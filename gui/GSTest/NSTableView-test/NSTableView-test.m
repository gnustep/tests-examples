/* NSTableView-test.m: NSTableView Class Demo/Test

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: March 2000
   
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
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

static NSString *NSTableViewTestPboardType = @"NSTableViewTestPboardType";

static NSArray *draggedRows;

// Something to show in the table
static NSString *keys[20] = 
{ 
  @"From",
  @"Reply-To",
  @"To", 
  @"Cc",
  @"Bcc", 
  @"Newsgrps",
  @"Fcc",
  @"Lcc",
  @"Attchmnt",
  @"Subject",
  @"More (A)",
  @"More (B)",
  @"More (C)",
  @"More (D)",
  @"More (E)",
  @"More (F)",
  @"More (G)",
  @"More (H)",
  @"More (I)",
  @"More (J)"
}; 
static NSString *values[20] = 
{ 
  @"Nicola Pero <n.pero@mi.flashnet.it>",
  @"Nicola Pero <n.pero@mi.flashnet.it>",
  @"richard@brainstorm.co.uk",
  @"ettore@helixcode.com",
  @"", 
  @"",
  @"Sent Mail",  
  @"",  
  @"test_app.tgz",
  @"Test mail",
  @"Info (A)",
  @"Info (B)",
  @"Info (C)",
  @"Info (D)",
  @"Info (E)",
  @"Info (F)",
  @"Info (G)",
  @"Info (H)",
  @"Info (I)",
  @"Info (J)"
};
static NSString *test[20] = 
{ 
  @"Other info (1)",
  @"Other info (2)",
  @"Other info (3)",
  @"Other info (4)",
  @"Other info (5)",
  @"Other info (6)",
  @"Other info (7)",
  @"Other info (8)",
  @"Other info (9)",
  @"Other info (10)",
  @"Other info (11)",
  @"Other info (12)",
  @"Other info (13)",
  @"Other info (14)",
  @"Other info (15)",
  @"Other info (16)",
  @"Other info (17)",
  @"Other info (18)",
  @"Other info (19)",
  @"Other info (20)"
};
//
@interface NSTableViewTest: NSObject <GSTest>
{
  NSWindow *win;
  NSMutableArray *keysArray;
  NSMutableArray *valuesArray;
  NSMutableArray *testArray;
}
-(void) restart;
- (int) numberOfRowsInTableView: (NSTableView *)aTableView;
- (id)           tableView: (NSTableView *)aTableView 
 objectValueForTableColumn: (NSTableColumn *)aTableColumn 
		       row:(int)rowIndex;
- (void) tableView: (NSTableView *)aTableView 
   willDisplayCell: (id)aCell 
    forTableColumn: (NSTableColumn *)aTableColumn
	       row: (int)rowIndex;
@end

@implementation NSTableViewTest: NSObject

-(id) init
{
  NSBox *externalBox;
  NSTableView *tableView;
  NSRect winFrame;
  NSTableColumn *keyColumn;
  NSTableColumn *valueColumn;  
  NSTableColumn *testColumn;
  NSTableColumn *tb;
  NSScrollView *scrollView;
  int i;
  NSString *string;
  NSCell *cell;

  keysArray = [[NSMutableArray alloc] initWithObjects: keys
				      count:20];

  valuesArray = [[NSMutableArray alloc] initWithObjects: values
					count:20];

  testArray = [[NSMutableArray alloc] initWithObjects: test
				      count:20];

  keyColumn = [[NSTableColumn alloc] initWithIdentifier: @"key"];
  AUTORELEASE (keyColumn);
  [keyColumn setEditable: NO];
  [[keyColumn headerCell] setStringValue: @"key"];
  [keyColumn setMinWidth: 100];

  valueColumn = [[NSTableColumn alloc] initWithIdentifier: @"value"];
  AUTORELEASE (valueColumn);
  [valueColumn setEditable: NO];
  [[valueColumn headerCell] setStringValue: @"value"];
  [valueColumn setMinWidth: 100];

  testColumn = [[NSTableColumn alloc] initWithIdentifier: @"test"];
  AUTORELEASE (testColumn);
  [testColumn setEditable: NO];
  [[testColumn headerCell] setStringValue: @"test"];
  [testColumn setMinWidth: 70];

  tableView = [[NSTableView alloc] 
		 initWithFrame: NSMakeRect (0, 0, 300, 300)];
  [tableView addTableColumn: keyColumn];
  [tableView addTableColumn: valueColumn];
  [tableView addTableColumn: testColumn];
  //  [tableView setAutoresizesAllColumnsToFit: YES];
  [tableView setAllowsMultipleSelection: YES];

  /* column with selectable but not editable cell */  
  string = @"Selectable";
  tb = AUTORELEASE ([[NSTableColumn alloc] initWithIdentifier: string]);
  [tb setEditable: YES];
  [tb setMinWidth: 50];
  [tb setMaxWidth: 400];
  [[tb headerCell] setStringValue: string];
 
  cell = [tb dataCell];
  [cell setSelectable: YES];
  [cell setEditable: YES];
  [tb setDataCell: cell];
  NSLog(@"data cell %@", cell);
  [tableView addTableColumn: tb];

  /* Now add some more columns */
  for (i = 1; i < 5; i++)
    {
      string = [NSString stringWithFormat: @"Column %d", i];
      tb = AUTORELEASE ([[NSTableColumn alloc] initWithIdentifier: string]);
      [tb setEditable: NO];
      [tb setMinWidth: 50];
      [tb setMaxWidth: 400];
      [[tb headerCell] setStringValue: string];
      [tableView addTableColumn: tb];
    }
  [tableView setDataSource: self];
  [tableView setDelegate: self];

  /* The following are to have a table without headers */
  //[tableView setHeaderView: nil];
  //[tableView setCornerView: nil];

  scrollView = [[NSScrollView alloc] 
		 initWithFrame: NSMakeRect (0, 0, 300, 200)];
  [scrollView setDocumentView: tableView];
  RELEASE (tableView);
  [scrollView setHasHorizontalScroller: YES];
  [scrollView setHasVerticalScroller: YES];
  [scrollView setBorderType: NSBezelBorder];
  [scrollView setAutoresizingMask: (NSViewWidthSizable 
				    | NSViewHeightSizable)];
	 

  externalBox = [NSBox new];
  [externalBox setTitlePosition: NSNoTitle];
  [externalBox setBorderType: NSNoBorder];
  [externalBox addSubview: scrollView];
  RELEASE (scrollView);
  [externalBox sizeToFit];
  [externalBox setAutoresizingMask: (NSViewWidthSizable 
				     | NSViewHeightSizable)];
  
  winFrame.size = [externalBox frame].size;
  winFrame.origin = NSMakePoint (100, 200);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  
  [win setReleasedWhenClosed: NO];
  [win setContentView: externalBox];
  RELEASE (externalBox);
  [win setTitle: @"NSTableView Test"];
  
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSTableView Test"
				     filename: NO];

  [tableView registerForDraggedTypes: 
	       [NSArray arrayWithObject: NSTableViewTestPboardType]];

  return self;
}

