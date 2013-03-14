//
//  GBMAboutViewController.h
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 3/13/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GBMAboutViewNotificated;
@interface GBMAboutViewController : UIViewController
- (IBAction)done:(id)sender;
@property (retain, nonatomic) IBOutlet UISwitch *noComics;
@property (retain, nonatomic) IBOutlet UINavigationBar *bar;
@property (nonatomic,retain) id<GBMAboutViewNotificated> delegate;
@end

@protocol GBMAboutViewNotificated <NSObject>

- (void) settingsDidChange;


@end