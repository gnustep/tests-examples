#import "Document.h"
#import "PieceView.h"

@interface Document (Private)

- (BOOL)loadError:(NSString *)msg;
- (NSWindow*) makeWindow;

@end

@implementation Document

- init
{
  [super init];
  return self;
}

- (void) dealloc
{
  [super dealloc];
}

- scramble:(id)sender
{
    NSMutableArray *allLeaves;
    int ind;
    PieceView *piece;
    BTree *cluster;
    NSSize desksize = [image size];
    int 
        width  = DESKTOPEXTRA/2+(int)desksize.width, 
        height = DESKTOPEXTRA/2+(int)desksize.height;

    if([clusters count]==px*py){
        for(ind=0; ind<[clusters count]; ind++){
            piece = [[clusters objectAtIndex:ind] leaf];
            
            [piece setFrameOrigin:
                       NSMakePoint(DESKTOPEXTRA/2+rand()%width,
                                   DESKTOPEXTRA/2+rand()%height)];
        }
    }
    else{
        allLeaves = [NSMutableArray array];
        for(ind=0; ind<[clusters count]; ind++){
            cluster = [clusters objectAtIndex:ind];
            [allLeaves addObjectsFromArray:[cluster leaves]];
            [cluster deallocAll];
        }
        // [clusters release];
        
        clusters = [NSMutableArray array];
        for(ind=0; ind<[allLeaves count]; ind++){
            piece = (PieceView *)[allLeaves objectAtIndex:ind];
            
            cluster = [[BTree alloc] 
                          initWithLeaf:piece];
            [piece setCluster:cluster];
            [clusters addObject:cluster];
            
            [piece setFrameOrigin:
                       NSMakePoint(DESKTOPEXTRA+rand()%width,
                                   DESKTOPEXTRA+rand()%height)];
        }
        [clusters retain];
    }

    [[view window] setDocumentEdited:YES];
    [view setNeedsDisplay:YES];

    return self;
}

#define INVALID_DISPLAY_SECS 1

- verify:(id)sender
{
    int ind;
    BTree *cluster;
    PieceView **pieces;

    for(ind=0; ind<[clusters count]; ind++){
        cluster = [clusters objectAtIndex:ind];
        if((pieces = [PieceView checkCluster:cluster]) != NULL){
            NSBeep();
            [pieces[0] showInvalid];
            [pieces[1] showInvalid];

            [NSThread 
                sleepUntilDate:
                    [NSDate 
                        dateWithTimeIntervalSinceNow:
                            INVALID_DISPLAY_SECS]];

            [pieces[0] setNeedsDisplay:YES];
            [pieces[1] setNeedsDisplay:YES];

            return self;
        }
    }
     
    NSRunAlertPanel(@"Verify", @"No conflicting pieces.", 
                    @"Ok", nil, nil);
    return self;
}


- (NSMutableArray *)clusters
{
    return clusters;
}


