/* -*-objc-*-
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
#include "AuxiliaryThread.h"
#include "SharedArea.h"

/* for sleep */
#include <unistd.h>

@implementation AuxiliaryThread
+ (void)start: (id)unused
{
  double advancement = 0.0;
  
  set_is_auxiliary_thread_running (YES);
  set_progress_indicator (advancement);

  /* This is where the thread would do its job ... here we do nothing.  */
  while (advancement < 100)
    {
      sleep (1);
      advancement += 1.366;
      set_progress_indicator (advancement);
    }

  set_progress_indicator (100);

  set_is_auxiliary_thread_running (NO);
}

@end
