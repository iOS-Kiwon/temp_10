//
//  CooKieDBManager.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 9. 16..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "CooKieDBManager.h"

@implementation CooKieDBManager

+(NSMutableArray*) getRecentKeywordCK {
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"search"]) {
            if([cookie.value isEqualToString:@""]) {
                return nil;
            }
            // 디코딩 stringByReplacingPercentEscapesUsingEncoding
            
            NSLog(@"cookie val: %@", [[NSString stringWithFormat:@"%@",cookie.value ] stringByRemovingPercentEncoding] );
            NSString* preval= [[NSString stringWithFormat:@"%@",cookie.value ] stringByRemovingPercentEncoding];
            if([preval  hasPrefix:@"@"]) {
                preval = [preval substringFromIndex:1];
            }
            //20160913 parkseugn - hasSuffix 에서 예외 발생에 대한 대응 처리
            if([NCS(preval)  hasSuffix:@"@"]) {
                preval = [preval substringWithRange:NSMakeRange(0, [preval length]-1)];
            }
            preval = [Mocha_Util strReplace:@"+" replace:@" " string:preval];
            NSMutableArray *cookieProperties = [NSMutableArray arrayWithArray:[[[Mocha_Util explode:@"@" string:preval  ] reverseObjectEnumerator] allObjects] ];
            return cookieProperties;
        }
    }
    return nil;
}

+(NSString*) getCartCountstr {
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        
        if([cookie.name isEqualToString:@"cartcnt"]) {
            //cartcount
            if([cookie.value isEqualToString:@""]) {
                return nil;
            }
            NSLog(@"cookie arr : %@ === %@", cookie.name, cookie.value);
            return [Mocha_Util strReplace:@" " replace:@"" string:cookie.value];            
        }
        
    }
    return nil;
}

+(NSString*) getMartDeliFlag {
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    
    for (NSHTTPCookie *cookie in gsCookies) {
        
        if([cookie.name isEqualToString:@"martDeliFlag"]) {
            //cartcount
            if([cookie.value isEqualToString:@""]) {
                return nil;
            }
            NSLog(@"cookie arr : %@ === %@", cookie.name, cookie.value);
            NSLog(@"cookie %@", cookie);
            return [Mocha_Util strReplace:@" " replace:@"" string:cookie.value];
        }
        
    }
    return nil;
}

+(BOOL) deleteOneKeyRecentKeywordCK:(NSString*)tgval {
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"search"]) {
            NSMutableArray *cookieProperties = [NSMutableArray arrayWithArray:[Mocha_Util explode:@"@" string: [[NSString stringWithFormat:@"%@",cookie.value ] stringByRemovingPercentEncoding] ] ];
            NSString* ckstr = [NSString string];
            int i = 0;
            for(NSString *gval in cookieProperties) {
                if( [gval isEqualToString:tgval]  || [gval isEqualToString:[NSString stringWithFormat:@"%@",[Mocha_Util strReplace:@" " replace:@"+" string:tgval]] ]){
                    
                }
                else {
                    if(i == 0) {
                        ckstr = [NSString stringWithFormat:@"%@",gval];
                    }
                    else {
                        ckstr = [NSString stringWithFormat:@"%@@%@",ckstr,gval];
                    }
                }
                i++;
            }
            
            [cookies deleteCookie:cookie];
            NSMutableDictionary* cookiestrees = [NSMutableDictionary dictionary];
            [cookiestrees setObject:@"search" forKey:NSHTTPCookieName];
            [cookiestrees setObject:[ckstr urlEncodedString]//[ckstr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
                             forKey:NSHTTPCookieValue];
            [cookiestrees setObject:@".gsshop.com" forKey:NSHTTPCookieDomain];
            [cookiestrees setObject:@".gsshop.com" forKey:NSHTTPCookieOriginURL];
            [cookiestrees setObject:@"/" forKey:NSHTTPCookiePath];
            [cookiestrees setObject:@"0" forKey:NSHTTPCookieVersion];
            [cookiestrees setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
            
            NSHTTPCookie *neocookie = [NSHTTPCookie cookieWithProperties:cookiestrees];
            [cookies setCookie:neocookie];
            NSLog(@"GSShop cookies  ================== %@ === %@ === %@", cookie.name,  [cookie.value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], cookie.domain   );
            return YES;
        }
    }
    return NO;
}



+(BOOL) deleteAllRecentKeywordCK {
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"search"]) {
            [cookies deleteCookie:cookie];            
            return YES;
        }
    }
    return NO;
}

+(void)deleteLogoutCookies{
    
    //임시저장된 로그인 쿠기 정보를 제거한다.
    ApplicationDelegate.loginisLoginCookies = nil;
    ApplicationDelegate.loginEcidCookies = nil;    
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if(cookie.isSessionOnly){
            NSLog(@"delcookies GSShop cookies  ================== %@ === %@", cookie.name,cookie.value );
            if([cookie.name isEqualToString:@"mediatype"] ||
               [cookie.name isEqualToString:@"appmediatype"] ||
               [cookie.name isEqualToString:@"pcid"] ||
               //최근본 상품 쿠키 남도록 변경 2016/03/28 yunsang.jin
               [cookie.name isEqualToString:@"lastprdid"] ||
               [cookie.name isEqualToString:@"wa_pcid"] ||
               [cookie.name isEqualToString:@"view-type"] ||
               [cookie.name isEqualToString:@"martDeliHistoryFlag"]
               ) {
            }
            else {
                [cookies deleteCookie:cookie];
            }
            
        }else {
            if([cookie.name isEqualToString:@"mediatype"] ||
               [cookie.name isEqualToString:@"appmediatype"] ||
               [cookie.name isEqualToString:@"pcid"] ||
               //최근본 상품 쿠키 남도록 변경 2016/03/28 yunsang.jin
               [cookie.name isEqualToString:@"lastprdid"] ||
               [cookie.name isEqualToString:@"wa_pcid"] ||
               [cookie.name isEqualToString:@"view-type"] ||
               [cookie.name isEqualToString:@"martDeliHistoryFlag"]
               ){
            }else {
                [cookies deleteCookie:cookie];
            }
            NSLog(@"Normal cookie GSShop cookies  ================== %@ === %@", cookie.name,cookie.value );
            
        }
        
    }
    
}


+(void)printSharedCookies {
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if(cookie.isSessionOnly){
            NSLog(@"Session GSShop cookies  ================== %@ === %@", cookie.name,cookie.value );
            
        }
        else {            
            NSLog(@"Normal cookie GSShop cookies  ================== %@ === %@", cookie.name,cookie.value );
            
        }
        
    }
}

@end
