//
//  GBMAbout.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMAbout.h"


@interface GBMAbout ()

@end

@implementation GBMAbout

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    self.shouldPaginate.on =  [[NSUserDefaults standardUserDefaults]boolForKey:@"paginate"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_icon release];
    [_shouldPaginate release];
    [super dealloc];
}
- (IBAction)end:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)paginatorChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:self.shouldPaginate.on forKey:@"paginate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
