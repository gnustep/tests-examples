/* Document.m Subclass of NSDocument for Ink application

   Copyright (C) 2000 Free Software Foundation, Inc.

   Author:  Fred Kiefer <fredkiefer@gmx.de>
   Date: 2000
   
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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
#include <AppKit/AppKit.h>
#include <AppKit/NSWindowController.h>
#include "Document.h"

@interface Document (Private)

- (NSWindow*) makeWindow;

@end

@implementation Document

- (id) init
{
  [super init];

  ts = [[NSMutableAttributedString alloc] init];
  return self;
}

- (void) dealloc
{
  RELEASE (ts);
  RELEASE (tv);
  RELEASE (pi);
  [super dealloc];
}

- (NSFileWrapper *)fileWrapperRepresentationOfType:(NSString *)type
{
  if ([type isEqualToString:@"rtfd"])
    {
      NSAttributedString *attr;

      if (tv != nil)
	attr = [tv textStorage];
      else
	attr = ts;

      return [attr RTFDFileWrapperFromRange: NSMakeRange(0, [attr length]) 
		   documentAttributes: [[self printInfo] dictionary]]; 
    }
  else
    {
      return [super fileWrapperRepresentationOfType: type];
    }
}

- (NSData *)dataRepresentationOfType:(NSString *)aType 
{
  NSAttributedString *attr;

  if (tv != nil)
    {
      attr = [tv textStorage];
    }
  else
    {
      attr = ts;
    }

  if (aType == nil)
    {
      aType = @"text";
    }

  if ([aType isEqualToString: @"rtf"])
    {
      return [attr RTFFromRange: NSMakeRange (0, [attr length]) 
		   documentAttributes: [[self printInfo] dictionary]]; 
    }
  else if ([aType isEqualToString:@"rtfd"])
    {
      return [attr RTFDFromRange: NSMakeRange (0, [attr length]) 
		   documentAttributes: [[self printInfo] dictionary]]; 
    }
  else if ([aType isEqualToString:@"text"])
    {
      return [[attr string] dataUsingEncoding: 
			      [NSString defaultCStringEncoding]]; 
    }
  else
    {
      NSAssert (NO, ([NSString stringWithFormat: @"Unknown type %@", aType]));
      return nil;
    }
}

- (BOOL)loadFileWrapperRepresentation:(NSFileWrapper *)wrapper 
			       ofType:(NSString *)type
{
  if ([type isEqualToString:@"rtfd"])
    {
      NSAttributedString *attr;
  
      attr = [[NSAttributedString alloc] initWithRTFDFileWrapper: wrapper 
					 documentAttributes: NULL];

      if (tv != nil)
	[[tv textStorage] setAttributedString: attr];
      else 
	[ts setAttributedString: attr];

      RELEASE(attr);
      return YES;
    }
  else
    {
      return [super loadFileWrapperRepresentation: wrapper 
		    ofType: type];
    }
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType 
{
  NSAttributedString *attr;

  if ([aType isEqualToString:@"rtf"])
    {
      attr = [[NSAttributedString alloc] initWithRTF: data 
					 documentAttributes: NULL];
    }
  else if ([aType isEqualToString:@"rtfd"])
    {
      attr = [[NSAttributedString alloc] initWithRTFD: data 
					 documentAttributes: NULL];
    }
  else if ([aType isEqualToString:@"text"])
    {
      attr = [[NSAttributedString alloc] 
		 initWithString: AUTORELEASE([[NSString alloc] initWithData: data
							       encoding: [NSString defaultCStringEncoding]])];
    }
  else
    {
      NSAssert(NO, ([NSString stringWithFormat: @"Unknown type %@", aType]));
      return NO;
    }

  if (tv != nil)
    [[tv textStorage] setAttributedString: attr];
  else 
    [ts setAttributedString: attr];

  RELEASE(attr);
  return YES;
}

- (void) makeWindowControllers
{
  NSWindowController *controller;
  NSWindow *win = [self makeWindow];
  
  controller = [[NSWindowController alloc] initWithWindow: win];
  RELEASE (win);
  [self addWindowController: controller];
  RELEASE(controller);

  // We have to do this ourself, as there is currently no nib file
  [self windowControllerDidLoadNib: controller];
} 

- (void)printShowingPrintPanel:(BOOL)flag
{
  NSPrintOperation *po = [NSPrintOperation printOperationWithView: tv
					   printInfo: [self printInfo]];

  [po setShowPanels: flag];
  [po runOperation];
}


- (void)windowControllerDidLoadNib:(NSWindowController *) aController;
{
  [super windowControllerDidLoadNib:aController];

  [[tv textStorage] setAttributedString: ts];
  DESTROY(ts);
}

- (void)textDidChange:(NSNotification *)textObject 
{
  [self updateChangeCount: NSChangeDone];
}

@end

@implementation Document (Private)

- (NSWindow*)makeWindow
{
  NSWindow *window;
  NSScrollView* scrollView;
  NSTextView* textView;
  NSRect scrollViewRect = {{0, 0}, {470, 400}};
  NSRect winRect = {{100, 100}, {470, 400}};
  NSRect textRect;
  unsigned int style = NSTitledWindowMask | NSClosableWindowMask | 
      NSMiniaturizableWindowMask | NSResizableWindowMask;
  
  // This is expected to be retained, as it would normaly come from a
  // nib file, where the owner would retain it.
  window = [[NSWindow alloc] initWithContentRect: winRect
			     styleMask: style
			     backing: NSBackingStoreRetained
			     defer: NO];
   
  scrollView = [[NSScrollView alloc] initWithFrame: scrollViewRect];
  [scrollView setHasHorizontalScroller: NO];
  [scrollView setHasVerticalScroller: YES]; 
  [scrollView setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];
  [[scrollView contentView] setAutoresizingMask: NSViewHeightSizable 
			    | NSViewWidthSizable];
  [[scrollView contentView] setAutoresizesSubviews:YES];

  // Build up the text network
  textRect = [[scrollView contentView] frame];
  textView = [[NSTextView alloc] initWithFrame: textRect];

  [textView setBackgroundColor: [NSColor whiteColor]];
  [textView setRichText: YES];
  [textView setUsesFontPanel: YES];
  [textView setDelegate: self];
  [textView setHorizontallyResizable: NO];
  [textView setVerticallyResizable: YES];
  [textView setMinSize: NSMakeSize (0, 0)];
  [textView setMaxSize: NSMakeSize (1E7, 1E7)];
  [textView setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];
  [[textView textContainer] setContainerSize: NSMakeSize (textRect.size.width,
							  1e7)];
  [[textView textContainer] setWidthTracksTextView: YES];
  // Store the text view in an ivar
  ASSIGN(tv, textView);

  [scrollView setDocumentView: textView];
  RELEASE(textView);
  [window setContentView: scrollView];
  RELEASE(scrollView);

  // Make the Document the delegate of the window
  [window setDelegate: self];

  // Make the text view the first responder
  [window makeFirstResponder: textView];
  [window display];
  [window orderFront: nil];

  return window;
}

- (void)insertFile: (id)sender
{
  static NSString  *lastDir = nil;  
  static NSView    *accView = nil;
  static NSButton  *asIconButton;
  
  NSTextAttachment *attachment;
  NSFileWrapper    *wrapper;
  NSOpenPanel      *panel;
  int               ret;
  id                object = nil;
  NSString         *ext;
  NSString         *filename;
  
  NSEnumerator     *enumerator;
  NSString         *type;
  BOOL              isImage = NO;
  
  if (accView == nil)
    {
      accView = [[NSView alloc] initWithFrame: 
				  NSMakeRect (0.0, 0.0, 100.0, 24.0)];
      asIconButton = [[NSButton alloc] initWithFrame:
					 NSMakeRect (0.0, 0.0, 100.0, 24.0)];
      [asIconButton setButtonType: NSSwitchButton];
      [asIconButton setTitle: @"Insert as icon"];
      /* tooltips are not implemented, but this is for the future ... */
      [asIconButton setToolTip: @"Insert file type icon instead of file contents"];

      [accView addSubview: asIconButton];
    }

  if (lastDir == nil)
    {
      ASSIGN (lastDir, NSHomeDirectory ());
    }
  
  panel = [NSOpenPanel openPanel];
  
  [panel setAccessoryView: accView];
  [panel setAllowsMultipleSelection: NO];
  ret = [panel runModalForDirectory: lastDir   file: nil   types: nil];
  
  ASSIGN (lastDir, [panel directory]);
  
  if (ret == NSOKButton) 
    {
      filename = [panel filename];
      
      ext = [filename pathExtension];
      
      if ([asIconButton state] != NSOnState)
        {
	  if (ext == nil  
	      ||  [ext isEqualToString: @""]	 
	      || [ext isEqualToString: @"txt"] 
	      || [ext isEqualToString: @"text"])
            {
	      object = [NSString stringWithContentsOfFile: filename];
            }
	  else if ([ext isEqualToString: @"rtf"])
            {
	      NSData *data = [NSData dataWithContentsOfFile: filename];
	      
	      object = [[NSAttributedString alloc] initWithRTF: data
						   documentAttributes: NULL];
	      AUTORELEASE (object);
            }
	  else if ([ext isEqualToString: @"rtfd"])
            {
	      NSData *data = [NSData dataWithContentsOfFile: filename];
	      
	      object = [[NSAttributedString alloc] initWithRTFD: data
						   documentAttributes: NULL];
	      AUTORELEASE (object);
            }
        }
      
      if (object == nil)
        {
	  wrapper = [[NSFileWrapper alloc] initWithPath: filename];
	  AUTORELEASE (wrapper);

	  /* Insert image contents */
	  if ([asIconButton state] != NSOnState)
            {    
	      enumerator = [[NSImage imageFileTypes] objectEnumerator];
	      
	      while ((type = [enumerator nextObject]) != nil)
                {
		  if ([ext isEqualToString: type])
                    {
		      isImage = YES;
		      break;
                    }
                }
	      
	      if (isImage)
                {
		  NSImage *image;
		  
		  image = [[NSImage alloc] initWithContentsOfFile: filename];
		  AUTORELEASE (image);
		  [wrapper setIcon: image];
                }
            }
	  
	  attachment = [[NSTextAttachment alloc] initWithFileWrapper: 
						   wrapper];
	  AUTORELEASE (attachment);
	  object = [NSAttributedString attributedStringWithAttachment: 
					 attachment];
        }
      
      if (object != nil)
        {
	  [tv insertText: object];
        }
    }
}

-        (void)textView: (NSTextView *)aTextView
    doubleClickedOnCell: (id <NSTextAttachmentCell>)attachmentCell
                 inRect: (NSRect)cellFrame
                atIndex: (unsigned)charIndex
{
  NSTextAttachment *attachment;
  NSFileWrapper    *filewrapper;
  
  attachment  = [attachmentCell attachment];
  filewrapper = [attachment fileWrapper];
  
  NSLog(@"Opening file '%@'", [filewrapper filename]);
  
  /* openFile:fromImage:at:inView: */
  [[NSWorkspace sharedWorkspace] openFile: [filewrapper filename]];
}
@end
