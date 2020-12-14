//
//  PopupWebView.m
//  GSSHOP
//
//  Created by 조도연 on 2014. 6. 17..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "PopupWebView.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Mocha_MPViewController.h"
#import "URLParser.h"

#define VSLIDERWIDTH 30

@interface PopupWebView () <LoginViewCtrlPopDelegate>
{
    AutoLoginViewController *loginView;
    
    float resizewviewheight;
    BOOL isBtnAlphaZero;
    CGFloat prevOffsety;
    UIButton *btngoTop;
}

@property (nonatomic, strong) NSString *startURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic,strong) NSString *curRequestString;

@end



@implementation PopupWebView

@synthesize wview;
@synthesize delegate;


+ (id)openPopupWithFrame:(CGRect)aFrame
               superview:(UIView *)superview
                delegate:(id)delegate
                     url:(NSString *)urlString
                   title:(NSString *)title
                animated:(BOOL)animated
{
    PopupWebView *view = [[PopupWebView alloc] initWithURL:urlString delegate:delegate frame:aFrame title:title];
    
  
    
    view.frame = CGRectMake(0 + APPFULLWIDTH, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    [superview addSubview:view];
    
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         
                         
                     }];
    
    
    return view;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}


- (id)initWithURL:(NSString *)urlString delegate:(id)aDelegate frame:(CGRect)aFrame title:(NSString *)title
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        self.delegate = aDelegate;
        self.title = title;
        
        [self setup];
        
        resizewviewheight =0;
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                timeoutInterval:kWebviewTimeoutinterval];
        
        self.startURL = [requestObj.URL absoluteString];
        
        //for test
        NSLog(@"startURL = %@", self.startURL);
        
        [wview loadRequest:requestObj];
        
        
        
        wview.scrollView.showsVerticalScrollIndicator = NO;
        wview.scrollView.delegate = self;
        
        
        //20160705 parksegun title이 nil이면 top 버튼 노출 하지 않도록 수정
        if(self.title != nil){
        
            //UI 변경
            btngoTop = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [btngoTop setFrame:CGRectMake(self.frame.size.width-45-10, self.frame.size.height-45-10, 45, 45)];
            [btngoTop addTarget:self action:@selector(sectiongoTop) forControlEvents:UIControlEventTouchUpInside];
            [btngoTop setBackgroundImage:[UIImage imageNamed:@"bt_common_top"] forState:UIControlStateNormal] ;
            [btngoTop setBackgroundImage:[UIImage imageNamed:@"bt_common_top"] forState:UIControlStateHighlighted];
            btngoTop.alpha = 0.0f;
            [self addSubview:btngoTop];
            isBtnAlphaZero = YES;
            
            btngoTop.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            }
        
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)transparentImage
{
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return transparentImage;
}
- (void)valueDidChanged:(UISlider *)sender
{
    [self performSelectorOnMainThread:@selector(goposoffset:) withObject:sender waitUntilDone:NO  modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

-(void)goposoffset:(UISlider *)sender {
    NSLog(@"변경값: %f ======= %f === %f", sender.value, resizewviewheight, self.wview.scrollView.zoomScale);
    
    
    [self.wview.scrollView setZoomScale:1.0f animated:NO];
    CGPoint offset = self.wview.scrollView.contentOffset;
    
    float contentsize = self.wview.scrollView.contentSize.height;
    
    offset.y =  sender.value *  (contentsize - self.wview.frame.size.height);
    
    [self.wview.scrollView setContentOffset:offset animated:NO];
}
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    // 20160705 parksegun title값이 nil일 경우에만 타이틀영역을 그리지 않는다.
    if(self.title != nil)
    {
        UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, 44)];
        titleBar.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.75];
        [self addSubview:titleBar];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = [Mocha_Util getColor:@"ffffff"];
        label.text = self.title;
        [titleBar addSubview:label];
        
        // 잘 눌려지게 하려고
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(APPFULLWIDTH-34-10, 5, 34, 34);
            [button addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:button];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(APPFULLWIDTH-14-20, 15, 14, 14);
        [button setBackgroundImage:[UIImage imageNamed:@"6_floating_top_icon_close.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleBar addSubview:button];
    
    

        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContentController;
        config.processPool = [[WKManager sharedManager] getGSWKPool];
        config.allowsInlineMediaPlayback = YES;
        
        wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, self.frame.size.height - 0) configuration:config];
        wview.navigationDelegate = self;
        wview.UIDelegate = wview;
        
        //wview.scalesPageToFit = TRUE;
        //wview.dataDetectorTypes = UIDataDetectorTypeNone;
        wview.backgroundColor = [UIColor whiteColor];
        wview.opaque = YES;
        [self addSubview:wview];
        [self bringSubviewToFront:titleBar];
    }
    else
    {
        // No title
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContentController;
        config.allowsInlineMediaPlayback = YES;
        config.processPool = [[WKManager sharedManager] getGSWKPool];
        wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, self.frame.size.height - 0) configuration:config];
        wview.navigationDelegate = self;
        wview.UIDelegate = wview;
        
        //wview.scalesPageToFit = TRUE;
        
        //wview.dataDetectorTypes = UIDataDetectorTypeNone;
        wview.backgroundColor = [UIColor whiteColor];
        wview.opaque = YES;
        [self addSubview:wview];
    }
    
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchNotiCloseEvent)
                                                 name:@"customovieViewRemove"
                                               object:nil];
}


