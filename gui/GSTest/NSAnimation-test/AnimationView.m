/*
 * AnimationView.m
 *
 * Created : 2007-03-Mar
 * Author : Xavier Glattard (xgl) <xavier.glattard@online.fr>
 * Copyright 2007 Free Software Foundation
 *
 * This file is part of the GNUstep framework.
 *
 * Last changes : 2007-04-Apr 17:44 (Paris, Madrid) by Xavier Glattard (xgl)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 * 
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02111 USA.
 */

#include <Foundation/Foundation.h>
#include <AnimationView.h>
#include <AppKit/PSOperators.h>
#include <Foundation/NSDebug.h>

#include <math.h>

@interface AnimationTestLoopAnimation : NSAnimation
{}
@end

@interface AnimationTestRoundTripAnimation : AnimationTestLoopAnimation
{
  BOOL backward;
}
@end

@interface AnimationTestMainAnimation : AnimationTestLoopAnimation
{ 
  NSView *view;
}

- (AnimationTestMainAnimation*) initWithView: (NSView*) aView;

@end

#define ANIMATION_MODE NSAnimationNonblocking
//#define ANIMATION_MODE NSAnimationBlocking // NA
//#define ANIMATION_MODE NSAnimationNonblockingThreaded

@implementation AnimationView

- (NSView*) initWithFrame: (NSRect)frame
{
  unsigned i;
  if ((self = [super initWithFrame: frame]))
    {
      mainAnimation = [[AnimationTestMainAnimation alloc] initWithView: self];
      [mainAnimation setAnimationBlockingMode: ANIMATION_MODE];
      [mainAnimation setFrameRate: 30.0];

      fpsField = [[NSTextField alloc] initWithFrame: NSMakeRect (5,5,50,20)];
      [fpsField setEditable: NO];
      [fpsField setBezeled: YES];
      [fpsField setDrawsBackground: YES];
      [self addSubview: fpsField];
      [fpsField setFloatValue: 0.0];

      circlePosAnimation = [[AnimationTestLoopAnimation alloc]
       initWithDuration: 5
         animationCurve: NSAnimationLinear];
      [circlePosAnimation setAnimationBlockingMode: ANIMATION_MODE];
      [circlePosAnimation setDelegate: self];
      [circlePosAnimation setFrameRate: 0.0];
      [circlePosAnimation addProgressMark: 0.23f];
      [circlePosAnimation addProgressMark: 0.48f];
      [circlePosAnimation addProgressMark: 0.73f];
      [circlePosAnimation addProgressMark: 0.76f];
      [circlePosAnimation addProgressMark: 0.98f];

      circleColorAnimation = [[AnimationTestRoundTripAnimation alloc]
       initWithDuration: 0.4
         animationCurve: NSAnimationEaseInOut];
      [circleColorAnimation setAnimationBlockingMode: ANIMATION_MODE];
      [circleColorAnimation setFrameRate: 0.0];

      for (i=0;i<3;i++)
        {
          shapeAnimation[i] = [[NSAnimation alloc]
           initWithDuration: 0.5
             animationCurve: NSAnimationEaseInOut];
          [shapeAnimation[i] setAnimationBlockingMode: ANIMATION_MODE];
        }
      shapeAnimation[3] = [[NSAnimation alloc]
       initWithDuration: 2.5
         animationCurve: NSAnimationSpeedInOut];
      [shapeAnimation[3] setAnimationBlockingMode: ANIMATION_MODE];

      plotAnimation = [[AnimationTestLoopAnimation alloc]
       initWithDuration: 3.5
         animationCurve: NSAnimationLinear];
      [plotAnimation setAnimationBlockingMode: ANIMATION_MODE];
      curvePathIndex = 0;

      [circlePosAnimation   startWhenAnimation: mainAnimation reachesProgress: 0.0];
      [circleColorAnimation startWhenAnimation: mainAnimation reachesProgress: 0.0];
      [plotAnimation        startWhenAnimation: mainAnimation reachesProgress: 0.0];

      // delay the start : needed in case of a blocking animation
      [[NSRunLoop currentRunLoop] performSelector: @selector (startAnimation)
                                           target: mainAnimation
                                         argument: nil
                                            order: 1000
                                            modes: [NSArray arrayWithObject: NSDefaultRunLoopMode]];
      fpsDisplayTimer = [NSTimer
       scheduledTimerWithTimeInterval: 1.0
                               target: self
                             selector: @selector (fpsDisplay)
                             userInfo: nil
                              repeats: YES
                              ];
    }
  return self;
}

