/* 
   TestView.h

   Simple subclass of NSView.

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: June 1996
   
   This file is part of the GNUstep GUI X/RAW Backend.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; see the file COPYING.LIB.
   If not, write to the Free Software Foundation,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/ 

#import <AppKit/AppKit.h>
#include "TestView.h"
#include <config.h>

extern void XRlineto(float x, float y);
extern void XRmoveto(float x, float y);
extern void XRshow(const char *str);

@implementation TestView

// Class methods

// Instance methods
- (BOOL)isFlipped
{
  return NO;
}

- (void)drawRect:(NSRect)rect
{
  NSFont *f;
  float width, height;
  NSColor *c = [NSColor greenColor];
  NSColor *blue = [NSColor blueColor];
  NSColor *y = [NSColor yellowColor];
  NSColor *mg = [NSColor magentaColor];
  NSColor *orange = [NSColor orangeColor];

  NSDebugLog(@"Painting TestView %f %f %f %f\n", bounds.origin.x,
	     bounds.origin.y,
	     bounds.size.width, bounds.size.height);

  [orange set];
  NSRectFill([self bounds]);
 NSDrawGroove(NSMakeRect (10, 10, 100, 200), NSMakeRect (10, 10, 100, 200));

#if 0
  {
    NSRect superBounds = [[self superview] bounds];
    NSRect superFrame = [[self superview] frame];
    NSRect theBounds = [self bounds];
    NSRect theFrame = [self frame];

    NSLog (@"TestView drawRect: ((%f, %f), (%f, %f))",
	  rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    NSLog (@"TestView bounds: ((%f, %f), (%f, %f))",
	  theBounds.origin.x, theBounds.origin.y,
	  theBounds.size.width, theBounds.size.height);
    NSLog (@"TestView frame: ((%f, %f), (%f, %f))",
	  theFrame.origin.x, theFrame.origin.y,
	  theFrame.size.width, theFrame.size.height);
    NSLog (@"clip view bounds: ((%f, %f), (%f, %f))",
	  superBounds.origin.x, superBounds.origin.y,
	  superBounds.size.width, superBounds.size.height);
    NSLog (@"clip view frame: ((%f, %f), (%f, %f))",
	  superFrame.origin.x, superFrame.origin.y,
	  superFrame.size.width, superFrame.size.height);
  }
#endif

  [c set];
#if 0
  drawAnX(0, 0, 100, 100);
#endif

#if 0
  // Text
  f = [NSFont boldSystemFontOfSize: 24];
  [f set];
  PSmoveto(15, 20);
  PSshow("Bold system font.");

  f = [NSFont systemFontOfSize: 24];
  [f set];
  PSmoveto(15, 50);
  PSshow("System font.");

  f = [NSFont userFixedPitchFontOfSize: 24];
  [f set];
  PSmoveto(15, 100);
  PSshow("User fixed pitch font.");

  f = [NSFont userFontOfSize: 24];
  [f set];
  PSmoveto(15, 150);
  PSshow("User font.");
#endif

#if 1
  // Absolute Lines
  [blue set];
  PSnewpath();
  PSmoveto(400, 400);
  PSlineto(420, 400);
  PSlineto(440, 380);
  PSlineto(440, 360);
  PSlineto(420, 340);
  PSlineto(400, 340);
  PSlineto(380, 360);
  PSlineto(380, 380);
  PSclosepath();
  PSfill();
#endif

#if 1
  // Relative Lines
  [y set];
  PSnewpath();
  PSmoveto(400, 200);
  PSrlineto(20, 0);
  PSrlineto(20, -20);
  PSrlineto(0, -20);
  PSrlineto(-20, -20);
  PSrlineto(-20, 0);
  PSrlineto(-20, 20);
  PSrlineto(0, 20);
  PSclosepath();
  PSstroke();
#endif

}

- (void)mouseDown:(NSEvent *)theEvent
{
  NSPoint location = [theEvent locationInWindow];
  NSPoint p = [self convertPoint:location fromView:nil];
  NSClipView* clipView = [self superview];
  NSRect rect;

  NSLog (@"mouse down at (%2.2f, %2.2f), window location (%2.2f, %2.2f)",
	  p.x, p.y,
	  location.x, location.y);

  rect = [clipView bounds];
  NSLog (@"clip view bounds = ((%f, %f) (%f, %f))",
	  rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

  rect = [self bounds];
  NSLog (@"self bounds = ((%f, %f) (%f, %f))\n",
	  rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

@end
