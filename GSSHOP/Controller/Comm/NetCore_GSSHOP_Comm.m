//
//  NetCore_GSSHOP_Comm.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "NetCore_GSSHOP_Comm.h"
#import "UrlSessionCache.h"

//#import <Mocha/JSON.h>
#define IFEZ_URL(__C1__, __C2__) [NSString stringWithFormat:@"GetLocalpoiList/%@/%@", __C1__, __C2__]
//#define TIMEOUT_INTERVAL_REQUEST        5
//#define TIMEOUT_INTERVAL_RESPONSE       10

@implementation NetCore_GSSHOP_Comm



- (id) init
{
    self = [super init];
    
    return self;
}


//섹션별 화면 api 수신
-(NSURLSessionDataTask*) gsSECTIONUILISTURL:(NSString*)apiurl
                               isForceReload:(BOOL)isreload
                                onCompletion:(ResponseDicBlock) completionBlock
                                     onError:(MCNKErrorBlock) errorBlock{


    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_API_FINISH object:nil userInfo:nil];
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_API_FINISH object:nil userInfo:nil];
        });
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
    }];
    [dataTask resume];
    
    return dataTask;
}




//섹션별화면 APPLE JSON 용
-(NSURLSessionDataTask*) gsSECTIONUILISTURL_NativeJSON:(NSString*)apiurl
                                          isForceReload:(BOOL)isreload
                                           onCompletion:(ResponseDicBlock) completionBlock
                                                onError:(MCNKErrorBlock) errorBlock{
    
    __block NSData *data = nil;
    isreload = NO;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_API_FINISH object:nil userInfo:nil];
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_API_FINISH object:nil userInfo:nil];
        });
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
    }];
    [dataTask resume];
    
    return dataTask;
}





//
////TVC 생방송 셀 화면구성 api 수신
//-(nullable NSURLSessionDataTask*) gsTVCCELLINFOAPIURL:(NSString*)apiurl
//                                 onCompletion:(ResponseDicBlock) completionBlock
//                                      onError:(MCNKErrorBlock) errorBlock{
//
//
//    __block NSData *data = nil;
//
//    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
//    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//
//    // check url path
//    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
//    {
//        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
//    }
//    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
//
//    // Memory Cache 사용 여부 판단
//    if(isreload == NO)
//    {
//        data = [UrlSessionCache getDataWithKey:apiurl];
//
//        if(data != nil)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock([data JSONtoValue]);
//            });
//            return nil;
//        }
//    }
//
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
//    [request setHTTPMethod:@"GET"];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
//        data = taskData;
//
//        if(error != nil )
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                errorBlock(error);
//            });
//        }
//
//        // Save cache
//        [UrlSessionCache setData:data forKey:apiurl];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completionBlock([data JSONtoValue]);
//        });
//
//
//    }];
//    [dataTask resume];
//
//    return dataTask;
//
//}



//뱃지 정보 가져오기

-(NSURLSessionDataTask*) gsGETBADGEURL:(ResponseDicBlock) completionBlock
                                onError:(MCNKErrorBlock) errorBlock {
    
    
    NSString *apiurl = GSGETBADGEURL;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
      

        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}


//브랜드 리스트 수신
-(NSURLSessionDataTask*) gsBRANDLISTURL:(ResponseDicBlock) completionBlock
                                 onError:(MCNKErrorBlock) errorBlock{
    
    //
    NSString *apiurl = GSBRANDLISTURL;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
}




//핫키워드 수신
-(NSURLSessionDataTask*) gsHOTKEYWORDLISTURL:(NSString*) apiurl
                                 onCompletion:(ResponseDicBlock) completionBlock
                                      onError:(MCNKErrorBlock) errorBlock{
    
    //
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}




//검색프로모션 키워드링크 수신
-(NSURLSessionDataTask*) gsPROMOKEYWORDLISTURL:(ResponseDicBlock) completionBlock
                                        onError:(MCNKErrorBlock) errorBlock{
  
    //
    NSString *apiurl = GSPROMOKEYWORDLISTURL;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}





