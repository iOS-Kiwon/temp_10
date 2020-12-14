//
//  PrePrdView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 2. 25..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import "PrePrdView.h"
#import "AppDelegate.h"
#import <AirBridge/AirBridge.h>

@implementation PrePrdView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0.0, APPFULLHEIGHT, APPFULLWIDTH, APPFULLHEIGHT);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reInitWKWebView) name:WKSESSION_REINIT object:nil];
    
    [self reInitWKWebView];
    
}

-(void)reInitWKWebView{
    
    if (webViewPrePrd != nil) {
        [webViewPrePrd removeFromSuperview];
        webViewPrePrd = nil;
    }
    
    webViewPrePrd.scrollView.scrollsToTop = NO;
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
    config.userContentController = userContentController;
    config.processPool = [[WKManager sharedManager] getGSWKPool];
    config.allowsInlineMediaPlayback = YES;
    
    webViewPrePrd = [[GSWKWebview alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, APPFULLHEIGHT - STATUSBAR_HEIGHT) configuration:config];
    webViewPrePrd.navigationDelegate = self;
    webViewPrePrd.UIDelegate = webViewPrePrd;
    [self addSubview:webViewPrePrd];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString ;
    
    BOOL isDecisionAllow = YES;
    
    NSLog(@"요청URL %@", requestString1);
    
    if ([requestString1 isEqualToString:strStartUrl]) {
        isDecisionAllow = YES;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://close"]) {
        
        [self closeWithAnimated:YES];
        isDecisionAllow = NO;
    }else if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://back"]) {
        
        [self closeWithAnimated:YES];
        isDecisionAllow = NO;
    }
    else if (isDecisionAllow == YES && [requestString1 hasPrefix:@"appjs:"]) {
        NSString *jsonString = [[[requestString1 componentsSeparatedByString:@"appjs:"] lastObject] stringByRemovingPercentEncoding];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        if(NCO(jsonData)) {
            id parameters = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            NSLog(@"appjs params: %@", parameters);
            if(!error) {
                NSDictionary*dd = [[NSDictionary alloc] initWithDictionary:parameters];
                NSLog(@" %@",[dd objectForKey:@"callback"]);
                NSString* procnstr = [NSString stringWithFormat:@"%@('%@');",NCS([dd objectForKey:@"callback"]), [Common_Util commonAPPJSresponse:NCS([dd objectForKey:@"actkey"]) eventName:[dd objectForKey:@"eventName"] reqparam:[dd objectForKey:@"reqparam"]]  ];
                
                //콜백이 있을떄만
                if([NCS([dd objectForKey:@"callback"]) length] > 0){
                    [self callJscriptMethod: procnstr];
                }
            }
            else {
                
            }
        }
        isDecisionAllow = NO;
    }
    else {
        
        BOOL isFrame = ![[[navigationAction.request URL] absoluteString] isEqualToString:[[navigationAction.request mainDocumentURL] absoluteString]];
        
        if (isFrame == NO && ![requestString1 isEqualToString:strStartUrl]) {
            
            [self closeWithAnimated:YES];
            
            ////탭바제거
            UINavigationController * navigationController = ApplicationDelegate.mainNVC;
            ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:requestString1];
            
            if([Mocha_Util strContain:@"ordSht.gs" srcstring:requestString1]) {
                resVC.ordPass = YES;
            }
            
            resVC.view.tag = 505;
            [navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
            isDecisionAllow = NO;
        }
        
        
    }
    
    if(isDecisionAllow){
        NSLog(@"");
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        NSLog(@"");
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *arrResponseCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@""]];
    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *arrSharedCookie = [sharedCookies cookies];
    
    
    for (NSHTTPCookie *cookie in arrResponseCookies) {
        
        //if (cookie !=nil && ([cookie.name isEqualToString:@"lastprdid"] || [cookie.name isEqualToString:@"search"])) {
        if (cookie !=nil && ([cookie.name length] > 0)) {
            
            for (NSHTTPCookie *deleteCookie in arrSharedCookie) {
                if ([[deleteCookie domain] isEqualToString:[cookie domain]] && [[deleteCookie name] isEqualToString:[cookie name]]) {
                    //NSLog(@"WKNavigationResponse delete Cookie = %@",deleteCookie);
                    [sharedCookies deleteCookie:deleteCookie];
                }
            }
            
            //NSLog(@"setttttt cookie = %@",cookie);
            
            [sharedCookies setCookie:cookie];
            
            //            if ([cookie.name isEqualToString:@"lastprdid"]) {
            //                [ApplicationDelegate checkCookieLastPrd];
            //            }
        }
        
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"-====== %@", [NSString stringWithFormat:@"%@",webView.URL.absoluteString]);
    dispatch_async(dispatch_get_main_queue(),^{
        [ApplicationDelegate.gactivityIndicator startAnimating];
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{    
    NSLog(@"-====== %@", [NSString stringWithFormat:@"%@",webView.URL.absoluteString]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Webviewerror: %@", [error description]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

//javascript 함수호출
-(void)callJscriptMethod:(NSString *)mthd {
    
    [webViewPrePrd evaluateJavaScript:mthd completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"callJscriptMethod mthd = %@",mthd);
        NSLog(@"callJscriptMethod WKresult = %@",result);
        NSLog(@"callJscriptMethod WKerror = %@",error);
        
    }];
}

- (void)closeWithAnimated:(BOOL)animated {
    
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         webViewPrePrd.frame = CGRectMake(0, self.frame.size.height, webViewPrePrd.frame.size.width, webViewPrePrd.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         self.frame = CGRectMake(0.0, APPFULLHEIGHT, APPFULLWIDTH, APPFULLHEIGHT -STATUSBAR_HEIGHT);
                     }];
}




- (void)openWithAnimated:(BOOL)animated withUrl:(NSString *)strUrl {
    NSLog(@"strStartUrl = %@",strStartUrl);
    strStartUrl = strUrl;
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:strStartUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    [webViewPrePrd loadRequest:requestObj];
    
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{

                         if(IS_IPHONE_X_SERISE)
                         {
                             webViewPrePrd.frame = CGRectMake(0, 45, APPFULLWIDTH, webViewPrePrd.frame.size.height);
                         }
                         else{
                             if (@available(iOS 11.0, *))
                             {
                                 webViewPrePrd.frame = CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, webViewPrePrd.frame.size.height);
                             }
                             else{
                                 webViewPrePrd.frame = CGRectMake(0, 0, APPFULLWIDTH, webViewPrePrd.frame.size.height);
                             }
                         }
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"webViewPrePrdwebViewPrePrd = %@",webViewPrePrd);
                     }];
}


@end

