/* ImageSelection-test.m: test that fills/strokes line up on the desired
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

@interface ImageSelectionTest : NSObject <GSTest>
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

static void AddLabel(NSString *text, NSRect frame, NSView *dest)
{
  NSTextField *labelView = [[NSTextField alloc] initWithFrame: frame];
  [labelView setStringValue: text];
  [labelView setEditable: NO];
  [labelView setSelectable: NO];
  [labelView setBezeled: NO];
  [labelView setFont: [NSFont labelFontOfSize: 10]];
  [dest addSubview: labelView];
  [labelView release];
}


@interface ImageSelectionTestView : NSView
{
  NSImage *test72DPIAnd288DPI;
  NSImage *testICNSIcon;
  NSImage *testTIFFIconWithAllImages72DPI;
  NSImageView *imageView;

  NSPopUpButton *classesPopUp;
  NSPopUpButton *scalingModesPopUp;
}

- (void) sliderH: (id)sender;
- (void) sliderV: (id)sender;
- (void) imageScaling: (id)sender;
- (void) imageClass: (id)sender;

@end

@implementation ImageSelectionTestView

static NSImage *ImageFromBundle(NSString *name, NSString *type)
{
  return [[[NSImage alloc] initWithContentsOfFile:
			[[NSBundle bundleForClass: [ImageSelectionTestView class]] pathForResource: name ofType: type]] autorelease];
}

- (id)initWithFrame: (NSRect)frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
    {
      test72DPIAnd288DPI = [ImageFromBundle(@"test72DPIAnd288DPI", @"tiff") retain];
      testICNSIcon = [ImageFromBundle(@"testICNSIcon", @"icns") retain];
      testTIFFIconWithAllImages72DPI = [ImageFromBundle(@"testTIFFIconWithAllImages72DPI", @"tiff") retain];

      {
	NSSlider *slider = [[[NSSlider alloc] initWithFrame: NSMakeRect(248, 200, 256, 16)] autorelease];
	[slider setMinValue: 8.0];
	[slider setMaxValue: 600.0];
	[slider setFloatValue: 48.0];
	[slider setTarget: self];
	[slider setAction: @selector(sliderH:)];
	[slider setContinuous: YES];
	[self addSubview: slider];
      }

      {
	NSSlider *sliderV = [[[NSSlider alloc] initWithFrame: NSMakeRect(228, 200, 16, 256)] autorelease];
	[sliderV setMinValue: 8.0];
	[sliderV setMaxValue: 600.0];
	[sliderV setFloatValue: 48.0];
	[sliderV setTarget: self];
	[sliderV setAction: @selector(sliderV:)];
	[sliderV setContinuous: YES];
	[self addSubview: sliderV];
      }

      {
	scalingModesPopUp = [[[NSPopUpButton alloc] initWithFrame: NSMakeRect (0, 200, 220, 32)] autorelease];
	[scalingModesPopUp addItemWithTitle: @"NSImageScaleProportionallyDown"];
	[[scalingModesPopUp lastItem] setTag: NSImageScaleProportionallyDown];
	[scalingModesPopUp addItemWithTitle: @"NSImageScaleAxesIndependently"];
	[[scalingModesPopUp lastItem] setTag: NSImageScaleAxesIndependently];
	[scalingModesPopUp addItemWithTitle: @"NSImageScaleNone"];
	[[scalingModesPopUp lastItem] setTag: NSImageScaleNone];
	[scalingModesPopUp addItemWithTitle: @"NSImageScaleProportionallyUpOrDown"];
	[[scalingModesPopUp lastItem] setTag: NSImageScaleProportionallyUpOrDown];

	[scalingModesPopUp setTarget: self];
	[scalingModesPopUp setAction: @selector(imageScaling:)];
	[self addSubview: scalingModesPopUp];
      }

      {
	classesPopUp = [[[NSPopUpButton alloc] initWithFrame: NSMakeRect (0, 240, 220, 32)] autorelease];
	[classesPopUp addItemWithTitle: @"NSButton"];
	[classesPopUp addItemWithTitle: @"NSImageView"];
	[classesPopUp setTarget: self];
	[classesPopUp setAction: @selector(imageClass:)];
	[self addSubview: classesPopUp];
      }

      [self imageClass: nil];
    }
  return self;
}

- (void) sliderH: (id)sender
{
  [[imageView superview] setNeedsDisplayInRect: [imageView frame]];
  [imageView setFrameSize: NSMakeSize([sender floatValue],
				      [imageView frame].size.height)];
  [[imageView superview] setNeedsDisplayInRect: [imageView frame]];
}

- (void) sliderV: (id)sender
{
  [[imageView superview] setNeedsDisplayInRect: [imageView frame]];
  [imageView setFrameSize: NSMakeSize([imageView frame].size.width,
				   [sender floatValue])];
  [[imageView superview] setNeedsDisplayInRect: [imageView frame]];
}

- (void) imageScaling: (id)sender
{
  if ([imageView isKindOfClass: [NSImageView class]])
    {
      [imageView setImageScaling: [[scalingModesPopUp selectedItem] tag]];
    }
}

- (void) imageClass: (id)sender
{
  Class c = Nil;
  NSRect frame;
  NSString *selected = [[classesPopUp selectedItem] title];

  if (imageView)
    {
      frame = [imageView frame];
      [imageView removeFromSuperview];
      imageView = nil;
    }
  else
    {
      frame = NSMakeRect(248, 224, 48, 48);
    }


  if ([selected isEqual: @"NSImageView"])
    {
      imageView = [[[NSImageView alloc] initWithFrame: frame] autorelease];
      [imageView setImage: testTIFFIconWithAllImages72DPI];
      [imageView setImageFrameStyle: NSImageFrameGrayBezel];
    }
  else if ([selected isEqual: @"NSButton"])
    {
      imageView = [[[NSButton alloc] initWithFrame: frame] autorelease];
      [imageView setImage: testTIFFIconWithAllImages72DPI];
    }

  if (imageView)
    {
      [self addSubview: imageView];
      [self imageScaling: nil];
    }
}

- (void) drawRect: (NSRect)dirty
{
  // Image tests

  [test72DPIAnd288DPI drawInRect: NSMakeRect(0,0,32,32)
			fromRect: NSZeroRect
		       operation: NSCompositeSourceOver
			fraction: 1.0f];

  [testICNSIcon drawInRect: NSMakeRect(64, 0, 16, 16)
		  fromRect: NSZeroRect
		 operation: NSCompositeSourceOver
		  fraction: 1.0f];

  [testTIFFIconWithAllImages72DPI drawInRect: NSMakeRect(128, 0, 32, 32)
				    fromRect: NSZeroRect
				   operation: NSCompositeSourceOver
				    fraction: 1.0f];

  [testTIFFIconWithAllImages72DPI drawInRect: NSMakeRect(192, 0, 48, 48)
				    fromRect: NSZeroRect
				   operation: NSCompositeSourceOver
				    fraction: 1.0f];


  // Test calling setSize: and drawAtPoint: works
  {
    NSImage *img = [testTIFFIconWithAllImages72DPI copy];
    [img setSize: NSMakeSize(24, 24)];
    [img drawAtPoint: NSMakePoint(0, 64)
	    fromRect: NSZeroRect
	   operation: NSCompositeSourceOver
	    fraction: 1.0];
    [[NSColor redColor] set];
    NSFrameRect(NSMakeRect(0,64,24,24));
    [img release];
  }

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
}
@end

@implementation ImageSelectionTest : NSObject

-(id) init
{
  NSView *content;
  content = [[ImageSelectionTestView alloc] initWithFrame: NSMakeRect(0,0,800,445)];

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
  [win setTitle: @"Image Selection Test"];
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