//AUTOMAKE 수신
-(NSURLSessionDataTask*) gsAUTOMAKELISTURL:(NSString*) apiurl
                               onCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock{
 //
//    NSString *apiurl = GSPROMOKEYWORDLISTURL;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;

    
}


//옵션정보체크 -deprecated 동기통신으로 전환
-(NSURLSessionDataTask*) gsOptionInfo:(ResponseDicBlock) completionBlock
                               onError:(MCNKErrorBlock) errorBlock {
    
    NSString *apiurl = GSOPTIONINFOURL;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}




//SKTELECOM 사용자 체크 - datafree toast관련
-(NSURLSessionDataTask*) gsSKTUserCheck:(ResponseDicBlock) completionBlock
                                 onError:(MCNKErrorBlock) errorBlock {

    NSString *apiurl = GSSKTUSERCHECKURL;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}


//토큰인증관련
//토큰로그인 https 사용
//new
// ssl YES 중요 !!!
-(NSURLSessionDataTask*) gsTOKENLOGINURL:(NSString*) uname
                                userpass : (NSString*) upass
                             simplelogin :(NSString*)slogin
                          snsAccessToken : (NSString *)snsAccessToken
                          snsRefreshToken : (NSString *)snsRefreshToken
                                 snsType : (NSString *)snsType
                                 loginType : (NSString *)loginType
                             onCompletion:(ResponseDicBlock) completionBlock
                                  onError:(MCNKErrorBlock) errorBlock {
    
    NSString *apiurl = GSUSERTOKENLOGINURL;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:DEVICEUUID forKey:@"deviceId"];
    [headerFields setValue:uname forKey:@"loginId"];
    [headerFields setValue:upass forKey:@"passwd"];
    [headerFields setValue:slogin forKey:@"easiLogin"];
    [headerFields setValue:snsAccessToken forKey:@"snsAccess"];
    [headerFields setValue:snsRefreshToken forKey:@"snsRefresh"];
    [headerFields setValue:snsType forKey:@"snsTyp"];
    [headerFields setValue:loginType forKey:@"loginTyp"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {
#if SM14 && !APPSTORE
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
#else
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];
#endif
        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        NSLog(@"%@ \r\n   %@\r\n %@", taskData, response, error);
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}






//신규 SNS 연동 2017.03.30
//SNS 연동 여부 확인
-(NSURLSessionDataTask*) gsSnsAccountCheck:(NSString*) custNo
                               onCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock{
   
    NSString *apiurl = GSUSERSNSCHECK;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:custNo forKey:@"custNo"];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {
#if SM14 && !APPSTORE
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
#else
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];
#endif
        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"POST"];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}




//SNS 연동 연결등록
-(NSURLSessionDataTask*) gsSnsAccountOpenCustNo:(NSString*) custNo
                                    snsType:(NSString*) snsTyp
                                    snsAccessToken:(NSString*) accessToken
                                    snsRefreshToken:(NSString*) refreshToken
                               onCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock{
 
    //
    NSString *apiurl = GSUSERSNSOPEN;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:custNo forKey:@"custNo"];
    [headerFields setValue:snsTyp forKey:@"snsTyp"];
    [headerFields setValue:accessToken forKey:@"snsAccess"];
    [headerFields setValue:refreshToken forKey:@"snsRefresh"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {
#if SM14 && !APPSTORE
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
#else
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];
#endif
        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        NSLog(@"%@ \r\n   %@\r\n %@", taskData, response, error);
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
}





