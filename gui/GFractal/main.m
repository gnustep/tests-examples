/*
 *  main.m: main function of Fractal.app
 *
 *  Copyright (c) 2002 Free Software Foundation, Inc.
 *  
 *  Author: Marko Riedel
 *  Date: May 2002
 *
 *  With code fragments from MemoryPanel, ImageViewer, Finger, GDraw
 *  and GShisen, as well as some fractal defintions from FractInt.
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

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <AppKit/GSHbox.h>
#import <AppKit/GSVbox.h>

#import "Controller.h"

int
main (void)
{
  NSAutoreleasePool *pool;
  NSApplication *app;
  NSMenu *mainMenu, *subMenu;
  NSMenu *menu;
  NSMenuItem *menuItem, *subMenuItem;
  Controller *controller;
  FTYPE ft;
  CSCHEME cs;
  
  pool = [NSAutoreleasePool new];
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
	action: @selector (orderFrontStandardInfoPanel:) 
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
  subMenuItem = 
    [menu addItemWithTitle: @"New Fractal Window" 
	  action: NULL
	  keyEquivalent: @""];
  
  subMenu = AUTORELEASE ([NSMenu new]);
  [menu setSubmenu: subMenu forItem: subMenuItem];
  [[subMenu addItemWithTitle: [FractalWindow typeToString:ZSQUARED]
	    action: @selector (startNewFractalWindow:)
	    keyEquivalent: @"n"] setTag:ZSQUARED];
  for (ft = 1; ft < FTYPE_COUNT; ft++)
    {
      [[subMenu addItemWithTitle: [FractalWindow typeToString:ft]
		action: @selector (startNewFractalWindow:)
		keyEquivalent: @""] setTag:ft];
    }
  
  [menu addItemWithTitle: @"Save As..." 
	action: @selector (saveAs:)
	keyEquivalent: @"s"];
  [menu addItemWithTitle: @"Miniaturize"
	action: @selector(performMiniaturize:)
	keyEquivalent: @"m"];
  [menu addItemWithTitle: @"Close"
	action: @selector(performClose:)
	keyEquivalent: @"w"];
  
  // Fractal Submenu
  menuItem = [mainMenu addItemWithTitle: @"Fractal" 
		       action: NULL 
		       keyEquivalent: @""];
  menu = AUTORELEASE ([NSMenu new]);
  [mainMenu setSubmenu: menu forItem: menuItem];
  subMenuItem = [menu addItemWithTitle: @"Resolution" 
		      action: NULL
		      keyEquivalent: @""];
  
  subMenu = AUTORELEASE ([NSMenu new]);
  [menu setSubmenu: subMenu forItem: subMenuItem];
  [[subMenu addItemWithTitle: @"200" 
	    action: @selector (resolution:)
	    keyEquivalent: @""] setTag:200];
  [[subMenu addItemWithTitle: @"400" 
	    action: @selector (resolution:)
	    keyEquivalent: @""] setTag:400];
  [[subMenu addItemWithTitle: @"600" 
	    action: @selector (resolution:)
	    keyEquivalent: @""] setTag:600];
  
  
  subMenuItem = [menu addItemWithTitle: @"Color Scheme" 
                       action: NULL
		      keyEquivalent: @""];
  subMenu = AUTORELEASE ([NSMenu new]);
  [menu setSubmenu: subMenu forItem: subMenuItem];
  for (cs = 0; cs < CSCHEME_COUNT; cs++)
    {
      [[subMenu addItemWithTitle: [FractalWindow schemeToString:cs]
		action: @selector (colorScheme:)
		keyEquivalent: @""] setTag:cs];
    }
  
  subMenuItem = [menu addItemWithTitle: @"Zoom" 
		      action: NULL
		      keyEquivalent: @""];
  
  subMenu = AUTORELEASE ([NSMenu new]);
  [menu setSubmenu: subMenu forItem: subMenuItem];
  [[subMenu addItemWithTitle: @"Zoom in" 
	    action: @selector (zoomOp:)
	    keyEquivalent: @""] setTag:ZOOM_IN];
  [[subMenu addItemWithTitle: @"Zoom out" 
	    action: @selector (zoomOp:)
	    keyEquivalent: @""] setTag:ZOOM_OUT];
  [[subMenu addItemWithTitle: @"Restore" 
	    action: @selector (zoomOp:)
	    keyEquivalent: @""] setTag:ZOOM_RESTORE];
  
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
  [app setWindowsMenu: menu];
  
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
  
  RELEASE (controller);
  RELEASE (pool);
  return 0;
}


