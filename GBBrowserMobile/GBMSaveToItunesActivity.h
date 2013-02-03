//
//  GBMSaveToItunesActivity.h
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDownloadViewController.h"
@interface GBMSaveToItunesActivity : UIActivity
{
    HCDownloadViewController *dlvc;
    NSURL*download;
    UIAlertView*wait;
}
@end
