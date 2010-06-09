#import "Controller.h"


@interface TestView : NSView
{
	@public
	BOOL isFlipped;
}
@end

@interface CopyBitsView : NSView
{
	@public
	BOOL isFlipped;
}
@end

@implementation TestView

#ifdef GNUSTEP
- (BOOL) isFlipped
{
	return _rFlags.flipped_view;
}
#else
- (BOOL) isFlipped
{
	return isFlipped;
}
#endif

- (void) drawRect: (NSRect)aRect
{
	NSImage *appImg = [[NSImage imageNamed: @"GNUstep"] copy];
	/*[appImg setScalesWhenResized: YES];
	[appImg setSize: NSMakeSize(200, 200)];
	[appImg setScalesWhenResized: NO];*/
	NSSize imgSize = [appImg size];
	NSAffineTransform *xform = [NSAffineTransform transform];

	/*if ([self isFlipped] == NO)
	{

		[xform translateXBy: 0 yBy: [self frame].size.height];
		[xform scaleXBy: 1.0 yBy: -1.0];
		[xform concat];	
	}*/
	[xform rotateByDegrees: 15];
	[xform concat];

	NSLog(@"Image data flipped: %d", [appImg isFlipped]);
	
	[appImg drawInRect: NSMakeRect(0, 50, 200, 200) 
		fromRect: NSMakeRect(0, 0, imgSize.width, imgSize.height)
		operation: NSCompositeSourceOver
		fraction: 0.5];
	id imgCell = [[NSImageCell alloc] initImageCell: appImg];
	[imgCell drawWithFrame: NSMakeRect(150, 50, 25, 25) inView: self];

	[[NSColor redColor] set];
	NSRectFill(NSMakeRect(50, 0, 50, 50));
	
	[appImg setScalesWhenResized: YES];
	[appImg setSize: NSMakeSize(48, 48)];

	[appImg compositeToPoint: NSMakePoint(100, 50) 
		operation: NSCompositeSourceOver];
	[appImg dissolveToPoint: NSMakePoint(150, 50) 
		fraction: 0.5];

	[[NSColor colorWithPatternImage: appImg] set];
	NSRectFill(NSMakeRect(150, 100, 100, 150));

	/*if ([self isFlipped] == NO)
	{
		[xform invert];
		[xform concat];	
	}*/
	[xform invert];
	[xform concat];
}

- (BOOL) canDraw
{
	return YES;
}

@end


@implementation CopyBitsView

#ifdef GNUSTEP
- (BOOL) isFlipped
{
	return _rFlags.flipped_view;
}
#else
- (BOOL) isFlipped
{
	return isFlipped;
}
#endif

- (void) drawRect: (NSRect)aRect
{
	NSAffineTransform *flip = [NSAffineTransform transform];
	NSAffineTransform *xform = [NSAffineTransform transform];

	/*[flip translateXBy: 0 yBy: [self frame].size.height];
	[flip scaleXBy: 1.0 yBy: -1.0];
	[flip concat];*/

	[[NSColor redColor] set];
	NSRectFill(NSMakeRect(0, 0, 50, 50));
	NSRectFill(NSMakeRect(50, 50, 30, 30));

	// FIXME: NSCopyBits doesn't draw at the right location with a rotation
	[xform rotateByDegrees: 25];
	[xform concat];

	NSRect copyRect = NSMakeRect(0, 0, 80, 80);

	NSLog(@"Copy bits");
	NSCopyBits([self gState], copyRect, NSMakePoint(130, 0));
	NSImage *appImg = [[NSImage imageNamed: @"GNUstep"] copy];
	[appImg compositeToPoint: NSMakePoint(130, 0) 
		operation: NSCompositeSourceOver];

	[xform invert];
	[xform concat];

	[[NSColor blackColor] setStroke];
	[NSBezierPath strokeRect: copyRect];
	[NSBezierPath strokeRect: NSMakeRect(100, 0, 80, 80)];
	[NSBezierPath strokeRect: [self bounds]];

	/*[flip invert];
	[flip concat];*/
}

@end

@implementation Controller

- (void) awakeFromNib
{
	TestView *view1 = [[TestView alloc] initWithFrame: NSMakeRect(0, 0, 200, 200)];
	TestView *view2 = [[TestView alloc] initWithFrame: NSMakeRect(200, 0, 200, 200)];
	CopyBitsView *view3 = [[CopyBitsView alloc] initWithFrame: NSMakeRect(200, 200, 200, 150)];

#ifdef GNUSTEP
	view1->_rFlags.flipped_view = YES;
	[view1 _rebuildCoordinates];
        //view3->_rFlags.flipped_view = YES;
	//[view3 _rebuildCoordinates];
#else
	view1->isFlipped = YES;
	//view3->isFlipped = YES;
#endif
	[[window contentView] addSubview: view1];
	[[window contentView] addSubview: view2];
	[[window contentView] addSubview: view3];
}

@end
