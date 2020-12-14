//
//  ABRoutingTypedef.h
//  AirBridge
//
//  Created by WOF on 18/12/2018.
//  Copyright © 2018 TehranSlippers. All rights reserved.
//

#ifndef ABRoutingTypedef_h
#define ABRoutingTypedef_h

typedef void (^ABDeeplinkCallback) (NSString* URL, NSDictionary* parameters);
typedef void (^ABDeferredDeeplinkCallback) (NSString* URL, NSDictionary* parameters);

typedef void (^ABAutoRoutingCallback) (NSDictionary *params);

/* ABR-DEPRECATED */
typedef void (^ABDefaultRoutingCallback) (NSString *routing, NSDictionary *params, NSError *error) __deprecated;
typedef void (^ABDeferredLinkRoutingCallback) (NSString *url, NSDictionary *params, NSError *error) __deprecated;
typedef void (^abSimpleLinkRoutingCallback) (NSString *routing, NSDictionary *params, NSError *error) __deprecated;

#endif /* ABRoutingTypedef_h */
