/*
 *  CurrencyConverter.h
 *
 *  Copyright (c) 1999 Free Software Foundation, Inc.
 *  
 *  Author: Nicola Pero
 *  Date: November 1999
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

// Library headers
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

// @interface 'class' : 'superClass'
@interface CurrencyConverter : NSObject <NSTextFieldDelegate>
{
  // Instance variables
  NSTextField* field[3];
  NSWindow* window;
}
// Methods
- (id)init;
- (void)dealloc;
- (void)controlTextDidEndEditing: (NSNotification *)aNotification;
- (void)applicationDidFinishLaunching: (NSNotification *)aNotification;
@end







