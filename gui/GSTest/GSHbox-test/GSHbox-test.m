/* GSHbox-test.m: GSHbox Class Demo/Test

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999
   
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
#include <GNUstepGUI/GSHbox.h>
#include "../GSTestProtocol.h"

@interface GSHboxTest: NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@implementation GSHboxTest: NSObject
{
}
-(id) init
{
  GSHbox* hbox;
  NSColorWell *wA;
  NSColorWell *wB;
  NSColorWell *wC;
  NSColorWell *wD;
  NSColorWell *wE;
  NSColorWell *wF;
  NSColorWell *wG;
  NSRect winFrame;
  
  wA = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 50)];
  [wA setAutoresizingMask: NSViewHeightSizable];

  wB = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 50)];
  [wB setAutoresizingMask: NSViewMinYMargin | NSViewMaxYMargin 
      | NSViewMinXMargin | NSViewMaxXMargin];

  wC = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 50)];
  [wC setAutoresizingMask: NSViewMaxYMargin];

  wD = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 50)];
  [wD setAutoresizingMask: NSViewMinYMargin];

  wE = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 90, 90)];
  [wE setAutoresizingMask: NSViewNotSizable];

  wF = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 50)];
  [wF setAutoresizingMask: NSViewMinXMargin];

  wG = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 50)];
  [wG setAutoresizingMask: NSViewMinYMargin];

  hbox = [GSHbox new];
  [hbox setDefaultMinXMargin: 10];

  [hbox addView: wA];
  [wA release];

  [hbox addView: wB];
  [wB release];

  [hbox addView: wC];
  [wC release];

  [hbox addView: wD];
  [wD release];

  [hbox addSeparator];

  [hbox addView: wE];
  [wE release];

  [hbox addView: wF];
  [wF release];

  [hbox addView: wG
	enablingXResizing: NO];
  [wG release];

  [hbox setBorder: 10];
  [hbox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  
  winFrame.size = [hbox frame].size;
  winFrame.origin = NSMakePoint (100, 200);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO]; 
  [win setContentView: hbox];
  [hbox release];
  [win setTitle: @"GSHbox Test"];
  
  [self restart];
  return self;
}
-(void) dealloc
{
  [win release];
  [super dealloc];
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"GSHbox Test"
				     filename: NO];
}
@end
