/* memoryPanel.m                                           -*-objc-*-

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

#include "MemoryPanel.h"
#include <AppKit/GSVbox.h>

/*
 * Internal private class used in reordering entries.
 *
 */
@interface MemoryPanelEntry : NSObject
{
  NSString *string;
  NSNumber *number;
}
- (id) initWithString: (NSString *)aString  number: (int)aNumber;
- (NSString *) string;
- (NSNumber *) number;
- (NSComparisonResult) compareByNumber: (MemoryPanelEntry *)aEntry;
- (NSComparisonResult) compareByAlphabet: (MemoryPanelEntry *)aEntry;
@end

@implementation MemoryPanelEntry

- (id) initWithString: (NSString *)aString  number: (int)aNumber
{
  ASSIGN (string, aString);
  ASSIGN (number, [NSNumber numberWithInt: aNumber]);
  return self;
}

- (void) dealloc
{
  RELEASE (string);
  RELEASE (number);
  [super dealloc];
}

- (NSString *) string
{
  return string;
}

- (NSNumber *) number
{
  return number;
}

- (NSComparisonResult) compareByNumber: (MemoryPanelEntry *)aEntry
{
  NSComparisonResult comparison = [number compare: aEntry->number];
  /* invert comparison */
  if (comparison == NSOrderedAscending)
    {
      comparison = NSOrderedDescending;
    }
  else if (comparison == NSOrderedDescending)
    {
      comparison = NSOrderedAscending;
    }

  return comparison;
}

- (NSComparisonResult) compareByAlphabet: (MemoryPanelEntry *)aEntry
{
  return [string compare: aEntry->string];
}

@end

/*
 * The Memory Panel code
 */

static MemoryPanel *mp = nil;

@implementation MemoryPanel
+ (id) sharedMemoryPanel
{
  if (mp == nil)
    {
      mp = [MemoryPanel new];
    }

  return mp;
}

