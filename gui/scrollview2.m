/*
   scrollview2.m

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author: Ovidiu Predescu <ovidiu@net-community.com>
   Date: August 1997

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
#include "TestView.h"



@interface Controller : NSObject
{
  NSMatrix* matrix;
  NSScrollView* scrollView;
}

@end

@implementation Controller

- (void)setButtonTitles
{
int i, j, index = 0;
int numRows = [matrix numberOfRows];
int numCols = [matrix numberOfColumns];
id cell;

  for (i = 0; i < numRows; i++)
    for (j = 0; j < numCols; j++) {
      cell = [matrix cellAtRow: i column: j];
      [cell setTag: index];
      [cell setTitle: [NSString stringWithFormat: @"button %d, %d (%d)", i, j, index]];
      [cell setTarget: self];
      [cell setAction: @selector(handleCellAction: )];
      index++;
    }
}

- (void) handleCellAction: sender
{
  NSLog (@"handleCellAction: sender = %@", [[sender selectedCell] title]);
}

- (void) handleDoubleAction: sender
{
  NSLog (@"handleDoubleAction");
}

- (void) addRow: sender
{
  [matrix addRow];
  [self setButtonTitles];
  [matrix sizeToCells];
  [scrollView setNeedsDisplay: YES];
}

- (void) addColumn: sender
{
  [matrix addColumn];
  [self setButtonTitles];
  [matrix sizeToCells];
  [scrollView setNeedsDisplay: YES];
}

- (void) removeRow: sender
{
  if ([matrix selectedRow] >= 0)
    {
      [scrollView setNeedsDisplay: YES];
      [matrix removeRow: [matrix selectedRow]];
      [self setButtonTitles];
      [matrix sizeToCells];
    }
}

- (void) removeColumn: sender
{
  if ([matrix selectedColumn] >= 0)
    {
      [matrix removeColumn: [matrix selectedColumn]];
      [scrollView setNeedsDisplay: YES];
      [self setButtonTitles];
      [matrix sizeToCells];
    }

}

- (void) setMatrixMode: sender
{
  NSLog (@"setMatrixMode: %d", [[sender selectedCell] tag]);
  [matrix setMode: [[sender selectedCell] tag]];
}

- (void) setMatrix: (NSMatrix*)aMatrix
{
  [aMatrix retain];
  [matrix release];
  matrix = aMatrix;
  [matrix setDoubleAction: @selector(handleDoubleAction:)];
  [matrix setTarget: self];
}

- (void) applicationDidFinishLaunching: (NSNotification *)aNotification
{
  NSWindow* window;
  Controller* controller = self;
  NSMatrix* newMatrix;
  NSMatrix* selectionMatrix;
  NSButtonCell* buttonCell;
  NSButton *addRowButton, *removeRowButton, *addColButton, *removeColButton;
  NSRect matrixRect = NSZeroRect;
  NSRect scrollViewRect = {{20, 115}, {350, 235}};
  NSRect winRect = {{100, 100}, {400, 450}};
  NSRect selectionMatrixRect = {{30, 15}, {85, 95}};
  NSRect addRowRect = {{160, 70}, {95, 24}};
  NSRect removeRowRect = {{160, 32}, {95, 24}};
  NSRect addColRect = {{272, 70}, {95, 24}};
  NSRect removeColRect = {{272, 32}, {95, 24}};

  window = [[NSWindow alloc] init];

  /* Setup the matrix */
  buttonCell = [[NSButtonCell new] autorelease];
  [buttonCell setButtonType: NSPushOnPushOffButton];
  newMatrix = [[[NSMatrix alloc] initWithFrame: matrixRect
				       mode: NSRadioModeMatrix
				  prototype: buttonCell
			       numberOfRows: 0
			    numberOfColumns: 0] autorelease];

  [controller setMatrix: newMatrix];

  scrollView = [[NSScrollView alloc] initWithFrame: scrollViewRect];
  [scrollView setHasHorizontalScroller: YES];
  [scrollView setHasVerticalScroller: YES];
  [scrollView setBorderType: NSBezelBorder];		// for NS compatibility
  [scrollView setDocumentView: newMatrix];
  [[window contentView] addSubview: scrollView];

  /* Setup the matrix for different selection types */
  buttonCell = [[NSButtonCell new] autorelease];
  [buttonCell setButtonType: NSRadioButton];
  [buttonCell setBordered: NO];
  [buttonCell setImagePosition: NSImageLeft];		// for NS compatibility

  selectionMatrix = [[[NSMatrix alloc] initWithFrame: selectionMatrixRect
						mode: NSRadioModeMatrix
					   prototype: buttonCell
					numberOfRows: 4
				     numberOfColumns: 1] autorelease];
  [selectionMatrix setTarget: controller];
  [selectionMatrix setAutosizesCells: YES];		// for NS compatibility
  [selectionMatrix setAction: @selector(setMatrixMode: )];

  buttonCell = [selectionMatrix cellAtRow: 0 column: 0];
  [buttonCell setTitle: @"Radio"];
  [buttonCell setTag: NSRadioModeMatrix];

  buttonCell = [selectionMatrix cellAtRow: 1 column: 0];
  [buttonCell setTitle: @"Highlight"];
  [buttonCell setTag: NSHighlightModeMatrix];

  buttonCell = [selectionMatrix cellAtRow: 2 column: 0];
  [buttonCell setTitle: @"List"];
  [buttonCell setTag: NSListModeMatrix];

  buttonCell = [selectionMatrix cellAtRow: 3 column: 0];
  [buttonCell setTitle: @"Track"];
  [buttonCell setTag: NSTrackModeMatrix];

  [[window contentView] addSubview: selectionMatrix];

  addRowButton = [[NSButton alloc] initWithFrame: addRowRect];
  [addRowButton setTitle: @"Add row"];
  [addRowButton setTarget: controller];
  [addRowButton setAction: @selector(addRow: )];
  [[window contentView] addSubview: addRowButton];

  removeRowButton = [[NSButton alloc] initWithFrame: removeRowRect];
  [removeRowButton setTitle: @"Remove row"];
  [removeRowButton setTarget: controller];
  [removeRowButton setAction: @selector(removeRow: )];
  [[window contentView] addSubview: removeRowButton];

  addColButton = [[NSButton alloc] initWithFrame: addColRect];
  [addColButton setTitle: @"Add column"];
  [addColButton setTarget: controller];
  [addColButton setAction: @selector(addColumn: )];
  [[window contentView] addSubview: addColButton];

  removeColButton = [[NSButton alloc] initWithFrame: removeColRect];
  [removeColButton setTitle: @"Remove column"];
  [removeColButton setTarget: controller];
  [removeColButton setAction: @selector(removeColumn: )];
  [[window contentView] addSubview: removeColButton];

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
#ifndef NX_CURRENT_COMPILER_RELEASE
  initialize_gnustep_backend();
#endif

  theApp = [NSApplication sharedApplication];
  [theApp setDelegate: [Controller new]];
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
