/*
 *  FingerWindow.h: One of Finger.app windows
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

#import "Finger.h"
#import "Controller.h"
#import "TrivialTextView.h"

@interface FingerWindow : NSWindow
{
  NSButton *stopButton;
  NSForm *form;
  TrivialTextView *text;
  
  NSPipe *pipe[2];
  NSTask *task; 
}
-(void)resetResults: (id)sender;
-(void)saveResults: (id)sender;
-(void)startFinger: (id)sender;
-(void)startPing: (id)sender;
-(void)startTraceroute: (id)sender;
-(void)startTask: (NSString *)fullBinaryPath
    withArgument: (NSString *)argument;
-(void)stopTask: (id)sender;
-(void)taskEnded: (NSNotification *)aNotification;
-(void)readData: (NSNotification *)aNotification;
-(void)controlTextDidEndEditing: (NSNotification *)aNotification;
@end

