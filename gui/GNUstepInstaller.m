/*
   nsbrowsercell.m
   
   Copyright (C) 1996 Free Software Foundation, Inc.
   
   Author: Scott Christley <scottc@net-community.com>
   Date: October 1997
   Author:  Felipe A. Rodriguez <far@ix.netcom.com>
   Date: July 1998
   
   This file is part of the GNUstep GUI X/RAW Library.
   
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
   
   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSTabView.h>

#include "GSImageTabViewItem.h"

@interface myTabViewDelegate : NSObject
{
  NSTabView *ourView;
}
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)TabView;
@end

@implementation myTabViewDelegate
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
  NSLog(@"shouldSelectTabViewItem: %@", [tabViewItem label]);

  /*
   * This is a test to see if the delegate is doing its job.
   */

  if ([[tabViewItem label] isEqual:@"Me"])
    return NO;

  return YES;
}

- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
  NSLog(@"willSelectTabViewItem: %@", [tabViewItem label]);
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
  NSLog(@"didSelectTabViewItem: %@", [tabViewItem label]);
}

- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)TabView
{
  NSLog(@"tabViewDidChangeNumberOfTabViewItems: %d", [TabView numberOfTabViewItems]);
}

- (void)setTabView:(NSTabView *)tabView
{
  ourView = tabView;
}

- (void)buttonNext:(id)sender
{
  [ourView selectNextTabViewItem:sender];  
}

- (void)buttonPrevious:(id)sender
{
  [ourView selectPreviousTabViewItem:sender];  
}
@end

int
main(int argc, char **argv, char** env)
{
NSApplication *theApp;
NSWindow *window;
NSTabView *tabView;
NSTabViewItem *item;
NSRect winRect = {{100, 100}, {300, 300}};
NSRect tabViewRect = {{10, 10}, {280, 280}};
id pool = [NSAutoreleasePool new];
id aView;
id label;
NSButton *button;
id delegate = [myTabViewDelegate new];

#if LIB_FOUNDATION_LIBRARY
	[NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

#ifndef NX_CURRENT_COMPILER_RELEASE
	initialize_gnustep_backend();
#endif

	theApp = [NSApplication sharedApplication];

	window = [[NSWindow alloc] init];

	tabView = [[NSTabView alloc] initWithFrame:tabViewRect];
	[tabView setTabViewType:NSNoTabsBezelBorder];
//	[tabView setDelegate:delegate];
	[delegate setTabView:tabView];
	[[window contentView] addSubview:tabView];

	aView = [[NSView alloc] initWithFrame:[tabView contentRect]];
  label = [[NSTextField alloc] initWithFrame:[aView frame]];
  [label setEditable:NO];
  [label setSelectable:NO];
  [label setBezeled:NO];
  [label setBordered:NO];
  [label setBackgroundColor:[NSColor lightGrayColor]];
  [label setAlignment:NSCenterTextAlignment];
  [label setStringValue:[NSString stringWithCString:"Press next to
install."]];
	[aView addSubview:label];
	[label release];
  button = [[NSButton alloc] initWithFrame:NSMakeRect(10,10,72,22)];
  [button setTitle: @"Next..."];
  [button setTarget:delegate];
  [button setAction:@selector(buttonNext:)];
	[aView addSubview:button];
	[button release];

        item = [[NSTabViewItem alloc] initWithIdentifier:@"Urph"];
        [item setLabel:@"Natalie"];
	[item setView:aView];
        [tabView addTabViewItem:item];
	[aView release];

	aView = [[NSView alloc] initWithFrame:[tabView contentRect]];
  label = [[NSTextField alloc] initWithFrame:[aView frame]];
  [label setEditable:NO];
  [label setSelectable:NO];
  [label setBezeled:NO];
  [label setBordered:NO];
  [label setBackgroundColor:[NSColor lightGrayColor]];
  [label setAlignment:NSCenterTextAlignment];
  [label setStringValue:[NSString stringWithCString: "Previous, or Next?"]];
	[aView addSubview:label];
	[label release];
  button = [[NSButton alloc] initWithFrame:NSMakeRect(10,10,72,22)];
  [button setTitle: @"Next..."];
  [button setTarget:delegate];
  [button setAction:@selector(buttonNext:)];
	[aView addSubview:button];
	[button release];
  button = [[NSButton alloc] initWithFrame:NSMakeRect(85,10,72,22)];
  [button setTitle: @"Previous..."];
  [button setTarget:delegate];
  [button setAction:@selector(buttonPrevious:)];
	[aView addSubview:button];
	[button release];

        item = [[NSTabViewItem alloc] initWithIdentifier:@"Urph2"];
        [item setLabel:@"Natalia Conquistadori"];
	[item setView:aView];
        [tabView addTabViewItem:item];
	[aView release];

	aView = [[NSView alloc] initWithFrame:[tabView contentRect]];
  label = [[NSTextField alloc] initWithFrame:[aView frame]];
  [label setEditable:NO];
  [label setSelectable:NO];
  [label setBezeled:NO];
  [label setBordered:NO];
  [label setBackgroundColor:[NSColor lightGrayColor]];
  [label setAlignment:NSCenterTextAlignment];
  [label setStringValue:[NSString stringWithCString:"Well, no install. 
Sorry. :-)"]];
	[aView addSubview:label];
	[label release];
  button = [[NSButton alloc] initWithFrame:NSMakeRect(10,10,72,22)];
  [button setTitle: @"Previous..."];
  [button setTarget:delegate];
  [button setAction:@selector(buttonPrevious:)];
	[aView addSubview:button];
	[button release];

        item = [[GSImageTabViewItem alloc] initWithIdentifier:@"Urph3"];
	[item setImage:[NSImage imageNamed:@"Smiley"]];
        [item setLabel:@"Me"];
	[item setView:aView];
        [tabView addTabViewItem:item];
	[aView release];
	
	[window setTitle:@"NSTabView without Tabs"];
	[window setFrame:winRect display:YES];
	[window orderFront:nil];
	
	[theApp run];
	[pool release];

	return 0;
}
