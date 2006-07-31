/*
 *  ButtonWithValidation.m: An application to demonstrate the GNUstep toolbars 
 *
 *  Copyright (c) 2004 Free Software Foundation, Inc.
 *  
 *  Author: Quentin Mathe <qmathe@club-internet.fr>
 *  Date: May 2004
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

#include "ButtonWithValidation.h"

@implementation ButtonWithValidation

/* This method is called when ButtonWithValidation instances are set as toolbar
   item's target. When the toolbar item needs to validate itself, it checks 
   whether its target adopts this validation protocol or not. If the protocol
   is adopted, the validation is delegated to the target (otherwise it is 
   handled automatically).
   With the code below, the toolbar item is validated in accordance with the 
   button state, in our case this is when the check box is checked. We use
   ButtonWithValidation as a superclass for the check box that allows to turn
   on and off this custom toolbar validation. */
- (BOOL) validateToolbarItem: (NSToolbarItem *)toolbarItem
{
  NSLog(@"check box validate");
  return [self state];
}

@end
