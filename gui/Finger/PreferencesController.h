/*
 *  PreferencesController.h: Finger.app Preferences Panel
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

#include "Finger.h"

/* Define SET_BUTTON to 1 to have the Set button compiled in the panel
   With or without the set button, everything is set as soon as you
   press return or end editing in any way.  */
#define SET_BUTTON 1

#define FINGER_TAG     0
#define PING_TAG       1
#define TRACEROUTE_TAG 2
#define WHOIS_TAG      3

@interface PreferencesController : NSObject
{
  NSPanel *pan;
  NSTextField *fingerCommand;
  NSTextField *pingCommand;  
  NSTextField *tracerouteCommand;
  NSTextField *whoisCommand;
  NSPopUpButton *buttonsSize;
#if SET_BUTTON
  NSButton *setButton;
#endif
}
- (id)  init;
- (void)reset;
- (void)resetToDefault: (id)sender;
- (void)set: (id)sender;
- (void)changePreference: (id)sender;
- (void)orderFrontPanel;
- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename;
@end
