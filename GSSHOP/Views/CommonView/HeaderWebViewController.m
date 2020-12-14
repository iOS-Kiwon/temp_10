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

@implementation HeaderWebViewController

@synthesize urlString;
@synthesize curRequestString;
@synthesize delegate;
@synthesize popupWebView;
@synthesize popupAttachView;
@synthesize ordPass;
@synthesize wview,curUrlUse,isDealAndPrd;

#define HeaderHeigth 45.0
#pragma mark -
#pragma mark 액티비티 인디케이터(로딩)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        abNomalCount = 0;
    }
    return self;
}

-(id)initWithUrlString:(NSString *)url withString:(NSString *)title {
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
        self.urlString = itemString;
        
        //상단 타이틀 영역 확보
        UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, HeaderHeigth)];
        topBar.backgroundColor = [UIColor whiteColor];
        //백버튼
        float margin = 0.0;
        float btnwidth = 48 - (margin*2);
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin, 1.0, btnwidth, HeaderHeigth - 1.0)];
        backBtn.backgroundColor = [UIColor clearColor];
        backBtn.tag = 0;//
        [backBtn setImage:[UIImage imageNamed:@"web_back.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:backBtn];
        //타이틀 //꽉채움
        UILabel *mainTitle = [[UILabel alloc] initWithFrame:CGRectMake(btnwidth, margin, APPFULLWIDTH - (btnwidth*2), HeaderHeigth)];
        mainTitle.backgroundColor = [UIColor clearColor];
        mainTitle.text = title;
        mainTitle.textAlignment = NSTextAlignmentLeft;
        mainTitle.font = [UIFont boldSystemFontOfSize:17];
        mainTitle.numberOfLines = 1;
        mainTitle.minimumScaleFactor = 0.6f; //최대 17 최소 10? 정도일때
        mainTitle.adjustsFontSizeToFitWidth = YES;        
        mainTitle.textColor = [Mocha_Util getColor:@"222222"];
        [topBar addSubview:mainTitle];
        //닫기
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(APPFULLWIDTH - btnwidth, margin, btnwidth, HeaderHeigth)];
        closeBtn.backgroundColor = [UIColor clearColor];
        closeBtn.tag = 1;
        [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:closeBtn];
        //언더라인
        UIView *underline = [[UIView alloc] initWithFrame:CGRectMake(0, HeaderHeigth-1.0, APPFULLWIDTH, 1.0)];
        underline.backgroundColor = [Mocha_Util getColor:@"E5E5E5"];
        [topBar addSubview:underline];
        
        [self.view addSubview:topBar];
    }
    return self;
}

- (IBAction)headerAction:(id)sender {
    if(((UIButton*)sender).tag == 0) {
        //back
        if([wview canGoBack]) {
            [wview goBack];
        }
        else {
            //빙글빙글 계속 돌고 있어서
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [ApplicationDelegate.gactivityIndicator stopAnimating];
            [self.navigationController popViewControllerMoveInFromTop];
        }
    }
    else {
        //close
        [self.navigationController popViewControllerMoveInFromTop];
    }
}


- (void)dealloc {
    // nami0342
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ApplicationDelegate offloadingindicator];
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self ];
    NSLog(@"wview dealloc");
    wview.UIDelegate = nil;
    wview.navigationDelegate = nil;
    wview = nil;
    loginView = nil;
    self.popupWebView = nil;
    self.popupAttachView = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning: view = %@, superview = %@", [self valueForKey:@"_view"], [[self valueForKey:@"_view"] superview]);
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //20160323 parksegun 키보드 처리용
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    firstLoading = YES;
    
    NSURL *videoURL = [NSURL URLWithString:self.urlString];
    NSURLRequest *requestObj;
    NSLog(@"videoURL = %@",videoURL);
    requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kWebviewTimeoutinterval ];
    //in-call 스테이터스바 확장 대응 2016.01 yunsang.jin
    
    [self requestWKWebviewUrlString];
}


