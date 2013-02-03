//
//  GBMAbout.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMAbout.h"
@interface UIImage (privateAPI)
-(UIImage*)_applicationIconImageForFormat:(int)format precomposed:(BOOL)precomposed;
@end

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_icon release];
    [super dealloc];
}
- (IBAction)end:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
