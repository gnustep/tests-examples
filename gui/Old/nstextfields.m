/* 
   nstextfields.m

   Simple application to test NSSecureTextField* and NSTextField* classes.

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author:  Lyndon Tremblay <humasect@coolmail.com>
   Date: October 1999
   
   This file is part of the GNUstep GUI.

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

#include <Foundation/NSAutoreleasePool.h>
#include <AppKit/NSApplication.h>
#include <AppKit/NSWindow.h>
#include <AppKit/NSTextField.h>
#include <AppKit/NSSecureTextField.h>
#include <AppKit/NSMenu.h>
#include <AppKit/NSGraphics.h>
#include <AppKit/PSOperators.h>
#include <AppKit/NSFont.h>


@interface CustomWindow : NSWindow
@end
@implementation CustomWindow
@end

@interface Controller : NSObject
{
  CustomWindow *i_customWindow;
  NSTextField *i_textField;
  NSSecureTextField *i_secureTextField;
}
@end

@implementation Controller

/*
==================
-applicationDidFinishLaunching:
==================
*/
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  const NSRect windowRect = {{0, 0}, {400, 70}};
  const NSRect textFieldRect = {{25, 25}, {125, 20}};
  const NSRect secureFieldRect = {{175, 25}, {125, 20}};
  unsigned styleMask =
	NSTitledWindowMask |
	NSClosableWindowMask |
	NSResizableWindowMask |
	NSMiniaturizableWindowMask;

  i_customWindow = [[CustomWindow alloc] initWithContentRect:windowRect
				   styleMask:styleMask
				   backing:NSBackingStoreRetained
				   defer:NO];

  i_textField = [[NSTextField alloc] initWithFrame:textFieldRect];
  [i_textField setStringValue:@"NSTextField"];
  [[i_customWindow contentView] addSubview:i_textField];

  i_secureTextField = [[NSSecureTextField alloc] initWithFrame:secureFieldRect];
  [i_secureTextField setStringValue:@"NSSecureTextField"];
  [[i_customWindow contentView] addSubview:i_secureTextField];

  NSLog(@"editable: %i", [i_secureTextField isEditable]);
  NSLog(@"selectable: %i", [i_secureTextField isSelectable]);

  [i_customWindow setTitle:@"NSTextField            NSSecureTextField"];
  [i_customWindow center];
  [i_customWindow display];
  [i_customWindow orderFront:nil];
}

@end

int main (int argc, char **argv)
{
  NSAutoreleasePool *pool = [NSAutoreleasePool new];
  NSApplication *application;
  NSMenu *menu;

  [application = [NSApplication sharedApplication] setDelegate:[Controller new]];

  menu = [NSMenu new];
  [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
  [application setMainMenu:menu];

  [application run];
  [pool release];
  return 0;
}
