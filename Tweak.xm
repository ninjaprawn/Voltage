//Variables
static CGFloat p;
static int pp;
static BOOL enabled = NO;
static NSString *format = @"Volume: %d%%";

//May the hooking begin

//Hook onto the HUD
%hook SBHUDView

//Hook onto the setTitle method:
-(void)setTitle:(id)arg1 {
    //Some funky things with the prefs
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.ninjaprawn.voltage.plist"];
    if (settings) {
        BOOL tempEnabledBool = [[settings objectForKey:@"enabled"] boolValue];
        NSString *tempFormat = [settings objectForKey:@"format"];
        if (tempEnabledBool) {
            enabled = tempEnabledBool;
        } else {
            enabled = NO;
        }
        //Formatting the string
        if (tempFormat) {
            tempFormat = [tempFormat stringByReplacingOccurrencesOfString:@"%%%" withString:@"%d%"];
            tempFormat = [tempFormat stringByReplacingOccurrencesOfString:@"%%" withString:@"%d"];
            tempFormat = [tempFormat stringByReplacingOccurrencesOfString:@"%d%" withString:@"%d%%"];
            format = tempFormat;
        }
    }
    if (enabled) {
        //Set to default format if blank
        if ([format isEqualToString:@""]) {
            format = @"Volume: %d%%";
        }
        //Multiply for percentage
        p = p*100.0;
        //Variables
        NSString *prog = @"";
        int progress;
        //Float to String. @codyd51: CGFloat didn't work :(
        NSString *strp = [NSString stringWithFormat:@"%f", p];
        //Do things with the float string
        if ([strp hasPrefix:@"0.0"]) {
            progress = 0;
        } else if ([strp hasPrefix:@"6.25"]) {
            progress = 6;
        }else if ([strp hasPrefix:@"12.5"]) {
            progress = 12;
        } else if ([strp hasPrefix:@"18.75"]) {
            progress = 18;
        } else if ([strp hasPrefix:@"25.00"]) {
            progress = 25;
        } else if ([strp hasPrefix:@"31.25"]) {
            progress = 31;
        } else if ([strp hasPrefix:@"37.5"]) {
            progress = 37;
        } else if ([strp hasPrefix:@"43.75"]) {
            progress = 43;
        } else if ([strp hasPrefix:@"50.0"]) {
            progress = 50;
        } else if ([strp hasPrefix:@"56.25"]) {
            progress = 56;
        } else if ([strp hasPrefix:@"62.5"]) {
            progress = 62;
        } else if ([strp hasPrefix:@"68.75"]) {
            progress = 68;
        } else if ([strp hasPrefix:@"75.00"]) {
            progress = 75;
        } else if ([strp hasPrefix:@"81.25"]) {
            progress = 81;
        } else if ([strp hasPrefix:@"87.50"]) {
            progress = 87;
        } else if ([strp hasPrefix:@"93.75"]) {
            progress = 93;
        } else if ([strp hasPrefix:@"100.0"]) {
            progress = 100;
        } else { //If user wants to stuff up my tweak, good luck (not concerning arm64 users)
            progress = pp;
        }
        //Apply progress with format
        prog = [NSString stringWithFormat:format, progress];
        //set arg1 to the string
        arg1 = prog;
        //Back up current progress
        pp = progress;
        //return original with custom arguement
        return %orig(arg1);
    }
    //if enabled = false, return original
    return %orig;
}

//Hook onto progress method
-(float)progress {
    //get current progress
    p = %orig;
    //say we were never here...
    return %orig;
}

%end