- (void)dealloc
{
    loginView = nil;
}



- (void)catchNotiCloseEvent
{
    [self closeWithAnimated:NO];
}


- (void)closeButtonClicked:(id)sender
{
    [self closeWithAnimated:YES];
}


- (void)closeWithAnimated:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"customovieViewRemove" object:nil];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
   
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         self.frame = CGRectMake(self.frame.origin.x + APPFULLWIDTH, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                     }];
    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *requestString1 = navigationAction.request.URL.absoluteString;
    NSLog(@"CHODY URL 요청: %@", requestString1);
    
    BOOL isDecisionAllow = YES;
    
    //iOS7 대응
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"gsshopmobile://"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    //PMS call protocol
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movemessage"]) {
        [ApplicationDelegate pressShowPMSLISTBOX];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://eventrecv"]) {
        NSString* tstring = [Mocha_Util strReplace:@"toapp://eventrecv?" replace:@"" string:requestString1];
        NSLog(@"etvURL: %@", [NSString stringWithFormat:@"%@&devId=%@",tstring,DEVICEUUID]);
        NSURL *evtURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&devId=%@",tstring,DEVICEUUID]];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:evtURL];
        [wview loadRequest:requestObj];
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"about:blank"]) {//공백페이지
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 isEqualToString:[NSString stringWithFormat:@"%@/",SERVERURI]]) {
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];
        isDecisionAllow =  NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 isEqualToString:[NSString stringWithFormat:@"%@",GSMAINURL]]) {
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];
        isDecisionAllow =  NO;
    }
    
    
    //트위터 외부링크
    if (isDecisionAllow == YES && [[requestString1 lowercaseString] hasPrefix:@"https://twitter.com/"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    
    // start 2012.12.20 외부 safari 웹브라우저로 띄우기 start
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://browser"]) {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"browser?"];
        NSString *toquery = [livetv lastObject];
        
        NSLog(@"toweb_query = %@",toquery);
        if( [toquery length] == NO) {
            NSLog(@"None URL... Go Homepage");
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else {
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.12.20 외부 safari 웹브라우저로 띄우기 end
    
    
    // start 2012.10.23 외부 safari 웹브라우저로 띄우기 start   (http 및 url schema대응)
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toweb://"]) {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"toweb://"];
        NSString *toquery = [livetv lastObject];
        
        NSLog(@"toweb_query = %@",toquery);
        if( [toquery length] == NO) {
            NSLog(@"None URL... Go Homepage");
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else {
            //http:// 가 있을경우 http//로 들어옴 http링크의경우만 수정, url schema 호출의경우 http 영향없음.
            toquery = [Mocha_Util strReplace:@"//" replace:@"://" string:toquery];
            
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.02.20 내장 웹브라우저로 띄우기 end
    
    
    
    
    //VOD영상 재생 - 20130102   + 딜상품 VOD영상 재생 - 20130226 + 기본 VOD영상재생(버튼overlay없음) 20150211
    if(isDecisionAllow == YES && (([requestString1 hasPrefix:@"toapp://vod?url="]) || ([requestString1 hasPrefix:@"toapp://dealvod?url="]) || ([requestString1 hasPrefix:@"toapp://basevod?url="])))    //vod 방송
    {
        
        if([NetworkManager.shared currentReachabilityStatus] == NetworkReachabilityStatusViaWiFi) {
            [self playrequestVODVideo:requestString1];
        }
        else {
            self.curRequestString = [NSString stringWithString:requestString1];
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle: DATASTREAM_ALERT
                                                           maintitle:nil
                                                            delegate:self
                                                         buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 888;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow =  NO;
    }
    
    
    
    //생방송
    if(isDecisionAllow == YES && (([requestString1 hasPrefix:@"toapp://liveBroadUrl?param="]) ||
       ([requestString1 hasPrefix:@"toApp://liveBroadUrl?param="])))  //live 방송
    {
        
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query3 = [livetv lastObject];
        NSLog(@"moviePlay = %@",query3);
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestLiveVideo:query3];
        }
        else {
            self.curRequestString = [NSString stringWithString:query3];
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:DATASTREAM_ALERT
                                                           maintitle:nil
                                                            delegate:self
                                                         buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 777;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow =  NO;
    }
    
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://back"]) {//폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
        NSArray *comp = [requestString1 componentsSeparatedByString:@"//"];
        NSString *query1 = [comp lastObject];
        if([query1 isEqualToString:@"back"]) {
            if([wview canGoBack]) {
                [wview goBack];
            }
            else {
                //빙글빙글 계속 돌고 있어서
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [ApplicationDelegate.gactivityIndicator stopAnimating];
                [self closeWithAnimated:YES];
            }
        }
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://close"]) {//폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
        [self closeWithAnimated:YES];
        isDecisionAllow = NO;
    }
        
    //로그인이 필요한 페이지는 로그인을 하고 페이지를 넘긴다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGINCHECKURL]) {
        //웹뷰가 toapp://login 호출할경우 기존에 로그인이 되어있으면 API로그아웃이 "아닌" APPJS 방식 로그아웃 호출
        if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
            NSLog(@"이전 로그인 로그아웃 호출");
            [ApplicationDelegate appjsProcLogout:nil];
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
        
        loginView.view.hidden=NO;
        ////탭바제거
        
        // 중복호출 및 Crash 방지
        @try {
            if([[ApplicationDelegate.mainNVC.viewControllers objectAtIndex:0] isKindOfClass:[AutoLoginViewController class]] == NO)
            {
                [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:loginView];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
//        [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:loginView];
        
        //20170615점유인증 & 회원 간소화
        if([Mocha_Util strContain:@"msg=" srcstring:requestString1]){
            
            NSArray *msgTemp = [requestString1 componentsSeparatedByString:@"msg="];
            
            if( [msgTemp count] > 1 ) {
                NSArray *idTemp = [NCS([msgTemp objectAtIndex:1]) componentsSeparatedByString:@"&"];
                if( [idTemp count] > 0) {
                    loginView.textFieldId.text = NCS([idTemp objectAtIndex:0]);
                }
            }
        }

        isDecisionAllow = NO;
    }
    
    
    //로그아웃 요청URL
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGOUTTOAPPURL]) {
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        if([query2 isEqualToString:@""]){
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
        }
        else {
            self.curRequestString = [NSString stringWithString:query2];
        }
        NSLog(@"self.curRequestString = %@", self.curRequestString);
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:LOGOUTALERTALSTR
                                                       maintitle:nil
                                                        delegate:self
                                                     buttonTitle:[NSArray arrayWithObjects:LOGOUTCONFIRMSTR1,  LOGOUTCONFIRMSTR2, nil]];
        malert.tag = 444;
        [self addSubview:malert];
        isDecisionAllow = NO;
    }
    
    
    // -- start -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- start --
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"tel:"]) {
        NSString* tstring = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:requestString1];
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:tstring] ];
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"mailto:"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    // -- end -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- end --
    
    
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

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //중요 웹뷰 네비게이션 및 속도 체크중. - IOS5 버전이하 cangback 꼬이는 문제로 사용않함
    //animationwithDuration 을 runloop free상태에서 사용하는 이유 -thread관리 - 제외시 앱다운유발가능.
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                     }
     
                     completion:^(BOOL finished){
                         
                         
                         [ApplicationDelegate.gactivityIndicator startAnimating];
                         
                     }];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)))
    {
        if(error.code != 101)
        {
            Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GNET_UNSTABLE maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            
            [ApplicationDelegate.window addSubview:malert];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)))
    {
        if(error.code != 101)
        {
            Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GNET_UNSTABLE maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            
            [ApplicationDelegate.window addSubview:malert];
        }
    }
}

