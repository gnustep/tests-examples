/* NSBrowser-test.m: NSBrowser Class Demo/Test

   Copyright (C) 2013 Free Software Foundation, Inc.

   Author:  Riccardo Mottola <rm@gnu.org>
   Date: 2013
   
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
#include <GNUstepGUI/GSHbox.h>
#include "../GSTestProtocol.h"


@interface NSBrowserTest: NSObject <GSTest>
{
  NSWindow *win;
  NSBrowser *b1;
  NSBrowser *b2;

  NSMutableArray *a1;
  NSMutableArray *a2;
}
-(void) restart;
@end

@implementation NSBrowserTest: NSObject
{

}



- (id) init
{
  GSHbox *hbox;
  NSRect winFrame;
  NSUInteger i;

  a1 = [[NSMutableArray alloc] init];
  a2 = [[NSMutableArray alloc] init];
  for (i = 0; i < 20; i++)
    {
      NSNumber *n;

      n = [NSNumber numberWithInt:i];
      [a1 addObject:[n stringValue]];
      [a2 addObject:[n stringValue]];
    }

  hbox = [GSHbox new];
  [hbox setBorder: 5];

  b1 = [[NSBrowser alloc] initWithFrame: NSMakeRect (0, 0, 150, 300)];
  [b1 setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  [b1 setDelegate: self];
  [b1 setMaxVisibleColumns: 1];
  [b1 setAllowsMultipleSelection: NO];
  [b1 setAllowsEmptySelection: NO];
  [b1 setHasHorizontalScroller: NO];
  [b1 setTitled: YES];
  [b1 setTakesTitleFromPreviousColumn: NO];
  [b1 setPath: @"Static"];
  [b1 setTarget: self];
  [b1 setDoubleAction: @selector(doubleAction:)];
  [b1 sizeToFit];
  [hbox addView: b1];

  b2 = [[NSBrowser alloc] initWithFrame: NSMakeRect (0, 0, 150, 300)];
  [b2 setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  [b2 setDelegate: self];
  [b2 setMaxVisibleColumns: 1];
  [b2 setAllowsMultipleSelection: NO];
  [b2 setAllowsEmptySelection: NO];
  [b2 setHasHorizontalScroller: NO];
  [b2 setTitled: YES];
  [b2 setTakesTitleFromPreviousColumn: NO];
  [b2 setPath: @"Editable"];
  [b2 setTarget: self];
  [b2 setDoubleAction: @selector(doubleAction:)];
  [b2 sizeToFit];
  [hbox addView: b2];

  winFrame.size = [hbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);
  
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];
  [win setContentView: hbox];
  [win setTitle: @"NSBrowser Test"];
  [hbox release];

  [self restart];
  return self;
}

-(void) dealloc
{
  [a1 release];
  [a2 release];
  [win release];
  [super dealloc];
}

-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSBrowser Test"
				     filename: NO];
}

-(void)doubleAction:(id)sender
{
  NSLog(@"double action");
}

-(NSString *)browser: (NSBrowser *)sender 
       titleOfColumn: (NSInteger)column
{
  if (sender == b1)
    return @"Static";
  else if (sender == b2)
    return @"Editable";

  return @"error";
}

-(void)browser: (NSBrowser *)sender 
createRowsForColumn: (NSInteger)column
      inMatrix: (NSMatrix *)matrix
{
  NSBrowserCell *cell;
  NSMutableArray *a;
  NSUInteger i;

  if (sender == b1)
    {
      a = a1;
    }
  else
    {
      a = a2;
    }
  [matrix renewRows:[a count] columns:1];
  for (i = 0; i < [a count]; i++)
    {
      cell = [matrix cellAtRow: i
			column: 0];
      [cell setStringValue: [a objectAtIndex: i]];
      if (sender == b2)
	[cell setEditable:YES];
      [cell setLeaf: YES];
    }
}

-(void)browser: (NSBrowser *)sender 
willDisplayCell: (id)cell
	 atRow: (NSInteger)row 
	column: (NSInteger)column
{
}

@end
