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

#if LIB_FOUNDATION_LIBRARY
	[NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

#ifndef NX_CURRENT_COMPILER_RELEASE
	initialize_gnustep_backend();
#endif

	theApp = [NSApplication sharedApplication];

	window = [[NSWindow alloc] init];

	tabView = [[NSTabView alloc] initWithFrame:tabViewRect];
	[[window contentView] addSubview:tabView];

        item = [[NSTabViewItem alloc] initWithIdentifier:@"Urph"];
        [item setLabel:@"Natalie"];
        [tabView addTabViewItem:item];

        item = [[NSTabViewItem alloc] initWithIdentifier:@"Urph2"];
        [item setLabel:@"Natalia Conquistadori"];
        [tabView addTabViewItem:item];

        item = [[NSTabViewItem alloc] initWithIdentifier:@"Urph3"];
        [item setLabel:@"Me"];
        [tabView addTabViewItem:item];
	
	[window setTitle:@"NSTabView"];
	[window setFrame:winRect display:YES];
	[window orderFront:nil];
	
	[theApp run];
	[pool release];

	return 0;
}
