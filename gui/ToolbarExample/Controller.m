/*
 *  Controller.m: An application to demonstrate the GNUstep toolbars 
 *
 *  Copyright (c) 2004 Free Software Foundation, Inc.
 *  
 *  Author: Quentin Mathe <qmathe@club-internet.fr>
 *  Date: August 2004
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

#include "Controller.h"

@implementation Controller

- (void) awakeFromNib
{
  [NSApp setDelegate: self];
}

- (BOOL) applicationShouldOpenUntitledFile: (NSApplication *)sender
{
  return YES;
}

- (BOOL) applicationOpenUntitledFile: (NSApplication *)sender
{
  NSDocumentController *specialController = [NSDocumentController sharedDocumentController];
  NSDocument *document = 
    [specialController openUntitledDocumentOfType: @"txt" display: YES];
    
  if (document != nil)
    return YES;
  
  return NO;
}

// Toolbar delegates

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString*)identifier
 willBeInsertedIntoToolbar:(BOOL)willBeInserted 
{
  NSToolbarItem *toolbarItem = [[NSToolbarItem alloc]
    initWithItemIdentifier: identifier];
  
  AUTORELEASE(toolbarItem);

  NSLog(@"toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar: \
    has been called");

  if ([identifier isEqual: @"First"]) 
    {
      [toolbarItem setLabel: @"First item"];
      [toolbarItem setImage: [NSImage imageNamed: @"FileIcon_Directory"]];
    }
  else if ([identifier isEqual:@"Second"]) 
    {
      [toolbarItem setLabel: @"Second item"];
      [toolbarItem setImage: [NSImage imageNamed: @"SecondImage"]];
      [toolbarItem setTarget: nil];
      [toolbarItem setAction: @selector(toggleToolbarShown:)];
    }
  else if ([identifier isEqual:@"Popup"]) 
    {
      NSPopUpButton *popup = [[NSPopUpButton alloc] initWithFrame: 
      NSMakeRect(0, 0, 150, 22)];
      id item;
      NSMenuItem *menuItem;
      NSMenu *submenu;

      [popup setAutoenablesItems: NO];
    
      [popup addItemWithTitle: @"Marguerite"];
      [[popup itemWithTitle: @"Marguerite"] setEnabled: YES];
      [popup addItemWithTitle: @"Julie"];
      [[popup itemWithTitle: @"Julie"] setEnabled: YES];
      [popup addItemWithTitle: @"Liv"];
      [[popup itemWithTitle: @"Liv"] setEnabled: YES];
      [popup addItemWithTitle: @"Juliette"];
      [[popup itemWithTitle: @"Juliette"] setEnabled: YES];
	
      item = [popup itemWithTitle: @"Julies"];
      [popup selectItem: item];

      [toolbarItem setLabel: @"Just... popup"];
      [toolbarItem setView: popup];
    
      menuItem = [[NSMenuItem alloc] initWithTitle: @"More..." 
                                            action: NULL
                                     keyEquivalent: @""];
      submenu = [[NSMenu alloc] initWithTitle: @""];
      [submenu addItemWithTitle: @"Marguerite" 
                         action: @selector(reflectMenuSelection:) 
                  keyEquivalent: @""];
      [submenu addItemWithTitle: @"Julie" 
                         action: @selector(reflectMenuSelection:) 
                  keyEquivalent: @""];
      [submenu addItemWithTitle: @"Liv" 
                         action: @selector(reflectMenuSelection:) 
                  keyEquivalent: @""];
      [submenu addItemWithTitle: @"Juliette" 
                         action: @selector(reflectMenuSelection:) 
                  keyEquivalent: @""];
      [menuItem setSubmenu: AUTORELEASE(submenu)];
      [toolbarItem setMenuFormRepresentation: AUTORELEASE(menuItem)];
    }
  else if ([identifier isEqual:@"Slider"]) 
    {
      [toolbarItem setLabel: @"Loulou"];
      [toolbarItem setView: [[NSSlider alloc] initWithFrame: 
        NSMakeRect(0, 0, 70, 18)]];
    }

  return toolbarItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers: (NSToolbar *)toolbar {
  NSLog(@"toolbarDefaultItemIdentifiers: has been called");

  return [NSArray arrayWithObjects: @"First", 
                                    NSToolbarFlexibleSpaceItemIdentifier, 
                                    @"Second", 
				    @"Popup", 
                                    NSToolbarFlexibleSpaceItemIdentifier,
                                    NSToolbarCustomizeToolbarItemIdentifier, nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers: (NSToolbar *)toolbar {
  NSLog(@"toolbarAllowedItemIdentifiers: has been called"); 
    
  return [NSArray arrayWithObjects: @"First", 
                                    @"Second", 
                                    @"Popup", 
                                    @"Slider",
                                    NSToolbarCustomizeToolbarItemIdentifier, 
                                    NSToolbarFlexibleSpaceItemIdentifier, nil];
}

// ---

@end
