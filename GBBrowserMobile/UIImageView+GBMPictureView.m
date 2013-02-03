//
//  UIImageView+GBMPictureView.m
//  GBBrowserMobile
//
//  Created by Vladislav Korotnev on 2/3/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "UIImageView+GBMPictureView.h"

@implementation UIImageView (GBMPictureView)
-(void)picture:(GBMPicture*)obj thumbnailBecameAvailable:(UIImage*)newImage {
    [self setImage:newImage];
}
@end
