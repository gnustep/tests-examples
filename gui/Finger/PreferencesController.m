/*
 *  PreferencesController.m: Finger.app Preferences Panel
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

#import <FingerIncludeAll.h>
#import "PreferencesController.h"

/* We cache here the shared file manager for speed */
static NSFileManager *fm;

/*
 * The Preferences Panel
 *
 */
static NSBox * 
setup_box (NSString *command, NSTextField *field, int tag, id target)
{
  NSBox *box;
  NSButton *button;
  GSHbox *hbox;

  [field setStringValue: @"Very Big, Long Long Sentence"];
  [field sizeToFit];
  [field setStringValue: @""];
  [field setDelegate: target];
  [field setTag: tag];
  [field setEditable: YES];
  [field setAutoresizingMask: (NSViewWidthSizable 
			       | NSViewMinYMargin | NSViewMaxYMargin)];

  button = AUTORELEASE ([NSButton new]);
  [button setTitle: @"File Panel..."];
  [button sizeToFit];
  [button setAutoresizingMask: NSViewNotSizable];
  [button setTag: tag];
  [button setTarget: target];
  [button setAction: @selector(changePreference:)];

  hbox = AUTORELEASE ([GSHbox new]);
  [hbox setBorder: 0];
  [hbox setDefaultMinXMargin: 8];
  [hbox addView: field];
  [hbox addView: button enablingXResizing: NO];
  [hbox setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin];

  box = AUTORELEASE ([NSBox new]);
  [box setTitlePosition: NSAtTop];
  [box setTitle: command];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: hbox];
  [box sizeToFit];
  [box setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];  
  return box;
}

@implementation PreferencesController

