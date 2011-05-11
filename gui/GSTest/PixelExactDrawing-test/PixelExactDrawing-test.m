/* PixelExactDrawing-test.m: test that fills/strokes line up on the desired
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

@interface PixelExactDrawingTest : NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

/**
 * Creates a 72dpi w by h red and white checkerboard 
 */
static NSImage *CheckerboardImage(NSInteger w, NSInteger h)
{
	NSImage *img;
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes: NULL
									pixelsWide: w
									pixelsHigh: h
								     bitsPerSample: 8
								   samplesPerPixel: 4
									  hasAlpha: YES
									  isPlanar: NO
								    colorSpaceName: NSDeviceRGBColorSpace
								       bytesPerRow: 0
								      bitsPerPixel: 0];
	
	NSInteger x, y;
	for (x=0; x<w; x++)
	{
		for (y=0; y<h; y++)
		{
			[rep setColor: (((x + y) % 2) == 0) ? [NSColor whiteColor] : [NSColor redColor]
				  atX: x
				    y: y];
		}
	}
	
	img = [[NSImage alloc] initWithSize: NSMakeSize(w, h)];
	[img addRepresentation: rep];
	[rep release];
	
	return [img autorelease];
}

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

/**
 * Draws a crosshair centered on the rectangle NSMakeRect(point.x, point.y, 1, 1)
 */
static void DrawCrosshair(NSPoint point)
{
  [[NSGraphicsContext currentContext] saveGraphicsState];
  [[NSColor grayColor] setFill];
  NSFrameRect(NSMakeRect(point.x + 1, point.y, 10, 1));
  NSFrameRect(NSMakeRect(point.x - 10, point.y, 10, 1));
  NSFrameRect(NSMakeRect(point.x, point.y + 1, 1, 10));
  NSFrameRect(NSMakeRect(point.x, point.y - 10, 1, 10));
  [[NSGraphicsContext currentContext] restoreGraphicsState];
}

@interface PixelExactDrawingTestView : NSView
{
  NSImageView *expected1view, *expected2view;
}
@end

@implementation PixelExactDrawingTestView

