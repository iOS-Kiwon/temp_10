//
//  WKManager.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 10. 19..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "WKManager.h"
#import "NSHTTPCookie+JAVASCRIPT.h"
#import "AppDelegate.h"
#import <AirBridge/AirBridge.h>


@interface WKManager () <WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *wkwview;
@property (nonatomic,strong) WKProcessPool *wkProcessPool;
@property (nonatomic) NSTimeInterval loadHTMLStart;
@end

@implementation WKManager
@synthesize isSyncronizing;

+ (WKManager *)sharedManager
{
    static WKManager *singleton = nil;
    
    if( singleton == nil )
    {
        @synchronized( self )
        {
            if( singleton == nil )
            {
                singleton = [[self alloc] init];
            }
        }
    }
    return singleton;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.isSyncronizing = NO;
        self.wkProcessPool = [[WKProcessPool alloc] init];
    }
    return  self;
}

- (WKProcessPool *)getGSWKPool {
    return self.wkProcessPool;
}

- (void) resetPool
{
    self.wkProcessPool = nil;
    self.wkProcessPool = [[WKProcessPool alloc]  init];
}


//쿠키 복사 NSHTTPCookieStorage -> WKWebview
-(void)wkWebviewSetCookieAll:(BOOL)isPoolKeep {
    if (isPoolKeep == NO) { // pool유지 안함 로그아웃일 경우 초기화
        self.wkProcessPool = nil;
        self.wkProcessPool = [[WKProcessPool alloc] init];
        [[NSNotificationCenter defaultCenter] postNotificationName:WKSESSION_REINIT object:nil userInfo:nil];
    }
    self.isSyncronizing = YES;
    
    
    BOOL loginStatus = [[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin);
    
    
    //로그인 쿠키 유효성 체크
   
    
    // 자동로그인을 풀릴려면.. 자동로그인 상태 확인
    if(loginStatus) {
        if(![ApplicationDelegate checkLoginCookie:NO]) {//쿠키에 로그인정보가 없다면
            //if([DataManager sharedManager].m_loginData.autologin == 1) { // 자동로그인 유저임.
            
                //solution 2: 로그인 쿠키 원복?
                if( NCO(ApplicationDelegate.loginEcidCookies) && NCO(ApplicationDelegate.loginisLoginCookies)) {
                    //쿠키 복구
                    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
                    [sharedCookies setCookie:ApplicationDelegate.loginEcidCookies];
                    [sharedCookies setCookie:ApplicationDelegate.loginisLoginCookies];
                    [self WKConfigSettingModule];
                }
                else {
                    //어.. 저장된게;;; 없네??
                    // 어쩌지?
                    [self WKConfigSettingModule];
                }
                
            //}
            //else { //자동로그인 유저가 아니라면 무한돌겠죠...
            //    // 어쩌지?
            //    [self WKConfigSettingModule];
            //}
         }
         else {
             //쿠키 세팅이 잘되어 있는자.
             [self WKConfigSettingModule];
         }
    }
    else {
        //로그인이랑 상관없는자..
        [self WKConfigSettingModule];
    }
        
    
    
       
    /*
    
    NSMutableString *script = [[NSMutableString alloc] initWithString:@""];
    [script appendString:@"var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"];
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
         //Skip cookies that will break our script
        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
            continue;
        }
        
        // Create a line that appends this cookie to the web view's document's cookies
        //[script appendFormat:@"if (cookieNames.indexOf('%@') == -1) { document.cookie='%@'; };\n", cookie.name, cookie.wn_javascriptString];
        [script appendFormat:@"document.cookie='%@';\n", cookie.wn_javascriptString];
        
    }
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:script
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:NO];
    [userContentController addUserScript:cookieInScript];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    config.processPool = self.wkProcessPool;
    config.allowsInlineMediaPlayback = YES;
    
    if(self.wkwview != nil) {
        self.wkwview.UIDelegate = nil;
        self.wkwview.navigationDelegate = nil;
        self.wkwview = nil;
    }
    self.wkwview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.wkwview.navigationDelegate = self;
    NSURL *urlProcessSession = [NSURL URLWithString:WKSESSION_URL];
    NSMutableURLRequest *requestObj = [[NSMutableURLRequest alloc]initWithURL:urlProcessSession cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
    
    [ApplicationDelegate onloadingindicator];
    [self.wkwview loadRequest:requestObj];
     */
    
}

-(void) WKConfigSettingModule {
    
    //NSLog(@"checkLoginCookie >> %@",[ApplicationDelegate checkLoginCookie:NO] ? @"YES" : @"NO");
    
    NSMutableString *script = [[NSMutableString alloc] initWithString:@""];
    [script appendString:@"var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"];
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        //Skip cookies that will break our script
        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
            continue;
        }
        
        // Create a line that appends this cookie to the web view's document's cookies
        //[script appendFormat:@"if (cookieNames.indexOf('%@') == -1) { document.cookie='%@'; };\n", cookie.name, cookie.wn_javascriptString];
        [script appendFormat:@"document.cookie='%@';\n", cookie.wn_javascriptString];
        
    }
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:script
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:NO];
    [userContentController addUserScript:cookieInScript];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
    config.userContentController = userContentController;
    config.processPool = self.wkProcessPool;
    config.allowsInlineMediaPlayback = YES;
    
    if(self.wkwview != nil) {
        self.wkwview.UIDelegate = nil;
        self.wkwview.navigationDelegate = nil;
        self.wkwview = nil;
    }
    self.wkwview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.wkwview.navigationDelegate = self;
    NSURL *urlProcessSession = [NSURL URLWithString:WKSESSION_URL];
    NSMutableURLRequest *requestObj = [[NSMutableURLRequest alloc]initWithURL:urlProcessSession cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
    
    [ApplicationDelegate onloadingindicator];
    [self.wkwview loadRequest:requestObj];
}


