//
//  ABDeeplinkInstallEvent.h
//  AirBridge
//
//  Created by WOF on 06/03/2019.
//  Copyright © 2019 ab180. All rights reserved.
//

#import "ABEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABDeeplinkInstallEvent : ABEvent

- (instancetype)init;
- (void)setDeeplink:(NSString*)deeplink;
- (void)setAppleSearchAds:(NSDictionary*)appleSearchAds;

@end

NS_ASSUME_NONNULL_END
