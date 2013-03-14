//
//  GBMViewController.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMViewController.h"
#import "MyPhoto.h"
#import "EGOPhotoGlobal.h"
#import "MyPhotoSource.h"
#import "UIImageView+GBMPictureView.h"
@interface GBMViewController ()

@end

@implementation GBMViewController

 static int currentThumbSize=100;
static bool didLoadSecondTime=false;
- (void) loadPics {
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Trying to load");
    currentPid = 0;
 self.countoftotal.title=@"Loading...";
    [currentPictures removeAllObjects];
    [self.collection reloadData];
    NSString * url = [NSString stringWithFormat:@"http://%@//index.php?page=dapi&s=post&q=index&pid=%i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]lowercaseString],currentPid ];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"noComics"]) {
        url = [NSString stringWithFormat:@"%@&tags=-comic",url];
    }
    if(isInSearch) {
        if (![[NSUserDefaults standardUserDefaults]boolForKey:@"noComics"])
            url = [NSString stringWithFormat:@"%@&tags=%@",url,curSearchRequest];
        else
            url = [NSString stringWithFormat:@"%@+%@",url,curSearchRequest];
    }
    NSURL * t = [NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self parseDocumentWithURL:t];
}


-(BOOL)parseDocumentWithURL:(NSURL *)url {
    if (url == nil)
    {NSLog(@"Nil url");
        self.countoftotal.title = @"Check server settings.";
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return NO;}
    NSLog(@"URL %@",url.absoluteString);
    // this is the parsing machine
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // this class will handle the events
    [xmlparser setDelegate:self];
    [xmlparser setShouldResolveExternalEntities:NO];
    NSLog(@"Starting parse");
    // now parse the document
    BOOL ok = [xmlparser parse];
    if (ok == NO){
        self.countoftotal.title = @"Error loading.";
        NSLog(@"%@",xmlparser.parserError.localizedDescription);
        NSLog(@"%@",xmlparser.parserError.localizedFailureReason);
    }
        
    else
        NSLog(@"OK");
    
    
    return ok;
}


-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"Start");
  
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !didLoadSecondTime) {
        didLoadSecondTime = true;
        [self loadMorePics];
    }
    NSLog(@"End");
    self.countoftotal.title = [NSString stringWithFormat:@"%i of %i",currentPictures.count,totalPosts];
    [self.collection reloadData];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"post"]) {
        
        // print all attributes for this element
        NSEnumerator *attribs = [attributeDict keyEnumerator];
        NSString *key, *value;
        NSURL * thumb, *sample, *full;
        NSArray * tags;
        NSString  *rating,*ident;
        
        while((key = [attribs nextObject]) != nil) {
            value = [attributeDict objectForKey:key];
            if ([key isEqualToString:@"file_url"]) {
                full = [NSURL URLWithString:value];
            }
            if ([key isEqualToString:@"sample_url"]) {
                sample = [NSURL URLWithString:value];
            }
            if ([key isEqualToString:@"preview_url"]) {
                thumb = [NSURL URLWithString:value];
            }
            if ([key isEqualToString:@"rating"]) {
                rating = value;
            }
            if ([key isEqualToString:@"id"]) {
                ident = value;
            }
            if ([key isEqualToString:@"tags"]) {
                tags = [value componentsSeparatedByString:@" "];
            }
        }
        GBMPicture*i = [[GBMPicture alloc]init];
        [i setFullURL:full];
        [i setThumbnailURL:thumb];
        [i setSampleURL:sample];
        [i setTags:tags];
        [i setIdent:ident];
        
        [currentPictures addObject:i];
        [currentPictures retain];
    }
    if ([elementName isEqualToString:@"posts"]) {
        NSEnumerator *attribs = [attributeDict keyEnumerator];
        NSString *key, *value;
        
        while((key = [attribs nextObject]) != nil) {
            value = [attributeDict objectForKey:key];
            if ([key isEqualToString:@"count"]) {
                totalPosts = [value integerValue];
            }
        }
        
    }
    
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}