-(id)init
{
  GSVbox *vbox;
  NSBox *box;
  GSHbox *hbox, *bshbox;
  NSButton *defaultButton;
  NSRect panFrame;
  NSSize buttonSize;

  if (fm == nil)
    {
      fm = [NSFileManager defaultManager];
    }

  vbox = AUTORELEASE ([GSVbox new]);
  [vbox setBorder: 10];
  [vbox setDefaultMinYMargin: 10];
  [vbox setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];

  /* Buttons */
  hbox = AUTORELEASE ([GSHbox new]);
  [hbox setDefaultMinXMargin: 10];

  defaultButton = AUTORELEASE ([NSButton new]);
  [defaultButton setTitle: @"Default"];
  [defaultButton sizeToFit];
  buttonSize = [defaultButton frame].size;
  [defaultButton setAutoresizingMask: NSViewMaxXMargin];
  [defaultButton setTarget: self];
  [defaultButton setAction: @selector (resetToDefault:)];

#if SET_BUTTON
  setButton = AUTORELEASE ([NSButton new]);
  [setButton setTitle: @"Set"];
  [setButton sizeToFit];
  [setButton setAutoresizingMask: NSViewMinXMargin];
  [setButton setTarget: self];
  /* We have a nice trick here.  When the user presses the 'set'
     button, the first responder is changed, so that editing ends -- and
     this saves the setting.  We need to do nothing more.  */
  [setButton setAction: NULL];

  if ([setButton frame].size.width > buttonSize.width)
    {
      buttonSize.width = [setButton frame].size.width;
    }

  [setButton setFrameSize: buttonSize];

#endif 
  
  [defaultButton setFrameSize: buttonSize];

  [hbox addView: defaultButton];
#if SET_BUTTON
  [hbox addView: setButton]; 
#endif

  [hbox setAutoresizingMask: NSViewWidthSizable];
  [vbox addView: hbox
	enablingYResizing: NO];

  /* Preferences */

  buttonsSize = AUTORELEASE ([NSPopUpButton new]);
  [buttonsSize setPullsDown: NO];
  [buttonsSize addItemWithTitle: @"Large"];
  [buttonsSize addItemWithTitle: @"Small"];
  [buttonsSize setTarget: self];
  [buttonsSize setAction: @selector(set:)];
  [buttonsSize sizeToFit];
  [buttonsSize setAutoresizingMask: (NSViewWidthSizable | NSViewMinYMargin 
				     | NSViewMaxYMargin)];

  bshbox = AUTORELEASE ([GSHbox new]);
  [bshbox setBorder: 0];
  [bshbox setDefaultMinXMargin: 8];
  [bshbox addView: buttonsSize];
  [bshbox setAutoresizingMask: NSViewWidthSizable | NSViewMinYMargin];  

  box = AUTORELEASE ([NSBox new]);
  [box setTitlePosition: NSAtTop];
  [box setTitle: @"Button Size"];
  [box setBorderType: NSGrooveBorder];
  [box addSubview: bshbox];
  [box sizeToFit];
  [box setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];  

  [vbox addView: box];

  tracerouteCommand = AUTORELEASE ([NSTextField new]);
  box = setup_box (@"Traceroute Command", tracerouteCommand, 
		   TRACEROUTE_TAG, self);
  [vbox addView: box];

  pingCommand = AUTORELEASE ([NSTextField new]);
  box = setup_box (@"Ping Command", pingCommand, PING_TAG, self);
  [vbox addView: box];

  whoisCommand = AUTORELEASE ([NSTextField new]);
  box = setup_box (@"Whois Command", whoisCommand, WHOIS_TAG, self);
  [vbox addView: box];

  fingerCommand = AUTORELEASE ([NSTextField new]);
  box = setup_box (@"Finger Command", fingerCommand, FINGER_TAG, self);
  [vbox addView: box];

  [fingerCommand setNextText: whoisCommand];
  [whoisCommand setNextText: pingCommand];
  [pingCommand setNextText: tracerouteCommand];
  [tracerouteCommand setNextText: fingerCommand];

  panFrame.size = [vbox frame].size;
  panFrame.origin = NSMakePoint (150, 150);
  
  pan = [[NSPanel alloc] initWithContentRect: panFrame
			 styleMask: (NSTitledWindowMask 
				     | NSClosableWindowMask
				     | NSResizableWindowMask)	
			 backing: NSBackingStoreBuffered
			 defer: YES];
  [pan setTitle: @"Preferences"];
  [pan setContentView: vbox];
  // Set min Size ?
  return [super init];
}
-(void) reset
{   
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  
  [fingerCommand setStringValue: [ud stringForKey: @"FingerCommand"]];
  [whoisCommand setStringValue: [ud stringForKey: @"WhoisCommand"]];
  [pingCommand setStringValue: [ud stringForKey: @"PingCommand"]];
  [tracerouteCommand setStringValue: [ud stringForKey: 
					   @"TracerouteCommand"]];
  [buttonsSize selectItemWithTitle: [ud stringForKey: @"ButtonSize"]];
}
-(void) resetToDefault:(id)sender
{
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

  [ud removeObjectForKey: @"FingerCommand"];
  [ud removeObjectForKey: @"WhoisCommand"];
  [ud removeObjectForKey: @"PingCommand"];
  [ud removeObjectForKey: @"TracerouteCommand"];
  [ud removeObjectForKey: @"ButtonSize"];
  [self reset];
}
-(void) set:(id)sender
{
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

  [ud setObject: [fingerCommand stringValue] forKey: @"FingerCommand"];
  [ud setObject: [whoisCommand stringValue] forKey: @"WhoisCommand"];
  [ud setObject: [pingCommand stringValue] forKey: @"PingCommand"];
  [ud setObject: [tracerouteCommand stringValue] forKey: 
	@"TracerouteCommand"];
  [ud setObject: [buttonsSize titleOfSelectedItem] forKey: @"ButtonSize"];
  [ud synchronize];
}
-(void) changePreference: (id)sender
{
  NSOpenPanel *openPanel;
  NSString    *file;
  int result;

  openPanel = [NSOpenPanel openPanel];
  
  [openPanel setTitle: @"Choose Command"];
  [openPanel setAllowsMultipleSelection: NO];

  switch ([sender tag]) 
    {
    case PING_TAG: 
      [openPanel setPrompt: @"Ping Command:"];
      file = [pingCommand stringValue];
      break;
    case WHOIS_TAG:
      [openPanel setPrompt: @"Whois Command:"];
      file = [whoisCommand stringValue];
      break;
    case FINGER_TAG:
      [openPanel setPrompt: @"Finger Command:"];
      file = [fingerCommand stringValue];
      break;
    case TRACEROUTE_TAG:
      [openPanel setPrompt: @"Traceroute Command:"];
      file = [tracerouteCommand stringValue];
      break;
    default:
      return;
    }

  [openPanel setDelegate: self];

  result = [openPanel 
	     runModalForDirectory: [file stringByDeletingLastPathComponent]
	     file: [file lastPathComponent]
	     types: nil];

  if (result == NSOKButton)
    {
      switch ([sender tag])
	{
	case PING_TAG: 
	  [pingCommand setStringValue: [openPanel filename]];
	  break;
        case WHOIS_TAG:
          [whoisCommand setStringValue: [openPanel filename]];
          break;
	case FINGER_TAG:
	  [fingerCommand setStringValue: [openPanel filename]];
	  break;
	case TRACEROUTE_TAG:
	  [tracerouteCommand setStringValue: [openPanel filename]];
	  break;
	}
      [self set: self];
    }
}
- (void)controlTextDidEndEditing: (NSNotification *)aNotification
{
  NSTextField *sender = (NSTextField *)[aNotification object];
  NSString  *filename = [sender stringValue];
  BOOL      bip, bop;

  bip = [fm fileExistsAtPath: filename isDirectory: &bop]; 
  
  if (bip)
    bip = [fm isExecutableFileAtPath: filename]; 
  
  if ((bip == YES) && (bop == NO))
    {
#if SET_BUTTON
      [setButton performClick: self];
#endif
      [self set: self];
    }
  else
    {
      NSString *alert;
      NSString *pref;
      NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

      alert = [filename stringByAppendingString: @" is not executable!"];
      NSRunAlertPanel (NULL, alert, @"OK", NULL, NULL);
      switch ([sender tag])
	{
	case PING_TAG: 
	  pref = @"PingCommand";
	  break;
        case WHOIS_TAG:
          pref = @"WhoisCommand";
          break;
	case FINGER_TAG:
	  pref = @"FingerCommand";
	  break;
	case TRACEROUTE_TAG:
	  pref = @"TracerouteCommand";
	  break;
	default:
	  return;
	}
      [sender setStringValue: [ud stringForKey: pref]];
    }
}
-(void) orderFrontPanel
{
  [self reset];
  [pan orderFront: self];
}
-(void) dealloc
{
  RELEASE (pan);
  [super dealloc];
}
- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename
{
  /* NB: We show directories here */
  return [fm isExecutableFileAtPath: filename]; 
}
- (BOOL)panel:(id)sender isValidFilename:(NSString *)filename
{
  BOOL bip, bop;

  /* Do not accept not existing files or directories */
  bip = [fm fileExistsAtPath: filename isDirectory: &bop]; 
  return ((bip) && (!bop));
}
@end

