/* infoPanel.m: Info Panel for GNUstep GUI Test Suite

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999
   
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
#include "infoPanel.h"
#include <AppKit/GSHbox.h>
#include <AppKit/GSVbox.h>


// This simply shows some non-editable text
@interface Label: NSTextField
{
}
-(id) initWithText: (NSString *)aText;
@end

@implementation Label 
{
}
-(id) init
{
  return [self initWithText: nil];
}
-(id) initWithText: (NSString *)aText
{
  [super initWithFrame: NSZeroRect];
  [self setEditable: NO];
  [self setSelectable: NO];
  [self setBezeled: NO];
  [self setBordered: NO];
  [self setDrawsBackground: NO];
  [self setAlignment: NSCenterTextAlignment];
  [self setStringValue: aText];
  [self sizeToFit];
  return self;
}
@end

@implementation infoPanel: NSPanel
{
}
-(id) init
{
  // Labels
  Label *title;
  Label *subtitle;
  Label *authors;
  Label *version;
  Label *fsf;
  Label *copyrightOne;
  Label *copyrightTwo;
  // Text *description;
  NSImageView *logo;

  // General vbox
  GSVbox *vbox;
  // Lower part
  GSVbox *lowerVbox;
  // Upper part
  GSHbox *hbox;
  GSVbox *upperVbox;
  // Window frame
  NSRect winFrame;

  vbox = [GSVbox new];

  // Lower Part of the Panel
  lowerVbox = [GSVbox new];
  [lowerVbox setBorder: 5];

  copyrightTwo = [Label new];
  [copyrightTwo setStringValue: 
		  @"it under the terms of the GNU General Public License."];
  [copyrightTwo setFont: [NSFont systemFontOfSize: 10]];
  [copyrightTwo setAutoresizingMask: NSViewMaxXMargin | NSViewMinXMargin];
  [copyrightTwo sizeToFit];
  [lowerVbox addView: copyrightTwo];
  [copyrightTwo release];

  copyrightOne = [Label new];
  [copyrightOne 
    setStringValue: 
      @"This program is free software; you can redistribute it and/or modify"];
  [copyrightOne setFont: [NSFont systemFontOfSize: 10]];
  [copyrightOne setAutoresizingMask: NSViewMaxXMargin | NSViewMinXMargin];
  [copyrightOne sizeToFit];
  [lowerVbox addView: copyrightOne];
  [copyrightOne release];

  fsf = [Label new];
  [fsf setStringValue: @"Copyright (C) 1999, 2000 Free Software Foundation, Inc."];  
  [fsf setFont: [NSFont systemFontOfSize: 10]];
  [fsf setAutoresizingMask: NSViewMaxXMargin | NSViewMinXMargin];
  [fsf sizeToFit];
  [lowerVbox addView: fsf];
  [fsf release];
  
  authors = [Label new];
  [authors setStringValue: @"Author: Nicola Pero <n.pero@mi.flashnet.it>"];
  [authors setFont: [NSFont systemFontOfSize: 10]];
  [authors setAutoresizingMask: NSViewMaxXMargin | NSViewMinXMargin];
  [authors sizeToFit];
  [lowerVbox addView: authors];
  [authors release];

  [vbox addView: lowerVbox];
  [lowerVbox release];

  // Separator
  [vbox addSeparator];

  // Upper Part of the Panel 
  hbox = [GSHbox new];
  [hbox setBorder: 5];
  
  logo = [NSImageView new];
  [logo setImage: [NSImage imageNamed: @"GNUstep.tiff"]];
  [logo setImageFrameStyle: NSImageFrameNone];
  [logo setEditable: NO];
  [logo sizeToFit];
  [logo setAutoresizingMask: (NSViewMinXMargin | NSViewMaxXMargin
			      | NSViewMinYMargin | NSViewMaxYMargin)];
  [hbox addView: logo];
  [logo release];

  upperVbox = [GSVbox new];
  version = [Label new];
#ifdef GNUSTEP_SUBMINOR_VERSION
  [version setStringValue: [NSString stringWithFormat:
				       @"GNUstep Version: %d.%d.%d", 
				     GNUSTEP_MAJOR_VERSION, 
				     GNUSTEP_MINOR_VERSION,
				     GNUSTEP_SUBMINOR_VERSION]];
#else 
  [version setStringValue: [NSString stringWithFormat:
				       @"GNUstep Version: %d.%d.x", 
				     GNUSTEP_MAJOR_VERSION, 
				     GNUSTEP_MINOR_VERSION]];
#endif
  [version setFont: [NSFont systemFontOfSize: 12]];
  [version setAutoresizingMask: NSViewMinXMargin];
  [version sizeToFit];
  [upperVbox addView: version];
  [version release];

  subtitle = [Label new];
  [subtitle setStringValue: @"GNUstep GUI test/demo app"];
  [subtitle setFont: [NSFont boldSystemFontOfSize: 16]];
  [subtitle setAutoresizingMask: NSViewMinXMargin | NSViewMaxXMargin];
  [subtitle sizeToFit];
  [upperVbox addView: subtitle];
  [subtitle release];

  title = [Label new];
  [title setStringValue: @"GSTest.app"];
  [title setFont: [NSFont boldSystemFontOfSize: 18]];
  [title setAutoresizingMask: NSViewMaxXMargin | NSViewMinXMargin];
  [title sizeToFit];
  [upperVbox addView: title];
  [title release];
  [upperVbox setAutoresizingMask: NSViewMaxXMargin];

  [hbox addView: upperVbox];
  [upperVbox release];  
  [hbox setAutoresizingMask: NSViewWidthSizable];

  [vbox addView: hbox];
	//	margin: 10];
  [hbox release];

  // Window
  winFrame.size = [vbox frame].size;
  winFrame.origin = NSMakePoint (100, 100);

  [self initWithContentRect: winFrame
	styleMask: (NSTitledWindowMask | NSClosableWindowMask)
	backing: NSBackingStoreBuffered
	defer: NO];
  [self setContentView: vbox];
  [vbox release];
  [self setTitle: @"Info Panel"];
  [self center];
  return self;
}
@end








