#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSDocument.h>
#import <AppKit/NSDocumentController.h>

#define DOCTYPE  @"puzzle"
#define TIFFTYPE @"tiff"
#define DDOCTYPE  @".puzzle"
#define DTIFFTYPE @".tiff"

#define DESKTOPEXTRA 150
#define DESKTOPMAX   400

@interface Document : NSDocument
{
    NSImage *image;
    NSMutableArray *clusters;
    NSView *view;
    NSString *nameOfTIFF;
    int px, py;
}
- init;
- (void)dealloc;

- scramble:(id)sender;
- verify:(id)sender;

- (NSMutableArray *)clusters;

- (NSData *)dataRepresentationOfType:(NSString *)aType;
- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType;

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)docType;

- (void)makeWindowControllers;
- (void)windowControllerDidLoadNib:(NSWindowController *)aController;


@end