- (NSString*) definecurrentUrlString {
    return self.curRequestString;
}


- (void) hideLoginViewController:(NSInteger)loginviewtype
{
    //4=일반로그인 후 curRequestString forwarding
    //5=로그아웃 후 reloading
    //6=비회원배송조회
    //7=비회원주문
    
    
    if(loginviewtype == 4)
    {
        NSURL *videoURL = [NSURL URLWithString:self.curRequestString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        [wview loadRequest:requestObj];
    }
    else if(loginviewtype == 6)
    {
        //비회원배송조회
        NSURL *videoURL = [NSURL URLWithString: NONMEMBERORDERLISTURL(self.curRequestString)];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        [wview loadRequest:requestObj];
    }
    else if(loginviewtype == 7)
    {
        //비회원주문
        NSURL *videoURL = [NSURL URLWithString:NONMEMBERORDERURL(self.curRequestString)];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        [wview loadRequest:requestObj];
    }
    
    else if(loginviewtype == 2)
    {
        //성인인증인 경우 webview history 한번더 뒤로~
        if([wview canGoBack]) {
            NSLog(@"캔고백");
            
            [wview goBack];
            
        }
        
    }
    
    else {
        //로그아웃  loginviewtype == 5 인경우
        [wview reload];
    }
}


-(void)goJoinPage
{
    NSURL *goURL = [NSURL URLWithString:JOINURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
    
    [wview loadRequest:requestObj];
}

//isp 처리후 다시 넘어 왔을때 넘어온 주소를 가지고 웹뷰로 다시 넘긴다.
- (void) ispResultWeb:(NSString *)url
{
    NSLog(@"__________urlString = %@ ",url);
    
    NSURL *videoURL = [NSURL URLWithString:url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    [wview loadRequest:requestObj];
    [wview reload];
}


//isp 처리후 다시 넘어 왔을때 넘어온 주소를 가지고 웹뷰로 다시 넘긴다.
-(void)goWebView:(NSString *)url
{
    NSLog(@"gsurl = %@",url);
    
    NSURL *goURL = [NSURL URLWithString:url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
    [wview loadRequest:requestObj];
}


- (void)webViewReload
{
    [wview reload];
}



#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 444) {
        switch (index) {
            case 1:
                //로그아웃? 예
                
                
                //로그아웃 한 다음 url을 가지고 다시 webview로 넘긴다.
                if(loginView == nil) {
                    loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                }else{
                    [loginView clearTextFields];
                }
                
                loginView.delegate = self;
                loginView.loginViewType = 5;
                
                loginView.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
                
                loginView.isLogining = YES;
                [loginView goLogin];
                loginView.view.hidden=YES;
                
                break;
            default:
                break;
        }
    }
    
    else if(alert.tag == 777) {
        switch (index) {
            case 1:
                //생방송 영상재생? 예
                [self playrequestLiveVideo:self.curRequestString];
                break;
            default:
                break;
        }
    }
    
    else if(alert.tag == 888) {
        switch (index) {
            case 1:
                //단품 VOD 재생? 예
                [self playrequestVODVideo:self.curRequestString];
                break;
            default:
                break;
        }
    }
}






//생방송 재생
-(void)playrequestLiveVideo: (NSString*)requrl
{
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:nil];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    
    [vc playMovie:[NSURL URLWithString:requrl]];
}


//단품 VOD 재생
-(void)playrequestVODVideo:(NSString*)requrl
{
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    
    
    // check 후 call
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    URLParser *parser = [[URLParser alloc] initWithURLString:requrl];
    
    if ([Mocha_Util strContain:@"videoid" srcstring:requrl] && [NCS([parser valueForVariable:@"videoid"]) length] > 4 ) {
        NSLog(@"videoid: %@",[parser valueForVariable:@"videoid"]);
        [vc playBrightCoveWithID:NCS([parser valueForVariable:@"videoid"])];
    }else{
        [vc playMovie:[NSURL URLWithString:[parser valueForVariable:@"url"]]];
    }
}




-(void)sectiongoTop {
    
    CGPoint offset = self.wview.scrollView.contentOffset;
    offset.y = 0.0f;
    [self.wview.scrollView setContentOffset:offset animated:YES];
    
    
}
-(void)alphaDownTopButton{
    if (isBtnAlphaZero == YES) {
        return;
    }else{
        
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             btngoTop.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             
                             isBtnAlphaZero = YES;
                         }];
        
        
    }
    
}

-(void)alphaUpTopButton{
    if (isBtnAlphaZero == NO) {
        return;
    }else{
        
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             btngoTop.alpha = 0.8;
                         }
                         completion:^(BOOL finished) {
                             
                             isBtnAlphaZero = NO;
                         }];
        
        
    }
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if(scrollView.contentOffset.y > 100) {
        [self alphaUpTopButton];
    }else {
        [self alphaDownTopButton];
        
    }
    
        
    
}





@end
