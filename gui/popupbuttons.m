/*
   buttons.m

   All of the various NSButtons

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Author:  Ovidiu Predescu <ovidiu@net-community.com>
   Date: June 1996
   Author:  Felipe A. Rodriguez <far@ix.netcom.com>
   Date: August 1998

   This file is part of the GNUstep GUI X/RAW Backend.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; see the file COPYING.LIB.
   If not, write to the Free Software Foundation,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSPopUpButton.h>

#include "TestView.h"
#include "ColorView.h"

@interface buttonsController : NSObject
{
  NSWindow *win;
  id textField;
  id textField1;
  NSView* anotherView1;
  NSView* anotherView2;
}

@end

@implementation buttonsController

- (void)buttonAction:(id)sender
{
  NSLog (@"buttonAction:");
}

- (void)buttonAction2:(id)sender
{
  NSLog (@"buttonAction2:");
  [textField setStringValue:[sender intValue] ? @"on" : @"off"];
}

- (void)buttonSwitchView:(id)sender
{
  NSString *title = [sender titleOfSelectedItem];

  NSLog (@"title value = %@", title);

  if ([title isEqualToString:@"Devices"])
    [[win contentView] addSubview:anotherView1];    
  else
    [[win contentView] addSubview:anotherView2];    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSRect wf = {{100, 100}, {400, 400}};
  NSRect f = {{10, 10}, {380, 200}};
  NSPopUpButton *pushb;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask
		      | NSMiniaturizableWindowMask | NSResizableWindowMask;

  win = [[NSWindow alloc] initWithContentRect:wf
				    styleMask:style
				      backing:NSBackingStoreRetained
					defer:NO];

  anotherView1 = [[NSScrollView alloc] initWithFrame:f];
  [[win contentView] addSubview:anotherView1];
  
  anotherView2 = [[TestView alloc] initWithFrame:f];

  pushb = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(200,375,80,20)];
  [pushb addItemWithTitle:@"Devices"];
  [pushb addItemWithTitle:@"Network"];
  [pushb addItemWithTitle:@"Printers"];
  [pushb addItemWithTitle:@"Austin"];
  [pushb addItemWithTitle:@"Powers"];
  [pushb addItemWithTitle:@"Shag"];
  [pushb setTarget:self];
  [pushb setAction:@selector(buttonSwitchView:)];
  [[win contentView] addSubview:pushb];

  [win display];
  [win orderFront:nil];
}

@end

int
main(int argc, char **argv, char** env)
{
  id pool = [NSAutoreleasePool new];
  NSApplication *theApp;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif
#ifndef NX_CURRENT_COMPILER_RELEASE
    initialize_gnustep_backend();
#endif

  theApp = [NSApplication sharedApplication];
	[theApp setDelegate: [buttonsController new]];
	[theApp run];

  [pool release];

  return 0;
}
