// We need this
#import <Preferences/PSSpecifier.h>

// Specific the group of hooking
%group SiriHook

%hook AssistantController // This is a class in Assistant.bundle (Siri Preferences Bundle)

// The method we want to hook
- (void)setAssistantLanguage:(id)language forSpecifier:(id)specifier
{
	%log;
	%orig;
}

%end

%end

// Now head to PSListController (For iOS 6 and 7) or PSRootController (For iOS 4 and 5)
%hook PSListController

// This is method we use for making our hook(s) running
- (void)lazyLoadBundle:(PSSpecifier *)bundle
{
	%orig; // Call the original method first, or let the bundle loaded
	if ([bundle.name isEqualToString:@"Siri"]) // Detect bundle(s) name to hook
	{
		%init(SiriHook, AssistantController = objc_getClass("AssistantController")); // initialize the hook(s), get class(es) if it's neccessary
	}
}

%end

// Do not forget to add the following
%ctor
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    %init;
    [pool drain];
}