/* KeyboardInput-test.m: Keyboard Input demo/test

   Copyright (C) 1999, 2000 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999, 2000
   
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
#include <GNUstepGUI/GSTable.h>
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"
#include "ConvertKeys.h"

static unsigned int modifiers[8] = 
{
  NSAlphaShiftKeyMask,
  NSShiftKeyMask, 
  NSControlKeyMask,
  NSCommandKeyMask,
  NSAlternateKeyMask,
  NSHelpKeyMask,
  NSFunctionKeyMask,
  NSNumericPadKeyMask
};

static NSString *modifierTitle[8] = 
{
  @"NSAlphaShiftKeyMask",
  @"NSShiftKeyMask", 
  @"NSControlKeyMask",
  @"NSCommandKeyMask",
  @"NSAlternateKeyMask",
  @"NSHelpKeyMask",
  @"NSFunctionKeyMask",
  @"NSNumericPadKeyMask"
};

static void
set_standard_properties (NSTextField *tf, NSTextAlignment align)
{
  [tf setEditable: NO];
  [tf setSelectable: NO];
  [tf setBezeled: NO];
  [tf setDrawsBackground: NO];
  [tf setAlignment: align];
  [tf setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin];
}

/* An NSTextField which can become invisible on request */
@interface ModifierEntry: NSTextField
{
  BOOL is_visible;
}
-(void)setVisible: (BOOL) flag;
@end

@implementation ModifierEntry
-(void)setVisible: (BOOL) flag
{
  if (is_visible != flag)
    [self setNeedsDisplay];
  is_visible = flag;
}
-(void) drawRect: (NSRect)aRect
{
  if (is_visible == NO)
    return;

  [super drawRect: aRect];
}
@end

/* The object displaying the list of modifiers */
@interface ModifiersList: GSVbox
{
  ModifierEntry *mod[8];
}
-(void)setModifiers: (unsigned int)flags;
@end

@implementation ModifiersList: GSVbox
{
}
-(id) init
{
  int i;

  [super init];

  [self setDefaultMinYMargin: 2];

  /* Start from 7 so that mod[0] is the uppest entry */
  for (i = 7; i > -1; i--)
    {
      mod[i] = AUTORELEASE ([ModifierEntry new]);
      set_standard_properties (mod[i], NSLeftTextAlignment);
      /* setStringValue just to compute dimension */
      [mod[i] setStringValue: modifierTitle[i]];
      [mod[i] sizeToFit];
      [mod[i] setVisible: NO];
      [self addView: mod[i]];
    }
  return self;
}
-(void)setModifiers: (unsigned int)flags
{
  int i, entries = 0;

  for (i = 0; i < 8; i++)
    {
      if (flags & modifiers[i])
	{
	  [mod[entries] setStringValue: modifierTitle[i]];
	  [mod[entries] setVisible: YES];
	  entries++;
	}
    }

  for (i = entries; i < 8; i++)
    {
      [mod[i] setVisible: NO];
    }
}
@end

/* The main view in our test window */
@interface InputTestView: NSView
{
  /* If NO, we behave as a common NSView */
  /* If YES, we catch all key events     */
  BOOL enabled;
  
  ModifiersList *modifiersList;
  NSTextField *keyCodeField;
  NSTextField *charactersField;
  NSTextField *charactersIgnoringModifiersField;
}
-(void) setEnabled: (BOOL)flag;
@end

