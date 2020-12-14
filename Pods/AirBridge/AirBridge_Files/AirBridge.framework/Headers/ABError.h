//
//  ABError.h
//  AirBridge
//
//  Created by WOF on 2019/11/11.
//  Copyright © 2019 ab180. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABError : NSObject

- (instancetype) initWithCode:(uint64_t)code message:(NSString*)message;

@property (nonatomic, readonly) uint64_t code;
@property (nonatomic, readonly) NSString* message;

@end

NS_ASSUME_NONNULL_END