-(void) dealloc
{
  RELEASE(win);
  RELEASE(keysArray);
  RELEASE(valuesArray);
  RELEASE(testArray);
  [super dealloc];
}
-(void) restart
{
  [[self class] new];
  //  [win orderFront: nil]; 
}

- (int) numberOfRowsInTableView: (NSTableView *)aTableView
{
  return [keysArray count];
}

- (id)           tableView: (NSTableView *)aTableView 
 objectValueForTableColumn: (NSTableColumn *)aTableColumn 
		       row:(int)rowIndex
{
  if (rowIndex < 0 || rowIndex >= (int)[keysArray count])
    {
      NSLog (@"BUG: We were asked for rowIndex: %d", rowIndex);
      return nil;
    }

  if (aTableColumn == nil)
    {
      NSLog (@"BUG: We were asked with nil tableColumn");
      return nil;
    }

  if ([(NSString *)[aTableColumn identifier] isEqual: @"key"])
    return [keysArray objectAtIndex: rowIndex];
  else if ([(NSString *)[aTableColumn identifier] isEqual: @"value"])
    return [valuesArray objectAtIndex: rowIndex];
  else if ([(NSString *)[aTableColumn identifier] isEqual: @"test"])
    return [testArray objectAtIndex: rowIndex];
  else 
    return [testArray objectAtIndex: rowIndex];
}

