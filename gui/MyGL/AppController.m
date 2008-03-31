/* All Rights reserved */

#include <AppKit/AppKit.h>
#include <AppKit/NSOpenGLView.h>
#include "AppController.h"
#include <GL/gl.h>
#include <GL/glu.h>
#include <GNUstepBase/GSXML.h>

#include <math.h>

static GLfloat _rtx = 0;
static GLfloat _rty = 0;
static GLfloat _rtz = 0;
static GLfloat _artx = 0;
static GLfloat _arty = 0;
static GLfloat _artz = 0;
static GLfloat _artl = 50;

typedef struct _Vector
{
	float X;
	float Y;
	float Z;
} Vector;

typedef struct _Tri
{
	int p1;
	int p2;
	int p3;
} Tri;


typedef struct tagMATRIX
{
	float Data[16];
} MATRIX;


@interface Mesh : NSObject
{
@public
	int vcount;
	Vector *vertices;

	int nvcount;
	Vector *nvertices;

	int pcount;
	/* FIXME rewrite to separate tris/quads/polygons */
	Tri *polygons;
	Tri *pnormals;
}
@end

@implementation Mesh

static float DotProduct (Vector *v1, Vector *v2)
{
	return v1->X * v2->X + v1->Y * v2->Y + v1->Z * v2->Z;
}


static float Magnitude (Vector *v)
{
	return sqrtf(v->X * v->X + v->Y * v->Y + v->Z * v->Z);
}

static void Normalize (Vector *v)
{
	float m = Magnitude(v);
	if (m != 0.0f)
	{
		v->X /= m;
		v->Y /= m;
		v->Z /= m;
	}

}

- (void) drawCelShade
{
	int t;
	Vector light;
	Vector vv;
	light.X = 1.0f + _rtx;
	light.Y = 1.0f + _rty;
	light.Z = 1.0f + _rtz;;
	Normalize(&light);
	float xx;

	for(t = 0; t < pcount; t++)
	{
		glBegin( GL_TRIANGLES );

		vv = nvertices[pnormals[t].p1];
		Normalize(&vv);
		xx = DotProduct(&light,&vv);
		if (xx < 0.0f) xx = 0;
		glColor3f(xx,xx,xx);
		glVertex3f(vertices[polygons[t].p1].X,
				vertices[polygons[t].p1].Y,
				vertices[polygons[t].p1].Z);

		vv = nvertices[pnormals[t].p2];
		Normalize(&vv);
		xx = DotProduct(&light,&vv);
		if (xx < 0.0f) xx = 0;
		glColor3f(xx,xx,xx);
		glVertex3f(vertices[polygons[t].p2].X,
				vertices[polygons[t].p2].Y,
				vertices[polygons[t].p2].Z);

		vv = nvertices[pnormals[t].p3];
		Normalize(&vv);
		xx = DotProduct(&light,&vv);
		if (xx < 0.0f) xx = 0;
		glColor3f(xx,xx,xx);
		glVertex3f(vertices[polygons[t].p3].X,
				vertices[polygons[t].p3].Y,
				vertices[polygons[t].p3].Z);

		glEnd( );
	}
}
- (void) draw
{
	int t;
	/*
	glBegin( GL_POINTS );
	for(t = 0; t < vcount-1; t++)
	{
		glVertex3f(vertices[t].X,
				vertices[t].Y,
				vertices[t].Z);
	}
	*/
	glColor3f(0.8f,0.5f,0.3f);
	glBegin( GL_TRIANGLES );
	for(t = 0; t < pcount; t++)
	{
		glVertex3f(vertices[polygons[t].p1].X,
				vertices[polygons[t].p1].Y,
				vertices[polygons[t].p1].Z);
		glVertex3f(vertices[polygons[t].p2].X,
				vertices[polygons[t].p2].Y,
				vertices[polygons[t].p2].Z);
		glVertex3f(vertices[polygons[t].p3].X,
				vertices[polygons[t].p3].Y,
				vertices[polygons[t].p3].Z);
	}
	glEnd( );
}

