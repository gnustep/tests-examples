/*
 *  CurrencyConverter.m: A mini over-commented sample GNUstep app 
 *
 *  Copyright (c) 1999 Free Software Foundation, Inc.
 *  
 *  Author: Nicola Pero
 *  Date: November 1999
 *
 *  This sample program is part of GNUstep.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/*
 * This mini sample program documents using text fields. 
 *
 * Layout is done with GSHbox, GSVbox.  
 * See Calculator.app for an example of window layout done without 
 * using GSVbox & GSHbox.
 */

/*
 *  I took the idea of writing this example code from an old GNUstep project 
 *  by Michael S. Hanni, but everything was coded from scratch. 
 */

// Include the definition of our custom class.
#include "CurrencyConverter.h"

// Include GNUstep layout extension classes
#include <GNUstepGUI/GSHbox.h>
#include <GNUstepGUI/GSVbox.h>


// Text to be displayed in the labels
static NSString* fieldString[3] = {
  @"Amount in other currency:",
  @"EUROs to convert:", 
  @"Exchange rate per 1 EURO:"
};

// Implementation of our custom class.
@implementation CurrencyConverter
{
  // See the @interface declaration in CurrencyConverter.h 
  // for the listing of instance variables
}
//
// Methods implementation
//

// Initialize an instance object of our class. 
- (id) init
{
  GSVbox* windowVbox;
  GSVbox* formVbox;
  GSHbox* hbox;
  NSTextField* label;
  NSButton* convertButton;
  NSRect winFrame;
  int i;
  NSSize size;

  self = [super init];

  // Create a vertical box (NB: Things are packed in the box 
  // from bottom to top)
  windowVbox = AUTORELEASE ([GSVbox new]);
  [windowVbox setBorder: 0];
  [windowVbox setDefaultMinYMargin: 0];
  
  //
  // Result field
  //
  hbox = AUTORELEASE ([GSHbox new]);
  [hbox setDefaultMinXMargin: 10];
  [hbox setBorder: 10];

  label = AUTORELEASE ([NSTextField new]);
  [label setSelectable: NO];
  [label setBezeled: NO];
  [label setDrawsBackground: NO];
  [label setStringValue: fieldString[0]];
  [label sizeToFit];
  [label setAutoresizingMask: NSViewHeightSizable];
  [hbox addView: label
	enablingXResizing: NO];
  
  field[0] = AUTORELEASE ([NSTextField new]);
  [field[0] setSelectable: YES];
  [field[0] setEditable: NO];
  [field[0] setBezeled: YES];
  [field[0] setBackgroundColor: [NSColor controlBackgroundColor]];
  [field[0] setDrawsBackground: YES];
  // Use automatic height
  [field[0] sizeToFit];
  // But set width to 100
  size = [field[0] frame].size;
  size.width = 100;
  [field[0] setFrameSize: size];
  [field[0] setAutoresizingMask: NSViewWidthSizable];
  // Saying nothing means enablingXResizing: YES
  [hbox addView: field[0]];

  [hbox setAutoresizingMask: NSViewWidthSizable];
  [windowVbox addView: hbox];

  //
  // Separator
  //
  [windowVbox addSeparator];
  
  //
  // Upper part of the window
  //
  formVbox = AUTORELEASE ([GSVbox new]);
  [formVbox setBorder: 10];
  [formVbox setDefaultMinYMargin: 10];

  // The two editable fields
  for (i = 1; i < 3; i++)
    {
      // We are doing it the hard way, without NSForm, to show how to do
      // more generally to pack things and objects
      hbox = AUTORELEASE ([GSHbox new]);
      [hbox setDefaultMinXMargin: 10];

      label = AUTORELEASE ([NSTextField new]);
      [label setSelectable: NO];
      [label setBezeled: NO];
      [label setDrawsBackground: NO];
      [label setStringValue: fieldString[i]];
      [label sizeToFit];
      [label setAutoresizingMask: NSViewHeightSizable];
      [hbox addView: label
	    enablingXResizing: NO];

      field[i] = AUTORELEASE ([NSTextField new]);
      [field[i] setEditable: YES];
      [field[i] setBezeled: YES];
      [field[i] setDrawsBackground: YES];
      // Use automatic height
      [field[i] sizeToFit];
      // But set width to 100
      size = [field[i] frame].size;
      size.width = 100;
      [field[i] setFrameSize: size];
      [field[i] setAutoresizingMask: NSViewWidthSizable];
      [hbox addView: field[i]];

      [hbox setAutoresizingMask: NSViewWidthSizable];
      [formVbox addView: hbox];
    }

  // Link the editable fields so the user may move between them
  // pressing TAB (Important: Remember to always send these messages
  // *after* you have created the objects you are referring to)
  [field[1] setNextText: field[2]];
  [field[2] setNextText: field[1]];

  // Ask to receive interesting messages concerning what's happening 
  // to the fields.  We are interested only in [-controlTextDidEndEditing:]
  [field[1] setDelegate: self];
  [field[2] setDelegate: self];

  [formVbox setAutoresizingMask: NSViewWidthSizable];
  [windowVbox addView: formVbox];

  //
  // Window
  //
  winFrame.size = [windowVbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);

  // Now we can make the window of the exact size  
  // NB: Note that we do not autorelease the window
  window = [[NSWindow alloc] 
	     initWithContentRect: winFrame
	     styleMask: (NSTitledWindowMask | NSMiniaturizableWindowMask 
			 | NSResizableWindowMask)
	     backing: NSBackingStoreBuffered
	     defer: YES];
  [window setTitle: @"CurrencyConverter.app"];
  [window setContentView: windowVbox];
  [window setMinSize: [NSWindow frameRectForContentRect: winFrame
				styleMask: [window styleMask]].size];

  // Trick to forbid vertical resizing
  [window setResizeIncrements: NSMakeSize (1, 100000)];
  return self;
}
- (void)dealloc
{
  // Releasing the window releases all its views in cascade
  RELEASE (window);
  [super dealloc];
}

