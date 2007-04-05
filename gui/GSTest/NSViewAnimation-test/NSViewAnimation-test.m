/* NSViewAnimation-test.m: NSViewAnimation Demo/Test
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

@interface NSViewAnimationTest: NSObject <GSTest>
{
  NSWindow* win[3];
  NSArray* animations;
  NSViewAnimation* viewAnimation;
}
-(void) restart;
@end

@implementation NSViewAnimationTest

-(id) init
{
  unsigned i;
  for(i=0;i<3;i++)
    win[i] = [[NSWindow alloc]
      initWithContentRect: NSMakeRect(100+i*15,200+i*15,400,400)
		styleMask: NSBorderlessWindowMask
              		   | NSTitledWindowMask
			   | NSClosableWindowMask
			   | NSMiniaturizableWindowMask
		  backing: NSBackingStoreRetained
	    	    defer: YES
    ];

  animations = [[NSArray alloc] initWithObjects:
		 [NSDictionary dictionaryWithObjectsAndKeys:
		    win[0], NSViewAnimationTargetKey,
                    [NSValue valueWithRect: NSMakeRect( 50,50,50,100 )], NSViewAnimationEndFrameKey, 
		    nil],
		 [NSDictionary dictionaryWithObjectsAndKeys:
		    win[1], NSViewAnimationTargetKey, 
                    [NSValue valueWithRect: NSMakeRect( 110,50,120,120 )], NSViewAnimationEndFrameKey, 
		    nil],
		 [NSDictionary dictionaryWithObjectsAndKeys:
		    win[2], NSViewAnimationTargetKey, 
                    [NSValue valueWithRect: NSMakeRect( 50,180,150,180 )], NSViewAnimationEndFrameKey,
		    nil],
                 nil];

  viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations: animations];

  [self restart];
  return self;
}

-(void) dealloc
{
  unsigned i;
  for(i=0;i<3;i++)
    RELEASE(win[i]);
  RELEASE(animations);
  RELEASE(viewAnimation);
  [super dealloc];
}

-(void) restart
{
  unsigned i;
  for(i=0;i<3;i++)
  {
    [win[i] setFrame: NSMakeRect(100+i*15,200+i*15,400,400) display:YES];
    [win[i] orderFront: nil]; 
    [[NSApplication sharedApplication] addWindowsItem: win[i]
	   					title: @"NSViewAnimation Test"
					     filename: NO];
  }
  [NSTimer scheduledTimerWithTimeInterval: 1.5
				   target: self
				 selector: @selector(animate)
				 userInfo: nil
				  repeats: NO];
}

- (void) animate
{
  [viewAnimation startAnimation];
}
@end