//SNS 연동 해제
-(NSURLSessionDataTask*) gsSnsAccountClose:(NSString*) custNo
                                    snsType:(NSString*) snsTyp
                               onCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock{

    //
    NSString *apiurl = GSUSERSNSCLOSE;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:custNo forKey:@"custNo"];
    [headerFields setValue:snsTyp forKey:@"snsTyp"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {
#if SM14 && !APPSTORE
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
#else
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];
#endif
        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        NSLog(@"%@ \r\n   %@\r\n %@", taskData, response, error);
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
    
}





//로그아웃
-(NSURLSessionDataTask*) gsTOKENLOGOUTPROC: (NSString*) loginid
                                 serieskey : (NSString*) skey
                               onCompletion:(ResponseDicBlock) completionBlock
                                    onError:(MCNKErrorBlock) errorBlock {
  
    NSString *apiurl = GSUSERTOKENLOGOUTURL;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:DEVICEUUID forKey:@"deviceId"];
    [headerFields setValue:loginid forKey:@"loginId"];
    [headerFields setValue:skey forKey:@"serisKey"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {
#if SM14 && !APPSTORE
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
#else
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];
#endif
        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        NSLog(@"%@ \r\n   %@\r\n %@", taskData, response, error);
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
}





//인증
-(NSURLSessionDataTask*) gsTOKENAUTHURL:(NSString*) loginid
                              serieskey : (NSString*) skey
                               authtken : (NSString*) atoken
                                 snsTyp : (NSString*) snsTyp
                            onCompletion:(ResponseDicBlock) completionBlock
                                 onError:(MCNKErrorBlock) errorBlock{
   
    NSString *apiurl = GSUSERTOKENAUTHURL;
//    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:DEVICEUUID forKey:@"deviceId"];
    [headerFields setValue:loginid forKey:@"loginId"];
    [headerFields setValue:skey forKey:@"serisKey"];
    [headerFields setValue:atoken forKey:@"certToken"];
    [headerFields setValue:snsTyp forKey:@"snsTyp"];        //2017.03.30 SNS로그인 추가
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {
#if SM14 && !APPSTORE
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
#else
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];
#endif
        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
//    if(isreload == NO)
//    {
//        data = [UrlSessionCache getDataWithKey:apiurl];
//
//        if(data != nil)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock([data JSONtoValue]);
//            });
//            return nil;
//        }
//    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        NSLog(@"%@ \r\n   %@\r\n %@", taskData, response, error);
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if( error.code == -1001) {
                    NSLog(@"1001 발생");
                }
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
//        if(isreload == NO)
//        {
//            if(NCO([data JSONtoValue]) == YES)
//            {
//                [UrlSessionCache setData:data forKey:apiurl];
//            }
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
}


//
////20160422 parksegun 인증 재시도용
-(NSURLSessionDataTask*) gsTOKENAUTHURL_Retry:(NSString*) loginid
                              serieskey : (NSString*) skey
                               authtken : (NSString*) atoken
                                 snsTyp : (NSString*) snsTyp
                            onCompletion:(ResponseDicBlock) completionBlock
                                 onError:(MCNKErrorBlock) errorBlock{

    NSString *apiurl = GSUSERTOKENAUTHURL;
//    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:DEVICEUUID forKey:@"deviceId"];
    [headerFields setValue:loginid forKey:@"loginId"];
    [headerFields setValue:skey forKey:@"serisKey"];
    [headerFields setValue:atoken forKey:@"certToken"];
    [headerFields setValue:snsTyp forKey:@"snsTyp"];            //2017.03.30 SNS로그인 추가
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {
#if SM14 && !APPSTORE
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
#else
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];
#endif
        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
//    if(isreload == NO)
//    {
//        data = [UrlSessionCache getDataWithKey:apiurl];
//
//        if(data != nil)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock([data JSONtoValue]);
//            });
//            return nil;
//        }
//    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        NSLog(@"%@ \r\n   %@\r\n %@", taskData, response, error);
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
//        if(isreload == NO)
//        {
//            if(NCO([data JSONtoValue]) == YES)
//            {
//                [UrlSessionCache setData:data forKey:apiurl];
//            }
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;


}





