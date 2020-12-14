//
//  FullWebViewController.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 11. 26..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "FullWebViewController.h"
#import "URLDefine.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DataManager.h"
#import "Mocha_MPViewController.h"
#import "Common_Util.h"
#import "URLParser.h"

@implementation FullWebViewController

@synthesize target;
@synthesize urlString;
@synthesize loginView;
@synthesize curRequestString;

//
@synthesize popupWebView;


#pragma mark -
#pragma mark 액티비티 인디케이터(로딩)


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        abNomalCount = 0;        
    }
    return self;
}
-(id)initWithUrlString:(id)gtarget tgurl:(NSString *)url;
{
    self = [super init];
    if(self !=nil)
    {
        NSLog(@"FullsizeURL 세팅 %@",url);
        target = gtarget;
        self.urlString = url;
        
    }
    return self;
}
//이미지 버튼 처리 : Back 버튼
- (void)GoBack
{
    [self.navigationController popViewControllerMoveInFromTop];
}

- (void)dealloc
{
    
    // nami0342
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(catchNotiCloseEvent)
                                                 name:@"customovieViewRemove"
                                               object:nil];
    
    firstLoading = YES;
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self requestWKWebviewUrlString];
    
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
        
        self.wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0,0,APPFULLWIDTH,APPFULLHEIGHT-[UIApplication sharedApplication].statusBarFrame.size.height) configuration:config];
        self.wview.navigationDelegate = self;
        self.wview.UIDelegate = self.wview;
        
        [self.wview setBackgroundColor:[UIColor whiteColor]];
        [self.wview setOpaque:NO];
        [self.view addSubview:self.wview];
    }
    
    NSLog(@"[[WKManager sharedManager] getGSWKPool] = %@",[[WKManager sharedManager] getGSWKPool]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval];
    
    NSLog(@"\n\n\nResultWebview WKWebview Requested !!!!!!!\n\n\n");
    //NSLog(@"request.allHTTPHeaderFields = %@",request.allHTTPHeaderFields);
    
    [self.wview loadRequest:request];
}



-(void)catchNotiCloseEvent {
    [self.navigationController popViewControllerAnimated:NO];
    
}




//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 11)
//    {
//        [self.navigationController popViewControllerMoveInFromTop];
//    }
//}
-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewDidAppear:NO];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    //딜, 단품 floating 처리
    [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:self.wview.URL.absoluteString ];
    if(self.wview.parentViewController == nil) {
        self.wview.parentViewController = self;
    }
    [super viewWillAppear:NO];
}
- (void)webViewReload
{
    [self.wview reload];
}


- (void)viewWillDisappear:(BOOL)animated
{
    //딜, 단품 floating 처리
    [ApplicationDelegate checkFloatingPurchaseBarWithWebView:self.wview url:nil];
    if(self.wview != nil) {
        self.wview.parentViewController = nil;
    }
    [super viewWillDisappear:NO];
}







////shawn 2012.07.13 subview의 class가 _UIWebViewScrollView 아닌 경우 scrollstoTop Property = (BOOL)NO
////주의.simulator 테스트시 _UIWebViewScrollView 가 UIScrollView로 나옴.
//- (void) subViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val{
//    for (UIView *subview in sview.subviews) {
//        if ([subview isKindOfClass:[UIScrollView class]]) {
//            NSLog(@"pre setscroll  stat = %i", [(UIScrollView*)subview scrollsToTop] );
//            if(([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"_UIWebViewScrollView"])
//               ||
//               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UIScrollView"]))
//                
//            {
//                ((UIScrollView *)subview).scrollsToTop = val;
//            }else {
//                
//                ((UIScrollView *)subview).scrollsToTop = !val;
//                
//            }
//            NSLog(@"change class %@",   [NSString stringWithFormat:@"%s",   object_getClassName(subview)]);
//            NSLog(@"next setscroll stat = %i", [(UIScrollView*)subview scrollsToTop] );
//            
//        }
//        [self subViewchangePropertyForScrollsToTop:subview boolval:val];
//    }
//}