//GA 추적
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //현재 떠있는 웹뷰에 흰화면이면.. back... 혹은 닫기
    NSLog(@"나는 누구인가?: %@",wview.URL.absoluteString);
   
    if([Common_Util checkBlankWebView:self.wview urlUse:self.curUrlUse]) {
        if([self.wview canGoBack]) {
            [self.wview goBack]; // 뒤로가면 단품이 있을꺼란 기대..
        }
        else {
            [self.navigationController popViewControllerMoveInFromTop];
        }
    }
    
    if(self.curUrlUse == YES) {
        self.curUrlUse = NO;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    if( self.wview.parentViewController == nil) {
        self.wview.parentViewController = self;
    }
    
    
}


-(void)requestWKWebviewUrlString{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_FAIL object:nil];
    
    NSLog(@"");
    //https://stackoverflow.com/questions/26573137/can-i-set-the-cookies-to-be-used-by-a-wkwebview/26577303#26577303
    //self.urlString = @"http://m.hnsmall.com/goods/view/13490137";
    NSURL *urlRequest = [NSURL URLWithString:self.urlString];
    
    if (self.wview == nil) {
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = userContentController;
        config.processPool = [[WKManager sharedManager] getGSWKPool];
        config.allowsInlineMediaPlayback = YES;
        
        self.wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0,STATUSBAR_HEIGHT + HeaderHeigth ,APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT - HeaderHeigth) configuration:config];
        self.wview.navigationDelegate = self;
        self.wview.UIDelegate = self.wview;
        
        [self.view addSubview:self.wview];
        
        NSLog(@"wviewwviewwview =%@",self.wview);
        
        [self.wview setBackgroundColor:[UIColor whiteColor]];
        [self.wview setOpaque:NO];
        self.wview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    NSLog(@"[[WKManager sharedManager] getGSWKPool] = %@",[[WKManager sharedManager] getGSWKPool]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
    
    NSLog(@"\n\n\nResultWebview WKWebview Requested !!!!!!!\n\n\n");
    //NSLog(@"request.allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
    
    [self.wview loadRequest:request];
}

//20160323 parksegun iOS8에서 키보드의 Forword, back 키로 인해 셀렉트박스 이동시 앱이 크래시됨. 이를 막고자 해당 버튼 쩨거 로직 추가
-(void)keyboardDidShow {
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


- (void)viewWillDisappear:(BOOL)animated {
    if(wview != nil) {
        wview.parentViewController = nil;
    }
    [super viewWillDisappear:NO];
}

- (void)webViewReload {
    [wview reload];
}
//- (void)viewDidUnload {
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardDidShowNotification
//                                                  object:nil];
//    [super viewDidUnload];
//}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
    
    NSLog(@"loginviewtype = %ld",(long)loginviewtype);
    
    if(loginviewtype == 4)
    {
        
        NSLog(@"self.curRequestString = %@",self.curRequestString);
        
        self.urlString = self.curRequestString;
        
        
        //꼭 딜레이 줘야함
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
        
        
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
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
        
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
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
    }
    
    else if(loginviewtype == 2)
    {
        //성인인증인 경우 webview history 한번더 뒤로~
        if([self.wview canGoBack]) {
            [self.wview goBack];
            
        }else {
            //돌아갈곳이 없다면 홈으로
            [self.navigationController popViewControllerMoveInFromTop];
        }
        
    }
    
    else {
        //로그아웃  loginviewtype == 5 인경우
        [self.wview reload];
        
        
    }
    //curRequestString 사용하였음..
    //20160407 parksegun 로그인뷰가 닫히면서 현재 웹뷰에 이동이 발생하는지 체크하는 플래그 처리
    self.curUrlUse = YES;
    
    
    
}

-(void)goJoinPage {
    
    NSURL *goURL = [NSURL URLWithString:JOINURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
    
    [wview loadRequest:requestObj];
    
    
}


//isp 처리후 다시 넘어 왔을때 넘어온 주소를 가지고 웹뷰로 다시 넘긴다.
- (void) ispResultWeb:(NSString *)url
{
    NSLog(@"__________urlString = %@ ",url);
    
    NSURL *videoURL = [NSURL URLWithString:url];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kWebviewTimeoutinterval ];
    
    [wview loadRequest:requestObj];
    [wview reload];
    
}

-(void)goWebView:(NSString *)url
{
    self.urlString = url;
    //꼭 딜레이 줘야함
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
}