- (NSData *)dataRepresentationOfType:(NSString *)aType 
{
    NSString *msg;

    if([aType isEqualToString:DOCTYPE]){
        NSString *trees = @"", *pieces = @"", *all;
        int clind, pind;
        BTree *cluster; PieceView *piece;
        NSMutableArray *leaves;

        for(clind=0; clind<[clusters count]; clind++){
            cluster = [clusters objectAtIndex:clind];
            trees = [trees stringByAppendingString:
                                 [cluster toString]];
            
            leaves = [cluster leaves];
            for(pind=0; pind<[leaves count]; pind++){
                piece = [leaves objectAtIndex:pind];
                pieces = [pieces stringByAppendingString:
                                     [piece toString]];
            }
        }

        all = [NSString stringWithFormat:@"%@\n%d %d %d\n", 
                        nameOfTIFF, px, py, [clusters count]];

        all = [all stringByAppendingString:trees];
        all = [all stringByAppendingString:pieces];
        return [all dataUsingEncoding:NSASCIIStringEncoding];
    }
    else{
        msg = [NSString stringWithFormat: @"Unknown type: %@", 
                        [aType uppercaseString]];
        NSRunAlertPanel(@"Alert", msg, @"Ok", nil, nil);
        return nil;
    }
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType 
{
    NSString *msg;
    NSSize size;
    int x, y;
    PieceView *piece;
    BTree *cluster;

    int horizontal[DIM_MAX][DIM_MAX];
    int vertical[DIM_MAX][DIM_MAX];

    if([aType isEqualToString:DOCTYPE]){
        NSArray *lines = 
            [[NSString stringWithCString:[data bytes] 
                       length:[data length]] 
                componentsSeparatedByString:@"\n"];
        NSEnumerator *en = [lines objectEnumerator];
        NSString *line;
        NSScanner *scanner;
        int clcount, clind, lind;
        NSMutableDictionary *pdict;
        int x, y, ktag, posx, posy;
        PTYPE left, right, lower, upper;

        image = nil;
        clusters = nil;

        if((line = [en nextObject])==nil){
            return [self loadError:@"File name is missing"];
        }
        if ((image = [[NSImage alloc] 
                         initWithContentsOfFile:line])==nil){
            msg = [NSString stringWithFormat: @"Load failed (TIFF)", 
                            data];
            return [self loadError:msg];
        }
        nameOfTIFF = [line copy];
        size = [image size];

        if((line = [en nextObject])==nil){
            return [self loadError:@"Image dimensions missing"];
        }
        scanner = [NSScanner scannerWithString:line];
        if([scanner scanInt:&px]==NO ||
           [scanner scanInt:&py]==NO ||
           [scanner scanInt:&clcount]==NO ||
           px<DIM_MIN || px>DIM_MAX-1 ||
           py<DIM_MIN || py>DIM_MAX-1 ||
           clcount<1 || clcount>px*py){
            return [self loadError:
                             @"Image dimensions/clusters out of range"];
        }

        clusters = [NSMutableArray arrayWithCapacity:clcount];
        for(clind=0; clind<clcount; clind++){
            if((cluster = [BTree fromLines:en])==nil){
                msg = [NSString stringWithFormat: 
                                    @"Read failure  (cluster %d/%d)", 
                                clind, clcount];
                return [self loadError:msg];
            }
            [clusters addObject:cluster];
        }

        pdict = [NSMutableDictionary dictionaryWithCapacity:px*py];
        for(lind = 0; lind<px*py; lind++){
            if((line = [en nextObject])==nil){
                msg = [NSString stringWithFormat: 
                                    @"EOF  (piece %d/%d)", 
                                lind, px*py];
                return [self loadError:msg];
            }

            scanner = [NSScanner scannerWithString:line];
            if([scanner scanInt:&ktag]==NO ||
               [scanner scanInt:&x]==NO ||
               [scanner scanInt:&y]==NO ||
               [scanner scanInt:(int *)&left]==NO ||
               [scanner scanInt:(int *)&right]==NO ||
               [scanner scanInt:(int *)&upper]==NO ||
               [scanner scanInt:(int *)&lower]==NO ||
               [scanner scanInt:&posx]==NO ||
               [scanner scanInt:&posy]==NO){
                msg = [NSString stringWithFormat: 
                                    @"missing fields  (piece %d/%d)", 
                                lind, px*py];
                return [self loadError:msg];
            }

            piece = [[PieceView alloc]
                        initWithImage:image
                        loc:NSMakePoint(posx, posy)
                        posX:x outOf:px
                        posY:y outOf:py
                        left:left
                        right:right
                        upper:upper
                        lower:lower];
            [piece setDocument:self];
            [pdict setObject:piece 
                   forKey:[NSNumber numberWithInt:ktag]];
        }

        for(clind=0; clind<[clusters count]; clind++){
            cluster = [clusters objectAtIndex:clind];
            [cluster substituteLeaves:pdict];
            [cluster
                inorderWithPointer:(void *)cluster
                sel:@selector(setCluster:)]; 
        }

        [clusters retain];

        return YES;
    }
    else if([aType isEqualToString:TIFFTYPE]){
        if (!(image = [[NSImage alloc] initWithData:data])){
            NSRunAlertPanel(@"Alert", @"Load failed (TIFF)",
                            @"Ok", nil, nil);
            return NO;
        }

        size = [image size];

        px = ((int)size.width)/PIECE_WIDTH;
        if(((int)size.width)%PIECE_WIDTH){
            px++;
        }

        py = ((int)size.height)/PIECE_HEIGHT;
        if(((int)size.height)%PIECE_HEIGHT){
            py++;
        }

        if(px<DIM_MIN || py<DIM_MIN){
            [image dealloc];
            NSRunAlertPanel(@"Alert", @"Image too small (TIFF)",
                            @"Ok", nil, nil);
            return NO;
        }
        if(px>DIM_MAX-1 || py>DIM_MAX-1){
            [image dealloc];
            NSRunAlertPanel(@"Alert", @"Image too large (TIFF)", 
                            @"Ok", nil, nil);
            return NO;
        }

        // horizontal 
        for(y=0; y<py; y++){
            horizontal[0][y] = BORDER;
            for(x=1; x<px; x++){
                horizontal[x][y] = (rand()%2 ? INNER : OUTER);
            }
            horizontal[px][y] = BORDER;
        }
        
        // vertical
        for(x=0; x<px; x++){
            vertical[x][0] = BORDER;
            for(y=1; y<py; y++){
                vertical[x][y] = (rand()%2 ? INNER : OUTER);
            }
            vertical[x][py] = BORDER;
        }

        clusters = [NSMutableArray arrayWithCapacity:px*py];
        for(y=0; y<py; y++){
            for(x=0; x<px; x++){
                piece = [[PieceView alloc]
                            initWithImage:image
                            loc:NSMakePoint(DESKTOPEXTRA+x*PIECE_WIDTH, 
                                            DESKTOPEXTRA+y*PIECE_HEIGHT)
                            posX:x outOf:px
                            posY:y outOf:py
                            left:horizontal[x][y]
                            right:(-horizontal[x+1][y])
                            upper:(-vertical[x][y+1])
                            lower:vertical[x][y]];
                [piece setDocument:self];

                cluster = [[BTree alloc] initWithLeaf:piece];
                [piece setCluster:cluster];
                [clusters addObject:cluster];
            }
        }

        [clusters retain];
        [self scramble:self];
    }
    else{
        msg = [NSString stringWithFormat: @"Unknown type: %@", 
                        [aType uppercaseString]];
        NSRunAlertPanel(@"Alert", msg, @"Ok", nil, nil);
        return NO;
    }

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

- (void)windowControllerDidLoadNib:(NSWindowController *)aController;
{
  [super windowControllerDidLoadNib:aController];
}

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)docType
{
    if([docType isEqual:TIFFTYPE]){
        nameOfTIFF = [fileName copy];
    }

    return [super readFromFile:fileName ofType:docType];
}

@end

@implementation Document (Private)

- (NSWindow*)makeWindow
{
  NSWindow *window;
  NSRect frame;
  int m = (NSTitledWindowMask |  NSClosableWindowMask | 
           NSMiniaturizableWindowMask);

  int clind;
  BTree *cluster;
  NSScrollView *scroller;
  NSSize scrollSize, desktop;
  NSString *fname;

  frame.origin.x = 0;
  frame.origin.y = 0;
  frame.size = [image size];
  frame.size.width  += 2*(BOUNDARY+DESKTOPEXTRA);
  frame.size.height += 2*(BOUNDARY+DESKTOPEXTRA);

  desktop = frame.size;

  view  = [[NSView alloc] initWithFrame:frame];
  for(clind=0; clind<[clusters count]; clind++){
      cluster = [clusters objectAtIndex:clind];
      [cluster inorderWithTarget:view
               sel:@selector(addSubview:)];
  }

  scrollSize = 
      [NSScrollView frameSizeForContentSize:
                        NSMakeSize((desktop.width<DESKTOPMAX ? 
                                    desktop.width : DESKTOPMAX),
                                   (desktop.height<DESKTOPMAX ? 
                                    desktop.height : DESKTOPMAX))
                    hasHorizontalScroller:YES
                    hasVerticalScroller:YES
                    borderType:NSLineBorder];
  scroller = [[NSScrollView alloc] 
                 initWithFrame:NSMakeRect(0, 0, 
                                          scrollSize.width,
                                          scrollSize.height)];
  [scroller setHasHorizontalScroller:YES];
  [scroller setHasVerticalScroller:YES];
  [scroller setDocumentView:view];

  frame = [NSWindow frameRectForContentRect:[scroller frame] 
                    styleMask:m];

  window = [[NSWindow alloc] initWithContentRect:frame 
                             styleMask:m			       
                             backing: NSBackingStoreRetained 
                             defer:YES];
  [window setMinSize:NSMakeSize(DESKTOPEXTRA, DESKTOPEXTRA)];
  [window setReleasedWhenClosed:NO];
  [window setDelegate:self];

  [window setFrame:frame display:YES];
  [window setMaxSize:desktop];
  [window setContentView:scroller];
  [window setReleasedWhenClosed:YES];

  // RELEASE(view);

  [window center];
  [window orderFrontRegardless];
  [window makeKeyWindow];
  [window display];

  [self setFileType:DOCTYPE];
  
  fname = [self fileName];
  if([fname hasSuffix:DTIFFTYPE]){
      NSArray *docs = 
          [[NSDocumentController sharedDocumentController]
              documents];
      NSString *result, *fixIt = 
          [fname substringToIndex:
                     ([fname length]-[DTIFFTYPE length])];
      NSFileManager *manager = [NSFileManager defaultManager];
      int comp, index = 1;

      while(index){
          result = [fixIt stringByAppendingFormat:@"-%u%@", 
                          index, DDOCTYPE];

          for(comp=0; comp<[docs count]; comp++){
              if([[[docs objectAtIndex:comp] fileName]
                     isEqual:result]){
                  break;
              }
          }

          if(comp==[docs count] && 
             [manager fileExistsAtPath:result]==NO){
              break;
          }
          index++;
      }
      
      [self setFileName:result];
  }
  NSLog(@"file name %@\n",  [self fileName]);

  return window;
}

- (BOOL)loadError:(NSString *)msg
{
    if(image!=nil){
        [image dealloc];
    }
    if(clusters!=nil){
        [clusters dealloc];
    }
    NSRunAlertPanel(@"Alert", msg, @"Ok", nil, nil);
    return NO;
}

@end
