/* Image-test.m: test that fills/strokes line up on the desired
   pixel boundaries.

   Copyright (C) 2011 Free Software Foundation, Inc.

   Author:  Eric Wasylishen <ewasylishen@gmail.com>
   Date: 2011
   
   This file is part of GNUstep.
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "../GSTestProtocol.h"

static NSImage *ImageFromBundle(NSString *name, NSString *type);

static void AddLabel(NSString *text, NSRect frame, NSView *dest)
{
  NSTextField *labelView = [[NSTextField alloc] initWithFrame: frame];
  [labelView setStringValue: text];
  [labelView setEditable: NO];
  [labelView setSelectable: NO];
  [labelView setBezeled: NO];
  [labelView setFont: [NSFont labelFontOfSize: 10]];
  [labelView setDrawsBackground: NO];
  [dest addSubview: labelView];
  [labelView release];
}

/**
 * Draws a crosshair centered on the rectangle NSMakeRect(point.x, point.y, 1, 1)
 */
static void DrawCrosshair(NSPoint point)
{
  [[NSGraphicsContext currentContext] saveGraphicsState];
  [[[NSColor redColor] colorWithAlphaComponent: 0.5] setFill];
  NSFrameRect(NSMakeRect(point.x + 1, point.y, 10, 1));
  NSFrameRect(NSMakeRect(point.x - 10, point.y, 10, 1));
  NSFrameRect(NSMakeRect(point.x, point.y + 1, 1, 10));
  NSFrameRect(NSMakeRect(point.x, point.y - 10, 1, 10));
  [[NSGraphicsContext currentContext] restoreGraphicsState];
}

static NSImage *ResizedIcon(NSImage *icon, int size, BOOL createBitmap)
{
  NSSize icnsize = [icon size];
  NSRect srcr = NSMakeRect(0, 0, icnsize.width, icnsize.height);
  float fact = (icnsize.width >= icnsize.height) ? (icnsize.width / size) : (icnsize.height / size);
  NSSize newsize = NSMakeSize(floor(icnsize.width / fact + 0.5), floor(icnsize.height / fact + 0.5));	
  NSRect dstr = NSMakeRect(0, 0, newsize.width, newsize.height);
  NSImage *newIcon = [[NSImage alloc] initWithSize: newsize];
  
  [newIcon lockFocus];

  [icon drawInRect: dstr 
          fromRect: srcr 
         operation: NSCompositeSourceOver 
          fraction: 1.0];

  // It should work with or without this block executing
  if (createBitmap)
    {
      NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect: dstr];
      [newIcon addRepresentation: rep];
      [rep release];
    }

  [newIcon unlockFocus];

  return [newIcon autorelease];  
}

@interface ImageTest : NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@interface VectorTestRep : NSImageRep
{
}

+ (NSImage*) testImage;

@end

@interface DrawingDelegate : NSObject
@end

@interface FlippedTestView : NSView
{
  NSImage *gsImage;
}
@end



@implementation FlippedTestView

- (id)initWithFrame: (NSRect)aFrame
{
  self = [super initWithFrame: aFrame];
  if (self)
    {
      AddLabel(@"(10, 10) This is a flipped view with an 80% bounds scale, 3 degrees rotation, and a translation", NSMakeRect(10,10,500,12), self);
      AddLabel(@"Composite image to (10, 80) (should be bigger and not rotated):", NSMakeRect(10,30,500,12), self);
      AddLabel(@"Draw image at (10, 100) (should be up-side down and rotated):", NSMakeRect(10,85,500,12), self);
      AddLabel(@"Draw image at (10, 155) using respectFlipped: YES (should be right-side-up and rotated):", NSMakeRect(10,140,500,12), self);
      gsImage = [ImageFromBundle(@"gs", @"png") retain];
    }
  return self;
}

- (void)dealloc
{
  [gsImage release];
  [super dealloc];
}

- (BOOL) isFlipped
{
  return YES;
}

- (void) drawRect: (NSRect)dirty
{
  [[[NSColor whiteColor] colorWithAlphaComponent: 0.2] setFill];
  [[NSBezierPath bezierPathWithRect: [self bounds]] fill];

  [gsImage compositeToPoint: NSMakePoint(10,80)
		   fromRect: NSZeroRect
		  operation: NSCompositeSourceOver
		   fraction: 1.0];
  DrawCrosshair(NSMakePoint(10, 80));

  [gsImage drawAtPoint: NSMakePoint(10,100)
	      fromRect: NSZeroRect
	     operation: NSCompositeSourceOver
	      fraction: 1.0];
  DrawCrosshair(NSMakePoint(10, 100));

  [gsImage drawInRect: NSMakeRect(10,155, [gsImage size].width, [gsImage size].height)
	     fromRect: NSZeroRect
	    operation: NSCompositeSourceOver
	     fraction: 1.0
       respectFlipped: YES
		hints: nil];
  DrawCrosshair(NSMakePoint(10, 155));
}

