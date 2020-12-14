//
//  ABDeeplink.h
//  AirBridge
//
//  Created by WOF on 06/09/2019.
//  Copyright © 2019 ab180. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABError.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABDeeplink : NSObject

/* handle deeplink */
- (void) handleUniversalLink:(NSURL*)link;
- (void) handleUniversalLink:(NSURL*)link
                      onDone:(nullable void (^)(NSString* deeplink))onDone;
- (void) handleUniversalLink:(NSURL*)link
                      onDone:(nullable void (^)(NSString* deeplink))onDone
                     onError:(nullable void (^)(ABError* error))onError;

- (void) handleURLSchemeDeeplink:(NSURL*)url;
- (void) handleURLSchemeDeeplink:(NSURL*)url
                          onDone:(nullable void (^)(NSString* deeplink))onDone;

/* set callback */
- (void) setDeeplinkCallback:(void (^)(NSString* deeplink))callback;
- (void) setDeferredDeeplinkCallback:(void (^)(NSString* deeplink))callback;

/* set option */
- (void) setHandleTrackingLinkTimeout:(uint64_t)timeout;

@end

NS_ASSUME_NONNULL_END