//20180314 parksegun 회원가입후 자동로그인 처리
-(NSURLSessionDataTask*) gsREGAUTOAUTHURL:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock {

    NSString *apiurl = GSAUTOAUTHCHANGE;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:DEVICEUUID forKey:@"deviceId"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1 && [[apiurl componentsSeparatedByString:@"https"] count] == 1)
    {

        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI_HTTPS, apiurl];

        
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    NSError *error;
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:headerFields options:0 error:&error]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        NSLog(@"%@ \r\n   %@\r\n %@", taskData, response, error);
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
    
    
}






//사이드 매뉴용 네비게이션 , 카테고리 호출
-(NSURLSessionDataTask*) gsLeftNavigation:(NSString*)apiurl
                               isForceReload:(BOOL)isreload
                                onCompletion:(ResponseDicBlock) completionBlock
                                     onError:(MCNKErrorBlock) errorBlock{
 
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
        
        // Save cache
        if(NCO([data JSONtoValue]) == YES)
        {
            [UrlSessionCache setData:data forKey:apiurl];
        }
    }];
    [dataTask resume];
    
    return dataTask;
}





//마이쇼핑 알림함 리얼맴버쉽
-(NSURLSessionDataTask*) gsMyShopRealMemberCustNo:(NSString*)strCustNo
                                     isForceReload:(BOOL)isreload
                                onCompletion:(ResponseDicBlock) completionBlock
                                     onError:(MCNKErrorBlock) errorBlock{

    //
    NSString *apiurl = GS_MYSHOP_PERSONINFO;
    isreload = YES;
    __block NSData *data = nil;
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:strCustNo forKey:@"catvId"];
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    [request setAllHTTPHeaderFields:headerFields];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
}



- (void)SwitchSSLPort {
    
   
}


// !!!!!! 
-(void)setDefaultCommPort {
    
    if (([SERVERMAINDOMAIN isEqualToString:@"m.gsshop.com"] == YES)  || ([SERVERMAINDOMAIN isEqualToString:@"app.gsshop.com"] == YES)){
        
    }else {
//        [self setPortNumber:80];
    }
    
    
}







//APP wiselog 호출

-(NSURLSessionDataTask*) gsAPPWISELOGREQPROC: (NSString*) apiurl
                                 onCompletion:(ResponseDicBlock) completionBlock
                                      onError:(MCNKErrorBlock) errorBlock {

    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
    }];
    [dataTask resume];
    
    return dataTask;
    
    
}




