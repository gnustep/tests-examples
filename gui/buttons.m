/*
   buttons.m

   All of the various NSButtons

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Also: Ovidiu Predescu <ovidiu@net-community.com> June 1996
	 Felipe A. Rodriguez <far@ix.netcom.com> August 1998
	 Richard Frith-Macdonald

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


@interface buttonsController : NSObject
{
  id textField;
  id textField1;
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

- (void)setTextField:(id)anObject
{
  [anObject retain];
  if (textField)
    [textField release];
  textField = anObject;
}

- (void)buttonPressed:sender
{
  NSLog (@"textfield value = %@", [textField1 stringValue]);
  [textField1 setStringValue: @"Hello"];
}

- (void)setTextField1:object
{
  textField1 = object;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSWindow *win;
  NSRect wf = {{100, 100}, {400, 400}};
  NSView *v;
  NSView* anotherView1;
  NSView* anotherView2;
  NSButton *mpush, *ponpoff, *toggle, *swtch, *radio, *mchange, *onoff, *light;
  NSRect bf0 = {{5, 5}, {200, 50}};
  NSRect bf1 = {{5, 65}, {90, 45}};
  NSRect bf2 = {{5, 115}, {90, 26}};
  NSRect bf3 = {{5, 170}, {200, 26}};
  NSRect bf4 = {{5, 225}, {200, 26}};
  NSRect bf5 = {{5, 280}, {200, 50}};
  NSRect bf6 = {{10, 10}, {100, 20}};
  NSRect bf7 = {{120, 115}, {90, 26}};
  NSRect anotherView1Frame = {{5, 335}, {240, 70}};
  NSRect anotherView2Frame = {{10, 10}, {220, 50}};
  NSRect textFieldRect = {{125, 10}, {80, 20}};
  NSTextField* txtField;
  id button;
  NSTextField* tfield;
  NSRect textRect = { {260, 100}, {100, 20} };
  NSRect buttonRect = { { 300, 130 }, { 53, 20 } };
  NSColorWell *colorWell;
  NSRect cwf = {{300, 30}, {40, 40}};
  NSRect frame = {{250, 200}, {100, 100}};
  NSForm* form;
  NSFormCell *c;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask
		      | NSMiniaturizableWindowMask | NSResizableWindowMask;

  NSLog(@"Starting the application\n");

  win = [[NSWindow alloc] initWithContentRect:wf
				    styleMask:style
				      backing:NSBackingStoreRetained
					defer:NO];

//NSBackingStoreNonretained
//	win = [[NSWindow alloc] init];
//	[win setFrame: wf display: YES];
	[win setTitle:@"GNUstep Buttons"];
//	[win makeKeyAndOrderFront:nil];

  v = [win contentView];

  NSLog(@"Create the buttons\n");
  mpush = [[NSButton alloc] initWithFrame: bf0];
  [mpush setTitle: @"MomentaryPush"];
  [mpush setTarget:self];
  [mpush setAction:@selector(buttonAction:)];
  [mpush setContinuous:YES];

  ponpoff = [[NSButton alloc] initWithFrame: bf1];
  [ponpoff setButtonType:NSToggleButton];
  [ponpoff setTitle: @"Toggle"];
  [ponpoff setAlternateTitle: @"Alternate"];
  [ponpoff setImage:[NSImage imageNamed:@"NSSwitch"]];
  [ponpoff setAlternateImage:[NSImage imageNamed:@"NSHighlightedSwitch"]];
  [ponpoff setImagePosition:NSImageAbove];
  [ponpoff setAlignment:NSCenterTextAlignment];

  toggle = [[NSButton alloc] initWithFrame: bf2];
  [toggle setButtonType: NSToggleButton];
  [toggle setTitle: @"Toggle"];

  light = [[NSButton alloc] initWithFrame: bf7];
  [light setButtonType: NSMomentaryLight];
  [light setTitle: @"Light"];

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
  [mchange setAlternateTitle: @"Alternate"];

  anotherView1 = [[NSView alloc] initWithFrame:anotherView1Frame];
  anotherView2 = [[NSView alloc] initWithFrame:anotherView2Frame];

  onoff = [[NSButton alloc] initWithFrame: bf6];
  [onoff setButtonType: NSOnOffButton];
  [onoff setTitle: @"OnOff"];
  [onoff setTarget:self];
  [onoff setAction:@selector(buttonAction2:)];

  txtField = [[[NSTextField alloc] initWithFrame:textFieldRect] autorelease];
  [self setTextField:txtField];
  [txtField setStringValue:@"off"];

  colorWell = [[NSColorWell alloc] initWithFrame: cwf];
  [colorWell setColor:[NSColor greenColor]];

  tfield = [[NSTextField alloc] initWithFrame:textRect];
  [tfield setStringValue:@"abcdefghijklmnopqrstuvwxyz"];
  [tfield setAlignment:NSCenterTextAlignment];

  [self setTextField1:tfield];

  button = [[NSButton alloc] initWithFrame:buttonRect];
  [button setButtonType:NSMomentaryPushButton];
  [button setTarget:self];
  [button setAction:@selector(buttonPressed:)];

  form = [[NSForm alloc] initWithFrame:frame];
  c = [form addEntry:@"Field1"];
  [c setEditable:YES];
  [c setStringValue:@"Test"];
  [form addEntry:@"Field2"];
  [form addEntry:@"Field3"];

  NSLog(@"Make the buttons subviews\n");

  {
    NSMenu    *menu = [NSMenu new];
  
    [menu addItemWithTitle: @"Quit"
                  action: @selector(terminate:)
           keyEquivalent: @"q"];
    [NSApp setMainMenu: menu];
  }

  [v addSubview: mpush];
  [v addSubview: ponpoff];
  [v addSubview: toggle];
  [v addSubview: swtch];
  [v addSubview: radio];
  [v addSubview: mchange];
  [v addSubview:anotherView1];
  [anotherView1 addSubview:anotherView2];
  [anotherView2 addSubview:onoff];
  [anotherView1 addSubview:txtField];
  [v addSubview:light];
  [v addSubview:tfield];
  [v addSubview:button];
  [v addSubview:form];
  [v addSubview: colorWell];

  [v display];
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
