/* NSSplitView-test.m: NSSplitView Class Demo/Test

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
#include "../GSTestProtocol.h"

@interface NSSplitViewTest: NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@implementation NSSplitViewTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  NSSplitView *split;
  NSTextField *firstView;
  NSTextField *secondView;
  NSRect winFrame;

  split = [[NSSplitView alloc] initWithFrame: NSMakeRect (0, 0, 400, 200)];  
  
  firstView = [NSTextField new];
  [firstView setDrawsBackground: YES];
  [firstView setBackgroundColor: [NSColor whiteColor]];
  [firstView setEditable: NO];
  [firstView setSelectable: NO];
  [firstView setBezeled: YES];
  [firstView setBordered: NO];
  [firstView setAlignment: NSCenterTextAlignment];
  [firstView setStringValue: @"First NSView Contents"];
  [firstView setFrameSize: NSMakeSize (200, 200)]; 
  [firstView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  secondView = [NSTextField new];
  [secondView setDrawsBackground: YES];
  [secondView setBackgroundColor: [NSColor grayColor]];
  [secondView setEditable: NO];
  [secondView setSelectable: NO];
  [secondView setBezeled: YES];
  [secondView setBordered: NO];
  [secondView setAlignment: NSCenterTextAlignment];
  [secondView setStringValue: @"Second  NSView Contents"];
  [secondView setFrameSize: NSMakeSize (200, 200)]; 
  [secondView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  [split addSubview: firstView];
  [firstView release];
  [split addSubview: secondView];
  [secondView release];
  [split setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  winFrame.size = [split frame].size;
  winFrame.origin = NSMakePoint (100, 120);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: YES];
  
  [win setContentView: split];
  [split release];
  [win setTitle: @"NSSplitView Test"];
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
				     title: @"NSSplitView Test"
				     filename: NO];
}
@end
