//
//  ABNetworkingTypedef.h
//  AirBridge
//
//  Created by WOF on 18/12/2018.
//  Copyright © 2018 TehranSlippers. All rights reserved.
//

#ifndef ABNetworkingTypedef_h
#define ABNetworkingTypedef_h

typedef void (^ABNetworkingSuccessBlock)(id json);
typedef void (^ABNetworkingFailBlock)(NSError *error, id json);

typedef NS_ENUM(NSUInteger, ABNetworkingType) {
    ABNETWORKING_TYPE_GET,
    ABNETWORKING_TYPE_POST
};

#endif /* ABNetworkingTypedef_h */
