#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#define DEFAULT_RES  200

typedef enum {
  ZSQUARED=0,
  ZCUBED,
  ZSQSQPLUSZ,
  ZLAMBDA,
  ZMAGNET,
  FTYPE_COUNT
} FTYPE;

#define DEFAULT_TYPE ZSQUARED

typedef enum {
  MONOCHROME=0,
  GRAY16,
  RGB8,
  RGB27,
  CSCHEME_COUNT
} CSCHEME;

#define DEFAULT_SCHEME GRAY16

typedef enum {
  ZOOM_IN = 0,
  ZOOM_OUT,
  ZOOM_RESTORE
} ZOOMOP;

@interface FractalView : NSView
{
  NSImage *image;
  FTYPE ftype;
  int res;
  CSCHEME cscheme;
  double minre, maxre;
  double minim, maxim;
  NSBitmapImageRep *rep;
}

+ (id)getColorsForScheme:(CSCHEME)cs;

- (id)initWithType:(FTYPE)ft;
- (id)initWithType:(FTYPE)ft 
        resolution:(int)rval
           cscheme:(CSCHEME)cs
            region:(double *)reg;

- (id)setResolution:(int)rval;
- (int)resolution;

- (id)setColorScheme:(CSCHEME)cs;
- (CSCHEME)colorScheme;

- (id)zoomOp:(ZOOMOP)op;

- (void)update;

- (void)drawRect:(NSRect)aRect;

- (void)mouseDown:(NSEvent *)theEvent;


- (BOOL)writeTIFF:(NSString *)name;

- (void)dealloc;
@end



