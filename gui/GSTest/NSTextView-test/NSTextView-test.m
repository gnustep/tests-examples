/* NSTextView-test.m: NSTextView Class Demo/Test

   Copyright (C) 2001 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 2001
   
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

@interface NSTextViewTest: NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@implementation NSTextViewTest: NSObject

-(id) init
{
  NSBox *externalBox;
  NSScrollView *scrollView;
  NSTextView *textView;
  NSRect winFrame;
  NSRect textRect;

  scrollView = [[NSScrollView alloc] 
		 initWithFrame: NSMakeRect (0, 0, 400, 300)];
  [scrollView setHasHorizontalScroller: YES];
  [scrollView setHasVerticalScroller: YES];
  [scrollView setBorderType: NSBezelBorder];
  [scrollView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  textRect = [[scrollView contentView] frame];
  textView = [[NSTextView alloc] initWithFrame: textRect];
  [textView setBackgroundColor: [NSColor whiteColor]];
  [textView setRichText: YES];
  [textView setUsesFontPanel: YES];
  [textView setDelegate: self];
  [textView setHorizontallyResizable: NO];
  [textView setVerticallyResizable: YES];
  [textView setMinSize: NSMakeSize (0, 0)];
  [textView setMaxSize: NSMakeSize (1E7, 1E7)];
  [textView setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];
  [[textView textContainer] setContainerSize: NSMakeSize (textRect.size.width,
							  1e7)];
  [[textView textContainer] setWidthTracksTextView: YES];
  
  [scrollView setDocumentView: textView];
  RELEASE(textView);
  
  // TODO: Substitute the following with a Hbox with commands etc. 
  externalBox = [NSBox new];
  [externalBox setTitlePosition: NSNoTitle];
  [externalBox setBorderType: NSNoBorder];
  [externalBox addSubview: scrollView];
  RELEASE (scrollView);
  [externalBox sizeToFit];
  [externalBox setAutoresizingMask: (NSViewWidthSizable 
				     | NSViewHeightSizable)];
  
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
  RELEASE (externalBox);
  [win setTitle: @"NSTextView Test"];
  
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
				     title: @"NSTextView Test"
				     filename: NO];
}
@end