//javascript 함수호출
-(void)callJscriptMethod:(NSString *)mthd {
    
    [self.wview evaluateJavaScript:mthd completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"callJscriptMethod mthd = %@",mthd);
        NSLog(@"callJscriptMethod WKresult = %@",result);
        NSLog(@"callJscriptMethod WKerror = %@",error);
        
    }];
}

#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 380) {
        
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
    
    
}






//공통영상 재생
-(void)playrequestCommonVideo: (NSString*)requrl {
    
    //requrl = toapp://streaming...
    
    
    
    URLParser *parser = [[URLParser alloc] initWithURLString:requrl];
    
    NSLog(@"type = %@ \n url = %@ \n targeturl = %@ ", [parser valueForVariable:@"type"], [parser valueForVariable:@"url"], [parser valueForVariable:@"targeturl"]);
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
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
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString ;
    
    BOOL isDecisionAllow = YES;
    
    // 201611010 parksegun
    //이슈: 메모리가 넉넉한 아이폰의 경우 히스토리백일때 메모리에 남아 았던 웹뷰가 그대로 노출되면서 쿠키 및 스크립트가 동작하지 않아, 최근본 상품 처리가 단말에 따라,상품에 따라 상이한 케이스가 발생함.
    //이를 해결하고자 뒤로가기일때 웹뷰캐시를 제거 하여 쿠키 동작및 스크립트가 동작하도록 유도함.
    if(WKNavigationTypeBackForward == navigationAction.navigationType)
    {
        //현재와 과거 로그인 상태가 다르나? 그럼 리로드
//        if(self.wview != nil && self.wview.isloginInfo != [ApplicationDelegate islogin]) {
//            NSLog(@"로그인 상태가 !!! 상태가!!!!! 상태가 달라!!!!");
//            [self webViewReload];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
        
        if ([requestString1 length] > 0 && ([requestString1 rangeOfString:@"/deal.gs?"].location != NSNotFound || [requestString1 rangeOfString:@"/prd.gs?"].location != NSNotFound))
        {
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }
    }
    NSLog(@"URLREQUEST = %@", requestString1);
    
    //캡슐화 - 공통 처리 를 위해 상위클래스 불러줌
    isDecisionAllow = [self.wview isGSWKDecisionAllowURLString:requestString1 andNavigationAction:navigationAction withTarget:self];
    
    
    
    //검색 공통
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://search"])
    {
        [ApplicationDelegate SearchviewShow];
        isDecisionAllow = NO;
    }
    
    
    //2016.01 라이브톡 추가
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetolivetalk"]) {
        
        NSLog(@"requestString1 = %@",requestString1);
        
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
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://livestreaming?"])
    {
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
            malert.tag = 999;
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
                [self.navigationController popViewControllerMoveInFromTop];
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
                [ApplicationDelegate.HMV sectionReloadWithTargetShopNumber:strTabID];
            }
        }
        
        [self.navigationController popViewControllerMoveInFromTop];
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
    
    //로그인이 필요한 페이지는 로그인을 하고 페이지를 넘긴다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGINCHECKURL]) {
        //웹뷰가 toapp://login 호출할경우 기존에 로그인이 되어있으면 API로그아웃이 "아닌" APPJS 방식 로그아웃 호출
        if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
            NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation" code:9000 userInfo:nil];
            NSString *msg = [[NSString alloc] initWithFormat:@"앱로그인 상태에서 toapp://login 호출됨: HeaderWebView url=%@ 자동로그인인가? %@ requestString1: %@", self.wview.lastEffectiveURL, ([DataManager sharedManager].m_loginData.autologin == 1 ? @"YES" : @"NO"), requestString1 ];
            [ApplicationDelegate SendExceptionLog:err msg:msg];
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
                    [self.navigationController popToRootViewControllerAnimated:NO];
                });
                return;
            }
            abNomalCount++;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(requestWKWebviewUrlString)
                                                         name:WKSESSION_SUCCESS
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(requestWKWebviewUrlString)
                                                         name:WKSESSION_FAIL
                                                       object:nil];
            [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
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
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://setting"]) //내설정
    {
        //내설정
        dispatch_async(dispatch_get_main_queue(),^{
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
    if(isDecisionAllow == YES ){
        
        //iframe 내에서 url request 무시하기
        
        NSLog(@"아이프레임 일까요? %i  ==== %@", isFrame,requestString1);
        if(!isFrame){
            
            //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
            NSString *strLoadedUrl = NCS(self.wview.URL.absoluteString);
            if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
                ////탭바제거
                [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
                
            }
            webView.tag = self.wview.tag == 0 ? self.view.tag : self.wview.tag;
            
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
//            NSLog(@"navigationAction.navigationType = %ld",navigationAction.navigationType);
//
//            NSLog(@"requestString1 = %@",requestString1);
//
//            ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
//            result.ordPass = NO;
//            result.isDealAndPrd = NO;
//            result.delegate = self.delegate;
//            result.view.tag = 505;
//            [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
//            isDecisionAllow = NO;
//        }
        
        // nami0342 - 상품 상세에서 영상 틀어놓고 이동 시 새창이라서 이전 영상이 계속 재생되므로 딜/단품 -> 타 링크 이동 시 새 창으로 뜨는 거 막는 테스트
        if (([requestString1 length] > 0 && self.isDealAndPrd == YES ) &&
             ([requestString1 rangeOfString:@"/ordsht/addOrdSht.gs"].location != NSNotFound ||
             [requestString1 rangeOfString:@"/ordsht/ordShtGate.gs"].location != NSNotFound
             
             )){
                 ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
                 result.ordPass = NO;
                 result.isDealAndPrd = NO;
                 result.delegate = self.delegate;
                 result.view.tag = 505;
                 [self.navigationController pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
                 isDecisionAllow = NO;
            }
        
        //딜/단품은 새창
        if (!isFrame && [requestString1 length] > 0 && ([requestString1 rangeOfString:@"/deal.gs?"].location != NSNotFound || [requestString1 rangeOfString:@"/prd.gs?"].location != NSNotFound) && self.isDealAndPrd == NO) {
            
            NSLog(@"navigationAction.navigationType = %ld",(long)navigationAction.navigationType);
            
            ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
            result.ordPass = NO;
            result.isDealAndPrd = YES;
            result.delegate = self.delegate;
            result.view.tag = 505;
            [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
            
            isDecisionAllow =  NO;
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

/*! @abstract Invoked when a main frame navigation starts.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    //3초로딩인디케이터
    //3초후 강제 제거를 원한다면
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         [ApplicationDelegate.gactivityIndicator startAnimating];
                         
                     }
     
                     completion:^(BOOL finished){
                         
                         
                         //[ApplicationDelegate.gactivityIndicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:3.0f];
                         
                     }];
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
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"errorerror = %@",error);
    
    
    //이부분은 앱 꺼져있을때 Push를 받아 최초 접근시 appdelegate loadingDone을 위한.
    
    if(firstLoading){
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
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"");
    
    
}

/*! @abstract Invoked when a main frame navigation completes.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSString *documentURL = wview.URL.absoluteString;
    [ApplicationDelegate GTMscreenOpenSendLog:documentURL];

    wview.currentDocumentURL = documentURL;
    
    NSLog(@"currentDocumentURL = %@",wview.currentDocumentURL);
    
    
    //이부분은 앱 꺼져있을때 Push를 받아 최초 접근시 appdelegate loadingDone을 위한.
    
    if(firstLoading){
        firstLoading = NO;
        ApplicationDelegate.appfirstLoading = NO;
        [ApplicationDelegate loadingDone];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

/*! @abstract Invoked when an error occurs during a committed main frame
 navigation.
 @param webView The web view invoking the delegate method.
 @param navigation The navigation.
 @param error The error that occurred.
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    
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
    
    //    NSString *strException = [[NSString alloc] initWithData:(__bridge NSData*)exceptions encoding:NSASCIIStringEncoding];
    //    NSLog(@"strException = %@",strException);
    //    NSLog(@"serverTrust = %@",serverTrust);
    
    CFRelease(exceptions);
    
    completionHandler(NSURLSessionAuthChallengeUseCredential,
                      [NSURLCredential credentialForTrust:serverTrust]);
    
}

@end



