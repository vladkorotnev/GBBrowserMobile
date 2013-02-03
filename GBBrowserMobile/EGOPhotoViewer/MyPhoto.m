//
//  MyPhoto.m
//  EGOPhotoViewerDemo_iPad
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyPhoto.h"

@implementation MyPhoto
@synthesize boardlink;
@synthesize URL=_URL;
@synthesize caption=_caption;
@synthesize image=_image;
@synthesize size=_size;
@synthesize failed=_failed;

- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName image:(UIImage*)aImage{
	
	if (self = [super init]) {
	
		_URL=[aURL retain];
		_caption=[aName retain];
		_image=[aImage retain];
		
	}
	
	return self;
}

- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName{
	return [self initWithImageURL:aURL name:aName image:nil];
}

- (id)initWithImageURL:(NSURL*)aURL{
	return [self initWithImageURL:aURL name:nil image:nil];
}

- (id)initWithImage:(UIImage*)aImage{
	return [self initWithImageURL:nil name:nil image:aImage];
}
- (id)initWithImageURL:(NSURL*)aURL boardLink:(NSString*)link tags:(NSArray*)tags {
    [self initWithImageURL:aURL name:nil image:nil];
    [self setBoardlink:link];
    [self.boardlink retain];
    NSString*t= @"";
    for (NSString*tag in tags) {
        t = [t stringByAppendingFormat:@" %@",tag];
    }
    _caption = t;
    [_caption retain];
    return self;
}
- (void)dealloc{
	
	[_URL release], _URL=nil;
	[_image release], _image=nil;
	[_caption release], _caption=nil;
	
	[super dealloc];
}


@end
