/*
 *  main.m: main function of Finger.app
 *
 *  Copyright (c) 2000 Free Software Foundation, Inc.
 *  
 *  Author: Nicola Pero
 *  Date: February 2000
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

#import "Finger.h"
#import "Controller.h"

int
main (void)
{
   NSAutoreleasePool *pool;
   NSApplication *app;
   NSMenu *mainMenu;
   NSMenu *menu;
   NSMenuItem *menuItem;
   Controller *controller;
   int i;

   pool = [NSAutoreleasePool new];
   initialize_gnustep_backend ();
   app = [NSApplication sharedApplication];
  
   //
   // Create the Menu 
   //

   // Main Menu
   mainMenu = AUTORELEASE ([NSMenu new]);

   // Info SubMenu
   menuItem = [mainMenu addItemWithTitle: @"Info" 
			action: NULL 
			keyEquivalent: @""];
   menu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: menu forItem: menuItem];
   [menu addItemWithTitle: @"Info Panel..." 
	 action: @selector (runInfoPanel:) 
	 keyEquivalent: @""];
   [menu addItemWithTitle: @"Preferences..." 
	 action: @selector (runPreferencesPanel:) 
	 keyEquivalent: @""];
   [menu addItemWithTitle: @"Help..." 
	 action: @selector (orderFrontHelpPanel:)
	 keyEquivalent: @"?"];

   // Document Submenu
   menuItem = [mainMenu addItemWithTitle: @"Document" 
			action: NULL 
			keyEquivalent: @""];
   menu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: menu forItem: menuItem];
   [menu addItemWithTitle: @"New Finger Window" 
	 action: @selector (startNewFingerWindow:)
	 keyEquivalent: @""];
   [menu addItemWithTitle: @"Save Results As..." 
	 action: @selector (saveResults:)
	 keyEquivalent: @"s"];
   [menu addItemWithTitle: @"Reset Results" 
	 action: @selector (resetResults:)
	 keyEquivalent: @""];
   [menu addItemWithTitle: @"Miniaturize"
	 action: @selector(performMiniaturize:)
	 keyEquivalent: @"m"];
   [menu addItemWithTitle: @"Close"
	 action: @selector(performClose:)
	 keyEquivalent: @"w"];
   // Edit SubMenu
   menuItem = [mainMenu addItemWithTitle: @"Edit" 	
			action: NULL 
			keyEquivalent: @""];
   menu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: menu forItem: menuItem];
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
   // Windows SubMenu
   menuItem = [mainMenu addItemWithTitle:@"Windows" 
			action: NULL 
			keyEquivalent:@""];
   menu = AUTORELEASE ([NSMenu new]);
   [mainMenu setSubmenu: menu forItem: menuItem];
   [menu addItemWithTitle: @"Arrange"
	 action: @selector(arrangeInFront:)
	 keyEquivalent: @""];
   [menu addItemWithTitle: @"Miniaturize"
	 action: @selector(performMiniaturize:)
	 keyEquivalent: @"m"];
   [menu addItemWithTitle: @"Close"
	 action: @selector(performClose:)
	 keyEquivalent: @"w"];
   
   // Hide MenuItem
   [mainMenu addItemWithTitle: @"Hide" 
	     action: @selector (hide:)
	     keyEquivalent: @"h"];	

   // Quit MenuItem
   [mainMenu addItemWithTitle: @"Quit" 
	     action: @selector (terminate:)
	     keyEquivalent: @"q"];	

   [app setMainMenu: mainMenu];

   controller = [Controller new];
   [app setDelegate: controller];
   [app run];
   [[NSUserDefaults standardUserDefaults] synchronize];
   /* Useless anyway, since everything is automatically released on exit. */
   RELEASE (controller);
   RELEASE (pool);
   return 0;
}