@implementation InputTestView
{
}
-(id) init
{
  NSBox *box;
  NSBox *borderBox;
  GSTable *table;
  NSTextField *entry;

  [super init];
  
  // The little results table
  table = AUTORELEASE ([[GSTable alloc] initWithNumberOfRows: 4
					numberOfColumns: 2]);
  // Set resizing properties
  [table setXResizingEnabled: NO  forColumn: 0];
  [table setXResizingEnabled: YES forColumn: 1];
  
  [table setYResizingEnabled: NO forRow: 0];
  [table setYResizingEnabled: NO forRow: 1];
  [table setYResizingEnabled: NO forRow: 2];
  [table setYResizingEnabled: NO forRow: 3];

  [table setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin];

  //Add entries in the table
  entry = AUTORELEASE ([NSTextField new]);
  set_standard_properties (entry, NSRightTextAlignment);
  [entry setStringValue: @"keyCode:"];
  [entry sizeToFit];
  [table putView: entry atRow: 3 column: 0 withMargins: 2];

  entry = AUTORELEASE ([NSTextField new]);
  set_standard_properties (entry, NSRightTextAlignment);
  [entry setStringValue: @"characters:"];
  [entry sizeToFit];
  [table putView: entry atRow: 2 column: 0 withMargins: 2];

  entry = AUTORELEASE ([NSTextField new]);
  set_standard_properties (entry, NSRightTextAlignment);
  [entry setStringValue: @"charactersIgnoringModifiers:"];
  [entry sizeToFit];
  [table putView: entry atRow: 1 column: 0 withMargins: 2];

  entry = AUTORELEASE ([NSTextField new]);
  set_standard_properties (entry, NSRightTextAlignment);
  [entry setStringValue: @"modifiers:"];
  [entry sizeToFit];
  [table putView: entry atRow: 0 column: 0 withMargins: 2];

  keyCodeField = AUTORELEASE ([NSTextField new]);
  set_standard_properties (keyCodeField, NSLeftTextAlignment);
  [keyCodeField setStringValue: @" "];
  [keyCodeField sizeToFit];
  [table putView: keyCodeField atRow: 3 column: 1 withMargins: 2];

  charactersField = AUTORELEASE ([NSTextField new]);
  set_standard_properties (charactersField, NSLeftTextAlignment);
  [charactersField setStringValue: @" "];
  [charactersField sizeToFit];
  [table putView: charactersField atRow: 2 column: 1 withMargins: 2];

  charactersIgnoringModifiersField = AUTORELEASE ([NSTextField new]);
  set_standard_properties (charactersIgnoringModifiersField, 
			   NSLeftTextAlignment);
  [charactersIgnoringModifiersField setStringValue: @" "];
  [charactersIgnoringModifiersField sizeToFit];
  [table putView: charactersIgnoringModifiersField 
	 atRow: 1 column: 1 withMargins: 2];

  modifiersList = AUTORELEASE ([ModifiersList new]);
  [table putView: modifiersList atRow: 0 column: 1 withMargins: 2];

  box = AUTORELEASE ([NSBox new]);
  [box setTitle: @"Information On Latest Key Event"];
  [box setTitlePosition: NSAtTop];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: table];
  [box sizeToFit];
  [box setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  borderBox = AUTORELEASE ([NSBox new]);
  [borderBox setTitlePosition: NSNoTitle];
  [borderBox setBorderType: NSNoBorder];
  [borderBox addSubview: box];
  [borderBox sizeToFit];
  [borderBox setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  [self setFrameSize: [borderBox frame].size];
  [borderBox setFrameOrigin: NSMakePoint (0, 0)];
  [self addSubview: borderBox];
  enabled = NO;
  return self;
}

/* NB: We do not need any dealloc method.  We are not retaining anything. */

-(void) setEnabled: (BOOL)flag;
{
  enabled = flag;
  [[self window] makeFirstResponder: self];
}
- (BOOL) acceptsFirstResponder
{
  return enabled;
}
- (BOOL) resignFirstResponder
{
  return (!enabled);
}
-(BOOL) performKeyEquivalent: (NSEvent *)theEvent
{
  if (enabled)
    {
      [self keyDown: theEvent];
      return YES;
    }
  else
    return [super performKeyEquivalent: theEvent];
}
-(void) keyDown: (NSEvent *)theEvent
{
  if (enabled)
    {
      NSString *s;

      [modifiersList setModifiers: [theEvent modifierFlags]];
      [keyCodeField setIntValue: [theEvent keyCode]];

      s = convertCharactersToDisplayable ([theEvent characters]);
      [charactersField setStringValue: s];

      s = convertCharactersToDisplayable ([theEvent 
					    charactersIgnoringModifiers]);
      [charactersIgnoringModifiersField setStringValue: s];
    }
  else
    [super keyDown: theEvent];
}
@end 

@interface KeyboardInputTest: NSObject <GSTest>
{
  InputTestView *v;
  NSWindow *win;
}
-(void) restart;
- (void)windowDidBecomeKey: (NSNotification *)aNotification;
- (void)windowDidResignKey: (NSNotification *)aNotification;
@end

@implementation KeyboardInputTest: NSObject
{
  // for instance variables see above
}
-(id) init 
{
  NSRect winFrame;

  v = AUTORELEASE ([InputTestView new]);
  winFrame.size = [v frame].size;
  winFrame.origin = NSMakePoint (100, 100);
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: YES];
  [win setTitle:@"Keyboard Input Test"];
  [win setReleasedWhenClosed: NO];
  [win setContentView: v];
  [win setMinSize: [NSWindow frameRectForContentRect: winFrame
			     styleMask: [win styleMask]].size];
  [win setDelegate: self];
  [self restart];
  return self;
}
- (void) dealloc
{
  [win setDelegate: nil];
  RELEASE(win);
  [super dealloc];
}
- (void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"Keyboard Input Test"
				     filename: NO];
}
- (void)windowDidBecomeKey: (NSNotification *)aNotification
{
  [v setEnabled: YES];
}
- (void)windowDidResignKey: (NSNotification *)aNotification
{
  [v setEnabled: NO];
}
@end

