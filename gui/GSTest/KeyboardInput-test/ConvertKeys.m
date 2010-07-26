/* ConvertKeys.m: Convert characters to their names

   Copyright (C) 2001 Free Software Foundation, Inc.

   Author:  Nicola Pero <n.pero@mi.flashnet.it>
   Date: 2001
   
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

#include "ConvertKeys.h"

/* Code stolen from the corresponding gnustep-gui code also by myself.  */
#define CHARACTER_TABLE_SIZE 78

static struct 
{
  NSString *name;
  unichar character;
} 
character_table[CHARACTER_TABLE_SIZE] =
{
  { @"UpArrow", NSUpArrowFunctionKey },
  { @"DownArrow", NSDownArrowFunctionKey },
  { @"LeftArrow", NSLeftArrowFunctionKey },
  { @"RightArrow", NSRightArrowFunctionKey },
  { @"F1", NSF1FunctionKey },
  { @"F2", NSF2FunctionKey },
  { @"F3", NSF3FunctionKey },
  { @"F4", NSF4FunctionKey },
  { @"F5", NSF5FunctionKey },
  { @"F6", NSF6FunctionKey },
  { @"F7", NSF7FunctionKey },
  { @"F8", NSF8FunctionKey },
  { @"F9", NSF9FunctionKey },
  { @"F10", NSF10FunctionKey },
  { @"F11", NSF11FunctionKey },
  { @"F12", NSF12FunctionKey },
  { @"F13", NSF13FunctionKey },
  { @"F14", NSF14FunctionKey },
  { @"F15", NSF15FunctionKey },
  { @"F16", NSF16FunctionKey },
  { @"F17", NSF17FunctionKey },
  { @"F18", NSF18FunctionKey },
  { @"F19", NSF19FunctionKey },
  { @"F20", NSF20FunctionKey },
  { @"F21", NSF21FunctionKey },
  { @"F22", NSF22FunctionKey },
  { @"F23", NSF23FunctionKey },
  { @"F24", NSF24FunctionKey },
  { @"F25", NSF25FunctionKey },
  { @"F26", NSF26FunctionKey },
  { @"F27", NSF27FunctionKey },
  { @"F28", NSF28FunctionKey },
  { @"F29", NSF29FunctionKey },
  { @"F30", NSF30FunctionKey },
  { @"F31", NSF31FunctionKey },
  { @"F32", NSF32FunctionKey },
  { @"F33", NSF33FunctionKey },
  { @"F34", NSF34FunctionKey },
  { @"F35", NSF35FunctionKey },
  { @"Insert", NSInsertFunctionKey },
  { @"Delete", NSDeleteFunctionKey },
  { @"Home", NSHomeFunctionKey },
  { @"Begin", NSBeginFunctionKey },
  { @"End", NSEndFunctionKey },
  { @"PageUp", NSPageUpFunctionKey },
  { @"PageDown", NSPageDownFunctionKey },
  { @"PrintScreen", NSPrintScreenFunctionKey },
  { @"ScrollLock", NSScrollLockFunctionKey },
  { @"Pause", NSPauseFunctionKey },
  { @"SysReq", NSSysReqFunctionKey },
  { @"Break", NSBreakFunctionKey },
  { @"Reset", NSResetFunctionKey },
  { @"Stop", NSStopFunctionKey },
  { @"Menu", NSMenuFunctionKey },
  { @"User", NSUserFunctionKey },
  { @"System", NSSystemFunctionKey },
  { @"Print", NSPrintFunctionKey },
  { @"ClearLine", NSClearLineFunctionKey },
  { @"ClearDisplay", NSClearDisplayFunctionKey },
  { @"InsertLine", NSInsertLineFunctionKey },
  { @"DeleteLine", NSDeleteLineFunctionKey },
  { @"InsertChar", NSInsertCharFunctionKey },
  { @"DeleteChar", NSDeleteCharFunctionKey },
  { @"Prev", NSPrevFunctionKey },
  { @"Next", NSNextFunctionKey },
  { @"Select", NSSelectFunctionKey },
  { @"Execute", NSExecuteFunctionKey },
  { @"Undo", NSUndoFunctionKey },
  { @"Redo", NSRedoFunctionKey },
  { @"Find", NSFindFunctionKey },
  { @"Help", NSHelpFunctionKey },
  { @"ModeSwitch", NSModeSwitchFunctionKey },
  { @"Backspace", NSDeleteCharacter },
  { @"BackTab", NSBackTabCharacter },
  { @"Tab", NSTabCharacter },
  { @"Enter", NSEnterCharacter },
  { @"FormFeed", NSFormFeedCharacter },
  { @"CarriageReturn", NSCarriageReturnCharacter }
};

NSString *convertCharactersToDisplayable (NSString *characters)
{
  if ([characters length] == 1)
    {
      int i;
      unichar c = [characters characterAtIndex: 0];

      for (i = 0; i < CHARACTER_TABLE_SIZE; i++)
	{
	  if (c == character_table[i].character)
	    {
	      return [NSString stringWithFormat: @"<%@>",
			       character_table[i].name];
	    }
	}
    }

  return characters;
}
