/*
   scrollview.m

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author: Ovidiu Predescu <ovidiu@net-community.com>
   Date: July 1997
   
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
#include "TestView.h"

@interface MyObject : NSObject
{
  id scrollView;
  NSRect viewFrame;
}
- (void)setScrollView:(id)aView;
@end

@implementation MyObject
- (void)setScrollView:(id)aView
{
  [aView retain];
  [scrollView release];
  scrollView = aView;
  viewFrame = [[scrollView documentView] frame];
}

- (void)setZoomFactor:(id)sender
{
  int tag = [[sender selectedCell] tag];
  id docView = [scrollView documentView];
  float scale;

  switch (tag) {
    default:
    case 1: scale = 1; break;
    case 2: scale = 1.5; break;
    case 3: scale = 2; break;
    case 4: scale = 4; break;
  }

  [docView setFrameSize:NSMakeSize (viewFrame.size.width * scale, 
				     viewFrame.size.height * scale)];
  [docView setBoundsSize:viewFrame.size];
  [scrollView setNeedsDisplay:YES];
}
@end


int
main(int argc, char **argv, char** env)
{
  NSApplication *theApp;
  NSWindow* window;
  NSScrollView* scrollView;
  MyObject* object;
  TestView* view;
  NSButtonCell* buttonCell;
  NSMatrix* zoomMatrix;
  NSRect scrollViewRect = {{10, 10}, {250, 300}};
  NSRect zoomMatrixRect = {{270, 10}, {120, 80}};
  NSRect winRect = {{100, 100}, {380, 350}};
  NSRect f = {{0, 0}, {500, 700}};
  NSAutoreleasePool* pool;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask				
					| NSMiniaturizableWindowMask | NSResizableWindowMask;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments:argv count:argc environment:env];
#endif

  pool = [NSAutoreleasePool new];

#ifndef NX_CURRENT_COMPILER_RELEASE
  initialize_gnustep_backend();
#endif

  theApp = [NSApplication sharedApplication];

#if 0
  window = [[NSWindow alloc]
	      initWithContentRect:winRect
	      styleMask:style
	      backing:NSBackingStoreNonretained
	      defer:NO];
#else
  window = [[NSWindow alloc] init];
#endif

  view = [[[TestView alloc] initWithFrame:f] autorelease];

  scrollView = [[NSScrollView alloc] initWithFrame:scrollViewRect];
  [scrollView setHasHorizontalScroller:YES];
  [scrollView setHasVerticalScroller:YES];
  [scrollView setDocumentView:view];
  [[window contentView] addSubview:scrollView];

  object = [[MyObject new] autorelease];
  [object setScrollView:scrollView];

  buttonCell = [[NSButtonCell new] autorelease];
  [buttonCell setButtonType:NSRadioButton];
  [buttonCell setBordered:NO];

  zoomMatrix = [[[NSMatrix alloc]
		    initWithFrame:zoomMatrixRect
		    mode:NSRadioModeMatrix
		    prototype:buttonCell
		    numberOfRows:4
		    numberOfColumns:1]
		  autorelease];
  [zoomMatrix setTarget:object];
  [zoomMatrix setAction:@selector(setZoomFactor:)];

  buttonCell = [zoomMatrix cellAtRow:0 column:0];
  [buttonCell setTitle:@"100%"];
  [buttonCell setTag:1];

  buttonCell = [zoomMatrix cellAtRow:1 column:0];
  [buttonCell setTitle:@"150%"];
  [buttonCell setTag:2];

  buttonCell = [zoomMatrix cellAtRow:2 column:0];
  [buttonCell setTitle:@"200%"];
  [buttonCell setTag:3];

  buttonCell = [zoomMatrix cellAtRow:3 column:0];
  [buttonCell setTitle:@"400%"];
  [buttonCell setTag:4];

  [[window contentView] addSubview:zoomMatrix];

  [window setFrame:winRect display:YES];
  [window makeKeyAndOrderFront:nil];
  [window orderFront:nil];

  [theApp run];
  [pool release];
  return 0;
}
