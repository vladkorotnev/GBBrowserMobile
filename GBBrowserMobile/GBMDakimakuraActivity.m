//
//  GBMDakimakuraActivity.m
//  GBBrowserMobile
//
//  Created by Gokou Ruri on 4/20/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMDakimakuraActivity.h"

@implementation GBMDakimakuraActivity
- (NSString *)activityType{
    return self.description;
}       // default returns nil. subclass may override to return custom activity type that is reported to completion handler
- (NSString *)activityTitle{
    return @"Make a dakimakura";
}      // default returns nil. subclass must override and must return non-nil value
- (UIImage *)activityImage{
    return [UIImage imageNamed:@"daki.png"];
}       // default returns nil. subclass must override and must return non-nil value

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    return YES;
}
- (void)prepareWithActivityItems:(NSArray *)activityItems{
    // dirtily assume item at index 1 is the url
    NSLog(@"Send to DakiMaker: %@",activityItems[1])    ;
   download = [NSURL URLWithString:[NSString stringWithFormat:@"daki://save?url=%@",[[activityItems objectAtIndex:1]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [download retain];
    
}

- (UIViewController *)activityViewController{
    return nil;
}
- (void)performActivity{
    if ([[UIApplication sharedApplication]canOpenURL:download]) 
        [[UIApplication sharedApplication]openURL:download];
    else
        [[[UIAlertView alloc]initWithTitle:@"Stub" message:@"Add DakiMaker app link here" delegate:self cancelButtonTitle:@"Developers" otherButtonTitles: nil]show];
    
    [self activityDidFinish:true];
}

@end