// nami0342 - Main tab 이동 처리
- (void) moveMainTabOnWebView : (URLParser *) parser
{
    [ApplicationDelegate.HMV.navigationController popToRootViewControllerAnimated:NO];
    
    if ([parser valueForVariable:@"tabId"] != nil) {
        [ApplicationDelegate.HMV sectionChangeWithTargetShopNumber:[parser valueForVariable:@"tabId"]];
    }
    
    if ([parser valueForVariable:@"mseq"] != nil) {
        NSString *strSeq = [NSString stringWithFormat:@"?mseq=%@",[parser valueForVariable:@"mseq"]];
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strSeq)];
    }
}




- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString ;
    
    BOOL isDecisionAllow = YES;
    
    // nami0342 - Main Tab 이동 기능 추가.
    if ([Mocha_Util strContain:@".gsshop.com/index.gs" srcstring:requestString1])
    {
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        if ([parser valueForVariable:@"tabId"] != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self moveMainTabOnWebView:parser];
            });
            isDecisionAllow = NO;
        }
    }

    
    
    NSLog(@"URL 요청: %@", requestString1);
    
    //20160913 parkseugn - hasSuffix 에서 예외 발생에 대한 대응 처리
    if(isDecisionAllow == YES && NCS(requestString1).length <= 0)
        isDecisionAllow = NO;
    
    //iOS7 대응
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"gsshopmobile://"])
    {
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    //PMS call protocol
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movemessage"])
    {
        
        [ApplicationDelegate pressShowPMSLISTBOX];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://eventrecv"])
    {
        
        NSString* tstring = [Mocha_Util strReplace:@"toapp://eventrecv?" replace:@"" string:requestString1];
        
        NSLog(@"etvURL: %@", [NSString stringWithFormat:@"%@&devId=%@",tstring,DEVICEUUID]);
        NSURL *evtURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&devId=%@",tstring,DEVICEUUID]];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:evtURL];
        
        [self.wview loadRequest:requestObj];
        
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && (([requestString1 hasSuffix:@"kmcisHpAgreePop_noiframe.html#"]) || ([requestString1 hasSuffix:@"kmcisHp01.jsp#"])|| ([requestString1 hasSuffix:@"kmcisHpDiscrAgreePop_noiframe.html#"])|| ([requestString1 hasSuffix:@"kmcisErr_Mobile.jsp#"]))){
        if ([requestString1 hasSuffix:@"kmcisErr_Mobile.jsp#"]){
            [self.navigationController popViewControllerMoveInFromTop];
        }
        else {
            [self.wview goBack];
        }
        
        isDecisionAllow = NO;
    }
    
    
    
    // start 2012.12.20 외부 safari 웹브라우저로 띄우기 start
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://browser"])
    {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"browser?"];
        NSString *toquery = [livetv lastObject];
        
        NSLog(@"toweb_query = %@",toquery);
        if(   [toquery length] == NO)
        {
            NSLog(@"None URL... Go Homepage");
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else
        {
            //http:// 가 있을경우 http//로 들어옴 http링크의경우만 수정, url schema 호출의경우 http 영향없음.
            //toquery = [Mocha_Util strReplace:@"//" replace:@"://" string:toquery];
            
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.12.20 외부 safari 웹브라우저로 띄우기 end
    
    // start 2012.10.23 외부 safari 웹브라우저로 띄우기 start   (http 및 url schema대응)
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toweb://"])
    {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"toweb://"];
        NSString *toquery = [livetv lastObject];
        
        NSLog(@"toweb_query = %@",toquery);
        if(   [toquery length] == NO)
        {
            NSLog(@"None URL... Go Homepage");
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else
        {
            //http:// 가 있을경우 http//로 들어옴 http링크의경우만 수정, url schema 호출의경우 http 영향없음.
            toquery = [Mocha_Util strReplace:@"//" replace:@"://" string:toquery];
            
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.02.20 내장 웹브라우저로 띄우기 end
    
    
    NSLog(@"requestString1 = %@",requestString1);
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"ispmobile://"]) //isp 결제 주소
    {
        
        NSURL *appUrl = [NSURL URLWithString:requestString1];
        BOOL isInstalled =[[UIApplication sharedApplication] openURL_GS:appUrl];
        if(isInstalled)
        {
            NSLog(@"ispmobile");
        }
        else
        {
            NSURL *videoURL = [NSURL URLWithString:GSISPFAILBACKURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL];
            
            [self.wview loadRequest:requestObj];
            
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSISPDOWNURL]];
        }
        
        //
        isDecisionAllow = NO;
    }
    
    // start 2012.02.09 신한안심클릭 추가 start
    //------------------------------------------------------------------------------
    if(isDecisionAllow == YES && [requestString1 isEqualToString:SHINHANDOWNURL] == YES)
    {
        NSLog(@"1.스마트신한 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    if(isDecisionAllow == YES && [requestString1 hasPrefix:SHINHANAPPNAME])
    {
        NSLog(@"2.스마트신한 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
        
    }
    //------------------------------------------------------------------------------
    // end 2012.02.09 신한안심클릭 추가 end
    
    // start 2013.09.10 신한Mobile 앱 다운로드 url start
    //------------------------------------------------------------------------------
    if (isDecisionAllow == YES && [requestString1 isEqualToString:SHINHANMAPPDOWNURL] == YES ){
        NSLog(@"1. 스마트신한앱 관련 url 입니다. ==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    if (isDecisionAllow == YES &&  [requestString1 hasPrefix:SHINHANAPPCARDAPPNAME]){
        NSLog(@"2. 신한Mobile결제 앱 관련 url 입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    // end 2013.09.10 신한Mobile 앱 다운로드 url end
    
    
    //start 2012.06.25 현대 안심 클릭 url start
    //------------------------------------------------------------------------------
    if(isDecisionAllow == YES && [requestString1 isEqualToString:HYUNDAIDOWNURL] == YES)
    {
        NSLog(@"현대안심클릭 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    if(isDecisionAllow == YES && [requestString1 hasPrefix:HYUNDAIAPPNAME])
    {
        NSLog(@"2.현대안심클릭 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
        
    }
    //------------------------------------------------------------------------------
    //end 2012.06.25 현대 안심 클릭 url end
    
    
    
    //VOD영상 재생 - 20130102   + 딜상품 VOD영상 재생 - 20130226 + 기본 VOD영상재생(버튼overlay없음) 20150211
    if(isDecisionAllow == YES && (([requestString1 hasPrefix:@"toapp://vod?url="]) || ([requestString1 hasPrefix:@"toapp://dealvod?url="]) || ([requestString1 hasPrefix:@"toapp://basevod?url="])))    //vod 방송
    {
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestVODVideo:requestString1];
        }else {
            self.curRequestString = [NSString stringWithString:requestString1];
            
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 888;
            [ApplicationDelegate.window addSubview:malert];
            
            
            
            
        }
        isDecisionAllow =  NO;
    }
    
    
    
    //생방송
    if(isDecisionAllow == YES && (([requestString1 hasPrefix:@"toapp://liveBroadUrl?param="]) ||([requestString1 hasPrefix:@"toApp://liveBroadUrl?param="])))  //live 방송
    {
        
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query3 = [livetv lastObject];
        NSLog(@"moviePlay = %@",query3);
        
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestLiveVideo:query3];
        }else {
            
            self.curRequestString = [NSString stringWithString:query3];
            
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
            
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 999;
            [ApplicationDelegate.window addSubview:malert];
            
        }
        
        
        isDecisionAllow =  NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://close"])
    {
        
        if([Mocha_Util strContain:@"toapp://close?" srcstring:requestString1]) {
            
            NSString* tstring = [Mocha_Util strReplace:@"toapp://close?" replace:@"" string:requestString1];
            
            NSLog(@"query3 = %@",tstring);
            if([tstring length] > 0) {
                
                [self.navigationController popToRootViewControllerAnimated:NO];
                [[self target] appModalReAction:tstring ];
            }
            
        }else {
        
            [self.navigationController popViewControllerMoveInFromTop];
            
        }
        
        isDecisionAllow = NO;
    }
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://back"]) //폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
    {
        
        if([self.wview canGoBack]) {
            [self.wview goBack];
        }else {
            //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
            NSString *strLoadedUrl = NCS(webView.URL.absoluteString);
            if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
                ////탭바제거
                [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
                
            }
            
            [self.navigationController popViewControllerMoveInFromTop];
        }
        
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix: GSMAINURL] ) {
        [self.navigationController popViewControllerMoveInFromTop];
        isDecisionAllow =  NO;
    }
    
    //로그인이 필요한 페이지는 로그인을 하고 페이지를 넘긴다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGINCHECKURL]) {        
        //웹뷰가 toapp://login 호출할경우 기존에 로그인이 되어있으면 API로그아웃이 "아닌" APPJS 방식 로그아웃 호출
        if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
            NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation" code:9000 userInfo:nil];
            NSString *msg = [[NSString alloc] initWithFormat:@"앱로그인 상태에서 toapp://login 호출됨: FullWebView url=%@ 자동로그인인가? %@, requestString1: %@", self.wview.lastEffectiveURL, ([DataManager sharedManager].m_loginData.autologin == 1 ? @"YES" : @"NO"), requestString1  ];
            [ApplicationDelegate SendExceptionLog:err msg: msg];
            decisionHandler(WKNavigationActionPolicyCancel);
            // 재호출 로직 제한
            if(abNomalCount >= ABNOMALMAX) {
                // 앱을 자동로그인 부터 다시 한다.
                NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation_AppExit" code:9001 userInfo:nil];
                [ApplicationDelegate SendExceptionLog:err msg: @"앱메인이동"];
                [ApplicationDelegate callProcess];                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ [self.navigationController popViewControllerAnimated:NO];
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
        NSString *query2 = [comp1 count] > 1 ?[comp1 objectAtIndex:1]:@"";
        
        self.curRequestString = [NSString stringWithString:query2];
        NSLog(@"self.curRequestString = %@", self.curRequestString);
        
        //본창루트 보낸후 로그인페이지로
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[self target] appModalLogin];
        
        isDecisionAllow = NO;
        
    }
    //로그아웃 요청URL
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGOUTTOAPPURL]) {
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = [comp1 count] > 1 ?[comp1 objectAtIndex:1]:@"";        
        self.curRequestString = [NSString stringWithString:query2];
        NSLog(@"self.curRequestString = %@", self.curRequestString);
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:LOGOUTALERTALSTR  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:LOGOUTCONFIRMSTR1,  LOGOUTCONFIRMSTR2, nil]];
        malert.tag = 444;
        
        [self.view addSubview:malert];
        
        isDecisionAllow = NO;
    }
    
    // -- start -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- start --
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"tel:"]) {
        NSString*  tstring = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:requestString1];
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:tstring] ];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"mailto:"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    // -- end -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- end --
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"about:blank"]) //공백페이지
    {
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 isEqualToString:[NSString stringWithFormat:@"%@/",SERVERURI]]){

        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];

        
        isDecisionAllow =  NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 isEqualToString:[NSString stringWithFormat:@"%@",GSMAINURL]]){
        
        [[UIApplication sharedApplication] performSelector:@selector(openURL:) withObject:[NSURL URLWithString:@"gsshopmobile://home"] afterDelay:0.5];

        
        isDecisionAllow =  NO;
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
            NSArray *tempArray = [query2 componentsSeparatedByString:@"&url="];	// 0 : title=상품설명 , 1 : http://
            
            title = [Mocha_Util strReplace:@"title=" replace:@"" string:NCA(tempArray)?[tempArray objectAtIndex:0]:@""];
            
            NSMutableArray *tempArray2 = [NSMutableArray arrayWithArray:tempArray];
            [tempArray2 removeObjectAtIndex:0];
            landingURL = [tempArray2 componentsJoinedByString:@"&url="];
        }
        
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
    
    

    //트위터 외부링크
    if (isDecisionAllow == YES && [[requestString1 lowercaseString] hasPrefix:@"https://twitter.com/"])
    {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    
        
    //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
    NSString *strLoadedUrl = NCS(webView.URL.absoluteString);
    if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
        ////탭바제거
        [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
        
    }
    webView.tag = self.wview.tag == 0 ? self.view.tag : self.wview.tag;
    [ApplicationDelegate checkFloatingPurchaseBarWithWebView:(GSWKWebview *)webView url:requestString1];
    if ([[requestString1 lowercaseString] hasPrefix:@"http:"] || [[requestString1 lowercaseString] hasPrefix:@"https:"]) self.wview.lastEffectiveURL = requestString1;
    
    
    
    if(isDecisionAllow){
        NSLog(@"");
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        NSLog(@"");
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

-(void)callJscriptMethod:(NSString *)mthd {
    
    [self.wview evaluateJavaScript:mthd completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"callJscriptMethod mthd = %@",mthd);
        NSLog(@"callJscriptMethod WKresult = %@",result);
        NSLog(@"callJscriptMethod WKerror = %@",error);
        
    }];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_main_queue(),^{
        [ApplicationDelegate.gactivityIndicator startAnimating];
        
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
    
    //이부분은 앱 꺼져있을때 Push를 받아 최초 접근시 appdelegate loadingDone을 위한.
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

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

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    

    [ApplicationDelegate.gactivityIndicator stopAnimating];
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {
        if(error.code != 101) {
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
    
    
    
    NSLog(@"__________urlString = %@",self.curRequestString);
    if(loginviewtype == 4)
    {
//        NSURL *videoURL = [NSURL URLWithString:self.curRequestString];
//
//        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
//        [self.wview loadRequest:requestObj];
        
        self.urlString = self.curRequestString;
        
        //꼭 딜레이 줘야함
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
        
    }
    else if(loginviewtype == 6)
    {
        //비회원배송조회
//        NSURL *videoURL = [NSURL URLWithString: NONMEMBERORDERLISTURL(self.curRequestString)];
//        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
//        [self.wview loadRequest:requestObj];
        
        self.urlString = NONMEMBERORDERLISTURL(self.curRequestString);
        //꼭 딜레이 줘야함
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
    }
    else if(loginviewtype == 7)
    {
//        NSURL *videoURL = [NSURL URLWithString:NONMEMBERORDERURL(self.curRequestString)];
//        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
//        [self.wview loadRequest:requestObj];
        
        self.urlString = NONMEMBERORDERURL(self.curRequestString);
        //꼭 딜레이 줘야함
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(requestWKWebviewUrlString) userInfo:nil repeats:NO];
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




#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 444) {
        switch (index) {
            case 1:
                //로그아웃? 예
                
                //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
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

    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:nil];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
        
   
    [vc playMovie:[NSURL URLWithString:requrl]];
    
}


//단품 VOD 재생
-(void)playrequestVODVideo:(NSString*)requrl   {
    
    
    
    URLParser *parser = [[URLParser alloc] initWithURLString:requrl];
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
        
    [vc playMovie:[NSURL URLWithString:[parser valueForVariable:@"url"]]];
    
    
    
}




@end


