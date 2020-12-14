//
//  WebHTMLCache.m
//  GSSHOP
//
//  Created by nami0342 on 30/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "WebHTMLCache.h"
#import "FileUtil.h"


static WebHTMLCache *_instance = nil;        // Singleton 변수

@implementation WebHTMLCache

#define MEMORY_CACHE_NAME_URL            @"com.gsshop.webhtml.cache"
#define MEMORY_CACHE_MAX_SIZE_URL        104857600   // 100Mb
#define MEMORY_CACHE_EXPIREDATE          300 // 60 * 5

+ (WebHTMLCache *)sharedInstance
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
            [_instance setName:MEMORY_CACHE_NAME_URL];
            [_instance setTotalCostLimit:MEMORY_CACHE_MAX_SIZE_URL];
            [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(deleteAllMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        }
    }
    
    return _instance;
}




@end
