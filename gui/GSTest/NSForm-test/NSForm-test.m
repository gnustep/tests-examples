/* NSForm-test.m: NSForm class demo/test

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
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

@interface NSFormTest: NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@implementation NSFormTest: NSObject
{
  // for instance variables see above
}
-(id) init 
{
  GSVbox* vbox;
  NSBox* boxOne;
  NSForm* formOne;
  NSBox* boxTwo;
  NSForm* formTwo;
  NSBox* fieldBox;
  NSTextField* field;
  NSRect winFrame;

  field = [[NSTextField new] autorelease];
  // I suppose this could be considered a hack
  [field setStringValue: @"Test"];
  [field sizeToFit];
  [field setStringValue: @""];
  //
  [field setEditable: YES];
  [field setAutoresizingMask: NSViewWidthSizable];

  fieldBox = [[NSBox new] autorelease];
  [fieldBox setTitlePosition: NSAtTop];
  [fieldBox setTitle: @"A NSTextField"];
  [fieldBox setBorderType: NSGrooveBorder];
  [fieldBox addSubview: field];
  [fieldBox sizeToFit];
  [fieldBox setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  formOne = [[NSForm new] autorelease];
  [formOne addEntry: @"First Name:"];
  [formOne addEntry: @"Surname:"];
  [formOne addEntry: @"Address:"];
  [formOne addEntry: @"City:"];
  [formOne addEntry: @"State:"];
  [formOne setAutoresizingMask: NSViewWidthSizable];
  // Please note the order of the following commands
  [formOne setAutosizesCells: YES];
  // We use sizeToFit to make the form nice in the vertical direction
  [formOne sizeToFit];
  // Only then we set a bigger entry width (otherwise sizeToFit sets the 
  // minimum width).
  [formOne setEntryWidth: 240];

  boxOne = [[NSBox new] autorelease];
  [boxOne setTitlePosition: NSAtTop];
  [boxOne setTitle: @"A NSForm"];
  [boxOne setBorderType: NSGrooveBorder];
  [boxOne addSubview: formOne];
  [boxOne sizeToFit];
  [boxOne setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  formTwo = [[NSForm new] autorelease];
  [formTwo addEntry: @"First Name:"];
  [formTwo addEntry: @"Surname:"];
  [formTwo addEntry: @"Address:"];
  [formTwo addEntry: @"City:"];
  [formTwo addEntry: @"State:"];
  // Please note the order of the following commands
  [formTwo setAutoresizingMask: (NSViewWidthSizable)];
  [formTwo setAutosizesCells: YES];
  [formTwo sizeToFit];
  [formTwo setEntryWidth: 240];

  boxTwo = [[NSBox new] autorelease];
  [boxTwo setTitlePosition: NSAtTop];
  [boxTwo setTitle: @"Another NSForm"];
  [boxTwo setBorderType: NSGrooveBorder];
  [boxTwo addSubview: formTwo];
  [boxTwo sizeToFit];
  [boxTwo setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  vbox = [[GSVbox new] autorelease];
  [vbox setBorder: 10];
  [vbox setDefaultMinYMargin: 10];
  [vbox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  [vbox addView: boxTwo];
  [vbox addView: boxOne];
  [vbox addView: fieldBox];

  // NB: Always set next/previous text/keyview 
  // after all the objects have been created!
  [field setNextText: formOne];
  [formOne setNextText: formTwo];
  [formTwo setNextText: field];

  winFrame.size = [vbox frame].size;
  winFrame.origin = NSMakePoint (150, 150);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask
				      | NSResizableWindowMask)	
			  backing: NSBackingStoreBuffered
			  defer: YES];
  [win setTitle: @"NSForm Test"];
  [win setReleasedWhenClosed: NO];
  [win setContentView: vbox];

  [self restart];
  return self;
}
-(void) dealloc
{
  [win release];
  [super dealloc];
}
- (void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSForm Test"
				     filename: NO];
}
@end
