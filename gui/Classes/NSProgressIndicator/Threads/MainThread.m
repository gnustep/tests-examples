/* -*-objc-*-
   Copyright (C) 2002 Free Software Foundation, Inc.
   
   Author: Nicola Pero <n.pero@mi.flashnet.it>

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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
*/
#include <MainThread.h>
#include <AppKit/AppKit.h>
#include "SharedArea.h"
#include "AuxiliaryThread.h"
#include <GNUstepGUI/GSVbox.h>

@implementation MainThread

- (id) init
{
  GSVbox *vbox;

  self = [super init];

  vbox = [GSVbox new];
  [vbox setBorder: 20];
  [vbox setDefaultMinYMargin: 20];

  pi = [[NSProgressIndicator alloc] initWithFrame: NSMakeRect (0, 0, 360, 20)];
  [pi setIndeterminate: NO];
  [pi setMinValue: 0];
  [pi setMaxValue: 100];
  [pi setAutoresizingMask: NSViewNotSizable];
  [vbox addView: pi enablingYResizing: NO];
  RELEASE (pi);

  field = AUTORELEASE ([NSTextField new]);
  [field setSelectable: YES];
  [field setEditable: NO];
  [field setBezeled: NO];
  [field setDrawsBackground: NO];
  [field setStringValue: @"Status: Running auxiliary thread ... XXX.XXX%"];
  [field sizeToFit];
  [field setStringValue: @"Status: Idle"];
  [field setAutoresizingMask: NSViewWidthSizable];
  [vbox addView: field  enablingYResizing: NO];
  RELEASE (field);

  window = [[NSWindow alloc] 
	     initWithContentRect: NSMakeRect (200, 300, 
					      [vbox frame].size.width,
					      [vbox frame].size.height)
	     styleMask: (NSTitledWindowMask | NSMiniaturizableWindowMask)
	     backing: NSBackingStoreBuffered
	     defer: YES];
  [window setTitle: @"NSProgressIndicator"];

  [window setContentView: vbox];
  RELEASE (vbox);
  
  return self;
}

- (void)dealloc
{
  RELEASE (window);
  [super dealloc];
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification;
{
  [window orderFront: self];
}

- (void)start: (id)sender
{
  if (timer != nil)
    {
      NSLog (@"Already running ... ignoring!");
      return;
    }


  [field setStringValue: @"Status: Running auxiliary thread ..."];
  
  [NSThread detachNewThreadSelector: @selector(start:)
	    toTarget: [AuxiliaryThread class]
	    withObject: nil];
  
  timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
		   target: self
		   selector: @selector(updateProgressIndicator:)
		   userInfo: nil
		   repeats: YES];
  RETAIN (timer);
}


- (void)updateProgressIndicator: (NSTimer *)t
{
  [pi setDoubleValue: progress_indicator ()];



  if (! is_auxiliary_thread_running ())
    {
      [timer invalidate];
      DESTROY (timer);
      [field setStringValue: @"Status: Idle"];
    }  
  else
    {
      NSString *status;
      
      status = [NSString stringWithFormat: 
			   @"Status: Running auxiliary thread ... %2.1f%%",
			 progress_indicator ()];
      
      [field setStringValue: status];
    }
  
}

@end
