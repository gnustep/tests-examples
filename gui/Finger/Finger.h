/*
 *  Finger.h: A GNUstep simple demo: a finger front-end
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

/* 
 * You may edit the following three (recommended if you are
 * distributing this program bundled in some distribution.)  
 */
#define FINGER_DEFAULT_COMMAND     @"/usr/bin/finger"
#define PING_DEFAULT_COMMAND       @"/bin/ping"
#define TRACEROUTE_DEFAULT_COMMAND @"/usr/sbin/traceroute"

/*
 * Version Number
 */
#define NAME_WITH_SHORT_VERSION @"Finger 0.7"
#define FULL_VERSION            @"0.7.2, Feb 2000"

/*
 * Libraries
 */
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <AppKit/GSHbox.h>
#import <AppKit/GSVbox.h>

