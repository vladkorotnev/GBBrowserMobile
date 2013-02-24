//
//  GBMServerList.h
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/12/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBMServerList : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
- (IBAction)doneWithIt:(id)sender;
- (IBAction)addServer:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *table;

@end