- (void) loadMorePics {
    NSLog(@"Trying to load more");
 self.countoftotal.title=@"Loading...";
    currentPid = currentPid + 1;
    if (currentPid * 100 >= totalPosts) {
        NSLog(@"End!");
        [[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"It seems you have reached the end of the pages." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
         self.countoftotal.title = [NSString stringWithFormat:@"%i of %i",currentPictures.count,totalPosts];
        return;
    }
    
    NSString*serv;
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]hasPrefix:@"http://"] && ![[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]hasPrefix:@"https://"]){
        serv  = [NSString stringWithFormat:@"http://%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]];
    } else serv=[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"];
    NSString * url = [NSString stringWithFormat:@"%@//index.php?page=dapi&s=post&q=index&pid=%i",serv,currentPid ];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"noComics"]) {
        url = [NSString stringWithFormat:@"%@&tags=-comic",url];
    }
    if(isInSearch) {
        if (![[NSUserDefaults standardUserDefaults]boolForKey:@"noComics"])
            url = [NSString stringWithFormat:@"%@&tags=%@",url,curSearchRequest];
        else
            url = [NSString stringWithFormat:@"%@+%@",url,curSearchRequest];
    }
    NSURL * t = [NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self parseDocumentWithURL:t];
    
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.disableView.alpha = 0;
    [self.collection addSubview:self.disableView];
    [currentPictures removeAllObjects];
    [self.collection reloadData];
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.4];
    self.disableView.alpha = 0.6;
    [UIView commitAnimations];
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    isInSearch = NO;
    curSearchRequest = @"";
    [curSearchRequest retain];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
 [self.disableView removeFromSuperview];
    [self performSelector:@selector(loadPics) withObject:nil afterDelay:0.6];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    isInSearch = YES;
    curSearchRequest = [[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"_"]lowercaseString];
    [curSearchRequest retain];
 [self.disableView removeFromSuperview];
    [self performSelector:@selector(loadPics) withObject:nil afterDelay:0.6];
}

- (void)viewDidLoad
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]isEqualToString:@""] || [[NSUserDefaults standardUserDefaults]objectForKey:@"Server"] == nil) {
         [[NSUserDefaults standardUserDefaults]setObject:@"vladkorotnev.me/GBBrowserSample" forKey:@"Server"];
        [[NSUserDefaults standardUserDefaults]setObject:@[@"vladkorotnev.me/GBBrowserSample"] forKey:@"allservers"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    if (!([[NSUserDefaults standardUserDefaults]boolForKey:@"NotFirstLaunch"]==YES)) {
       // [self.hints setFrame:CGRectMake(0, 67, self.collection.frame.size.width, self.collection.frame.size.height-107)];
        [self.bottomBar setBarStyle:UIBarStyleBlackOpaque];
       // [self.collection addSubview:self.hints];
    }
    UINib *cellNib = [UINib nibWithNibName:@"PictureCell" bundle:nil];
    [self.collection registerNib:cellNib forCellWithReuseIdentifier:@"PictureCell"];
    [self.collection.collectionViewLayout setItemSize:CGSizeMake(currentThumbSize, currentThumbSize)];
    currentPictures = [NSMutableArray new];
    [super viewDidLoad];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)[[UIApplication sharedApplication]setStatusBarHidden:true];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadPics];

}

