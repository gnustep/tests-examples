/*
 *  TrivialTextView.h: A Text View for Finger.app
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

/*
 * Taken with modifications from GSTest/StringDrawing
 */

/*
 * This object displays uneditable, unselectable attributed text.
 */
@interface TrivialTextView: NSView
{
  NSDictionary *bold;
  NSDictionary *normal;
  NSMutableAttributedString *str;
}
-(void) setString: (NSString *)s;
-(NSString *) string;
-(void) appendAttributedString: (NSMutableAttributedString *)s;
-(void) appendString: (NSString *)s;
-(void) appendBoldString: (NSString *)s;
-(void) sizeToFit;
@end

