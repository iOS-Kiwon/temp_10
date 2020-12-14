//
//  WebHTMLCache.h
//  GSSHOP
//
//  Created by nami0342 on 30/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlSessionCache.h"

@interface WebHTMLCache : UrlSessionCache
+ (WebHTMLCache *)sharedInstance;            // nami0342 - Singleton 함수

@end
