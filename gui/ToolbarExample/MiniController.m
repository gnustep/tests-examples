/*
 *  MiniController.m: An application to demonstrate the GNUstep toolbars 
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

#include <AppKit/AppKit.h>
#include <GNUstepGUI/GSToolbarView.h>
#include <GNUstepGUI/GSToolbar.h>
#include "MiniController.h"

@implementation MiniController

- (void)awakeFromNib
{
  NSLog(@"Nib loaded with window");
  
  otherToolbar = [[GSToolbar alloc] initWithIdentifier: @"blablaToolbar"];
  
  if ([otherToolbar delegate] == nil)
    [otherToolbar setDelegate: self];
  
  [otherToolbarView setBorderMask: GSToolbarViewTopBorder 
                                 | GSToolbarViewBottomBorder
				 | GSToolbarViewRightBorder
				 | GSToolbarViewLeftBorder];
  [(GSToolbarView *)otherToolbarView setToolbar: otherToolbar];
  // We do a cast to eliminate a warning... should be a better way to fix that
}

- (void)dealloc
{
  RELEASE(otherToolbar);
}

// Toolbar delegates

- (NSToolbarItem *)toolbar: (GSToolbar *)toolbar itemForItemIdentifier: (NSString *)identifier 
                                             willBeInsertedIntoToolbar: (BOOL)willBeInserted 
{
  NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier: identifier];

  NSLog(@"toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar: has been called");
  
  AUTORELEASE(toolbarItem);

  if ([identifier isEqual: @"Third"]) 
    {
      [toolbarItem setLabel: @"Yet another item"];
      [toolbarItem setImage: [NSImage imageNamed: @"RecyclerFull"]];
      [toolbarItem setTarget: window];
      [toolbarItem setAction: @selector(toggleToolbarShown:)];
    }

  return toolbarItem;
}

- (NSArray *)toolbarDefaultItemIdentifiers: (GSToolbar *)toolbar {
  NSLog(@"toolbarDefaultItemIdentifiers: has been called");

  return [NSArray arrayWithObjects: @"Third", 
                                    NSToolbarShowFontsItemIdentifier, 
				    NSToolbarShowColorsItemIdentifier,  
				    nil];
}

- (NSArray *)toolbarAllowedItemIdentifiers: (GSToolbar *)toolbar {
  NSLog(@"toolbarAllowedItemIdentifiers: has been called"); 
    
  return [NSArray arrayWithObjects: @"Third", 
                                    NSToolbarShowFontsItemIdentifier,
	                            NSToolbarShowColorsItemIdentifier,  
				    nil];
}

// ---

- (void)removeItem: (id)sender
{
  [otherToolbar removeItemAtIndex: [itemIndexField intValue]];
}

- (NSWindow *)window 
{
  return window;
}

@end
