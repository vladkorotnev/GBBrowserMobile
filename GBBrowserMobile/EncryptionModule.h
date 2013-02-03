//
//  EncryptionModule.h
//  BasicCrypter
//
//  Created by Vladislav on 03.08.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EncryptionModule : NSObject {
    
}
-(NSString *)encryptString:(NSString *)string;
-(NSString *)encryptString:(NSString *)string withOffset:(int)offset;

-(NSString *)decryptString:(NSString *)string;
-(NSString *)decryptString:(NSString *)string withOffset:(int)offset;
@end
