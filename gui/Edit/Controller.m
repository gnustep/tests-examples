/*
        Controller.m
	Copyright (c) 1995-1996, NeXT Software, Inc.
        All rights reserved.
        Author: Ali Ozer

	You may freely copy, distribute and reuse the code in this example.
	NeXT disclaims any warranty of any kind, expressed or implied,
	as to its fitness for any particular use.

   	Central controller object for Edit...

   GNUstep changes are:
   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Felipe A. Rodriguez <far@ix.netcom.com>
   Date: November 1998

   This file is part of the GNUstep GUI X/RAW Library.
   
   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.
   
   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.
   
   You should have received a copy of the GNU Library General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#import <AppKit/AppKit.h>
#import "Controller.h"
#import "Document.h"


@implementation Controller

- (void)method:menuCell								// temp for sake of menu
{
  	NSLog (@"method invoked from cell with title '%@'", [menuCell title]);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
NSWindow *window;
NSScrollView* scrollView;
NSTextView* textView;
Document *document;
NSString *string;
NSRect scrollViewRect = {{0, 0}, {470, 400}};
NSRect winRect = {{100, 100}, {470, 400}};
id openPanel;
NSColor* backColor;
unsigned int style = NSTitledWindowMask | NSClosableWindowMask				
					| NSMiniaturizableWindowMask | NSResizableWindowMask;

	window = [[NSWindow alloc] initWithContentRect:winRect
								styleMask:style
								backing:NSBackingStoreRetained
								defer:NO];

        [window setRepresentedFilename: @"Edit"];
        [window setDocumentEdited: NO];

	document = [[Document new] initWithPath:nil encoding:UnknownStringEncoding 
										  		uniqueZone:NO];
	scrollView = [[NSScrollView alloc] initWithFrame:scrollViewRect];
	[scrollView setHasHorizontalScroller:NO];
	[scrollView setHasVerticalScroller:YES]; 
	[scrollView setAutoresizingMask: NSViewHeightSizable];

	textView = [document firstTextView];
	[textView setFrame:[[scrollView contentView] frame]];
	backColor = [NSColor colorWithCalibratedWhite:0.85 alpha:1.0]; // off white
	[textView setBackgroundColor:backColor];					
//	[textView setBackgroundColor:[NSColor whiteColor]];					
	string = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] 
			  bundlePath] stringByAppendingString:@"/Resources/Readme.txt"]];
	[textView setString:string];
	[scrollView setDocumentView:textView];
	[[window contentView] addSubview: scrollView];

	[window setTitle:@"Edit"];
	[window display];
	[window orderFront:nil];

//	openPanel = [NSOpenPanel openPanel];
//	[openPanel display];
//	[openPanel runModalForDirectory:@"/" file:@""];
}

- (BOOL)applicationShouldTerminate:(NSApplication *)app {
    NSArray *windows = [NSApp windows];
    unsigned count = [windows count];
    BOOL needsSaving = NO;

    // Determine if there are any unsaved documents...

    while (!needsSaving && count--) {
        NSWindow *window = [windows objectAtIndex:count];
        Document *document = [Document documentForWindow:window];
        if (document && [document isDocumentEdited]) needsSaving = YES;
    }

    if (needsSaving) {
        int choice = NSRunAlertPanel(NSLocalizedString(@"Quit", @"Title of alert panel which comes up when user chooses Quit and there are unsaved documents."), 
			NSLocalizedString(@"You have unsaved documents.", @"Message in the alert panel which comes up when user chooses Quit and there are unsaved documents."), 
			NSLocalizedString(@"Review Unsaved", @"Choice (on a button) given to user which allows him/her to review all unsaved documents if he/she quits the application without saving them all first."), 
			NSLocalizedString(@"Quit Anyway", @"Choice (on a button) given to user which allows him/her to quit the application even though there are unsaved documents."), 
			NSLocalizedString(@"Cancel", @"Button choice allowing user to cancel."));
        if (choice == NSAlertOtherReturn)  {		/* Cancel */
            return NO;
        } else if (choice != NSAlertAlternateReturn) {	/* Review unsaved; Quit Anyway falls through */
            count = [windows count];
            while (count--) {
                NSWindow *window = [windows objectAtIndex:count];
                Document *document = [Document documentForWindow:window];
                if (document) {
                    [window makeKeyAndOrderFront:nil];
                    if (![document canCloseDocument]) {
                        return NO;
                    }			
                }
            }
        }
    }
//    [Preferences saveDefaults];
    return YES;
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
#ifdef WIN32
    /* If the document is in a .rtfd and it's name is TXT.rtf or index.rtf, open the parent dir... This is because on windows it doesn't seem trivial to double-click to open folders as documents.
    */
    NSString *parentDir = [filename stringByDeletingLastPathComponent];
    if ([[[parentDir pathExtension] lowercaseString] isEqualToString:@"rtfd"]) {
        NSString *lastPathComponent = [[filename lastPathComponent] lowercaseString];
        if ([lastPathComponent isEqualToString:@"txt.rtf"] || [lastPathComponent isEqualToString:@"index.rtf"]) {
	    filename = parentDir;
        }
    }
#endif
    return [Document openDocumentWithPath:filename encoding:UnknownStringEncoding] ? YES : NO;
}

- (BOOL)application:(NSApplication *)sender openTempFile:(NSString *)filename {	/* ??? Why? */
    return [Document openDocumentWithPath:filename encoding:UnknownStringEncoding] ? YES : NO;
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender {
    return [Document openUntitled];
}

- (BOOL)application:(NSApplication *)sender printFile:(NSString *)filename {
    BOOL retval = NO;
    BOOL releaseDoc = NO;
    Document *document = [Document documentForPath:filename];
    
    if (!document) {
        document =  [[Document alloc] initWithPath:filename encoding:UnknownStringEncoding uniqueZone:NO];
        releaseDoc = YES;
    }
    if (document) {
        BOOL useUI = [NSPrintInfo defaultPrinter] ? NO : YES;

        [document printDocumentUsingPrintPanel:useUI];
        retval = YES;

        if (releaseDoc) {
            // If we created it, we get rid of it.
            [document release];
        }
    }
    return retval;
}

- (void)createNew:(id)sender {
    (void)[Document openUntitled];
}

- (void)open:(id)sender {
    (void)[Document open:sender];
}

- (void)saveAll:(id)sender {
    NSArray *windows = [[NSApplication sharedApplication] windows];
    unsigned count = [windows count];
    while (count--) {
        NSWindow *window = [windows objectAtIndex:count];
        Document *document = [Document documentForWindow:window];
        if (document) {
            if ([document isDocumentEdited]) {
                if (![document saveDocument:NO]) return;
            }
        }
    }
}

/*** Info Panel related stuff ***/

- (void)showInfoPanel:(id)sender {
    if (!infoPanel) {
        if (![NSBundle loadNibNamed:@"Info" owner:self])  {
            NSLog(@"Failed to load Info.nib");
            NSBeep();
            return;
        }
	[infoPanel center];
    }
    [infoPanel makeKeyAndOrderFront:nil];
}


@end

/*

 1/28/95 aozer	Created for Edit II.
 7/21/95 aozer	Command line file names
 
*/

