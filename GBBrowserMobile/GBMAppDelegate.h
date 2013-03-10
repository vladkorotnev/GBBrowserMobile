//
//  GBMAppDelegate.h
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>
#import "EncryptionModule.h"
@class GBMViewController;

@interface GBMAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{
 
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GBMViewController *viewController;

@end
