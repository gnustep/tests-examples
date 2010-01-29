/* NSWindowStyleMask-test.m: NSWindow styleMasks test

   Copyright (C) 1999, 2000 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999, July 2000
   
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
#include <GNUstepGUI/GSHbox.h>
#include <GNUstepGUI/GSTable.h>
#include <GNUstepGUI/GSVbox.h>
#include "../GSTestProtocol.h"

#define STYLE_NUMBER 7
#define PANEL_STYLE_NUMBER 4

struct 
{ 
  NSString *name; unsigned int styleMask;
} styles[STYLE_NUMBER + PANEL_STYLE_NUMBER] = 
{
  { @"NSMiniWindowMask",                            NSMiniWindowMask               },
  { @"NSIconWindowMask",                            NSIconWindowMask               },
  { @"NSResizableWindowMask",                       NSResizableWindowMask          },
  { @"NSMiniaturizableWindowMask",                  NSMiniaturizableWindowMask     },
  { @"NSClosableWindowMask",                        NSClosableWindowMask           },
  { @"NSTitledWindowMask",                          NSTitledWindowMask             },
  { @"NSTexturedBackgroundWindowMask",              NSTexturedBackgroundWindowMask },
  { @"NSUtilityWindowMask (NSPanel only)",          NSUtilityWindowMask            },
  { @"NSDocModalWindowMask (NSPanel only)",         NSDocModalWindowMask           },
  { @"NSNonactivatingPanelMask (NSPanel only)",     NSNonactivatingPanelMask       },
  { @"NSHUDWindowMask (NSPanel only)",              NSHUDWindowMask                }
};



@interface NSWindowStyleMaskTest: NSObject <GSTest>
{
  NSButton *styleButton[STYLE_NUMBER + PANEL_STYLE_NUMBER];
  NSButton *panelButton;
  NSWindow *win;
}
-(void) restart;
-(void) newWindow: (id)sender;
@end

@implementation NSWindowStyleMaskTest: NSObject
{
  // for instance variables see above
}
-(id) init
{
  int i;
  GSVbox *styleVbox;
  NSButton *newWindowButton;
  GSVbox *mainVbox;
  NSBox *optionsBox;
  NSRect winFrame;

  mainVbox = AUTORELEASE ([GSVbox new]);
  [mainVbox setDefaultMinYMargin: 5];
  [mainVbox setBorder: 5];

  newWindowButton = AUTORELEASE ([NSButton new]);
  [newWindowButton setTitle: @"Create Window"];
  [newWindowButton sizeToFit];
  [newWindowButton setAutoresizingMask: NSViewMinXMargin];
  [newWindowButton setTarget: self];
  [newWindowButton setAction: @selector (newWindow:)];
  [mainVbox addView: newWindowButton  enablingYResizing: NO];

  panelButton = AUTORELEASE ([NSButton new]);
  [panelButton setTitle: @"Create NSPanel"];
  [panelButton setButtonType: NSSwitchButton];
  [panelButton setBordered: NO];
  [panelButton sizeToFit];
  [panelButton setAutoresizingMask: NSViewMaxXMargin];
  [mainVbox addView: panelButton];
 
  [mainVbox addSeparator];
  
  styleVbox = AUTORELEASE ([GSVbox new]);
  [styleVbox setDefaultMinYMargin: 5];
  [styleVbox setBorder: 5];

  for (i = 0; i < STYLE_NUMBER + PANEL_STYLE_NUMBER; i++)
    {
      if (i == STYLE_NUMBER)
        {
          [styleVbox addSeparator];
        }

      styleButton[i] = AUTORELEASE ([NSButton new]);
      [styleButton[i] setTitle: styles[i].name];
      [styleButton[i] setButtonType: NSSwitchButton];
      [styleButton[i] setBordered: NO];
      [styleButton[i] sizeToFit];
      [styleButton[i] setAutoresizingMask: NSViewMaxXMargin];
      [styleVbox addView: styleButton[i]];
    }
 


 
  optionsBox = AUTORELEASE ([NSBox new]);
  [optionsBox setTitle: @"Window Style Mask"];
  [optionsBox setTitlePosition: NSAtTop];
  [optionsBox addSubview: styleVbox];
  [optionsBox sizeToFit];
  [optionsBox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

  [mainVbox addView: optionsBox];
  
  winFrame.size = [mainVbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);

  win = [[NSWindow alloc] initWithContentRect: winFrame
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];  
  [win setContentView: mainVbox];
  [win setTitle: @"NSWindowStyleMask Test"];
  
  [self restart];
  return self;
}
-(void) dealloc
{
  RELEASE (win);
  [super dealloc];
}
-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: @"NSWindowStyleMask Test"
				     filename: NO];
}
-(void) newWindow: (id) sender 
{
  BOOL isPanel;
  NSButton *button;
  NSTextField *label;
  NSString *labelString;
  NSWindow *newWindow;
  unsigned int styleMask;
  int i;
  
  isPanel = ([panelButton state] == 1);

  styleMask = 0;
  labelString = @"";
  for (i = 0; i < (isPanel ? (STYLE_NUMBER + PANEL_STYLE_NUMBER) : STYLE_NUMBER); i++)
    {
      if ([styleButton[i] state] == 1)
	{
	  styleMask |= styles[i].styleMask;
          labelString = [NSString stringWithFormat: @"%@\n%@", labelString, styles[i].name];
	}      
    }

  if (isPanel)
    newWindow = [NSPanel alloc];
  else
    newWindow = [NSWindow alloc];

  newWindow = [newWindow initWithContentRect: NSMakeRect (100, 100, 300, 200)
			 styleMask: styleMask
			 backing: NSBackingStoreBuffered
			 defer: NO];
  [newWindow setReleasedWhenClosed: YES];
  
  if (isPanel)
    [newWindow setTitle: @"Panel"];

  button = [[[NSButton alloc] initWithFrame: NSMakeRect(100, 0, 100, 30)] autorelease];
  [button setTitle: @"Close"];
  [button setTarget: self];
  [button setAction: @selector(closeWindow:)];
  [[newWindow contentView] addSubview: button];

  label = [[[NSTextField alloc] initWithFrame: NSMakeRect(0, 30, 300, 170)] autorelease];
  [label setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
  [label setStringValue: labelString];
  [label setDrawsBackground: NO];
  [label setEditable: NO];
  [label setBezeled: NO];
  [label setSelectable: NO];
  [[newWindow contentView] addSubview: label];

  [newWindow orderFront: self]; 
}

- (void) closeWindow: (id) sender
{
  [[sender window] close];
}

@end
