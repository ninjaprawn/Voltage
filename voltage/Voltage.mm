#import "PSListController.h"
#import "PSSpecifier.h"
#import "PSViewController.h"

@interface VoltageListController: PSListController {
}
@end

@implementation VoltageListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Voltage" target:self] retain];
	}
	return _specifiers;
}

- (void)save {
    [self.view endEditing:YES];
}

@end

// vim:ft=objc
