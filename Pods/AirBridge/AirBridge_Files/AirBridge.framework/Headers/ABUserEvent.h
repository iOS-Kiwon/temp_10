//
//  ABUserEvent.h
//  AirBridge
//
//  Created by donutt on 2017. 8. 9..
//  Copyright © 2017년 TehranSlippers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABInAppEvent.h"

#import "ABUser.h"

@interface ABUserEvent : ABInAppEvent

- (id)initWithUser:(ABUser *)user;

- (void)sendSignup;
- (void)sendSignin;
- (void)expireUser;

@end
