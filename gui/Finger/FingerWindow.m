/*
 *  FingerWindow.m: One of Finger.app windows
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
#import "FingerWindow.h"

@implementation FingerWindow

-(void) dealloc
{
  if (task && [task isRunning])
    {
      [task terminate];
    }
  TEST_RELEASE (task);
  TEST_RELEASE (pipe[0]);
  TEST_RELEASE (pipe[1]);
  [[NSNotificationCenter defaultCenter] removeObserver: self];
  [super dealloc];
}
- (id) init
{
  GSVbox *vbox;
  GSHbox *hbox;
  NSButton* fingerButton;
  NSButton* pingButton;
  NSButton* traceButton;
  NSButton* whoisButton;
  NSScrollView* scroll;
  NSRect winFrame;
  float f = 0;
  NSSize bs;
  BOOL bigButtons;
  NSFont *font;
  
  if ([[[NSUserDefaults standardUserDefaults] stringForKey: @"ButtonSize"]
	isEqualToString: @"Small"])
    {
      font = [NSFont systemFontOfSize: SMALL_FONT_SIZE];
      bigButtons = NO;
    }
  else
    {
      font = [NSFont systemFontOfSize: BIG_FONT_SIZE];
      bigButtons = YES;
    }
  
  vbox = AUTORELEASE ([GSVbox new]);
  [vbox setBorder: 5];
  [vbox setDefaultMinYMargin: 5];
  
  text = AUTORELEASE ([TrivialTextView new]);
  
  scroll = AUTORELEASE ([[NSScrollView alloc] 
			  initWithFrame: NSMakeRect (0, 0, 300, 300)]);
  [scroll setDocumentView: text];
  [scroll setHasHorizontalScroller: YES];
  [scroll setHasVerticalScroller: YES];
  [scroll setBorderType: NSBezelBorder];
  [scroll setAutoresizingMask: (NSViewWidthSizable | NSViewHeightSizable)];

  [vbox addView: scroll];

  hbox = AUTORELEASE ([GSHbox new]);
  [hbox setBorder: 0];
  [hbox setDefaultMinXMargin: 8];

  form = AUTORELEASE ([NSForm new]);
  [form addEntry: @"User:"];
  [form addEntry: @"Host:"];
  [form setAutoresizingMask: (NSViewWidthSizable | NSViewMinYMargin 
			      | NSViewMaxYMargin)];
  [form setAutosizesCells: YES];
  [form sizeToFit];
  [form setEntryWidth: 240];

  [hbox addView: form];

  whoisButton = AUTORELEASE ([NSButton new]);
  if (bigButtons) 
    {
      [whoisButton setImage: [NSImage imageNamed: @"whois"]];
    }
  else
    {
      [whoisButton setImage: [NSImage imageNamed: @"whois32"]];
    }
  [whoisButton setTitle: @"Whois"];
  [whoisButton setFont: font]; 
  [whoisButton setImagePosition: NSImageAbove];
  [whoisButton setAlignment: NSCenterTextAlignment];
  [whoisButton sizeToFit];
  bs = [whoisButton frame].size;
  if (bs.width > f)
    {
      f = bs.width;
    }
  if (bs.height > f)
    {
      f = bs.height;
    }
  [whoisButton setAutoresizingMask: NSViewNotSizable];
  [whoisButton setTarget: self];
  [whoisButton setAction: @selector (startWhois:)];

  fingerButton = AUTORELEASE ([NSButton new]);
  if (bigButtons)
    {
      [fingerButton setImage: [NSImage imageNamed: @"finger"]];
    }
  else
    {
      [fingerButton setImage: [NSImage imageNamed: @"finger32"]];
    }
  [fingerButton setTitle: @"Finger"];
  [fingerButton setFont: font]; 
  [fingerButton setImagePosition: NSImageAbove];
  [fingerButton setAlignment: NSCenterTextAlignment];
  [fingerButton sizeToFit];
  bs = [fingerButton frame].size;
  if (bs.width > f)
    {
      f = bs.width;
    }
  if (bs.height > f)
    {
      f = bs.height;
    }
  [fingerButton setAutoresizingMask: NSViewNotSizable];
  [fingerButton setTarget: self];
  [fingerButton setAction: @selector (startFinger:)];

  pingButton = AUTORELEASE ([NSButton new]);
  if (bigButtons)
    {
      [pingButton setImage: [NSImage imageNamed: @"ping"]];
    }
  else
    {
      [pingButton setImage: [NSImage imageNamed: @"ping32"]];
    }
  [pingButton setTitle: @"Ping"];
  [pingButton setFont: font]; 
  [pingButton setImagePosition: NSImageAbove];
  [pingButton setAlignment: NSCenterTextAlignment];
  [pingButton sizeToFit];
  bs = [pingButton frame].size;
  if (bs.width > f)
    {
      f = bs.width;
    }
  if (bs.height > f)
    {
      f = bs.height;
    }
  [pingButton setAutoresizingMask: NSViewNotSizable];
  [pingButton setTarget: self];
  [pingButton setAction: @selector (startPing:)];

  traceButton = AUTORELEASE ([NSButton new]);
  if (bigButtons)
    {
      [traceButton setImage: [NSImage imageNamed: @"traceroute"]];
    }
  else  
    {
      [traceButton setImage: [NSImage imageNamed: @"traceroute32"]];
    }
  [traceButton setTitle: @"Trace"];
  [traceButton setFont: font]; 
  [traceButton setImagePosition: NSImageAbove];
  [traceButton setAlignment: NSCenterTextAlignment];
  [traceButton sizeToFit];
  bs = [traceButton frame].size;
  if (bs.width > f)
    {
      f = bs.width;
    }
  if (bs.height > f)
    {
      f = bs.height;
    }
  [traceButton setAutoresizingMask: NSViewNotSizable];
  [traceButton setTarget: self];
  [traceButton setAction: @selector (startTraceroute:)];

  stopButton = AUTORELEASE ([NSButton new]);
  if (bigButtons)
    {
      [stopButton setImage: [NSImage imageNamed: @"stop"]];
    }
  else
    {
      [stopButton setImage: [NSImage imageNamed: @"stop32"]];
    }
  [stopButton setTitle: @"Stop"];
  [stopButton setFont: font]; 
  [stopButton setImagePosition: NSImageAbove];
  [stopButton setAlignment: NSCenterTextAlignment];
  [stopButton sizeToFit];
  bs = [stopButton frame].size;
  if (bs.width > f)
    {
      f = bs.width;
    }
  if (bs.height > f)
    {
      f = bs.height;
    }
  [stopButton setAutoresizingMask: NSViewNotSizable];
  [stopButton setTarget: self];
  [stopButton setAction: @selector (stopTask:)];
  [stopButton setEnabled: NO];

  /* Make all the buttons of the same square size */
  bs = NSMakeSize (f, f);
  [fingerButton setFrameSize: bs];
  [whoisButton setFrameSize: bs];
  [pingButton setFrameSize: bs];
  [traceButton setFrameSize: bs];
  [stopButton setFrameSize: bs];  
  
  [hbox addView: fingerButton enablingXResizing: NO withMinXMargin: 12];
  [hbox addView: whoisButton enablingXResizing: NO];
  [hbox addView: pingButton enablingXResizing: NO];
  [hbox addView: traceButton enablingXResizing: NO];
  [hbox addView: stopButton enablingXResizing: NO];
  [hbox setAutoresizingMask: NSViewWidthSizable];
  
  [vbox addView: hbox enablingYResizing: NO];
  
  winFrame.size = [vbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);
  self = [super initWithContentRect: winFrame
		styleMask: (NSTitledWindowMask 
			    | NSClosableWindowMask 
			    | NSMiniaturizableWindowMask 
			    | NSResizableWindowMask)
		backing: NSBackingStoreBuffered
		defer: YES];
  [self setTitle: @"Finger.app"];
  [self setContentView: vbox];
  [self setMinSize: [NSWindow frameRectForContentRect: winFrame
			      styleMask: [self styleMask]].size];
  return self;
}

