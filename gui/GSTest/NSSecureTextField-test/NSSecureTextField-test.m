/* NSSecureTextField-test.m: NSSecureTextField Class Demo/Test

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
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

@interface NSSecureTextFieldTest: NSObject <GSTest>
{
  NSWindow *win;
}
- (void) restart;
@end

@implementation NSSecureTextFieldTest: NSObject
{
  // for instance variables see above
}
-(id) init
{  
  GSVbox *vbox;
  NSBox *box;
  NSRect winFrame;
  NSSecureTextField *sview;
  NSTextField *view;
  
  vbox = [GSVbox new];
  [vbox setBorder: 5];
  
  sview = [NSSecureTextField new];
  [sview setEditable: YES];
  [sview setBezeled: YES];
  [sview setStringValue: @"A very long password inserted here"]; 
  [sview sizeToFit];
  [sview setStringValue: @""]; 
  [sview setAutoresizingMask: NSViewWidthSizable];
  
  box = [NSBox new];
  [box setTitle: @"Insert Password"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: sview];
  [sview release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewWidthSizable];      
  [vbox addView: box];

  view = [NSTextField new];
  [view setEditable: YES];
  [view setBezeled: YES];
  [view setStringValue: @"A very long login inserted here"]; 
  [view sizeToFit];
  [view setStringValue: @""]; 
  [view setAutoresizingMask: NSViewWidthSizable];
  [view setNextKeyView: sview];
  [sview setNextKeyView: view];

  box = [NSBox new];
  [box setTitle: @"Insert Login"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: view];
  [view release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewWidthSizable];      
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
  [win setTitle: @"NSSecureTextField Test"];
  
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
				     title: @"NSSecureTextFieldTest"
				     filename: NO];
}

@end
