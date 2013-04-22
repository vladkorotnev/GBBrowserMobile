//
//  GBMSaveToItunesActivity.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMSaveToItunesActivity.h"
#import "MyPhoto.h"
@implementation GBMSaveToItunesActivity

- (NSString *)activityType{
    return self.description;
}       // default returns nil. subclass may override to return custom activity type that is reported to completion handler
- (NSString *)activityTitle{
    return @"Download full version";
}      // default returns nil. subclass must override and must return non-nil value
- (UIImage *)activityImage{
    return [UIImage imageNamed:@"itunes.png"];
}       // default returns nil. subclass must override and must return non-nil value

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems{
    return YES;
}  
- (void)prepareWithActivityItems:(NSArray *)activityItems{
   // dirtily assume item at index 1 is the url
  
    download = [NSURL URLWithString:[activityItems objectAtIndex:1]];
    [download retain];
    dlvc = [[HCDownloadViewController alloc] init];
   
    dlvc.downloadDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]; // Get documents folder;
    NSLog(@"Download to %@",dlvc.downloadDirectory);
    dlvc.delegate = self;
    [dlvc retain];
    wait = [[UIAlertView alloc]initWithTitle:@"Downloading.." message:@"Please wait" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [wait retain];

}      

- (UIViewController *)activityViewController{
    return nil;
}   
- (void)performActivity{
    [wait show];
        [dlvc downloadURL:download  userInfo:nil];
    
}                     
- (void)downloadController:(HCDownloadViewController *)vc finishedDownloadingURL:(NSURL *)url toFile:(NSString *)fileName userInfo:(NSDictionary *)userInfo {
    NSLog(@"Done");
    [wait dismissWithClickedButtonIndex:0 animated:true];
    [[[UIAlertView alloc]initWithTitle:@"Downloaded" message:@"Grab the full resolution version via iTunes" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
   [self activityDidFinish:true];
}

@end
