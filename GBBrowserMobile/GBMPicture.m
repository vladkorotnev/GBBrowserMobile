//
//  GBMPicture.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "GBMPicture.h"

@implementation GBMPicture
-(void)_downloadThumbnail{
    thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.thumbnailURL]];
    [thumbnailImage retain];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self performSelectorOnMainThread:@selector(_delegateInformGotthumb) withObject:nil waitUntilDone:false];
}
-(void)_delegateInformGotthumb{
    if([self.delegate respondsToSelector:@selector(picture:thumbnailBecameAvailable:)])
        [self.delegate picture:self thumbnailBecameAvailable:thumbnailImage];
}
-(void)_downloadSample{
    
    sampleImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.thumbnailURL]];
    [sampleImage retain];
    if([self.delegate respondsToSelector:@selector(picture:sampleBecameAvailable::)])
        [self.delegate picture:self sampleBecameAvailable:sampleImage];
}
-(UIImage*)getThumbnailImage{
    if(!thumbnailImage){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [self performSelectorInBackground:@selector(_downloadThumbnail) withObject:nil];
        return [UIImage imageNamed:@"placehold.png"];
    }
        
    return thumbnailImage;
}
-(UIImage*)getSampleImage{
    if(!sampleImage)
        [self _downloadSample];
    return sampleImage;
}
-(UIImage*)getFullImage{
    return [[UIImage imageWithData:[NSData dataWithContentsOfURL:self.fullURL]]autorelease];
}
@end
