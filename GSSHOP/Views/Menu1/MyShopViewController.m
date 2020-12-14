//
//  MyShopViewController.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 12. 15..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "MyShopViewController.h"
#import "URLDefine.h"
#import "DataManager.h"
#import "LoginData.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Mocha_MPViewController.h"
#import "Common_Util.h"
#import "URLParser.h"
#import "LiveTalkViewController.h"
#import "SNSManager.h"

#import <Photos/Photos.h>

#import "NSHTTPCookie+JAVASCRIPT.h"
#import "MobileLiveViewController.h"
#import <AirBridge/AirBridge.h>

@interface MyShopViewController ()

@end

@implementation MyShopViewController
@synthesize wview;
@synthesize loginView;
@synthesize curRequestString;
//@synthesize currentOperation1;

@synthesize popupWebView,popupAttachView;

@synthesize curUrlUse;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        abNomalCount = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    // nami0342
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [ApplicationDelegate offloadingindicator];
    NSLog(@"wview dealloc");
    if ([self isViewLoaded]) {
        [self.wview removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    self.wview.UIDelegate = nil;
    self.wview.navigationDelegate = nil;
    self.wview = nil;
    loginView = nil;
    self.popupWebView = nil;
    
    self.popupAttachView = nil;
    
}
#pragma mark - View lifecycle


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
    
    [ApplicationDelegate.HMV showTabbarView];
}
-(void)viewWillDisappear:(BOOL)animated {
    [self.wview stopLoading];
    //[self.currentOperation1 cancel];
    //딜, 단품 floating 처리
    [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:nil];
    if(self.wview != nil) {
        self.wview.parentViewController = nil;
    }
    [super viewWillDisappear:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [ApplicationDelegate.HMV showTabbarView];    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    //20160323 parksegun 키보드 처리용
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


/**
 NSURLRequest(NSMutableURLRequest) 클래스의 setCachePolicy: 메소드 캐시 정책
 
 NSURLRequestUseProtocolCachePolicy(Default)
 - 프로토콜에 가장 부합하는 정책.
 NSURLRequestReloadIgnoringCacheData(NSURLRequestReloadIgnoringLocalCacheData)
 - URL로딩 시스템이 캐시를 완전히 무시하고 원격지 소스로부터 데이터를 로딩하는 정책.
 NSURLRequestReturnCacheDataElseLoad
 - 캐시된 데이터가 있다면, 로컬캐시로 부터 데이터를 가져오며, 없다면 원격지 소스로부터 데이터를 로딩한다.
 NSURLRequestReturnCacheDataDontLoad
 - (네트워크 연결 안함)로컬 캐시에 있는 정책만을 리턴함. 만약 응답이 로컬 캐시안에 없다면 nil이 리턴됨. 오프라인 모드에 대한 기능과 비슷함.
 */
-(void) firstProc {
    NSLog(@"MYSHOP MYSHOP MYSHOP firstProcfirstProcfirstProc");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wkSessionSuccess)
                                                 name:WKSESSION_SUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wkSessionFail)
                                                 name:WKSESSION_FAIL
                                               object:nil];
    //쿠키 동기화를 항상한다.
    [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
    
    
}

-(void)wkSessionSuccess{
    
    NSMutableURLRequest *urlRequest1;
    
    if(ApplicationDelegate.URLSchemeString != nil) {
        
        urlRequest1 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:ApplicationDelegate.URLSchemeString ] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
        ApplicationDelegate.URLSchemeString = nil;
    }
    else {
        urlRequest1 = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:MYSHOP_URL ] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
    }
    [self resetWebviewForLoad:urlRequest1];
    
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
    [self.navigationController popViewControllerMoveInFromTop];
}

// 로드전 웹뷰를 초기화하고 다시 설정후 url로드함.
-(void) resetWebviewForLoad:(NSMutableURLRequest *) urlRequest {
    if (self.wview != nil) {
        [self.wview removeFromSuperview];
        [self.wview removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
        self.wview.UIDelegate = nil;
        self.wview.navigationDelegate = nil;
        self.wview = nil;
    }
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
    config.userContentController = userContentController;
    config.processPool = [[WKManager sharedManager] getGSWKPool];
    config.allowsInlineMediaPlayback = YES;
    
    self.wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH, APPFULLHEIGHT - APPTABBARHEIGHT - STATUSBAR_HEIGHT) configuration:config];
    
