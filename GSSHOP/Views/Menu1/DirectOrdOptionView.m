//
//  DirectOrdOptionView.m
//  GSSHOP
//
//  Created by gsshop on 2016. 3. 4..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "DirectOrdOptionView.h"
#import "AppDelegate.h"
#import <AirBridge/AirBridge.h>

@implementation DirectOrdOptionView



- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0.0, APPFULLHEIGHT, APPFULLWIDTH, APPFULLHEIGHT);
    //self.alpha = 0.0;
    self.backgroundColor = UIColor.clearColor;
    abNomalCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reInitWKWebView) name:WKSESSION_REINIT object:nil];
    //[self reInitWKWebView];
}

- (void) drawRect:(CGRect)rect {
}

-(void)reInitWKWebView {
    
    if (webViewOption != nil) {
        [webViewOption removeFromSuperview];
        webViewOption.UIDelegate = nil;
        webViewOption.navigationDelegate = nil;
        webViewOption = nil;
    }
    
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
    config.userContentController = userContentController;
    config.processPool = [[WKManager sharedManager] getGSWKPool];
    config.allowsInlineMediaPlayback = YES;
    
    webViewOption = [[GSWKWebview alloc] initWithFrame:CGRectMake(0.0, 0, APPFULLWIDTH, APPFULLHEIGHT) configuration:config];
    webViewOption.navigationDelegate = self;
    webViewOption.UIDelegate = webViewOption;
    webViewOption.scrollView.scrollsToTop = NO;
    webViewOption.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:webViewOption];
    
    webViewOption.backgroundColor = UIColor.clearColor;
    [webViewOption setOpaque:NO];
    
    //[webViewOption loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sm20.gsshop.com/shop/directOrd/54827478?mseq=A00323-V-BUY&pgmID=361457"]]];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString ;
    
    BOOL isDecisionAllow = YES;
    
    NSLog(@"요청URL %@", requestString1);
    
    //로그인이 필요한 페이지는 로그인을 하고 페이지를 넘긴다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGINCHECKURL]) {
        //웹뷰가 toapp://login 호출할경우 기존에 로그인이 되어있으면 API로그아웃이 "아닌" APPJS 방식 로그아웃 호출
        if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
            if( [webViewOption.configuration.processPool isEqual:[[WKManager sharedManager] getGSWKPool]] ) {
                NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation" code:9000 userInfo:nil];
                NSString *msg = [[NSString alloc] initWithFormat:@"앱로그인 상태에서 toapp://login 호출됨: DirectOrdOption url=%@ 자동로그인인가? %@, requestString1 %@", webViewOption.lastEffectiveURL, ([DataManager sharedManager].m_loginData.autologin == 1 ? @"YES" : @"NO") , requestString1 ];
                [ApplicationDelegate SendExceptionLog:err msg: msg];
                decisionHandler(WKNavigationActionPolicyCancel);
                // 재호출 로직 제한
                if(abNomalCount >= ABNOMALMAX) {
                    // 앱을 자동로그인 부터 다시 한다.
                    NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation_AppExit" code:9001 userInfo:nil];
                    [ApplicationDelegate SendExceptionLog:err msg: @"앱메인이동"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [ApplicationDelegate callProcess];
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self closeWithAnimated:NO];
                    });
                    return;
                }
                abNomalCount++;
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(wkSessionSuccess)
                                                             name:WKSESSION_SUCCESS
                                                           object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(wkSessionFail)
                                                             name:WKSESSION_FAIL
                                                           object:nil];
                [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
                return;
            }
        }
        
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        if([query2 isEqualToString:@""]) {
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
        }
        else {
            self.curRequestString = [NSString stringWithString:query2];
        }
        NSLog(@"self.curRequestString = %@", self.curRequestString);
        
        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
        if(loginView == nil) {
            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
        }else{
            [loginView clearTextFields];
        }
        
        loginView.delegate = self;
        loginView.loginViewType = 4;
        loginView.deletargetURLstr = query2;
        //20140220 각 포함 문자열 비교방식을 안드로이드에 맞춤.
        if([Mocha_Util strContain:@"isAdult=Y" srcstring:requestString1]) {
            loginView.loginViewMode = 2;
        }
        else if([Mocha_Util strContain:@"isPrdOrder=Y" srcstring:requestString1]) {
            loginView.loginViewMode = 1;
        }
        else {
            loginView.loginViewMode = 0;
        }
        
        [ApplicationDelegate directOrdOptionViewHidden];
        ////탭바제거
        UINavigationController * navigationController = ApplicationDelegate.mainNVC;
        loginView.view.hidden=NO;
        
        
        // 여러 번 호출되서 발생하는 Animation crash 방지
        @try {
            if([[navigationController.viewControllers objectAtIndex:0] isKindOfClass:[AutoLoginViewController class]] == NO)
            {
                [navigationController pushViewControllerMoveInFromBottom:loginView];
            }
        } @catch (NSException *exception) {

        } @finally {

        }
    
        
        //20170615점유인증 & 회원 간소화
        if([Mocha_Util strContain:@"msg=" srcstring:requestString1]) {
            NSArray *msgTemp = [requestString1 componentsSeparatedByString:@"msg="];
            if( [msgTemp count] > 1 ) {
                NSArray *idTemp = [NCS([msgTemp objectAtIndex:1]) componentsSeparatedByString:@"&"];
                if( [idTemp count] > 0) {
                    loginView.textFieldId.text = NCS([idTemp objectAtIndex:0]);
                }
            }
        }
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
    }
    else if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://close"]) {
        
        [self callMainCartUpdate];
        [ApplicationDelegate directOrdOptionViewHidden];
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDIRECTORDERCLOSE object:nil userInfo:nil];
        isDecisionAllow = NO;
    }
    else if (isDecisionAllow == YES && [requestString1 hasPrefix:@"appjs:"]) {
        NSString *jsonString = [[[requestString1 componentsSeparatedByString:@"appjs:"] lastObject] stringByRemovingPercentEncoding];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        if(NCO(jsonData)) {
            id parameters = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers
                                                              error:&error];
            
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
        if ([Mocha_Util strContain:@"/deal.gs?" srcstring:requestString1] ||
            [Mocha_Util strContain:@"/prd.gs?" srcstring:requestString1] ||
            [Mocha_Util strContain:@"/ordSht.gs" srcstring:requestString1] ||
            [Mocha_Util strContain:@"/viewCart.gs" srcstring:requestString1] ||
            [Mocha_Util strContain:@"/mcPrdConsultRental.gs" srcstring:requestString1] ||
            [Mocha_Util strContain:@"/addOrdSht.gs" srcstring:requestString1] // 점유인증이 안된 계정의 경우 바로구매 페이지에서 알림팝업과 인증창이 뜨는 문제가 발생하여 바로구매 버튼에 대한 액션을 resultwebview로 전달. 20171024
            ) {
            
            [ApplicationDelegate directOrdOptionViewHidden];
            
            ////탭바제거
            UINavigationController * navigationController = ApplicationDelegate.mainNVC;
            ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:requestString1];
            
            if([Mocha_Util strContain:@"ordSht.gs" srcstring:requestString1]) {
                resVC.ordPass = YES;
            }
            
            if([Mocha_Util strContain:@"addOrdSht.gs" srcstring:requestString1]) {
                //생방송상품 멀티페이지에서 movetoinpage 받을경우 viewWillApper 가 먼저 체크해서 창이 닫히는 버그 막기위해 추가함
                resVC.ordPass = YES;
            }
            
            resVC.view.tag = 505;
            [navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
            isDecisionAllow = NO;
        }
    }
    
    
    //20160307 parksegun movetoinpage 이면 나를 닫고 다른 웹뷰에 URL을 호출한다.
    // 만약 page를 열수없는 상태이면 새로운 웹뷰 창을 띄운다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetoinpage"]) {
        
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        NSLog(@"movetoninpage = %@   ", [parser valueForVariable:@"url"]);
        // 인코딩
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];
        [ApplicationDelegate directOrdOptionViewHidden];
        
        ////탭바제거
        UINavigationController * navigationController = ApplicationDelegate.mainNVC;
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
        
        if([Mocha_Util strContain:@"ordSht.gs" srcstring:url]) {
            resVC.ordPass = YES;
        }
        
        resVC.view.tag = 505;
        [navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://newpage"]) {
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        // 인코딩
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];
        
        NSString *strCloseYn = @"n";
        if ([Mocha_Util strContain:@"closeYn=" srcstring:requestString1])
        {
            NSArray *arCloseYN = [requestString1 componentsSeparatedByString:@"closeYn="];
            strCloseYn = [NCS([arCloseYN objectAtIndex:1]) lowercaseString];
            strCloseYn = [strCloseYn substringToIndex:1];
        }
        
        if ([strCloseYn isEqualToString:@"y"]) {
            //[ApplicationDelegate.mainNVC  popViewControllerAnimated:NO];
            [self closeWithAnimated:NO];
        }
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
        resVC.ordPass = NO;
        resVC.view.tag = 505;
        [ApplicationDelegate.mainNVC  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        
        isDecisionAllow = NO;
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
        
        if (cookie !=nil && ([cookie.name length] > 0)) {
            
            for (NSHTTPCookie *deleteCookie in arrSharedCookie) {
                if ([[deleteCookie domain] isEqualToString:[cookie domain]] && [[deleteCookie name] isEqualToString:[cookie name]]) {
                    [sharedCookies deleteCookie:deleteCookie];
                }
            }
            
            [sharedCookies setCookie:cookie];
            
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
    webViewOption.currentDocumentURL = webView.URL.absoluteString;
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Webviewerror: %@", [error description]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    //토스트 메세지 띄우고 창닫기
    [self closeWithAnimated:NO];
    //[Mocha_ToastMessage toastWithDuration:2.0 andText:@"불러오기에 실패하였습니다." inView: ApplicationDelegate.window];
    [Toast show:0.3 andText:@"불러오기 실패했습니다."];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    //토스트 메세지 띄우고 창닫기
    [self closeWithAnimated:NO];
    [Toast show:0.3 andText:@"불러오기 실패했습니다."];
}

//javascript 함수호출
-(void)callJscriptMethod:(NSString *)mthd {
    
    [webViewOption evaluateJavaScript:mthd completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"callJscriptMethod mthd = %@",mthd);
        NSLog(@"callJscriptMethod WKresult = %@",result);
        NSLog(@"callJscriptMethod WKerror = %@",error);
        
    }];
}

