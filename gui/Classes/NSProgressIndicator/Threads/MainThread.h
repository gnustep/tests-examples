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
#ifndef MAIN_THREAD_H
#define MAIN_THREAD_H

#include <Foundation/Foundation.h>

@class NSProgressIndicator, NSTextField, NSWindow;

@interface MainThread : NSObject
{
  NSTimer *timer;
  NSProgressIndicator *pi;
  NSTextField *field;
  NSWindow *window;
}
- (void)applicationDidFinishLaunching: (NSNotification *)aNotification;
- (void)start: (id)sender;
- (void)updateProgressIndicator: (NSTimer *)timer;
@end

#endif /* MAIN_THREAD_H */
