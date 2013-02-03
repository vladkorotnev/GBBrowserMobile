//
//  GBMViewController.h
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBMPicture.h"
#import "GBMAbout.h"
@interface GBMViewController : UIViewController<UIActionSheetDelegate,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate>
{
    NSInteger currentPid;
    bool isInSearch;
      NSInteger totalPosts;
   
    NSMutableArray *currentPictures;
    NSString*curSearchRequest;
}
- (IBAction)serverChoose:(id)sender;
@property (retain, nonatomic) IBOutlet UICollectionView *collection;
@property (retain, nonatomic) IBOutlet UISearchBar *search;
@property (retain, nonatomic) IBOutlet UIView *disableView;
- (IBAction)hideHints:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *hints;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *countoftotal;
- (IBAction)loadMore:(id)sender;
- (IBAction)about:(id)sender;

@end