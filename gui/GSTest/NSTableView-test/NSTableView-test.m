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
#include <AppKit/GSVbox.h>
#include "../GSTestProtocol.h"

// Something to show in the table
NSString *keys[20] = 
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
NSString *values[20] = 
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
NSString *test[20] = 
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

  /* Now add some more columns */
  for (i = 0; i < 5; i++)
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
  
  [self restart];
  return self;
}

-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSTableView Test"
				     filename: NO];
}

- (int) numberOfRowsInTableView: (NSTableView *)aTableView
{
  return 20;
}

- (id)           tableView: (NSTableView *)aTableView 
 objectValueForTableColumn: (NSTableColumn *)aTableColumn 
		       row:(int)rowIndex
{
  if (rowIndex < 0 || rowIndex > 19)
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
    return keys[rowIndex];
  else if ([(NSString *)[aTableColumn identifier] isEqual: @"value"])
    return values[rowIndex];
  else if ([(NSString *)[aTableColumn identifier] isEqual: @"test"])
    return test[rowIndex];
  else 
    return test[rowIndex];
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
@end
