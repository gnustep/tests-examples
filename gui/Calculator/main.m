/* main.m: Main Body of Calculator.app

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
#include "CalcBrain.h"
#include "CalcFace.h"

@interface CalcController: NSObject
{
}
-(BOOL) windowShouldClose: (NSWindow *)win;
@end

@implementation CalcController
{
}
-(BOOL) windowShouldClose: (NSWindow *)win
{
  [[NSApplication sharedApplication] terminate: nil];
  return YES;
}
@end

int 
main (void)
{ 
  CalcBrain *brain;
  CalcFace *face;
  CalcController *faceController;
  NSAutoreleasePool *pool;
  NSApplication *app;
  NSMenu *mainMenu;
  NSMenu *menu;
  NSMenuItem *menuItem;
  
  pool = [NSAutoreleasePool new];
  initialize_gnustep_backend ();
  app = [NSApplication sharedApplication];
  [app setApplicationIconImage: [NSImage imageNamed: @"Calculator.app.tiff"]];
  mainMenu = [NSMenu new];
  menuItem = [mainMenu addItemWithTitle: @"Edit" 	
		       action: NULL 
		       keyEquivalent: @""];
  menu = [NSMenu new];
  [mainMenu setSubmenu: menu forItem: menuItem];
  /*
  [menu addItemWithTitle: @"Cut" 
	action: @selector (cut:) 
	keyEquivalent: @"x"];
  */
  [menu addItemWithTitle: @"Copy" 
	action: @selector (copy:) 
	keyEquivalent: @"c"];
  /* 
  [menu addItemWithTitle: @"Paste" 
	action: @selector (paste:) 
	keyEquivalent: @"v"];
  */
  [menu addItemWithTitle: @"SelectAll" 
	action: @selector (selectAll:) 
	keyEquivalent: @"a"];
  
  [mainMenu addItemWithTitle: @"Quit" 
	    action: @selector (terminate:)
	    keyEquivalent: @"q"];	
  
  [app setMainMenu: mainMenu];
  
  brain = [CalcBrain new];
  face = [CalcFace new]; 
  [brain setFace: face];
  [face setBrain: brain];
  faceController = [CalcController new];
  [face setDelegate: faceController];
  [app setDelegate: face];
  
  [app run];
  [pool release];
  return 0;
}