@end

@interface MySAX : GSSAXHandler
{
	BOOL trackMeshVertices;
	BOOL trackNormalVertices;
	BOOL trackPolygons;
	Mesh *mesh;
	int idx;
}
@end

@implementation MySAX
- (id) init
{
	idx = 0;
	mesh = [Mesh new];
	trackMeshVertices = NO;
	trackNormalVertices = NO;
	trackPolygons = NO;
		
	return [super init];
}

- (Mesh *) currentMesh
{
	return mesh;
}

- (void) characters:(NSString *)str
{
	int p;
	NSEnumerator *en;
	if (trackMeshVertices)
	{
		NSArray *ar;
		str = [[str stringByTrimmingSpaces]
			stringByReplacingString:@"\t"
						 withString:@""];
		NSArray *parray = [str componentsSeparatedByString:@"\n"];
		mesh->vcount = [parray count];
		mesh->vertices = malloc(sizeof(Vector) * mesh->vcount);

		NSLog(@"import %d vertices",mesh->vcount);

		p = 0;
		en = [parray objectEnumerator];
		while ((str = [en nextObject]))
		{
			ar = [str componentsSeparatedByString:@" "];
			if ([ar count] == 3)
			{
				mesh->vertices[p].X = [[ar objectAtIndex:0] floatValue];
				mesh->vertices[p].Y = [[ar objectAtIndex:1] floatValue];
				mesh->vertices[p].Z = [[ar objectAtIndex:2] floatValue];
				p++;
			}
		}
	}
	else if (trackNormalVertices)
	{
		NSArray *ar;
		str = [[str stringByTrimmingSpaces]
			stringByReplacingString:@"\t"
						 withString:@""];
		NSArray *parray = [str componentsSeparatedByString:@"\n"];
		mesh->nvcount = [parray count];
		mesh->nvertices = malloc(sizeof(Vector) * mesh->nvcount);

		NSLog(@"import %d normal vertices",mesh->nvcount);

		p = 0;
		en = [parray objectEnumerator];
		while ((str = [en nextObject]))
		{
			ar = [str componentsSeparatedByString:@" "];
			if ([ar count] == 3)
			{
				mesh->nvertices[p].X = [[ar objectAtIndex:0] floatValue];
				mesh->nvertices[p].Y = [[ar objectAtIndex:1] floatValue];
				mesh->nvertices[p].Z = [[ar objectAtIndex:2] floatValue];
				p++;
			}
		}
	}
	else if (trackPolygons)
	{
		NSArray *parray = [str componentsSeparatedByString:@" "];
		mesh->polygons[idx].p1 = [[parray objectAtIndex:0] intValue];
		mesh->polygons[idx].p2 = [[parray objectAtIndex:2] intValue];
		mesh->polygons[idx].p3 = [[parray objectAtIndex:4] intValue];

		mesh->pnormals[idx].p1 = [[parray objectAtIndex:1] intValue];
		mesh->pnormals[idx].p2 = [[parray objectAtIndex:3] intValue];
		mesh->pnormals[idx].p3 = [[parray objectAtIndex:5] intValue];
		idx ++;
	}
}