- (id) init
{
  NSRect winFrame;
  NSTableColumn *classColumn;
  NSTableColumn *numberColumn;  
  NSScrollView *scrollView;
  GSVbox *vbox;

  /* Activate debugging of allocation */
  GSDebugAllocationActive (YES);

  classColumn = [[NSTableColumn alloc] initWithIdentifier: @"Class"];
  AUTORELEASE (classColumn);
  [classColumn setEditable: NO];
  [[classColumn headerCell] setStringValue: @"Class Name"];
  [classColumn setMinWidth: 200];

  numberColumn = [[NSTableColumn alloc] initWithIdentifier: @"Number"];
  AUTORELEASE (numberColumn);
  [numberColumn setEditable: NO];
  [[numberColumn headerCell] setStringValue: @"Number of Objects"];
  [numberColumn setMinWidth: 50];

  table = [[NSTableView alloc] initWithFrame: NSMakeRect (0, 0, 300, 300)];
  [table addTableColumn: classColumn];
  [table addTableColumn: numberColumn];
  [table setDataSource: self];
  [table setDelegate: self];
  [table setDoubleAction: @selector (reorder:)];
  
  scrollView = [[NSScrollView alloc] 
	       initWithFrame: NSMakeRect (0, 0, 350, 300)];
  [scrollView setDocumentView: table];
  RELEASE (table);
  [scrollView setHasHorizontalScroller: YES];
  [scrollView setHasVerticalScroller: YES];
  [scrollView setBorderType: NSBezelBorder];
  [scrollView setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  [table sizeToFit];
 
  vbox = [GSVbox new];
  [vbox setDefaultMinYMargin: 5];
  [vbox setBorder: 5];
  [vbox addView: scrollView];
  
  winFrame.size = [vbox frame].size;
  winFrame.origin = NSMakePoint (100, 200);
  
  self = [super initWithContentRect: winFrame
	 styleMask: (NSTitledWindowMask 
		     | NSClosableWindowMask 
		     | NSMiniaturizableWindowMask 
		     | NSResizableWindowMask)
	 backing: NSBackingStoreBuffered
	 defer: NO];
  
  [self setReleasedWhenClosed: NO];
  [self setContentView: vbox];
  RELEASE (vbox);
  [self setTitle: @"Memory Panel"];
  
  return self;
}

- (int) numberOfRowsInTableView: (NSTableView *)aTableView
{
  return [numberArray count];
}

- (id)           tableView: (NSTableView *)aTableView 
 objectValueForTableColumn: (NSTableColumn *)aTableColumn 
		       row:(int)rowIndex
{
  if ([[aTableColumn identifier] isEqual: @"Class"])
    {
      return [classArray objectAtIndex: rowIndex];
    }
  else if ([[aTableColumn identifier] isEqual: @"Number"])
    {
      return [numberArray objectAtIndex: rowIndex];
    }

  NSLog (@"Hi, I am a bug in your table view");

  return @"";
}

- (void) update: (id)sender
{
  /* NB: We rely on GSDebugAllocationList format to parse it */
  const char *allocationList = GSDebugAllocationList (NO);
  NSString *string = [NSString stringWithCString: allocationList];
  NSScanner *scanner = [NSScanner scannerWithString: string];
  NSMutableArray *array = [NSMutableArray new];
  NSArray *array_imm;
  MemoryPanelEntry *entry;
  int number;
  NSString *className;
  static NSCharacterSet *space = nil;
  NSMutableArray *classes = [NSMutableArray new];
  NSMutableArray *numbers = [NSMutableArray new];
  int count, i;

  if (space == nil)
    {
      space = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    }

  while ([scanner isAtEnd] == NO)
    {
      /* Skip spaces */
      [scanner scanCharactersFromSet: space  intoString: NULL];
      /* Get number */
      if ([scanner scanInt: &number] == NO)
	{
	  break;
	}
      /* Skip spaces */
      [scanner scanCharactersFromSet: space  intoString: NULL];
      /* Get class name */
      if ([scanner scanUpToCharactersFromSet: space
		   intoString: &className] == NO)
	{
	  break;
	}
      /* Insert into array */
      entry = [MemoryPanelEntry alloc];
      [entry initWithString: className  number: number];
      [array addObject: entry];
      RELEASE (entry);
    }
  
  if (orderingByNumber == YES)
    {
      array_imm = [array sortedArrayUsingSelector: @selector(compareByNumber:)];
    }
  else
    {
      array_imm = [array sortedArrayUsingSelector: @selector(compareByAlphabet:)];
    }
  
  RELEASE (array);

  count = [array_imm count];
  for (i = 0; i < count; i++)
    {
      entry = [array_imm objectAtIndex: i];
      [numbers addObject: [entry number]];
      [classes addObject: [entry string]];
    }

  ASSIGN (classArray, classes);
  RELEASE (classes);

  ASSIGN (numberArray, numbers);
  RELEASE (numbers);

  [table reloadData];
}

- (void) reorder: (id)sender
{
  int selectedColumn = [table clickedColumn];
  NSArray *tableColumns = [table tableColumns];
  NSTableColumn *tb;
  BOOL newFlag = YES;

  if (selectedColumn == -1)
    {
      return;
    }

  tb = [tableColumns objectAtIndex: selectedColumn];

  if ([[tb identifier] isEqual: @"Class"])
    {
      newFlag = NO;
    }
  else if ([[tb identifier] isEqual: @"Number"])
    {
      newFlag = YES;
    }

  if (orderingByNumber == newFlag)
    {
      return;
    }
  else
    {
      orderingByNumber = newFlag;
      [self update: self];
    }
}

@end

@implementation NSApplication (memoryPanel)

- (void) orderFrontSharedMemoryPanel: (id)sender
{
  MemoryPanel *memoryPanel;

  memoryPanel = [MemoryPanel sharedMemoryPanel];
  [memoryPanel update: self];
  [memoryPanel orderFront: self];
}


@implementation NSMenu (memoryPanel)
- (void) addMemoryPanelSubmenu
{
  NSMenuItem *menuItem;
  NSMenu *memoryMenu;

  menuItem = [self addItemWithTitle: @"Memory" 
	     action: NULL 
	     keyEquivalent: @""];
  memoryMenu = AUTORELEASE ([NSMenu new]);
  [self setSubmenu: memoryMenu forItem: menuItem];
  
  [memoryMenu addItemWithTitle: @"Run Memory Panel..." 
	      action: @selector (orderFrontSharedMemoryPanel:) 
	      keyEquivalent: @""];
  menuItem = [memoryMenu addItemWithTitle: @"Update Memory Panel" 
			 action: @selector (update:)
			 keyEquivalent: @""];
  [menuItem setTarget: [MemoryPanel sharedMemoryPanel]];
}
@end
