/*
 *  Controller.m: Main Object of Finger.app
 *
 *  Copyright (c) 2000 Free Software Foundation, Inc.
 *  
 *  Author: Nicola Pero
 *  Date: February 2000
 *
 *  This sample program is part of GNUstep.
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#import "Controller.h"

@implementation Controller

+(void)initialize
{
  if (self == [Controller class])
    {
      NSUserDefaults *defaults;
      NSMutableDictionary   *dict; 

      defaults = [NSUserDefaults standardUserDefaults];      
      dict = AUTORELEASE ([NSMutableDictionary new]);
      [dict setObject: FINGER_DEFAULT_COMMAND forKey: @"FingerCommand"];
      [dict setObject: PING_DEFAULT_COMMAND forKey: @"PingCommand"];
      [dict setObject: TRACEROUTE_DEFAULT_COMMAND 
	    forKey: @"TracerouteCommand"];
      [defaults registerDefaults: dict];
    }
}

-(id) init
{
  return self;
}

-(void) dealloc
{
  TEST_RELEASE (pref);
  [super dealloc];
}

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification;
{
  [self startNewFingerWindow: self];
}

- (void)startNewFingerWindow: (id) sender
{
  FingerWindow *win;

  win = [FingerWindow new];
  [win orderFront: self];
  /* Theoretically win is going to be released when it is closed by
     the user */
}

-(void) runInfoPanel: (id) sender
{
  NSMutableDictionary *d;

  d = AUTORELEASE ([NSMutableDictionary new]);
  [d setObject: @"Finger" forKey: @"ApplicationName"];
  [d setObject: @"A GNUstep Frontend to Finger, Ping, Traceroute" 
     forKey: @"ApplicationDescription"];
  [d setObject: NAME_WITH_SHORT_VERSION forKey: @"ApplicationRelease"];
  [d setObject: FULL_VERSION forKey: @"FullVersionID"];
  [d setObject: [NSArray arrayWithObject: 
			   @"Nicola Pero <n.pero@mi.flashnet.it>"]
     forKey: @"Authors"];
  //  [d setObject: @"See http://www.gnustep.org" forKey: @"URL"];
  [d setObject: @"Copyright (C) 2000 Free Software Foundation, Inc."
     forKey: @"Copyright"];
  [d setObject: @"Released under the GNU General Public License 2.0"
     forKey: @"CopyrightDescription"];
  
  [NSApp orderFrontStandardInfoPanelWithOptions:d];
}

-(void) runPreferencesPanel: (id) sender
{
  if (pref == nil)
    pref = [PreferencesController new];

  [pref orderFrontPanel];
}

@end