- (void)closeWithAnimated:(BOOL)animated {
    
    self.frame = CGRectMake(0.0, APPFULLHEIGHT, APPFULLWIDTH, APPFULLHEIGHT);
    //self.alpha = 0.0;
    
}




- (void)openWithAnimated:(BOOL)animated withUrl:(NSString *)strUrl {
    NSLog(@"strStartUrl = %@",strStartUrl);
    strStartUrl = strUrl;
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:strStartUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    
    [self reInitWKWebView]; // 매번 초기화 한다.
    
    if(ApplicationDelegate.islogin == YES) {
        if([WKManager sharedManager].isSyncronizing == YES) {
            [ApplicationDelegate.gactivityIndicator startAnimating];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(wkSessionSuccess)
                                                         name:WKSESSION_SUCCESS
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(wkSessionFail)
                                                         name:WKSESSION_FAIL
                                                       object:nil];
            
            
        }
        else {
            [webViewOption loadRequest:requestObj];
        }
    }
    else {
        [webViewOption loadRequest:requestObj];
    }
}


//
-(void)wkSessionSuccess{
    
    [self reInitWKWebView];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:strStartUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    [webViewOption loadRequest:requestObj];
    //self.alpha = 1.0;
    //webViewOption.frame = self.frame;
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_FAIL object:nil];
    
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

