//
//  GBMServerList.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/12/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMServerList.h"

@interface GBMServerList ()
{
    NSMutableArray*_servers;
}
@end

@implementation GBMServerList

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
    _servers = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"allservers"]];
    [_servers retain];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.table setEditing:TRUE];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _servers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Cell");
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"MyIdentifier"];
                             
                             if (cell == nil)
                             {
                                 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyIdentifier"] autorelease];
                             }
                             cell.textLabel.text = [_servers objectAtIndex:indexPath.row];
                             return cell;
}

- (IBAction)doneWithIt:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [_servers removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]setObject:_servers forKey:@"allservers"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}



- (IBAction)addServer:(id)sender {
  UIAlertView *a=  [[UIAlertView alloc]initWithTitle:@"Add server" message:@"Enter Gelbooru server address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [a setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [a show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == alertView.cancelButtonIndex) return;
    [_servers addObject:[alertView textFieldAtIndex:0].text];
    [[NSUserDefaults standardUserDefaults]setObject:_servers forKey:@"allservers"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.table reloadData];
}
- (void)dealloc {
    [_table release];
    [super dealloc];
}
@end
