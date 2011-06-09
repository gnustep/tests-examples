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
}
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
    }
  return self;
}

- (void) drawRect: (NSRect)dirty
{
  [[NSColor whiteColor] set];
  NSRectFill([self bounds]);

  // Image tests

  [test72DPIAnd288DPI compositeToPoint: NSMakePoint(0, 0)
		       operation: NSCompositeSourceOver];

  [testICNSIcon compositeToPoint: NSMakePoint(128, 0)
		       operation: NSCompositeSourceOver];

  [testTIFFIconWithAllImages72DPI compositeToPoint: NSMakePoint(256, 0)
					 operation: NSCompositeSourceOver];

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