@end

@interface FlippedNinePartView : NSView
@end

@implementation FlippedNinePartView

- (BOOL) isFlipped
{
  return YES;
}

- (void) drawRect: (NSRect)dirty
{
  NSDrawNinePartImage(NSMakeRect(0, 0, 128, 64), 
		      ImageFromBundle(@"1", @"png"),
		      ImageFromBundle(@"2", @"png"),
		      ImageFromBundle(@"3", @"png"),
		      ImageFromBundle(@"4", @"png"),
		      ImageFromBundle(@"5", @"png"),
		      ImageFromBundle(@"6", @"png"),
		      ImageFromBundle(@"7", @"png"),
		      ImageFromBundle(@"8", @"png"),
		      ImageFromBundle(@"9", @"png"),
		      NSCompositeSourceOver,
		      1.0,
		      YES);

  NSDrawNinePartImage(NSMakeRect(0, 96, 24, 32), 
		      ImageFromBundle(@"1", @"png"),
		      ImageFromBundle(@"2", @"png"),
		      ImageFromBundle(@"3", @"png"),
		      ImageFromBundle(@"4", @"png"),
		      ImageFromBundle(@"5", @"png"),
		      ImageFromBundle(@"6", @"png"),
		      ImageFromBundle(@"7", @"png"),
		      ImageFromBundle(@"8", @"png"),
		      ImageFromBundle(@"9", @"png"),
		      NSCompositeSourceOver,
		      1.0,
		      YES);
}

@end


@interface ImageTestView : NSView
{
  NSImage *pdfexample, *svgexample;
}

@end

@implementation ImageTestView

static NSImage *ImageFromBundle(NSString *name, NSString *type)
{
  return [[[NSImage alloc] initWithContentsOfFile:
			[[NSBundle bundleForClass: [ImageTestView class]] pathForResource: name ofType: type]] autorelease];
}

- (id)initWithFrame: (NSRect)frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
    {
      NSView *flipped = [[FlippedTestView alloc] initWithFrame: NSMakeRect(10, 200, 400, 200)];
      [flipped setBounds: NSMakeRect(0, 0, 500, 250)];
      [flipped setBoundsRotation: 3.0];
      [flipped translateOriginToPoint: NSMakePoint(25, 0)];
      
      [self addSubview: flipped];
      [flipped release];

      pdfexample = [ImageFromBundle(@"pdfexample", @"pdf") retain];
      svgexample = [ImageFromBundle(@"svgexample", @"svg") retain];
      {
	NSView *flippedNinePartView = [[FlippedNinePartView alloc] initWithFrame: NSMakeRect(670, 128, 128, 128)];
	
	[self addSubview: flippedNinePartView];
	[flippedNinePartView release];

	AddLabel(@"Flipped NSDrawNinePartImage", NSMakeRect(670,260,128,30), self);
      }

      AddLabel(@"Clipped image at 20x. Should not have faded edge.", NSMakeRect(670,30,128,50), self);
    }
  return self;
}

- (void) dealloc
{
  [pdfexample release];
  [svgexample release];
  [super dealloc];
}