- (void)settingsDidChange {
    [self loadPics];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.bottomBar setBarStyle:UIBarStyleBlackTranslucent];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)serverChoose:(id)sender {
       UIActionSheet*ac= [[UIActionSheet alloc]init];
    ac.title= [NSString stringWithFormat:@"Active: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]];
    [ac setDelegate:self];
    for (NSString*serv in (NSArray*)[[NSUserDefaults standardUserDefaults]objectForKey:@"allservers"]) {
        [ac addButtonWithTitle:serv];
    
    }
    ac.destructiveButtonIndex = [ac addButtonWithTitle:@"Edit servers"];
    ac.cancelButtonIndex = [ac addButtonWithTitle:@"Cancel"];
    [ac setTag:1999];
    [ac showFromBarButtonItem:sender animated:true];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 1999 && (buttonIndex != actionSheet.cancelButtonIndex)) {
        if(buttonIndex != actionSheet.destructiveButtonIndex) {
            [[NSUserDefaults standardUserDefaults]setObject:[actionSheet buttonTitleAtIndex:buttonIndex] forKey:@"Server"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self loadPics];
        } else {
            GBMServerList*ass = [[GBMServerList alloc]init];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [ass setModalPresentationStyle:UIModalPresentationFormSheet  ];
                [ass setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            }
            
            [self presentViewController:ass animated:true completion:nil];
        }
    }
   /* if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"I DON'T agree"]) {
        [self.collection setDelegate:nil];
        [self.collection setDataSource:nil];
        [[[UIActionSheet alloc]initWithTitle:@"Sorry, this way you cannot use this application." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]showInView:self.view];
    }*/
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"I agree"]) {
        //a = [[UIActionSheet alloc]initWithTitle:@"Thanks for using GBBrowser mobile!\n\nTo dismiss the hint, tap it once, it will not appear again (as well as these messages)" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        //[a retain];
        //[a showInView:self.view];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotFirstLaunch"];
        //[self performSelector:@selector(_welcomed) withObject:nil afterDelay:1];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   /* if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"I agree"]) {
          [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotFirstLaunch"];
    }
    if ([[alertView buttonTitleAtIndex:buttonIndex]isEqualToString:@"I DON'T agree"]) {
        [[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"You cannot use the application then" delegate:self cancelButtonTitle:nil otherButtonTitles:nil]show];
    }*/
}
-(void)_welcomed {
    [a dismissWithClickedButtonIndex:111 animated:TRUE];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PictureCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *picture = (UIImageView *)[cell viewWithTag:100];
    GBMPicture * data = (GBMPicture*)[currentPictures objectAtIndex:indexPath.row];
    [picture setImage:[data getThumbnailImage]];
    [data setDelegate:picture];
    [picture setContentMode:UIViewContentModeScaleAspectFit];
    return cell;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return currentPictures.count;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray*samples = [NSMutableArray new];
    for (GBMPicture*pic in currentPictures) {
        MyPhoto*p = [[MyPhoto alloc]initWithImageURL:pic.sampleURL boardLink:pic.fullURL.absoluteString tags:pic.tags];//[NSString stringWithFormat:@"http://%@/index.php?page=post&s=view&id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"],pic.ident]];
        [samples addObject:p];
    }
   
    
	MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:samples];
    
	EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source pid:indexPath.row];
	photoController.contentSizeForViewInPopover = CGSizeMake(480.0f, 480.0f);
   
	[source release];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoController];
	[self presentViewController:navController animated:true completion:nil];
	[photoController release];
	[navController release];

    return NO;
}
- (void)dealloc {
    [_collection release];
    [_search release];
    [_disableView release];
    [_countoftotal release];
    [_hints release];
    [_bottomBar release];
    [super dealloc];
}
- (IBAction)loadMore:(id)sender {
    self.countoftotal.title=@"Loading...";
    didLoadSecondTime=false;
    [self performSelector:@selector(loadMorePics) withObject:nil afterDelay:0.1];
}

- (IBAction)about:(id)sender {
    GBMAboutViewController*a=[[GBMAboutViewController alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [a setModalPresentationStyle:UIModalPresentationFormSheet];
    } else {
        [a setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    }
    [a setDelegate:self];
    
    [self presentViewController:a animated:true completion:nil];
}

- (IBAction)hideHints:(id)sender {
    [UIView beginAnimations:@"FadeOut" context:nil];
    [UIView setAnimationDuration:0.4];
    self.hints.alpha = 0;
        [UIView commitAnimations];
    
    [self.hints performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
  
}
- (void)viewDidUnload {
    [self setBottomBar:nil];
    [super viewDidUnload];
}
@end
