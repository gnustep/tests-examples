/* 
   ColorView.m

   Simple subclass of NSView.

   Copyright (C) 1997 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: February 1997
   
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
#include "ColorView.h"

@implementation ColorView

// Class methods

// Instance methods
- initWithFrame:(NSRect)rect
{
  [super initWithFrame: rect];

  ASSIGN(the_color, [NSColor blackColor]);
  ASSIGN(the_cursor, [NSCursor IBeamCursor]);

  return self;
}

- (void)setColor:(NSColor *)aColor
{
  ASSIGN(the_color, aColor);
}

- (NSColor *)color
{
  return the_color;
}

- (void)setCursor:(NSCursor *)aCursor
{
  ASSIGN(the_cursor, aCursor);
}

- (NSCursor *)cursor
{
  return the_cursor;
}

- (void)drawRect:(NSRect)rect
{
  [the_color set];
  NSRectFill([self bounds]);
}

- (void)mouseEntered:(NSEvent *)theEvent
{
  NSLog(@"Entered color view\n");
}

- (void)resetCursorRects
{
  NSRect theFrame = [self frame];
  NSRect theBounds = [self bounds];

  NSLog(@"resetCursorRects: frame ((%f, %f) (%f, %f)), "
	@"bounds ((%f, %f) (%f, %f))",
	theFrame.origin.x, theFrame.origin.y,
	theFrame.size.width, theFrame.size.height,
	theBounds.origin.x, theBounds.origin.y,
	theBounds.size.width, theBounds.size.height);
  [self addCursorRect: theBounds cursor: the_cursor];
}

@end