- (void) drawRect: (NSRect)dirty
{
  // Test drawing with a complex clip path
  {
    NSImage *img = ImageFromBundle(@"plasma", @"png");

    [[NSGraphicsContext currentContext] saveGraphicsState];

    // Set the clipping path to a 'g' character
    {
      NSFont *font = [NSFont fontWithName: @"Helvetica" size: 64.0];
      NSBezierPath *clip = [NSBezierPath bezierPath];
      [clip moveToPoint: NSMakePoint(68,68)];
      [clip appendBezierPathWithGlyph: [font glyphWithName: @"a"]
			       inFont: font];
      [clip addClip];
    }

    [img drawInRect: NSMakeRect(64,64,128,128)
	   fromRect: NSZeroRect
	  operation: NSCompositeSourceOver
	  fraction: 1.0];

    [[NSGraphicsContext currentContext] restoreGraphicsState];
  }

  // Test drawing sub-regions of an image
  {
    NSImage *img = ImageFromBundle(@"fourcorners", @"png");

    [img drawInRect: NSMakeRect(128,64,32,32)
	   fromRect: NSMakeRect(0,64,64,64)
	  operation: NSCompositeSourceOver
	  fraction: 1.0];

    [img drawAtPoint: NSMakePoint(192, 64)
	    fromRect: NSMakeRect(0,64,64,64)
	   operation: NSCompositeSourceOver
	    fraction: 1.0];

    [img compositeToPoint: NSMakePoint(128, 128)
		 fromRect: NSMakeRect(64,64,64,64)
		operation: NSCompositeSourceOver];
  }

  // Test that drawing a vector rep scales properly
  {
    NSImage *img = [VectorTestRep testImage];
    
    [img drawAtPoint: NSMakePoint(256, 0)
	   fromRect: NSZeroRect
	  operation: NSCompositeSourceOver
	  fraction: 1.0];

    [img drawInRect: NSMakeRect(300, 0, 100, 100)
	   fromRect: NSZeroRect
	  operation: NSCompositeSourceOver
	   fraction: 1.0];
  }

  // Test drawing into an NSBitmapImageRep
  {
    NSImage *img;
    NSBitmapImageRep *rep = [[[NSBitmapImageRep alloc] initWithBitmapDataPlanes: NULL
								    pixelsWide: 64
								    pixelsHigh: 64
								 bitsPerSample: 8
							       samplesPerPixel: 4
								      hasAlpha: YES
								      isPlanar: NO
								colorSpaceName: NSCalibratedRGBColorSpace
								  bitmapFormat: 0
								   bytesPerRow: 0
								  bitsPerPixel: 0] autorelease];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:
			 [NSGraphicsContext graphicsContextWithBitmapImageRep: rep]];
    [[NSColor purpleColor] setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0,0,64,64)] fill];
    [NSGraphicsContext restoreGraphicsState];
    
    
    img = [[[NSImage alloc] initWithSize: NSMakeSize(64,64)] autorelease];
    [img addRepresentation: rep];
    
    [img drawInRect: NSMakeRect(400, 0,64,64)
	   fromRect: NSZeroRect
	  operation: NSCompositeSourceOver
	   fraction: 0.5];
    
    [img drawInRect: NSMakeRect(432, 0,64,64)
	   fromRect: NSZeroRect
	  operation: NSCompositeSourceOver
	   fraction: 0.5];

    // Stroke around where the images should be drawn

    [[NSColor purpleColor] setStroke];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(400,0,64,64)] stroke];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(432,0,64,64)] stroke];
  }

  // Test PDF and SVG
  {
    [pdfexample drawAtPoint: NSMakePoint(400, 64)
		   fromRect: NSZeroRect
		  operation: NSCompositeSourceOver
		   fraction: 1.0];
    [svgexample drawAtPoint: NSMakePoint(464, 64)
		   fromRect: NSZeroRect
		  operation: NSCompositeSourceOver
		   fraction: 1.0];
  }

  // Test NSCustomImageRep
  {
    NSImage *img = [[NSImage alloc] init];

    id delegate = [[DrawingDelegate alloc] init];
    NSCustomImageRep *rep = [[NSCustomImageRep alloc] initWithDrawSelector: @selector(draw:)
								  delegate: delegate];
    [img addRepresentation: rep];
    [rep release];

    // NOTE: We'll test with the rep size (0, 0); it should still work.

    [img setSize: NSMakeSize(64, 64)];

    [img drawAtPoint: NSMakePoint(532, 0)
	    fromRect: NSZeroRect
	   operation: NSCompositeSourceOver
	    fraction: 1.0];

    [delegate release];
    [img release];
  }

  // Test NSDrawNinePartImage
  {
    NSDrawNinePartImage(NSMakeRect(532, 192, 128, 64), 
                       ImageFromBundle(@"1", @"png"),
                       ImageFromBundle(@"2", @"png"),
                       ImageFromBundle(@"3", @"png"),
                       ImageFromBundle(@"4", @"png"),
                       ImageFromBundle(@"5", @"png"),
                       ImageFromBundle(@"6", @"png"),
                       ImageFromBundle(@"7", @"png"),
                       ImageFromBundle(@"8", @"png"),
                       ImageFromBundle(@"9", @"png"),
                       NSCompositeSourceOver,
                       1.0,
                       NO);
   NSDrawNinePartImage(NSMakeRect(532, 128, 24, 32), 
                       ImageFromBundle(@"1", @"png"),
                       ImageFromBundle(@"2", @"png"),
                       ImageFromBundle(@"3", @"png"),
                       ImageFromBundle(@"4", @"png"),
                       ImageFromBundle(@"5", @"png"),
                       ImageFromBundle(@"6", @"png"),
                       ImageFromBundle(@"7", @"png"),
                       ImageFromBundle(@"8", @"png"),
                       ImageFromBundle(@"9", @"png"),
                       NSCompositeSourceOver,
                       1.0,
                       NO);
  }

  // Test drawing a single pixel of an image scaled up 20x.
  // It should have not fade out towards the edge of the image.
  {
    [NSGraphicsContext saveGraphicsState];
    NSRectClip(NSMakeRect(670,5,20,20));
    [ImageFromBundle(@"1", @"png") drawInRect: NSMakeRect(670,5,300,400)
				     fromRect: NSZeroRect
				    operation: NSCompositeSourceOver
				     fraction: 1.0
			       respectFlipped: YES
					hints: nil];
    [NSGraphicsContext restoreGraphicsState];
  }

  // Test using lockFocus and drawing an image into an image
  {
    NSImage *test = [NSImage imageNamed: @"common_Unknown"];
    NSImage *testWithCreateBitmap, *testWithoutCreateBitmap;
    [test compositeToPoint: NSMakePoint(800,0)
		 operation: NSCompositeSourceOver];

    // These should behve the same
    testWithCreateBitmap = ResizedIcon(test, 16, YES);
    testWithoutCreateBitmap = ResizedIcon(test, 16, NO);

    [testWithCreateBitmap compositeToPoint: NSMakePoint(864, 0)
				 operation: NSCompositeSourceOver];

    [testWithoutCreateBitmap compositeToPoint: NSMakePoint(864, 32)
				    operation: NSCompositeSourceOver];
  }
}
@end

