/*
   Copyright (C) 2002 Free Software Foundation, Inc.
   
   Author: Nicola Pero <n.pero@mi.flashnet.it>

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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
*/
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "MainThread.h"
#include "SharedArea.h"

int main (void)
{ 
  NSAutoreleasePool *pool;
  NSMenu *mainMenu;

  pool = [NSAutoreleasePool new];
  [NSApplication sharedApplication];

  mainMenu = AUTORELEASE ([NSMenu new]);
  [mainMenu addItemWithTitle: @"Start" 
	    action: @selector (start:)
	    keyEquivalent: @"s"];	
  [mainMenu addItemWithTitle: @"Quit" 
	    action: @selector (terminate:)
	    keyEquivalent: @"q"];	
  [NSApp setMainMenu: mainMenu];

  set_up_shared_area ();

  [NSApp setDelegate: [MainThread new]];
  
  [NSApp run];

  return 0;
}