- (id)initWithFrame: (NSRect)frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
    {
      NSImage *checkerboard = CheckerboardImage(10, 10);      
      NSImage *expected1, *expected2;
      NSImageView *iv1, *iv2;
      NSButton *b1, *b2;

      // Radio button

      {
	NSButtonCell *prototype;
	NSMatrix *matrix;

	prototype = [[[NSButtonCell alloc] init] autorelease];
	[prototype setButtonType:NSRadioButton];
	matrix = [[[NSMatrix alloc] initWithFrame: NSMakeRect(0, 360, 150, 25)
					     mode: NSRadioModeMatrix
					prototype: prototype
				     numberOfRows: 1
				  numberOfColumns: 2] autorelease];
	[self addSubview: matrix];
	[[[matrix cells] objectAtIndex:0] setTitle:@"Actual"];
	[[[matrix cells] objectAtIndex:1] setTitle:@"Expected"];
	[matrix setTarget: self];
	[matrix setAction: @selector(chooseViewMode:)];
      }

      // Image tests

      AddLabel(@"-[NSImage compositeToPoint:operation:] at (10,10)", NSMakeRect(30,5,350,15), self);
      AddLabel(@"-[NSImage compositeToPoint:operation:] at (10.5,40.5)", NSMakeRect(30,35,350,15), self);
      AddLabel(@"-[NSImage drawAtPoint:fromRect::operation:fraction:] at (10,70)", NSMakeRect(30,65,350,15), self);
      AddLabel(@"-[NSImage drawAtPoint:fromRect:operation:fraction:] at (10.5,100.5)", NSMakeRect(30,95,350,15), self);
      AddLabel(@"NSImageView at (10,130)", NSMakeRect(30,125,350,15), self);
      AddLabel(@"NSImageView at (10.5,160.5)", NSMakeRect(30,155,350,15), self);
      AddLabel(@"NSButton at (10,190)", NSMakeRect(30,185,350,15), self);
      AddLabel(@"NSButton at (10.5,220.5)", NSMakeRect(30,215,350,15), self);
      AddLabel(@"NSCopyBits from (10, 239, 10, 10) to (10, 250)", NSMakeRect(30,245,350,15), self);
      AddLabel(@"NSCopyBits from (10, 269, 10, 10) to (10.5, 280.5)", NSMakeRect(30,275,350,15), self);
      AddLabel(@"NSCopyBits from (10.5, 299.5, 9.5, 9.5) to (10, 310)", NSMakeRect(30,305,350,15), self);
      AddLabel(@"NSCopyBits from (10.5, 329.5, 9.5, 9.5) to (10.5, 340.5)", NSMakeRect(30,335,350,15), self);

      iv1 = [[[NSImageView alloc] initWithFrame: NSMakeRect(10,130,10,10)] autorelease];
      [iv1 setImage: checkerboard];
      [self addSubview: iv1];

      iv2 = [[[NSImageView alloc] initWithFrame: NSMakeRect(10.5,160.5,10,10)] autorelease];
      [iv2 setImage: checkerboard];
      [self addSubview: iv2];

      b1 = [[[NSButton alloc] initWithFrame: NSMakeRect(10, 190, 18, 18)] autorelease];
      [b1 setImage: checkerboard];
      [self addSubview: b1];

      b2 = [[[NSButton alloc] initWithFrame: NSMakeRect(10.5, 220.5, 18, 18)] autorelease];
      [b2 setImage: checkerboard];
      [self addSubview: b2];

      // Fill and stroke tests

      AddLabel(@"NSRectFill at (410,10) size (10,10)", NSMakeRect(430,5,400,15), self);
      AddLabel(@"NSRectFill at (410.5,40.5) size (10,10)", NSMakeRect(430,35,400,15), self);
      AddLabel(@"NSDrawButton at (410,70) size (10,10)", NSMakeRect(430,65,400,15), self);
      AddLabel(@"NSDrawButton at (410.5,100.5) size (10,10)", NSMakeRect(430,95,400,15), self);
      AddLabel(@"+[NSBezierPath fillRect:] at (410,130) size (10, 10)", NSMakeRect(430,125,400,15), self);
      AddLabel(@"+[NSBezierPath fillRect:] at (410.5,160.5) size (10, 10)", NSMakeRect(430,155,400,15), self);
      AddLabel(@"NSDottedFrameRect at (410, 190) size (10, 10)", NSMakeRect(430,185,400,15), self);
      AddLabel(@"NSDottedFrameRect at (410.5, 220.5) size (10, 10)", NSMakeRect(430,215,400,15), self);
      AddLabel(@"+[NSBezierPath strokeRect:] at (410, 250) size (10, 10)", NSMakeRect(430,245,400,15), self);
      AddLabel(@"+[NSBezierPath strokeRect:] at (410.5, 280.5) size (10, 10)", NSMakeRect(430,275,400,15), self);
      AddLabel(@"NSRectClip at (410, 310) size (10, 10)", NSMakeRect(430,305,400,15), self);
      AddLabel(@"NSRectClip at (410.5, 340.5) size (10, 10)", NSMakeRect(430,335,400,15), self);

      // Expected
      expected1 = [[[NSImage alloc] initWithContentsOfFile:
				 [[NSBundle bundleForClass: [self class]] pathForResource: @"pixelExact1" ofType: @"tiff"]] autorelease];
      expected2 = [[[NSImage alloc] initWithContentsOfFile:
				 [[NSBundle bundleForClass: [self class]] pathForResource: @"pixelExact2" ofType: @"tiff"]] autorelease];
      expected1view = [[[NSImageView alloc] initWithFrame: NSMakeRect(0, 0, [expected1 size].width, [expected1 size].height)] autorelease];
      [expected1view setImage: expected1];
      expected2view = [[[NSImageView alloc] initWithFrame: NSMakeRect(399, 0, [expected2 size].width, [expected2 size].height)] autorelease];
      [expected2view setImage: expected2];
      [expected1view setHidden: YES];
      [expected2view setHidden: YES];
      [self addSubview: expected1view];
      [self addSubview: expected2view];
    }
  return self;
}

- (void) chooseViewMode: (id)sender
{
  NSMatrix *matrix = (NSMatrix*)sender;
  BOOL actual = ([matrix selectedColumn] == 0);
  [expected1view setHidden: actual];
  [expected2view setHidden: actual];
}

