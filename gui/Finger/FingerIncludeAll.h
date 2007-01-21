/*
 *  FingerIncludeAll.h: A GNUstep simple demo: a finger front-end
 *
 *  Copyright (c) 2007 Free Software Foundation, Inc.
 *  
 *  Author: Nicola Pero
 *  Date: February 2007
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

/* This file includes all the library headers that all files in this project use.  */

/* The reason for having such a wide include is to speed up
 * compilation where precompiled headers are available.  By setting
 * xxx_OBJC_PRECOMPILED_HEADERS = <this file> in the GNUmakefile, the
 * file gets precompiled and then automatically reused when compiled
 * the rest, gaining a massive speed up in compilation speed.
 */
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <GNUstepGUI/GSHbox.h>
#import <GNUstepGUI/GSVbox.h>

