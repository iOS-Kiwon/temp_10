//
//  ABData.h
//  AirBridge
//
//  Created by WOF on 28/02/2019.
//  Copyright © 2019 ab180. All rights reserved.
//

#ifndef ABData_h
#define ABData_h

#import <Foundation/Foundation.h>

@protocol ABData

@required
- (NSDictionary*)toDictionary;

@end

#endif /* ABData_h */
