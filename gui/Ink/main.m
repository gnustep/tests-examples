/* main.m: Main Body of GNUstep Ink demo application

   Copyright (C) 2000 Free Software Foundation, Inc.

   Author:  Fred Kiefer <fredkiefer@gmx.de>
   Date: 2000
   
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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <AppKit/NSDocumentController.h>
#include "Document.h"

@interface MyDelegate : NSObject
{
}

- (BOOL)application:(NSApplication *)application openFile:(NSString *)fileName;
- (void) applicationWillFinishLaunching: (NSNotification *)not;
//- (void) applicationDidFinishLaunching: (NSNotification *)not;
@end

@implementation MyDelegate : NSObject 

- (BOOL)application:(NSApplication *)application openFile:(NSString *)fileName
{
  [NSApp activateIgnoringOtherApps: YES];
  [[NSDocumentController sharedDocumentController]
    openDocumentWithContentsOfFile: fileName display: YES];
  return YES;
}

- (void) applicationWillFinishLaunching: (NSNotification *)not
{
  CREATE_AUTORELEASE_POOL(pool);
  NSMenu *menu;
  NSMenu *info;
  NSMenu *file;
  NSMenu *format;
  NSMenu *base;
  NSMenu *text;
  NSMenu *edit;
  NSMenu *print;
  NSMenu *services;
  NSMenu *windows;

  //	Create the app menu
  menu = [NSMenu new];

  [menu addItemWithTitle: @"Info"
		  action: NULL
	   keyEquivalent: @""];
  [menu addItemWithTitle: @"File"
		  action: NULL
	   keyEquivalent: @""];
  [menu addItemWithTitle: @"Edit"
		  action: NULL
	   keyEquivalent: @""];
  [menu addItemWithTitle: @"Format"
		  action: NULL
	   keyEquivalent: @""];
  [menu addItemWithTitle: @"Text"
		  action: NULL
	   keyEquivalent: @""];
  [menu addItemWithTitle: @"Windows"
		  action: NULL
	   keyEquivalent: @""];
  [menu addItemWithTitle: @"Print"
		  action: NULL
	   keyEquivalent: @"p"];
  [menu addItemWithTitle: @"Services"
		  action: NULL
	   keyEquivalent: @""];
  [menu addItemWithTitle: @"Hide"
		  action: @selector(hide:)
	   keyEquivalent: @"h"];
  [menu addItemWithTitle: @"Quit"
		  action: @selector(terminate:)
	   keyEquivalent: @"q"];

  // Create the info submenu
  info = [NSMenu new];
  [info addItemWithTitle: @"Info Panel..."
	          action: @selector(orderFrontStandardInfoPanel:)
	   keyEquivalent: @""];
/*  
  [info addItemWithTitle: @"Preferences..."
		  action: NULL
	   keyEquivalent: @""];
*/
  [info addItemWithTitle: @"Help"
		  action: @selector (orderFrontHelpPanel:)
	   keyEquivalent: @"?"];
  [menu setSubmenu: info
	   forItem: [menu itemWithTitle: @"Info"]];
  RELEASE(info);

  // Create the file submenu
  file = [NSMenu new];
  [file addItemWithTitle: @"Open Document"
		  action: @selector(openDocument:)
	   keyEquivalent: @"o"];
  [file addItemWithTitle: @"New Document"
		  action: @selector(newDocument:)
	   keyEquivalent: @"n"];
  [file addItemWithTitle: @"Save"
	          action: @selector(saveDocument:)
	   keyEquivalent: @"s"];
  [file addItemWithTitle: @"Save To..."
	          action: @selector(saveDocumentTo:)
	   keyEquivalent: @"t"];
  [file addItemWithTitle: @"Save As..."
	          action: @selector(saveDocumentAs:)
	   keyEquivalent: @"S"];
  [file addItemWithTitle: @"Save All"
	action: @selector(saveDocumentAll:)
	   keyEquivalent: @""];
  [file addItemWithTitle: @"Revert to Saved"
		  action: @selector(revertDocumentToSaved:)
	   keyEquivalent: @"u"];
  [file addItemWithTitle: @"Close"
		  action: @selector(close)
	   keyEquivalent: @""];
  [file addItemWithTitle: @"Insert File..."
	          action: @selector(insertFile:)
	   keyEquivalent: @""];
  [menu setSubmenu: file
	   forItem: [menu itemWithTitle: @"File"]];
  RELEASE(file);

  // Create the edit submenu
  edit = [NSMenu new];

  [edit addItemWithTitle: @"Cut"
	          action: @selector(cut:)
	   keyEquivalent: @"x"];
  [edit addItemWithTitle: @"Copy"
	          action: @selector(copy:)
	   keyEquivalent: @"c"];
  [edit addItemWithTitle: @"Paste"
		  action: @selector(paste:)
	   keyEquivalent: @"v"];
  [edit addItemWithTitle: @"Delete"
   	          action: @selector(delete:)
	   keyEquivalent: @""];
