//
//  ResultWebViewController.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 29..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "ResultWebViewController.h"
#import "URLDefine.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DataManager.h"
#import "Mocha_MPViewController.h"
#import "Common_Util.h"
#import "URLParser.h"

#import "LiveTalkViewController.h"
#import "GSMediaUploader.h"
#import "SNSManager.h"

#import "HeaderWebViewController.h"
#import <Photos/Photos.h>
#import "MobileLiveViewController.h"
#import <AirBridge/AirBridge.h>


@implementation ResultWebViewController

@synthesize urlString;
@synthesize curRequestString;
@synthesize delegate;
@synthesize popupWebView;
@synthesize popupAttachView;
@synthesize ordPass;
@synthesize wview,curUrlUse,isDealAndPrd;

#pragma mark -
#pragma mark 액티비티 인디케이터(로딩)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        abNomalCount = 0;
        isShowing = NO;
    }
    return self;
}

-(id)initWithUrlString:(NSString *)url {
    self = [super init];
    if(self != nil) {
        self.ordPass = NO;
        self.curUrlUse = NO;
        //첫 진입이 딜,단품 로딩할때 문제가 발생할수 있다...
        if ([url length] > 0 && ([url rangeOfString:@"/deal.gs?"].location != NSNotFound || [url rangeOfString:@"/prd.gs?"].location != NSNotFound) && self.isDealAndPrd == NO) {
            self.isDealAndPrd = YES;
            
        }
        else {
            self.isDealAndPrd = NO;
            
        }
        NSLog(@" set url: %@",url);
        NSString *itemString = [Mocha_Util strReplace:@" " replace:@"" string:url];
        ////////////////
        // nami0342 - 동일 도메인 들어올 경우 처리
        NSArray *arSamedomain = [itemString componentsSeparatedByString:@"http://m.gsshop.comhttp://m.gsshop.com"];
        if([arSamedomain count] > 1) {
            itemString = [itemString stringByReplacingOccurrencesOfString:@"http://m.gsshop.comhttp://m.gsshop.com" withString:@"http://m.gsshop.com"];
        }
        ////////////////
        //self.urlString = @"http://m.gsshop.com/jsp/jseis_withLGeshop.jsp?media=LIb&ch_id=PU&p_id=202031700902&gourl=http://m.gsshop.com/prd/prd.gs?prdid=36919901&p=202031700902";//itemString;
        
        self.urlString = itemString;//
        self.isNativePassUrl = [[self.urlString lowercaseString] containsString:@"isweb=y"]?YES:NO;
        
        
//        NSData *test = [self.urlString dataUsingEncoding:NSUTF8StringEncoding];
//        NSLog(@"[test hexadecimalString] = %@",[test base16Encoding]);
    }
    return self;
}

-(id)initWithUrlString:(NSString *)url methodPost:(BOOL)isPost{
    self.isPostRequest = isPost;
    return [self initWithUrlString:url];
}

-(id)initWithUrlStringByNoTab:(NSString *)url {
    noTab = NoTAB;
    return [self initWithUrlString:url];
}

- (void)dealloc {
    // nami0342
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ApplicationDelegate offloadingindicator];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self ];
    NSLog(@"resultWebview!!!!!!! dealloc =%@",self);
    if ([self isViewLoaded]) {
        [self.wview removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    [self removeAllObject];
    self.wview.UIDelegate = nil;
    self.wview.navigationDelegate = nil;
    self.wview.scrollView.delegate = nil;
    self.wview = nil;
    loginView = nil;
    self.popupWebView = nil;
    self.popupAttachView = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)removeAllObject{
    [self.wview stopLoading];
    if (self.wview.viewHeader != nil) {
        [self.wview.viewHeader removeMiniPlayerView];
        
        [self.wview.viewHeader viewDidDisappear];
        self.wview.viewHeader.aTarget = nil;
        [self.wview.viewHeader removeFromSuperview];
        self.wview.viewHeader = nil;
        self.webPrdNaviBarView.aTarget = nil;
        [self.webPrdNaviBarView removeFromSuperview];
        self.webPrdNaviBarView = nil;
        
        [self.wview removeFromSuperview];
        @try{
           [self.wview removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
        }@catch(id anException){
           NSLog(@"self.wview observer doesn't have");
        }
        // nami0342 - Remove script handler
        [self.wview.configuration.userContentController removeScriptMessageHandlerForName:@"iOSScript"];
        self.wview.UIDelegate = nil;
        self.wview.navigationDelegate = nil;
        self.wview.scrollView.delegate = nil;
        self.wview = nil;
    }
    
    NSLog(@"removeAllObject =%@",self);
    NSLog(@"self.view.subviews =%@",self.view.subviews);
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[ApplicationDelegate.HMV showTabbarView];
    if(self.wview != nil) {
        [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:wview.URL.absoluteString];
    }
    //20160323 parksegun 키보드 처리용
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeaderCartCount) name:PRODUCT_NATIVE_CARTUPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSound) name:GS_GLOBAL_SOUND_CHANGE object:nil];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    firstLoading = YES;
    
    if ([@"Y" isEqualToString:PRD_NATIVE_YN] && self.isNativePassUrl == NO) {
        [self checkAndDrawPreloadHeaderL1:self.urlString];
    }
    [self requestWKcall];
}

// nami0342 - Webview 닫기
- (void) closeWebView
{
    // 나를 닫음.
    [self removeAllObject];
    [self.navigationController popViewControllerMoveInFromTop];
}

- (void) requestWKcall {
    if(ApplicationDelegate.islogin == YES) {
        if([WKManager sharedManager].isSyncronizing == YES) {
            //기다려야해~
            if(self.wview.viewHeader != nil) {
                [ApplicationDelegate.gactivityIndicator isDownLoding];
            }
            [ApplicationDelegate.gactivityIndicator startAnimating];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(wkSessionSuccess)
                                                         name:WKSESSION_SUCCESS
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(wkSessionFail)
                                                         name:WKSESSION_FAIL
                                                       object:nil];
            return;
        }
        else {
            [self requestWKWebviewUrlString];
        }
    }
    else {
        [self requestWKWebviewUrlString];
    }
}

-(void)popSelfAndPushNewVC{
    [self removeAllObject];
    [ApplicationDelegate.mainNVC  popViewControllerAnimated:NO];
    ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:self.curRequestString methodPost:YES];
    resVC.ordPass = NO;
    resVC.view.tag = 505;
    [ApplicationDelegate.mainNVC  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
    
}


