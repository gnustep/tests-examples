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
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02111, USA.
*/

#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>

@interface MyObject : NSObject
{
  NSMatrix* matrix;
}
@end

@implementation MyObject
- (void)setMatrix:(NSMatrix*)anObject
{
  matrix = anObject;
}

- (void)setMatrixMode:sender
{
  [matrix setMode:[[sender selectedCell] tag]];
}

- (void)setSelectionByRect:sender
{
  [matrix setSelectionByRect:[sender state]];
}
@end

int
main(int argc, char **argv, char** env)
{
NSApplication *theApp;
NSWindow *window;
NSRect winRect = {{100, 100}, {600, 600}};
NSRect scrollViewRect = {{20, 115}, {150, 335}};
NSRect matrixRect = {{0, 0}, {100, 550}};
id pool = [NSAutoreleasePool new];
NSMatrix* matrix;
NSBrowserCell* browserCell;
NSScrollView* scrollView;
MyObject* handler = [[MyObject new] autorelease];
NSSize cs, ms;
NSRect mr;

#if LIB_FOUNDATION_LIBRARY
	[NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

	theApp = [NSApplication sharedApplication];

//#if 1
//  window = [[NSWindow alloc]
//	      initWithContentRect:winRect
//	      styleMask:NSTitledWindowMask
//	      backing:NSBackingStoreNonretained
//	      defer:NO];
//#else
	window = [[NSWindow alloc] init];
//#endif

	browserCell = [[NSBrowserCell new] autorelease];
	[browserCell setStringValue:@"aTitle"];				// for NS compatibility

	matrix = [[[NSMatrix alloc] initWithFrame:matrixRect
							  	mode:NSRadioModeMatrix
//		mode:NSListModeMatrix	// selectedRow/selectedColumn get set to -1 
								// during matrix init. the program then crashes
								// when a cell is selected FAR 6/19/98 (fix me)
								prototype:browserCell
								numberOfRows:10
								numberOfColumns:1]
								autorelease];

//  [matrix _test];

	scrollView = [[NSScrollView alloc] initWithFrame:scrollViewRect];
	[scrollView setHasHorizontalScroller:NO];
	[scrollView setHasVerticalScroller:YES];
	[scrollView setBorderType:NSBezelBorder];			// for NS compatibility

	cs = [scrollView contentSize];
	ms = [matrix cellSize];
	ms.width = cs.width;
	[matrix setCellSize: ms];

	[matrix sizeToCells];								// for NS compatibility
	[scrollView setDocumentView:matrix];
	
	[[window contentView] addSubview:scrollView];
	
	[window setTitle:@"NSMatrix with NSBrowserCells"];
	[window setFrame:winRect display:YES];
	[window orderFrontRegardless];
	
	[theApp run];
	[pool release];

	return 0;
}