// 메인 그룹매장 화면구조 api 수신
-(NSURLSessionDataTask*) gsGROUPUILISTURL:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock{
    
    ///
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    
    NSString *apiurl;
    NSLog(@"API_ADD_OPEN_DATE length = %ld",(long)[NCS([[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_OPEN_DATE"]) length]);
    
    if ( ([NCS([[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_OPEN_DATE"]) length] > 0) && ([Mocha_Util strContain:@"openDate" srcstring:GROUPUILISTURL] == FALSE)) {
        apiurl = [NSString stringWithFormat:@"%@%@", GROUPUILISTURL, [[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_OPEN_DATE"]];
        
        NSLog(@"API_ADD_OPEN_DATE = %@",NCS([[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_OPEN_DATE"]));
        
    }else{
        apiurl = [NSString stringWithFormat:@"%@", GROUPUILISTURL];
    }
    
    
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
//    if(isreload == NO)
//    {
//        data = [UrlSessionCache getDataWithKey:apiurl];
//
//        if(data != nil)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                completionBlock([data JSONtoValue]);
//            });
//            return nil;
//        }
//    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            [self gsGROUPUILISTURL_forRetry:^(NSDictionary *result){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock( result);
                });
                
                
            } onError:^(NSError* error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorBlock(error);
                });
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(NCO([data JSONtoValue]) == NO)
            {
                data = [UrlSessionCache getDataWithKey:apiurl];
                
                if(data != nil)
                {
                    completionBlock([data JSONtoValue]);
                }else{
                    errorBlock(error);
                    return;
                }
            }
            else
            {
                completionBlock([data JSONtoValue]);
            }
        });
        
        
//        // Save cache
//        if(NCO([data JSONtoValue]) == YES)
//        {
//            [UrlSessionCache setData:data forKey:apiurl isFile:YES];
//        }
        
        
        
    }];
    [dataTask resume];
    
    return dataTask;
}




//
////20160217 parksegun 재시도용
-(NSURLSessionDataTask*) gsGROUPUILISTURL_forRetry:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock{

    __block NSData *data = nil;
    BOOL isreload = YES;
    
    NSString *apiurl;
    if ( ([NCS([[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_OPEN_DATE"]) length] > 0) && ([Mocha_Util strContain:@"openDate" srcstring:GROUPUILISTURL] == FALSE)) {
        apiurl = [NSString stringWithFormat:@"%@%@", GROUPUILISTURL, [[NSUserDefaults standardUserDefaults] objectForKey:@"API_ADD_OPEN_DATE"]];
    }else{
        apiurl = [NSString stringWithFormat:@"%@", GROUPUILISTURL];
    }
    
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];
        
        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
        
        
    }];
    [dataTask resume];
    
    return dataTask;
    
    
}



//
//// 그룹매장 섹션별 화면 api 수신
//-(NSURLSessionDataTask*) gsGROUPSECTIONUILISTURL:(NSString*)apiurl
//                                    isForceReload:(BOOL)isreload
//                                     onCompletion:(ResponseDicBlock) completionBlock
//                                          onError:(MCNKErrorBlock) errorBlock{
//
//
//
//    MochaNetworkOperation *op = [self operationWithPath:apiurl
//                                                 params:nil
//                                             httpMethod:@"GET"
//                                            sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
//
//    [self procqueueOperation:op forceReload:isreload];
//    [op onCompletion:^(MochaNetworkOperation *completedOperation)
//     {
//         // the completionBlock will be called twice.
//         // if you are interested only in new values, move that code within the else block
//
//         if([completedOperation isCachedResponse]) {
//             NSLog(@"GROUPSECTIONUILISTURL Data from cache %@", [completedOperation responseJSON]);
//         }
//         else {
//             NSLog(@"GROUPSECTIONUILISTURL Data from server %@", [completedOperation responseString]);
//         }
//
//
//         completionBlock( [[completedOperation responseData] JSONtoValue] );
//
//     }onError:^(NSError* error) {
//
//         NSLog(@"NET_ERROR - gsGROUPSECTIONUILISTURL error !!!!!!!!  %@", [error localizedDescription]);
//
//         errorBlock(error);
//     }];
//
//    return op;
//}




//
//// 필터 섹션 페이징별 컨텐츠 요청 API
//-(NSURLSessionDataTask*) gsSECTIONCONTENTSPAGINGLISTURL:(NSString*)apiurl
//                                           isForceReload:(BOOL)isreload
//                                            onCompletion:(ResponseDicBlock) completionBlock
//                                                 onError:(MCNKErrorBlock) errorBlock{
//
//
//
//    MochaNetworkOperation *op = [self operationWithPath:apiurl
//                                                 params:nil
//                                             httpMethod:@"GET"
//                                            sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
//
//    [self procqueueOperation:op forceReload:isreload];
//    [op onCompletion:^(MochaNetworkOperation *completedOperation)
//     {
//
//         if([completedOperation isCachedResponse]) {
//             NSLog(@"gsSECTIONCONTENTSPAGINGLISTURL Data from cache %@", [completedOperation responseJSON]);
//         }
//         else {
//             NSLog(@"gsSECTIONCONTENTSPAGINGLISTURL Data from server %@", [completedOperation responseString]);
//         }
//
//
//         completionBlock(  [[completedOperation responseData] JSONtoValue] );
//
//     }onError:^(NSError* error) {
//
//         NSLog(@"NET_ERROR - gsSECTIONCONTENTSPAGINGLISTURL error !!!!!!!!  %@", [error localizedDescription]);
//
//         errorBlock(error);
//     }];
//
//    return op;
//}





//
// 나의 찜 상품 추가
-(NSURLSessionDataTask*) gsFAVORITEREGURL:(NSString*)prodCd
                              onCompletion:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock{
    
    NSString *apiurl = FAVORITEREGURL(prodCd);
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
}




//
//-(NSURLSessionDataTask*) gsIntroWithSystemOS:(NSString*)OS
//                          deviceHeight:(NSString *)height
//                           deviceWidth:(NSString *)width
//                         deviceDensity:(NSString *)density
//                          onCompletion:(ResponseDicBlock) completionBlock
//                               onError:(MCNKErrorBlock) errorBlock{
//
//
//    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
//    [headerFields setValue:OS forKey:@"os"];
//    [headerFields setValue:height forKey:@"h"];
//    [headerFields setValue:width forKey:@"w"];
//    [headerFields setValue:density forKey:@"density"];
//
//    //[headerFields setValue:@"20160401000000" forKey:@"openDate"];
//
//    MochaNetworkOperation *op = [self operationWithPath:GSINTROURL
//                                                 params:headerFields
//                                             httpMethod:@"GET"
//                                            sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
//
//    NSLog(@"opopop = %@",op);
//       [op setTimeoutInterval:3.0f];
//
//
//    [self procqueueOperation:op forceReload:YES];
//    [op onCompletion:^(MochaNetworkOperation *completedOperation)
//     {
//
//         NSLog(@"인트로 이미지 왔어????");
//
//         completionBlock(  [[completedOperation responseData] JSONtoValue] );
//
//     }onError:^(NSError* error) {
//
//         NSLog(@"NET_ERROR - gsFAVORITEREGURL error !!!!!!!!  %@", [error localizedDescription]);
//
//         errorBlock(error);
//     }];
//
//    return op;
//}





// 검색 AB TEST
-(NSURLSessionDataTask*) gsSearchABTest:(ResponseStrBlock)completionBlock onError:(MCNKErrorBlock) errorBlock{
    
    
    NSString *apiurl = ABTESTSEARCHVALUE;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
    
}





//TV편성표 매장 OnAir 정보 호출
-(NSURLSessionDataTask*) gsTVScheduleOnAirRequestOnCompletion:(ResponseDicBlock) completionBlock
                                   onError:(MCNKErrorBlock) errorBlock{
 
    
    NSString *apiurl = GS_TVSCHEDULE_LIVEINFO;
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([data JSONtoValue]);
        });
    }];
    [dataTask resume];
    
    return dataTask;
    
}

//단품 상단 네이티브
-(NSURLSessionDataTask*)gsProductTopNative:(NSString *)strNumber isPrd:(BOOL)isPrd OnCompletion:(ResponseDicBlock) completionBlock onError:(MCNKErrorBlock) errorBlock{
 
    
    NSString *apiurl = @"";
    
    if (isPrd) {
        apiurl = [NSString stringWithFormat:@"%@%@",PRODUCT_NATIVE_TOP,strNumber];
    }else{
        apiurl = [NSString stringWithFormat:@"%@%@",DEAL_NATIVE_TOP,strNumber];
    }
    
    BOOL isreload = YES;
    __block NSData *data = nil;
    
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = TIMEOUT_INTERVAL_REQUEST;
    config.timeoutIntervalForResource = TIMEOUT_INTERVAL_RESPONSE;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // check url path
    if([[apiurl componentsSeparatedByString:@"http"] count] == 1)
    {
        apiurl = [NSString stringWithFormat:@"%@/%@", SERVERURI, apiurl];
    }
    apiurl = [apiurl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    apiurl = [NSString stringWithFormat:@"%@&ver=%@",apiurl,PRODUCT_NATIVE_VERSION];
    
    // Memory Cache 사용 여부 판단
    if(isreload == NO)
    {
        data = [UrlSessionCache getDataWithKey:apiurl];

        if(data != nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([data JSONtoValue]);
            });
            return nil;
        }
    }
    
    NSLog(@"kiwon : WebPrd Native api url = %@",apiurl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiurl]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:TIMEOUT_INTERVAL_REQUEST];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        data = taskData;
        
        if(error != nil )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock(error);
            });
            return;
        }
        
        // api 결과코드가 200이 아니면 에러
        NSDictionary * resultDic = [data JSONtoValue];
        NSString *resultCode = NCS([resultDic objectForKey:@"resultCode"]);
        if([@"200" isEqualToString:resultCode] == NO ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *resultMsg = NCS([resultDic objectForKey:@"resultMessage"]);
                [ApplicationDelegate SendExceptionLog:error msg:resultMsg];
                errorBlock(error);
            });
            return ;
        }
        
        // Save cache
        if(isreload == NO)
        {
            if(NCO([data JSONtoValue]) == YES)
            {
                [UrlSessionCache setData:data forKey:apiurl];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(resultDic);
        });
        
        
    }];
    [dataTask resume];
    
    return dataTask;
    
}


