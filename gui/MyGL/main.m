#include <AppKit/AppKit.h>

int main(int argc, char **argv)
{
	CREATE_AUTORELEASE_POOL(pool);
	[NSApplication sharedApplication];
	[NSApp run];
	DESTROY(pool);
	return 0;
}
