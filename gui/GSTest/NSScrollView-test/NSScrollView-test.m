/* NSScrollView-test.m: NSScrollView Class Demo/Test

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

@interface NSScrollViewTest: NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@implementation NSScrollViewTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  NSBox *externalBox;
  NSBox *borderBox;
  NSBox *box;
  NSScrollView *scrollView;
  NSTextField *view;
  NSRect winFrame;
  
  view = [NSTextField new];
  [view setDrawsBackground: YES];
  [view setBackgroundColor: [NSColor yellowColor]];
  [view setEditable: NO];
  [view setSelectable: NO];
  [view setBezeled: NO];
  [view setBordered: YES];
  [view setAlignment: NSCenterTextAlignment];
  [view setStringValue: @"This is the DocumentView"];
  [view setFrameSize: NSMakeSize (400, 400)]; 
  [view setAutoresizingMask: NSViewNotSizable];
  
  box = [NSBox new];
  [box setTitle: @"DocumentView"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: view];
  [view release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewNotSizable];      
  
  borderBox = [NSBox new];
  [borderBox setTitlePosition: NSNoTitle];
  [borderBox setBorderType: NSNoBorder];
  [borderBox addSubview: box];
  [box release];
  [borderBox sizeToFit];
  [borderBox setAutoresizingMask: NSViewNotSizable];

  scrollView = [[NSScrollView alloc] 
		 initWithFrame: NSMakeRect (0, 0, 200, 200)];
  [scrollView setDocumentView: borderBox];
  [borderBox release];
  [scrollView setHasHorizontalScroller: YES];
  [scrollView setHasVerticalScroller: YES];
  [scrollView setBorderType: NSBezelBorder];
  [scrollView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  // TODO: Substitute the following with a Hbox with commands etc. 
  externalBox = [NSBox new];
  [externalBox setTitlePosition: NSNoTitle];
  [externalBox setBorderType: NSNoBorder];
  [externalBox addSubview: scrollView];
  [scrollView release];
  [externalBox sizeToFit];
  [externalBox setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  winFrame.size = [externalBox frame].size;
  winFrame.origin = NSMakePoint (100, 200);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  
  [win setContentView: externalBox];
  [externalBox release];
  [win setTitle: @"NSScrollView Test"];
  
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
				     title: @"NSScrollView Test"
				     filename: NO];
}
@end
