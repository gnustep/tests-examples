/* Composite-test.m: Composite Demo/Test

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
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "../GSTestProtocol.h"
#include "MyView.h"

@interface Composite: NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@implementation Composite : NSObject
{
  // for instance variables see above
}
-(id) init
{
  NSBox *externalBox;
  NSBox *borderBox;
  NSBox *box;
  NSScrollView *scrollView;
  MyView *view;
  NSRect winFrame;
  
  view = [[MyView alloc] initWithFrame: NSMakeRect(0, 0, 400, 300)];
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
  [win setReleasedWhenClosed: NO];
  [win setContentView: externalBox];
  [externalBox release];
  [win setTitle: @"Composite Test"];
  
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
				     title: @"Composite Test"
				     filename: NO];
}
@end