//
////TV편성표 매장 OnAir 정보 호출
//-(NSURLSessionDataTask*) gsTVScheduleAlarmProcess:(NSString *)strProcess
//                                        alarmPrdId:(NSString *)strPrdId
//                                      alarmPrdName:(NSString *)strPrdName
//                                       alarmPeriod:(NSString *)strPeriod
//                                          alarmCnt:(NSString *)strCnt
//                                     isForceReload:(BOOL)isreload
//                               onCompletion:(ResponseDicBlock) completionBlock
//                                    onError:(MCNKErrorBlock) errorBlock{
//
//    NSString *strApiUrl = nil;
//
//    if ([NCS(strProcess) isEqualToString:TVS_ALARMINFO]) {
//        strApiUrl = GS_TVSCHEDULE_ALARMINFO;
//    }else if ([NCS(strProcess) isEqualToString:TVS_ALARMADD]) {
//        strApiUrl = GS_TVSCHEDULE_ALARMADD;
//    }else if ([NCS(strProcess) isEqualToString:TVS_ALARMDELETE]) {
//        strApiUrl = GS_TVSCHEDULE_ALARMDELETE;
//    }
//
//    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
//    [headerFields setValue:@"PRDID" forKey:@"type"];
//    [headerFields setValue:strPrdId forKey:@"prdId"];
//    [headerFields setValue:strPrdName forKey:@"prdName"];
//    [headerFields setValue:strPeriod forKey:@"period"];
//    [headerFields setValue:strCnt forKey:@"alarmCnt"];
//
//    MochaNetworkOperation *op = [self operationWithPath:strApiUrl
//                                                 params:headerFields
//                                             httpMethod:@"POST"
//                                                    ssl:NO
//                                            sloadertype:(MochaNetworkOperationLoadingType)MochaNetworkOperationLINormalExcute];
//
//    NSLog (@"허헛 121212121 %@",op );
//
//    [self procqueueOperation:op forceReload:isreload];
//    [op onCompletion:^(MochaNetworkOperation *completedOperation)
//     {
//
//         if(isreload==YES) { NSLog(@"강제로 새것"); } else { NSLog(@"캐시로 예전"); }
//
//         completionBlock(  [[completedOperation responseData] JSONtoValue] );
//
//     }onError:^(NSError* error) {
//
//         NSLog(@"NET_ERROR - gsTVScheduleAlarmProcess error !!!!!!!!  %@", [error localizedDescription]);
//
//         errorBlock(error);
//     }];
//
//
//
//    return op;
//}



@end
