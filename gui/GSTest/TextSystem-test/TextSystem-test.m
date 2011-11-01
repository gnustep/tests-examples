/* TextSystem-test.m: test fonts, glyphs

   Copyright (C) 2011 Free Software Foundation, Inc.

   Author:  Eric Wasylishen <ewasylishen@gmail.com>
   Date: 2011
   
   This file is part of GNUstep.
   
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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "../GSTestProtocol.h"


static NSGlyph GlyphForCharacter(NSFont *f, unichar c)
{
  NSTextView *view = [[NSTextView alloc] init];
  NSGlyph g = 0;
  [view setFont: f];
  [view setString: [[[NSString alloc] initWithCharacters: &c length: 1] autorelease]];
  if ([[view layoutManager] numberOfGlyphs] > 0)
    {
      [[view layoutManager] getGlyphs: &g range: NSMakeRange(0, 1)];
    }
  [view release];
  return g;
}

static NSGlyph GlyphForAttributedStringIndex(NSAttributedString *as, NSUInteger i)
{
  NSFont *f = [as attribute: NSFontAttributeName atIndex: i effectiveRange: NULL];
  if (f == nil)
    {
      f = [NSFont systemFontOfSize: 0];
    }
  return GlyphForCharacter(f, [[as string] characterAtIndex: i]);
}

/**
 * This glyph generator reverses the input string
 */
@interface CrazyGlyphGenerator : NSGlyphGenerator
{
}
@end

@implementation CrazyGlyphGenerator

- (void) generateGlyphsForGlyphStorage: (id <NSGlyphStorage>)storage
             desiredNumberOfCharacters: (NSUInteger)num
                            glyphIndex: (NSUInteger*)glyph
                        characterIndex: (NSUInteger*)index
{
  NSAttributedString *as = [storage attributedString];
  NSUInteger len = [as length];

  NSUInteger i;
  for (i=*index; i<(*index + num); i++)
    {
      NSGlyph g = GlyphForAttributedStringIndex(as, i);
      [storage insertGlyphs: &g
		     length: 1
	       forStartingGlyphAtIndex: (len - i)
	     characterIndex: i];
    }

 *index = *index + num;
 *glyph = *glyph + num;
}

@end



static void AddLabel(NSString *text, NSRect frame, NSView *dest)
{
  NSTextField *labelView = [[NSTextField alloc] initWithFrame: frame];
  [labelView setStringValue: text];
  [labelView setEditable: NO];
  [labelView setSelectable: NO];
  [labelView setBezeled: NO];
  [labelView setFont: [NSFont labelFontOfSize: 10]];
  [labelView setDrawsBackground: NO];
  [dest addSubview: labelView];
  [labelView release];
}

@interface TextSystemTest : NSObject <GSTest>
{
  NSWindow *win;
}
-(void) restart;
@end

@interface TextSystemTestView : NSView
{
}

  
@end

@implementation TextSystemTestView

- (id)initWithFrame: (NSRect)frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
    {
      AddLabel(@"The text view below has a glyph generator which reverses the input string. It should display HelloWorld backwards (dlroWolleH)", NSMakeRect(0, 310, 400, 50), self);

      
      {
	NSTextContainer *tc1;	
	NSTextView *tv1;
	NSLayoutManager *lm1;	
	NSTextStorage *storage;
	NSGlyphGenerator *gg;

	gg = [[CrazyGlyphGenerator alloc] init];

	storage = [[NSTextStorage alloc] init];
	
	lm1 = [[NSLayoutManager alloc] init];
	[lm1 setGlyphGenerator: gg];
	[gg release];
	[storage addLayoutManager: lm1];
	[lm1 release];
	
	tc1 = [[NSTextContainer alloc] initWithContainerSize: NSMakeSize(150, 150)];
	[lm1 addTextContainer: tc1];
	[tc1 release];
	tv1 = [[NSTextView alloc] initWithFrame: NSMakeRect(0, 0, 150,150) textContainer: tc1];		
	
	[self addSubview: tv1];
	[tv1 release]; 
	
	[[storage mutableString] appendString: @"HelloWorld"];
      }
    }
  return self;
}

@end

@implementation TextSystemTest : NSObject

-(id) init
{
  NSView *content;
  content = [[TextSystemTestView alloc] initWithFrame: NSMakeRect(0,0,400,360)];

  // Create the window
  win = [[NSWindow alloc] initWithContentRect: [content frame]
			  styleMask: (NSTitledWindowMask 
				      | NSClosableWindowMask 
				      | NSMiniaturizableWindowMask 
				      | NSResizableWindowMask)
			  backing: NSBackingStoreBuffered
			  defer: NO];
  [win setReleasedWhenClosed: NO];
  [win setContentView: content];
  [win setMinSize: [win frame].size];
  [win setTitle: @"TextSystem Test"];
  [self restart];
  return self;
}

-(void) restart
{
  [win orderFront: nil]; 
  [[NSApplication sharedApplication] addWindowsItem: win
				     title: [win title]
				     filename: NO];
}

- (void) dealloc
{
  RELEASE (win);
  [super dealloc];
}

@end
