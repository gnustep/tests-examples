/* MyView - Custom view.

   Copyright (C) 2000 Free Software Foundation, Inc.

   Author:  Adam Fedor <fedor@gnu.org>
   Date: Feb 2000
   
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

#include "MyView.h"

@implementation MyView

-(void) dealloc
{
  RELEASE(comp);
  [super dealloc];
}

- (NSImage *) compositeImage
{
  NSRect frame;
  if (comp)
    return comp;

  frame = NSMakeRect(0, 0, 100, 100);
  comp = [[NSImage alloc] initWithSize: frame.size];		
			
  [comp lockFocus];
			
  [[NSColor clearColor] set];
  NSRectFill (frame);

  PSsetlinewidth(4);
  PSsetrgbcolor(0.6, 0.3, 0);
  PSsetalpha(1);
  PSmoveto(10, 10);
  PSlineto(90, 90);
  PSstroke();

  PSsetrgbcolor(0.0, 0.3, 0.8);
  PSsetalpha(0.5);
  PSrectfill(30, 40, 23, 24);
			
  [comp unlockFocus];
  return comp;
		
}

- (void) drawRect: (NSRect)rect
{
  NSPoint origin;

  origin = NSMakePoint (50, 50);
  PSsetrgbcolor(0, 0.5, 0.6);
  NSRectFill(rect);
  [[self compositeImage] compositeToPoint: origin operation: NSCompositeSourceOver];
}

@end
