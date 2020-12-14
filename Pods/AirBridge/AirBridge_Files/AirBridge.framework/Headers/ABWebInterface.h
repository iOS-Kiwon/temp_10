//
//  ABWebInterface.h
//  AirBridge
//
//  Created by WOF on 2020/05/18.
//  Copyright © 2020 ab180. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Webkit/Webkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABWebInterface : NSObject

- (void) injectTo:(WKUserContentController*)controller
     withWebToken:(NSString*)webToken;

@end

NS_ASSUME_NONNULL_END