//    self.wview = [[NSTWKWebViewWarmuper sharedViewWarmuper] dequeueWarmupedWKWebView];
//    self.wview.frame = CGRectMake(0,STATUSBAR_HEIGHT,APPFULLWIDTH, APPFULLHEIGHT - APPTABBARHEIGHT - STATUSBAR_HEIGHT);
    
    [self.wview addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:NULL];
    
    self.wview.navigationDelegate = self;
    self.wview.UIDelegate = self.wview;
    
    
    [self.wview setBackgroundColor:[UIColor whiteColor]];
    [self.wview setOpaque:NO];
    
    [self.view addSubview:wview];
    
    
    NSLog(@"GSWKWebViewGSWKWebViewGSWKWebView = %@",wview);
    //in-call 스테이터스바 확장 대응 2016.01 yunsang.jin
    self.wview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.wview loadRequest:urlRequest];
}


-(void)callPMSMessgaeBox {
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"proctm1");
        ////탭바제거
        [ApplicationDelegate updateBadgeInfo:[NSNumber numberWithBool:NO]];
        [ApplicationDelegate pressShowPMSLISTBOX];
        
        NSLog(@"proctm2");
        
        
    } );
    
}

- (IBAction)IBActionPMSMessageModalOpen:(id)sender {
    [self callPMSMessgaeBox];    
}


