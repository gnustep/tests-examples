include $(GNUSTEP_MAKEFILES)/common.make

PACKAGE_NAME = MyTransparentGL
VERSION = 0.0.1
APP_NAME = MyTransparentGL
MyTransparentGL_MAIN_MODEL_FILE=MyTransparentGL.gorm
MyTransparentGL_APPLICATION_ICON=MyTransparentGL.tiff

MyTransparentGL_OBJC_FILES = main.m AppController.m
MyTransparentGL_RESOURCE_FILES = MyTransparentGL.gorm MyTransparentGL.tiff


ifeq ($(GNUSTEP_TARGET_OS), mingw32)
ADDITIONAL_TOOL_LIBS += -lopengl32 -lglu32 -lm
else
ADDITIONAL_TOOL_LIBS += -lGL -lGLU -lm
endif

include $(GNUSTEP_MAKEFILES)/application.make
