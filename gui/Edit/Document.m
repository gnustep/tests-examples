/*
        Document.m
	Copyright (c) 1995-1996, NeXT Software, Inc.
        All rights reserved.
        Author: Ali Ozer

	You may freely copy, distribute and reuse the code in this example.
	NeXT disclaims any warranty of any kind, expressed or implied,
	as to its fitness for any particular use.

        Document object for Edit...
*/

#import <AppKit/AppKit.h>
#import <math.h>
#import <stdio.h>				// for NULL
#import "Document.h"
#import "MultiplePageView.h"
#import "TextFinder.h"

@implementation Document

- (void)setupInitialTextViewSharedState 
{
  NSText *textView = [self firstTextView];
    
  [textView setUsesFontPanel:YES];
  [textView setDelegate:self];
  [textView setRichText: YES];
//    [self setRichText:[[Preferences objectForKey:RichText] boolValue]];
//    [self setHyphenationFactor:0.0];
}

- (id)init 
{
static NSPoint cascadePoint = {0.0, 0.0};
NSZone *zone = [self zone];
        
    self = [super init];

    					// This ensures the first view gets set up correctly
    [self setupInitialTextViewSharedState];

    return self;
}

- (id)initWithPath:(NSString *)filename encoding:(int)encoding 
										uniqueZone:(BOOL)flag 
{
    if (!(self = [self init])) {
        if (flag) NSRecycleZone([self zone]);
        return nil;
    }
    uniqueZone = flag;	/* So if something goes wrong we can recycle the zone correctly in dealloc */
    if (filename && ![self loadFromPath:filename encoding:encoding]) {
        [self release];
        return nil;
    }
    if (filename) {
	[Document setLastOpenSavePanelDirectory:[filename stringByDeletingLastPathComponent]];
    }
    [[self firstTextView] setSelectedRange:NSMakeRange(0, 0)];
    [self setDocumentName:filename];

    return self;
}

+ (BOOL)openUntitled 
{
NSZone *zone = NSCreateZone(NSPageSize(), NSPageSize(), YES);
Document *document = [[self allocWithZone:zone] initWithPath:nil 
												encoding:UnknownStringEncoding 
												uniqueZone:YES];
    if (document) 
		{
		[document setPotentialSaveDirectory:[Document openSavePanelDirectory]];
		[document setDocumentName:nil];
        [[document window] makeKeyAndOrderFront:nil];
        return YES;
    	} 
	else 
        return NO;
}

/* Return the document in the specified window.
*/
+ (Document *)documentForWindow:(NSWindow *)window {
    id delegate = [window delegate];
    return (delegate && [delegate isKindOfClass:[Document class]]) ? delegate : nil;
}

+ (BOOL)openDocumentWithPath:(NSString *)filename encoding:(int)encoding {
    Document *document = [self documentForPath:filename];
    if (!document) {
        NSZone *zone = NSCreateZone(NSPageSize(), NSPageSize(), YES);
        document =  [[self allocWithZone:zone] initWithPath:filename encoding:encoding uniqueZone:YES];
    }
}

/* Clear the delegates of the text views and window, then release all resources and go away...
*/
- (void)dealloc 
{
    [[self firstTextView] setDelegate:nil];
    [[self window] setDelegate:nil];
    [documentName release];
    if (uniqueZone) {
        NSRecycleZone([self zone]);
    }
    [super dealloc];
}

- (NSText *)firstTextView 
{
static textView;

	if(!textView)
		textView = [NSText new]; 

    return textView;
}

- (NSSize)viewSize 
{
    return [scrollView contentSize];
}

- (void)setViewSize:(NSSize)size {
    NSWindow *window = [scrollView window];
    NSRect origWindowFrame = [window frame];
    NSSize scrollViewSize = [NSScrollView frameSizeForContentSize:size hasHorizontalScroller:[scrollView hasHorizontalScroller] hasVerticalScroller:[scrollView hasVerticalScroller] borderType:[scrollView borderType]];
    [window setContentSize:scrollViewSize];
    [window setFrameTopLeftPoint:NSMakePoint(origWindowFrame.origin.x, NSMaxY(origWindowFrame))];
}