@implementation ImageTest : NSObject

-(id) init
{
  NSView *content;
  content = [[ImageTestView alloc] initWithFrame: NSMakeRect(0,0,900,445)];

  // Create the window
  win = [[NSWindow alloc] initWithContentRect: [content frame]
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];
  [win setContentView: content];
  [win setMinSize: [win frame].size];
  [win setTitle: @"Image Test"];
  [self restart];
  return self;
}

-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: [win title]
				     filename: NO];
}

- (void) dealloc
{
  RELEASE (win);
  [super dealloc];
}

@end

@implementation VectorTestRep

- (id)init
{
  [self setSize: NSMakeSize(32, 32)];
  [self setAlpha: YES];
  [self setOpaque: NO];
  [self setBitsPerSample: NSImageRepMatchesDevice];
  [self setPixelsWide: NSImageRepMatchesDevice];
  [self setPixelsHigh: NSImageRepMatchesDevice];
  return self;
}

- (BOOL)draw
{
  [[[NSColor blueColor] colorWithAlphaComponent: 0.5] set];
  [NSBezierPath setDefaultLineWidth: 2.0];
  [NSBezierPath strokeRect: NSMakeRect(1, 1, 28, 28)];
  
  [[[NSColor redColor] colorWithAlphaComponent: 0.5] set];
  [NSBezierPath setDefaultLineWidth: 1.0];
  [[NSBezierPath bezierPathWithOvalInRect: NSMakeRect(2,2,26,26)] stroke];
  
  [@"Vector Rep" drawInRect: NSMakeRect(2,2,26,26)
	     withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSFont userFontOfSize: 8], NSFontAttributeName,
					   nil]];
  
  return YES;
}

+ (NSImage *)testImage
{
  NSImage *img = [[[NSImage alloc] initWithSize: NSMakeSize(32, 32)] autorelease];
  [img addRepresentation: [[[self alloc] init] autorelease]];
  return img;
}

@end


/**
 * A delegate to use with NSCustomImageRep.
 */
@implementation DrawingDelegate

- (void) draw: (NSCustomImageRep*)rep
{
  [[[NSColor magentaColor] colorWithAlphaComponent: 0.5] set];
  [NSBezierPath setDefaultLineWidth: 2.0];
  [NSBezierPath strokeRect: NSMakeRect(1, 1, 60, 60)];
  
  [[[NSColor blueColor] colorWithAlphaComponent: 0.5] set];
  [NSBezierPath setDefaultLineWidth: 1.0];
  [[NSBezierPath bezierPathWithOvalInRect: NSMakeRect(2,2,58,58)] stroke];
  
  [@"Custom Rep" drawInRect: NSMakeRect(2,2,58,58)
	     withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
						 [NSFont userFontOfSize: 10], NSFontAttributeName,
					   nil]];

  [@"CLIPPED" drawInRect: NSMakeRect(2,2,400,30)
	  withAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
					      [NSFont userFontOfSize: 24], NSFontAttributeName,
					nil]];
}

@end
