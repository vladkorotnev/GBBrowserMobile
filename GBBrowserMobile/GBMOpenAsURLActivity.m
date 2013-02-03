//
//  GBMOpenAsURLActivity.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMOpenAsURLActivity.h"

@implementation GBMOpenAsURLActivity

- (NSString *)activityType{
    return self.description;
}       // default returns nil. subclass may override to return custom activity type that is reported to completion handler
- (NSString *)activityTitle{
    return @"Open full version";
}      // default returns nil. subclass must override and must return non-nil value
- (UIImage *)activityImage{
    return [UIImage imageNamed:@"browse.png"];
}       // default returns nil. subclass must override and must return non-nil value

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    return YES;
}
- (void)prepareWithActivityItems:(NSArray *)activityItems{
    // dirtily assume item at index 1 is the url
    
    download = [NSURL URLWithString:[activityItems objectAtIndex:1]];
    [download retain];
    
}

- (UIViewController *)activityViewController{
    return nil;
}
- (void)performActivity{
    [[UIApplication sharedApplication]openURL:download];
    [self activityDidFinish:true];
}



@end