- (void) startElement: (NSString *)elementName
		   attributes: (NSMutableDictionary *)elementAttributes
{
	if ([elementName isEqualToString:@"float_array"])
	{
		NSString *sourceName = [elementAttributes objectForKey:@"name"];
		if ([sourceName isEqualToString:@"Sphere-Pos-Array"])
		{
			trackMeshVertices = YES;
			trackNormalVertices = NO;
			trackPolygons = NO;
		}
		else if ([sourceName isEqualToString:@"Sphere-Normal-Array"])
		{
			trackMeshVertices = NO;
			trackNormalVertices = YES;
			trackPolygons = NO;
		}
	}

	if ([elementName isEqualToString:@"polygons"])
	{
		int pc = [[elementAttributes objectForKey:@"count"] intValue];
		mesh->polygons = malloc(sizeof(Tri) * pc);
		mesh->pnormals = malloc(sizeof(Tri) * pc);
		mesh->pcount = pc;
	}

	/*
	if ([elementName isEqualToString:@"polygons"])
	{
		NSString *sourceName = [elementAttributes objectForKey:@"source"];
		if ([sourceName isEqualToString:@"#Mesh-Normal"])
		{
			trackMeshVertices = NO;
			trackNormalVertices = NO;
			trackPolygons = YES;
		}
	}
	*/
	if ([elementName isEqualToString:@"p"])
	{
			trackMeshVertices = NO;
			trackNormalVertices = NO;
			trackPolygons = YES;
	}
}

- (void) endElement:(NSString*)elementName
{
	trackMeshVertices = NO;
	trackNormalVertices = NO;
	trackPolygons = NO;
}

- (void) endDocument
{
	NSLog(@"end %d tris",idx);
}
@end

@interface MyGLView : NSOpenGLView
{
	NSMutableArray *meshArray;
}

@end

@implementation MyGLView

- (void) scrollWheel:(NSEvent *)theEvent
{
	_artl += [theEvent deltaY];
	[self reshape];
}

- (void) mouseDragged: (NSEvent*)theEvent
{
	NSRect bounds = [self bounds];

	_arty = [theEvent deltaX]/NSWidth(bounds) * 180;
	_artx = -[theEvent deltaY]/NSHeight(bounds) * 180;
	_artz = sqrtf(_arty * _artz);

	_rtz += _artz;
	_rty += _arty;
	_rtx += _artx;
}

- (void) prepareOpenGL
{
	meshArray = [NSMutableArray new];

	glShadeModel(GL_SMOOTH);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClearDepth(1.0f);
	glEnable(GL_DEPTH_TEST);

	glDepthFunc(GL_LEQUAL);

	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	glMatrixMode(GL_MODELVIEW);

	[self reshape];
}

- (void) reshape
{
	[super reshape];

	GLfloat ratio;
	NSRect sceneBounds = [self bounds];

	ratio = NSWidth(sceneBounds)/ NSHeight(sceneBounds);

	glViewport(0, 0, NSWidth(sceneBounds), NSHeight(sceneBounds));
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(_artl, ratio, 0.1f, 100.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	[self setNeedsDisplay:YES];
}

- (void) drawRect:(NSRect)r
{
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

	glLoadIdentity();

	glTranslatef(-1.5f, 0.0f, -6.0f);
	glRotatef(_rtx,1.0f,0.0f,0.0f);
	glRotatef(_rty,0.0f,1.0f,0.0f);
	glRotatef(_rtz,0.0f,0.0f,1.0f);

	[meshArray makeObjectsPerform:@selector(drawCelShade)];


	[[self openGLContext] flushBuffer];
}

-(void) refresh
{
	[self setNeedsDisplay:YES];
}

- (void) loadModel
{
	GSXMLParser *p;
	MySAX *h;

	h = [MySAX new];
	p = [GSXMLParser parserWithSAXHandler:h
					   withContentsOfFile:@"girl.dae"];
	if ([p parse])
	{
		[meshArray addObject:[h currentMesh]];
	}

}

@end

@implementation AppController
static id glview;
-(void) applicationDidFinishLaunching: (NSNotification *)not
{
	[NSTimer scheduledTimerWithTimeInterval:0.05 //(1.0 / 30)
									 target:glview
								   selector:@selector(refresh)
								   userInfo:nil
									repeats:YES];
	[glview loadModel];
}

-(void) applicationWillFinishLaunching: (NSNotification *)not
{
	glview = [[MyGLView alloc] initWithFrame:[window frame]];
	/*
								   colorBits:16
								   depthBits:16
								  fullscreen:NO];
								  */
	[window setContentView:glview];
}

@end