#pragma mark - WKWebviewDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    self.loadHTMLStart = CACurrentMediaTime();
    NSLog(@"navigationAction.request.URL.absoluteString = %@",navigationAction.request.URL.absoluteString);
    if ([navigationAction.request.URL.absoluteString isEqualToString:WKSESSION_URL]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *arrResponseCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@""]];
    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *arrSharedCookie = [sharedCookies cookies];
    for (NSHTTPCookie *cookie in arrResponseCookies) {
        if (cookie !=nil && ([cookie.name length] > 0)) {
            NSLog(@"cookie.name cookie.name =%@",cookie.name);
            for (NSHTTPCookie *deleteCookie in arrSharedCookie) {
                if ([[deleteCookie domain] isEqualToString:[cookie domain]] && [[deleteCookie name] isEqualToString:[cookie name]]) {
                    NSLog(@"WKNavigationResponse delete Cookie = %@",deleteCookie);
                    [sharedCookies deleteCookie:deleteCookie];
                }
            }
            [sharedCookies setCookie:cookie];
            if ([cookie.name isEqualToString:WKCOOKIE_NAME_LASTPRDID]) {
                [ApplicationDelegate checkCookieLastPrd:cookie.value];
            }
        }
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"");
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"");
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"errorerror = %@",error);
    //NSString *test = ( [[[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] length] > 0 ) ? [[NSUserDefaults standardUserDefaults] objectForKey:DEV_VERSION_CODE] : @"7.2";
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    //200이 아닐경우 로그인 실패 처리를 해야할지?
    if ([webView.URL.absoluteString isEqualToString:WKSESSION_URL]) {
        //최적화 검토 필요
        NSLog(@"Manager DidFinishNavigation = %@",webView.URL.absoluteString);
        NSTimeInterval delta = CACurrentMediaTime() - self.loadHTMLStart;
        NSLog(@"END: %f, TIME: %f", CACurrentMediaTime(), delta);
        [ApplicationDelegate offloadingindicator];
        
        // 로그인 쿠키 값 확인 후 별도 저장
        //[Mocha_ToastMessage toastWithDuration:2.0 andText:@"동기화성공" inView:ApplicationDelegate.window];
        [[NSNotificationCenter defaultCenter] postNotificationName:WKSESSION_SUCCESS object:nil userInfo:nil];
        self.isSyncronizing = NO;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    if ([webView.URL.absoluteString isEqualToString:WKSESSION_URL]) {
        NSLog(@"Manager DidFinishNavigation = %@",webView.URL.absoluteString);
        [ApplicationDelegate offloadingindicator];
        [[NSNotificationCenter defaultCenter] postNotificationName:WKSESSION_FAIL object:nil userInfo:nil];
        [Mocha_ToastMessage toastWithDuration:2.0 andText:@"동기화에 실패 하였습니다." inView:ApplicationDelegate.window];
        self.isSyncronizing = NO;
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    // SSL 인증서 오류 시, 무시하도록 설정
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    
    NSError * error = [challenge error];
    if (error != nil) {
        NSString *msg = [NSString stringWithFormat:@"didReceiveAuthenticationChallenge 호출됨. 인증서 오류로 의심됨. %@", error.localizedDescription ] ;
        [ApplicationDelegate SendExceptionLog:error msg:msg];
    }
}

#pragma mark - WKWebview Cookie Copy
//전체 쿠키를 wkwebview -> NSHTTPCookieStorage로 동기화 블럭형.. 이후 처리 로직 필요할때
-(void)copyToSharedCookieAll:(WKResponseBlock) completionBlock {
    [self.wkwview evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([NCS(result) length] > 0) {
            NSString *strResult = [NSString stringWithFormat:@"%@",(NSString *)result];
            NSArray *arrResult = [strResult componentsSeparatedByString:@";"];
            BOOL rBool = [self copyToSharedCookie:arrResult];
            completionBlock(rBool);
        }
        else {
            completionBlock(NO);
        }
    }];
}




