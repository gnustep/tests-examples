/*
 *  Controller.h: An application to demonstrate GNUstep toolbars 
 *
 *  Copyright (c) 2004 Free Software Foundation, Inc.
 *  
 *  Author: Quentin Mathe <qmathe@club-internet.fr>
 *  Date: March 2004
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

@interface Controller : NSObject
{
  id newItemName;
  id toolbarButton;
  id firstItemSwitch;
  id popUpField;
  id sliderField;
  id window;
  id popUpMenuSize;
  id popUpMenuDisplay;
  id whatever;
}

- (void) toggleToolbar: (id)sender;
- (void) setFirstItemLabel: (id)sender;
- (void) setSecondItemImage: (id)sender;
- (void) newItem:(id)sender;
- (void) popUpMenuDisplayChanged: (id)sender;
- (void) popUpMenuSizeChanged: (id)sender;
- (void) newWindow:(id)sender;
- (void) reflectMenuSelection: (id)sender;
@end
