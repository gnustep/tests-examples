/* 
   windows.m

   Multiple windows

   Copyright (C) 1997 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: March 1997
   
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
#include "TestView.h"

//
// my main for the test app
//
int
main(int argc, char **argv, char** env)
{
  NSApplication *theApp;
  NSWindow *w0, *w1, *w2;
  NSRect wf0 = {{0, 0}, {500, 500}};
  NSRect wf2 = {{0, 0}, {300, 500}};
  TestView *v;
  NSView *v1, *v2;
  NSButton *mpush, *ponpoff, *toggle, *swtch, *radio, *mchange, *onoff;
  NSRect bf0 = {{5, 5}, {200, 50}};
  NSRect bf1 = {{5, 65}, {90, 45}};
  NSRect bf2 = {{5, 115}, {90, 26}};
  NSRect bf3 = {{5, 170}, {200, 26}};
  NSRect bf4 = {{5, 225}, {200, 26}};
  NSRect bf5 = {{5, 280}, {200, 50}};
  NSRect bf6 = {{5, 335}, {200, 50}};
  NSSliderCell *s0;
  NSRect sf0 = {{25, 325}, {100, 50}};

  NSTextField *t0, *t1, *t2, *t3;
  NSRect tf0 = {{25, 25}, {200, 50}};
  NSRect tf1 = {{25, 100}, {200, 50}};
  NSRect tf2 = {{25, 175}, {200, 50}};
  NSRect tf3 = {{25, 250}, {200, 50}};
  id pool;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

  pool = [NSAutoreleasePool new];

#ifndef NX_CURRENT_COMPILER_RELEASE
    initialize_gnustep_backend();
#endif

  theApp = [NSApplication sharedApplication];

  //
  // Windows
  //
  w0 = [[NSWindow alloc] init];
  [w0 setTitle:@"Graphics Testing"];

  v = [[TestView alloc] init];
  [w0 setContentView: v];
  [w0 setFrame:wf0 display:YES];

  w1 = [[NSWindow alloc] init];
  [w1 setTitle: @"Second Window"];
  v1 = [w1 contentView];

  mpush = [[NSButton alloc] initWithFrame: bf0];
  [mpush setTitle: @"MomentaryPush"];

  ponpoff = [[NSButton alloc] initWithFrame: bf1];
  [ponpoff setButtonType:NSToggleButton];
  [ponpoff setTitle: @"Toggle"];
  [ponpoff setAlternateTitle: @"Alternate"];
  [ponpoff setImage:[NSImage imageNamed:@"common_SwitchOff"]];
  [ponpoff setAlternateImage:[NSImage imageNamed:@"common_SwitchOn"]];
  [ponpoff setImagePosition:NSImageAbove];
  [ponpoff setAlignment:NSCenterTextAlignment];

  toggle = [[NSButton alloc] initWithFrame: bf2];
  [toggle setButtonType: NSToggleButton];
  [toggle setTitle: @"Toggle"];

  swtch = [[NSButton alloc] initWithFrame: bf3];
  [swtch setButtonType: NSSwitchButton];
  [swtch setBordered: NO];
  [swtch setTitle: @"Switch"];
  [swtch setAlternateTitle: @"Alternate"];

  radio = [[NSButton alloc] initWithFrame: bf4];
  [radio setButtonType: NSRadioButton];
  [radio setBordered: NO];
  [radio setTitle: @"Radio"];
  [radio setAlternateTitle: @"Alternate"];

  mchange = [[NSButton alloc] initWithFrame: bf5];
  [mchange setButtonType: NSMomentaryChangeButton];
  [mchange setTitle: @"MomentaryChange"];

  onoff = [[NSButton alloc] initWithFrame: bf6];
  [onoff setButtonType: NSOnOffButton];
  [onoff setTitle: @"OnOff"];

  [v1 addSubview: mpush];
  [v1 addSubview: ponpoff];
  [v1 addSubview: toggle];
  [v1 addSubview: swtch];
  [v1 addSubview: radio];
  [v1 addSubview: mchange];
  [v1 addSubview: onoff];

  [w1 setFrame: wf0 display: YES];

  w2 = [[NSWindow alloc] init];
  [w2 setTitle: @"Third Window"];
  v2 = [w2 contentView];

  t0 = [[NSTextField alloc] initWithFrame: tf0];
  t1 = [[NSTextField alloc] initWithFrame: tf1];
  [t1 setAlignment: NSRightTextAlignment];
  t2 = [[NSTextField alloc] initWithFrame: tf2];
  [t2 setAlignment: NSCenterTextAlignment];
  t3 = [[NSTextField alloc] initWithFrame: tf3];
  [t3 setBordered: NO];
  [t3 setTextColor: [NSColor redColor]];
  [t0 setNextText: t3];
  [t1 setNextText: t0];
  [t2 setNextText: t1];
  [t3 setNextText: t2];
  [v2 addSubview: t0];
  [v2 addSubview: t1];
  [v2 addSubview: t2];
  [v2 addSubview: t3];

  s0 = [[NSSlider alloc] initWithFrame: sf0];
  [v2 addSubview: s0];

  [w2 setFrame: wf2 display: YES];

  [w0 orderFrontRegardless];
  [w1 orderFrontRegardless];
  [w2 orderFrontRegardless];

  {
    NSMenu	*menu = [NSMenu new];

    [menu addItemWithTitle: @"Quit"
		    action: @selector(terminate:)
	     keyEquivalent: @"q"];
    [NSApp setMainMenu: menu];
  }

  [theApp run];

  [w0 release];
  [w1 release];
  [w2 release];

  [pool release];

  return 0;
}