- (void)taskEnded: (NSNotification *)aNotification
{
  [stopButton setEnabled: NO];
}

-(void)startFinger: (id)sender
{
  NSString *username;
  NSString *hostname;
  NSString *command;
  NSString *argument;

  command = [[NSUserDefaults standardUserDefaults] stringForKey: 
						     @"FingerCommand"];

  username = [[form cellAtIndex: 0] stringValue];
  hostname = [[form cellAtIndex: 1] stringValue];

  if ([hostname length] > 0)
    hostname = [@"@" stringByAppendingString: hostname];
  
  if (username)
    argument = [username stringByAppendingString: hostname];
  else
    argument = hostname;

  [self startTask: command
	withArgument: argument];
}

-(void)startWhois: (id)sender
{
  NSString *command;
  NSString *argument;

  command = [[NSUserDefaults standardUserDefaults] stringForKey: 
						     @"WhoisCommand"];

  argument = [[form cellAtIndex: 1] stringValue];

  [self startTask: command
	withArgument: argument];
}

-(void)startPing: (id)sender
{
  NSString *command;
  NSString *argument;

  command = [[NSUserDefaults standardUserDefaults] stringForKey: 
						     @"PingCommand"];

  argument = [[form cellAtIndex: 1] stringValue];

  [self startTask: command
	withArgument: argument];
}

-(void)startTraceroute: (id)sender
{
  NSString *command;
  NSString *argument;

  command = [[NSUserDefaults standardUserDefaults] stringForKey: 
						     @"TracerouteCommand"];

  argument = [[form cellAtIndex: 1] stringValue];

  [self startTask: command
	withArgument: argument];
}

