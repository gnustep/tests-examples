/*
 *  ButtonWithValidation.h: An application to demonstrate the GNUstep toolbars 
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
 
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>

@interface ButtonWithValidation : NSButton
{

}

- (BOOL) validateToolbarItem: (NSToolbarItem *)toolbarItem;

@end
