//
//  ABSetting.h
//  AirBridge
//
//  Created by WOF on 18/06/2019.
//  Copyright © 2019 ab180. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABUser.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  class that save SDK
 */
@interface ABState : NSObject

/* User */
- (void)setUser:(ABUser*) user;

- (void)setUserID:(NSString*)ID;
- (void)setUserEmail:(NSString*)email;
- (void)setUserPhone:(NSString*)phone;
- (void)setUserAlias:(NSDictionary<NSString*, NSString*>*)alias;
- (void)addUserAliasWithKey:(NSString*)key value:(NSString*)value;
- (void)setUserAttributes:(NSDictionary<NSString*, NSObject*>*)attributes;
- (void)addUserAttributesWithKey:(NSString*)key value:(NSObject*)value;

/* Device */
- (void)setDeviceAlias:(NSDictionary<NSString*, NSString*>*)alias;
- (void)addDeviceAliasWithKey:(NSString*)key value:(NSString*)value;

/* SDK Development Platform */
- (void) setSDKDevelopmentPlatform:(NSString*)platform;

@end

NS_ASSUME_NONNULL_END