/*
  [edit addItemWithTitle: @"Undelete"
		  action: NULL
	   keyEquivalent: @""];
*/
  [edit addItemWithTitle: @"Select All"
  	          action: @selector(selectAll:)
	   keyEquivalent: @"a"];
  [menu setSubmenu: edit
	   forItem: [menu itemWithTitle: @"Edit"]];
  RELEASE(edit);

  // Create the format submenu
  format = [[NSFontManager sharedFontManager] fontMenu: YES];
  [format addItemWithTitle: @"Underline"
  	          action: @selector(underline:)
	   keyEquivalent: @""];
  [format addItemWithTitle: @"Baseline"
  	          action: NULL
	   keyEquivalent: @""];
  base = [NSMenu new];
  [base addItemWithTitle: @"Superscript"
  	          action: @selector(superscript:)
	   keyEquivalent: @""];
  [base addItemWithTitle: @"Subscript"
  	          action: @selector(subscript:)
	   keyEquivalent: @""];
  [base addItemWithTitle: @"Unscript"
  	          action: @selector(unscript:)
	   keyEquivalent: @""];
  [format setSubmenu: base
	   forItem: [format itemWithTitle: @"Baseline"]];
  RELEASE(base);
  [format addItemWithTitle: @"Color" 
	  action: @selector(orderFrontColorPanel:)
	  keyEquivalent: @"c"];
  [format addItemWithTitle: @"Copy Font" 
	  action: @selector(copyFont:)
	  keyEquivalent: @"3"];
  [format addItemWithTitle: @"Paste Font" 
	  action: @selector(pasteFont:) 
	  keyEquivalent: @"4"];
  [menu setSubmenu: format
	   forItem: [menu itemWithTitle: @"Format"]];
  RELEASE(format);

  // Create the text submenu
  text = [NSMenu new];
  [text addItemWithTitle: @"Align Left"
		  action: @selector(alignLeft:)
	   keyEquivalent: @"{"];
  [text addItemWithTitle: @"Center"
		  action: @selector(alignCenter:)
	   keyEquivalent: @"-"];
  [text addItemWithTitle: @"Align Right"
		  action: @selector(alignRight:)
	   keyEquivalent: @"}"];
  [text addItemWithTitle: @"Toggle Ruler" 
	action: @selector(toggleRuler:) 
	keyEquivalent: @""];
  [text addItemWithTitle: @"Copy Ruler" 
	action: @selector(copyRuler:) 
	keyEquivalent: @"1"];
  [text addItemWithTitle: @"Paste Ruler" 
	action: @selector(pasteRuler:) 
	keyEquivalent: @"2"];
  [menu setSubmenu: text
	   forItem: [menu itemWithTitle: @"Text"]];
  RELEASE(text);

  // Create the printing submenu
  print = [NSMenu new];
  [print addItemWithTitle: @"Print"
		  action: @selector(printDocument:)
	   keyEquivalent: @"p"];
  [print addItemWithTitle: @"Setup Printer"
		  action: @selector(runPageLayout:)
	   keyEquivalent: @"P"];
  [print addItemWithTitle: @"Spell Check"
		  action: @selector(checkSpelling:)
	   keyEquivalent: @"C"];
  [print addItemWithTitle: @"Spell Panel"
		  action: @selector(showGuessPanel:)
	   keyEquivalent: @"c"];
  [menu setSubmenu: print
	   forItem: [menu itemWithTitle: @"Print"]];
  RELEASE(print);

  // Create the windows submenu
  windows = [NSMenu new];
  [windows addItemWithTitle: @"Arrange"
		     action: @selector(arrangeInFront:)
	      keyEquivalent: @""];
  [windows addItemWithTitle: @"Miniaturize"
		     action: @selector(performMiniaturize:)
	      keyEquivalent: @"m"];
  [windows addItemWithTitle: @"Close"
		     action: @selector(performClose:)
	      keyEquivalent: @"w"];
  [menu setSubmenu: windows
	   forItem: [menu itemWithTitle: @"Windows"]];
  [NSApp setWindowsMenu: windows];
  RELEASE(windows);

  // Create the service submenu
  services = [NSMenu new];
  [menu setSubmenu: services
	   forItem: [menu itemWithTitle: @"Services"]];
  [NSApp setServicesMenu: services];
  RELEASE(services);

  [NSApp setMainMenu: menu];
  RELEASE(menu);

  RELEASE(pool);
}

@end

int
main(int argc, const char **argv, char** env)
{
  [NSApplication sharedApplication];
  [NSApp setDelegate: [MyDelegate new]];

  return NSApplicationMain(argc, argv);
}