-(void)wkSessionFail{
    //실패시 정의 필요함
    
    //API로그인은 됐는데 웹뷰는 안됐어!!!
    //동기화를 다시할까??
    [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
    //나를 다시 닫고
    //사용자한테 다시 시도 메세지를 띄운다.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_FAIL object:nil];
    
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    // 나를 닫음.
    [self onBtnClose:nil];
}
//



-(IBAction)onBtnClose:(id)sender {
    [self callMainCartUpdate];
    [self closeWithAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONDIRECTORDERCLOSE object:nil userInfo:nil];
}

- (NSString*) definecurrentUrlString {
    return self.curRequestString;
}

-(void)callMainCartUpdate {
    ////탭바제거
    Home_Main_ViewController * HVC =  (Home_Main_ViewController *)[[ApplicationDelegate.mainNVC viewControllers] objectAtIndex:0];
    if ( [HVC respondsToSelector:@selector(DrawCartCountstr)] && ApplicationDelegate.islogin){
        
        [[WKManager sharedManager] copyToSharedCookieName:WKCOOKIE_NAME_CART OnCompletion:^(BOOL isSuccess) {
            if (isSuccess) {
                [HVC DrawCartCountstr];
            }
        }];
    }
}

- (void) hideLoginViewController:(NSInteger)loginviewtype {
    //4=일반로그인 후 curRequestString forwarding
    //5=로그아웃 후 reloading
    //6=비회원배송조회
    //7=비회원주문
    //8=하단 옵션창

    if(loginviewtype == 4) {
    }
    else if(loginviewtype == 6) {
        //비회원배송조회
        self.curRequestString = NONMEMBERORDERLISTURL(self.curRequestString);
    }
    else if(loginviewtype == 7) {
        //비회원주문
        self.curRequestString = NONMEMBERORDERURL(self.curRequestString);
    }
    
    //꼭 딜레이 줘야함
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
}


-(void)requestWKWebviewUrlString{
    //다시
    NSURL *urlRequest = [NSURL URLWithString:self.curRequestString];
    
    if (webViewOption == nil) {
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
        config.userContentController = userContentController;
        config.processPool = [[WKManager sharedManager] getGSWKPool];
        config.allowsInlineMediaPlayback = YES;
        
        webViewOption = [[GSWKWebview alloc] initWithFrame:CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT) configuration:config];
        webViewOption.navigationDelegate = self;
        webViewOption.UIDelegate = webViewOption;
        webViewOption.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

        webViewOption.backgroundColor = UIColor.clearColor;
        [webViewOption setOpaque:NO];
        
        [self addSubview:webViewOption];
        

    }
    
    NSLog(@"[[WKManager sharedManager] getGSWKPool] = %@",[[WKManager sharedManager] getGSWKPool]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
    
    NSLog(@"\n\n\nResultWebview WKWebview Requested !!!!!!!\n\n\n");
    //NSLog(@"request.allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
    
    [webViewOption loadRequest:request];
}

@end
