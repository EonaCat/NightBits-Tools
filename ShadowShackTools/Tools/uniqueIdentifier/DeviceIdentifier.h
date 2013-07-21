//
//  DeviceIdentifier.h
//  Created by NightBits
//  Copyright 2013 NightBits. All rights reserved.
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
