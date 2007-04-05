/*
 * AnimationView.h
 *
 * Created : 2007-03-Mar
 * Author : Xavier Glattard (xgl) <xavier.glattard@online.fr>
 * Copyright 2007 Free Software Foundation
 *
 * This file is part of the GNUstep framework.
 *
 * Last changes : 2007-04-Apr 09:17 (Paris, Madrid) by Xavier Glattard (xgl)
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

#ifndef _ANIMATIONVIEW_H_
#define _ANIMATIONVIEW_H_

#include <AppKit/NSView.h>
#include <AppKit/NSTextField.h>
#include <AppKit/NSAnimation.h>

@interface NSAnimation(Private)
- (_NSAnimationCurveDesc*) _gs_curveDesc;
- (NSAnimationProgress) _gs_curveShift;
@end

@class AnimationTestLoopAnimation;
@class AnimationTestRoundTripAnimation;
@class AnimationTestMainAnimation;

/**
 * AnimationView
 */
@interface AnimationView : NSView
{
  AnimationTestMainAnimation *mainAnimation;
  AnimationTestLoopAnimation *circlePosAnimation;
  AnimationTestRoundTripAnimation *circleColorAnimation;
  NSAnimation* shapeAnimation[4];
  AnimationTestLoopAnimation* plotAnimation;
  NSPoint curvePath[100];
  unsigned curvePathIndex;
  NSTimer *fpsDisplayTimer;
  NSTextField *fpsField;
}

- (void) fpsDisplay;

@end // interface AnimationView

#endif // _ANIMATIONVIEW_H_
