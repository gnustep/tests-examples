/* NSSavePanel-test.m: NSSavePanel class demo/test

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999
   
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
#include <AppKit/GSHbox.h>
#include <AppKit/GSTable.h>
#include <AppKit/GSVbox.h>
#include "../GSTestProtocol.h"

// A unit rectangle of the little results table
@interface TableEntry: NSTextField
@end

@implementation TableEntry
- (id) initWithFrame: (NSRect)frameRect
{
  [super initWithFrame: frameRect];
  [self setEditable: NO];
  [self setSelectable: NO];
  [self setBezeled: NO];
  [self setDrawsBackground: NO];
  [self setAutoresizingMask: NSViewWidthSizable];
  return self;
}
@end

@interface NSSavePanelTest: NSObject <GSTest>
{
  NSButton *packageButton;
  NSButton *accessoryViewButton;
  NSForm *configureForm;
  NSWindow *win;
  TableEntry *filenameEntry;
  TableEntry *directoryEntry;
  TableEntry *buttonEntry;
}
-(void)restart;
-(void)startSavePanel: (id)sender;
-(NSBox *)accessoryView;
@end

@implementation NSSavePanelTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  NSButton *button;
  GSVbox *vbox;
  GSVbox *ivbox;
  GSVbox *tmp_box;
  NSBox *configureBox;
  NSBox *resultsBox;
  GSTable *resultsTable;
  TableEntry *entry;
  NSRect winFrame;
  
  vbox = [[GSVbox new] autorelease];
  [vbox setDefaultMinYMargin: 5];
  [vbox setBorder: 5];
 
  button = [[NSButton new] autorelease];
  [button setTitle: @"Start Save Panel"];
  [button sizeToFit];
  [button setAutoresizingMask: NSViewMinXMargin];
  [button setTarget: self];
  [button setAction: @selector (startSavePanel:)];
  [vbox addView: button
	enablingYResizing: NO];

  // The little results table
  resultsTable = [[[GSTable alloc] initWithNumberOfRows: 3
				   numberOfColumns: 2] autorelease];
  // Set resizing properties
  [resultsTable setXResizingEnabled: NO
		forColumn: 0];
  [resultsTable setXResizingEnabled: YES
		forColumn: 1];

  [resultsTable setYResizingEnabled: NO
		forRow: 0];
  [resultsTable setYResizingEnabled: NO
		forRow: 1];
  [resultsTable setYResizingEnabled: NO
		forRow: 2];

  [resultsTable setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin];
  //Add entries in the table
  entry = [[TableEntry new] autorelease];
  [entry setStringValue: @"Button:"];
  [entry setAlignment: NSRightTextAlignment];
  [entry sizeToFit];
  [resultsTable putView: entry
		atRow: 0
		column: 0
		withMargins: 2];

  entry = [[TableEntry new] autorelease];
  [entry setStringValue: @"Filename:"];
  [entry setAlignment: NSRightTextAlignment];
  [entry sizeToFit];
  [resultsTable putView: entry
		atRow: 1
		column: 0
		withMargins: 2];

  entry = [[TableEntry new] autorelease];
  [entry setStringValue: @"Directory:"];
  [entry setAlignment: NSRightTextAlignment];
  [entry sizeToFit];
  [resultsTable putView: entry
		atRow: 2
		column: 0
		withMargins: 2];

  buttonEntry = [[TableEntry new] autorelease];
  [buttonEntry setStringValue: @" "];
  [buttonEntry setAlignment: NSLeftTextAlignment];
  [buttonEntry sizeToFit];
  [resultsTable putView: buttonEntry
		atRow: 0
		column: 1
		withMargins: 2];

  filenameEntry = [[TableEntry new] autorelease];
  [filenameEntry setStringValue: @" "];
  [filenameEntry setAlignment: NSLeftTextAlignment];
  [filenameEntry sizeToFit];
  [resultsTable putView: filenameEntry
		atRow: 1
		column: 1
		withMargins: 2];

  directoryEntry = [[TableEntry new] autorelease];
  [directoryEntry setStringValue: @" "];
  [directoryEntry setAlignment: NSLeftTextAlignment];
  [directoryEntry sizeToFit];
  [resultsTable putView: directoryEntry
		atRow: 2
		column: 1
		withMargins: 2];
  //  

  resultsBox = [[NSBox new] autorelease];
  [resultsBox setTitle: @"Results"];
  [resultsBox setTitlePosition: NSAtTop];
  [resultsBox addSubview: resultsTable];
  [resultsBox sizeToFit];
  [resultsBox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

  [vbox addView: resultsBox
	withMinYMargin: 10];
  
  configureForm = [[NSForm new] autorelease];
  [configureForm addEntry: @"Title:"];
  [configureForm addEntry: @"Prompt:"];
  [configureForm addEntry: @"Directory:"];
  [configureForm addEntry: @"File:"];
  [configureForm sizeToFit];
  [configureForm setAutoresizingMask: NSViewWidthSizable];

  tmp_box = [[GSVbox new] autorelease];
  [tmp_box setDefaultMinYMargin: 4];
  [tmp_box setAutoresizingMask: NSViewMinXMargin | NSViewMaxXMargin];
  
  packageButton = [[NSButton new] autorelease];
  [packageButton setTitle: @"Treat File Packages as Directories"];
  [packageButton setButtonType: NSSwitchButton];
  [packageButton setBordered: NO];
  [packageButton sizeToFit];
  [packageButton setAutoresizingMask: NSViewMaxXMargin];
  [tmp_box addView: packageButton];

  accessoryViewButton = [[NSButton new] autorelease];
  [accessoryViewButton setTitle: @"Add an Accessory View"];
  [accessoryViewButton setButtonType: NSSwitchButton];
  [accessoryViewButton setBordered: NO];
  [accessoryViewButton sizeToFit];
  [accessoryViewButton setAutoresizingMask: NSViewMaxXMargin];
  [tmp_box addView: accessoryViewButton];

  ivbox = [[GSVbox new] autorelease];
  [ivbox setDefaultMinYMargin: 8];
  [ivbox addView: tmp_box
	 enablingYResizing: NO];
  [ivbox addView: configureForm 
	 enablingYResizing: NO];
  [ivbox setAutoresizingMask: NSViewWidthSizable|NSViewMinYMargin];
  
  configureBox = [[NSBox new] autorelease];
  [configureBox setTitle: @"Options"];
  [configureBox setTitlePosition: NSAtTop];
  [configureBox addSubview: ivbox];
  [configureBox sizeToFit];
  [configureBox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

  [vbox addView: configureBox];
  [vbox setAutoresizingMask: (NSViewWidthSizable | NSViewMinYMargin)];

  [configureForm setNextKeyView: accessoryViewButton];
  [accessoryViewButton setNextKeyView: packageButton];
  [packageButton setNextKeyView: configureForm];
  
  winFrame.size = [vbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);

  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];  
  [win setContentView: vbox];
  [win setTitle: @"NSSavePanel Test"];
  
  [self restart];
  return self;
}
-(void) dealloc
{
  RELEASE(win);
  [super dealloc];
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSSavePanel Test"
				     filename: NO];
}
-(void) startSavePanel: (id) sender 
{
  NSSavePanel *savePanel;
  int packageFlag;
  int accessoryViewFlag;
  int result;
  NSString *string;
  NSString *directory;
  NSString *filename;

  savePanel = [NSSavePanel savePanel];
  string = [[configureForm cellAtIndex: 0] stringValue];
  if ([string length]) 
    [savePanel setTitle: string];
  
  string = [[configureForm cellAtIndex: 1] stringValue];
  if ([string length])
    [savePanel setPrompt: string];
  
  packageFlag = [packageButton state];
  if (packageFlag == 0)
    [savePanel setTreatsFilePackagesAsDirectories: NO];
  else
    [savePanel setTreatsFilePackagesAsDirectories: YES];

  accessoryViewFlag = [accessoryViewButton state];
  if (accessoryViewFlag == 1)
    [savePanel setAccessoryView: [self accessoryView]];

  filename = [[configureForm cellAtIndex: 3] stringValue];
  directory = [[configureForm cellAtIndex: 2] stringValue];

  if ([filename hasPrefix: @"/"])
    {
      NSRunAlertPanel (NULL, @"A valid filename can not begin with / !",
		       @"OK", NULL, NULL);
      return;
    }

  result = [savePanel runModalForDirectory:  directory
		      file: filename];
  switch (result)
    {
    case NSOKButton:
      [buttonEntry setStringValue: @"NSOKButton"];
      break;
    case NSCancelButton:
      [buttonEntry setStringValue: @"NSCancelButton"];
      break;
    default: // There are no other cases.
      [buttonEntry setStringValue: @"<Weird. Report to bug-gnustep@gnu.org>"];
      break;      
    }

  [directoryEntry setStringValue: [savePanel directory]];
  [filenameEntry setStringValue: [savePanel filename]];
}
-(NSBox *) accessoryView
{
  NSTextField *view;
  NSBox *box;

  view = [NSTextField new];
  [view setDrawsBackground: YES];
  [view setBackgroundColor: [NSColor grayColor]];
  [view setEditable: NO];
  [view setSelectable: NO];
  [view setBezeled: NO];
  [view setBordered: YES];
  [view setAlignment: NSCenterTextAlignment];
  [view setStringValue: @"This is the AccessoryView"];
  [view setFrameSize: NSMakeSize (400, 70)]; 
  [view setAutoresizingMask: NSViewWidthSizable];
  
  box = [NSBox new];
  [box setTitle: @"AccessoryView"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: view];
  [view release];
  [box sizeToFit];
  [box setAutoresizingMask: NSViewWidthSizable];      
  
  return [box autorelease];
}
@end
