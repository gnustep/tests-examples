/*
   nsimagecell.m
   
   Copyright (C) 1999 Free Software Foundation, Inc.
   
   Author: Jonathan Gapen <jagapen@smithlab.chem.wisc.edu>
   Date: May 1999
  
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

#include <Foundation/NSAutoreleasePool.h>
#include <AppKit/AppKit.h>


@interface matrixController : NSObject
{
  NSMatrix* matrix;
}

@end
@implementation matrixController

- (void) setMatrix: (NSMatrix*)anObject
{
  matrix = anObject;
}

- (void) setMatrixMode: sender
{
  [matrix setMode: [[sender selectedCell] tag]];
}

- (void) setSelectionByRect: sender
{
  [matrix setSelectionByRect: [sender state]];
}

- (void) applicationDidFinishLaunching: (NSNotification *)aNotification
{
  NSWindow	*window;
  NSRect	winRect = {{100, 400}, {270, 200}};
  NSRect	matrixRect = {{5, 5}, {265, 195}};
  NSMatrix	*theMatrix;
  NSSize cellSize = {64, 64};
  NSImageCell	*imageCell;
  id		handler = self;

  window = [[NSWindow alloc] init];

  imageCell = [[NSImageCell new] autorelease];
  [imageCell setImageFrameStyle: NSImageFrameGrayBezel];
  [imageCell setImageScaling: NSScaleNone];
  [imageCell setImage: [NSImage imageNamed: @"NSRadioButton"]];

  theMatrix = [[[NSMatrix alloc] initWithFrame: matrixRect
				  mode: NSRadioModeMatrix
				  prototype: imageCell
				  numberOfRows: 3
				  numberOfColumns: 4]
				  autorelease];
  [theMatrix setCellSize: cellSize];
  [[window contentView] addSubview: theMatrix];

  [handler setMatrix: theMatrix];

  imageCell = [theMatrix cellAtRow: 0 column: 0];
  [imageCell setImageAlignment: NSImageAlignTopLeft];

  imageCell = [theMatrix cellAtRow: 0 column: 1];
  [imageCell setImageAlignment: NSImageAlignTop];

  imageCell = [theMatrix cellAtRow: 0 column: 2];
  [imageCell setImageAlignment: NSImageAlignTopRight];

  imageCell = [theMatrix cellAtRow: 0 column: 3];
  [imageCell setImageScaling: NSScaleProportionally];

  imageCell = [theMatrix cellAtRow: 1 column: 0];
  [imageCell setImageAlignment: NSImageAlignLeft];

  imageCell = [theMatrix cellAtRow: 1 column: 1];
  [imageCell setImageAlignment: NSImageAlignCenter];

  imageCell = [theMatrix cellAtRow: 1 column: 2];
  [imageCell setImageAlignment: NSImageAlignRight];

  imageCell = [theMatrix cellAtRow: 1 column: 3];
  [imageCell setImageScaling: NSScaleToFit];

  imageCell = [theMatrix cellAtRow: 2 column: 0];
  [imageCell setImageAlignment: NSImageAlignBottomLeft];

  imageCell = [theMatrix cellAtRow: 2 column: 1];
  [imageCell setImageAlignment: NSImageAlignBottom];

  imageCell = [theMatrix cellAtRow: 2 column: 2];
  [imageCell setImageAlignment: NSImageAlignBottomRight];

  imageCell = [theMatrix cellAtRow: 2 column: 3];
  [imageCell setImageScaling: NSScaleNone];
  
  [window setTitle: @"NSImageCell Test"];
  [window setFrame: winRect display: YES];
  [window orderFront: nil];
}

@end

int
main(int argc, char** argv, char** env)
{
  id pool = [NSAutoreleasePool new];
  NSApplication *theApp;

#if LIB_FOUNDATION_LIBRARY
  [NSProcessInfo initializeWithArguments: argv count: argc environment: env];
#endif

  theApp = [NSApplication sharedApplication];
  [theApp setDelegate: [matrixController new]];	
  {
    NSMenu	*menu = [NSMenu new];

    [menu addItemWithTitle: @"Quit"
		    action: @selector(terminate:)
	     keyEquivalent: @"q"];
    [NSApp setMainMenu: menu];
  }

  [theApp run];
  
  [pool release];
  
  return 0;
}

