/*
   Copyright (C) 2002 Free Software Foundation, Inc.
   
   Author: Nicola Pero <n.pero@mi.flashnet.it>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
*/
#include <Foundation/Foundation.h>
#include "SharedArea.h"

static double progress_index = 0;
static BOOL is_running = NO;

static NSLock *lock;

void set_up_shared_area ()
{
  lock = [NSLock new];
}


double progress_indicator ()
{
  double value;

  [lock lock];
  value = progress_index;
  [lock unlock];

  return value;
}

BOOL is_auxiliary_thread_running ()
{
  BOOL value;

  [lock lock];
  value = is_running;
  [lock unlock];

  return value;
}


void set_progress_indicator (double value)
{
  [lock lock];
  progress_index = value;
  [lock unlock];
}

void set_is_auxiliary_thread_running (BOOL flag)
{
  [lock lock];
  is_running = flag;
  [lock unlock];
}
