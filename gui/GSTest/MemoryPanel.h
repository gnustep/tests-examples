/* MemoryPanel.h                                           -*-objc-*-

   A GNUstep panel for tracking memory leaks.

   Copyright (C) 2000 Free Software Foundation, Inc.

   Author:  Nicola Pero <nicola@brainstorm.co.uk>
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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */

/*
 * Class displaying a panel showing object allocation statistics.
 *
 */

#ifndef MEMORY_PANEL_H
#define MEMORY_PANEL_H

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

@interface MemoryPanel: NSPanel
{
  NSTableView *table;
  NSMutableArray *classArray;
  NSMutableArray *numberArray;
  /* YES if we are ordering the entries of the table by number of
     instances; NO if we are ordering the entries in the table
     alphabetically by class name */
  BOOL orderingByNumber;
}
+ (id) sharedMemoryPanel;
/* Updates the statistics */
+ (void) update: (id)sender;
- (void) update: (id)sender;
@end

@interface NSApplication (memoryPanel)
- (void) orderFrontSharedMemoryPanel: (id)sender;
@end

@interface NSMenu (memoryPanel)
- (void) addMemoryPanelSubmenu;
@end

#endif // MEMORY_PANEL_H

