
#import "FractalView.h"

#define _FRACTALVIEW_DEBUG 1

static double defaultregs[] =
{ -1.5, 0.5, -1, 1,
  -1.5, 1.5, -1.5, 1.5,
  -2, 2, -2, 2,
  -2.5, 4.5, -4, 4,
  -1, 3, -2, 2
};

static double escape[] =
{ 4,
  4,
  4,
  4,
  100,
};

static int maxiter[] =
{ 256,
  256,
  256,
  256,
  256
};

static id cschemes[] =
{
    nil, nil, nil, nil
};

@implementation FractalView

+ (id)getColorsForScheme:(CSCHEME)cs
{
  id scheme, col;
  int r, g, b, divs, total, pos;
  float rfl, gfl, bfl;
  
  if (cschemes[cs] == nil)
    {
      switch (cs)
	{
	case MONOCHROME:
	case GRAY16:
	  divs = (cs==MONOCHROME ? 2 : 16);
	  scheme = [NSMutableArray arrayWithCapacity:divs];
	  for (g = 0; g < divs; g++)
	    {
	      gfl = (float)g/(float)(divs - 1);
	      col = [NSColor colorWithDeviceRed:gfl
			     green:gfl
			     blue:gfl
			     alpha:1.0];
	      [scheme insertObject:col atIndex:g];
	    }
	  break;
	case RGB8:
	case RGB27:
	  divs = (cs==RGB8 ? 2 : 3);
	  total = divs*divs*divs;
	  scheme = [NSMutableArray arrayWithCapacity:total];
	  pos = 0;
	  for (r = 0; r < divs; r++)
	    {
	      for (g = 0; g < divs; g++)
		{
		  for (b = 0; b < divs; b++)
		    {
		      rfl = (float)r/(float)(divs-1);
		      gfl = (float)g/(float)(divs-1);
		      bfl = (float)b/(float)(divs-1);
		      col = [NSColor colorWithDeviceRed:rfl
				     green:gfl
				     blue:bfl
				     alpha:1.0];
		      [scheme insertObject:col atIndex:pos++];
		    }
		}
	    }
	  break;
        }
      
      [scheme retain];
      cschemes[cs] = scheme;
    }
  
  return cschemes[cs];
}


- (id)initWithType:(FTYPE)ft
{
  return [self initWithType:ft 
	       resolution:DEFAULT_RES
	       cscheme:DEFAULT_SCHEME
	       region:(defaultregs+4*ft)];
}

- (id)initWithType:(FTYPE)ft 
        resolution:(int)rval
           cscheme:(CSCHEME)cs
            region:(double *)reg
{
  NSRect iframe = {{0, 0}, {rval, rval}};
  [super initWithFrame:iframe];
  
  ftype = ft;
  res = rval;
  cscheme = cs;
  
  minre = reg[0];
  maxre = reg[1];
  minim = reg[2];
  maxim = reg[3];

  image = [[NSImage alloc] initWithSize:iframe.size];
  rep = [[NSBitmapImageRep alloc]
	  initWithBitmapDataPlanes:NULL
	  pixelsWide:res 
	  pixelsHigh:res 
	  bitsPerSample:8
	  samplesPerPixel:3
	  hasAlpha:NO
	  isPlanar:NO
	  colorSpaceName:NSDeviceRGBColorSpace
	  bytesPerRow:res*3
	  bitsPerPixel:24];
  [image addRepresentation:rep];
  
  [self update];
  [self setNeedsDisplay:YES];
  
  return self;
}

- (id)setResolution:(int)rval
{
  NSSize size={ rval, rval };
  
  [super setFrameSize:size];
  res = rval;
  
  [image removeRepresentation:rep];
  [rep dealloc];
  [image dealloc];
  
  image = [[NSImage alloc] initWithSize:size];
  rep = [[NSBitmapImageRep alloc]
	  initWithBitmapDataPlanes:NULL
	  pixelsWide:res 
	  pixelsHigh:res 
	  bitsPerSample:8
	  samplesPerPixel:3
	  hasAlpha:NO
	  isPlanar:NO
	  colorSpaceName:NSDeviceRGBColorSpace
	  bytesPerRow:res*3
	  bitsPerPixel:24];
  [image addRepresentation:rep];
  
  [self update];
  [self setNeedsDisplay:YES];
  
  return self;
}

- (int)resolution
{
  return res;
}

- (id)setColorScheme:(CSCHEME)cs
{
  cscheme = cs;
  
  [self update];
  [self setNeedsDisplay:YES];
  
  return self;
}

- (CSCHEME)colorScheme
{
  return cscheme;
}

- (id)zoomOp:(ZOOMOP)op
{
  double *reg = defaultregs+4*ftype;
  double midre, midim, deltare, deltaim;
  
  deltare = maxre - minre;
  deltaim = maxim - minim;
  
  midre = (minre + maxre)/(double)2;
  midim = (minim + maxim)/(double)2;
  
  switch(op)
    {
    case ZOOM_IN:
    case ZOOM_OUT:
      if(op == ZOOM_IN)
	{
	  deltare /= (double)4;
	  deltaim /= (double)4;
	}
      
      minre = midre - deltare;
      maxre = midre + deltare;
      minim = midim - deltaim;
      maxim = midim + deltaim;
      break;
    case ZOOM_RESTORE:
      minre = reg[0];
      maxre = reg[1];
      minim = reg[2];
      maxim = reg[3];
      break;
    }
  
  [self update];
  [self setNeedsDisplay:YES];
  
  return self;
}