#pragma mark - WKWebView Delegates

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString;
    BOOL isDecisionAllow = YES;
    
    // 201611010 parksegun
    //이슈: 메모리가 넉넉한 아이폰의 경우 히스토리백일때 메모리에 남아 았던 웹뷰가 그대로 노출되면서 쿠키 및 스크립트가 동작하지 않아, 최근본 상품 처리가 단말에 따라,상품에 따라 상이한 케이스가 발생함.
    //이를 해결하고자 뒤로가기일때 웹뷰캐시를 제거 하여 쿠키 동작및 스크립트가 동작하도록 유도함.
    if(WKNavigationTypeBackForward == navigationAction.navigationType) {
        if ([requestString1 length] > 0 && ([requestString1 rangeOfString:@"/deal.gs?"].location != NSNotFound || [requestString1 rangeOfString:@"/prd.gs?"].location != NSNotFound))
        {
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
    
    //VOD영상 재생 - 20130102   + 딜상품 VOD영상 재생 - 20130226
    if(isDecisionAllow == YES &&  ( ([requestString1 hasPrefix:@"toapp://vod?url="]) || ([requestString1 hasPrefix:@"toapp://dealvod?url="]) || ([requestString1 hasPrefix:@"toapp://basevod?url="]) ))    //vod 방송
    {
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestVODVideo:requestString1];
        }
        else {
            self.curRequestString = [NSString stringWithString:requestString1];
            self.curUrlUse = NO;
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 888;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow = NO;
    }
    
    
    //생방송
    if(isDecisionAllow == YES && ( ([requestString1 hasPrefix:@"toapp://liveBroadUrl?param="]) ||([requestString1 hasPrefix:@"toApp://liveBroadUrl?param="]) ))  //live 방송
    {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query3 = [livetv lastObject];
        NSLog(@"moviePlay = %@",query3);
        
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestLiveVideo:query3];
        }else {
            
            self.curRequestString = [NSString stringWithString:query3];
            self.curUrlUse = NO;
            
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 777;
            [ApplicationDelegate.window addSubview:malert];
            
        }
        
        
        isDecisionAllow = NO;
    }
    
    //공통영상 재생 20150626 v3.1.6.17이후
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://livestreaming?"]) {
        //글로벌 데이터 동의 변경
        if([requestString1 containsString:@"globalConfirm=Y"]) {
            [DataManager sharedManager].strGlobal3GAgree = @"Y";
        }
        
        //https://jira.gsenext.com/browse/PDP-111
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi ||
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
        isDecisionAllow = NO;
    }
    
    
    //20160805 parksegun NativeSNS 팝업창 호출 // toapp://snsshow
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://snsshow"]){
        [self showSnsScriptView];
        isDecisionAllow = NO;
    }
    
    
    // 공유하기 기능 20160630 배포건
    // 201606 parksegun 공유하기 기능 변경
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://share?"]){
        
        NSString *share = [requestString1 stringByReplacingOccurrencesOfString:@"toapp://share?" withString:@""];
        NSLog(@"share: %@",share);
        
        if([share hasPrefix:@"target=facebook&"]){
            // 페이스북
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            //NSLog(@"link = %@ \n message = %@ \n imageurl = %@ \n subject = %@", [parser valueForVariable:@"link"], [parser valueForVariable:@"message"], [parser valueForVariable:@"imageurl"], [parser valueForVariable:@"subject"]);
            
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)
                                ];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_FACEBOOK];
            isDecisionAllow = NO;
        }
        
        if([share hasPrefix:@"target=twitter&"]){
            // 트위터
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)
                                ];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_TWITTER];
            isDecisionAllow = NO;
        }
        
        //20160722 line 추가
        if([share hasPrefix:@"target=line&"]){
            //라인
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)
                                ];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_LINE];
            isDecisionAllow = NO;
        }
        if([share hasPrefix:@"target=kakaotalk&"]){
            //라인
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)
                                ];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_KAKAOTALK];
            isDecisionAllow = NO;
        }
        if([share hasPrefix:@"target=kakaostory&"]){
            //라인
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)
                                ];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_KAKAOSTORY];
            isDecisionAllow = NO;
        }
        
        if([share hasPrefix:@"target=etc&"]){
            // 기타
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
            
            SNSManager *tsns = [SNSManager snsPostingWithUrl:[[parser valueForVariable:@"link"] urlDecodedString]
                                                        text:[[parser valueForVariable:@"message"] urlDecodedString]
                                                    imageUrl:[[parser valueForVariable:@"imageurl"] urlDecodedString]
                                                   imageSize:CGSizeMake(0, 0)
                                ];
            tsns.target = self;
            [tsns NSNSPosting:TYPE_SHARE];
            isDecisionAllow = NO;
            
        }
    }
    
    
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://back"]) //폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
    {
        
        
        NSArray *comp = [requestString1 componentsSeparatedByString:@"//"];
        NSString *query1 = [comp lastObject];
        if([query1 isEqualToString:@"back"])
        {
            
            if([wview canGoBack]) {
                
                [wview goBack];
                
            }else {
                //fifthview는 각 탭의 루트뷰이므로
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
        [self firstProc];
        
        //웹뷰 외 사용시 return 처리해야 함
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
            NSString *msg = [[NSString alloc] initWithFormat:@"앱로그인 상태에서 toapp://login 호출됨: MyShopView url=%@ 자동로그인인가? %@, requestString1 %@", self.wview.lastEffectiveURL, ([DataManager sharedManager].m_loginData.autologin == 1 ? @"YES" : @"NO") , requestString1 ];
            [ApplicationDelegate SendExceptionLog:err msg: msg];
            //쿠키동기후 재호출 로직 추가 firstProc에서 쿠키 동기후 재호출한다.
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
            abNomalCount++;
            [self performSelector:@selector(firstProc) withObject:nil];
            [ApplicationDelegate.gactivityIndicator startAnimating];
            return;
        }
        
        //param 없는경우 home으로 포워딩 201404121 v3.1.3.14
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];        
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        if([query2 isEqualToString:@""]){
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
            self.curUrlUse = NO;
        }else {
            self.curRequestString = [NSString stringWithString:query2];
            self.curUrlUse = NO;
        }
        
        NSLog(@"self.curRequestString = %@", self.curRequestString);
        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
        if(loginView != nil) {
            loginView = nil;
        }
        
        loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
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
        [self.navigationController pushViewController:loginView animated:NO];
        
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
        
        
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
        
    }
    
    //로그아웃 요청URL
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGOUTTOAPPURL])
    {
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        
        if([query2 isEqualToString:@""]){
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
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        NSString *title = GSSLocalizedString(@"common_txt_modaltitle_default");
        NSString *landingURL = query2;
        
        // toapp://modal?title=상품설명&url=
        if ([requestString1 hasPrefix:@"toapp://modal?title="])
        {
            NSArray *tempArray = [query2 componentsSeparatedByString:@"&url="];    // 0 : title=상품설명 , 1 : http://
            
            title = [Mocha_Util strReplace:@"title=" replace:@"" string:NCA(tempArray)?[tempArray objectAtIndex:0]:@""];
            
            NSMutableArray *tempArray2 = [NSMutableArray arrayWithArray:tempArray];
            if(tempArray2.count > 0)
                [tempArray2 removeObjectAtIndex:0];
            
            landingURL = [tempArray2 componentsJoinedByString:@"&url="];
        }
        
        NSLog(@"title = %@, landingURL = %@", title, landingURL);
        
        //popup 띄우기 (타이틀 및 UI)
        self.popupWebView = [PopupWebView openPopupWithFrame:wview.frame
                                                   superview:self.view
                                                    delegate:self
                                                         url:landingURL
                                                       title:title
                                                    animated:YES];
        isDecisionAllow = NO;
    }
    
    
    
    //extmodal 띄우기
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://extmodal"] )
    {
        URLParser *oparser = [[URLParser alloc] initWithURLString:requestString1 ];
        
        
        NSLog(@"bbbbbbbbbb = %@ \n nnnnnnnnnn = %@ \n   ",    [[oparser valueForVariable:@"title"] urlDecodedString], [oparser valueForVariable:@"url"]  );
        
        
        if([oparser valueForVariable:@"title"] != nil && [oparser valueForVariable:@"url"] != nil){
            
            
            //popup 띄우기 (타이틀 및 UI)
            self.popupWebView = [PopupWebView openPopupWithFrame:wview.frame
                                                       superview:self.view
                                                        delegate:self
                                                             url:[Common_Util getURLEndcodingCheck:[oparser valueForVariable:@"url"]]
                                                           title:[[oparser valueForVariable:@"title"]  urlDecodedString]
                                                        animated:YES];
            
        }
        isDecisionAllow = NO;
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
                self.popupWebView = [PopupWebView openPopupWithFrame:wview.frame
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
    { // 여기는 나를 닫고가는 로직을 제외함.. 마이숍을 닫을순 없다.
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
            [ApplicationDelegate.gactivityIndicator startAnimating];
            
        });
        
        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
        
        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
        isDecisionAllow = NO;
        
    }
    //* 2016/04/12 예정
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
    //*/
    
    //20160304 parksegun 주문서페이지 새로운 뷰로 처리 하도록 변경
    //20160407 parksegun 주문서 새창띄우기 막기, 백키 관련해서는 유지되야함.
    
    if(isDecisionAllow == YES && [Mocha_Util strContain:@"ordSht.gs" srcstring:requestString1])
    {
        //appModalReAction
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
        result.ordPass = YES;
        result.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        
        isDecisionAllow = NO;
    }
    
    
    //20160307 parksegun movetoinpage 이면 나를 닫고 다른 웹뷰에 URL을 호출한다.
    // 만약 page를 열수없는 상태이면 새로운 웹뷰 창을 띄운다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetoinpage"]) {
        
        
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        NSLog(@"movetoninpage = %@   ", [parser valueForVariable:@"url"]);
        // 인코딩
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];
        
        
        
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
        else if([navigationController.viewControllers count] == 1  ) { // 나뿐이 없다면...
            
            
            ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
            resVC.ordPass = NO;
            resVC.view.tag = 505;
            [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
            
        }
        else
        {
            // 예외처리 필요함.
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
    
    //딜, 단품 floating 처리
    
    BOOL isFrame = ![[[navigationAction.request URL] absoluteString] isEqualToString:[[navigationAction.request mainDocumentURL] absoluteString]];
    NSLog(@"아이프레임 일까요? %i", isFrame);
    
    if(isDecisionAllow == YES ) {
        if(!isFrame) {
            //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
            NSString *strLoadedUrl = NCS(webView.URL.absoluteString);
            if([requestString1 length] > 0 && [strLoadedUrl length] > 0) {
                ////탭바제거
                [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
            }
            webView.tag = self.wview.tag == 0 ? self.view.tag : self.wview.tag;
            [ApplicationDelegate checkFloatingPurchaseBarWithWebView:(GSWKWebview *)webView url:requestString1];
            
            if ([[requestString1 lowercaseString] hasPrefix:@"http:"] || [[requestString1 lowercaseString] hasPrefix:@"https:"]) {
                self.wview.lastEffectiveURL = requestString1;
            }
        }
    }
    
    
    
    if (isDecisionAllow == YES ) {
        //딜/단품은 새창
        if (!isFrame && [requestString1 length] > 0 && ([requestString1 rangeOfString:@"/deal.gs?"].location != NSNotFound || [requestString1 rangeOfString:@"/prd.gs?"].location != NSNotFound)) {
            ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
            result.ordPass = NO;
            result.isDealAndPrd = YES;
            result.delegate = (id <ResultWebViewDelegate>)self;
            result.view.tag = 505;
            [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
            
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
                         
                         
                         [ApplicationDelegate.gactivityIndicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:3.0f];
                         
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
    
    [ApplicationDelegate checkFloatingPurchaseBarWithWebView:wview url:documentURL];
    wview.currentDocumentURL = documentURL;
    
    NSLog(@"currentDocumentURL = %@",wview.currentDocumentURL);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    if ([Mocha_Util strContain:GS_LEAVEGSMEMBER_FININSH_URL srcstring:NCS(wview.URL.absoluteString)]) {
        [ApplicationDelegate appjsProcLogout:nil];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wview) {
        
        if(self.wview.estimatedProgress >= 0.6f && ApplicationDelegate.gactivityIndicator.isAnimating == YES) {
            [ApplicationDelegate.gactivityIndicator stopAnimating];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//isp 처리후 다시 넘어 왔을때 넘어온 주소를 가지고 웹뷰로 다시 넘긴다.
-(void)goWebView:(NSString *)url
{
    NSLog(@"gsurl = %@",url);
    NSURL *goURL = [NSURL URLWithString:url];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    
    [wview loadRequest:requestObj];
}
//javascript 함수호출
-(void)callJscriptMethod:(NSString *)mthd {
    [self.wview evaluateJavaScript:mthd completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"callJscriptMethod mthd = %@",mthd);
        NSLog(@"callJscriptMethod WKresult = %@",result);
        NSLog(@"callJscriptMethod WKerror = %@",error);
        
    }];
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
    
    NSLog(@"__________urlString = %@",self.curRequestString);
    if(loginviewtype == 4)
    {
        //나는 쿠키를 지우고 싶어요.
        NSURL *uRL = [NSURL URLWithString:self.curRequestString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:uRL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        
        [wview loadRequest:requestObj];
        
    }
    else if(loginviewtype == 6)
    {
        //비회원배송조회
        NSURL *goURL = [NSURL URLWithString: NONMEMBERORDERLISTURL(self.curRequestString)];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        
        [wview loadRequest:requestObj];
    }
    else if(loginviewtype == 7)
    {
        NSURL *goURL = [NSURL URLWithString:NONMEMBERORDERURL(self.curRequestString)];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        
        [wview loadRequest:requestObj];
    }
    
    else {
        //로그아웃  loginviewtype == 5 인경우
        //단순 reload 하는 경우 무한루프빠짐.
        //[wview reload];
        
        NSURL *goURL = [NSURL URLWithString:self.curRequestString];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        [wview loadRequest:requestObj];
        
    }
    
    self.curUrlUse = YES;
    
}


-(void)goJoinPage {
    
    NSURL *goURL = [NSURL URLWithString:JOINURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
    
    [wview loadRequest:requestObj];
    
    
}

//가려젓다가 다시 나타 났을때 호출
- (void)webViewReload
{
    [wview reload];
}



#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index {
    if(alert.tag == 380) {
        switch (index) {
            case 1:
                NSLog(@"설정");
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            default:
                break;
        }
        
    }else if(alert.tag == 444) {
        switch (index) {
            case 1:
                //로그아웃? 예
                NSLog(@"self.curRequestString = %@", self.curRequestString);
                //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                if(loginView == nil) {
                    loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                }else{
                    [loginView clearTextFields];
                }
                
                loginView.delegate = self;
                loginView.loginViewType = 5;
                //로그아웃  콜~
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
    
    
    // check 후 call
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
    
    // check 후 call
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


//20160323 parksegun iOS8에서 키보드의 Forword, back 키로 인해 셀렉트박스 이동시 앱이 크래시됨. 이를 막고자 해당 버튼 쩨거 로직 추가
-(void)keyboardDidShow{
    
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


@end

