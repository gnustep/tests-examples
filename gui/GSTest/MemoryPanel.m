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

enum {
  OrderByClassName,
  OrderByCount,
  OrderByTotal,
  OrderByPeak
};

static inline NSComparisonResult 
invertComparison (NSComparisonResult comparison)
{
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

/*
 * Internal private class used in reordering entries.
 *
 */
@interface MemoryPanelEntry : NSObject
{
  NSString *string;
  NSNumber *count;
  NSNumber *total;
  NSNumber *peak;
}
- (id) initWithString: (NSString *)aString  
		count: (int)aCount
		total: (int)aTotal   
		 peak: (int)aPeak;
- (NSString *) string;
- (NSNumber *) count;
- (NSNumber *) total;
- (NSNumber *) peak;
- (NSComparisonResult) compareByTotal: (MemoryPanelEntry *)aEntry;
- (NSComparisonResult) compareByCount: (MemoryPanelEntry *)aEntry;
- (NSComparisonResult) compareByPeak: (MemoryPanelEntry *)aEntry;
- (NSComparisonResult) compareByClassName: (MemoryPanelEntry *)aEntry;
@end

@implementation MemoryPanelEntry

- (id) initWithString: (NSString *)aString  
		count: (int)aCount
		total: (int)aTotal   
		 peak: (int)aPeak
{
  ASSIGN (string, aString);
  ASSIGN (count, [NSNumber numberWithInt: aCount]);
  ASSIGN (total, [NSNumber numberWithInt: aTotal]);
  ASSIGN (peak, [NSNumber numberWithInt: aPeak]);
  return self;
}

- (void) dealloc
{
  RELEASE (string);
  RELEASE (count);
  RELEASE (total);  
  RELEASE (peak);
  [super dealloc];
}

- (NSString *) string
{
  return string;
}

- (NSNumber *) count
{
  return count;
}

- (NSNumber *) total
{
  return total;
}

- (NSNumber *) peak
{
  return peak;
}

- (NSComparisonResult) compareByCount: (MemoryPanelEntry *)aEntry
{
  NSComparisonResult comparison = [count compare: aEntry->count];

  return invertComparison (comparison);
}

- (NSComparisonResult) compareByTotal: (MemoryPanelEntry *)aEntry
{
  NSComparisonResult comparison = [total compare: aEntry->total];

  return invertComparison (comparison);
}

- (NSComparisonResult) compareByPeak: (MemoryPanelEntry *)aEntry
{
  NSComparisonResult comparison = [peak compare: aEntry->peak];

  return invertComparison (comparison);
}

- (NSComparisonResult) compareByClassName: (MemoryPanelEntry *)aEntry
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

+ (void) update: (id)sender
{
  [[self sharedMemoryPanel] update: sender];
}

- (id) init
{
  NSRect winFrame;
  NSTableColumn *classColumn;
  NSTableColumn *countColumn;  
  NSTableColumn *totalColumn;
  NSTableColumn *peakColumn;  
  NSScrollView *scrollView;
  GSVbox *vbox;

  /* Activate debugging of allocation. */
  GSDebugAllocationActive (YES);

  /* Ordering by number of objects by default */
  orderingBy = OrderByCount;

  classColumn = [[NSTableColumn alloc] initWithIdentifier: @"Class"];
  AUTORELEASE (classColumn);
  [classColumn setEditable: NO];
  [[classColumn headerCell] setStringValue: @"Class Name"];
  [classColumn setMinWidth: 200];

  countColumn = [[NSTableColumn alloc] initWithIdentifier: @"Count"];
  AUTORELEASE (countColumn);
  [countColumn setEditable: NO];
  [[countColumn headerCell] setStringValue: @"Current"];
  [countColumn setMinWidth: 50];

  totalColumn = [[NSTableColumn alloc] initWithIdentifier: @"Total"];
  AUTORELEASE (totalColumn);
  [totalColumn setEditable: NO];
  [[totalColumn headerCell] setStringValue: @"Total"];
  [totalColumn setMinWidth: 50];

  peakColumn = [[NSTableColumn alloc] initWithIdentifier: @"Peak"];
  AUTORELEASE (peakColumn);
  [peakColumn setEditable: NO];
  [[peakColumn headerCell] setStringValue: @"Peak"];
  [peakColumn setMinWidth: 50];

  table = [[NSTableView alloc] initWithFrame: NSMakeRect (0, 0, 300, 300)];
  [table addTableColumn: classColumn];
  [table addTableColumn: countColumn];
  [table addTableColumn: totalColumn];
  [table addTableColumn: peakColumn];
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
  return [countArray count];
}

- (id)           tableView: (NSTableView *)aTableView 
 objectValueForTableColumn: (NSTableColumn *)aTableColumn 
		       row:(int)rowIndex
{
  id identifier = [aTableColumn identifier];

  if ([identifier isEqual: @"Class"])
    {
      return [classArray objectAtIndex: rowIndex];
    }
  else if ([identifier isEqual: @"Count"])
    {
      return [countArray objectAtIndex: rowIndex];
    }
  else if ([identifier isEqual: @"Total"])
    {
      return [totalArray objectAtIndex: rowIndex];
    }
  else if ([identifier isEqual: @"Peak"])
    {
      return [peakArray objectAtIndex: rowIndex];
    }

  NSLog (@"Hi, I am a bug in your table view");

  return @"";
}

- (void) update: (id)sender
{
  Class *classList = GSDebugAllocationClassList ();
  Class *pointer;
  NSMutableArray *array = [NSMutableArray new];
  NSArray *array_imm;
  SEL orderSel = NULL;
  MemoryPanelEntry *entry;
  int i, count, total, peak;
  NSString *className;
  NSMutableArray *classes = [NSMutableArray new];
  NSMutableArray *counts = [NSMutableArray new];
  NSMutableArray *totals = [NSMutableArray new];
  NSMutableArray *peaks = [NSMutableArray new];

  pointer = classList;
  i = 0;

  while (pointer[i] != NULL)
    {
      className = NSStringFromClass (pointer[i]);
      count = GSDebugAllocationCount (pointer[i]);
      total = GSDebugAllocationTotal (pointer[i]);
      peak = GSDebugAllocationPeak (pointer[i]);
      
      /* Insert into array */
      entry = [MemoryPanelEntry alloc];
      [entry initWithString: className  count: count  
	     total: total  peak: peak];
      [array addObject: entry];
      RELEASE (entry);
      i++;
    }

  switch (orderingBy)
    {
    case (OrderByClassName): 
      orderSel = @selector(compareByClassName:); 
      break;
    case (OrderByCount): 
      orderSel = @selector(compareByCount:);
      break;
    case (OrderByTotal): 
      orderSel = @selector(compareByTotal:);
      break;
    case (OrderByPeak): 
      orderSel = @selector(compareByPeak:);
      break;
    }
  
  array_imm = [array sortedArrayUsingSelector: orderSel];
  RELEASE (array);

  count = [array_imm count];
  for (i = 0; i < count; i++)
    {
      entry = [array_imm objectAtIndex: i];
      [counts addObject: [entry count]];
      [totals addObject: [entry total]];
      [peaks addObject: [entry peak]];
      [classes addObject: [entry string]];
    }

  ASSIGN (classArray, classes);
  RELEASE (classes);

  ASSIGN (countArray, counts);
  RELEASE (counts);

  ASSIGN (totalArray, totals);
  RELEASE (totals);

  ASSIGN (peakArray, peaks);
  RELEASE (peaks);

  [table reloadData];
}

- (void) reorder: (id)sender
{
  int selectedColumn = [table clickedColumn];
  NSArray *tableColumns = [table tableColumns];
  id identifier;
  int newOrderingBy = 0;

  if (selectedColumn == -1)
    {
      return;
    }

  identifier = [[tableColumns objectAtIndex: selectedColumn] identifier];

  if ([identifier isEqual: @"Class"])
    {
      newOrderingBy = OrderByClassName;
    }
  else if ([identifier isEqual: @"Count"])
    {
      newOrderingBy = OrderByCount;
    }
  else if ([identifier isEqual: @"Total"])
    {
      newOrderingBy = OrderByTotal;
    }
  else if ([identifier isEqual: @"Peak"])
    {
      newOrderingBy = OrderByPeak;
    }

  if (newOrderingBy == orderingBy)
    {
      return;
    }
  else
    {
      orderingBy = newOrderingBy;
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
  [menuItem setTarget: [MemoryPanel class]];
}
@end
