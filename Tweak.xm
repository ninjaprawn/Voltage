static CGFloat p;
static BOOL enabled = NO;
static NSString *format = @"Volume: %d%%";

%hook SBHUDView

-(void)setTitle:(id)arg1 {
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.ninjaprawn.voltage.plist"];
    if (settings) {
        BOOL tempEnabledBool = [[settings objectForKey:@"enabled"] boolValue];
        NSString *tempFormat = [settings objectForKey:@"format"];
        if (tempEnabledBool) {
            enabled = tempEnabledBool;
        } else {
            enabled = NO;
        }
        if (tempFormat) {
            tempFormat = [tempFormat stringByReplacingOccurrencesOfString:@"%%%" withString:@"%d%"];
            tempFormat = [tempFormat stringByReplacingOccurrencesOfString:@"%%" withString:@"%d"];
            tempFormat = [tempFormat stringByReplacingOccurrencesOfString:@"%d%" withString:@"%d%%"];
            format = tempFormat;
        }
    }
    if (enabled) {
        if ([format isEqualToString:@""]) {
            format = @"Volume: %d%%";
        }
        p = p*100.0;
        NSString *prog = @"";
        int progress = (int)floor(p);
        prog = [NSString stringWithFormat:format, progress];
        arg1 = prog;
        return %orig(arg1);
    }
    return %orig;
}

-(float)progress {
    p = %orig;
    return %orig;
}

%end