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
#ifndef SHARED_AREA_H
#define SHARED_AREA_H

/* Must be called before any thread action begins.  */
void set_up_shared_area ();

/* The main thread calls this to read.  */
double progress_indicator ();

/* The main thread calls this to know if the auxliary thread is
   running.  */
BOOL is_auxiliary_thread_running ();

/* The auxiliary thread calls this to write.  */
void set_progress_indicator (double value);

/* The auxiliary thread calls this to write.  */
void set_is_auxiliary_thread_running (BOOL flag);

#endif /* SHARED_AREA_H */