/* This method causes the text to be laid out in the foreground (approximately) up to the indicated character index.
*/
- (void)doForegroundLayoutToCharacterIndex:(unsigned)loc 
{}

+ (NSString *)cleanedUpPath:(NSString *)filename {
    NSString *resolvedSymlinks = [filename stringByResolvingSymlinksInPath];
    if ([resolvedSymlinks length] > 0) {
        NSString *standardized = [resolvedSymlinks stringByStandardizingPath];
        return [standardized length] ? standardized : resolvedSymlinks;
    }
    return filename;
}

- (void)setDocumentName:(NSString *)filename {
    [documentName autorelease];
    if (filename) {
        documentName = [[filename stringByResolvingSymlinksInPath] copyWithZone:[self zone]];
        [[self window] setTitleWithRepresentedFilename:documentName];
        if (uniqueZone) NSSetZoneName([self zone], documentName);
    } else {
	NSString *untitled = NSLocalizedString(@"UNTITLED", @"Name of new, untitled document");
        if ([self isRichText]) untitled = [untitled stringByAppendingPathExtension:@"rtf"];
	if (potentialSaveDirectory) {
	    [[self window] setTitleWithRepresentedFilename:[potentialSaveDirectory stringByAppendingPathComponent:untitled]];
	} else {
	    [[self window] setTitle:untitled];
	}
        if (uniqueZone) NSSetZoneName([self zone], untitled);
        documentName = nil;
    }
}

- (NSString *)documentName 
{
    return documentName;
}

- (BOOL)isRichText
{
    return isRichText;
}

- (void)setPotentialSaveDirectory:(NSString *)nm 
{}

- (NSString *)potentialSaveDirectory 
{}

- (void)setDocumentEdited:(BOOL)flag 
{
    if (flag != isDocumentEdited) {
        isDocumentEdited = flag;
        [[self window] setDocumentEdited:isDocumentEdited];
    }
}

- (BOOL)isDocumentEdited 
{
    return isDocumentEdited;
}

- (NSWindow *)window 
{
    return [[self firstTextView] window];
}


- (void)setPrintInfo:(NSPrintInfo *)anObject 
{}

- (NSPrintInfo *)printInfo 
{
    return printInfo;
}

/* Multiple page related code */

- (unsigned)numberOfPages {
    if (hasMultiplePages) {
        return [[scrollView documentView] numberOfPages];
    } else {
        return 1;
    }
}

- (BOOL)hasMultiplePages {
    return hasMultiplePages;
}

/* Outlet methods */

- (void)setScrollView:(id)anObject 
{
    scrollView = anObject;
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:NO];
    [[scrollView contentView] setAutoresizesSubviews:YES];
    [self fixUpScrollViewBackgroundColor:nil];
}
        
static NSPopUpButton *encodingPopupButton = nil;
static NSView *encodingAccessory = nil;


- (void)close:(id)sender 
{
    [[self window] close];
}

/* Not correct! */
- (void)saveTo:(id)sender 
{
    [self saveAs:sender];
}

- (void)saveAs:(id)sender 
{
    (void)[self saveDocument:YES];
}

- (void)save:(id)sender 
{
  (void)[self saveDocument:NO];
}

- (BOOL)saveDocument:(BOOL)showSavePanel
{
  NSLog(@"Save called!");
  [[self firstTextView] writeRTFDToFile: @"test.rtf" atomically: NO];
  return YES;
}

/* Window delegation messages */

- (BOOL)windowShouldClose:(id)sender 
{

    //return [self canCloseDocument];
    return YES;
}

- (void)windowWillClose:(NSNotification *)notification 
{
    NSWindow *window = [self window];
    [window setDelegate:nil];
    [self release];
}

/* Text view delegation messages */

- (void)textDidChange:(NSNotification *)textObject 
{
  //[self saveDocument: NO];
    if (!isDocumentEdited) {
        [self setDocumentEdited:YES];
    }
}

@end
