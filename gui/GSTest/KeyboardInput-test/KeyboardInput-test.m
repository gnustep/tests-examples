/* KeyboardInput-test.m: Keyboard Input demo/test

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

// Same as a switch button, which you can't press.
@interface CheckBox: NSButton
{
}
@end

@implementation CheckBox: NSButton
{
}
-(id) init
{
  self = [super init];
  [self setButtonType: NSSwitchButton];
  [self setBordered: NO];
  return self;
}
- (BOOL) acceptsFirstResponder
{
  return NO;
}
-(void) keyDown: (NSEvent *)theEvent
{
  if (next_responder)
    return [next_responder keyDown: theEvent];
  else
    return [self noResponderFor: @selector(keyDown:)];
}
-(void) mouseDown: (NSEvent *)theEvent
{
  if (next_responder)
    return [next_responder mouseDown: theEvent];
  else
    return [self noResponderFor: @selector(mouseDown:)];
}
@end

@interface inputTestView: NSView
{
  CheckBox *modifierCheckBox[8];
  NSTextField *keyCodeField;
  NSTextField *charactersField;
  NSTextField *charactersIgnoringModifiersField;
  NSTextFieldCell *cell;
}
-(void) setCheckBox: (CheckBox *)theCheckBox withNumber: (int)checkBoxNumber; 
-(void) setKeyCodeField: (NSTextField *)theField;
-(void) setCharactersField: (NSTextField *)theField;
-(void) setCharactersIgnoringModifiersField: (NSTextField *)theField;
@end

@implementation inputTestView
{
  CheckBox *modifierCheckBox[8];
  NSTextField *keyCodeField;
  NSTextField *charactersField;
  NSTextField *charactersIgnoringModifiersField;
  NSTextFieldCell *cell;
}
-(id) initWithFrame: (NSRect)aFrame
{
  cell = [NSTextFieldCell new];
  [cell setStringValue: @"Type Keys in Here"];
  [cell setBackgroundColor: [NSColor controlColor]];
  [cell setTextColor: [NSColor controlTextColor]];
  [cell setDrawsBackground: YES];
  [cell setBordered: YES];
  [cell setSelectable: NO];
  [cell setAlignment: NSCenterTextAlignment];
  return [super initWithFrame: aFrame];
}
-(void) dealloc
{
  [cell release];
  [super dealloc];
}
-(void) setCheckBox: (CheckBox *) theCheckBox withNumber: (int) checkBoxNumber 
{
  if (modifierCheckBox[checkBoxNumber])
    [modifierCheckBox[checkBoxNumber] release];
  modifierCheckBox[checkBoxNumber] = [theCheckBox retain];
}
-(void) setKeyCodeField: (NSTextField *)theField
{
  if (keyCodeField)
    [keyCodeField release];
  keyCodeField = [theField retain];
}
-(void) setCharactersField: (NSTextField *)theField
{
  if (charactersField)
    [charactersField release];
  charactersField = [theField retain];
}
-(void) setCharactersIgnoringModifiersField: (NSTextField *)theField
{
  if (charactersIgnoringModifiersField)
    [charactersIgnoringModifiersField release];
  charactersIgnoringModifiersField = [theField retain];
}
- (BOOL) acceptsFirstResponder
{
  return YES;
}
- (BOOL) resignFirstResponder
{
  return NO;
}
-(BOOL) performKeyEquivalent: (NSEvent *)theEvent
{
  [self keyDown: theEvent];
  return YES;
}
-(void) keyDown: (NSEvent *)theEvent
{
  unsigned int flags = [theEvent modifierFlags];
  int i;

  for (i = 0; i < 8; i++)
    {
      if (flags & modifiers[i])
	[modifierCheckBox[i] setState: 1];
      else 
	[modifierCheckBox[i] setState: 0];
    }

  [keyCodeField setIntValue: [theEvent keyCode]];
  [charactersField setStringValue: [theEvent characters]];
  [charactersIgnoringModifiersField 
    setStringValue: [theEvent charactersIgnoringModifiers]];
}
-(void) drawRect: (NSRect)aRect
{
  [cell drawWithFrame: [self bounds]
	inView: self];
}
@end 

@interface KeyboardInputTest: NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@implementation KeyboardInputTest: NSObject
{
  // for instance variables see above
}
-(id) init 
{
  GSHbox *hbox;
  GSVbox *vbox;
  NSBox *keyBox;
  GSVbox *keyVbox;
  GSHbox *keyCodeHbox;
  GSHbox *charactersHbox;
  GSHbox *charactersIgnoringModifiersHbox;
  NSTextField *keyCodeName;
  NSTextField *charactersName;
  NSTextField *charactersIgnoringModifiersName;
  NSTextField *keyCodeField;
  NSTextField *charactersField;
  NSTextField *charactersIgnoringModifiersField;
  NSBox *modifierBox;
  GSVbox *modifierVbox;
  CheckBox *modifierCheckBox[8];
  inputTestView *inputOnMe;
  NSRect winFrame;
  int i;

  inputOnMe = [[inputTestView alloc] 
		initWithFrame: NSMakeRect (0, 0, 120, 120)];
  [inputOnMe autorelease];
  [inputOnMe setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  modifierVbox = [[GSVbox new] autorelease];
  [modifierVbox setDefaultMinYMargin: 10];
  [modifierVbox setBorder: 10];

  for (i = 0; i < 8; i++)
    {
      modifierCheckBox[i] = [[CheckBox new] autorelease];
      [modifierCheckBox[i] setTitle: modifierTitle[i]];
      [modifierCheckBox[i] sizeToFit];
      [modifierVbox addView: modifierCheckBox[i]];
      [inputOnMe setCheckBox: modifierCheckBox[i] withNumber: i];
    }

  modifierBox = [[NSBox new] autorelease];
  [modifierBox setTitle: @"Modifiers"];
  [modifierBox setTitlePosition: NSAtTop];
  [modifierBox setBorderType: NSGrooveBorder];
  [modifierBox addSubview: modifierVbox];
  [modifierBox sizeToFit];
  [modifierBox setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  keyVbox = [[GSVbox new] autorelease];
  [keyVbox setDefaultMinYMargin: 10];
  [keyVbox setBorder: 10];
  [keyVbox setAutoresizingMask: NSViewWidthSizable];

  keyCodeHbox = [[GSHbox new] autorelease];
  [keyCodeHbox setDefaultMinXMargin: 10];
  [keyCodeHbox setAutoresizingMask: NSViewWidthSizable];

  keyCodeName = [[NSTextField new] autorelease];
  [keyCodeName setDrawsBackground: NO];
  [keyCodeName setEditable: NO];
  [keyCodeName setSelectable: NO];
  [keyCodeName setBezeled: NO];
  [keyCodeName setAlignment: NSLeftTextAlignment];
  [keyCodeName setStringValue: @"keyCode:"];
  [keyCodeName sizeToFit];
  [keyCodeHbox addView: keyCodeName
	       enablingXResizing: NO];

  keyCodeField = [[NSTextField new] autorelease];
  [keyCodeField setDrawsBackground: NO];
  [keyCodeField setEditable: NO];
  [keyCodeField setSelectable: NO];
  [keyCodeField setBezeled: YES];
  [keyCodeField setAlignment: NSLeftTextAlignment];
  [keyCodeField setStringValue: @"Not Set"];
  [keyCodeField sizeToFit];
  [keyCodeField setAutoresizingMask: NSViewWidthSizable];
  [keyCodeHbox addView: keyCodeField];
  [inputOnMe setKeyCodeField: keyCodeField];

  [keyVbox addView: keyCodeHbox];

  charactersHbox = [[GSHbox new] autorelease];
  [charactersHbox setDefaultMinXMargin: 10];
  [charactersHbox setAutoresizingMask: NSViewWidthSizable];

  charactersName = [[NSTextField new] autorelease];
  [charactersName setDrawsBackground: NO];
  [charactersName setEditable: NO];
  [charactersName setSelectable: NO];
  [charactersName setBezeled: NO];
  [charactersName setAlignment: NSLeftTextAlignment];
  [charactersName setStringValue: @"characters:"];
  [charactersName sizeToFit];
  [charactersHbox addView: charactersName
		  enablingXResizing: NO];

  charactersField = [[NSTextField new] autorelease];
  [charactersField setDrawsBackground: NO];
  [charactersField setEditable: NO];
  [charactersField setSelectable: NO];
  [charactersField setBezeled: YES];
  [charactersField setAlignment: NSLeftTextAlignment];
  [charactersField setStringValue: @"Not Set"];
  [charactersField sizeToFit];
  [charactersField setAutoresizingMask: NSViewWidthSizable];
  [charactersHbox addView: charactersField];
  [inputOnMe setCharactersField: charactersField];  
  
  [keyVbox addView: charactersHbox];

  charactersIgnoringModifiersHbox = [[GSHbox new] autorelease];
  [charactersIgnoringModifiersHbox setDefaultMinXMargin: 10];
  [charactersIgnoringModifiersHbox setAutoresizingMask: NSViewWidthSizable];

  charactersIgnoringModifiersName = [[NSTextField new] autorelease];
  [charactersIgnoringModifiersName setDrawsBackground: NO];
  [charactersIgnoringModifiersName setEditable: NO];
  [charactersIgnoringModifiersName setSelectable: NO];
  [charactersIgnoringModifiersName setBezeled: NO];
  [charactersIgnoringModifiersName setAlignment: NSLeftTextAlignment];
  [charactersIgnoringModifiersName 
    setStringValue: @"charactersIgnoringModifiers:"];
  [charactersIgnoringModifiersName sizeToFit];
  [charactersIgnoringModifiersHbox addView: charactersIgnoringModifiersName
				   enablingXResizing: NO];

  charactersIgnoringModifiersField = [[NSTextField new] autorelease];
  [charactersIgnoringModifiersField setDrawsBackground: NO];
  [charactersIgnoringModifiersField setEditable: NO];
  [charactersIgnoringModifiersField setSelectable: NO];
  [charactersIgnoringModifiersField setBezeled: YES];
  [charactersIgnoringModifiersField setAlignment: NSLeftTextAlignment];
  [charactersIgnoringModifiersField setStringValue: @"Not Set"];
  [charactersIgnoringModifiersField sizeToFit];
  [charactersIgnoringModifiersField setAutoresizingMask: NSViewWidthSizable];
  [charactersIgnoringModifiersHbox addView: charactersIgnoringModifiersField];
  [inputOnMe 
    setCharactersIgnoringModifiersField: charactersIgnoringModifiersField];  
  
  [keyVbox addView: charactersIgnoringModifiersHbox];

  keyBox = [[NSBox new] autorelease];
  [keyBox setTitle: @"Keys"];
  [keyBox setTitlePosition: NSAtTop];
  [keyBox setBorderType: NSGrooveBorder];
  [keyBox addSubview: keyVbox];
  [keyBox sizeToFit];
  [keyBox setAutoresizingMask: NSViewWidthSizable];

  vbox = [[GSVbox new] autorelease];
  [vbox setDefaultMinYMargin: 10];
  [vbox setBorder: 10];
  [vbox addView: keyBox];
  [vbox addView: inputOnMe];

  hbox = [[GSHbox new] autorelease];
  [hbox setDefaultMinXMargin: 10];
  [hbox setBorder: 10];
  [hbox addView: vbox];
  [hbox addView: modifierBox];  


  winFrame.size = [hbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);

  // Now we can make the window of the exact size 
  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: YES];
  [win setTitle:@"Keyboard Input Test"];
  [win setContentView: hbox];
  [win setMinSize: winFrame.size];
  [win makeFirstResponder: inputOnMe];
  [self restart];
  return self;
}
- (void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"Keyboard Input Test"
				     filename: NO];
}
@end