- (void)update
{
  double redelta, imdelta;
  double recur, imcur;
  int rept, impt;
  double zzbar, esc;
  
  float colr, colg, colb;
  
  id colors, color;
  int count, maxit, cols;
  __complex__ double z, c, acc;
  
  unsigned char *base, *data = [rep bitmapData];
  
  colors = [FractalView getColorsForScheme:cscheme];
  cols = [colors count];
  
  redelta = (maxre - minre)/(double)res;
  imdelta = (maxim - minim)/(double)res;
  esc = escape[ftype];
  maxit = maxiter[ftype];
  
  [image lockFocus];
  
  for (recur = minre, rept = 0; rept < res; recur += redelta, rept++)
    {
      for (imcur = minim, impt=0; impt < res; imcur += imdelta, impt++)
	{
	  c = recur + imcur*1i;
	  z = (ftype==ZLAMBDA ? 0.5 : 0);
	  count = 0;
	  
	  do {
	    zzbar = 
	      (__real__ z)*(__real__ z)+
	      (__imag__ z)*(__imag__ z);
	    switch(ftype){
	    case ZSQUARED:
	      z = z*z + c;
	      break;
	    case ZCUBED:
	      z = z*z*z + c;
	      break;
	    case ZSQSQPLUSZ:
	      z = z*z*z*z + z + c;
	      break;
	    case ZLAMBDA:
	      z = c*z*(1-z);
	      break;
	    case ZMAGNET:
	      acc = (z*z+c-1)/(2*z+c-2);
	      z = acc*acc;
	    }
	    count++;
	  } while(count < maxit && zzbar < esc);
	  
	  color = [colors objectAtIndex:((maxit - count)%cols)];
	  [color getRed:&colr green:&colg blue:&colb alpha:NULL];
	  
	  base = data + (res - 1 - impt)*res*3 + rept*3;
	  base[0] = (int)(colr*255);
	  base[1] = (int)(colg*255);
	  base[2] = (int)(colb*255);
	  
	  [color set];
	  PSrectfill(rept, impt, 1, 1);
	}
    }
  
  [image unlockFocus];
  
#ifdef _FRACTALVIEW_DEBUG
    {
      static int starter = 1;
      Class todebug[] = { 
	[NSWindow class],
	[FractalView class],
	[NSImage class], 
	[NSBitmapImageRep class],
	[NSCachedImageRep class],
	nil
      }, *current;
      
      if (starter)
	{
	  GSDebugAllocationActive(YES);
	  starter = 0;
	}
      
      current=todebug;
      while (*current!=nil)
	{
	  id cl = *current;
	  NSLog(@"%@ count %u total %u peak %u\n",
		NSStringFromClass(cl),
		GSDebugAllocationCount(cl),
		GSDebugAllocationTotal(cl),
		GSDebugAllocationPeak(cl));
	  current++;
	}
    }
#endif

}

- (void)drawRect:(NSRect)aRect
{
  [image compositeToPoint:aRect.origin 
	 fromRect:aRect 
	 operation:NSCompositeCopy];
}

#define PAD 5

- (void)mouseDown:(NSEvent *)theEvent
{
  NSPoint startp, curp;
  NSEvent *curEvent = theEvent;
  
  float dx, dy, prevr = 0, r;
  NSRect update;
  
  double deltare, deltaim, 
    newminre, newmaxre, newminim, newmaxim;
  
  startp = [curEvent locationInWindow];
  startp = [self convertPoint:startp fromView: nil];
  
  do 
    {
      curp = [curEvent locationInWindow];
      curp = [self convertPoint:curp fromView: nil];
      
      dx = curp.x - startp.x;
      dy = curp.y - startp.y;
      
      if (dx < 0)
	{
	  dx = -dx;
        }
      if (dy < 0)
	{
	  dy = -dy;
        }
      
      r = (dx<dy ? dx : dy);

      [self lockFocus];
      
      if(prevr)
	{
	  update = NSMakeRect(startp.x - prevr - PAD, 
			      startp.y - prevr - PAD,
			      2*(prevr + PAD), 
			      2*(prevr + PAD));
	  update = NSIntersectionRect(update, [self frame]);
	  
	  [image compositeToPoint:update.origin 
		 fromRect:update
		 operation:NSCompositeCopy];
        }
      
      PSsetgray(0.0);
      PSarc(startp.x, startp.y, r, 0, 360);
      PSstroke();
      PSsetgray(1.0);
      PSarc(startp.x, startp.y, r+1, 0, 360);
      PSstroke();
      
      [self unlockFocus];
      [[self window] flushWindow];
      
      prevr = r;
      
      curEvent = 
	[[self window] 
	  nextEventMatchingMask: 
	    NSLeftMouseUpMask | NSLeftMouseDraggedMask];
    } while([curEvent type] != NSLeftMouseUp);


  deltare = maxre - minre;
  deltaim = maxim - minim;
  newminre = deltare*(double)(startp.x - r)/(double)res + minre;
  newmaxre = deltare*(double)(startp.x + r)/(double)res + minre;
  newminim = deltaim*(double)(startp.y - r)/(double)res + minim;
  newmaxim = deltaim*(double)(startp.y + r)/(double)res + minim;
    
  minre = newminre;
  maxre = newmaxre;
  minim = newminim;
  maxim = newmaxim;

  [self update];
  [self setNeedsDisplay:YES];
}


- (BOOL)writeTIFF:(NSString *)name
{
  NSData *data;
  BOOL result;
  NSRect rect = [self frame];
  
  data = 
    [rep TIFFRepresentationUsingCompression:
	   NSTIFFCompressionPackBits
	 factor:0.5];
  
  result = [data writeToFile:name atomically:YES];
  return result;
}

- (void)dealloc
{
  [image dealloc];
  [super dealloc];
}

@end


