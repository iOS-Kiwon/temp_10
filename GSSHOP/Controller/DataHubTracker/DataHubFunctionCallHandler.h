//
//  DataHubFunctionCallHandler.h
//  GSSHOP
//
//  Created by gsshop on 2015. 6. 11..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

//google tagmanager기반

#import <Foundation/Foundation.h>
#import <GoogleTagManager/GoogleTagManager.h>
#import "APPDelegate.h"

extern NSString *const kMyTagFunctionName;

@interface DataHubFunctionCallHandler : NSObject<TAGCustomFunction>

@end
