
#import "FractalWindow.h"

static int counter = 1;

static NSString *typestrs[] = 
{ @"z^2+c", @"z^3+c", @"z^4+z+c", 
  @"c z (1-z)", @"((z^2+c-1)/(2*z+c-2))^2" };

static NSString *schemestrs[] = 
{ @"Monochrome", @"Gray16", @"RGB8", @"RGB27" };

@implementation FractalWindow

+ (NSString *) typeToString:(FTYPE)ft
{
  return typestrs[ft];
}

+ (NSString *) schemeToString:(CSCHEME)cs
{
  return schemestrs[cs];
}

- (id)initWithType:(FTYPE)ft
{
  if ((self = [super init]) != nil)
    {
      NSRect frame;
      int m = (NSTitledWindowMask |  NSClosableWindowMask | 
	       NSMiniaturizableWindowMask);

      view  = [[FractalView alloc] initWithType:ft];
      frame = [NSWindow frameRectForContentRect:[view frame] 
			styleMask:m];
      
      window = [[NSWindow alloc] initWithContentRect:frame 
				 styleMask:m			       
                                   backing: NSBackingStoreRetained 
				 defer:YES];
      [window setMinSize:frame.size];
      [window 
	setTitle:[[NSString alloc]
		   initWithFormat:@"#%u(%@)" 
		   locale: nil, counter++, 
		   [FractalWindow typeToString:ft]]];
      [window setReleasedWhenClosed:NO];
      [window setDelegate:self];

      [window setFrame:frame display:YES];
      [window setMaxSize:frame.size];
      [window setContentView:view];
      [window setReleasedWhenClosed:YES];
      
      // RELEASE(view);

      [window center];
      [window orderFrontRegardless];
      [window makeKeyWindow];
      [window display];
    }
  return self;
}

- (void)dealloc
{
  RELEASE(window);
  [super dealloc];
}

- (id)delegate
{
  return delegate;
}

- (void)setDelegate:(id)aDelegate
{
  delegate = aDelegate;
}

- (id)window
{
  return window;
}

-(void)saveAs:(id)sender
{
  NSSavePanel *savePanel;
  int result;
  NSString *fname, *msg;

  savePanel = [NSSavePanel savePanel];
  [savePanel setRequiredFileType:@"tiff"];
  result = [savePanel runModal];
  
  if (result == NSOKButton)
    {
      fname = [savePanel filename];
      if ([view writeTIFF:fname] == NO)
	{
	  msg = [[NSString alloc]
		  initWithFormat:@"Couldn't write %@" 
		  locale: nil, fname];
	  NSRunAlertPanel(@"Alert", msg, @"Ok", nil, nil);
	}
    }
  
  [[NSCursor arrowCursor] set];
}

-(void)resolution:(id)sender
{
  int tag = [sender tag];
  NSRect frame;
  
  if (tag == [view resolution])
    {
      return;
    }
  
  [window setContentView:nil];
  
  [view setResolution:tag];
  frame = [NSWindow frameRectForContentRect:[view frame] 
		    styleMask:[window styleMask]];
  frame.origin = [window frame].origin;
  
  [window setMinSize:frame.size];
  [window setMaxSize:frame.size];
  
  [window setFrame:frame display:NO];
  [window setContentView:view];
}

-(void)colorScheme:(id)sender
{
  int tag = [sender tag];
  
  if (tag == [view colorScheme])
    {
      return;
    }
  
  [view setColorScheme:tag];
}

-(void)zoomOp:(id)sender
{
  [view zoomOp:[sender tag]];
}

@end

