//특정 쿠키 삭제 iOS11이상만.
-(void)wkWebviewDeleteCookie:(NSHTTPCookie*) cookie OnCompletion:(WKResponseBlock) completionBlock {
    if(self.wkwview == nil) {
        completionBlock(NO);
        return;
    }
    
    [self.wkwview.configuration.websiteDataStore.httpCookieStore deleteCookie:cookie completionHandler:^{
        completionBlock(YES);
    }];
}



//특정 쿠키 설정 iOS11이상만.
-(void)wkWebviewSetCookie:(NSHTTPCookie*) cookie OnCompletion:(WKResponseBlock) completionBlock {
    if(self.wkwview == nil) {
        completionBlock(NO);
        return;
    }
    
    [self.wkwview.configuration.websiteDataStore.httpCookieStore setCookie:cookie completionHandler:^{
        completionBlock(YES);
    }];
}




-(BOOL) copyToSharedCookie:(NSArray *) arrResult {
    for (NSString *strCookie in arrResult) {
        NSString *strToSplit = NCS(strCookie);
        if([strToSplit length] <= 0) {
            continue;
        }
        NSString *strKey = nil;
        NSString *strValue = nil;
        NSScanner *scanner = [NSScanner scannerWithString:strToSplit];
        [scanner scanUpToString:@"=" intoString:&strKey];
        [scanner scanString:@"=" intoString:nil];
        strValue = [strToSplit substringFromIndex:scanner.scanLocation];
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:strKey forKey:NSHTTPCookieName];
        [cookieProperties setObject:strValue forKey:NSHTTPCookieValue];
        [cookieProperties setObject:@".gsshop.com" forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@".gsshop.com" forKey:NSHTTPCookieOriginURL];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        if ([strKey isEqualToString:WKCOOKIE_NAME_LASTPRDID]) {
            [ApplicationDelegate checkCookieLastPrd:strValue];
        }
        NSLog(@"cookie.name = %@",cookie.name);
        NSLog(@"cookie.value = %@",cookie.value);
    }
    return YES;
}



-(BOOL) copyToSharedCookie:(NSArray *) arrResult cookieName:(NSString *)strName {
    BOOL isFind = NO;
    for (NSString *strCookie in arrResult) {
        NSString *strToSplit = NCS(strCookie);
        if([strToSplit length] <= 0) {
            continue;
        }
        NSString *strKey = nil;
        NSString *strValue = nil;
        NSScanner *scanner = [NSScanner scannerWithString:strToSplit];
        [scanner scanUpToString:@"=" intoString:&strKey];
        [scanner scanString:@"=" intoString:nil];
        strValue = [strToSplit substringFromIndex:scanner.scanLocation];
        if ([strKey isEqualToString:strName]) {
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:strKey forKey:NSHTTPCookieName];
            [cookieProperties setObject:strValue forKey:NSHTTPCookieValue];
            [cookieProperties setObject:@".gsshop.com" forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:@".gsshop.com" forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            if ([strKey isEqualToString:WKCOOKIE_NAME_LASTPRDID]) {
                [ApplicationDelegate checkCookieLastPrd:strValue];
            }
            isFind = YES;
            break;
        }
    }
    return isFind;
}


//특정 쿠키를 wkwebview -> NSHTTPCookieStorage로 동기화 - 블럭형.. 이후 처리 로직 필요할때
-(void)copyToSharedCookieName:(NSString *)strName OnCompletion:(WKResponseBlock) completionBlock {
    [self.wkwview evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([NCS(result) length] > 0) {
            NSString *strResult = [NSString stringWithFormat:@"%@",(NSString *)result];
            NSArray *arrResult = [strResult componentsSeparatedByString:@";"];
            BOOL rBool = [self copyToSharedCookie:arrResult cookieName:strName];
            
            completionBlock(rBool);
        }
        else {
            completionBlock(NO);
        }
    }];
}

-(void)printCookie{
    [self.wkwview evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if ([NCS(result) length] > 0) {
            NSString *strResult = [NSString stringWithFormat:@"%@",(NSString *)result];
            NSArray *arrResult = [strResult componentsSeparatedByString:@";"];
            
            NSLog(@"arrResultarrResultarrResult = %@",arrResult);

        }
    }];
}
@end
