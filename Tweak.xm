//Import header
#import "Voltage.h"

//Variables
static NSString *progress;
static BOOL enabled = YES;
NSString *format = @"Volume: %@%%";
float cv;
NSDictionary* prefs;

//Reload the preferance variables
void reloadPrefs() {
	prefs = [[NSDictionary alloc] initWithContentsOfFile:kSettingsPath];
	enabled = !prefs[@"Enabled"] ? YES : [prefs[@"Enabled"] boolValue];
	format = !prefs[@"Format"] ? @"Volume: %@%%" : prefs[@"Format"];
}

//Hook onto the HUD
%hook SBHUDView

//Hook onto the setTitle method:
-(void)setTitle:(id)arg1 {
    if (enabled) {
        //Set to default format if blank, default or nil
        if ([format isEqualToString:@""] || format == nil || [format isEqualToString:@"Volume: %@%%"]) {
            format = @"Volume: %@%%";
        } else {
        	//Temp string cause direct formating crashes SB 
        	NSString *tempFormat;
        	//See if substring is in string. If is, change it
        	if ([format rangeOfString:@"%%%"].location != NSNotFound)
        		tempFormat = [format stringByReplacingOccurrencesOfString:@"%%%" withString:@"%@%\%"];
        	if ([format rangeOfString:@"%%"].location != NSNotFound)
        		tempFormat = [format stringByReplacingOccurrencesOfString:@"%%" withString:@"%@%"];
        	if ([tempFormat rangeOfString:@"%\%"].location != NSNotFound)
        		tempFormat = [tempFormat stringByReplacingOccurrencesOfString:@"%\%" withString:@"%%"];
        	format = tempFormat;
        }
        //Float to string
        NSString *cvs = [NSString stringWithFormat:@"%2.0f", cv];
        //Apply progress with format
        progress = [NSString stringWithFormat:format, cvs];
        //set arg1 to the string
        arg1 = progress;
        reloadPrefs();
        //return original with custom arguement
        return %orig(arg1);
    }
    //if enabled = false, return original
    return %orig;
}

-(float)progress {
    //get current progress
    cv = %orig*100;
    //say we were never here...
    return %orig;
}

%end

%ctor {
	//Reloads the prefs
	reloadPrefs();
	//NC Observer for reloading in settings
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)reloadPrefs,
        CFSTR("com.ninjaprawn.voltage/preferencechanged"),
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately);
}
