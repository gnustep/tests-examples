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

#include <AppKit/AppKit.h>
#include "TestView.h"

@interface	FlippedView : NSView
@end

@implementation	FlippedView
- (BOOL) isFlipped
{
  return YES;
}
- (void)drawRect:(NSRect)rect
{
  [[NSColor redColor] set];
  NSRectFill ([self bounds]);
}
@end

@interface	UnflippedView : NSView
@end

@implementation	UnflippedView
- (BOOL) isFlipped
{
  return NO;
}
- (void)drawRect:(NSRect)rect
{
  [[NSColor greenColor] set];
  NSRectFill ([self bounds]);
}
@end

@implementation TestView

// Class methods

// Instance methods
- (BOOL)isFlipped
{
  return NO;
}

- (void)drawRect:(NSRect)rect
{
  static BOOL beenHere = NO;
  NSFont *f;
  NSColor *c = [NSColor greenColor];
  NSColor *blue = [NSColor blueColor];
  NSColor *y = [NSColor yellowColor];
  NSColor *orange = [NSColor orangeColor];
  static NSView	*fv;
  static NSView	*uv;

  NSRectClip (rect);
  [orange set];
  NSRectFill ([self bounds]);
  NSDrawGroove (NSMakeRect (10, 10, 100, 200), 
		NSMakeRect (10, 10, 100, 200));

  if (beenHere == NO)
    {
      beenHere = YES;
      fv = [[FlippedView alloc] initWithFrame: NSMakeRect(15,15,20,20)];
      [self addSubview: fv];
      uv = [[UnflippedView alloc] initWithFrame: NSMakeRect(45,15,20,20)];
      [self addSubview: uv];
    }
  
  [c set];
  
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

  // Absolute Lines
  [blue set];
  PSnewpath ();
  PSmoveto (400, 400);
  PSlineto (420, 400);
  PSlineto (440, 380);
  PSlineto (440, 360);
  PSlineto (420, 340);
  PSlineto (400, 340);
  PSlineto (380, 360);
  PSlineto (380, 380);
  PSclosepath ();
  PSfill ();

  // Relative Lines
  [y set];
  PSnewpath ();
  PSmoveto (400, 200);
  PSrlineto (20, 0);
  PSrlineto (20, -20);
  PSrlineto (0, -20);
  PSrlineto (-20, -20);
  PSrlineto (-20, 0);
  PSrlineto (-20, 20);
  PSrlineto (0, 20);
  PSclosepath ();
  PSstroke ();

  PSinitclip ();
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
