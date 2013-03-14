//
//  GBMAboutViewController.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 3/13/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMAboutViewController.h"

@interface GBMAboutViewController ()

@end

@implementation GBMAboutViewController

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
- (void) viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about"]];
    [self.noComics setOn:[[NSUserDefaults standardUserDefaults]boolForKey:@"noComics"]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.bar setHidden:true];
    }
}
- (void) viewDidDisappear:(BOOL)animated {
      [[NSUserDefaults standardUserDefaults]setBool:self.noComics.on forKey:@"noComics"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if ([self.delegate respondsToSelector:@selector(settingsDidChange)]) {
        [self.delegate settingsDidChange];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [[NSUserDefaults standardUserDefaults]setBool:self.noComics.on forKey:@"noComics"];
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)dealloc {
    [_noComics release];
    [_bar release];
    [super dealloc];
}
@end
