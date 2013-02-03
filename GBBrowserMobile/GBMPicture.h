//
//  GBMPicture.h
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GBMPictureDelegate;
@interface GBMPicture : NSObject
{
    UIImage* thumbnailImage;
    UIImage* sampleImage;
    NSURL *sampleURL;
    NSURL *fullURL;
    NSURL *thumbnailURL;
    NSArray *tags;
    NSString * ident;
}
@property (nonatomic,assign) id<GBMPictureDelegate> delegate;
-(UIImage*)getThumbnailImage;
-(UIImage*)getSampleImage;
-(UIImage*)getFullImage;
@property (nonatomic,retain) NSURL *sampleURL;
@property (nonatomic,retain)NSURL *fullURL;
@property (nonatomic,retain)NSURL *thumbnailURL;
@property (nonatomic,retain) NSArray *tags;
@property (nonatomic,retain)NSString * ident;
@end

@protocol GBMPictureDelegate <NSObject>
-(void)picture:(GBMPicture*)obj thumbnailBecameAvailable:(UIImage*)newImage;
-(void)picture:(GBMPicture*)obj sampleBecameAvailable:(UIImage*)newImage;

@end