-(void)startTask: (NSString *)fullBinaryPath
    withArgument: (NSString *)argument
{
  NSArray      *arguments;
  NSFileHandle *fileHandle;
  NSString     *stringToShow;
  NSFileManager *fm;
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

  [self stopTask: self];

  /* Check if binary is executable */
  fm = [NSFileManager defaultManager];
  /* Uhm -- if it is a directory, we are "executing" it.  This will not do any harm ?. */
  if ([fm isExecutableFileAtPath: fullBinaryPath] == NO)
    {
      NSString *alert;
      int       result;

      alert = [fullBinaryPath stringByAppendingString: 
				@" is not executable!"];
      result = NSRunAlertPanel (NULL, alert, @"Cancel", 
				@"Change command", NULL);
      if (result == NS_ALERTALTERNATE)
	{
	  [(Controller *)[NSApp delegate] runPreferencesPanel: self];
	}
      return;
    }

  /* Show command we are issuing in the text view */
  stringToShow = [fullBinaryPath stringByAppendingString: @" "];
  stringToShow = [stringToShow stringByAppendingString: argument];
  stringToShow = [stringToShow stringByAppendingString: @"\n"];
  [text appendBoldString: stringToShow];

  /* Show command in the window title */
  stringToShow = [fullBinaryPath lastPathComponent];
  stringToShow = [stringToShow stringByAppendingString: @" "];
  stringToShow = [stringToShow stringByAppendingString: argument];
  [self setTitle: stringToShow];
  
  /* Run the task */
  ASSIGN (task, AUTORELEASE ([NSTask new]));
  [task setLaunchPath: fullBinaryPath];
  
  arguments = [NSArray arrayWithObjects: argument, nil]; 
  [task setArguments: arguments];

  ASSIGN (pipe[0], [NSPipe pipe]);
  fileHandle = [pipe[0] fileHandleForReading];
  [task setStandardOutput: pipe[0]];
  [fileHandle readInBackgroundAndNotify];
  [nc addObserver: self 
      selector: @selector(readData:) 
      name: NSFileHandleReadCompletionNotification
      object: (id) fileHandle];
  
  ASSIGN (pipe[1], [NSPipe pipe]);
  fileHandle = [pipe[1] fileHandleForReading];
  [task setStandardError: pipe[1]];
  [fileHandle readInBackgroundAndNotify];
  [nc addObserver: self 
      selector: @selector(readData:) 
      name: NSFileHandleReadCompletionNotification
      object: (id) fileHandle];

  [nc addObserver: self 
      selector: @selector(taskEnded:) 
      name: NSTaskDidTerminateNotification 
      object: (id) task];

  [task launch];
  
  [stopButton setEnabled: YES];
}

-(void)stopTask: (id)sender
{
  NSFileHandle *fileHandle;

  if ([task isRunning])
    {    
      /* Be fine so that ping gives us all the statistical infos */
      [task interrupt];
      if ([task isRunning])
	[task terminate];
      /* Now wait 0.1 seconds for the ping statistical info */ 
      /* [FIXME Some better solution -- or at least make the 0.1
           seconds configurable] */
      [[NSRunLoop currentRunLoop] 
	runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.1]];
      /* Then discard the remaining data */
      fileHandle = [pipe[0] fileHandleForReading];
      [fileHandle closeFile];    
      fileHandle = [pipe[1] fileHandleForReading];
      [fileHandle closeFile];
      /* Remove us from notifications */
      [[NSNotificationCenter defaultCenter] 
	removeObserver: self 
	name: NSFileHandleReadCompletionNotification
	object: nil];
      [[NSNotificationCenter defaultCenter] 
	removeObserver: self 
	name: NSTaskDidTerminateNotification
	object: nil];
    }
}

-(void)readData: (NSNotification *)aNotification
{
  NSData   *readData;
  NSString *readString;
  NSFileHandle *fileHandle;
  
  readData = [[aNotification userInfo] 
	       objectForKey: NSFileHandleNotificationDataItem];
  readString = [[NSString alloc] initWithData: readData
				 encoding:  NSNonLossyASCIIStringEncoding];
  AUTORELEASE (readString);
  [text appendString: readString];
  
  if ([task isRunning])
    {
      fileHandle = [pipe[0] fileHandleForReading];
      if ([fileHandle readInProgress] == NO)
	[fileHandle readInBackgroundAndNotify];

      fileHandle = [pipe[1] fileHandleForReading];
      if ([fileHandle readInProgress] == NO)
	[fileHandle readInBackgroundAndNotify];
    }
}

- (void)resetResults: (id)sender
{
  [self stopTask: self];
  [text setString: nil];
}

- (void)saveResults: (id)sender
{
  NSSavePanel *savePanel;
  int result;

  [self stopTask: self];

  savePanel = [NSSavePanel savePanel];
  result = [savePanel runModal];
  if (result == NSOKButton)
    {
      /* TODO: Ask before overwriting file ?*/
      [[text string] writeToFile: [savePanel filename] 
		     atomically: YES];
    }
}

/* Not used now */
- (void)controlTextDidEndEditing: (NSNotification *)aNotification
{
  [self startFinger: self];
}

@end
