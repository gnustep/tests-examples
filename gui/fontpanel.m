/* 
   fontpanel.m

   Copyright (C) 2000 Free Software Foundation, Inc.

   Author: Fred Kiefer, Nicola Pero
   Date: December 2000
   
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
#include <Foundation/NSAutoreleasePool.h>
#include <AppKit/AppKit.h>

int
main (void)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSApplication     *app;
  NSMenu	    *menu;
  NSMenuItem        *item;

  app = [NSApplication sharedApplication];

  menu = [NSMenu new];
  item = [menu addItemWithTitle: @"Fonts"
	       action: NULL
	       keyEquivalent: @""];
  [menu setSubmenu: [[NSFontManager sharedFontManager] fontMenu: YES]  
	forItem: item]; 
  [menu addItemWithTitle: @"Quit"
	action: @selector(terminate:)
	keyEquivalent: @"q"];
  [app setMainMenu: menu];

  [app run];

  [pool release];
  return 0;
}


