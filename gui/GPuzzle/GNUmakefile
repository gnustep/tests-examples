
GNUSTEP_INSTALLATION_DIR = $(GNUSTEP_SYSTEM_ROOT)

include $(GNUSTEP_MAKEFILES)/common.make

# The application to be compiled
APP_NAME = GPuzzle

# The Objective-C source files to be compiled

GPuzzle_OBJC_FILES = main.m  \
  BTree.m         \
  Document.m      \
  PieceView.m

SHARED_CFLAGS     += -g

# The Resource files to be copied into the app's resources directory
// GFractal_RESOURCE_FILES = Icons/*

-include GNUmakefile.preamble

-include GNUmakefile.local

include $(GNUSTEP_MAKEFILES)/application.make

-include GNUmakefile.postamble

