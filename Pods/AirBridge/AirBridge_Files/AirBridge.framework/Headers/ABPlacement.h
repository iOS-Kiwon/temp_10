//
//  ABPlacement.h
//  AirBridge
//
//  Created by WOF on 24/07/2019.
//  Copyright © 2019 ab180. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABPlacement : NSObject

- (void) click:(NSString*)trackingLink;
- (void) click:(NSString*)trackingLink deeplink:(nullable NSString*)deeplink;
- (void) click:(NSString*)trackingLink deeplink:(nullable NSString*)deeplink fallback:(nullable NSString*)fallback;
- (void) impression:(NSString*)trackingLink;

@end

NS_ASSUME_NONNULL_END