- (void) tableView: (NSTableView *)aTableView 
   willDisplayCell: (id)aCell 
    forTableColumn: (NSTableColumn *)aTableColumn
	       row: (int)rowIndex
{
  if (rowIndex == 9)
    [aCell setFont: [NSFont boldSystemFontOfSize: 0]];
  else
    [aCell setFont: [NSFont systemFontOfSize: 0]];
}

- (BOOL) tableView: (NSTableView *)aTableView
	 writeRows: (NSArray *) rows
      toPasteboard: (NSPasteboard *) pboard
{
  NSMutableArray *propertyList;
  unsigned int i;

  draggedRows = RETAIN(rows);
  propertyList = [[NSMutableArray alloc] initWithCapacity: 
					   [rows count]];

  for (i = 0; i < [rows count]; i++)
    {
      NSMutableArray *line = [[NSMutableArray alloc] initWithCapacity:
						       3];

      
      [line addObject: 
	      [self tableView: aTableView
		    objectValueForTableColumn: 
		      [[aTableView tableColumns] objectAtIndex: 0]
		    row: [[rows objectAtIndex: i] intValue]]];

      [line addObject: 
	      [self tableView: aTableView
		    objectValueForTableColumn: 
		      [[aTableView tableColumns] objectAtIndex: 1]
		    row: [[rows objectAtIndex: i] intValue]]];

      [line addObject: 
	      [self tableView: aTableView
		    objectValueForTableColumn: 
		      [[aTableView tableColumns] objectAtIndex: 2]
		    row: [[rows objectAtIndex: i] intValue]]];

      [propertyList addObject: line];
      RELEASE(line);
    }

  [pboard declareTypes: [NSArray arrayWithObject: NSTableViewTestPboardType]
	  owner: self];

  [pboard setPropertyList: propertyList
	  forType: NSTableViewTestPboardType];
  RELEASE(propertyList);
  return YES;
}

- (NSDragOperation) tableView: (NSTableView *) tv
		 validateDrop: (id <NSDraggingInfo>) info
		  proposedRow: (NSInteger) row
	proposedDropOperation: (NSTableViewDropOperation) operation

{
  if ([info draggingSourceOperationMask] & NSDragOperationGeneric)
    return NSDragOperationGeneric;
  else if ([info draggingSourceOperationMask] & NSDragOperationCopy)
    return NSDragOperationCopy;
  else
    return NSDragOperationNone;
}

- (BOOL) tableView: (NSTableView *)tv
	acceptDrop: (id <NSDraggingInfo>) info
	       row: (NSInteger) row
     dropOperation: (NSTableViewDropOperation) operation
{
  NSDragOperation dragOperation;
  if ([info draggingSourceOperationMask] & NSDragOperationGeneric)
    dragOperation = NSDragOperationGeneric;
  else if ([info draggingSourceOperationMask] & NSDragOperationCopy)
    dragOperation = NSDragOperationCopy;
  else
    dragOperation = NSDragOperationNone;

  {
    NSInteger i, j;
    NSArray *pl = [[info draggingPasteboard] propertyListForType:
					       NSTableViewTestPboardType];
    NSUInteger count = [pl count];

    for ( i = count - 1; i >= 0; i-- )
      {
	[keysArray insertObject: 
		     [[pl objectAtIndex: i] objectAtIndex: 0]
		   atIndex: 
		     row];
	[valuesArray insertObject: 
		     [[pl objectAtIndex: i] objectAtIndex: 1]
		   atIndex: 
		     row];
	[testArray insertObject: 
		     [[pl objectAtIndex: i] objectAtIndex: 2]
		   atIndex: 
		     row];
      }
    
    if (dragOperation == NSDragOperationGeneric)
      {
	for ( i = count - 1; i >= 0; i-- )
	  {
	    j = [[draggedRows objectAtIndex: i] intValue];
	    if (j >= row)
	      {
		j += count;
	      }
	    [keysArray removeObjectAtIndex: j];
	    [valuesArray removeObjectAtIndex: j];
	    [testArray removeObjectAtIndex: j];
	  }
      }
    [tv reloadData];
  }
  
  return YES;
}

@end
