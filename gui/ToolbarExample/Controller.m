/*
 *  Controller.m: An application to demonstrate the GNUstep toolbars 
 *
 *  Copyright (c) 2004 Free Software Foundation, Inc.
 *  
 *  Author: Quentin Mathe <qmathe@club-internet.fr>
 *  Date: March 2004
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

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "Controller.h"
#include "MiniController.h"

@implementation Controller

- (void)awakeFromNib 
{
  NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"myToolbar"];
  NSImage *image = [NSImage imageNamed: @"SecondImage.tiff"];
  id item;
  
  [window setDelegate: self];
    
  [toolbar setAllowsUserCustomization: YES];
  [toolbar setDelegate: self];
  [window setToolbar: toolbar];
  
  [popUpMenuDisplay setAutoenablesItems: NO];
  [popUpMenuSize setAutoenablesItems: NO];
    
  [popUpMenuDisplay addItemWithTitle: @"Default"];
  [[popUpMenuDisplay itemWithTitle: @"Default"] setEnabled: YES];
  [[popUpMenuDisplay itemWithTitle: @"Default"] 
    setTag: NSToolbarDisplayModeDefault];
  [popUpMenuDisplay addItemWithTitle: @"Icon and label"];
  [[popUpMenuDisplay itemWithTitle: @"Icon and label"] setEnabled: YES];
  [[popUpMenuDisplay itemWithTitle: @"Icon and label"] 
    setTag: NSToolbarDisplayModeIconAndLabel];
  [popUpMenuDisplay addItemWithTitle: @"Icon only"];
  [[popUpMenuDisplay itemWithTitle: @"Icon only"] setEnabled: YES];
  [[popUpMenuDisplay itemWithTitle: @"Icon only"] 
    setTag: NSToolbarDisplayModeIconOnly];
  [popUpMenuDisplay addItemWithTitle: @"Text only"];
  [[popUpMenuDisplay itemWithTitle: @"Text only"] setEnabled: YES]; 
  [[popUpMenuDisplay itemWithTitle: @"Text only"] 
    setTag: NSToolbarDisplayModeLabelOnly];
    
  [popUpMenuSize addItemWithTitle: @"Default"];
  [[popUpMenuSize itemWithTitle: @"Default"] setEnabled: YES];
  [[popUpMenuSize itemWithTitle: @"Default"] 
    setTag: NSToolbarSizeModeDefault];
  [popUpMenuSize addItemWithTitle: @"Regular"];
  [[popUpMenuSize itemWithTitle: @"Regular"] setEnabled: YES];
  [[popUpMenuSize itemWithTitle: @"Regular"] 
    setTag: NSToolbarSizeModeRegular];
  [popUpMenuSize addItemWithTitle: @"Small"];
  [[popUpMenuSize itemWithTitle: @"Small"] setEnabled:YES];
  [[popUpMenuSize itemWithTitle: @"Small"] 
    setTag: NSToolbarSizeModeSmall];
 	
  item = [popUpMenuDisplay itemWithTitle: @"Default"];
  [popUpMenuDisplay selectItem: item];
  
  item = [popUpMenuSize itemWithTitle:@"Default"];
  [popUpMenuSize selectItem: item];
  
  [popUpMenuDisplay setAction: @selector(popUpMenuDisplayChanged:)];
  [popUpMenuSize setAction: @selector(popUpMenuSizeChanged:)];
}

// Toolbar delegates

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString*)identifier
 willBeInsertedIntoToolbar:(BOOL)willBeInserted 
{
  NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc]
    initWithItemIdentifier:identifier] autorelease];

  NSLog(@"toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar: \
    has been called");

  if ([identifier isEqual: @"First"]) 
    {
      [toolbarItem setLabel: @"First item"];
      [toolbarItem setImage: [NSImage imageNamed: @"FileIcon_Directory"]];
      [toolbarItem setTarget: firstItemSwitch];
      [toolbarItem setAction: @selector(performClick:)];
    }
  else if ([identifier isEqual:@"Second"]) 
    {
      [toolbarItem setLabel: @"Second item"];
      [toolbarItem setImage: [NSImage imageNamed: @"SecondImage"]];
      if (toolbar == [window toolbar])
        {
          [toolbarItem setTarget: window];
          [toolbarItem setAction: @selector(toggleToolbarShown:)];
        }
    }
  else if ([identifier isEqual:@"Popup"]) 
    {
      NSPopUpButton *popup = [[NSPopUpButton alloc] initWithFrame: 
        NSMakeRect(0, 0, 150, 22)];
      id item;
      NSMenuItem *menuItem;
      NSMenu *submenu;

      [popup setAction: @selector(reflectMenuSelection:)];
      [popup setAutoenablesItems: NO];
    
      [popup addItemWithTitle: @"Marguerite"];
      [[popup itemWithTitle: @"Marguerite"] setEnabled: YES];
      [popup addItemWithTitle: @"Julie"];
      [[popup itemWithTitle: @"Julie"] setEnabled: YES];
      [popup addItemWithTitle: @"Liv"];
      [[popup itemWithTitle: @"Liv"] setEnabled: YES];
      [popup addItemWithTitle: @"Juliette"];
      [[popup itemWithTitle: @"Juliette"] setEnabled: YES];
	
      item = [popup itemWithTitle: @"Liv"];
      [popup selectItem:item];
      [[NSApplication sharedApplication] sendAction: [popup action] 
                                                 to: self 
                                               from: popup];
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
      [toolbarItem setLabel: [newItemName stringValue]];
      [toolbarItem setView: [[NSSlider alloc] initWithFrame: 
        NSMakeRect(0, 0, 120, 18)]];
      if (toolbar == [window toolbar])
        {
          [(NSControl *)[toolbarItem view] setTarget: sliderField];
          [(NSControl *)[toolbarItem view]
            setAction: @selector(takeStringValueFrom:)];
        }
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

- (void) toggleToolbar: (id)sender
{
  [window toggleToolbarShown: self];
}

- (void) setFirstItemLabel: (id)sender 
{
  NSEnumerator *e = [[[window toolbar] items] objectEnumerator];
  id item;
  
  while ((item = [e nextObject]) != nil)
    {
      if ([[item itemIdentifier] isEqualToString: @"First"])
        {
          [item setLabel:[sender stringValue]];
          return;
        }
    }
}

- (void) setSecondItemImage: (id)sender
{
  NSEnumerator *e = [[[window toolbar] items] objectEnumerator];
  id item;
  NSImage *image;
  NSOpenPanel *op = [NSOpenPanel openPanel];
  int code;
  
  code = [op runModal];
  
  if (code != NSOKButton) return;
  
  image = [[NSImage alloc] initWithContentsOfFile: [op filename]]; 
  
  while ((item = [e nextObject]) != nil)
    {
      if ([[item itemIdentifier] isEqualToString: @"Second"])
        {
          [item setImage:image];
          return;
        }
    }
  
  RELEASE(image);
}

- (void) newItem:(id)sender
{
  [[window toolbar] insertItemWithItemIdentifier: @"Slider"
                                         atIndex: 2]; 
} 

- (void) popUpMenuDisplayChanged: (id)sender {
  [[window toolbar] setDisplayMode: [[sender selectedItem] tag]]; 
}

- (void) popUpMenuSizeChanged: (id)sender
{
  [[window toolbar] setSizeMode: [[sender selectedItem] tag]];
}

- (void) newWindow: (id)sender
{
  MiniController *otherController = [[MiniController alloc] init];
  NSWindow *otherWindow;
  NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier: @"myToolbar"];
  
  [NSBundle loadNibNamed: @"SecondWindow.gorm" owner: otherController];
  
  otherWindow = [otherController window];
  [otherWindow setToolbar: toolbar];
  [otherWindow makeKeyAndOrderFront: self];
}

- (void) reflectMenuSelection:(id)sender
{  
   if ([sender isKindOfClass:[NSPopUpButton class]])
     {
       [popUpField setStringValue:[sender titleOfSelectedItem]];
     }
   else if ([sender isKindOfClass: [NSMenuItem class]])
     {
       [popUpField setStringValue: [sender title]];
     }
}

@end
