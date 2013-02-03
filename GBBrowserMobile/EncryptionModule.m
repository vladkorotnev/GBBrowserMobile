//
//  EncryptionModule.m
//  BasicCrypter
//
//  Created by Vladislav on 03.08.11.
//  Copyright 2011 Tigr@Soft. All rights reserved.
//

#import "EncryptionModule.h"


@implementation EncryptionModule

-(NSString *)decryptString:(NSString *)string {
    NSString *result = @"";
    if ([string length]>0) {
    int i;
    for (i=0; i<=[string length]-1; i++) {
        int characterno;
        characterno = [string characterAtIndex:i];
        characterno = characterno - 1;
        char *Newchar = (char *) characterno;
        NSString *buf = [ NSString stringWithFormat:@"%c",Newchar];
        result = [result stringByAppendingString:buf];
        //[buf release];
    }
    }
    return result;
}

-(NSString *)decryptString:(NSString *)string withOffset:(int)offset {
    NSString *result = @"";
    if ([string length]>0) {
    int i;
    for (i=0; i<=[string length]-1; i++) {
        int characterno;
        characterno = [string characterAtIndex:i];
        characterno = characterno - offset;
        char *Newchar = (char *) characterno;
        NSString *buf = [ NSString stringWithFormat:@"%c",Newchar];
        result = [result stringByAppendingString:buf];
        //[buf release];
    }
    }
    return result;
}

-(NSString *)encryptString:(NSString *)string {
    NSString *result = @"";
    if ([string length]>0) {
    int i;
    for (i=0; i<=[string length]-1; i++) {
        int characterno;
        characterno = [string characterAtIndex:i];
        characterno = characterno + 1;
        char *Newchar = (char *) characterno;
        NSString *buf = [ NSString stringWithFormat:@"%c",Newchar];
        result = [result stringByAppendingString:buf];
        //[buf release];
    }
    }
    return result;
}

-(NSString *) encryptString:(NSString *)string withOffset:(int)offset    {
        NSString *result = @"";
    if ([string length]>0) {
    int i;
    for (i=0; i<=[string length]-1; i++) {
        int characterno;
        characterno = [string characterAtIndex:i];
        characterno = characterno + offset;
        char *Newchar = (char *) characterno;

        NSString *buf = [ NSString stringWithFormat:@"%c",Newchar];
        result = [result stringByAppendingString:buf];
        //[buf release];
    }
    }
    return result;
}
@end
