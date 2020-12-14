//
//  UrlSessionCache.m
//  GSSHOP
//
//  Created by nami0342 on 08/01/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "UrlSessionCache.h"


static UrlSessionCache *_instance = nil;        // Singleton 변수

@implementation UrlSessionCache

#define MEMORY_CACHE_NAME_URL            @"com.gsshop.memorycach.url"
#define MEMORY_CACHE_MAX_SIZE_URL        104857600   // 100Mb
#define MEMORY_CACHE_EXPIREDATE          300 // 60 * 5

+ (UrlSessionCache *)sharedInstance
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


// Set response data from sever sent.
+ (void) setData: (NSData *) dValue  forKey : (NSString *) strKey
{
    NSDate *dNow = [NSDate date];       // current time
    NSDictionary *dicDatas = [NSDictionary dictionaryWithObjectsAndKeys:dValue, @"data", dNow, @"date", nil];
    
    [[UrlSessionCache sharedInstance] setObject:dicDatas forKey:strKey];
}




// Get response data from local memory
+ (nullable NSData *) getDataWithKey : (NSString *) strKey
{
    NSDate *dNow = [NSDate date];
    NSDictionary *dicData = [[UrlSessionCache sharedInstance] objectForKey:strKey];
    
    if(dicData == nil)
    {
        return nil;
    }
    
    NSDate *dSaved = [dicData objectForKey:@"date"];
    
    if(dNow.timeIntervalSinceReferenceDate - dSaved.timeIntervalSinceReferenceDate > MEMORY_CACHE_EXPIREDATE)
    {
        [[UrlSessionCache sharedInstance] removeObjectForKey:strKey];
        return nil;
    }
    else
    {
        return [dicData objectForKey:@"data"];
    }
    
    
    return nil;
}




// Save to File : 강제로 파일로 저장
+ (void) setData: (NSData *) dValue  forKey : (NSString *) strKey isFile:(BOOL) isFile
{
    
    NSDate *dNow = [NSDate date];       // current time
    NSDictionary *dicDatas = [NSDictionary dictionaryWithObjectsAndKeys:dValue, @"data", dNow, @"date", nil];
    [dicDatas writeToFile:[_instance getLocalPath:strKey] atomically:YES];
}

// Load from file : 중요 정보 수신 실패 시 기존에 저장된 것을 응답하며, Expire date를 무시
+ (nullable NSData *) getDataWithKey : (NSString *) strKey isFile:(BOOL) isFile
{
    NSDictionary *dicData = [NSDictionary dictionaryWithContentsOfFile:[_instance getLocalPath:strKey]];

    return [dicData objectForKey:@"data"];
}


// Delete all memory.
- (void) deleteAllMemory
{
    [self removeAllObjects];
}


- (NSString *) getLocalPath : (NSString *) strKey
{
    NSString *strSHA256 = [[GSCryptoHelper sharedInstance]  sha1:strKey];
    
    //// Get cache folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = NCA(paths)?[paths objectAtIndex:0]:@"";
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"GSSHOPImages"];
    NSString *strFullPath = [NSString stringWithFormat:@"%@/%@", cacheDirectoryName, strSHA256];
    
    return strFullPath;
}

@end
