//
//  GSDataHubTracker.m
//  GSSHOP
//
//  Created by gsshop on 2015. 6. 15..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "GSDataHubTracker.h"
#import "AppDelegate.h"

@implementation GSDataHubTracker

@synthesize DHmediaType;

static GSDataHubTracker  *sharedGDHTracker = nil;

+ (GSDataHubTracker *)sharedInstance
{
    @synchronized([GSDataHubTracker class]) {
        if(sharedGDHTracker == nil) {
            sharedGDHTracker = [[self alloc] init];
            
        }
        return sharedGDHTracker;
    }
    return nil;
    
}
+ (id)alloc
{
    @synchronized([GSDataHubTracker class]) {
        sharedGDHTracker = [[super alloc] init];
        return sharedGDHTracker;
    }
    return nil;
}
- (id)init
{
    @try {
        if (sharedGDHTracker == nil) {
            self.DHmediaType = nil;
            return self;
        }
        self = [super init];
    }
    @catch (NSException *exception) {
        NSLog(@"sharedGDHTracker init : %@", exception);
    }
    return self;
}


- (void)NeoCallGTMWithReqURL:(NSString*)arg1 str2:(NSString*)arg2 str3:(NSString*)arg3 {

    {
        
        NSLog(@"NEOGTM DATAHUBCALL %@ , %@ , %@",arg1,arg2,arg3);
        
        NSString * apiUrl = nil;
        
        
        //기본포멧 20150930 style ex)검색
        //http://gtm.gsshop.com/mgs/app/4020103?pcid=pcid&catvid=catvid&domain=m.gsshop.com&service_type=MC&mediatype=mediatype&appmediatype=appmediatype
        
        
        
        
        if([arg1 isEqualToString:@"D_1016"]){
            //검색 - 우측상단 돋보기 버튼클릭
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/1020103?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }else  if([arg1 isEqualToString:@"D_1017"]){
            //홈 - 상단 장바구니확인 아이콘클릭
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/4020504?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
        /*
        else  if([arg1 isEqualToString:@"D_1019"]){
            //홈 - 하단탭 마이쇼핑
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/4020703?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
         */
        else if([arg1 isEqualToString:@"D_1030"]){
            //앱푸시수신신청
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/4020609?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
        else if([arg1 isEqualToString:@"D_1031"]){
            //앱푸시수신해지
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/4020610?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
        else if([arg1 isEqualToString:@"D_1032"]){
            //회원인증 - 비로그인상태 - 로그인페이지진입 - 아이디 비번입력 - 로그인버튼클릭
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/D1032/1050101?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
        else if([arg1 isEqualToString:@"D_1033"]){
            //나가기 - 마이쇼핑 - 설정 - 로그아웃
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/4060201?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
        /*
        else if([arg1 isEqualToString:@"D_1034"]){
            //상품평작성
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/3040201?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
         */

        else if([arg1 isEqualToString:@"D_1038"]){
            //회원인증 - 비로그인상태 - 로그인페이지진입
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/D1038/1050101?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
        else if([arg1 isEqualToString:@"D_4030101"]){ // D번호가 없어서 그냥 행동코드로 생성
            //마이쇼핑 1:1모바일 상담 상담문의 - 접수하기
            apiUrl= [NSString stringWithFormat:@"http://gtm.gsshop.com/mgs/app/4030101?pcid=%@&catvid=%@&domain=m.gsshop.com&service_type=MC&mediatype=%@&appmediatype=%@", [self itspcid], [self itscatvid], [self itsmediatype], @"BS"];
            
        }
        else {
            apiUrl = nil;
            return;
        }
        
        

        
        // Establish the API request. Use upload vs uploadAndPost for skip tweet
        NSString *baseurl = [NSString stringWithFormat:@"http://gtm.gsshop.com/index.htm?uri=%@",apiUrl];
        
        NSLog(@"baseURL: %@",  [NSString stringWithFormat:@"%@",baseurl]);
        NSURL *url = [NSURL URLWithString:baseurl];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:3.0f];
        
        
        [urlRequest setHTTPMethod: @"GET"];
        
        //GTM user Agent 추가 2015/11/09 yunsang.jin
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        NSLog(@"Contacting Server....");
        
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          if (!result)
                                          {
                                              
                                          }else {
                                              //응답코드
                                              NSLog(@" 데이터허브result========== %@ ", result);
                                              
                                              
                                          }
                                      }];
        [task resume];
        
        /*
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             if (!result)
             {
                 
             }else {
                 //응답코드
                 NSLog(@" 데이터허브result========== %@ ", result);
                 
                 
             }
             
             
         }];
        [queue waitUntilAllOperationsAreFinished];
        */
        
    }
    
}
-(NSString*)itspcid{
    
    
    NSString* pcidstr = [NSString stringWithFormat:@""];
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        //NSLog(@"cookiesarr: %@  == %@", cookie.name,  cookie.value);
        if([cookie.name isEqualToString:@"pcid"]){
            pcidstr = cookie.value;
            return pcidstr;
            
        }
    }
    
    return  pcidstr;
    
    
}

-(NSString*)itscatvid{
    
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        //NSLog(@" %@  == %@", cookie.name,  cookie.value);
        if([cookie.name isEqualToString:@"ecid"]){
            
            NSArray *curarr = [Mocha_Util explode:@"~" string:cookie.value];
            
            for(NSString *gval in curarr){
                
                //NSLog(@"제거비교: %@ %@ %@", gval, tgval,[Mocha_Util strReplace:@" " replace:@"+" string:tgval] );
                
                if( [gval hasPrefix:@"catvid="]  ){
                    
                    //   NSLog(@"CATVID: %@", [Mocha_Util strReplace:@"catvid=" replace:@"" string:gval] );
                    
                    NSString* catvidstr = [Mocha_Util strReplace:@"catvid=" replace:@"" string:gval];
                    return  [Mocha_Util strReplace:@"\"" replace:@"" string:catvidstr];
                }
                
            }
            
            
            
        }
    }
    
    return  @"";
    
    
}
-(NSString*)itsmediatype{
    
    
    if(DHmediaType == nil){
        
        
        NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        
        NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
        for (NSHTTPCookie *cookie in gsCookies) {
            //NSLog(@" %@  == %@", cookie.name,  cookie.value);
            if([cookie.name isEqualToString:@"ecid"]){
                
                NSArray *curarr = [Mocha_Util explode:@"~" string:cookie.value];
                
                
                //NSString* ckstr = [NSString string];
                
                for(NSString *gval in curarr){
                    
                    //NSLog(@"제거비교: %@ %@ %@", gval, tgval,[Mocha_Util strReplace:@" " replace:@"+" string:tgval] );
                    
                    if( [gval hasPrefix:@"mediatype="]  ){
                        
                        // NSLog(@"mmmtype: %@", [Mocha_Util strReplace:@"mediatype=" replace:@"" string:gval] );
                        
                        NSString* cmedtypestr = [Mocha_Util strReplace:@"mediatype=" replace:@"" string:gval];
                        return [Mocha_Util strReplace:@"\"" replace:@"" string:cmedtypestr];
                    }
                    
                }
                
                
                
            }
        }
        
        
        return @"";
    }else {
        return DHmediaType;
    }
    
}

-(NSString*)itscustclass{
    
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        //NSLog(@" %@  == %@", cookie.name,  cookie.value);
        if([cookie.name isEqualToString:@"ecid"]){
            
            NSArray *curarr = [Mocha_Util explode:@"~" string:cookie.value];
            
            //NSString* ckstr = [NSString string];
            
            for(NSString *gval in curarr){
                
                //NSLog(@"제거비교: %@ %@ %@", gval, tgval,[Mocha_Util strReplace:@" " replace:@"+" string:tgval] );
                
                if( [gval hasPrefix:@"cusclass="]  ){
                    
                    NSLog(@"cusclass: %@", [Mocha_Util strReplace:@"cusclass=" replace:@"" string:gval] );
                    
                    NSString* custclassstr = [Mocha_Util strReplace:@"cusclass=" replace:@"" string:gval];
                    //NSLog(@" %@",[Mocha_Util strReplace:@"\"" replace:@"" string:custclassstr]);
                    return  [Mocha_Util strReplace:@"\"" replace:@"" string:custclassstr];
                }
                
            }
            
            
            
        }
    }
    
    return  @"";
    
    
}

@end
