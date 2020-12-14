//
//  ABSender.h
//  AirBridge
//
//  Created by WOF on 20/02/2019.
//  Copyright © 2019 TehranSlippers. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ABEventType) {
    AB_INSTALL_EVENT = 1,
    AB_DEEPLINK_INSTALL_EVENT,
    AB_OPEN_EVENT,
    AB_DEEPLINK_EVENT,
    AB_FOREGROUND_EVENT,
    AB_BACKGROUND_EVENT,
    AB_IN_APP_EVENT,
    AB_PUSH_TOKEN_EVENT
};

@interface ABEvent : NSObject

- (instancetype) __unavailable init;

// this should be removed and changed by ABCustomSender
// in SDK you should not use ABUserSender, use ABSDKSender
- (void)send;

@end

NS_ASSUME_NONNULL_END
