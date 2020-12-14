//
//  ABLogLevel.h
//  AirBridge
//
//  Created by WOF on 21/05/2019.
//  Copyright © 2019 ab180. All rights reserved.
//

#ifndef ABLogLevel_h
#define ABLogLevel_h

typedef NS_ENUM(NSUInteger, ABLogLevel) {
    AB_LOG_NO = 0,
    AB_LOG_CRASH,
    AB_LOG_CRITICAL,
    AB_LOG_WARNING,
    AB_LOG_INFO,
    AB_LOG_DEBUG,
    AB_LOG_ALL,
};

#endif /* ABLogLevel_h */