-(void)clearWebView{
    // 기존 풀에 연결된 애를 날려버리자.
    if (self.wview != nil) {
        [self.wview removeFromSuperview];
        [self.wview removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
        // nami0342 - Remove script handler
        [self.wview.configuration.userContentController removeScriptMessageHandlerForName:@"iOSScript"];
        self.wview.UIDelegate = nil;
        self.wview.navigationDelegate = nil;
        self.wview.scrollView.delegate = nil;
        self.wview = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_FAIL object:nil];
    
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}
//
-(void)wkSessionSuccess{
    
    [self clearWebView];
    
    [self requestWKWebviewUrlString];
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
    [self removeAllObject];
    [self.navigationController popViewControllerMoveInFromTop];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
    
    
    //로그인창 띄웠다 빽해버리면 문제발생

    // 단품 네이티브 영역 deallock
    if (self.viewHeader != nil) {
        [self.viewHeader viewDidDisappear];
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    isShowing = YES;
    
    //현재 떠있는 웹뷰에 흰화면이면.. back... 혹은 닫기
    NSLog(@"나는 누구인가?: %@",wview.URL.absoluteString);
    //웹 쿠키 동기화후 카운트 변경
    [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
        if(isSuccess) {
            //네이티브 이면 상단에 장바구니 갱신
            if(self.webPrdNaviBarView != nil && [@"Y" isEqualToString:PRD_NATIVE_YN] && self.isNativePassUrl == NO) {
                [self.webPrdNaviBarView didDoneLogin];
            }
        }
    }];
    
    
    if([Common_Util checkBlankWebView:self.wview urlUse:self.curUrlUse]) {
        if([self.wview canGoBack]) {
            [self.wview goBack]; // 뒤로가면 단품이 있을꺼란 기대..
        }
        else {
            [self removeAllObject];
            [self.navigationController popViewControllerMoveInFromTop];
        }
    }
    
    //딜,단품 네이티브 적용시 전용 제거하기 기능
    if([Mocha_Util strContain:@"/member/adultCheck.gs?" srcstring:NCS(self.wview.URL.absoluteString)] && [PRD_NATIVE_YN isEqualToString:@"Y"] && self.isNativePassUrl == NO) {
        if([self.wview canGoBack]) {
            [self.wview goBack]; // 뒤로가면 단품이 있을꺼란 기대..
        }
        else {
            [self removeAllObject];
            [self.navigationController popViewControllerMoveInFromTop];
        }
    }
    
    
    
    if(self.curUrlUse == YES) {
        self.curUrlUse = NO;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    //딜, 단품 floating 처리 -> 하단탭 노출여부
    [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:wview.URL.absoluteString];
    
    if( self.wview.parentViewController == nil) {
        self.wview.parentViewController = self;
    }
    
    // nami0342 - Add script handler
    if(self.wview.configuration.userContentController != nil)
    {
        
        [self.wview.configuration.userContentController removeScriptMessageHandlerForName:@"iOSScript"];
        [self.wview.configuration.userContentController addScriptMessageHandler:self name:@"iOSScript"];
    }
    
    // 단품 네이티브
    if (self.wview.viewHeader != nil ) {
        [self.wview.viewHeader viewWillAppear];
    }
    
    // 하단 탭바 처리 로직 추가
    if ([@"Y" isEqualToString:PRD_NATIVE_YN ] && self.viewHeader != nil && self.isNativePassUrl == NO) {
        
        if(wview.URL.absoluteString != nil) {
            [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:wview.URL.absoluteString];
        }
        else {
            ApplicationDelegate.HMV.tabBarView.hidden = YES;
        }
    }
    else {
        if (self.isNativePassUrl == YES) {
            if( ([PRODUCT_NATIVE_BOTTOM_URL isEqualToString:self.wview.URL.path] || [@"/prd/prd.gs" isEqualToString:self.wview.URL.path] || [DEAL_NATIVE_BOTTOM_URL isEqualToString:self.wview.URL.path] || [@"/deal/deal.gs" isEqualToString:self.wview.URL.path] )) {
                ApplicationDelegate.HMV.tabBarView.hidden = YES;
            }
        }
        else {
            [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:wview.URL.absoluteString];
            
        }
    }

}


//20160323 parksegun iOS8에서 키보드의 Forword, back 키로 인해 셀렉트박스 이동시 앱이 크래시됨. 이를 막고자 해당 버튼 쩨거 로직 추가
- (void)keyboardDidShow {
    
    //iPad에 iOS8 이면.. 실행 아니면 실행하지 않음
    NSLog(@"OS Version: %f : %@",[[[UIDevice currentDevice] systemVersion] floatValue] , [UIDevice currentDevice].deviceModelName);
    NSLog(@"OS Version: %f : %@",floor([[[UIDevice currentDevice] systemVersion] floatValue])  , [Mocha_Util strContain:@"iPad" srcstring:[UIDevice currentDevice].deviceModelName] ? @"Y" :@"N");
    if (!(floor([[[UIDevice currentDevice] systemVersion] floatValue]) == 8 && [Mocha_Util strContain:@"iPad" srcstring:[UIDevice currentDevice].deviceModelName])){
        return;
    }
    
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if (![[testWindow class] isEqual : [UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    // Locate UIWebFormView.
    for (UIView *possibleFormView in [keyboardWindow subviews]) {
        
        if ([[possibleFormView description] hasPrefix : @"<UIInputSetContainerView"]) {
            for (UIView* peripheralView in possibleFormView.subviews) {
                
                for (UIView* peripheralView_sub in peripheralView.subviews) {
                    
                    
                    // hides the backdrop (iOS 8)
                    if ([[peripheralView_sub description] hasPrefix : @"<UIKBInputBackdropView"] && peripheralView_sub.frame.size.height == 44) {
                        [[peripheralView_sub layer] setOpacity : 0.0];
                        
                    }
                    // hides the accessory bar
                    if ([[peripheralView_sub description] hasPrefix : @"<UIWebFormAccessory"]) {
                        
                        
                        for (UIView* UIInputViewContent_sub in peripheralView_sub.subviews) {
                            
                            CGRect frame1 = UIInputViewContent_sub.frame;
                            frame1.size.height = 0;
                            peripheralView_sub.frame = frame1;
                            UIInputViewContent_sub.frame = frame1;
                            [[peripheralView_sub layer] setOpacity : 0.0];
                            
                        }
                        
                        CGRect viewBounds = peripheralView_sub.frame;
                        viewBounds.size.height = 0;
                        peripheralView_sub.frame = viewBounds;
                        
                    }
                }
                
            }
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:NO];
    
    isShowing = NO;
    
    if(self.wview != nil) {
        self.wview.parentViewController = nil;
    }
    
    // nami0342 - Remove script handler
    if(self.wview.configuration.userContentController != nil)
    {
        [self.wview.configuration.userContentController removeScriptMessageHandlerForName:@"iOSScript"];
    }
}

- (void)webViewReload {
    NSLog(@"asdfkasjflkasjflaskdjf: %@",self.wview.URL.absoluteString);
    NSLog(@"self.curRequestString: %@", self.curRequestString);
    NSLog(@"urlString: %@", self.urlString);
    if([Mocha_Util strContain:@"ordSht.gs?" srcstring:self.urlString] ||
       [Mocha_Util strContain:@"/member/certifyNoMember.gs?" srcstring:self.urlString] ||
       [Mocha_Util strContain:@"addBasketForward.gs?" srcstring:self.urlString] ) {
        
        //
        if([Mocha_Util strContain:@"ordSht.gs?" srcstring:self.urlString] == YES)
        {
            ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = NO;
        }
        NSMutableArray *arrVC = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        [arrVC removeObject:self];
        [self.navigationController setViewControllers:arrVC];
        return;
    }
    [self.wview reload];
}


- (BOOL)shouldAutorotate {
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}



-(void)requestWKWebviewUrlString {
    
    NSLog(@"");
    //https://stackoverflow.com/questions/26573137/can-i-set-the-cookies-to-be-used-by-a-wkwebview/26577303#26577303
    //self.urlString = @"http://m.hnsmall.com/goods/view/13490137";
    //    self.urlString = @"http://10.52.164.237/test/app/appjs.html";
    
    NSLog(@"self.urlString = %@",self.urlString);

    if (([NCS(self.urlString) containsString:@"com/prd/prd.gs"] || [NCS(self.urlString) containsString:@"com/deal/deal.gs"])) {
        NSString *strADID = [Common_Util getAppleADID];
        NSURLComponents *components = [NSURLComponents componentsWithString:self.urlString];
        NSURLQueryItem * newAdidQueryItem = [[NSURLQueryItem alloc] initWithName:@"adid" value:strADID];
        NSMutableArray * newQueryItems = [NSMutableArray arrayWithCapacity:[components.queryItems count] + 1];
        for (NSURLQueryItem * qi in components.queryItems) {
            if (![qi.name isEqual:newAdidQueryItem.name]) {
                [newQueryItems addObject:qi];
            }
        }
        [newQueryItems addObject:newAdidQueryItem];
        [components setQueryItems:newQueryItems];
        self.urlString = components.string;
    }
    
    NSURL *urlRequest = [NSURL URLWithString:self.urlString];
    
//    #if DEBUG
//        if ([self.urlString componentsSeparatedByString:urlRequest.host]) {
//            NSArray *arrtt = [self.urlString componentsSeparatedByString:urlRequest.host];
//            NSString *str = [NSString stringWithFormat:@"%@%@%@",[arrtt objectAtIndex:0],SERVERMAINDOMAIN,[arrtt objectAtIndex:1]];
//        }
//    #endif


    
    NSLog(@"urlRequest = %@",urlRequest);
    
    if ([NCS(urlRequest.absoluteString) isEqualToString:@""] ) {
        
        Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"linkUrl_Error_text") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        alt.tag = 222;
        [ApplicationDelegate.window addSubview:alt];
        return;
    }
    
    
    if (self.wview == nil) {
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [userContentController addScriptMessageHandler:self name:@"iOSScript"];
        [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
        config.userContentController = userContentController;
        config.allowsInlineMediaPlayback = YES;
        config.processPool = [[WKManager sharedManager] getGSWKPool];
        self.wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH, APPFULLHEIGHT - APPTABBARHEIGHT - STATUSBAR_HEIGHT) configuration:config];
        
        
        //        self.wview = [[NSTWKWebViewWarmuper sharedViewWarmuper] dequeueWarmupedWKWebView];
        //        self.wview.frame = CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH, APPFULLHEIGHT - APPTABBARHEIGHT - STATUSBAR_HEIGHT);
        
        self.wview.navigationDelegate = self;
        self.wview.UIDelegate = self.wview;
        self.wview.scrollView.delegate = self;
        self.wview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.wview addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
        
        if ([@"Y" isEqualToString:PRD_NATIVE_YN ] && self.viewHeader != nil && self.isNativePassUrl == NO) {
            if(isShowing) {
                ApplicationDelegate.HMV.tabBarView.hidden = YES;
            }

            self.curUrlUse = YES;
            [self.view insertSubview:self.wview atIndex:1];
            [self.wview setOpaque:NO];
            
            urlRequest = nil;
            
            self.wview.frame = CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT);
            NSLog(@"시간시간시간:API호출 전");
            [self callWebViewHeaderAPI:self.urlString isCookieSync:NO OnCompletion:^(NSDictionary *dicApiResult) {
                NSLog(@"시간시간시간:API호출 직후");
                // 성인 상품인지 체크
                NSString *adultYn = NCS([dicApiResult objectForKey:@"checkAdultPrdYN"]);
                if ([@"N" isEqualToString:adultYn]) {
                    
                    if ([Common_Util isthisAdultCerted] == NO) {
                        NSString *adultUrl = NCS([dicApiResult objectForKey:@"adultCertRetUrl"]);
                        
                        NSData *encodeUrl = [self.urlString dataUsingEncoding:NSUTF8StringEncoding];
                        NSString *goAdultUrl =  [NSString stringWithFormat:@"%@%@&fromApp=Y",adultUrl, [encodeUrl base16Encoding]];
                        
                        [self didFailAPICall:goAdultUrl];
                        return;
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    if (self.viewHeader != nil) {
                        self.wview.viewHeader = self.viewHeader;
                    }
                    //NSLog(@"self.dicHeaderself.dicHeader = %@",self.dicHeader);
                
                    if (self.dicHeader != nil) {
                        //받아서 높이 계산후 넘긴다 일단 하드코딩
                            self.headerHeight = (long)APPFULLWIDTH;
                        NSLog(@"시간시간시간:에드해더시작");
                            [self.wview addHeaderViewWithResult:self.dicHeader andNavigationDelegate:self andFrame:CGRectMake(0, 0, APPFULLWIDTH, self.headerHeight)];
                            [self drawWebViewHeaderNavigationBar:self.dicHeader];
                            
                            NSLog(@"self.headerHeight = %f",self.headerHeight);
                        NSLog(@"시간시간시간:에드해더끝");
                    }
                    
                    NSLog(@"시간시간시간:본문후리기시작");
                    self.urlString = [self changeNativeProductURL:self.urlString];
                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
                    if (self.isPostRequest == YES) {
                        [request setHTTPMethod:@"POST"];
                        self.isPostRequest = NO;
                    }
                    [self.wview loadRequest:request];
                    self.loadHTMLStart = CACurrentMediaTime();

                });
            } onError:^(NSError *error) {
                if (error != nil) {
                    NSLog(@"error = %@",error);
                }else{
                    //애러 못받아왔으면 통신은 성공했는데 json 데이터가 이상한것
                }
                
                [self didFailAPICall:self.urlString];
                
            }];
            
            
        }else{
            [self.wview setOpaque:YES];
            [self.view addSubview:self.wview];
        }
    }
    
    //NSLog(@"노탭?: %ld",self.view.tag);
    //20190319 parksegun 노탭 설정
    if(noTab == NoTAB) {
        [self.wview setNoTab:YES];
    }
    else {
        [self.wview setNoTab:NO];
    }
    
    NSLog(@"[[WKManager sharedManager] getGSWKPool] = %@",[[WKManager sharedManager] getGSWKPool]);
    
    
    if (urlRequest != nil) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
        
        
        NSLog(@"requestreques = %@",request);
        NSLog(@"\n\n\nResultWebview WKWebview Requested !!!!!!!\n\n\n");
        //NSLog(@"request.allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
        
        if (self.isPostRequest == YES) {
            [request setHTTPMethod:@"POST"];
            self.isPostRequest = NO;
        }
        [self.wview loadRequest:request];
        self.loadHTMLStart = CACurrentMediaTime();
        
        
    }
    
    
//    UIButton *btnContact = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnContact.titleLabel.text = @"연락처 호출";
//    btnContact.backgroundColor = [UIColor redColor];
//    [btnContact addTarget:self action:@selector(callContactViewController) forControlEvents:UIControlEventTouchUpInside];
//    btnContact.frame = CGRectMake(200.0, 200.0, 40.0, 30.0);
//    [self.view addSubview:btnContact];
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
    
    //로그인 성공후 빽시킬때 백화상태일경우 유지후 URL이동
    
    NSLog(@"loginviewtype = %ld",(long)loginviewtype);
    NSLog(@"self.curRequestString = %@",self.curRequestString);
    
    
    //curRequestString 사용하였음..
    //20160407 parksegun 로그인뷰가 닫히면서 현재 웹뷰에 이동이 발생하는지 체크하는 플래그 처리
    self.curUrlUse = YES;
    //self.isPassFirst = YES;
    
    if(loginviewtype == 4)
    {
        self.urlString = self.curRequestString;
        //꼭 딜레이 줘야함
        
        if (([@"Y" isEqualToString:PRD_NATIVE_YN] && self.isNativePassUrl == NO) && ([NCS(self.wview.URL.absoluteString) containsString:DEAL_NATIVE_BOTTOM_URL] || [NCS(self.wview.URL.absoluteString) containsString:PRODUCT_NATIVE_BOTTOM_URL]) && ([NCS(self.curRequestString) containsString:@"com/prd/prd.gs"] || [NCS(self.curRequestString) containsString:@"com/deal/deal.gs"]) ) {
            
            NSURL *urlCheckBase = [NSURL URLWithString:NCS(self.wview.URL.absoluteString)];
            URLParser *parserBase = [[URLParser alloc] initWithURLString:self.wview.URL.absoluteString];
            URLParser *parserMoveTo = [[URLParser alloc] initWithURLString:NCS(self.urlString)];
            
            BOOL isSame = NO;
            
            if ([urlCheckBase.query containsString:@"prdid="]) {
                if ([NCS([parserBase valueForVariable:@"prdid"]) isEqualToString:NCS([parserMoveTo valueForVariable:@"prdid"])]) {
                    isSame = YES;
                }
                
            }else if ([urlCheckBase.query containsString:@"dealNo="]){
                if ([NCS([parserBase valueForVariable:@"dealNo"]) isEqualToString:NCS([parserMoveTo valueForVariable:@"dealNo"])]) {
                    isSame = YES;
                }
            }
            
            if (isSame) {
                [self removeAllObject];
                if (self.viewHeader != nil) {
                    [self.viewHeader removeFromSuperview];
                    self.viewHeader = nil;
                }
                
                [self checkAndDrawPreloadHeaderL1:self.urlString];
                [self clearWebView];
                
            }
        }
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKcall) userInfo:nil repeats:NO];
        //[ApplicationDelegate.HMV performSelector:@selector(moveWebViewStrUrl:) withObject:self.self.curRequestString afterDelay:1.0f];
        //[ApplicationDelegate.HMV goWebView:self.curRequestString];
        //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
    }
    else if(loginviewtype == 6)
    {
        /*
         //비회원배송조회
         NSURL *videoURL = [NSURL URLWithString: NONMEMBERORDERLISTURL(self.curRequestString)];
         NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
         [wview loadRequest:requestObj];
         */
        
        self.urlString = NONMEMBERORDERLISTURL(self.curRequestString);
        //꼭 딜레이 줘야함
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKcall) userInfo:nil repeats:NO];
        
    }
    else if(loginviewtype == 7)
    {
        //비회원주문
        /*
         NSLog(@" %@",NONMEMBERORDERURL(self.curRequestString));
         
         NSURL *videoURL = [NSURL URLWithString:NONMEMBERORDERURL(self.curRequestString)];
         
         NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
         
         [wview loadRequest:requestObj];
         */
        self.urlString = NONMEMBERORDERURL(self.curRequestString);
        //꼭 딜레이 줘야함
        self.curUrlUse = YES;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKcall) userInfo:nil repeats:NO];
    }
    
    else if(loginviewtype == 2)
    {
        //성인인증인 경우 webview history 한번더 뒤로~
        if([self.wview canGoBack]) {
            [self.wview goBack];
            
        }else {
            //돌아갈곳이 없다면 홈으로
            [self removeAllObject];
            [self.navigationController popViewControllerMoveInFromTop];
        }
        
    }
    
    else {
        //로그아웃  loginviewtype == 5 인경우
        [self.wview reload];
        
        
    }
    
    
    
    
}

-(void)goJoinPage {
    
    NSURL *goURL = [NSURL URLWithString:JOINURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
    
    [self.wview loadRequest:requestObj];
    
    
}


//isp 처리후 다시 넘어 왔을때 넘어온 주소를 가지고 웹뷰로 다시 넘긴다.
- (void) ispResultWeb:(NSString *)url
{
    NSLog(@"__________urlString = %@ ",url);
    
    NSURL *videoURL = [NSURL URLWithString:url];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    
    [self.wview loadRequest:requestObj];
    [self.wview reload];
    
}

-(void)goWebView:(NSString *)url {
    // 현재 창이 단품네이티브인데.. 검색이 들어오면 새창
    NSLog(@"self.urlString %@",self.urlString);
    // /prd/prdBottomApp.gs
    // /prd.gs?
    if(([@"Y" isEqualToString:PRD_NATIVE_YN] && self.isNativePassUrl == NO) && ([self.urlString containsString:PRODUCT_NATIVE_BOTTOM_URL] || [self.urlString containsString:@"/prd.gs?"] || [self.urlString containsString:DEAL_NATIVE_BOTTOM_URL] || [self.urlString containsString:@"/deal.gs?"] ) ) {
        ResultWebViewController *resVC = [[ResultWebViewController alloc] initWithUrlString:url];
        [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
    }
    else {
        self.urlString = url;
        //꼭 딜레이 줘야함
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKcall) userInfo:nil repeats:NO];
    }
}

//javascript 함수호출
-(void)callJscriptMethod:(NSString *)mthd {
    
    [self.wview evaluateJavaScript:mthd completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"callJscriptMethod mthd = %@",mthd);
        NSLog(@"callJscriptMethod WKresult = %@",result);
        NSLog(@"callJscriptMethod WKerror = %@",error);
    }];
}


//String을 분석하여 스크립트 호출과 url 실행을 구분한다. 무조건 새창
- (void)dealPrdUrlAction:(NSString *) urlString withParam:(NSString*) param loginCheck:(BOOL)isLogin{
    
    if (isLogin == true && ApplicationDelegate.islogin == NO) {
        if(loginView == nil) {
            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
        }else{
            [loginView clearTextFields];
        }
        
        loginView.delegate = self;
        loginView.loginViewType = 10;// 별도 정의된것은 없지만 로그인후 hideLogin 부분에서 이 창을 리로드 시키기위해 선언
        loginView.loginViewMode = 0;
        loginView.view.hidden=NO;
        
        // 중복호출 및 Crash 방지
        @try {
            if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[AutoLoginViewController class]] == NO)
            {
                [self.navigationController pushViewControllerMoveInFromBottom:loginView];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    }else{
        NSLog(@"isClickedWebPrdView = %d",isClickedWebPrdView);
        
        if([urlString containsString:@"javascript:"] && isClickedWebPrdView == NO) {
            NSString *jMethod = [urlString stringByReplacingOccurrencesOfString:@"javascript:" withString:@""];
            if([jMethod containsString:@"<param>"] && NCS(param).length > 0) {
                jMethod = [jMethod stringByReplacingOccurrencesOfString:@"<param>" withString:NCS(param)];
            }
            //[self callJscriptMethod:jMethod];
            //리턴받아서 체크해야함으로 직접처리하도록 수정
            
            isClickedWebPrdView = YES;
            [self.wview evaluateJavaScript:jMethod completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                
                NSLog(@"callJscriptMethod mthd = %@",jMethod);
                NSLog(@"callJscriptMethod WKresult = %@",result);
                NSLog(@"callJscriptMethod WKerror = %@",error);
                isClickedWebPrdView = NO;
            }];
            
        }
        else if([urlString containsString:@"http"]) {
            //새창 띄우기
            //처리가 불가능한 녀석이면??? 새로띄움
            ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:urlString];
            resVC.ordPass = NO;
            resVC.view.tag = 505;
            [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        }
        else {
            //오류
            NSLog(@"명령수행불가: %@",urlString);
        }
    }
}


///
-(void)updateWebHeight:(CGFloat)height {
    self.isUpdateWebHeight = YES;
    self.headerHeight = height;
}

#pragma mark - UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 222) {
        [self removeAllObject];
        [self.navigationController popViewControllerMoveInFromTop];
        
    }
    else if(alert.tag == 380) {
        
        switch (index) {
            case 1:
                NSLog(@"설정");
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            default:
                break;
        }
        
    }
    else if(alert.tag == 444) {
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
                self.curRequestString =nil;
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
                
                self.curRequestString =nil;
                break;
        }
    }
    else if(alert.tag == 999) {
        switch (index) {
            case 1:
                //공통영상 재생 예
                [self playrequestCommonVideo:self.curRequestString];
                break;
            default:
                
                self.curRequestString =nil;
                break;
        }
    }
    else if(alert.tag == 1999) { // livestreaming
        switch (index) {
            case 1:
                //공통영상 재생 예
                // 글로벌 적용
                [DataManager sharedManager].strGlobal3GAgree = @"Y";
                [self playrequestCommonVideo:self.curRequestString];
                break;
            default:
                
                self.curRequestString =nil;
                break;
        }
    }
    //SNS
    else if (alert.tag==141) {
        if (index==0) {
            // cancel
        } else {
            // 카카오톡 링크로 이동
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/id362057947"]];
        }
    }
    else if (alert.tag==142) {
        if (index==0) {
            // cancel
        } else {
            // 카카오스토리 링크로 이동
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/id486244601"]];
        }
    }
    // nami0342 - 네트워크 연결 불가 얼럿 처리
    else if(alert.tag == 10010)
    {
        if (index==0) {
            [self closeWebView];
        }
        else
        {
            [self requestWKWebviewUrlString];
        }
    }
    
    
}






