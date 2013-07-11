//
//  DeviceIdentifier.h
//  Created by ShadowShack
//  Copyright 2013 ShadowShack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice (IdentifierAddition)

// Generate a sha1 hash of your MAC address with your bundle app identifier
- (NSString*) appIdentifier;

// Generate a sha1 hash of your MAC address
- (NSString*) deviceIdentifier;

// Get the MAC address
- (NSString*) macAddress;

@end
