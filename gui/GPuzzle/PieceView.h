#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "Document.h"
#import "BTree.h"

#define PIECE_WIDTH  48 // must be even
#define PIECE_HEIGHT 40 // must be even

#define BOUNDARY     16
#define OFFS          8
#define RADSQ        ((float)(BOUNDARY*BOUNDARY/4))

#define PIECE_BD_WIDTH  (2*BOUNDARY+PIECE_WIDTH)
#define PIECE_BD_HEIGHT (2*BOUNDARY+PIECE_HEIGHT)

#define DIM_MAX      32
#define DIM_MIN       3

typedef enum {
    INNER = -1,
    BORDER,
    OUTER
} BTYPE;

typedef enum {
    EXTERIOR,
    LEFTIN, LEFTOUT,
    RIGHTIN, RIGHTOUT,
    LOWERIN, LOWEROUT,
    UPPERIN, UPPEROUT,
    CENTER
} PTYPE;

@interface PieceView : NSView
{
    Document *doc;
    NSImage *image;
    BTree *cluster;
    int x, y, px, py;
    BTYPE left, right, upper, lower;
    int padleft, padright, padupper, padlower;
    NSBezierPath *clip;
    int tag;
}

+ (id *)checkCluster:(BTree *)theCluster;

- (id)initWithImage:(NSImage *)theImage
                loc:(NSPoint)theLoc
               posX:(int)posx outOf:(int)px
               posY:(int)posy outOf:(int)py
               left:(BTYPE)bleft
              right:(BTYPE)bright
              upper:(BTYPE)bupper
              lower:(BTYPE)blower;

- setCluster:(BTree *)theCluster;
- (BTree *)cluster;

- setDocument:(Document *)theDocument;
- (Document *)document;

- (void)drawRect:(NSRect)aRect;
- (void)outline:(float *)delta;

- (void)showInvalid;

- (void)bbox:(NSRect *)bbox;

- (void)shiftView:(float *)delta;

- (BTYPE)left;
- (BTYPE)right;
- (BTYPE)upper;
- (BTYPE)lower;

- (int)tag;

- (int)x;
- (int)y;

- (PTYPE)classifyPoint:(NSPoint)pt;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)rightMouseDown:(NSEvent *)theEvent;

- (NSString *)toString;


@end



