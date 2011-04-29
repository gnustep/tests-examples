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
  NSTextStorage *storage;
}
-(void) restart;
@end

@implementation NSTextViewTest: NSObject

-(id) init
{
  NSView *container;
  NSRect winFrame;
  NSTextField *label;
  
  container = [NSView new];

  {
    NSTextContainer *tc1, *tc2, *tc3, *tc4, *tc5, *tc6;	
    NSTextView *tv1, *tv2, *tv3, *tv4, *tv5, *tv6;
    NSLayoutManager *lm1, *lm2;
   
    storage = [[NSTextStorage alloc] init];
 
    lm1 = [[NSLayoutManager alloc] init];
    lm2 = [[NSLayoutManager alloc] init];
    [storage addLayoutManager: lm1];
    [storage addLayoutManager: lm2];
    [lm1 release];
    [lm2 release];

    tc1 = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(150, 150)];
    tc2 = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(150, 150)];
    tc3 = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(150, 150)];
    tc4 = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(150, 150)];
    tc5 = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(150, 300)];		
    tc6 = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(150, 300)];
    
    [lm1 addTextContainer: tc1];
    [lm1 addTextContainer: tc2];
    [lm1 addTextContainer: tc3];
    [lm1 addTextContainer: tc4];
    [lm2 addTextContainer: tc5];
    [lm2 addTextContainer: tc6];
    [tc1 release];
    [tc2 release];
    [tc3 release];
    [tc4 release];
    [tc5 release];
    [tc6 release];
    
    tv1 = [[NSTextView alloc] initWithFrame: NSMakeRect(0,	151,	150,150) textContainer: tc1];		
    tv2 = [[NSTextView alloc] initWithFrame: NSMakeRect(151,	151,	150,150) textContainer: tc2];		
    tv3 = [[NSTextView alloc] initWithFrame: NSMakeRect(0,	0,	150,150) textContainer: tc3];
    tv4 = [[NSTextView alloc] initWithFrame: NSMakeRect(151,	0,	150,150) textContainer: tc4];
    tv5 = [[NSTextView alloc] initWithFrame: NSMakeRect(360,	0,	150,300) textContainer: tc5];
    tv6 = [[NSTextView alloc] initWithFrame: NSMakeRect(511,	0,	150,300) textContainer: tc6];
    
    [container addSubview: tv1];
    [container addSubview: tv2];
    [container addSubview: tv3];
    [container addSubview: tv4];	
    [container addSubview: tv5];
    [container addSubview: tv6];
    [tv1 release]; 
    [tv2 release];
    [tv3 release];
    [tv4 release];
    [tv5 release];
    [tv6 release];

    [[storage mutableString] appendString: @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."];
  }
  
  winFrame.size = NSMakeSize(662,401);
  winFrame.origin = NSMakePoint (100, 200);

  label = [[NSTextField alloc] initWithFrame: NSMakeRect(0, 301, 662, 100)];
  [label setStringValue: @"The four text views on the left share a layout manager, as do the two columns on the right. All six text views share the same underlying text storage."];
  [label setBezeled: NO];
  [label setDrawsBackground: NO];
  [label setEditable: NO];
  [container addSubview: label];
  RELEASE (label);

  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];  
  [win setContentView: container];
  RELEASE (container);
  [win setTitle: @"NSTextView Test"];
  
  [self restart];
  return self;
}
-(void) dealloc
{
  RELEASE (win);
  RELEASE (storage);
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
