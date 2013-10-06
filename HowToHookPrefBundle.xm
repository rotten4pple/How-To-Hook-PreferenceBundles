// We need this
#import <Preferences/PSSpecifier.h>

// Specific the group of hooking
%group SiriHook

%hook AssistantController // This is a class in Assistant.bundle (Siri Preferences Bundle)

- (void)setAssistantLanguage:(id)language forSpecifier:(id)specifier
{
	%log;
	%orig;
}

%end

%end

// Now head to PSListController
%hook PSListController

// This is method we use for making our hook(s) running
- (void)lazyLoadBundle:(PSSpecifier *)bundle
{
	if ([bundle.name isEqualToString:@"Siri"]) // Detect bundle(s) name to hook
	{
		%orig; // Always call original method
		%init(SiriHook, AssistantController = objc_getClass("AssistantController")); // initialize the hook(s), get class(es) if it's neccessary
	} else // If not, keep the original
		%orig;
}

%end

// Do not forget to add the following
%ctor
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    %init;
    [pool drain];
}