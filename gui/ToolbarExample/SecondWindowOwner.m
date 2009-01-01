/*
 *  SecondWindowOwner.m: An application to demonstrate the GNUstep toolbars 
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

#include "SecondWindowOwner.h"
#include <GNUstepGUI/GSToolbarView.h>

@implementation SecondWindowOwner

- (void) awakeFromNib
{
  NSToolbar *otherToolbar;
  
  //NSLog(@"Nib loaded with window");
  
  otherToolbar = [[NSToolbar alloc] initWithIdentifier: @"blablaToolbar"];
  //NSLog(@"Mini controller delegate %@", self);
  
  [otherToolbar setDelegate: self];
  
  [otherToolbarView setBorderMask: GSToolbarViewTopBorder 
                    | GSToolbarViewBottomBorder
                    | GSToolbarViewRightBorder
                    | GSToolbarViewLeftBorder];
  [(GSToolbarView *)otherToolbarView setToolbar: otherToolbar];
  // We do a cast to eliminate a warning...
  
  RELEASE(otherToolbar);  
}

// Toolbar delegates

- (NSToolbarItem *) toolbar: (NSToolbar *)toolbar 
      itemForItemIdentifier: (NSString *)identifier 
  willBeInsertedIntoToolbar: (BOOL)willBeInserted 
{
  NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier: identifier];

  //NSLog(@"toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar: has been called");
  
  if ([identifier isEqual: @"Third"])
    {
      [toolbarItem setLabel: @"Validation example"];
      [toolbarItem setImage: [NSImage imageNamed:@"RecyclerFull"]];
      [toolbarItem setTarget: buttonWithValidation];
      [toolbarItem setAction: @selector(performClick:)];
    }
  else if ([identifier isEqual: @"Four"]) 
    {
      [toolbarItem setLabel: @"Yet another item"];
      [toolbarItem setImage: [NSImage imageNamed: @"RecyclerFull"]];
      [toolbarItem setTarget: window];
      [toolbarItem setAction: @selector(toggleToolbarShown:)];
    }

  return AUTORELEASE(toolbarItem);
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *)toolbar
{
  //NSLog(@"toolbarDefaultItemIdentifiers: has been called");

  return [NSArray arrayWithObjects: @"Third",
                                    @"Four", 
                                    NSToolbarShowFontsItemIdentifier, 
				    NSToolbarShowColorsItemIdentifier,  
				    nil];
}

- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar *)toolbar
{
  //NSLog(@"toolbarAllowedItemIdentifiers: has been called"); 
    
  return [NSArray arrayWithObjects: @"Third", 
                                    @"Four",
                                    NSToolbarShowFontsItemIdentifier,
	                            NSToolbarShowColorsItemIdentifier,  
				    nil];
}

- (NSArray *) toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar
{
  //NSLog(@"toolbarSelectableItemIdentifiers: has been called");
  
  return [NSArray arrayWithObjects: @"Third", 
                                    NSToolbarShowFontsItemIdentifier,  
				    nil];
}

// ---

- (void) removeItem: (id)sender
{
  [[otherToolbarView toolbar] removeItemAtIndex: [itemIndexField intValue]];
}

- (NSWindow *) window 
{
  return window;
}

- (void) windowClose: (NSNotification *)notification
{
  [[NSNotificationCenter defaultCenter] removeObserver: self];
  AUTORELEASE(self);
}

@end
