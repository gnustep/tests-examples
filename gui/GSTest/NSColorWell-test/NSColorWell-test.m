/* NSColorWell-test.m: NSColorWell class demo/test

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
#include <AppKit/GSHbox.h>
#include "../GSTestProtocol.h"

@interface NSColorWellTest: NSObject <GSTest>
{
  NSWindow *win;
  NSColorWell *well;
}
-(void) restart;
@end

@implementation NSColorWellTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  GSHbox *hbox;
  NSTextField *label;
  NSRect winFrame;

  label =[NSTextField new]; 
  [label setEditable: NO];
  [label setSelectable: NO];
  [label setBezeled: NO];
  [label setBordered: NO];
  [label setDrawsBackground: NO];
  [label setStringValue:@"Choose a color:"];
  [label sizeToFit];
  [label setAutoresizingMask: NSViewMinYMargin | NSViewMaxYMargin];
  
  well = [[NSColorWell alloc] initWithFrame: NSMakeRect (0, 0, 50, 40)];
  [well setAutoresizingMask: (NSViewMaxXMargin 
			      | NSViewMinYMargin | NSViewMaxYMargin)];
  hbox = [GSHbox new];
  [hbox setDefaultMinXMargin: 10];
  [hbox setBorder: 5];
  [hbox addView: label
	enablingXResizing: NO];
  [label release];
  [hbox addView: well];
  [well release];
  [hbox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

  winFrame.size = [hbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: YES];
  [win setTitle: @"NSColorWell Test"];
  [win setContentView: hbox];
  [hbox release];
  [win setMinSize: winFrame.size];
  [self restart];
  return self;
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSColorWell Test"
				     filename: NO];
}
@end
