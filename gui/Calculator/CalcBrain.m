/* CalcBrain.m: Brain of Calculator.app

   Copyright (C) 1999 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 1999
   
   This file is part of GNUstep.
   
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
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. */
#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "CalcBrain.h"
#include "CalcFace.h"
#include <math.h>

@implementation CalcBrain: NSObject
{
  CalcFace *face;
  double result;
  double enteredNumber;
  calcOperation operation;
  int fractionalDigits;
  BOOL decimalSeparator;
  BOOL editing;
}
-(id) init
{
  [super init];
  result = 0;
  enteredNumber = 0;
  operation = none;
  fractionalDigits = 0;
  decimalSeparator = NO;
  editing = YES;
  face = nil;
  return self;
}
-(void) dealloc
{
  if (face) 
    [face release];
  [super dealloc];
}
// Set the corresponding face
-(void) setFace: (CalcFace *)aFace
{
  face = [aFace retain];
  [face setDisplayedNumber: enteredNumber withSeparator: decimalSeparator
	fractionalDigits: fractionalDigits];
}
// The various buttons 
-(void) clear: (id)sender
{
  result = 0;
  enteredNumber = 0;
  operation = none;
  fractionalDigits = 0;
  decimalSeparator = NO;
  editing = YES;
  [face setDisplayedNumber: 0 withSeparator: NO fractionalDigits: 0];
}
-(void) equal: (id)sender
{
  switch (operation)
    {
    case none: 
      result = enteredNumber;
      enteredNumber = 0;
      decimalSeparator = NO;
      fractionalDigits = 0;
      return;
      break;
    case addition:
      result = result + enteredNumber;
      break;
    case subtraction:
      result = result - enteredNumber;
      break;
    case multiplication:
      result = result * enteredNumber;
      break;
    case division:
      if (enteredNumber == 0)
	{
	  [self error];
	  return;
	}
      else 
	result = result / enteredNumber;
      break;
    }
  [face setDisplayedNumber: result 
	withSeparator: (ceil(result) != result)      
	fractionalDigits: 7];
  enteredNumber = result;
  operation = none;
  editing = NO;
}
-(void) digit: (id)sender
{
  if (!editing)
    {
      enteredNumber = 0;
      decimalSeparator = NO;
      fractionalDigits = 0;
      editing = YES;
    }
  if (decimalSeparator)
    {
      enteredNumber = enteredNumber 
	+ ([sender tag] * pow (0.1, 1+fractionalDigits));
      fractionalDigits++;
    }
  else
    {
      enteredNumber = enteredNumber * 10 + ([sender tag]);
      // Check overflow
      if (enteredNumber > pow (10, 15))
	{
	  [self error];
	  return;
	}
    }
  [face setDisplayedNumber: enteredNumber withSeparator: decimalSeparator
	fractionalDigits: fractionalDigits];
}
-(void) decimalSeparator: (id)sender
{
  if (!editing)
    {
      enteredNumber = 0;
      decimalSeparator = NO;
      fractionalDigits = 0;
      editing = YES;
    }
  if (!decimalSeparator)
    {
      decimalSeparator = YES;
      [face setDisplayedNumber: enteredNumber withSeparator: YES
	    fractionalDigits: 0];
    }
}
-(void) operation: (id)sender
{
  if (operation == none)
    {
      result = enteredNumber;
      enteredNumber = 0;
      decimalSeparator = NO;
      fractionalDigits = 0;
      operation = [sender tag];
    }
  else // operation
    {	 
      [self equal: nil];
      [self operation: sender];
    }
}
-(void) squareRoot: (id)sender
{
  if (operation == none)
    {
      result = sqrt (enteredNumber);
      [face setDisplayedNumber: result 
	    withSeparator: (ceil(result) != result)
	    fractionalDigits: 7];
      enteredNumber = result;
      editing = NO;
      operation = none;  
    }
  else // operation
    {	 
      [self equal: nil];
      [self squareRoot: sender];
    }
} 
-(void) error
{
  result = 0;
  enteredNumber = 0;
  operation = none;
  fractionalDigits = 0;
  decimalSeparator = NO;
  editing = YES;
  [face setError];
}
@end

