/*
   matrix.m
   
   Copyright (C) 1996-1999 Free Software Foundation, Inc.
   
   Author: Ovidiu Predescu <ovidiu@bx.logicnet.ro>
   Date: April 1997
  
   This file is part of the GNUstep GUI Testing package
   
   This file is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This file is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.
   
   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#import <Foundation/NSAutoreleasePool.h>
#import <AppKit/AppKit.h>



@interface matrixController : NSObject
{
  NSMatrix* matrix;
}

@end
@implementation matrixController

- (void)setMatrix: (NSMatrix*)anObject
{
  matrix = anObject;
}

- (void)setMatrixMode: sender
{
  [matrix setMode: [[sender selectedCell] tag]];
}

- (void)setSelectionByRect: sender
{
  [matrix setSelectionByRect: [sender state]];
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification
{
  NSWindow *window;
  NSRect winRect = {{100, 100}, {600, 600}};
  NSRect matrixRect = {{175, 5}, {460, 550}};
  NSRect selectionMatrixRect = {{12, 36}, {120, 80}};
  NSRect selectionByRectSwitchRect = {{12, 12}, {150, 20}};
  NSMatrix* matrix;
  NSMatrix* selectionMatrix;
  NSButtonCell* buttonCell;
  NSButton* selectionByRectSwitch;
  id handler = self;

  window = [[NSWindow alloc] init];

  buttonCell = [[NSButtonCell new] autorelease];
  [buttonCell setButtonType: NSPushOnPushOffButton];

  matrix = [[[NSMatrix alloc] initWithFrame: matrixRect
				       mode: NSRadioModeMatrix
				  prototype: buttonCell
			       numberOfRows: 30
			    numberOfColumns: 5] autorelease];
  [[window contentView] addSubview: matrix];
//  [matrix _test];

  [buttonCell setButtonType: NSRadioButton];
  [buttonCell setBordered: NO];

  selectionMatrix = [[[NSMatrix alloc] initWithFrame: selectionMatrixRect
					        mode: NSRadioModeMatrix
					   prototype: buttonCell
					numberOfRows: 4
				     numberOfColumns: 1] autorelease];
  [handler setMatrix: matrix];
  [selectionMatrix setTarget: handler];
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

  selectionByRectSwitch = [[[NSButton alloc]
    initWithFrame: selectionByRectSwitchRect] autorelease];
  [selectionByRectSwitch setButtonType: NSSwitchButton];
  [selectionByRectSwitch setBordered: NO];
  [selectionByRectSwitch setTitle: @"Selection by rect"];
  [selectionByRectSwitch setState: 1];
  [selectionByRectSwitch setTarget: handler];
  [selectionByRectSwitch setAction: @selector(setSelectionByRect: )];
  [[window contentView] addSubview: selectionByRectSwitch];
  
  [window setTitle: @"NSMatrix"];
  [window setFrame: winRect display: YES];
  [window orderFront: nil];
}

@end

int
main(int argc, char** argv, char** env)
{
  NSAutoreleasePool	*pool = [NSAutoreleasePool new];
  NSApplication		*theApp;

#if LIB_FOUNDATION_LIBRARY
    [NSProcessInfo initializeWithArguments: argv count: argc environment: env];
#endif
#ifndef NX_CURRENT_COMPILER_RELEASE
    initialize_gnustep_backend();
#endif

  theApp = [NSApplication sharedApplication];
  [theApp setDelegate: [matrixController new]];	
  [theApp run];
  
  [pool release];
  
  return 0;
}
