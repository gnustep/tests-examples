/* NSAnimation-test.m: NSAnimation Demo/Test
 *
 * Copyright (C) 2000 Free Software Foundation, Inc.
 *
 * Created : 2007-03-Mar
 * Author :  Xavier Glattard (xgl) <xavier.glattard@online.fr>
 * 
 * This file is part of GNUstep.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "../GSTestProtocol.h"
#include "AnimationView.h"

@interface NSAnimationTest: NSObject <GSTest>
{
  NSWindow *win;
  AnimationView *view;
}
-(void) restart;
@end

@implementation NSAnimationTest

-(id) init
{
  win = [[NSWindow alloc]
          initWithContentRect: NSMakeRect(100,200,400,400)
		    styleMask: NSBorderlessWindowMask
                               | NSTitledWindowMask
			       | NSClosableWindowMask
			       | NSMiniaturizableWindowMask
	              backing: NSBackingStoreRetained
			defer: NO
	];
  view = [[AnimationView alloc ] initWithFrame: NSZeroRect];

  [win setContentView: view];
  [win setReleasedWhenClosed: NO];

  [self restart];
  return self;
}
-(void) dealloc
{
  RELEASE(win);
  [super dealloc];
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSAnimation Test"
				     filename: NO];
}

@end