- (void) dealloc
{
  RELEASE (mainAnimation);
  RELEASE (circlePosAnimation);
  RELEASE (circleColorAnimation);
  RELEASE (plotAnimation);
  RELEASE (fpsField);
  [fpsDisplayTimer invalidate];
  RELEASE (fpsDisplayTimer);
  [super dealloc];
}

- (void) fpsDisplay
//{ [fpsField setFloatValue: [mainAnimation frameCount]]; }
{ 
  [fpsField setFloatValue: [mainAnimation actualFrameRate]]; 
}

- (void) drawRect: (NSRect)rect
{
  float v,c;
  unsigned i,j;
  NSRect frame = [self frame];
  float x,y,w,h;
  w = frame.size.width; h = frame.size.height;

  // Background
  c = [mainAnimation currentValue];
  PSsetrgbcolor (1-c, c, (c+1)/2);
//  PSrectfill (rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);

  // Cross lines
  PSnewpath ();
  PSsetrgbcolor (0.1,0.1,0.1);
  PSmoveto ( 0.0, 0.0) ; PSlineto(w,h);
  PSmoveto ( w, 0.0) ; PSlineto( 0.0,h);
  PSstroke ();

#define CURVES_1D

//BROKEN : uses private functions...
#if 0
  // Animation curves
  PSsetlinewidth (1);
  PSsetalpha (1.0);

  for (j=0;j<3;j++)
    {
      PSnewpath ();
      PSsetrgbcolor (j==0,j==1,j==2);
      cd = &_gs_animationCurveDesc[j];
#ifdef CURVES_1D
      PSmoveto (0,h*_gs_animationValueForCurve(cd,0.0,0));
#else
      PSmoveto (w*_GSBezierEval(&(cd->rb.n),0)/4,h*_GSBezierEval(&(cd->rb.d),0.0)/4);
#endif
      for (i=1;i<=50;i++)
        {
          PSlineto (
#ifdef CURVES_1D
            i*w/50,
            h*_gs_animationValueForCurve (cd,i/50.0,0)
#else
            w*_GSBezierEval (&(cd->rb.n),i/50.0)/4,
            h*_GSBezierEval (&(cd->rb.d),i/50.0)/4
#endif
          );
        }
      PSstroke ();
    }
 
 // Moving plot
  cd = [plotAnimation _gs_curveDesc];
  v =  [plotAnimation _gs_curveShift];
#ifndef CURVES_1D
  PSnewpath ();
  PSsetrgbcolor (0,0,0);
  PSsetlinewidth (2);
  PSmoveto (h*cd->rb.w[0]*cd->rb.p[0]/4,w*cd->rb.w[0]/4);
  for (i=1;i<4;i++)
    PSlineto (h*cd->rb.w[i]*cd->rb.p[i]/4,w*cd->rb.w[i]/4);
  PSstroke ();
  for (i=0;i<4;i++)
    PSrectfill ((h*cd->rb.w[i]*cd->rb.p[i])/4-3,(w*cd->rb.w[i])/4-3,6,6);
#endif

  PSnewpath ();
  PSsetrgbcolor (1,1,1);
  PSsetlinewidth (1);
#ifdef CURVES_1D
  PSmoveto (v*w,h*_gs_animationValueForCurve(cd,v,v));
#else
  PSmoveto (w*_GSBezierEval(&(cd->rb.n),0)/4,h*_GSBezierEval(&(cd->rb.d),0.0)/4);
#endif
  for (i=1;i<=50;i++)
  {
    PSlineto (
#ifdef CURVES_1D
        w*(i/50.0*(1-v)+v),
        h*_gs_animationValueForCurve (cd,i/50.0*(1-v)+v,v)
#else
        w*_GSBezierEval (&(cd->rb.n),i/50.0)/4,
        h*_GSBezierEval (&(cd->rb.d),i/50.0)/4
#endif
        );
  }
  PSstroke ();
#endif // BROKEN

  // Moving plot
  c = 0;
  j = curvePathIndex/2;
#ifdef CURVES_1D
#else // BROKEN
  cd = [plotAnimation _gs_curveDesc];
#endif
  v = [plotAnimation currentProgress];
  for (i=j;i<100;i++,c+=0.03)
    {
      PSsetrgbcolor (c/3,c/3,1.0);
      PSrectfill (curvePath[i].x*w-c, curvePath[i].y*h-c,2*c,2*c);
    }
  for (i=0;i<j;i++,c+=0.03)
    {
      PSsetrgbcolor (c/3,c/3,1.0);
      PSrectfill (curvePath[i].x*w-c, curvePath[i].y*h-c,2*c,2*c);
    }
#ifdef CURVES_1D
  curvePath[j].x = v;
  curvePath[j].y = [plotAnimation currentValue];
  //curvePath[j].y = (1-v)+[plotAnimation currentValue]-0.5;
#else // BROKEN
  v = (v-[plotAnimation _gs_curveShift]/(1.0-[plotAnimation _gs_curveShift]);
  curvePath[j].x = _GSBezierEval (&(cd->rb.n),v)/4;
  curvePath[j].y = _GSBezierEval (&(cd->rb.d),v)/4;
#endif

  i = [plotAnimation animationCurve];
  PSsetrgbcolor (i==0,i==1,i==2);
  PSsetalpha (1.0);
  PSrectfill ( curvePath[j].x*w-4, curvePath[j].y*h-4,8,8 );
  if (curvePathIndex==199) curvePathIndex = 0; else curvePathIndex++;

  // shape[0]
  PSnewpath ();
  v = [shapeAnimation[0] currentValue] * 2;
  if (v>1) v=2-v;
  PSsetrgbcolor (1.0/2+v/2,v/2,0);
  x = w*(1.0/2      );
  y = h*(1.0/2+1.0/3);
  PSmoveto ( x+40+v*25, y );
  PSlineto ( x        , y+40+v*13);
  PSlineto ( x-40-v*25, y        );
  PSlineto ( x        , y-40-v*13);
  PSclosepath ();
  PSfill ();

  // shape[1]
  PSnewpath ();
  v = [shapeAnimation[1] currentValue];
  PSsetrgbcolor (0,1.0/2+v/2,v/2);
  x = w*(1.0/2-1.0/3);
  y = h*(1.0/2      );
  PSmoveto ( x+40*cos(v*2*M_PI-  M_PI/6), y+40*sin(v*2*M_PI-  M_PI/6) );
  PSlineto ( x+40*cos(v*2*M_PI+  M_PI_2), y+40*sin(v*2*M_PI+  M_PI_2) );
  PSlineto ( x+40*cos(v*2*M_PI+7*M_PI/6), y+40*sin(v*2*M_PI+7*M_PI/6) );
  PSclosepath ();
  PSfill ();

  // shape[2]
  v = [shapeAnimation[2] currentValue] * 8;
  if (v>4.0) v=8-v;
  x = w*(1.0/2      );
  y = h*(1.0/2-1.0/3);
  for (i=0;i<=v;i++)
    {
      PSnewpath ();
      PSsetrgbcolor ((v-i)/2.0,0.0,(1.0+v-i)/2.0);
      PSsetlinewidth (4.0+(i-v)*2+3);
      PSmoveto ( x+20+12*i, y+20+12*i );
      PSlineto ( x-20-12*i, y+20+12*i );
      PSlineto ( x-20-12*i, y-20-12*i );
      PSlineto ( x+20+12*i, y-20-12*i );
      PSclosepath ();
      PSstroke ();
    }

  // Moving circle
  v = [circlePosAnimation currentValue];
  c = [circleColorAnimation currentValue];
  PSnewpath ();
  PSsetrgbcolor (c,(c+1)/2,1-c);
  x = w/2*(1+cos (v*2*M_PI)*2/3);
  y = h/2*(1+sin (v*2*M_PI)*2/3);
  PSarc (x,y,
      15-c*5,0,360
      );
  PSfill ();

  // shape[3]
  c = c+v*3;
  v = [shapeAnimation[3] currentValue] * 2;
  if (v>1) v=2-v;
  x = (1-v)*w*(1.0/2+1.0/3) + v*x;
  y = (1-v)*h*(1.0/2      ) + v*y;
  PSsetrgbcolor (v,1.0/2-v/2,0);
  PSarc (x+25*cos((c+v*2)*4.0*M_PI),y+18*sin((c+v*2+3)*3.0*M_PI),
      8-c+v*5,0,360
      );
  PSfill ();
}

- (void) animation: (NSAnimation*)animation didReachProgressMark: (NSAnimationProgress)progress
{
  if (animation == circlePosAnimation)
    {
      if (progress == 0.23f)
        {
          [plotAnimation setAnimationCurve: NSAnimationEaseOut];
          [shapeAnimation[0] startAnimation];
        }
      else if (progress == 0.48f)
        {
          [plotAnimation setAnimationCurve: NSAnimationEaseIn];
          [shapeAnimation[1] startAnimation];
        }
      else if (progress == 0.73f)
        {
          [plotAnimation setAnimationCurve: NSAnimationEaseInOut];
          [shapeAnimation[2] startAnimation];
        }
      else if (progress == 0.76f)
        {
          [shapeAnimation[3] startAnimation];
        }
      else if (progress == 0.98f)
        {
          [plotAnimation setAnimationCurve: NSAnimationLinear];
        }
    }
}

@end // implementation AnimationView

@implementation AnimationTestLoopAnimation
- (void) setCurrentProgress: (NSAnimationProgress) progress
{
  // Does this work with Cocoa ??
  [super setCurrentProgress: progress];
  if (progress >= 1.0)
    [self startAnimation];
}
- (NSArray*) runLoopModesForAnimating
{ return [NSArray arrayWithObject: NSDefaultRunLoopMode]; }
@end

@implementation AnimationTestRoundTripAnimation
- (AnimationTestRoundTripAnimation*) initWithDuration: (NSTimeInterval)duration
                                      animationCurve: (NSAnimationCurve)curve
{
  if ((self = [super initWithDuration: duration animationCurve: curve]))
  {
    backward = NO;
  }
  return self;
}

- (float) currentValue
{
  float value = [super currentValue];
  if (backward) value = 1 - value;
  return value;
}

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
  [super setCurrentProgress: progress];
  if (progress >= 1.0)
    backward = !backward;
}

@end

@implementation AnimationTestMainAnimation

- (AnimationTestMainAnimation*) initWithView: (NSView*)aView;
{
  if ((self = [super initWithDuration: 7 animationCurve: NSAnimationLinear]))
    {
      view = aView;
      RETAIN (view);
    }
  return self;
}

- (void) dealloc
{
  RELEASE (view);
  [super dealloc];
}

- (void) updateView
{
  [view display];
}

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
  [super setCurrentProgress: progress];
  // needed in case of a threaded animation : is Appkit not thread safe ???
  // Note : dont wait ! Avoids a deadlock...
  [self performSelectorOnMainThread: @selector(updateView)
                         withObject: nil waitUntilDone: NO];
}

@end
