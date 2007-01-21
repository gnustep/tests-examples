/*
 *  TrivialTextView.m: A Text View for Finger.app
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
#import "TrivialTextView.h"

@implementation TrivialTextView
-(id) init
{
  NSDictionary *dict;

  dict = [NSDictionary dictionaryWithObjectsAndKeys: 
			 [NSFont userFixedPitchFontOfSize: 0], 
		       NSFontAttributeName,
		       [NSColor textColor], 
		       NSForegroundColorAttributeName,
		       nil];
  ASSIGN (normal, dict);

  dict = [NSDictionary dictionaryWithObjectsAndKeys:
			 [NSFont boldSystemFontOfSize: 0], 
		       NSFontAttributeName,
		       [NSColor textColor], 
		       NSForegroundColorAttributeName,
		       nil];
  ASSIGN (bold, dict); 

  return [super init];
}
-(void) dealloc
{
  RELEASE (normal);
  RELEASE (bold);
  TEST_RELEASE (str);
  [super dealloc];
}
-(void) setString: (NSString *)s
{
  NSMutableAttributedString *attr;

  attr = [[NSMutableAttributedString alloc] initWithString:  s
					    attributes: normal];
  AUTORELEASE (attr);
  ASSIGN (str, attr);
  [self sizeToFit];
}
-(NSString *)string
{
  return [str string];
}
-(void) appendAttributedString: (NSMutableAttributedString *)s
{
  if (str)
    [str appendAttributedString: s];
  else
    ASSIGN (str, s);
  
  [self sizeToFit];  
}
-(void) appendString: (NSString *)s
{
  NSMutableAttributedString *attr;
  
  attr = [[NSMutableAttributedString alloc] initWithString:  s
					    attributes: normal];
  AUTORELEASE (attr);
  [self appendAttributedString: attr];
}
-(void) appendBoldString: (NSString *)s
{
  NSMutableAttributedString *attr;
  
  attr = [[NSMutableAttributedString alloc] initWithString:  s
					    attributes: bold];
  AUTORELEASE (attr);
  /* Now we check that the last character in the text is a newline. 
     If it isn't, we append a newline to it before the bold string */
  if ([[str mutableString] hasSuffix: @"\n"] == NO)
    [self appendString: @"\n"];

  [self appendAttributedString: attr];
}
-(void) sizeToFit
{
  if (str)
    [self setFrameSize: [str size]];
  else
    [self setFrameSize: NSZeroSize];

  /* A hard way of acting but anyway we want no risks */
  [[self window] display];
}
-(void) drawRect: (NSRect)rect
{
  if (str) 
    [str drawInRect: [self bounds]];
}
@end