// Received upon ending of editing in one of the two fields.
- (void)controlTextDidEndEditing: (NSNotification *)aNotification
{
  float euros, rate, total;

  // Read values
  euros = [field[2] floatValue];
  rate = [field[1] floatValue];

  // Compute total
  total = euros * rate;
  
  // Display total
  [field[0] setFloatValue: total];
}

// As app delegate, we receive this message from the app
- (void)applicationDidFinishLaunching: (NSNotification *)aNotification;
{
  [window orderFront: self];
}

// Execution starts from here. 
int main (void)
{
   NSAutoreleasePool *pool;
   NSApplication *app;
   NSMenu *mainMenu;
   NSMenu *menu;
   NSMenuItem *menuItem;
   CurrencyConverter *converter;
   int i;

   // We need to explicitly create this object only in the main function;     
   // instead, while the app is running, the gui library creates these objects
   // automatically for us.
   pool = [NSAutoreleasePool new];

   // Get the object representing our application.
   app = [NSApplication sharedApplication];
  
   //
   // Create the Menu 
   //

   // Main Menu
   mainMenu = AUTORELEASE ([NSMenu new]);

   // Info Item
   // The object receiving this message is determined at run time;
   // it will be the NSApplication
   [mainMenu addItemWithTitle: @"Info..." 
	     action: @selector (orderFrontStandardInfoPanel:) 
	     keyEquivalent: @""];

   // Edit Submenu
   menuItem = [mainMenu addItemWithTitle: @"Edit" 
			action: NULL 
			keyEquivalent: @""];
   menu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: menu forItem: menuItem];

   // The object which should receive the messages cut:, copy:, paste: is not 
   // specified, so that the library will have to determine it at run time. 
   // At first, it will (try to) send them to the 'first responder' 
   // -- the object which is receiving keyboard input.  
   // In our case that is precisely what we want, since the first responder 
   // is the NSText being edited (which knows how to handle cut:, copy:, 
   // paste:), if any.  
   [menu addItemWithTitle: @"Cut" 
	 action: @selector (cut:) 
	 keyEquivalent: @"x"];

   [menu addItemWithTitle: @"Copy" 
	 action: @selector (copy:) 
	 keyEquivalent: @"c"];

   [menu addItemWithTitle: @"Paste" 
	 action: @selector (paste:) 
	 keyEquivalent: @"v"];

   [menu addItemWithTitle: @"SelectAll" 
	 action: @selector (selectAll:) 
	 keyEquivalent: @"a"];

   // Hide MenuItem
   [mainMenu addItemWithTitle: @"Hide" 
	     action: @selector (hide:) 
	     keyEquivalent: @""];
   // Quit MenuItem
   [mainMenu addItemWithTitle: @"Quit" 
	     action: @selector (terminate:)
	     keyEquivalent: @"q"];	

   [app setMainMenu: mainMenu];
   // The default title @"Currency Converter" is a bit too long
   [mainMenu setTitle: @"CurrConv"];


   // Create and initializes an instance of our custom object.
   converter = [[CurrencyConverter alloc] init];
   
   // Set our custom object instance as the application delegate. 
   // This means that 'converter' will receive certain messages 
   // (documented in the doc) before/after important events for the app 
   // life, such as starting, ending, closing last window, etc.
   // In this context, we are interested in receiving the 
   // [-applicationDidFinishLaunching:] message.
   [app setDelegate: converter];

   // Finally, all is ready to run our application.
   [app run];
   return 0;
}


