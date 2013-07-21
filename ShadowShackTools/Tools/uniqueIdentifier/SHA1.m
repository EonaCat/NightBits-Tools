//
//  SHA1.m
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
//

#import "SHA1.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(SHA1)

-(NSString*) stringFromSHA1:(NSString*)input
{
    const char *charString = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:charString length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
@end