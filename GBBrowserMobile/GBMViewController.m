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

- (void) loadPics {
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"Trying to load");
    currentPid = 0;

    [currentPictures removeAllObjects];
    [self.collection reloadData];
    NSString * url = [NSString stringWithFormat:@"http://%@//index.php?page=dapi&s=post&q=index&pid=%i",[[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]lowercaseString],currentPid ];
    if(isInSearch) {
        
        url = [NSString stringWithFormat:@"%@&tags=%@",url,curSearchRequest];
    }
    NSURL * t = [NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self parseDocumentWithURL:t];
}


-(BOOL)parseDocumentWithURL:(NSURL *)url {
    if (url == nil)
    {NSLog(@"Nil url");
        return NO;}
    NSLog(@"URL %@",url.absoluteString);
    // this is the parsing machine
    NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    // this class will handle the events
    [xmlparser setDelegate:self];
    [xmlparser setShouldResolveExternalEntities:NO];
    NSLog(@"Starting parse");
    // now parse the document
    BOOL ok = [xmlparser parse];
    if (ok == NO)
        NSLog(@"Error");
    else
        NSLog(@"OK");
    
    
    return ok;
}


-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"Start");
   
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"End");
    self.countoftotal.title = [NSString stringWithFormat:@"%i of %i",currentPictures.count,totalPosts];
   
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

    currentPid = currentPid + 1;
    if (currentPid * 100 >= totalPosts) {
        NSLog(@"End!");
        return;
    }
    

    NSString * url = [NSString stringWithFormat:@"http://%@//index.php?page=dapi&s=post&q=index&pid=%i",[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"],currentPid ];
    if(isInSearch) {
        
        url = [NSString stringWithFormat:@"%@&tags=%@",url,curSearchRequest];
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
         [[NSUserDefaults standardUserDefaults]setObject:@"Safebooru.org" forKey:@"Server"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    if (!([[NSUserDefaults standardUserDefaults]boolForKey:@"NotFirstLaunch"]==YES)) {
        [self.hints setFrame:CGRectMake(0, 0, self.collection.frame.size.width, self.collection.frame.size.height)];
        [self.collection addSubview:self.hints];
    }
    UINib *cellNib = [UINib nibWithNibName:@"PictureCell" bundle:nil];
    [self.collection registerNib:cellNib forCellWithReuseIdentifier:@"PictureCell"];
    [self.collection.collectionViewLayout setItemSize:CGSizeMake(currentThumbSize, currentThumbSize)];
    currentPictures = [NSMutableArray new];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadPics];
}
-(void)viewDidAppear:(BOOL)animated {
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)serverChoose:(id)sender {
       UIActionSheet*a= [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"Active: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"]] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gelbooru.com",@"Safebooru.org",@"Xbooru.com",nil];
    [a setTag:1999];
    [a showFromBarButtonItem:sender animated:true];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 1999 && (buttonIndex != actionSheet.cancelButtonIndex)) {
        [[NSUserDefaults standardUserDefaults]setObject:[actionSheet buttonTitleAtIndex:buttonIndex] forKey:@"Server"];
         [[NSUserDefaults standardUserDefaults]synchronize];
        [self loadPics];
    }
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
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return currentPictures.count;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Select");
    NSMutableArray*samples = [NSMutableArray new];
    for (GBMPicture*pic in currentPictures) {
        MyPhoto*p = [[MyPhoto alloc]initWithImageURL:pic.sampleURL boardLink:[NSString stringWithFormat:@"http://%@/index.php?page=post&s=view&id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Server"],pic.ident]];
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
    [super dealloc];
}
- (IBAction)loadMore:(id)sender {
    [self performSelector:@selector(loadMorePics) withObject:nil afterDelay:0.1];
}

- (IBAction)about:(id)sender {
    [self presentViewController:[[GBMAbout alloc]init] animated:true completion:nil];
}

- (IBAction)hideHints:(id)sender {
    [UIView beginAnimations:@"FadeOut" context:nil];
    [UIView setAnimationDuration:0.4];
    self.hints.alpha = 0;
    [UIView commitAnimations];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"NotFirstLaunch"];
    [self.hints performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
}
@end