//공통영상 재생
-(void)playrequestCommonVideo: (NSString*)requrl {
    
    //requrl = toapp://streaming...
    
    
    
    URLParser *parser = [[URLParser alloc] initWithURLString:requrl];
    
    NSLog(@"type = %@ \n url = %@ \n targeturl = %@ ", [parser valueForVariable:@"type"], [parser valueForVariable:@"url"], [parser valueForVariable:@"targeturl"]);
    
    ApplicationDelegate.HMV.tabBarView.hidden = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
    // nami0342 - 단품 구매하기 버튼 사라지는 거 방지
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    if ([Mocha_Util strContain:@"videoid" srcstring:requrl] && [NCS([parser valueForVariable:@"videoid"]) length] > 4 ) {
        NSLog(@"videoid: %@",[parser valueForVariable:@"videoid"]);
        [vc playBrightCoveWithID:NCS([parser valueForVariable:@"videoid"])];
    }else{
        [vc playMovie:[NSURL URLWithString:[parser valueForVariable:@"url"]]];
    }
    
}

//생방송 재생
-(void)playrequestLiveVideo: (NSString*)requrl {
    
    
    //생방송 영상
    ApplicationDelegate.HMV.tabBarView.hidden = YES;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    [vc playMovie:[NSURL URLWithString:requrl]];
    
}

//단품 VOD 재생
-(void)playrequestVODVideo:(NSString*)requrl   {
    
    URLParser *parser = [[URLParser alloc] initWithURLString:requrl];
    
    
    ApplicationDelegate.HMV.tabBarView.hidden = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    NSLog(@"parser = %@",parser);
    NSLog(@"parser.variables = %@",parser.variables);
    
    if ([Mocha_Util strContain:@"videoid" srcstring:requrl] && [NCS([parser valueForVariable:@"videoid"]) length] > 4 ) {
        NSLog(@"videoid: %@",[parser valueForVariable:@"videoid"]);
        [vc playBrightCoveWithID:NCS([parser valueForVariable:@"videoid"])];
    }else{
        [vc playMovie:[NSURL URLWithString:[parser valueForVariable:@"url"]]];
    }
    
}



////20171128 yunsang.jin iPad 에서 팝오버컨트롤러가 이미 떠있는경우거나 중복불가능하도록 + 소스뷰가 문제있을경우 리턴
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    // Override this method in the view controller that owns the web view - the web view will try to present on this view controller ;)
    
    BOOL isBugiPadVer = NO;
    
    NSArray *arrSystemVersion = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    if (NCA(arrSystemVersion) && [arrSystemVersion count] >1 && [[arrSystemVersion objectAtIndex:0] isEqualToString:@"11"] && [[arrSystemVersion objectAtIndex:1] integerValue] < 2) {
        isBugiPadVer = YES;
    }
    
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) && isBugiPadVer) {
        
        if ([timerVCBlocker isValid]) {
            NSLog(@"viewControllerToPresent = %@",viewControllerToPresent);
            
            vcLastReturned = viewControllerToPresent;
            
            return;
            
        }else{
            viewControllerToPresent.popoverPresentationController.delegate = self;
            NSLog(@"");
            
            vcPresented = viewControllerToPresent;
            
            [super presentViewController:viewControllerToPresent animated:NO completion:completion];
        }
    }else{
        
        
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    
    
    
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController{
    NSLog(@"popoverPresentationController = %@",popoverPresentationController);
}

// Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
// dismissal of the view.
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    return YES;
}

// Called on the delegate when the user has taken action to dismiss the popover. This is not called when the popover is dimissed programatically.
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    NSLog(@"popoverPresentationController = %@",popoverPresentationController);
    
    BOOL isBugiPadVer = NO;
    
    NSArray *arrSystemVersion = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    if (NCA(arrSystemVersion) && [arrSystemVersion count] >1 && [[arrSystemVersion objectAtIndex:0] isEqualToString:@"11"] && [[arrSystemVersion objectAtIndex:1] integerValue] < 2) {
        isBugiPadVer = YES;
    }
    
    
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) && isBugiPadVer) {
        timerVCBlocker = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerBlockView) userInfo:nil repeats:NO];
    }
    
}


-(void)timerBlockView{
    if ([timerVCBlocker isValid]) {
        
        NSLog(@"");
        
        [timerVCBlocker invalidate];
        timerVCBlocker = nil;
        
        NSLog(@"vcPresented = %@",vcPresented);
        NSLog(@"vcLastReturned = %@",vcLastReturned);
        
        //[wview stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
        [self callJscriptMethod:@"document.activeElement.blur()"];
    }
}


#pragma mark -
#pragma mark uploadDelegate

- (void)didSuccesUpload:(NSDictionary *)dicResult{
    
    NSLog(@"");
    
}


#pragma mark -
//20160809 parksegun SNS 공유용 팝업뷰 호출(웹뷰 스크립트 호출 타입)
-(void)showSnsScriptView
{
    [ApplicationDelegate snsShareWithScriptTypeShow:self];
}

#pragma mark snsDelegate
-(void)callShareSnsWithString:(NSString*)seletedString{
    
    [self callJscriptMethod:seletedString];
}