- (void) drawRect: (NSRect)dirty
{
  NSImage *checkerboard = CheckerboardImage(10, 10);

  // Image tests

  DrawCrosshair(NSMakePoint(9,9));
  [checkerboard compositeToPoint: NSMakePoint(10, 10)
		       operation: NSCompositeSourceOver];

  DrawCrosshair(NSMakePoint(9,39));
  [checkerboard compositeToPoint: NSMakePoint(10.5, 40.5)
		       operation: NSCompositeSourceOver];

  DrawCrosshair(NSMakePoint(9,69));
  [checkerboard drawAtPoint: NSMakePoint(10, 70)
		   fromRect: NSZeroRect
		  operation: NSCompositeSourceOver
		   fraction: 1.0];

  DrawCrosshair(NSMakePoint(9,99));
  [checkerboard drawAtPoint: NSMakePoint(10.5, 100.5)
		   fromRect: NSZeroRect
		  operation: NSCompositeSourceOver
		   fraction: 1.0];

  DrawCrosshair(NSMakePoint(9,129));
  DrawCrosshair(NSMakePoint(9,159));
  DrawCrosshair(NSMakePoint(9,189));
  DrawCrosshair(NSMakePoint(9,219));
  
  DrawCrosshair(NSMakePoint(9,249));
  [checkerboard compositeToPoint: NSMakePoint(10, 239)
		       operation: NSCompositeSourceOver];
  NSCopyBits(0, NSMakeRect(10, 239, 10, 10), NSMakePoint(10, 250));
  
  DrawCrosshair(NSMakePoint(9,279));
  [checkerboard compositeToPoint: NSMakePoint(10, 269)
		       operation: NSCompositeSourceOver];
  NSCopyBits(0, NSMakeRect(10, 269, 10, 10), NSMakePoint(10.5, 280.5));

  DrawCrosshair(NSMakePoint(9,309));
  [checkerboard compositeToPoint: NSMakePoint(10, 299)
		       operation: NSCompositeSourceOver];
  NSCopyBits(0, NSMakeRect(10.5, 299.5, 9.5, 9.5), NSMakePoint(10, 310));

  DrawCrosshair(NSMakePoint(9,339));
  [checkerboard compositeToPoint: NSMakePoint(10, 329)
		       operation: NSCompositeSourceOver];
  NSCopyBits(0, NSMakeRect(10.5, 329.5, 9.5, 9.5), NSMakePoint(10.5, 340.5));

  // Fill tests

  [[NSColor blueColor] setFill];
  [[NSColor redColor] setStroke];
  DrawCrosshair(NSMakePoint(409,9));
  NSRectFill(NSMakeRect(410,10,10,10));

  DrawCrosshair(NSMakePoint(409,39));
  NSRectFill(NSMakeRect(410.5,40.5,10,10));

  DrawCrosshair(NSMakePoint(409,69));
  NSDrawButton(NSMakeRect(410,70,10,10), NSMakeRect(410,70,10,10));

  DrawCrosshair(NSMakePoint(409,99));
  NSDrawButton(NSMakeRect(410.5,100.5,10,10), NSMakeRect(410.5,100.5,10,10));

  DrawCrosshair(NSMakePoint(409,129));
  [NSBezierPath fillRect: NSMakeRect(410,130,10,10)];

  DrawCrosshair(NSMakePoint(409,159));
  [NSBezierPath fillRect: NSMakeRect(410.5,160.5,10,10)];

  DrawCrosshair(NSMakePoint(409,189));
  NSDottedFrameRect(NSMakeRect(410, 190, 10, 10));

  DrawCrosshair(NSMakePoint(409,219));
  NSDottedFrameRect(NSMakeRect(410.5, 220.5, 10, 10));

  DrawCrosshair(NSMakePoint(409,249));
  [NSBezierPath strokeRect: NSMakeRect(410, 250, 10, 10)];

  DrawCrosshair(NSMakePoint(409,279));
  [NSBezierPath strokeRect: NSMakeRect(410.5, 280.5, 10, 10)];

  DrawCrosshair(NSMakePoint(409,309));
  [[NSGraphicsContext currentContext] saveGraphicsState];
  NSRectClip(NSMakeRect(410, 310, 10, 10));
  NSRectFill(NSMakeRect(0, 0, 1000, 1000));
  [[NSGraphicsContext currentContext] restoreGraphicsState];
  
  DrawCrosshair(NSMakePoint(409,339));
  [[NSGraphicsContext currentContext] saveGraphicsState];
  NSRectClip(NSMakeRect(410.5, 340.5, 10, 10));
  NSRectFill(NSMakeRect(0, 0, 1000, 1000));
  [[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end


@implementation PixelExactDrawingTest : NSObject

-(id) init
{
  NSView *content;
  content = [[PixelExactDrawingTestView alloc] initWithFrame: NSMakeRect(0,0,800,385)];

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
  [win setBackgroundColor: [NSColor whiteColor]];
  [win setTitle: @"Pixel-Exact Drawing Test"];

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

