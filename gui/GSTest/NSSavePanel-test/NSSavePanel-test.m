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
#include <AppKit/GSVbox.h>
#include "../GSTestProtocol.h"

// An entry to show a single result
@interface ResultsEntry: GSHbox 
{
  NSTextField *entryField;
}
-(id)initWithName: (NSString *)name;
-(void)setStringValue: (NSString *)result;
@end

@implementation ResultsEntry
-(id)initWithName: (NSString *)name
{
  NSTextField *entryName;

  [super init];
  [self setDefaultMinXMargin: 5];
  [self setAutoresizingMask: NSViewWidthSizable];
  
  entryName = [NSTextField new];
  [entryName setDrawsBackground: NO];
  [entryName setEditable: NO];
  [entryName setSelectable: NO];
  [entryName setBezeled: NO];
  [entryName setAlignment: NSLeftTextAlignment];
  [entryName setStringValue: name];
  [entryName sizeToFit];
  [self addView: entryName
	enablingXResizing: NO];
  [entryName release];

  entryField = [NSTextField new];
  [entryField setDrawsBackground: YES];
  [entryField setBackgroundColor: [NSColor controlBackgroundColor]];
  [entryField setEditable: NO];
  [entryField setSelectable: NO];
  [entryField setBezeled: YES];
  [entryField setAlignment: NSLeftTextAlignment];
  [entryField setStringValue: @""];
  [entryField sizeToFit];
  [entryField setAutoresizingMask: NSViewWidthSizable];
  [self addView: entryField];
  [entryField release];
  return self;
}
-(void)setStringValue: (NSString *)result
{
  [entryField setStringValue: result];
}
@end

@interface NSSavePanelTest: NSObject <GSTest>
{
  NSButton *packageButton;
  NSButton *accessoryViewButton;
  NSForm *configureForm;
  NSWindow *win;
  ResultsEntry *filenameEntry;
  ResultsEntry *directoryEntry;
  ResultsEntry *buttonEntry;
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
  GSVbox *resultsVbox;
  NSBox *configureBox;
  NSBox *resultsBox;
  NSRect winFrame;
  
  vbox = [GSVbox new];
  [vbox setDefaultMinYMargin: 5];
  [vbox setBorder: 5];
 
  button = [NSButton new];
  [button setTitle: @"Start Save Panel"];
  [button sizeToFit];
  [button setAutoresizingMask: NSViewMinXMargin];
  [button setTarget: self];
  [button setAction: @selector (startSavePanel:)];
  [vbox addView: button];
  [button release];

  // Results
  directoryEntry = [[ResultsEntry alloc] initWithName: @"Directory:"];
  filenameEntry = [[ResultsEntry alloc] initWithName: @"Filename:"];
  buttonEntry = [[ResultsEntry alloc] initWithName: @"Button:"];

  resultsVbox = [GSVbox new];
  [resultsVbox setDefaultMinYMargin: 10];
  [resultsVbox setBorder: 0];
  [resultsVbox setAutoresizingMask: NSViewWidthSizable];
  
  [resultsVbox addView: filenameEntry];
  [filenameEntry release];
  [resultsVbox addView: directoryEntry];
  [directoryEntry release];
  [resultsVbox addView: buttonEntry];
  [buttonEntry release];
  
  resultsBox = [NSBox new];
  [resultsBox setTitle: @"Results"];
  [resultsBox setTitlePosition: NSAtTop];
  [resultsBox addSubview: resultsVbox];
  [resultsVbox release];
  [resultsBox sizeToFit];
  [resultsBox setAutoresizingMask: NSViewWidthSizable];

  [vbox addView: resultsBox];
  [resultsBox release];
  
  configureForm = [NSForm new];
  [configureForm addEntry: @"Title:"];
  [configureForm addEntry: @"Prompt:"];
  [configureForm addEntry: @"Directory:"];
  [configureForm addEntry: @"File:"];
  [configureForm setIntercellSpacing: NSMakeSize (0, 10) ];
  [configureForm setAutoresizingMask: NSViewWidthSizable];
 
  packageButton = [NSButton new];
  [packageButton setTitle: @"Treat File Packages as Directories"];
  [packageButton setButtonType: NSSwitchButton];
  [packageButton setBordered: NO];
  [packageButton sizeToFit];
  ivbox = [GSVbox new];
  [ivbox setDefaultMinYMargin: 10];
  [ivbox addView: packageButton];
  [packageButton release];

  accessoryViewButton = [NSButton new];
  [accessoryViewButton setTitle: @"Add an Accessory View"];
  [accessoryViewButton setButtonType: NSSwitchButton];
  [accessoryViewButton setBordered: NO];
  [accessoryViewButton sizeToFit];
  [ivbox addView: accessoryViewButton];
  [accessoryViewButton release];

  [ivbox addView: configureForm];
  [configureForm release];
  [ivbox setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];
  
  configureBox = [NSBox new];
  [configureBox setTitle: @"Options"];
  [configureBox setTitlePosition: NSAtTop];
  [configureBox addSubview: ivbox];
  [ivbox release];
  [configureBox sizeToFit];
  [configureBox setAutoresizingMask: NSViewWidthSizable];

  [vbox addView: configureBox];
  [configureBox release];
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
  
  [win setContentView: vbox];
  [vbox release];
  [win setTitle: @"NSSavePanel Test"];
  
  [self restart];
  return self;
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