#pragma mark - WKWebView Delegates

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString;
    NSURL *requestURL = navigationAction.request.URL;
    BOOL isDecisionAllow = YES;
    
    if (self.isNativePassUrl == NO) {
        self.isNativePassUrl = [[requestString1 lowercaseString] containsString:@"isweb=y"]?YES:NO;
        
        //2020.07.09 배포용
        //푸시 수신시 웹뷰 위치가 중앙에서 시작해 로딩 끝나는 시점에 상단으로 붙는 경우가 있어
        //아예 푸시수신일경우 "utm_source=apppush" 단품 네이티브를 로딩 안하도록 협의함
        if (([@"/prd/prd.gs" isEqualToString:requestURL.path] || [@"/deal/deal.gs" isEqualToString:requestURL.path])
            && [requestURL.query containsString:@"utm_source=apppush"]
            ){
            self.isNativePassUrl = YES;
        }
    }
    
    
    // 201611010 parksegun
    //이슈: 메모리가 넉넉한 아이폰의 경우 히스토리백일때 메모리에 남아 았던 웹뷰가 그대로 노출되면서 쿠키 및 스크립트가 동작하지 않아, 최근본 상품 처리가 단말에 따라,상품에 따라 상이한 케이스가 발생함.
    //이를 해결하고자 뒤로가기일때 웹뷰캐시를 제거 하여 쿠키 동작및 스크립트가 동작하도록 유도함.
    if(WKNavigationTypeBackForward == navigationAction.navigationType) {
        //성인인증을 위해 체크 페이지 진입후 히스토리 백 할때 처리 안되는 문제 수정
        if(self.wview != nil && [Mocha_Util strContain:@"member/adultCheck.gs?" srcstring:self.wview.URL.absoluteString]) {
            [self removeAllObject];
            [self.navigationController popViewControllerMoveInFromTop];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        
        if ([requestString1 length] > 0 && ([requestString1 rangeOfString:@"/deal.gs?"].location != NSNotFound || [requestString1 rangeOfString:@"/prd.gs?"].location != NSNotFound || [PRODUCT_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] || [DEAL_NATIVE_BOTTOM_URL isEqualToString:requestURL.path])) {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }
    }
    
    NSLog(@"URLREQUEST = %@", requestString1);
    
    //캡슐화 - 공통 처리 를 위해 상위클래스 불러줌
    isDecisionAllow = [self.wview isGSWKDecisionAllowURLString:requestString1 andNavigationAction:navigationAction withTarget:self];
    
    //검색 공통
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://search"]) {
        [ApplicationDelegate SearchviewShow];
        isDecisionAllow = NO;
    }
    
    
    //2016.01 라이브톡 추가
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetolivetalk"]) {
        NSLog(@"requestString1 = %@",requestString1);
        ApplicationDelegate.HMV.tabBarView.hidden = YES;
        LiveTalkViewController *goliveBVV = [[LiveTalkViewController alloc] initWithTarget:self withBCinfoStr:requestString1];
        [self.navigationController  pushViewControllerMoveInFromBottom:goliveBVV ];
        isDecisionAllow = NO;
    }
    
       
    
    //2019.02.20 모바일 라이브 추가
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetomobilelive"]) {
        // toapp://movetomobilelive?closeYn=Y&topapi=http://tm14.gsshop.com/app/section/mobilelive/2776/0
        
        NSString *strCloseYn = @"n";
        if ([Mocha_Util strContain:@"closeYn=" srcstring:requestString1])
        {
            NSArray *arCloseYN = [requestString1 componentsSeparatedByString:@"closeYn="];
            strCloseYn = [NCS([arCloseYN objectAtIndex:1]) lowercaseString];
            strCloseYn = [strCloseYn substringToIndex:1];
        }
        
        if([strCloseYn isEqualToString:@"y"] == YES)
        {
            // 나를 종료
            [self removeAllObject];
            [self.navigationController  popViewControllerAnimated:NO];
        }
        
        MobileLiveViewController *MLVC = [[MobileLiveViewController alloc] initWithNibName:@"MobileLiveViewController" bundle:nil];
        MLVC.m_toappString = requestString1;
        [ApplicationDelegate.mainNVC  pushViewControllerMoveInFromBottom:MLVC ];
        
        isDecisionAllow = NO;
    }
    
    
    
    //VOD영상 재생 - 20130102   + 딜상품 VOD영상 재생 - 20130226 + 기본 VOD영상재생(버튼overlay없음) 20150211
    if(isDecisionAllow == YES &&( ([requestString1 hasPrefix:@"toapp://vod?url="]) || ([requestString1 hasPrefix:@"toapp://dealvod?url="]) || ([requestString1 hasPrefix:@"toapp://basevod?url="]) ))    //vod 방송
    {
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestVODVideo:requestString1];
        }
        else
        {
            self.curRequestString = [NSString stringWithString:requestString1];
            self.curUrlUse = NO;
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 888;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow =  NO;
    }
    
    
    //생방송
    if(isDecisionAllow == YES &&( ([requestString1 hasPrefix:@"toapp://liveBroadUrl?param="]) ||([requestString1 hasPrefix:@"toApp://liveBroadUrl?param="]) ))  //live 방송
    {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query3 = [livetv lastObject];
        NSLog(@"moviePlay = %@",query3);
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestLiveVideo:query3];
        }
        else {
            self.curRequestString = [NSString stringWithString:query3];
            self.curUrlUse = NO;
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 777;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow =  NO;
    }
    
    
    
    
    //공통영상 재생 20150626 v3.1.6.17이후
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://livestreaming?"]) {
        //글로벌 데이터 동의 변경
        if([requestString1 containsString:@"globalConfirm=Y"]) {
            [DataManager sharedManager].strGlobal3GAgree = @"Y";
        }
        
        //https://jira.gsenext.com/browse/PDP-111
        if([NetworkManager.shared currentReachabilityStatus] == NetworkReachabilityStatusViaWiFi ||
           [requestString1 containsString:@"noDataWarningFlg=Y"]) {
            [self playrequestCommonVideo:requestString1];
        }
        else {
            self.curRequestString = [NSString stringWithString:requestString1];
            self.curUrlUse = NO;
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 1999;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow =  NO;
    }
    
    
    //20160805 parksegun NativeSNS 팝업창 호출 // toapp://snsshow
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://snsshow"]) {
        [self showSnsScriptView];
        isDecisionAllow = NO;
    }
    
    
    // 공유하기 기능 20160630 배포건
    // 201606 parksegun 공유하기 기능 변경
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://share?"]) {
        NSString *share = [requestString1 stringByReplacingOccurrencesOfString:@"toapp://share?" withString:@""];
        NSLog(@"share: %@",share);
        if([share hasPrefix:@"target=facebook&"]) {
            // 페이스북
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_FACEBOOK];
            isDecisionAllow = NO;
        }
        
        if([share hasPrefix:@"target=twitter&"]) {
            // 트위터
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_TWITTER];
            isDecisionAllow = NO;
        }
        
        //20160722 line 추가
        if([share hasPrefix:@"target=line&"]) {
            //라인
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_LINE];
            isDecisionAllow = NO;
        }
        
        if([share hasPrefix:@"target=kakaotalk&"]) {
            //카카오톡
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_KAKAOTALK];
            isDecisionAllow = NO;
        }
        if([share hasPrefix:@"target=kakaostory&"]) {
            //카카오스토리
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_KAKAOSTORY];
            isDecisionAllow = NO;
        }
        if([share hasPrefix:@"target=etc&"]) {
            // 기타
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_SHARE];
            isDecisionAllow = NO;
        }
    }
    
    
    
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://back"]) //폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
    {
        NSArray *comp = [requestString1 componentsSeparatedByString:@"//"];
        NSString *query1 = [comp lastObject];
        if([query1 isEqualToString:@"back"]) {
            if([self.wview canGoBack]) {
                [self.wview goBack];
                //[self.wview justBack];
            }
            else {
                //빙글빙글 계속 돌고 있어서
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [ApplicationDelegate.gactivityIndicator stopAnimating];
                
                //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
                NSString *strLoadedUrl = NCS(webView.URL.absoluteString);
                if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
                    ////탭바제거
                    [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
                }
                
                
                [self removeAllObject];
                
                BOOL isPopToRoot = NO;
                if (self.navigationController.viewControllers.count > 2){
                    id VC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                    if(VC != nil && [VC isKindOfClass:[ResultWebViewController class]]){
                        ResultWebViewController *resutlWebToBack = (ResultWebViewController *)VC;
                        NSString *strPopToHomeCheck = NCS(resutlWebToBack.wview.URL.absoluteString);
                        NSLog(@"strPopToHomeCheck  = %@",strPopToHomeCheck);
                        if (
                        [Mocha_Util strContain:@".gsshop.com/cm.html?" srcstring:strPopToHomeCheck] ||
                        [Mocha_Util strContain:@".gsshop.com/cp.html?" srcstring:strPopToHomeCheck] ||
                        [Mocha_Util strContain:@"/jseis_withLGeshop.jsp?" srcstring:strPopToHomeCheck] ||
                        [Mocha_Util strContain:@"/aliaGate.gs?" srcstring:strPopToHomeCheck]
                            
                            ){
                            
                            isPopToRoot = YES;
                        }
                    }
                }
                
                if (isPopToRoot) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [self.navigationController popViewControllerMoveInFromTop];
                }
                
                
            }
        }
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://close"]) //폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
    {
        if ([Mocha_Util strContain:@"tabId" srcstring:requestString1]) {
            //toapp://close?tabId=287
            NSString *strTabID = [[requestString1 componentsSeparatedByString:@"tabId="] lastObject];
            if ([NCS(strTabID) length] > 0 && [Common_Util isAllDigits:strTabID] ) {
                
                //여긴 범용으로... 가는게...
                [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
                    if (isSuccess == YES) {
                        [ApplicationDelegate.HMV sectionReloadWithTargetShopNumber:strTabID];
                    }
                    [self removeAllObject];
                    [self.navigationController popViewControllerMoveInFromTop];
                }];
            }else{
                [self removeAllObject];
                [self.navigationController popViewControllerMoveInFromTop];
            }
            
        }else{
            [self removeAllObject];
            [self.navigationController popViewControllerMoveInFromTop];
        }
        
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://attach"]) //파일첨부 페이지 호출
    {
        
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        NSLog(@"caller = %@ \n uploadUrl = %@ \n callbackUrl = %@ ", [parser valueForVariable:@"caller"], [parser valueForVariable:@"uploadUrl"], [parser valueForVariable:@"callback"]);
        
        //1:1 모바일 상담은 특수 경우로 UI처리 한번더해야함 그외에는 모두 GSMediaUploader로 처리
        if([[parser valueForVariable:@"caller"] isEqualToString:@"mobiletalk"]){
            
            if(self.popupAttachView != nil){
                [self.popupAttachView removeFromSuperview];
                self.popupAttachView = nil;
                
                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.500f]];
            }

            self.popupAttachView = [[[NSBundle mainBundle] loadNibNamed:@"PopupAttachView" owner:self options:nil] firstObject];
            [self.popupAttachView openPopupWithFrame:self.view.frame superview:self.view delegate:self param:parser animated:YES];
            
        }else{
            GSMediaUploader *uploder = [[[NSBundle mainBundle] loadNibNamed:@"GSMediaUploader" owner:self options:nil] firstObject];
            [uploder gsMediaUploadWithUrl:requestString1 andTarget:self];
        }
        
        
        isDecisionAllow = NO;
    }

    //NSLog(@"getLoginCookie >> %@",[ApplicationDelegate getLoginCookiesFromShared]);
    
    //로그인이 필요한 페이지는 로그인을 하고 페이지를 넘긴다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGINCHECKURL]) {
        //웹뷰가 toapp://login 호출할경우 기존에 로그인이 되어있으면 API로그아웃이 "아닌" APPJS 방식 로그아웃 호출
        if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
            NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation" code:9000 userInfo:nil];
            NSString *msg = [[NSString alloc] initWithFormat:@"앱로그인 상태에서 toapp://login 호출됨: resultWebView url=%@ 자동로그인인가? %@ requestString1: %@ [count: %d]", self.wview.lastEffectiveURL, ([DataManager sharedManager].m_loginData.autologin == 1 ? @"YES" : @"NO"),requestString1, abNomalCount ];
            [ApplicationDelegate SendExceptionLog:err msg: msg];
            //toapp://login에 되될아갈 URL이 있으면 그곳을 재호출 하도록 변경
            NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
            NSString *param = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
            if([NCS(param) length] > 0 && [param hasPrefix:@"http"] ) {
                self.urlString = param;
            }
            else {
                self.urlString = self.wview.lastEffectiveURL;
            }
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
                    NSArray *arrPopVC =  [self.navigationController popToRootViewControllerAnimated:NO];
                    for (UIViewController *vc in arrPopVC) {
                        NSLog(@"vcvcvcvc = %@",vc);
                        if ([vc isKindOfClass:[ResultWebViewController class]]) {
                            ResultWebViewController *rvc = (ResultWebViewController *)vc;
                            [rvc removeAllObject];
                        }
                    }
                    
                });
                return;
            }
            //쿠키 동기화후 재호출로직 추가
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
            
            if(self.wview.viewHeader != nil) {
                [ApplicationDelegate.gactivityIndicator isDownLoding];
            }
            [ApplicationDelegate.gactivityIndicator startAnimating];
            return;
        }
        
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        if([query2 isEqualToString:@""])
        {
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
            self.curUrlUse = NO;
        }
        else
        {
            self.curRequestString = [NSString stringWithString:query2];
            self.curUrlUse = NO;
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
        if([Mocha_Util strContain:@"isAdult=Y" srcstring:requestString1]){
            loginView.loginViewMode = 2;
        }
        else if([Mocha_Util strContain:@"isPrdOrder=Y" srcstring:requestString1]){
            loginView.loginViewMode = 1;
            
        }else {
            loginView.loginViewMode = 0;
        }
        
        loginView.view.hidden=NO;
        
        // 중복호출 및 Crash 방지
        @try {
            if([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[AutoLoginViewController class]] == NO)
            {
                [self.navigationController pushViewControllerMoveInFromBottom:loginView];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
        
        
        //20170615점유인증 & 회원 간소화
        if([Mocha_Util strContain:@"msg=" srcstring:requestString1]){
            
            NSArray *msgTemp = [requestString1 componentsSeparatedByString:@"msg="];
            
            if( [msgTemp count] > 1 ) {
                NSArray *idTemp = [NCS([msgTemp objectAtIndex:1]) componentsSeparatedByString:@"&"];
                if( [idTemp count] > 0) {
                    loginView.textFieldId.text = NCS([idTemp objectAtIndex:0]);
                    loginView.userId = NCS([idTemp objectAtIndex:0]);
                }
            }
        }
        
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
        
    }
    
    //로그아웃 요청URL
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGOUTTOAPPURL])
    {
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        
        if([query2 isEqualToString:@""])
        {
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
            self.curUrlUse = NO;
        }else {
            self.curRequestString = [NSString stringWithString:query2];
            self.curUrlUse = NO;
        }
        
        NSLog(@"self.curRequestString = %@", self.curRequestString);
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:LOGOUTALERTALSTR
                                                       maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:LOGOUTCONFIRMSTR1,  LOGOUTCONFIRMSTR2, nil]];
        malert.tag = 444;
        [self.view addSubview:malert];
        
        
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
    }
    
    
    
    //popup 띄우기
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://modal"] )
    {
        // toapp://modal?
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"modal?"];
        NSString *query2 = [comp1 count] > 1 ?[comp1 objectAtIndex:1]:@"";
        
        NSString *title = GSSLocalizedString(@"common_txt_modaltitle_default");
        NSString *landingURL = query2;
        
        if ([requestString1 hasPrefix:@"toapp://modal?title="])
        {
            NSArray *tempArray = [query2 componentsSeparatedByString:@"&url="];    // 0 : title=상품설명 , 1 : http://
            
            title = [Mocha_Util strReplace:@"title=" replace:@"" string:[tempArray objectAtIndex:0]];
            
            NSMutableArray *tempArray2 = [NSMutableArray arrayWithArray:tempArray];
            [tempArray2 removeObjectAtIndex:0];
            landingURL = [tempArray2 componentsJoinedByString:@"&url="];
        }
        
        NSLog(@"title = %@, landingURL = %@", title, landingURL);
        
        //popup 띄우기 (타이틀 및 UI)
        self.popupWebView = [PopupWebView openPopupWithFrame:self.wview.frame
                                                   superview:self.view
                                                    delegate:self
                                                         url:landingURL
                                                       title:title
                                                    animated:YES];
        
        isDecisionAllow =  NO;
    }
    
    
    
    
    //extmodal 띄우기
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://extmodal"] )
    {
        URLParser *oparser = [[URLParser alloc] initWithURLString:requestString1 ];
        
        
        NSLog(@"bbbbbbbbbb = %@ \n nnnnnnnnnn = %@ \n   ",    [[oparser valueForVariable:@"title"] urlDecodedString], [oparser valueForVariable:@"url"]  );
        
        
        if([oparser valueForVariable:@"title"] != nil && [oparser valueForVariable:@"url"] != nil){
            
            
            //popup 띄우기 (타이틀 및 UI)
            self.popupWebView = [PopupWebView openPopupWithFrame:self.wview.frame
                                                       superview:self.view
                                                        delegate:self
                                                             url:[Common_Util getURLEndcodingCheck:[oparser valueForVariable:@"url"]]
                                                           title:[[oparser valueForVariable:@"title"]  urlDecodedString]
                                                        animated:YES];
            
        }
        
        
        isDecisionAllow =  NO;
    }
    
    
    //20160630 parksegun 라이브톡 전체 웹뷰(이미지뷰어용)
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://fullwebview?"]) //타이틀 없는 전체사이즈 팝업
    {
        //규격 >> toapp://fullwebview?targetUrl=(url 인코딩)
        NSArray *arrSplit = [requestString1 componentsSeparatedByString:@"toapp://fullwebview?"];
        
        if (NCA(arrSplit) && [arrSplit count] > 1) {
            
            NSString *targetUrl = [[arrSplit objectAtIndex:1] stringByRemovingPercentEncoding];
            
            if ([targetUrl hasPrefix:@"targetUrl="])
            {
                NSString *landingURL = [Mocha_Util strReplace:@"targetUrl=" replace:@"" string:targetUrl];
                //popup 띄우기 (타이틀 및 UI)
                self.popupWebView = [PopupWebView openPopupWithFrame:self.wview.frame
                                                           superview:self.view
                                                            delegate:self
                                                                 url:landingURL
                                                               title:nil
                                                            animated:YES];
            }
        }
        isDecisionAllow = NO;
    }
    
    //20190319 parksegun 노탭 풀웹뷰
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://notabfullweb?"]) //타이틀 없는 전체사이즈 노탭,
    {
        //규격 >> toapp://notabfullweb?targetUrl=(url 인코딩)
        NSArray *arrSplit = [requestString1 componentsSeparatedByString:@"toapp://notabfullweb?"];
        if (NCA(arrSplit) && [arrSplit count] > 1) {
            NSString *targetUrl = [[arrSplit objectAtIndex:1] stringByRemovingPercentEncoding];
            
            NSString *strCloseYn = @"n";
            if ([Mocha_Util strContain:@"closeYn=" srcstring:targetUrl]) {
                NSArray *arCloseYN = [targetUrl componentsSeparatedByString:@"closeYn="];
                strCloseYn = [NCS([arCloseYN objectAtIndex:1]) lowercaseString];
                strCloseYn = [strCloseYn substringToIndex:1];
            }
            
            if([strCloseYn isEqualToString:@"y"] == YES) {
                // 나를 종료//안될꺼 같은데..(됨)
                [self removeAllObject];
                [ApplicationDelegate.mainNVC popViewControllerAnimated:NO];
            }
            //세건차장님 요청
            if ([targetUrl containsString:@"targetUrl="]) {
                //NSString *landingURL = [Mocha_Util strReplace:@"targetUrl=" replace:@"" string:targetUrl];
                NSRange targetRange = [targetUrl rangeOfString:@"targetUrl="];
                NSString *landingURL;
                if(targetRange.location == NSNotFound) {
                    landingURL = [Mocha_Util strReplace:@"targetUrl=" replace:@"" string:targetUrl];
                }
                else {
                    landingURL = [targetUrl substringFromIndex:targetRange.location + targetRange.length];
                }
                
                ResultWebViewController *resVC = [[ResultWebViewController alloc] initWithUrlStringByNoTab:landingURL];
                [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
            }
        }
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://setting"]) //내설정
    {
        //내설정
        dispatch_async(dispatch_get_main_queue(),^{
            if(self.wview.viewHeader != nil) {
                [ApplicationDelegate.gactivityIndicator isDownLoding];
            }
            [ApplicationDelegate.gactivityIndicator startAnimating];
            
        });
        
        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
        
        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
        isDecisionAllow = NO;
        
    }
    
    ///* 2016/04/12 예정
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://directOrd?"]) //바로주문
    {
        //내설정
        NSArray *arrSplit = [requestString1 componentsSeparatedByString:@"toapp://directOrd?"];
        
        if (NCA(arrSplit) && [arrSplit count] > 1) {
            
            NSString *strDirectOrd = [arrSplit objectAtIndex:1];
            
            
            [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
            
        }
        
        
        isDecisionAllow = NO;
        
    }
    
    
    
    //20160304 parksegun 주문서페이지 새로운 뷰로 처리 하도록 변경
    
    //20160407 parksegun 주문서 새창띄우기 막기, 백키 관련해서는 유지되야함.
    
    if(isDecisionAllow == YES && [Mocha_Util strContain:@"ordSht.gs" srcstring:requestString1] && self.ordPass == NO)
    {
        ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = NO;
        
        //appModalReAction
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
        result.ordPass = YES;
        result.delegate = self.delegate;
        result.view.tag = 505;
        //[DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        
        isDecisionAllow =  NO;
    }
    
    
    
    
    //20160307 parksegun movetoinpage 이면 나를 닫고 다른 웹뷰에 URL을 호출한다.
    // 만약 page를 열수없는 상태이면 새로운 웹뷰 창을 띄운다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetoinpage"]) {
        
        
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        NSLog(@"movetoninpage = %@   ", [parser valueForVariable:@"url"]);
        // 인코딩
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];//stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        
        UINavigationController *navigationController = ApplicationDelegate.mainNVC;
        ////탭바제거 navigationController = (UINavigationController *)[ApplicationDelegate.tabBarController1.viewControllers objectAtIndex: [DataManager sharedManager].selectTab];
        
        NSLog(@"**1** CurrentTab: %ld, Count: %lu",(long)[DataManager sharedManager].selectTab, (unsigned long)[navigationController.viewControllers count])
        // 나를 종료
        [self removeAllObject];
        [self.navigationController  popViewControllerMoveInFromTop];
        
        NSLog(@"**2** CurrentTab: %ld, Count: %lu",(long)[DataManager sharedManager].selectTab, (unsigned long)[navigationController.viewControllers count])
        
        if([navigationController.viewControllers count] > 1  )
        {
            if([[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] respondsToSelector:@selector(goWebView:)]) {
                
                [[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] goWebView:url];
            }
            else
            {
                //처리가 불가능한 녀석이면??? 새로띄움
                ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
                resVC.ordPass = NO;
                resVC.view.tag = 505;
                [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
            }
            
        }
        else if([navigationController.viewControllers count] == 1  ) { // 나뿐이 없다면... 내가
            
            
            if([[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] respondsToSelector:@selector(goWebView:)]) {
                
                [[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] goWebView:url];
            }
            else
            {
                NSLog(@"");
                //처리가 불가능한 녀석이면??? 새로띄움
                ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
                resVC.ordPass = NO;
                resVC.view.tag = 505;
                [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
            }
            
        }
        else
        {
            NSLog(@"");
            //처리가 불가능한 녀석이면??? 새로띄움
            ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
            resVC.ordPass = NO;
            resVC.view.tag = 505;
            [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        }
        
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://opennewpage"]) {
        
        
        //[ApplicationDelegate.HMV performSelector:@selector(openNewWebview:) withObject:requestString1 afterDelay:2.0];
        //[ApplicationDelegate.HMV openNewWebview:requestString1];
        
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        // 인코딩
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];//stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *strCloseYn = @"n";
        if ([Mocha_Util strContain:@"closeYn=" srcstring:requestString1])
        {
            NSArray *arCloseYN = [requestString1 componentsSeparatedByString:@"closeYn="];
            strCloseYn = [NCS([arCloseYN objectAtIndex:1]) lowercaseString];
            strCloseYn = [strCloseYn substringToIndex:1];
        }
        
        if ([strCloseYn isEqualToString:@"y"]) {
            [self removeAllObject];
            [ApplicationDelegate.mainNVC  popViewControllerAnimated:NO];
        }
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url methodPost:YES];
        resVC.ordPass = NO;
        resVC.view.tag = 505;
        [ApplicationDelegate.mainNVC  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        
        
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://newpage"]) {
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        // 인코딩
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];//stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *strCloseYn = @"n";
        if ([Mocha_Util strContain:@"closeYn=" srcstring:requestString1])
        {
            NSArray *arCloseYN = [requestString1 componentsSeparatedByString:@"closeYn="];
            strCloseYn = [NCS([arCloseYN objectAtIndex:1]) lowercaseString];
            strCloseYn = [strCloseYn substringToIndex:1];
        }
        
        if ([strCloseYn isEqualToString:@"y"]) {
            [self removeAllObject];
            [ApplicationDelegate.mainNVC  popViewControllerAnimated:NO];
        }
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
        resVC.ordPass = NO;
        resVC.view.tag = 505;
        [ApplicationDelegate.mainNVC  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        
        isDecisionAllow = NO;
    }
    
    //toapp://outsitemodal?title=xxx{@literal &}url=xxx
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://outsitemodal"]) {
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        //NSString *url = [[parser valueForVariable:@"url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];
        NSLog(@"bbbbbbbbbb = %@ \n nnnnnnnnnn = %@ \n   ",    [[parser valueForVariable:@"title"] urlDecodedString], [parser valueForVariable:@"url"]  );
        NSString *title = [[parser valueForVariable:@"title"] urlDecodedString];
        HeaderWebViewController *headVC = [[HeaderWebViewController alloc]initWithUrlString:url withString:title];
        headVC.ordPass = NO;
        headVC.view.tag = 506;
        [self.navigationController  pushViewControllerMoveInFromBottom:headVC];//url을 웹뷰로 보여줌
        isDecisionAllow = NO;
    }
    
    
    
    BOOL isFrame = ![[[navigationAction.request URL] absoluteString] isEqualToString:[[navigationAction.request mainDocumentURL] absoluteString]];
    
    //딜, 단품 floating 처리
    if(isDecisionAllow == YES ) {
        //iframe 내에서 url request 무시하기
        
        NSLog(@"아이프레임 일까요? %i  ==== %@", isFrame,requestString1);
        if(!isFrame) {
            
            //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
            NSString *strLoadedUrl = NCS(self.wview.URL.absoluteString);
            if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
                ////탭바제거
                [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
                
                
            }
            webView.tag = self.wview.tag == 0 ? self.view.tag : self.wview.tag;
            if(isShowing) {
                [ApplicationDelegate checkFloatingPurchaseBarWithWebView:(GSWKWebview*)webView url:requestString1];
            }
            
            if ([[requestString1 lowercaseString] hasPrefix:@"http:"] || [[requestString1 lowercaseString] hasPrefix:@"https:"]) {
                self.wview.lastEffectiveURL = requestString1;
            }
        }
        
    }
    
    if (isDecisionAllow == YES ) {
        
        //내가 딜,단품 인데, 달,단품이 아니야? 그럼 새창
        //        if(!isFrame && [requestString1 length] > 0 && self.isDealAndPrd == YES &&
        //           ([requestString1 rangeOfString:@"/deal.gs?"].location == NSNotFound &&
        //            [requestString1 rangeOfString:@"/prd.gs?"].location == NSNotFound &&
        //            [requestString1 rangeOfString:@"/addBasketForward.gs?"].location == NSNotFound &&
        //            [requestString1 rangeOfString:@"/addOrdSht.gs?"].location == NSNotFound &&
        //            [requestString1 rangeOfString:@"/ordShtGate.gs?"].location == NSNotFound &&
        //            ![requestString1 hasSuffix:@"http"]
        //            )
        //           ) {
        //
        //            NSLog(@"requestString1 = %@",requestString1);
        //
        //            ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
        //            result.ordPass = NO;
        //            result.isDealAndPrd = NO;
        //            result.delegate = self.delegate;
        //            result.view.tag = 505;
        //            [self.navigationController pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        //            isDecisionAllow = NO;
        //        }
        
        // nami0342 - 상품 상세에서 영상 틀어놓고 이동 시 새창이라서 이전 영상이 계속 재생되므로 딜/단품 -> 타 링크 이동 시 새 창으로 뜨는 거 막는 테스트
        if (([requestString1 length] > 0 && self.isDealAndPrd == YES ) &&
            ([requestString1 rangeOfString:@"/ordsht/addOrdSht.gs"].location != NSNotFound ||
             [requestString1 rangeOfString:@"/ordsht/ordShtGate.gs"].location != NSNotFound
             
             )){
            
            ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = NO;
                ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
                result.ordPass = NO;
                result.isDealAndPrd = NO;
                result.delegate = self.delegate;
                result.view.tag = 505;
                [self.navigationController pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
                isDecisionAllow = NO;
        }
        

//
        //딜/단품은 새창
        if (!isFrame && [requestString1 length] > 0 && ([requestString1 rangeOfString:@"/deal.gs?"].location != NSNotFound || [requestString1 rangeOfString:@"/prd.gs?"].location != NSNotFound) && self.isDealAndPrd == NO
            && !( [Mocha_Util strContain:@".gsshop.com/cm.html?" srcstring:NCS(self.wview.URL.absoluteString)] || [Mocha_Util strContain:@".gsshop.com/cp.html?" srcstring:NCS(self.wview.URL.absoluteString)] || [Mocha_Util strContain:@"/jseis_withLGeshop.jsp?" srcstring:NCS(self.wview.URL.absoluteString)] || [Mocha_Util strContain:@"/aliaGate.gs?" srcstring:NCS(self.wview.URL.absoluteString)]
                 
                 ) //현재 페이지가 푸시용 게이트페이지면 새창을 띄우지 않는다..gsshop.com/cp.html
            ) {
            NSLog(@" //딜/단품은 새창: %@",self.wview.URL.absoluteString);
            ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
            result.ordPass = NO;
            result.isDealAndPrd = YES;
            result.delegate = self.delegate;
            result.view.tag = 505;
            [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
            
            isDecisionAllow =  NO;
        }
        
//        //내가 딜/단품이야 그런데 다른 링크야.. 새창띄워
//        if (!isFrame && self.isDealAndPrd && [requestString1 length] > 0 && ![requestString1 containsString:@"/prdBottomApp.gs?"] && ( ![requestString1 containsString:@"/ordsht/addOrdSht.gs"] || ![requestString1 containsString:@"/ordsht/ordShtGate.gs"])
//        )
//            ) {
//                        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
//                           result.ordPass = NO;
//                           result.isDealAndPrd = NO;
//                           result.delegate = self.delegate;
//                           result.view.tag = 505;
//                           [self.navigationController pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
//                           isDecisionAllow = NO;
//        }
    }
    
    //헤더상단 네이티브
    //딜->단품 교체 추가 해야함
    //단품->딜 새창 추가해야함
    
    
    if ([@"Y" isEqualToString:PRD_NATIVE_YN ] && isDecisionAllow == YES && !isFrame && self.isNativePassUrl == NO) {

        NSLog(@"requestURL = %@",requestURL);
        NSLog(@"self.isDealAndPrd = %d",self.isDealAndPrd);
        
        if (WKNavigationTypeReload == navigationAction.navigationType){ //리로드 일떄
            
            if (isDecisionAllow == YES && ( [PRODUCT_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] || [@"/prd/prd.gs" isEqualToString:requestURL.path] || [DEAL_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] || [@"/deal/deal.gs" isEqualToString:requestURL.path]) ) {
                [self checkAndDrawPreloadHeaderL1:requestString1];
                //리로드의 경우 로그인 할때 말고는 거의 안일어 나고 로그인후에는 이미 쿠키 싱크가 되어있음
                [self callWebViewHeaderAPI:requestString1 isCookieSync:NO OnCompletion:^(NSDictionary *dicApiResult) {
                    
                    [self didSuccessAPICall:requestString1];
                    
                } onError:^(NSError *error) {
                    if (error != nil) {
                        NSLog(@"error = %@",error);
                    }else{
                        //애러 못받아왔으면 통신은 성공했는데 json 데이터가 이상한것
                    }
                    
                    [self didFailAPICall:requestString1];
                }];
                isDecisionAllow =  NO;
            }else{
                isDecisionAllow =  YES;
            }
        
        }else if (WKNavigationTypeBackForward == navigationAction.navigationType){ //뒤로가기
            //단품 네이티브 빽일경우에만 API 다시 호출해서 화면구성 다시 해야함
            if (isDecisionAllow == YES && ([PRODUCT_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] || [@"/prd/prd.gs" isEqualToString:requestURL.path] || [DEAL_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] || [@"/deal/deal.gs" isEqualToString:requestURL.path] )) {
                
                [self checkAndDrawPreloadHeaderL1:requestString1];
                [self callWebViewHeaderAPI:requestString1 isCookieSync:YES OnCompletion:^(NSDictionary *dicApiResult) {
                    
                    [self didSuccessAPICall:requestString1];
                    
                } onError:^(NSError *error) {
                    if (error != nil) {
                        NSLog(@"error = %@",error);
                    }else{
                        //애러 못받아왔으면 통신은 성공했는데 json 데이터가 이상한것
                    }
                    
                    [self didFailAPICall:requestString1];
                }];
                
                isDecisionAllow =  NO;
            }
            
        }else{
            
            //리로드 아니라 일반 링크이동
    
             if (([@"/prd/prd.gs" isEqualToString:requestURL.path] && [requestURL.query containsString:@"prdid="]) || ([@"/deal/deal.gs" isEqualToString:requestURL.path] && [requestURL.query containsString:@"dealNo="])) {
                
                if (
                    [Mocha_Util strContain:@".gsshop.com/cm.html?" srcstring:NCS(self.wview.URL.absoluteString)] ||
                    [Mocha_Util strContain:@".gsshop.com/cp.html?" srcstring:NCS(self.wview.URL.absoluteString)] ||
                    [Mocha_Util strContain:@"/jseis_withLGeshop.jsp?" srcstring:NCS(self.wview.URL.absoluteString)] ||
                    [Mocha_Util strContain:@"/aliaGate.gs?" srcstring:NCS(self.wview.URL.absoluteString)] ||
                    [Mocha_Util strContain:@"/member/gsSuperDlvSel.gs?" srcstring:NCS(self.wview.URL.absoluteString)] ||
                    [Mocha_Util strContain:@"/member/dlvpSel.gs?" srcstring:NCS(self.wview.URL.absoluteString)]
                    
                    //현재 페이지가 푸시용 게이트페이지면 새창을 띄우지 않는다..gsshop.com/cp.html
                    )
                    
                    
                {
                    

                    [self checkAndDrawPreloadHeaderL1:requestString1];
                    [self callWebViewHeaderAPI:requestString1 isCookieSync:YES OnCompletion:^(NSDictionary *dicApiResult) {
                        
                        [self didSuccessAPICall:requestString1];
                        
                    } onError:^(NSError *error) {
                        if (error != nil) {
                            NSLog(@"error = %@",error);
                        }else{
                            //애러 못받아왔으면 통신은 성공했는데 json 데이터가 이상한것
                        }
                        
                        [self didFailAPICall:requestString1];
                    }];
                    
                    
                    isDecisionAllow =  NO;
                }else{
                    NSLog(@"requestURL.query = %@",requestURL.query);
                    if ([requestString1 containsString:@"#dtl_"]) { //딜에서 해당 상품으로 앵커 이동하는 케이스는 예외
                        isDecisionAllow = YES;
                    }else{
                        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
                        result.ordPass = NO;
                        if (([@"/prd/prd.gs" isEqualToString:requestURL.path] && [requestURL.query containsString:@"prdid="] ) || ([@"/deal/deal.gs" isEqualToString:requestURL.path] && [requestURL.query containsString:@"dealNo="]) ) {
                            result.isDealAndPrd = YES;
                        }
                        
                        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌

                        isDecisionAllow =  NO;
                    }
                }
             }
//             else if (self.isDealAndPrd == YES && [@"/mobile/cart/viewCart.gs" isEqualToString:requestURL.path]){
//
//                 ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
//                 result.isNativePassUrl = YES;
//                 result.isDealAndPrd = NO;
//                 [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
//
//                 isDecisionAllow =  NO;
//             }
            
            
            //단품 네이티브 상단을 사용하는데 페이지가 단품이 아닐경우 헤더 숨김,터치막음
            if (isDecisionAllow == YES) {
                
                if ([PRODUCT_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] == YES ||
                    [DEAL_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] == YES ||
                    ([@"/member/logIn.gs" isEqualToString:requestURL.path] == YES && [requestURL.query containsString:@"returnurl="]) ||
                    [@"/mygsshop/mobileCentInq.gs" isEqualToString:requestURL.path] == YES ||
                    [@"/m/prd/mcPrdConsultRental.gs" isEqualToString:requestURL.path] == YES ||
                    [@"/member/dlvpSel.gs" isEqualToString:requestURL.path] == YES
                    ) {
                    
                    //단품 네이티브 화면에서 1:1 모바일 상담을 호출할경우
                    //비 로그인 상태에서는 단품네이티브를 유지한채로 로그인 창이들어올것이며
                    //로그인 상태에서는 단품 네이티브 영역 숨김처리후 ,상단 네이게이션 바도 숨겨야함
                    //111
                    if (ApplicationDelegate.islogin == YES && [@"/mygsshop/mobileCentInq.gs" isEqualToString:requestURL.path] == YES && self.isDealAndPrd == YES) {
                        
                        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
                        result.ordPass = NO;
                        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌

                        isDecisionAllow =  NO;
                    }
                    
                    
                    //상담 신청일때 새창 딜단품 네이티브일때
                    if (self.isDealAndPrd == YES && [requestString1 containsString:@"/m/prd/mcPrdConsultRental.gs"] ) {
                            ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
                            result.ordPass = NO;
                            result.isDealAndPrd = NO;
                            result.delegate = self.delegate;
                            result.view.tag = 505;
                            [self.navigationController pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
                            isDecisionAllow = NO;
                    }
                    
                    
                    //배송지 선택의 경우도 추가됨...
                    //상담신청 상품의경우 비 로그인시 상담신청 버튼에서 toapp://login 안들어오고 상담신청 페이지에서 들어오는 관계로 예외추가
                    if ([@"/member/dlvpSel.gs" isEqualToString:requestURL.path] == YES) {
                        if (ApplicationDelegate.islogin ==  YES) {
                            //로그인 상태 일때에만 상단,네이티브 숨김
                            [self.wview setBackgroundColor:[UIColor whiteColor]];
                            [self.wview setOpaque:YES];
                            [self.wview hideHeaderView];
                            self.webPrdNaviBarView.hidden = YES;
                            //[ApplicationDelegate.HMV showTabbarView];
                            [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:requestURL.path];
                            isDecisionAllow =  YES;
                        }else{
                            NSLog(@"비로그인 상담신청");
                        }

                    }
                    
                    
                    
                    
                }
                else {
                    
                    [self.wview setBackgroundColor:[UIColor whiteColor]];
                    [self.wview setOpaque:YES];
                    [self.wview hideHeaderView];
                    self.webPrdNaviBarView.hidden = YES;
                    if(isShowing) {
                        [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:wview.URL.absoluteString];
                    }
                    isDecisionAllow =  YES;
                }
            }
        }
    }
     
    
    
    
    //    NSTimeInterval delta = CACurrentMediaTime() - self.loadHTMLStart;
    //    NSLog(@"wviewAppStart ALLOW TIME: %f", delta);
  
    if(isDecisionAllow){
        NSLog(@"");
        if (self.isNativePassUrl == YES) {
            if( ([PRODUCT_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] || [@"/prd/prd.gs" isEqualToString:requestURL.path] || [DEAL_NATIVE_BOTTOM_URL isEqualToString:requestURL.path] || [@"/deal/deal.gs" isEqualToString:requestURL.path] )) {
                ApplicationDelegate.HMV.tabBarView.hidden = YES;
            }
            else {
                [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:requestURL.path];
            }
            self.isNativePassUrl = NO;
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        NSLog(@"");
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    
    if ((response.statusCode == 400 || response.statusCode == 404 || response.statusCode == 500) &&
        ([response.URL.path containsString:@"/prd/prd.gs"] || [response.URL.path containsString:@"/deal/deal.gs"] || [response.URL.path containsString:@"/plan/shop/detail.gs"] || [response.URL.path containsString:@"/jbp/brandMain.gs"]|| [response.URL.path containsString:@"/cart/viewCart.gs"])
        ) {
        NSLog(@"response.URL.absoluteString = %@",response.URL.path);
        [self.view addSubview:[self RefreshGuideView]];
    }
    
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

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
   
    if(self.wview.viewHeader != nil) {
        [ApplicationDelegate.gactivityIndicator isDownLoding];
    }
    [ApplicationDelegate.gactivityIndicator startAnimating];
}

/*! @abstract Invoked when a server redirect is received for the main
 frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"");
}

/*! @abstract Invoked when an error occurs while starting to load data for
 the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"errorerror = %@",error);
    
    // nami0342 - 네트워크 다운 시 팝업 노출
    if(error != nil)
    {
        if(error.code == -1009)
        {
            NSString *strRequestURL = [webView.URL absoluteString] == nil ? self.urlString : [webView.URL absoluteString];
            
            if(![ApplicationDelegate isthereMochaAlertView]){
                
                NSArray *buttonTitleArray = [NSArray arrayWithObjects:@"이전 단계로", @"새로고침", nil];
                NSArray *buttonTitleArrayHome = [NSArray arrayWithObjects:@"이전 단계로", nil];
                NSArray *buttonArray;
                
                // nami0342 - 특정 페이지에선 네트워크 접속 불가 시 메인 매장으로 이동하게 처리 - 최유진m 요청
                if([Mocha_Util strContain:@"ordSht.gs?" srcstring:strRequestURL] == YES)
                {
                    buttonArray = buttonTitleArrayHome;
                }
                else
                {
                    buttonArray = buttonTitleArray;
                }
                
                Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GNET_SERVERDOWN maintitle:nil delegate:self buttonTitle:buttonArray];
                malert.tag = 10010;
                [ApplicationDelegate.window addSubview:malert];
                
            }
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [ApplicationDelegate.gactivityIndicator stopAnimating];
            
            return;
        }
    }
    
    
    //이부분은 앱 꺼져있을때 Push를 받아 최초 접근시 appdelegate loadingDone을 위한.
    if(firstLoading) {
        firstLoading = NO;
        ApplicationDelegate.appfirstLoading = NO;
        [ApplicationDelegate loadingDone];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

/*! @abstract Invoked when content starts arriving for the main frame.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"");
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSTimeInterval delta = CACurrentMediaTime() - self.loadHTMLStart;
    NSLog(@"ResultWebView LoadFinish TIME: %f", delta);
    
    NSString *documentURL = self.wview.URL.absoluteString;
    [ApplicationDelegate GTMscreenOpenSendLog:documentURL];
    if(isShowing) {
        [ApplicationDelegate checkFloatingPurchaseBarWithWebView:wview url:documentURL];
    }
    self.wview.currentDocumentURL = documentURL;
    
    NSLog(@"currentDocumentURL = %@",wview.currentDocumentURL);
        
    //이부분은 앱 꺼져있을때 Push를 받아 최초 접근시 appdelegate loadingDone을 위한.
    
    if(firstLoading) {
        firstLoading = NO;
        ApplicationDelegate.appfirstLoading = NO;
        [ApplicationDelegate loadingDone];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    //회원탈퇴면.. 로그아웃처리
    if ([Mocha_Util strContain:GS_LEAVEGSMEMBER_FININSH_URL srcstring:NCS(self.wview.URL.absoluteString)]) {
        [ApplicationDelegate appjsProcLogout:nil];
    }
    
    //헤더상단 네이티브
    //[self checkNativeTopURL:documentURL];
    
    if (self.isUpdateWebHeight) {
        [self callJscriptMethod:[NSString stringWithFormat:@"%@resizeAppNativeDiv(%0.2f);", self.jspPrefix, self.headerHeight]];
        self.isUpdateWebHeight = NO;
    }
    
    if (self.wview.viewHeader != nil) {
        // 과금팝업 노출여부를 웹으로 전달
        NSString *strNoDataWarningFlag = @"N";
        if ([[DataManager sharedManager].strGlobal3GAgree isEqualToString:@"Y"]) {
            strNoDataWarningFlag = @"Y";
        }
        [self callJscriptMethod:[NSString stringWithFormat:@"%@setNoDataWarningFlag('%@');", self.jspPrefix, strNoDataWarningFlag]];
        
        // 음소거 여부를 웹으로 전달
        NSString *strMuteStatus = @"Y";
        if ([[DataManager sharedManager].strGlobalSound isEqualToString:@"Y"] || [[[DataManager sharedManager] strGlobalSound] isEqualToString:@"D"]) {
            strMuteStatus = @"N";
        }
        
        [self callJscriptMethod:[NSString stringWithFormat:@"%@muteStatus('%@');", self.jspPrefix, strMuteStatus]];
    }
}



/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    
    
    //    // nami0342 - 네트워크 다운 시 토스트 메시지 노출
    //    if(error != nil)
    //    {
    //        if(error.code == -1009)
    //        {
    //            [Mocha_ToastMessage toastWithDuration:1.0 andText:GSSLocalizedString(@"network_down") inView:ApplicationDelegate.window];
    //        }
    //    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    // nami0342 : Send Exception log
    [ApplicationDelegate SendExceptionLog:error];
}

/*! @abstract Invoked when the web view needs to respond to an authentication challenge.
 @param webView The web view that received the authentication challenge.
 @param challenge The authentication challenge.
 @param completionHandler The completion handler you must invoke to respond to the challenge. The
 disposition argument is one of the constants of the enumerated type
 NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
 the credential argument is the credential to use, or nil to indicate continuing without a
 credential.
 @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    NSLog(@"");
    
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
    SecTrustSetExceptions(serverTrust, exceptions);
    CFRelease(exceptions);
    completionHandler(NSURLSessionAuthChallengeUseCredential,
                      [NSURLCredential credentialForTrust:serverTrust]);
}

//iOSScript 처리 핸들러
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"WKScriptMessage.name = %@",message.name);
    NSLog(@"WKScriptMessage.body = %@",message.body);
    
    //헤더상단 네이티브
    NSLog(@"* content offset 11: %f, %f", [[self.wview scrollView] contentOffset].x, [[self.wview scrollView] contentOffset].y);
    
    NSString *strReturn = [Common_Util wkScriptAction:message delegate:self];
    
    if ([strReturn length] > 0 && [@"layerOpen" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        //self.wview.isViewHeaderFirstResponder = NO;
        
        if (self.webPrdNaviBarView != nil) {
            // 레이어팝업 노출시 단품 네비바 Dim show
            [self.webPrdNaviBarView setDimViewWithIsShow:YES];
        }
        
        if (self.wview.viewHeader != nil && [self.wview.viewHeader isMiniplayer] ) {
            // 레이어팝업 노출할때 miniPlayer가 있다면 일시정지 후 miniPlayer 사라지게 처리
            [self.wview.viewHeader pauseFromWeb];
            [self.wview.viewHeader hideMiniPlayerView];
        }
        
    }else if ([strReturn length] > 0 && [@"layerClose" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        //self.wview.isViewHeaderFirstResponder = YES;
        
        if (self.webPrdNaviBarView != nil) {
            // 레이어팝업 닫힐때 단품 네비바 Dim Hidden
            [self.webPrdNaviBarView setDimViewWithIsShow:NO];
        }
        
        if (self.wview.viewHeader != nil && [self.wview.viewHeader isMiniplayer]) {
            // 레이어팝업 노출할때 miniPlayer가 있다면 일시정지 후 miniPlayer 사라지게 처리
            
            [self.wview.viewHeader showMiniPlayerView];
            [self.wview.viewHeader playFromWeb];
        }
        
    }else if ([strReturn length] > 0 && [@"refreshCart" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        
        [[WKManager sharedManager] copyToSharedCookieName:WKCOOKIE_NAME_CART OnCompletion:^(BOOL isSuccess) {
            if (isSuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PRODUCT_NATIVE_CARTUPDATE object:nil userInfo:nil];
            }
        }];
    }else if ([strReturn length] > 0 && [@"broadAlertSet" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        [self.wview.viewHeader broadAlertSet];
    }else if ([strReturn length] > 0 && [@"broadAlertCancel" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        [self.wview.viewHeader broadAlertCancel];
    }else if ([strReturn length] > 0 && [@"zzimOk" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        // 2020. 04. 27 : 웹 Zzim UI로 변경 -> 애니메이션 통일
        [self.wview.viewHeader zzimSet];
    }else if ([strReturn length] > 0 && [@"zzimCancel" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        // 2020. 04. 27 : 웹 Zzim UI로 변경 -> 애니메이션 통일
        [self.wview.viewHeader zzimCancel];
    }else if ([strReturn length] > 0 && [@"hideHeader" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        self.webPrdNaviBarView.hidden = YES;
    }else if ([strReturn length] > 0 && [@"showHeader" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        self.webPrdNaviBarView.hidden = NO;
    }else if ([strReturn length] > 0 && [@"webMute" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        [DataManager sharedManager].strGlobalSound = @"N";
        [[NSNotificationCenter defaultCenter] postNotificationName:GS_GLOBAL_SOUND_CHANGE object:nil userInfo:nil];
    }else if ([strReturn length] > 0 && [@"webSound" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        [DataManager sharedManager].strGlobalSound = @"Y";
        [[NSNotificationCenter defaultCenter] postNotificationName:GS_GLOBAL_SOUND_CHANGE object:nil userInfo:nil];
    }else if ([strReturn length] > 0 && [@"noDataWarning" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        [DataManager sharedManager].strGlobal3GAgree = @"Y";
    }else if ([strReturn length] > 0 && [@"showDataWarning" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        [DataManager sharedManager].strGlobal3GAgree = @"N";
    }else if ([strReturn length] > 0 && [@"webPlay" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        // Web에서 영상 플레이시 APP으로 전달 - APP에서 플레이중인 영상을 중지
        [self.wview.viewHeader pauseFromWeb];
    }else if ([strReturn length] > 0 && [@"fullScreen" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        // Web 영상플레이어 전체화면 클릭시
        [self.webPrdNaviBarView setHidden:YES];
        [self.wview.viewHeader hideMiniPlayerView];
    }else if ([strReturn length] > 0 && [@"onScreen" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        // Web 영상플레이어 축소화면 클릭시
        [self.webPrdNaviBarView setHidden:NO];
        [self.wview.viewHeader showMiniPlayerView];
    }else if ([strReturn length] > 0 && [@"noDimmLayerOpen" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        // 딤없는 레이어가 열렸다!
        if (self.wview.viewHeader != nil && [self.wview.viewHeader isMiniplayer]) {
            // 레이어팝업 노출할때 miniPlayer가 있다면 일시정지 후 miniPlayer 사라지게 처리
            //현재 플레이어 상태 체크 및 저장
            
            [self.wview.viewHeader pauseFromWeb];
            [self.wview.viewHeader hideMiniPlayerView];
        }
    }
    else if ([strReturn length] > 0 && [@"noDimmLayerClose" isEqualToString:strReturn] && self.wview.viewHeader != nil) {
        // 딤없는 레이어가 닫혔다.
        if (self.wview.viewHeader != nil && [self.wview.viewHeader isMiniplayer]) {
           // 레이어팝업 노출할때 miniPlayer가 있다면 일시정지 후 miniPlayer 사라지게 처리
           
           [self.wview.viewHeader showMiniPlayerView];
            [self.wview.viewHeader playFromWeb];
        }
    }
    else if ([strReturn length] >0 && [strReturn  hasPrefix:@"setScrollOffsetY"] && self.wview.viewHeader != nil) {
        // @"setScrollOffsetY&hegith=800"
        NSString *heightStr = NCS([strReturn componentsSeparatedByString:@"="].lastObject);
        if ([heightStr length] > 0 && [heightStr floatValue] > 0) {
            // 높이만큼 스크롤
            CGFloat moveHeight = (CGFloat) heightStr.floatValue - STATUSBAR_HEIGHT;
            [self.wview.scrollView setContentOffset:CGPointMake(0, moveHeight) animated:true];
        }
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wview) {
        if(self.wview.estimatedProgress >= 0.6f && ApplicationDelegate.gactivityIndicator.isAnimating == YES) {
            [ApplicationDelegate.gactivityIndicator stopAnimating];
            
            NSTimeInterval delta = CACurrentMediaTime() - self.loadHTMLStart;
            NSLog(@"ResultWebView LoadFinish TIME: %f", delta);
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 단품 네이티브

- (void)didSuccessAPICall:(NSString *)requestString1{
    dispatch_async(dispatch_get_main_queue(),^{
        if(isShowing) {
            ApplicationDelegate.HMV.tabBarView.hidden = YES;
        }

        self.urlString = requestString1;
        [self clearWebView];
        [self reInitNativeTopWebView];

        NSLog(@"self.viewHeader.frame = %@",NSStringFromCGRect(self.viewHeader.frame));
        NSLog(@"self.view.subviews = %@",self.view.subviews);
   });
}

- (void)didFailAPICall:(NSString *)requestString1{
    dispatch_async(dispatch_get_main_queue(),^{
       
        
        if (self.webPrdNaviBarView != nil){
            [self.webPrdNaviBarView removeFromSuperview];
            self.webPrdNaviBarView.aTarget = nil;
            self.webPrdNaviBarView = nil;
        }
        if (self.wview.viewHeader != nil) {
            [self.wview.viewHeader removeMiniPlayerView];
        }
        if (self.viewHeader != nil){
            [self.viewHeader viewDidDisappear];
            [self.viewHeader removeFromSuperview];
            self.viewHeader = nil;
        }
        
        self.dicHeader = nil;
        
        self.isNativePassUrl = YES; //API 애러시 바이패스를 위한 플래그
        self.urlString = requestString1;
        
        [self clearWebView];
        [self reInitNativeTopWebView];
        self.curUrlUse = NO; //오류가 발생하면 뒤로가기 할때 흰화면 노출하지 않도록 처리
   });
}

-(void)reInitNativeTopWebView{
    if (self.wview == nil) {
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [userContentController addScriptMessageHandler:self name:@"iOSScript"];
        [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
        config.userContentController = userContentController;
        config.allowsInlineMediaPlayback = YES;
        config.processPool = [[WKManager sharedManager] getGSWKPool];
        self.wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT) configuration:config];
        self.curUrlUse = YES;
        [self.wview setBackgroundColor:[UIColor clearColor]];
        [self.wview setOpaque:NO];
        
        self.wview.navigationDelegate = self;
        self.wview.UIDelegate = self.wview;
        self.wview.scrollView.delegate = self;
        self.wview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.wview addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
        
        
        if (self.viewHeader != nil) {
            self.wview.viewHeader = self.viewHeader;
        }
        NSLog(@"self.dicHeaderself.dicHeader = %@",self.dicHeader);

        if (self.isNativePassUrl == YES) {
            [self.wview setBackgroundColor:[UIColor whiteColor]];
            [self.wview setOpaque:YES];
            self.urlString = [self reChangeNativeProductURLOnError:self.urlString];
        }else{
            self.urlString = [self changeNativeProductURL:self.urlString];
        }
       
        NSLog(@"self.viewHeader.frame = %@",NSStringFromCGRect(self.viewHeader.frame));
    
        NSLog(@"self.view.subviews = %@",self.view.subviews);
        if (self.viewHeader != nil) {
            [self.view insertSubview:self.wview atIndex:1];
        }else{
            [self.view addSubview:self.wview];
        }

        if (self.dicHeader != nil) {
            //받아서 높이 계산후 넘긴다 일단 하드코딩
            self.headerHeight = (long)APPFULLWIDTH;
            [self.wview addHeaderViewWithResult:self.dicHeader andNavigationDelegate:self andFrame:CGRectMake(0, 0, APPFULLWIDTH, self.headerHeight)];
            [self drawWebViewHeaderNavigationBar:self.dicHeader];
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
        [self.wview loadRequest:request];
    }
}

- (void)backFromWebviewHeader{
    
//    if([Common_Util checkBlankWebView:self.wview urlUse:self.curUrlUse]) {
//        if([self.wview canGoBack]) {
//            [self.wview goBack]; // 뒤로가면 단품이 있을꺼란 기대..
//        }
//        else {
//            [self.navigationController popViewControllerMoveInFromTop];
//        }
//    }else {
//        [self.navigationController popViewControllerMoveInFromTop];
//    }
    
    if([self.wview canGoBack]) {
        WKBackForwardList *list = [self.wview backForwardList];
        NSLog(@"%@",list.backItem.URL.absoluteString);
          if (
              [Mocha_Util strContain:@".gsshop.com/cm.html?" srcstring:NCS(list.backItem.URL.absoluteString)] ||
              [Mocha_Util strContain:@".gsshop.com/cp.html?" srcstring:NCS(list.backItem.URL.absoluteString)] ||
              [Mocha_Util strContain:@"/jseis_withLGeshop.jsp?" srcstring:NCS(list.backItem.URL.absoluteString)] ||
              [Mocha_Util strContain:@"/aliaGate.gs?" srcstring:NCS(list.backItem.URL.absoluteString)]
              )
                      //현재 페이지가 푸시용 게이트페이지면 새창을 띄우지 않는다..gsshop.com/cp.html
                      //단품 네이티브의경우 현재페이지가 딜일경우에도 새창을 띄우지 않는다
                  {
                      NSLog(@"self.view.subviews = %@",self.view.subviews);
                      [self removeAllObject];
                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                             [ApplicationDelegate.gactivityIndicator stopAnimating];
                             [self.navigationController popViewControllerMoveInFromTop];
                  }
          else {
              [self.wview goBack];
          }
    }
    else {
        [self removeAllObject];
        NSLog(@"self.view.subviews = %@",self.view.subviews);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ApplicationDelegate.gactivityIndicator stopAnimating];
        [self.navigationController popViewControllerMoveInFromTop];
    }
}

-(void)homeFromWebviewHeader{
    NSArray *arrPopVC =  [self.navigationController popToRootViewControllerAnimated:YES];
    for (UIViewController *vc in arrPopVC) {
        NSLog(@"vcvcvcvc = %@",vc);
        if ([vc isKindOfClass:[ResultWebViewController class]]) {
            ResultWebViewController *rvc = (ResultWebViewController *)vc;
            [rvc removeAllObject];
        }
    }
    [ApplicationDelegate.HMV firstProc];
}

- (void)drawWebViewHeader:(NSDictionary *)dic{

    self.dicHeader = dic;
    
    if (self.viewHeader != nil) {
        [self.wview.viewHeader removeMiniPlayerView];
        [self.viewHeader viewDidDisappear];
        [self.viewHeader removeFromSuperview];
        self.viewHeader = nil;
    }
    
    self.viewHeader = [[[NSBundle mainBundle] loadNibNamed:@"WebPrdView" owner:self options:nil] firstObject];
    
    self.viewHeader.aTarget = self;
    self.viewHeader.hidden = NO;
    self.viewHeader.frame = CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH,APPFULLWIDTH);
    [self.viewHeader setCellInfoNDrawData:self.dicHeader];
    
    
    [self.view addSubview:self.viewHeader];
    self.viewHeader.translatesAutoresizingMaskIntoConstraints = NO;

    self.topLayoutConstraint = [self.viewHeader.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:STATUSBAR_HEIGHT];
    [NSLayoutConstraint activateConstraints:@[
        self.topLayoutConstraint,
        [self.viewHeader.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.viewHeader.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    ]];
    [self.viewHeader layoutIfNeeded];
    [self.wview setOpaque:NO];
    
    [self drawWebViewHeaderNavigationBar:dic];
    
}

-(void)drawWebViewHeaderNavigationBar:(NSDictionary *)dic{
// 단품 네이티브에 사용할 상단 NaviBar뷰 추가
    if (self.webPrdNaviBarView == nil) {
        self.webPrdNaviBarView = [[[NSBundle mainBundle] loadNibNamed:@"WebPrdNaviBarView" owner:self options:nil] firstObject];
        self.webPrdNaviBarView.aTarget = self;
    }
    
    self.webPrdNaviBarView.hidden = NO;
    // 장바구니 url 설정
    NSString *strCart = SMARTCART_URL;
    if ([@YES isEqual:[dic objectForKey:@"isGSFresh"]]) {
        strCart = SMARTCART_GSFRESH_URL;
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=418824")];
    }
    
    
    self.webPrdNaviBarView.cartUrl = strCart;
    
    //[[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
    [self.webPrdNaviBarView updateCartCountView];
    //}];
    
//        CGFloat positionY = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGRect naviFrame = CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, WebPrdNaviBarView.WEB_PRD_NAVIBAR_HEIGHT);
    self.webPrdNaviBarView.frame = naviFrame;
    [self.view addSubview:self.webPrdNaviBarView];
    self.webPrdNaviBarView.autoresizingMask = UIViewAutoresizingNone;
}


-(void)callWebViewHeaderAPI:(NSString *)strCheckUrl  isCookieSync:(BOOL)isSync OnCompletion:(NativeAPI_CompletionBlock)completionBlock onError:(NativeAPI_ErrorBlock)errorBlock{
    NSURL *urlCheck = [NSURL URLWithString:strCheckUrl];

    if ([urlCheck.query containsString:@"prdid="] || [urlCheck.query containsString:@"dealNo="]) {
        
        URLParser *parser = [[URLParser alloc] initWithURLString:strCheckUrl];
        NSString *strPrdId = NCS([parser valueForVariable:@"prdid"]);
        NSString *strDealNo = NCS([parser valueForVariable:@"dealNo"]);
        NSString *pgmId = NCS([parser valueForVariable:@"pgmID"]);

        BOOL isPrd = NO;
        NSString *strNumber = @"";
        
        if ([strPrdId length] > 4) {
            isPrd = YES;
            strNumber = [NSString stringWithFormat:@"%@?pgmID=%@",strPrdId, pgmId];
        }else if ([strDealNo length] > 4) {
            isPrd = NO;
            strNumber = [NSString stringWithFormat:@"%@?pgmID=%@",strDealNo,pgmId];
        }
        NSLog(@"시간시간시간:쿠키싱크 전");
        if (isSync) {
            [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
                NSLog(@"시간시간시간:쿠키싱크 후");
                if(isSuccess) {
                    [self nativeAPICallWithNumber:strNumber isPrd:isPrd OnCompletion:^(NSDictionary *dicApiResult) {
                        completionBlock(dicApiResult);
                    } onError:^(NSError *error) {
                        errorBlock(error);
                    }];
                }else{
                    //쿠키 복사가 실패한경우 1번 재시도 하고 , 그래도 실패할경우 웹 로딩으로 전환
                    [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
                        if(isSuccess) {
                            [self nativeAPICallWithNumber:strNumber isPrd:isPrd OnCompletion:^(NSDictionary *dicApiResult) {
                                completionBlock(dicApiResult);
                            } onError:^(NSError *error) {
                                errorBlock(error);
                            }];
                        }else{
                            errorBlock(nil);
                        }
                    }];
                }
            }];
        }else{
            [self nativeAPICallWithNumber:strNumber isPrd:isPrd OnCompletion:^(NSDictionary *dicApiResult) {
                completionBlock(dicApiResult);
            } onError:^(NSError *error) {
                errorBlock(error);
            }];
        }
    }
    
}

-(void)nativeAPICallWithNumber:(NSString *)strNumber isPrd:(BOOL)isPrd OnCompletion:(NativeAPI_CompletionBlock)completionBlock onError:(NativeAPI_ErrorBlock)errorBlock{
    
    [self.currentOperation cancel];
    self.currentOperation = [ApplicationDelegate.gshop_http_core gsProductTopNative:strNumber isPrd:isPrd OnCompletion:^(NSDictionary *dicResult) {

//      if ([@"success" isEqualToString:NCS([dicResult objectForKey:@"msg"])]) {
                    
        dispatch_async(dispatch_get_main_queue(),^{
            [ApplicationDelegate.gactivityIndicator stopAnimating];
        });
        
        self.typeCode = NCS([dicResult objectForKey:@"prdTypeCode"]);
        if (([@"PRD" isEqualToString:self.typeCode]) ||
            ([@"DEAL" isEqualToString:self.typeCode]) ||
            ([@"PRD_FRESH" isEqualToString:self.typeCode]) ||
            ([@"PRD_THEBANCHAN" isEqualToString:self.typeCode])) {

            dispatch_async(dispatch_get_main_queue(),^{
                [self.wview setBackgroundColor:[UIColor clearColor]];
                [self.wview setOpaque:NO];
            });
            
            // 자바스크립트 prefix String
            self.jspPrefix = [NSString stringWithFormat:@"%@", [@"DEAL" isEqualToString:self.typeCode] ? @"dealAppController." : @"prdAppController."];
            
            // 단품 진입시 현재 앱에 설정된 음소거 플래그값, 과금 플래그값을 웹으로 전달해야함.
            NSString *isMute = NCS(DataManager.sharedManager.strGlobalSoundForWebPrd);
            if ([isMute isEqualToString:@"Y"]) {
                isMute = @"Y";
            } else {
                isMute = @"N";
            }
            DataManager.sharedManager.strGlobalSoundForWebPrd = isMute;
            
            
            NSString *data3GAgreeFlag = NCS(DataManager.sharedManager.strGlobal3GAgree);
            if ([data3GAgreeFlag isEqualToString:@"Y"]) {
                data3GAgreeFlag = @"Y";
            } else {
                data3GAgreeFlag = @"N";
            }
            DataManager.sharedManager.strGlobal3GAgree = data3GAgreeFlag;
            
            self.dicHeader = dicResult;
            completionBlock(dicResult);
            
        }else{
            self.dicHeader = nil;
            errorBlock(nil);
        }
        
    } onError:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^{
            [ApplicationDelegate.gactivityIndicator stopAnimating];
        });
        self.dicHeader = nil;
        errorBlock(error);
    }];
}


-(NSString *)changeNativeProductURL:(NSString *)strCheck{
    NSURL *urlCheck = [NSURL URLWithString:strCheck];
    
    NSString *strTopHeaderCheck = [strCheck copy];
    if ([@"/prd/prd.gs" isEqualToString:urlCheck.path] && [urlCheck.query containsString:@"prdid="]) {
        NSString *strFront = [[strCheck componentsSeparatedByString:urlCheck.path] objectAtIndex:0];
        strTopHeaderCheck = [NSString stringWithFormat:@"%@%@?%@&appH=%ld",strFront,PRODUCT_NATIVE_BOTTOM_URL,urlCheck.query,(long)self.headerHeight];
    }else if ([@"/deal/deal.gs" isEqualToString:urlCheck.path] && [urlCheck.query containsString:@"dealNo="]) {
        NSString *strFront = [[strCheck componentsSeparatedByString:urlCheck.path] objectAtIndex:0];
        strTopHeaderCheck = [NSString stringWithFormat:@"%@%@?%@&appH=%ld",strFront,DEAL_NATIVE_BOTTOM_URL,urlCheck.query,(long)self.headerHeight];
    }

    return strTopHeaderCheck;
}

-(NSString *)reChangeNativeProductURLOnError:(NSString *)strCheck{
    NSURL *urlCheck = [NSURL URLWithString:strCheck];
    
    NSString *strTopHeaderCheck = [strCheck copy];
    NSString *strRemoveAppH = urlCheck.query;
    
    if ([strRemoveAppH containsString:@"&appH="]) {
        NSArray *arrSplit = [strRemoveAppH componentsSeparatedByString:@"&appH="];
        strRemoveAppH = [arrSplit objectAtIndex:0];
    }
    
    if ([PRODUCT_NATIVE_BOTTOM_URL isEqualToString:urlCheck.path] && [urlCheck.query containsString:@"prdid="]) {
        NSString *strFront = [[strCheck componentsSeparatedByString:urlCheck.path] objectAtIndex:0];
        strTopHeaderCheck = [NSString stringWithFormat:@"%@%@?%@",strFront,@"/prd/prd.gs",strRemoveAppH];
    }else if ([DEAL_NATIVE_BOTTOM_URL isEqualToString:urlCheck.path] && [urlCheck.query containsString:@"dealNo="]) {
        NSString *strFront = [[strCheck componentsSeparatedByString:urlCheck.path] objectAtIndex:0];
        strTopHeaderCheck = [NSString stringWithFormat:@"%@%@?%@",strFront,@"/deal/deal.gs",strRemoveAppH];
    }

    return strTopHeaderCheck;
}

-(void)checkAndDrawPreloadHeaderL1:(NSString *)strCheck{
    NSURL *urlCheck = [NSURL URLWithString:strCheck];
    if ( [@"/prd/prd.gs" isEqualToString:urlCheck.path] || [PRODUCT_NATIVE_BOTTOM_URL isEqualToString:urlCheck.path] || [@"/deal/deal.gs" isEqualToString:urlCheck.path] || [DEAL_NATIVE_BOTTOM_URL isEqualToString:urlCheck.path] ) {
        NSMutableDictionary *dicTest = [[NSMutableDictionary alloc] init];
        NSString *strLowerQuery = [urlCheck.query lowercaseString];

        if ( [urlCheck.query containsString:@"prdid="] && [strLowerQuery containsString:@"ispre=y"]){
            URLParser *parser = [[URLParser alloc] initWithURLString:strCheck];
            NSString *strPrdId = NCS([parser valueForVariable:@"prdid"]);
            if ([NCS(strPrdId) length] > 4){
                NSString *strL1PrdImageUrl = [Common_Util productImageUrlWithPrdid:strPrdId withType:@"L1"];
                [dicTest setObject:strL1PrdImageUrl forKey:@"preCachingUrl"];
            }
        }
        
        [self drawWebViewHeader:[dicTest copy]];
    }
}

-(void)updateHeaderCartCount{
    if (self.webPrdNaviBarView != nil) {
        [self.webPrdNaviBarView updateCartCountView];
    }
}

-(void)updateSound{
    if(self.wview.viewHeader != nil){
        if ([[DataManager sharedManager].strGlobalSound isEqualToString:@"Y"]) {
            // 소리 on
            [self.wview.viewHeader isMuteFromWebWithValue:false];
        }else{
            // 소리 off : 음소거
            [self.wview.viewHeader isMuteFromWebWithValue:true];
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollView.contentOffset.y = %f",scrollView.contentOffset.y);
    CGFloat offsetY = scrollView.contentOffset.y;
    self.topLayoutConstraint.constant = STATUSBAR_HEIGHT - offsetY;
    [self.viewHeader layoutIfNeeded];
    [self.webPrdNaviBarView updateNaviBarWithOffset: offsetY];
    [self.viewHeader updateBrightCoveViewWithContentOffset:offsetY target:self];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"");
}


-(void)sendAmplitudeAndMseqWithAction:(NSString *)strAction{
    
    if ([NCS(strAction) length] > 0) {
        
        NSString *strEventName = @"";
        NSString *strMseq = @"";
        NSString *strMixAction = [NSString stringWithFormat:@"%@",strAction];
        NSString *strDealOrPrd = @"prdCd";
        NSString *strPrdIdValue = NCS([self.dicHeader objectForKey:@"prdCd"]);
        NSArray *arrComp = [self.dicHeader objectForKey:@"components"];
        NSString *strPrdTitle = @"";
        NSString *strPrdType = @"";
        

        for (NSDictionary *dicSubComp in arrComp) {
            if ([NCS([dicSubComp objectForKey:@"templateType"]) isEqualToString:@"prdNmInfo"]) {
                NSArray *arrExpoName = [dicSubComp objectForKey:@"expoName"];
                if ([arrExpoName count] > 1 ) {
                    NSDictionary *dicType = [arrExpoName firstObject];
                    strPrdType = [dicType objectForKey:@"textValue"];
                    
                    NSDictionary *dicName = [arrExpoName objectAtIndex:1];
                    strPrdTitle = [dicName objectForKey:@"textValue"];
                    
                }else if ([arrExpoName count] == 1){
                    NSDictionary *dicName = [arrExpoName objectAtIndex:0];
                    strPrdTitle = [dicName objectForKey:@"textValue"];
                }
            }
        }

        
        if ([@"PRD" isEqualToString:self.typeCode]){
            strEventName = @"Click-단품-상세설명";
        }else if ([@"DEAL" isEqualToString:self.typeCode]){
            strEventName = @"Click-딜-상세설명";
            strDealOrPrd = @"dealNo";
            strPrdIdValue = NCS([self.dicHeader objectForKey:@"dealNo"]);
        }else if ([@"PRD_FRESH" isEqualToString:self.typeCode]){
            strEventName = @"Click-단품-상세설명";
        }else if ([@"PRD_THEBANCHAN" isEqualToString:self.typeCode]){
            strEventName = @"Click-단품-상세설명";
        }
        
        //상품 상세 영역
        if ([@"header_장바구니" isEqualToString:strAction]) {
            strMseq = ([@"PRD" isEqualToString:self.typeCode])?@"398045":@"418920";
        }else if ([@"header_home" isEqualToString:strAction]) {
            strMseq = ([@"PRD" isEqualToString:self.typeCode])?@"409206":@"408522";
        }else if ([@"header_검색" isEqualToString:strAction]) {
            strMseq = ([@"PRD" isEqualToString:self.typeCode])?@"398044":@"418921";
        }else if ([@"판매가_미리계산" isEqualToString:strAction]) {
            strMseq = ([@"PRD" isEqualToString:self.typeCode])?@"397024":@"";
        }else if ([@"공유하기" isEqualToString:strAction]) {
            strMseq = ([@"PRD" isEqualToString:self.typeCode])?@"397081":@"397207";
        }else if ([@"찜" isEqualToString:strAction]) {
            strMseq = ([@"PRD" isEqualToString:self.typeCode])?@"397029":@"408656";
        }else if ([@"매장명(파트너스/JBP)" isEqualToString:strAction]) {
            strEventName = @"";//매장명 골라오기
            strMseq = @"";//mseq 분기 (API가 보내줌)
            strMixAction = strAction;
            
        }else if ([@"구매/배송_묶음배송" isEqualToString:strAction]) {
            strMseq = ([@"PRD" isEqualToString:self.typeCode])?@"418865":@"";
        }else if ([@"배송지 변경" isEqualToString:strAction]){
            strMixAction = strAction;
        }else if ([@"배송지 선택" isEqualToString:strAction]){
            strMixAction = strAction;
        }else if ([@"새벽배송지 선택" isEqualToString:strAction]){
            strMixAction = strAction;
        }else if ([@"배송가능시간" isEqualToString:strAction]){
            strMixAction = strAction;
        }
        
        
        //동영상 관련
        if ([strAction hasPrefix:@"대표_동영상"]) {
            NSString *strSuffix = [[strAction componentsSeparatedByString:@"_"] lastObject];
            NSString *strLiveOrVOD = @"VOD";
            NSString *strAutoPlay = ([self.urlString containsString:@"vodPlay="])?@"자동재생":@"수동재생";
            
            for (NSDictionary *dicSubComp in arrComp) {
                if ([NCS([dicSubComp objectForKey:@"templateType"]) isEqualToString:@"mediaInfo"]) {
                    NSArray *arrVideoList = [dicSubComp objectForKey:@"videoList"];
                    if ([arrVideoList count] > 0 ) {
                        NSDictionary *dicFirstVideoList = [arrVideoList firstObject];
                        if ([NCS([dicFirstVideoList objectForKey:@"liveYN"]) isEqualToString:@"Y"] &&
                            [NCS([dicFirstVideoList objectForKey:@"videoUrl"]) hasSuffix:@".m3u8"]
                            ) {
                            strLiveOrVOD = @"Live";
                            break;
                            //라이브인지 확인로직 , 아니면 다 VOD
                        }
                    }
                }
            }
            
            if ([strSuffix isEqualToString:@"자동재생"]) {
                strMixAction = [NSString stringWithFormat:@"대표_동영상_%@_자동재생",strLiveOrVOD];
            }else if ([strSuffix isEqualToString:@"Play"]){
                strMixAction = [NSString stringWithFormat:@"대표_동영상_%@_%@_Play",strLiveOrVOD,strAutoPlay];
            }else if ([strSuffix isEqualToString:@"취소"]){
                strMixAction = [NSString stringWithFormat:@"대표_동영상_%@_%@_취소",strLiveOrVOD,strAutoPlay];
            }else if ([strSuffix isEqualToString:@"확인"]){
                strMixAction = [NSString stringWithFormat:@"대표_동영상_%@_%@_확인",strLiveOrVOD,strAutoPlay];
            }else if ([strSuffix isEqualToString:@"Mini"]){
                strMixAction = @"대표_동영상_Mini";
            }
        }

        NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:strMixAction,@"action",strPrdIdValue,strDealOrPrd,strPrdTitle,@"prdNm",strPrdType,@"type",nil];
        NSLog(@"dicPropdicProp = %@",dicProp);
        
        if ([@"공유하기" isEqualToString:strAction] == false) {
            [ApplicationDelegate setAmplitudeEventWithProperties:strEventName properties:dicProp];
        }
        
        if ([NCS(strMseq) length] > 0) {
            NSString *strM = [NSString stringWithFormat:@"?mseq=%@",strMseq];
            NSLog(@"strMstrM = %@",strM);
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strM)];
        }
        
        
    }
}

-(void)sendBhrGbnEvent:(NSString *)strEvent andTotalTime:(NSTimeInterval)timeTotal andCurrentTime:(NSTimeInterval)timeCurrent{
    
    if ([@"DEAL" isEqualToString:self.typeCode]){
        return;
    }

    NSString *strPrdIdValue = NCS([self.dicHeader objectForKey:@"prdCd"]);
    NSArray *arrComp = [self.dicHeader objectForKey:@"components"];
    NSString *strLiveOrVOD = @"";
    NSString *strBrightCoveID = @"";
    NSString *strBaseMseq = @"";
    NSString *strRefMseq = @"";
    URLParser *parseURL = [[URLParser alloc] initWithURLString:NCS(self.urlString)];

    if ([NCS([parseURL valueForVariable:@"mseq"]) length] > 0){
        strRefMseq = [parseURL valueForVariable:@"mseq"];
    }
    
    for (NSDictionary *dicSubComp in arrComp) {
        if ([NCS([dicSubComp objectForKey:@"templateType"]) isEqualToString:@"mediaInfo"]) {
            NSArray *arrVideoList = [dicSubComp objectForKey:@"videoList"];
            if ([arrVideoList count] > 0 ) {
                NSDictionary *dicFirstVideoList = [arrVideoList firstObject];
                if ([NCS([dicFirstVideoList objectForKey:@"liveYN"]) isEqualToString:@"Y"] &&
                    [NCS([dicFirstVideoList objectForKey:@"videoUrl"]) hasSuffix:@".m3u8"]
                    ) {
                    strLiveOrVOD = @"Live_";
                }else if ([NCS([dicFirstVideoList objectForKey:@"videoUrl"]) hasSuffix:@".mp4"]){
                    strLiveOrVOD = @"mp4";
                }else{
                    if ([arrVideoList count] > 0 ) {
                        NSDictionary *dicSecondVideoList = [arrVideoList objectAtIndex:0];
                        if ([NCS([dicSecondVideoList objectForKey:@"videoId"]) length] > 4){
                            strBrightCoveID = NCS([dicSecondVideoList objectForKey:@"videoId"]);
                            strLiveOrVOD = @"bcPlayer_";
                        }
                    }
                }
            }
        }
    }
  
    if ([@"" isEqualToString:strLiveOrVOD] == NO && [@"mp4" isEqualToString:strLiveOrVOD] == NO ) {
        
        if ([@"bcPlayer_" isEqualToString:strLiveOrVOD]) {
            strBaseMseq = ([self.urlString containsString:@"vodPlay="])?@"418646":@"418869";
        }else {
            strBaseMseq = ([self.urlString containsString:@"vodPlay="])?@"418650":@"418649";
        }
    }
    
    
    if ([NCS(strBaseMseq) length] > 0) {
        NSString *strM = @"";
        if ([@"bcPlayer_" isEqualToString:strLiveOrVOD]) {
            NSString *strTT = [NSString stringWithFormat:@"%ld",(long)timeTotal];
            NSString *strPT = [NSString stringWithFormat:@"%ld",(long)timeCurrent];
            strM = [NSString stringWithFormat:@"?bhrGbn=%@%@&prdid=%@&vid=%@&mseq=%@&pt=%@&tt=%@&ref=%@",strLiveOrVOD,strEvent,strPrdIdValue,strBrightCoveID,strBaseMseq,strPT,strTT,strRefMseq];
        }else if ([@"Live_" isEqualToString:strLiveOrVOD]) {
            strM = [NSString stringWithFormat:@"?bhrGbn=%@%@&mseq=%@&prdid=%@&ref=%@",strLiveOrVOD,strEvent,strBaseMseq,strPrdIdValue,strRefMseq];
        }else if ([@"mp4" isEqualToString:strLiveOrVOD] && [@"PLAY" isEqualToString:strEvent]) {
            strM = @"?mseq=418869";
        }
        
        if ([strM length] > 0) {
            //NSLog(@"strMstrM = %@",strM)
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strM)];
        }
        
        
    }
}

#pragma mark - 웹뷰 400,404,500 일경우 애러화면
-(UIView*)RefreshGuideView {
    
    UIView *viewBackGround = [[UIView alloc] initWithFrame:self.wview.frame];
    viewBackGround.backgroundColor= [UIColor whiteColor];
    viewBackGround.tag = TBREFRESHBTNVIEW_TAG;
    
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    [containView setCenter:CGPointMake(self.wview.center.x, self.wview.center.y + 50)];
    containView.backgroundColor= [UIColor clearColor];
    //containView.tag = TBREFRESHBTNVIEW_TAG;
    //새로고침아이콘
    UIImageView* loadingimgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Network_error_icon.png"]];
    [loadingimgView setFrame:CGRectMake(150-37, 40, 75, 88)];
    [containView addSubview:loadingimgView];


    UILabel* gmentLabel = [[UILabel alloc] init];
    gmentLabel.text = [NSString stringWithFormat:@"%@", @"데이터 연결이 원활하지 않습니다."];
    gmentLabel.textAlignment = NSTextAlignmentCenter;
    gmentLabel.font = [UIFont boldSystemFontOfSize:17];
    gmentLabel.backgroundColor = [UIColor clearColor];
    gmentLabel.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.64] ;
    gmentLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [gmentLabel setFrame:CGRectMake(25, 147, 250, 24)];
    [containView addSubview:gmentLabel];
    UILabel* gmentLabel1 = [[UILabel alloc] init];
    gmentLabel1.text = [NSString stringWithFormat:@"%@", @"잠시 후 다시 시도해 주시기 바랍니다."];
    gmentLabel1.textAlignment = NSTextAlignmentCenter;
    gmentLabel1.font = [UIFont boldSystemFontOfSize:14];
    gmentLabel1.backgroundColor = [UIColor clearColor];
    gmentLabel1.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.48] ;
    gmentLabel1.lineBreakMode = NSLineBreakByTruncatingTail;

    [gmentLabel1 setFrame:CGRectMake(25, 175, 250, 20)];
    [containView addSubview:gmentLabel1];
    
    //새로고침 버튼
    UIButton* cbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn1 setFrame:CGRectMake(containView.frame.size.width/2 - 85,205,70,32)];
    [cbtn1 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn1.backgroundColor = [UIColor whiteColor];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateNormal];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn1.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn1.layer.cornerRadius = 4.0f;
    [cbtn1.layer setMasksToBounds:NO];
    cbtn1.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn1.layer.shadowRadius = 0.0;
    cbtn1.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn1.layer.borderWidth = 1;
    cbtn1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn1.tag = 1;
    [containView addSubview:cbtn1];
    
    // nami0342 - [웹으로 보기] 버튼 추가
    UIButton* cbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn2 setFrame:CGRectMake(containView.frame.size.width/2 -7,205,85,32)];
    [cbtn2 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn2.backgroundColor = [UIColor whiteColor];
    [cbtn2 setTitle:GSSLocalizedString(@"View_on_the_web_text")  forState:UIControlStateNormal];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn2 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn2.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn2.layer.cornerRadius = 4.0f;

    [cbtn2.layer setMasksToBounds:NO];
    cbtn2.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn2.layer.shadowRadius = 0.0;
    cbtn2.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn2.layer.borderWidth = 1;
    cbtn2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn2.tag = 2;
    [containView addSubview:cbtn2];
    
    [viewBackGround addSubview:containView];
    containView.center = viewBackGround.center;
    
    return viewBackGround;
}

//버튼 전용
-(void)ActionBtnContentRefresh:(id)sender {
    [ApplicationDelegate onloadingindicator];
    
    if(sender == nil)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *btnTemp = (UIButton *)sender;
        
        if(btnTemp.tag == 1)
        {
            [[self.view viewWithTag:TBREFRESHBTNVIEW_TAG] removeFromSuperview];
            [self.wview reload];
        }
        else if(btnTemp.tag == 2)
        {
            
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
    });
}
@end
