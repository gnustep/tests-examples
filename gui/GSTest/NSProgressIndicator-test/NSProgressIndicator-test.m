/* NSProgressIndicator-test.m: NSProgressIndicator Class Demo/Test

   Copyright (C) 2010 Free Software Foundation, Inc.

   Author:  Riccardo Mottola
   Date: 2010
   
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
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

@interface NSProgressIndicatorTest: NSObject <GSTest>
{
  NSWindow *win;
  NSProgressIndicator *pi1;
}
-(void) restart;
@end

@implementation NSProgressIndicatorTest: NSObject

-(id) init
{
  GSVbox *vbox;
  NSBox *box;
  NSRect winFrame;

  NSProgressIndicator *pi2;
  
  vbox = [GSVbox new];
  [vbox setBorder: 5];
  
  //  pi1 = [NSProgressIndicator new];
  pi1 = [[NSProgressIndicator alloc] initWithFrame: NSMakeRect (0, 0, 120, 20)];
  [pi1 setIndeterminate: YES];
  [pi1 setBezeled: YES];
  [pi1 setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];    
  [pi1 sizeToFit];
  
  box = [NSBox new];
  [box setTitle: @"Indeterminate progress"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: pi1];
  [pi1 release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];      
  [vbox addView: box];

  pi2 = [[NSProgressIndicator alloc] initWithFrame: NSMakeRect (0, 0, 120, 20)];
  [pi2 setIndeterminate: NO];
  [pi2 setMinValue: 0];
  [pi2 setMaxValue: 1];
  [pi2 setBezeled: YES];
  [pi2 setDoubleValue: 0.5];
  [pi2 sizeToFit];
  [pi2 setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

  box = [NSBox new];
  [box setTitle: @"Determinate"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: pi2];
  [pi2 release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];      
  [vbox addView: box];

  winFrame.size = [vbox frame].size;
  winFrame.origin = NSMakePoint (100, 200);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];  
  [win setContentView: vbox];
  [vbox release];
  [win setTitle: @"NSProgressIndicator Test"];
  
  [self restart];
  return self;
}
-(void) dealloc
{
  RELEASE (win);
  [super dealloc];
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSProgressIndicator Test"
				     filename: NO];
  [pi1 startAnimation: self];
}
@end
