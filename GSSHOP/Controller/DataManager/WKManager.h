//
//  WKManager.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 10. 19..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Webkit/Webkit.h"

typedef void (^WKResponseBlock)(BOOL isSuccess);
typedef void (^WKResponseErrorBlock)(NSError *error);

@interface WKManager : NSObject

@property(nonatomic,readwrite) BOOL isSyncronizing;

+ (WKManager *)sharedManager;
- (void)wkWebviewSetCookieAll:(BOOL)isPoolKeep;
- (WKProcessPool *)getGSWKPool;
- (void) resetPool;


-(void)copyToSharedCookieName:(NSString *)strName OnCompletion:(WKResponseBlock) completionBlock;
-(void)copyToSharedCookieAll:(WKResponseBlock) completionBlock;
-(void)wkWebviewDeleteCookie:(NSHTTPCookie*) cookie OnCompletion:(WKResponseBlock) completionBlock API_AVAILABLE(macosx(10.13), ios(11.0));
-(void)wkWebviewSetCookie:(NSHTTPCookie*) cookie OnCompletion:(WKResponseBlock) completionBlock API_AVAILABLE(macosx(10.13), ios(11.0));

-(void)printCookie;
@end
