//
//  LiveTalkViewController.m
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//
#import "LiveTalkViewController.h"

#import "AppDelegate.h"
#import "Mocha_MPViewController.h"
#import "ResultWebViewController.h"
#import "SNSManager.h"
#import <Photos/Photos.h>

#define chatLeadOne 44.0f
#define chatLeadTwo 80.0f
#define chatBottomSafeArea 20.0f


@interface LiveTalkViewController ()


@property (strong, nonatomic) LiveTalkPlayer* player;

@end



@implementation LiveTalkViewController

@synthesize wview;
@synthesize target;
@synthesize BCinfoDic,brdinfoStr;
@synthesize curRequestString;

@synthesize popupAttachView;
@synthesize popupWebView;

- (void)dealloc {
    self.wview.UIDelegate = nil;
    self.wview.navigationDelegate = nil;
    self.wview = nil;
    self.player = nil;
    self.BCinfoDic = nil;
    self.brdinfoStr = nil;
    self.curRequestString = nil;
    self.popupAttachView = nil;
    loginView = nil;
    self.popupWebView = nil;
    
    if ([timerEndCheck isValid]) {
        [timerEndCheck invalidate];
        timerEndCheck = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIVETALK_HIDDEN_CHAT_OBSERVER_Y object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIVETALK_HIDDEN_CHAT_OBSERVER_N object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    
    ApplicationDelegate.HMV.tabBarView.hidden = YES;
    if(isthisLive == YES  ) {
        iskeyboadOBActive = YES;
        
    }
    
    // 가로해상도가 낮으면 폰트를 줄인다? 레티나이면.. iPhone 4,4s,5,5s,
    // 20160215 parksegun  홍동훈D 요청으로 로그인 필요 멘트 수정 이로 인한 폰트크기 조정은 취소됨.
    //20160225 parksegun 라이브톡 화면이 뜰때마다 commonClickTrack을 호출
     ////탭바제거
    [ApplicationDelegate wiseAPPLogRequest: WISELOGPAGEURL(@"?mseq=408799")];
//    if(ApplicationDelegate.islogin == YES) {
//        text_chatword.placeholder = GSSLocalizedString(@"home_livetalk_placeholder_join_livetalk_text");
//    }
//    else {
//        text_chatword.placeholder = GSSLocalizedString(@"home_nalbang_placeholder_need_login_text");
//    }
    
    if( self.wview.parentViewController == nil) {
        self.wview.parentViewController = self;
    }
    [super viewWillAppear:(BOOL)animated];
}



- (void)viewWillDisappear:(BOOL)animated {
    [self.player pause];

    iskeyboadOBActive = NO;
    if ([timerEndCheck isValid]) {
        [timerEndCheck invalidate];
        timerEndCheck = nil;
    }
    if(self.wview != nil) {
        self.wview.parentViewController = nil;
    }
    [super viewWillDisappear:(BOOL)animated];
}




-(void)hideChatArea {
    InputChattingArea.hidden = YES;
}

-(void)showChatArea {
    InputChattingArea.hidden = NO;
    [self.view bringSubviewToFront:InputChattingArea];
}

- (id)initWithTarget:(id)sender withBCinfoStr:(NSString *)brddic {
    self = [super init];
    if(self) {
        abNomalCount = 0;
        isthisLandingMode = NO;
        isthisLive = NO;
        TopPlayerBGView.frame = CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, [Common_Util DPRateOriginVAL:180]);        
        self.target = sender;
        self.brdinfoStr = brddic;
        arrSns = [[NSMutableArray alloc] init];
       
        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            self.heightBottomSafeArea = window.safeAreaInsets.bottom;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showChatArea)
                                                     name:LIVETALK_HIDDEN_CHAT_OBSERVER_Y
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hideChatArea)
                                                     name:LIVETALK_HIDDEN_CHAT_OBSERVER_N
                                                   object:nil];
        
        URLParser *parser = [[URLParser alloc] initWithURLString:brddic];
        
        //infoapi 수신
        NSURL *turl = [NSURL URLWithString:[[parser valueForVariable:@"topapi"] urlDecodedString] ];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
        
        //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        
        
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *error;
        NSURLResponse *response;
        NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:kMKNetworkKitRequestTimeOutInSeconds error:&error];

        if(!result) {
            self.BCinfoDic = nil;
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"error_server") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 333;
            [ApplicationDelegate.window addSubview:lalert];
        }
        else {
            // nami0342 - JSON
            NSDictionary  *jresult = [result JSONtoValue];
            self.BCinfoDic = jresult;
            if([Mocha_Util strContain:@".m3u8" srcstring:[self.BCinfoDic objectForKey:@"liveUrl" ]]  ) {
                isthisLive = YES;
                iskeyboadOBActive = YES;
                InputChattingArea.hidden = NO;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            }
            else {
                isthisLive = NO;
                //치명 아래는 YES
                InputChattingArea.hidden = YES;
            }
            
            NSLog(@"방송타이틀  %@ %@ === %@",jresult, [self.BCinfoDic objectForKey:@"title"] , [self.BCinfoDic objectForKey:@"liveUrl" ] );
            
            if([self.BCinfoDic objectForKey:@"liveUrl" ] == nil || [[self.BCinfoDic objectForKey:@"liveUrl" ] isEqualToString:@""]) {
                Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"home_livetalk_info_error") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                lalert.tag = 334;
                [ApplicationDelegate.window addSubview:lalert];
                return self;
            }
            
            
            if(ApplicationDelegate.islogin == YES) {
                if([WKManager sharedManager].isSyncronizing == YES) {
                    //기다려야해~
                    [ApplicationDelegate.gactivityIndicator startAnimating];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(contentLoad)
                                                                 name:WKSESSION_SUCCESS
                                                               object:nil];
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(contentLoad)
                                                                 name:WKSESSION_FAIL
                                                               object:nil];
                    return self;
                }
                else {
                    [self contentLoad];
                }
            }
            else {
                [self contentLoad];
            }
            
        }
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];    
//    [btn_chatword.layer setMasksToBounds:NO];
//    btn_chatword.layer.shadowOffset = CGSizeMake(0, 0);
//    btn_chatword.layer.shadowRadius = 0.0;
//    btn_chatword.layer.borderColor = [Mocha_Util getColor:@"dddddd"].CGColor;
//    btn_chatword.layer.borderWidth = 1.0f;
//    btn_chatword.hidden = YES;
    
    
    
    
    self.viewBGchatword.layer.shouldRasterize = YES;
    self.viewBGchatword.layer.cornerRadius = 18.0;
    self.viewBGchatword.layer.rasterizationScale = [UIScreen mainScreen].scale;

    self.viewToastBG.layer.shouldRasterize = YES;
    self.viewToastBG.layer.cornerRadius = 4.0;
    self.viewToastBG.layer.rasterizationScale = [UIScreen mainScreen].scale;

    self.viewPrivacyToastBG.layer.shouldRasterize = YES;
    self.viewPrivacyToastBG.layer.cornerRadius = 4.0;
    self.viewPrivacyToastBG.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    
    // 뷰컨트롤러의 로딩 방식이 다른 뷰컨트롤러와 다른 관계로 viewDidLoad 부분에서의 아래 셋팅은 가능하면 유지
    if(self.heightBottomSafeArea > 0.0) {
        InputChattingArea.frame = CGRectMake(0, InputChattingArea.frame.origin.y - chatBottomSafeArea, APPFULLWIDTH, 44.0);
    }else{
        InputChattingArea.frame = CGRectMake(0, InputChattingArea.frame.origin.y, APPFULLWIDTH, 44.0);
    }
    
    self.viewBGchatword.frame = CGRectMake(80.0, 4.0, APPFULLWIDTH - 80.0 - 8.0, 36.0);
    self.tvChat.frame = CGRectMake(12.0, 0.0, self.viewBGchatword.frame.size.width - 24.0, 36.0);
    
    self.viewSendTalk.frame = CGRectMake(APPFULLWIDTH - 36.0 - 8.0, 4.0 , 36.0, 36.0);
    self.viewSendTalk.hidden = YES;
    
    self.lblToast.frame = CGRectMake(56.0, 16.0, APPFULLWIDTH-56.0-8.0, 17.0);
    
    [self.view bringSubviewToFront:InputChattingArea];
    [self.view layoutIfNeeded];
    
    NSLog(@"InputChattingArea.frame = %@",NSStringFromCGRect(InputChattingArea.frame));
    NSLog(@"self.view = %@",self.view);
    NSLog(@"self.view.subviews = %@",self.view.subviews);
    NSLog(@"self.viewBGchatword = %@",self.viewBGchatword);
}

-(void)setChattingViewFrame{
    CGFloat chatLead = isAttachShowAll?chatLeadTwo:chatLeadOne;
    //CGFloat chatHeight = 36.0;
    CGFloat chatTrailing = self.viewSendTalk.hidden?8.0:52.0;
    
//    if(IS_IPHONE_X_SERISE) {
//        InputChattingArea.frame = CGRectMake(0, APPFULLHEIGHT - 20.0 - (chatHeight+8.0), APPFULLWIDTH, (chatHeight+8.0));
//    }else{
//        InputChattingArea.frame = CGRectMake(0, APPFULLHEIGHT, APPFULLWIDTH, (chatHeight+8.0));
//    }
    
    if (isAttachShowAll) {
        self.viewPhoto.hidden = NO;
        self.viewCamera.hidden = NO;
        self.viewAdd.hidden = YES;
        //self.viewSendTalk.hidden = YES;
//        self.viewBGchatword.frame = CGRectMake(chatLead, 4.0, APPFULLWIDTH - chatLead - 8.0, chatHeight);
//        self.tvChat.frame = CGRectMake(12.0, 0.0, self.viewBGchatword.frame.size.width - 24.0, chatHeight);
    }else{
        self.viewPhoto.hidden = YES;
        self.viewCamera.hidden = YES;
        self.viewAdd.hidden = NO;
        
    }
    self.viewBGchatword.frame = CGRectMake(chatLead, 4.0, APPFULLWIDTH - chatLead - chatTrailing, self.tvChat.frame.size.height);
    self.tvChat.frame = CGRectMake(12.0, 0.0, self.viewBGchatword.frame.size.width - 24.0, self.tvChat.frame.size.height);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([timerEndCheck isValid]) {
        [timerEndCheck invalidate];
        timerEndCheck = nil;
    }
    [self.player checkCartStatus];
    timerEndCheck = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkBroadcastingEnd) userInfo:nil repeats:YES];
}


- (void)getSnsInfo {
    
    NSURL *url = [NSURL URLWithString:[DataManager sharedManager].strSNSINFO_URL];
    NSLog(@"url = url = url = url = %@",url);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    [urlRequest setHTTPMethod: @"GET"];
    
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (!result) {
        NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
        return;
    }
    else {
        // Return results
        NSArray  *resultj = nil;
        @try {
            resultj = [result JSONtoValue];
            [arrSns removeAllObjects];
            [arrSns addObjectsFromArray:resultj];
        }
        @catch (NSException *exception) {
            NSLog(@"exceptionexception = %@",exception);
        }
    }
}




- (void)reloadBCContents:(NSString*)tstr {
    
    self.brdinfoStr = nil;
    self.BCinfoDic = nil;
    
    NSLog(@"brddic = %@",tstr);
    self.brdinfoStr = tstr;
    
    URLParser *parser = [[URLParser alloc] initWithURLString:tstr];
    NSLog(@"noHeaderFlag = %@ \n topapi = %@ \n bottomurl = %@ ", [parser valueForVariable:@"noHeaderFlag"], [[parser valueForVariable:@"topapi"] urlDecodedString], [[parser valueForVariable:@"bottomurl"] urlDecodedString]);
    
    NSURL *turl = [NSURL URLWithString:[[parser valueForVariable:@"topapi"] urlDecodedString] ];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:kMKNetworkKitRequestTimeOutInSeconds error:&error];
    
    if (!result)
    {
        self.BCinfoDic = nil;
        
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"error_server") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        [ApplicationDelegate.window addSubview:lalert];
        lalert.tag = 333;
        
        NSLog(@"error3 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
              [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        
    }
    else {
        
        //  nami0342 - JSON
        NSDictionary  *jresult = [result JSONtoValue];

        self.BCinfoDic = jresult  ;
        
        
        if([Mocha_Util strContain:@".m3u8" srcstring:[self.BCinfoDic objectForKey:@"liveUrl" ]]  ) {
            isthisLive = YES;
            iskeyboadOBActive= YES;
            InputChattingArea.hidden = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
        else {
            
            isthisLive = NO;
            iskeyboadOBActive = NO;
            
            InputChattingArea.hidden = YES;
        }
        
        NSLog(@"방송타이틀  %@ === %@",[self.BCinfoDic objectForKey:@"title"] , [self.BCinfoDic objectForKey:@"liveUrl" ] );
        if([self.BCinfoDic objectForKey:@"liveUrl" ] == nil){
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"error_server") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 333;
            [ApplicationDelegate.window addSubview:lalert];
            return;
        }
        
        
        if(ApplicationDelegate.islogin == YES) {
            if([WKManager sharedManager].isSyncronizing == YES) {
                //기다려야해~
                [ApplicationDelegate.gactivityIndicator startAnimating];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(contentLoad)
                                                             name:WKSESSION_SUCCESS
                                                           object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(contentLoad)
                                                             name:WKSESSION_FAIL
                                                           object:nil];
                return;
            }
            else {
                [self contentLoad];
            }
        }
        else {
            [self contentLoad];
        }
    }
}

- (void) contentLoad {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WKSESSION_FAIL object:nil];
    
    [self ProcSyncAfter:^{
        NSLog(@"proctm2");
        // Do any additional setup after loading the view, typically from a nib.\\
        
        self.player = [[[NSBundle mainBundle] loadNibNamed:@"LiveTalkPlayer" owner:self options:nil] firstObject];
        
        [self.player setupWithNframe:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, (180.0/320.0) * APPFULLWIDTH) contentURL:[NSURL URLWithString:  [self.BCinfoDic objectForKey:@"liveUrl" ]   ]   withTitle:[self.BCinfoDic objectForKey:@"title"]    withthumImg:[self.BCinfoDic objectForKey:@"imgUrl"]];
        
        self.player.delegate = self;
        self.player.tintColor = [UIColor yellowColor];
        [self.player setFrame: CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, [Common_Util DPRateOriginVAL:180])];
        [self.view addSubview:self.player];
        NSLog(@"proctm3");
        if ([self.brdinfoStr rangeOfString:@"closeYn=Y"].location != NSNotFound) {
            NSLog(@"있다~~~~ closeYn=Y");//있다 확실히 호출 확인
            isClose = YES;
        }
        else {
            NSLog(@"없다~~~~ closeYn=Y");
            isClose = NO;
        }
        
    }];
}



- (void)checkBroadcastingEnd {

    NSDateFormatter* dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];

    //종료시간
    NSDate *closeTime = [dateformat dateFromString:[self.BCinfoDic objectForKey:@"endDate"]];
    int closestamp = [closeTime timeIntervalSince1970];
    //남은방송시간
    double leftTimeSec = closestamp - [[NSDate date] timeIntervalSince1970];
    NSLog(@"leftTimeSec = %f",leftTimeSec);
    
    int tminite = leftTimeSec/60;
    int hour = leftTimeSec/3600;
    int minite = (leftTimeSec-(hour*3600))/60;
    int second = (leftTimeSec-(hour*3600)-(minite*60));
    NSString *callTemp = nil;
    
    if(tminite >= 60) {
        callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
    }
    else if(leftTimeSec <= 0) {
        callTemp = @"00:00:00";
    }
    else {
        callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
    }
    self.player.ModeVodPBTimelabel.text = NCS(callTemp);
    
    if (leftTimeSec < 0) {
        if ([timerEndCheck isValid]) {
            [timerEndCheck invalidate];
            timerEndCheck = nil;
        }
        isEndBroadCast = YES;
        [self.player endBroadCast];
        NSLog(@"방송 종료");
    }

}



- (void)webViewReload {
    self.wview.isloginInfo = [ApplicationDelegate islogin];
    NSLog(@"Reload Main self.wview Webview noHeaderFlag %@",self.wview);
    NSURLRequest *urlRequest1 = [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@&noHeaderFlag=N",[[BCinfoDic objectForKey:@"btmUrl"] urlDecodedString] ] ] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:kWebviewTimeoutinterval ];
    [self.wview loadRequest:urlRequest1];
    [self subViewchangePropertyForScrollsToTop:self.wview boolval:YES];
    if(isthisLive == YES) {
        //채팅영역
        [self.view bringSubviewToFront:InputChattingArea];
    }
#if APPSTORE
#else
    
    //치명 아래도 주석
    /*
     else {
     
     InputChattingArea.hidden= NO;
     InputChattingArea.frame = CGRectMake(0,APPFULLHEIGHT-20-50,  InputChattingArea.frame.size.width,50);
     [self.view bringSubviewToFront:InputChattingArea];
     }
     */
#endif
    
    
}

- (void)ProcSyncAfter:(void (^)(void))handler {
    
    if(self.wview != nil){
        [self.wview removeFromSuperview];
        self.wview.UIDelegate = nil;
        self.wview.navigationDelegate = nil;
        self.wview = nil;
    }
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    config.processPool = [[WKManager sharedManager] getGSWKPool];
    config.allowsInlineMediaPlayback = YES;
    
    CGFloat modHeight = 0;
    if(self.heightBottomSafeArea > 0.0) {
        //narava 웹뷰 하단 안전영역 구버전등 고려할점이 많아 앱이 강제로 아래로 내려서 맞춤
        modHeight = 14;
    }
    
    self.wview = [[GSWKWebview alloc] initWithFrame:CGRectMake(0,STATUSBAR_HEIGHT + [Common_Util DPRateOriginVAL:180], APPFULLWIDTH,APPFULLHEIGHT-[Common_Util DPRateOriginVAL:180] - STATUSBAR_HEIGHT + modHeight) configuration:config];
    
    self.wview.navigationDelegate = self;
    self.wview.UIDelegate = self.wview;
    
    if(isthisLive == YES) {
        //채팅뷰 추가
        InputChattingArea.hidden = NO;
        [self.view bringSubviewToFront:InputChattingArea];
    }
//    self.wview.scalesPageToFit = TRUE;
//    self.wview.delegate = self;
//    self.wview.dataDetectorTypes = UIDataDetectorTypeNone;
    
    
    self.wview.backgroundColor = [Mocha_Util getColor:@"FFFFFF"];
    self.wview.opaque = YES;
    self.wview.scrollView.scrollsToTop = NO;
    [self.view addSubview:self.wview];
    
    if(self.heightBottomSafeArea > 0.0) {
        UIView *viewBottom20 = [[UIView alloc] initWithFrame:CGRectMake(0.0, APPFULLHEIGHT - chatBottomSafeArea, APPFULLWIDTH, chatBottomSafeArea)];
        viewBottom20.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:viewBottom20];
    }
    
    [self webViewReload];
    NSLog(@"proctm1");
    
    
    handler();
}



//shawn 2012.07.13 subview의 class가 _UIWebViewScrollView 아닌 경우 scrollstoTop Property = (BOOL)NO
//주의.simulator 테스트시 _UIWebViewScrollView 가 UIScrollView로 나옴.
- (void) subViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val{
    for (UIView *subview in sview.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            NSLog(@"presetscroll stat = %i", [(UIScrollView*)subview scrollsToTop] );
            if(([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"_UIWebViewScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UIScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"WKScrollView"])
               )
                
            {
                ((UIScrollView *)subview).scrollsToTop = val;
            }
            else {
                ((UIScrollView *)subview).scrollsToTop = !val;
            }
            NSLog(@"change class %@",   [NSString stringWithFormat:@"%s",   object_getClassName(subview)]);
            NSLog(@"aftersetscroll stat = %i", [(UIScrollView*)subview scrollsToTop] );
        }
        [self subViewchangePropertyForScrollsToTop:subview boolval:val];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return isthisLandingMode;
}

- (void)playerViewZoomButtonClicked:(LiveTalkPlayer*)view {
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    if(isthisLandingMode == NO) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self textFieldCancel];
        NSLog(@"전체화면");
        [self.player isShowTopButtons:NO];
        [self.player setFrame:CGRectMake(0 , 0 , APPFULLHEIGHT, APPFULLWIDTH)];
        self.player.center = ApplicationDelegate.window.rootViewController.view.center;
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.player.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
                         }
                         completion:^(BOOL finished){
                         }];
        isthisLandingMode = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
        NSLog(@"Portrait");
        
        [self.player isShowTopButtons:YES];
        self.player.center = TopPlayerBGView.center;
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.player.transform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(0), 0, 0);
                             [self.player setFrame:CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, [Common_Util DPRateOriginVAL:180])];
                         }
                         completion:^(BOOL finished){
                             
                         }];
        isthisLandingMode = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


- (void)playerPortraitBack:(LiveTalkPlayer*)view {
    [self GoBack:nil];
}


- (void)playerTopHudButtonPressed:(TOPBTNTYPE)type {
    
    if (type == TOPBTNCARTTYPE) {
        [self goSmartCart:nil];
    }
    else if (type == TOPBTNSEARCHTYPE) {
        //2016.07.07 라이브톡 검색 버튼 클릭시 GTM 안와서 로직 변경
        [self onBtnSearchView:nil];
    }
    else if (type == TOPBTNSNSTYPE) {
        // 20160809 parksegun AppDelegate로 이동
        [ApplicationDelegate snsShareWithScriptTypeShow:self];
        [self callJscriptMethod:@"trackingSnsClick()"];
    }
}

- (void)notAgree3G {
}

- (void)callShareSnsWithString:(NSString*)seletedString {
    NSLog(@"seletedStringseletedString = %@",seletedString);
    [self callJscriptMethod:seletedString];
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}





- (IBAction)GoBack:(id)sender {
    if([self.wview canGoBack]) {
        [self.wview goBack];
    }
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ApplicationDelegate.gactivityIndicator stopAnimating];
        [self checkNavigationBack];
    }
}


- (void)checkNavigationBack {
    if ([timerEndCheck isValid]) {
        [timerEndCheck invalidate];
        timerEndCheck = nil;
    }
    
    if(isClose) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerMoveInFromTop];
    }
}





- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString ;
    
    BOOL isDecisionAllow = YES;
    
    if([self.tvChat canResignFirstResponder]==YES) {
        [self.tvChat resignFirstResponder];
    }
    
    NSLog(@"URLREQUEST = %@", requestString1);
    
    
    //캡슐화 - 공통 처리 를 위해 상위클래스 불러줌
    isDecisionAllow = [self.wview isGSWKDecisionAllowURLString:requestString1 andNavigationAction:navigationAction withTarget:self];
    
    
    //검색 공통
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://search"]) {
        [ApplicationDelegate SearchviewShow];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetolivetalk"]) {
        //새로고침
        [self reloadBCContents:requestString1];
        isDecisionAllow = NO;
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movetoinpage"]) {
        
        URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
        NSLog(@"movetoninpage = %@   ", [parser valueForVariable:@"url"]);
          //20160503 parksegun url 인코딩 추가
        //NSString *url = [[parser valueForVariable:@"url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [[parser valueForVariable:@"url"] stringByRemovingPercentEncoding];
        
        ResultWebViewController *resVC = [[ResultWebViewController alloc]initWithUrlString:url];
        resVC.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:resVC];//url을 웹뷰로 보여줌
        
        isDecisionAllow = NO;
    }
    

    
    
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
    
    
    
    
    // 공유하기 기능 20160830 배포건
    // 201608 parksegun 공유하기 기능 변경
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://share?"]){
        
        NSString *share = [requestString1 stringByReplacingOccurrencesOfString:@"toapp://share?" withString:@""];
        NSLog(@"share: %@",share);
        
        if([share hasPrefix:@"target=facebook&"]){
            // 페이스북
            URLParser *parser = [[URLParser alloc] initWithURLString:requestString1];
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
            //카카오톡
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
            //카카오스토리
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
            }
            else {
                //빙글빙글 계속 돌고 있어서
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [ApplicationDelegate.gactivityIndicator stopAnimating];
                
                //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
                NSString *strLoadedUrl = NCS(wview.URL.absoluteString);
                if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
                    ////탭바제거
                    [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
                }
                [self checkNavigationBack];
            }            
        }
        //웹뷰 외 사용시 return 처리해야 함
        isDecisionAllow = NO;
        
    }
    
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://close"]) //폼에서 버튼을 눌렀을대 string의 가장 처음에 있는 문자열이 일치하는지를 알려주는 메소드
    {
        
        [self checkNavigationBack];
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
            
            
            if (self.intUploadType > 0) {

                GSMediaUploader *uploder = [[[NSBundle mainBundle] loadNibNamed:@"GSMediaUploader" owner:self options:nil] firstObject];
                
                NSInteger type = (self.intUploadType == 33)?0:1;
                [uploder gsMediaUploadWithParser:requestString1 andTarget:self andType:type];
                
            }else{
                GSMediaUploader *uploder = [[[NSBundle mainBundle] loadNibNamed:@"GSMediaUploader" owner:self options:nil] firstObject];
                [uploder gsMediaUploadWithUrl:requestString1 andTarget:self];
            }
        }

        
        isDecisionAllow = NO;
        
    }
    
    //로그인이 필요한 페이지는 로그인을 하고 페이지를 넘긴다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGINCHECKURL]) {        
        //웹뷰가 toapp://login 호출할경우 기존에 로그인이 되어있으면 API로그아웃이 "아닌" APPJS 방식 로그아웃 호출
        if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
            NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation" code:9000 userInfo:nil];
            NSString *msg = [[NSString alloc] initWithFormat:@"앱로그인 상태에서 toapp://login 호출됨: LiveTalkView 자동로그인인가? %@", ([DataManager sharedManager].m_loginData.autologin == 1 ? @"YES" : @"NO") ];
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
                    [self.navigationController popToRootViewControllerAnimated:NO];
                });
                return;
            }
            abNomalCount++;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(contentLoad)
                                                         name:WKSESSION_SUCCESS
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(contentLoad)
                                                         name:WKSESSION_FAIL
                                                       object:nil];
            [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
            return;
            
        }
        
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];

        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        
        if([query2 isEqualToString:@""]){
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
        }else {
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
        if([Mocha_Util strContain:@"isAdult=Y" srcstring:requestString1]){
            loginView.loginViewMode = 2;
        }
        else if([Mocha_Util strContain:@"isPrdOrder=Y" srcstring:requestString1]){
            loginView.loginViewMode = 1;
            
        }else {
            loginView.loginViewMode = 0;
        }
        
        
        
        loginView.view.hidden=NO;
        [self.navigationController pushViewControllerMoveInFromBottom:loginView];
        
        NSString *strLoadedUrl = NCS(webView.URL.absoluteString);
        if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
            ////탭바제거
            [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
            
        }
        
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
        }else {
            self.curRequestString = [NSString stringWithString:query2];
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
        
        if ([requestString1 hasPrefix:@"toapp://modal?title="])
        {
            NSArray *tempArray = [query2 componentsSeparatedByString:@"&url="];	// 0 : title=상품설명 , 1 : http://
            
            title = [Mocha_Util strReplace:@"title=" replace:@"" string:NCA(tempArray)?[tempArray objectAtIndex:0]:@""];
            
            NSMutableArray *tempArray2 = [NSMutableArray arrayWithArray:tempArray];
            if(NCA(tempArray))
                [tempArray2 removeObjectAtIndex:0];
            landingURL = [tempArray2 componentsJoinedByString:@"&url="];
        }
        
        NSLog(@"title = %@, landingURL = %@", title, landingURL);
        
        //popup 띄우기 (타이틀 및 UI)
        self.popupWebView = [PopupWebView openPopupWithFrame:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT)
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
            self.popupWebView = [PopupWebView openPopupWithFrame:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT)
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
                self.popupWebView = [PopupWebView openPopupWithFrame:CGRectMake(0.0, STATUSBAR_HEIGHT, APPFULLWIDTH, APPFULLHEIGHT - STATUSBAR_HEIGHT)
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
        
        NSString *strLoadedUrl = NCS(wview.URL.absoluteString);
        if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
            ////탭바제거
            [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
            
        }
        
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
    
    BOOL isFrame = ![[[navigationAction.request URL] absoluteString] isEqualToString:[[navigationAction.request mainDocumentURL] absoluteString]];
    NSLog(@"아이프레임 일까요? %i  ==== %@", isFrame,requestString1);
    if(isDecisionAllow == YES && !isFrame) {
        
        //웹뷰페이지가 딜,단품 에서 벗어날경우 하단탭바 최근본 상품 갱신 방어로직추가
        NSString *strLoadedUrl = NCS(wview.URL.absoluteString);
        if([requestString1 length] > 0 && [strLoadedUrl length] > 0){
            ////탭바제거
            [ApplicationDelegate checkWebviewUrlLastPrdShow:requestString1 loadedUrlString:strLoadedUrl];
            
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


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    //중요 웹뷰 네비게이션 및 속도 체크중. - IOS5 버전이하 cangback 꼬이는 문제로 사용않함
    //animationwithDuration 을 runloop free상태에서 사용하는 이유 -thread관리 - 제외시 앱다운유발가능.
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         //[wview loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
                         
                     }
     
                     completion:^(BOOL finished){
                         
                         
                         [ApplicationDelegate.gactivityIndicator startAnimating];
                         
                     }];
    
    
    
    
    
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"errorerror = %@",error);
    

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    
    NSString *documentURL = wview.URL.absoluteString;
    [ApplicationDelegate GTMscreenOpenSendLog:documentURL];
    
    wview.currentDocumentURL = documentURL;
    
    NSLog(@"currentDocumentURL = %@",wview.currentDocumentURL);
    
    NSString *strFirstLoad = [NSString stringWithFormat:@"%@&noHeaderFlag=N",[[BCinfoDic objectForKey:@"btmUrl"] urlDecodedString]];
    
    //narava 앱에서 강제로 진입시 1회 띄우도록 수정함
    if (self.firstShow != YES && [strFirstLoad isEqualToString:documentURL]) {
        [self showToast:@"타인에게 노출될 수 있는 개인 정보(주민번호,카드정보 등) 입력에 주의해 주세요."];
        self.firstShow = YES;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    // nami0342 : Send Exception log
    [ApplicationDelegate SendExceptionLog:error];
}



- (NSString*) definecurrentUrlString {
    return self.curRequestString;
}
-(void)gosmartcartMove{
    
    ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString: self.curRequestString];
    result.delegate = (id <ResultWebViewDelegate>)self;
    result.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    
}
- (void) hideLoginViewController:(NSInteger)loginviewtype
{
    //4=일반로그인 후 curRequestString forwarding
    //5=로그아웃 후 reloading
    //6=비회원배송조회
    //7=비회원주문
    
    
  
    if(loginviewtype == 4)
    {
        
        //스마트카트일떈d
        if([self.curRequestString isEqualToString:SMARTCART_URL]){
            [self performSelector:@selector(gosmartcartMove) withObject:nil afterDelay:1.0f];
        }else {
            
            NSURL *videoURL = [NSURL URLWithString:self.curRequestString];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
            [wview loadRequest:requestObj];
            
        }
        
    }
    else if(loginviewtype == 6) {
        //비회원배송조회
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString: NONMEMBERORDERLISTURL(self.curRequestString)];
        result.delegate = (id <ResultWebViewDelegate>)self;
        result.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    else if(loginviewtype == 7) {
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString: NONMEMBERORDERURL(self.curRequestString)];
        result.delegate = (id <ResultWebViewDelegate>)self;
        result.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    
    else if(loginviewtype == 2) {
        //성인인증인 경우 webview history 한번더 뒤로~
        if([wview canGoBack]) {
            [wview goBack];
        }
        else {
            //돌아갈곳이 없다면 홈으로
            [self checkNavigationBack];
        }
    }
    else {
        //로그아웃  loginviewtype == 5 인경우
        [wview reload];
        
        
    }
    
    
    
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
    NSLog(@"gsurl = %@",url);
    
    //검색결과로
    ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:url];
    result.delegate = (id <ResultWebViewDelegate>)self;
    result.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    
    
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
        
    }else if(alert.tag == 444) {
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
    
    
    
    
    else if(alert.tag ==1133) {
        
        
        switch (index) {
            case 1:
                //로그인? 예
                self.curRequestString = [NSString stringWithFormat:@"%@&noHeaderFlag=N",[[BCinfoDic objectForKey:@"btmUrl"] urlDecodedString] ] ;
                
                NSLog(@"self.curRequestString = %@", self.curRequestString);
                //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                if(loginView == nil) {
                    loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                }else{
                    [loginView clearTextFields];
                }
                
                loginView.delegate = self;
                loginView.loginViewType = 4;
                
                loginView.deletargetURLstr = nil;
                loginView.loginViewMode = 0;
                
                
                loginView.view.hidden=NO;
                loginView.btn_naviBack.hidden = NO;
                
                
                btn_chatword.enabled= YES;
                [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                
                break;
            default:
                self.curRequestString =nil;
                break;
        }
        
        
    }
    
    else if(alert.tag == 333) {
        //잘못된정보 내려올경우 홈으로~
        switch (index) {
            case 0:
                [self.navigationController popToRootViewControllerAnimated:YES];

                break;
            default:
                [self.navigationController popToRootViewControllerAnimated:YES];

                break;
        }
    }
    
    else if(alert.tag == 334) {
        //잘못된정보 이전 화면으로 , 라이브톡 url 문제 있을경우에만
        switch (index) {
            case 0:
                [self.navigationController popViewControllerAnimated:YES];
                break;
            default:
                [self.navigationController popViewControllerAnimated:YES];
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
- (void)playrequestCommonVideo: (NSString*)requrl {
    
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
- (void)playrequestLiveVideo: (NSString*)requrl {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    [vc playMovie:[NSURL URLWithString:requrl]];
}

//단품 VOD 재생
- (void)playrequestVODVideo:(NSString*)requrl {
    
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


-(IBAction)onBtnSearchView:(id)sender {
    //DATAHUB CALL
    //D_1016 메인 검색
    @try {
        [[GSDataHubTracker sharedInstance] NeoCallGTMWithReqURL:@"D_1016" str2:nil str3:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"D_1016 ERROR : %@", exception);
    }
    @finally {
    }
    
    [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_SEARCH_App" withLabel:@"Click"];
    // nami0342 - 효율코드수정요청 : 20160509 이주현
    ////탭바제거
    [ApplicationDelegate wiseAPPLogRequest:WISELOGCOMMONURL(@"?mseq=398044")];
    [ApplicationDelegate SearchviewShow];
}


- (IBAction)goSmartCart:(id)sender {
    [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_Main_Top_Cart" withLabel:SMARTCART_URL];
    
    if(ApplicationDelegate.islogin== NO) {
        self.curRequestString = SMARTCART_URL;
        NSLog(@"self.curRequestString = %@", self.curRequestString);
        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
        if(loginView == nil) {
            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
        }else{
            [loginView clearTextFields];
        }
        
        loginView.delegate = self;
        loginView.loginViewType = 4;
        
        loginView.deletargetURLstr = SMARTCART_URL;
        loginView.loginViewMode = 0;
        
        loginView.view.hidden=NO;
        loginView.btn_naviBack.hidden = NO;
        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
    }
    else {
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:SMARTCART_URL];
        result.delegate = (id <ResultWebViewDelegate>)self;
        result.view.tag = 505;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
}





-(void)textFieldCancel {
//    bg_chatword.backgroundColor = [Mocha_Util getColor:@"FAFAFA"];
    if (self.tvChat != nil) {
        [self.tvChat resignFirstResponder];
    }
}

-(IBAction)btn_regok_Press:(id)sender {
    
    if (isEndBroadCast) {
        /*
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"생방송 중에만 입력이 가능합니다."  maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        [ApplicationDelegate.window addSubview:lalert];
        [self textFieldCancel];
         */
        [self showToast:@"생방송 중에만 입력이 가능합니다."];
        return;
    }
    
    btn_chatword.enabled= NO;
    //[text_chatword resignFirstResponder];
    [self.tvChat resignFirstResponder];
    
    if(ApplicationDelegate.islogin == NO) {
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?"  maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 1133;
        [ApplicationDelegate.window addSubview:lalert];
        btn_chatword.enabled= YES;
    }
    else {
        //20160203 글 등록시 새로고침 -> 20160225 parksegun 글등록 성공시 텍스트를 포함하여 새로고침 호출하도록 변경됨.
        //공백 테스트, 100자 초과 테스트
        if([self.tvChat.text isEqualToString:@""] || [[self.tvChat.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            self.tvChat.text = @"";
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"내용을 입력 후 등록해주세요." maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 379;
            [ApplicationDelegate.window addSubview:lalert];
            btn_chatword.enabled= YES;
            return;
        }
        
        [ApplicationDelegate setAmplitudeEvent:@"Click-라이브톡-등록"];
        
        [self  NalCHatSendData:(NSString*)[BCinfoDic objectForKey:@"liveTalkNo"]
                      message : (NSString*)self.tvChat.text
                  phonenumber :(pnnum == nil)?@"":pnnum
                      enddate :(NSString*)[BCinfoDic objectForKey:@"endDate"]  ];
    }
}





- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 터치 동작들을 가져옵니다.
    UITouch * touch = [[event allTouches] anyObject];
    
    // textView가 현재 포커스되어 키보드가 띄워져 있는 경우...
    //if ([text_chatword isFirstResponder]) {
    if ([self.tvChat isFirstResponder]) {
        // [touch view]로 어느 View가 터치되었는지를 가져옵니다.
        // 터치된 View와 이 View의 textView가 다르다면, 즉 다른 View를 터치했다면...
        if ([touch view] != InputChattingArea ) {
            // 지금 포커스된 textView의 포커스를 박탈합니다.
            // 포커스를 잃은 textView에 의해 UIKeyboardWillHideNotification 이벤트가 발생하면서
            // keyboardWillHide 메서드가 실행됩니다.
            [self.tvChat resignFirstResponder];
        }
    }
    
    // 다른 작업들은 부모 클래스의 메서드로 넘깁니다.
    [super touchesBegan:touches withEvent:event];
}





// 키보드가 아래에서 떠오르는 이벤트 발생 시 실행할 이벤트 처리 메서드입니다.
- (void) keyboardWillShow:(NSNotification *)notification {
    
    if(iskeyboadOBActive == NO) {
        return;
    }
    
    //if(![text_chatword isFirstResponder]) {
    if(![self.tvChat isFirstResponder]) {
        return;
    }
    
    NSLog(@"노티스 %@ == %@", notification, notification.userInfo);
    CGRect rectView; // 이 View에 대한 위치와 크기의 사각 영역을 나타낼 CGRect 구조체입니다.
    CGRect rectKeyboard; // 키보드에 대한 위치와 크기의 사각 영역을 나타낼 CGRect 구조체입니다.
    
    // 애니메이션 효과를 지정합니다. 이와 관련한 함수들은 다음에 따로 정리합니다.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    
    
    rectView = CGRectMake(0,APPFULLHEIGHT - InputChattingArea.frame.size.height,  InputChattingArea.frame.size.width,InputChattingArea.frame.size.height);
    // 이 View 자체에 대한 사각 영역을 가져옵니다.
    // 하단에서 떠오른 키보드의 사각 영역을 가져옵니다.
    
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&rectKeyboard];
    
    // View를 전체적으로 키보드 높이만큼 위로 올립니다.
    rectView.origin.y -= rectKeyboard.size.height;
    // View의 변경된 사각 영역을 자기 자신에게 적용합니다.
    [InputChattingArea setFrame:rectView];
    
    [self changePrivacyPopupY];
    
    // 변경된 사각 영역을 애니메이션을 적용하면서 보여줍니다.
    [UIView commitAnimations];
}

// 키보드가 아래로 잠기는 이벤트 발생 시 실행할 이벤트 처리 메서드입니다.
- (void) keyboardWillHide:(NSNotification *)notification {
    if(iskeyboadOBActive == NO) {
        return;
    }
    
    CGRect rectView; // 이 View에 대한 위치와 크기의 사각 영역을 나타낼 CGRect 구조체입니다.
    CGRect rectKeyboard; // 키보드에 대한 위치와 크기의 사각 영역을 나타낼 CGRect 구조체입니다.
    
    // 애니메이션 효과를 지정합니다. 이와 관련한 함수들은 다음에 따로 정리합니다.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // 하단으로 잠길 키보드의 사각 영역을 가져옵니다.
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&rectKeyboard];
    
    CGFloat modHeight = 0.0;
    if(self.heightBottomSafeArea > 0.0){
        modHeight = 20.0;
    }
    
    rectView = CGRectMake(0,APPFULLHEIGHT - InputChattingArea.frame.size.height - modHeight - rectKeyboard.size.height,  InputChattingArea.frame.size.width,InputChattingArea.frame.size.height );
    // 이 View 자체에 대한 사각 영역을 가져옵니다.
    
    // View를 전체적으로 키보드 높이만큼 아래로 내립니다.
    rectView.origin.y += rectKeyboard.size.height;
    // View의 변경된 사각 영역을 자기 자신에게 적용합니다.
    [InputChattingArea setFrame:rectView];
    
    [self changePrivacyPopupY];
    
    // 변경된 사각 영역을 애니메이션을 적용하면서 보여줍니다.
    [UIView commitAnimations];
}

#pragma mark - textView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *replacedString = [textView.text stringByReplacingCharactersInRange:range withString:text];

    //100바이트 제한
    NSData *bytes = [replacedString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"stringstring = %@",text);

    if(bytes.length <= 100) {
        return YES;
    }
    else {
        BOOL isthereMarlert = NO;
        for ( UIView* v in  [ApplicationDelegate.window subviews] ) {
            if(v.tag == 379) {
                isthereMarlert = YES;
            }
        }
        
        if(isthereMarlert==NO) {
            NSData *existByte = [self.tvChat.text dataUsingEncoding:NSUTF8StringEncoding];
            if (existByte.length < 100) {
                NSString *str100 = nil;
                for (NSInteger i=100; i>0; i--) {
                    str100 = [[NSString alloc] initWithBytes:bytes.bytes length:i encoding:NSUTF8StringEncoding];
                    if (str100 != nil) {
                        textView.text = str100;
                        break;
                    }
                }
            }

            //[self textFieldCancel];
            //최대 글자 수(50자)를 초과하여 작성할 수 없습니다. 작성하신 글자 수()를 조정해주세요.
            NSString *str = [NSString stringWithFormat:@"최대 글자 수(50자)를 초과하여 작성할 수 없습니다."];
            [self showToast:str];
//            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:str maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
//            lalert.tag = 379;
//            [ApplicationDelegate.window addSubview:lalert];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.tvChat.text length] == 0) {
        isAttachShowAll = YES;
        [self setChattingViewFrame];
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self performSelector:@selector(delayedPrivacyPopup) withObject:nil afterDelay:0.2];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.viewPrivacyToast.alpha = 0.0;
    self.viewPrivacyToast.hidden = YES;
}

-(void)delayedPrivacyPopup{
    [self showPrivacyToast:@"타인에게 노출될 수 있는 개인 정보(주민번호,카드정보 등) 입력에 주의해 주세요."];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    if (isEndBroadCast) {
        [self showToast:@"생방송 중에만 입력이 가능합니다."];
        return NO;
    }
    
    if(ApplicationDelegate.islogin == NO) {
        [self textFieldCancel];

        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?"  maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 1133;
        [ApplicationDelegate.window addSubview:lalert];
        return NO;

    }
    
    if ([textView.text length] == 0) {
        isAttachShowAll = NO;
        self.viewSendTalk.hidden = NO;
        [self setChattingViewFrame];
    }
    
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    
    
    if (textView.contentSize.height <= 36) {
        
        if (textView.frame.size.height > 36.0) {
            CGFloat posY = InputChattingArea.frame.origin.y + (textView.frame.size.height - 36.0);
            textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 36.0);
            InputChattingArea.frame = CGRectMake(0.0, posY, InputChattingArea.frame.size.width, frame.size.height + 8.0);
            self.viewBGchatword.frame = CGRectMake(self.viewBGchatword.frame.origin.x, self.viewBGchatword.frame.origin.y, self.viewBGchatword.frame.size.width, 36.0);
        }else{
            NSLog(@"36보다 작음 유지");
        }
        
        
    }else if (textView.contentSize.height > 36 && textView.contentSize.height <= 82){
        
        if(textView.contentSize.height > textView.frame.size.height){ //커짐
            
            CGFloat posY = InputChattingArea.frame.origin.y - (textView.contentSize.height - textView.frame.size.height);
            InputChattingArea.frame = CGRectMake(0.0, posY, InputChattingArea.frame.size.width, frame.size.height + 8.0);
            self.viewBGchatword.frame = CGRectMake(self.viewBGchatword.frame.origin.x, self.viewBGchatword.frame.origin.y, self.viewBGchatword.frame.size.width, frame.size.height);
            textView.frame = frame;
            //textView.contentOffset = CGPointMake(0.0, textView.contentSize.height/2.0);
            [textView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
            
        }else if (textView.contentSize.height < textView.frame.size.height){ //작아짐
            
            CGFloat posY = InputChattingArea.frame.origin.y + (textView.frame.size.height - textView.contentSize.height);
            InputChattingArea.frame = CGRectMake(0.0, posY, InputChattingArea.frame.size.width, frame.size.height + 8.0);
            self.viewBGchatword.frame = CGRectMake(self.viewBGchatword.frame.origin.x, self.viewBGchatword.frame.origin.y, self.viewBGchatword.frame.size.width, frame.size.height);
            textView.frame = frame;
            
        }else{
            NSLog(@"높이 같음 유지");
        }
        
    }else { //82보다 클때
        
    }
    
    [self changePrivacyPopupY];
}


- (void) NalCHatSendData:(NSString*) nalroomnum message : (NSString*) msg phonenumber :(NSString*)pnum enddate :(NSString*) endd {
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    [post_dict setValue:msg forKey:@"blttgCntnt"];
    [post_dict setValue:pnum forKey:@"phoneNo"];
    [post_dict setValue:endd forKey:@"endDate"];
    [post_dict setValue:@"2.0" forKey:@"livetalkVer"];
    
    NSLog(@"comm dictionary %%%%%%%% = %@",post_dict);
    
    //new json - binary데이터 what do i do?
    NSData *postData = [[post_dict jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"json str %@", [post_dict jsonEncodedKeyValueString]);
    
    NSString *baseurl = GSLIVETALKURL(nalroomnum);
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    [urlRequest setTimeoutInterval:kMKNetworkKitRequestTimeOutInSeconds];
    
    NSLog(@"Contacting Server....");

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if(!data || [data isEqual:[NSNull null]] ) {
                                          //오류 처리
                                          [self performSelectorOnMainThread:@selector(commerrorALert) withObject:nil waitUntilDone:NO];
                                      }else {
                                          NSLog(@"Contacting Server3....");
                                          //응답코드 원래없음
                                          //응답헤더 확인
                                          NSLog(@"chattingapi  %@result %@ == %@",  [[data JSONtoValue] objectForKey:@"resultMessage"], [data JSONtoValue],  [response description]);
                                          //성공
                                          //20160225 parksegun 글등록 성공시 글정보 출력
                                          [self performSelectorOnMainThread:@selector(callJscriptMethod:) withObject:[NSString stringWithFormat:@"gs.liveTalk.reFresh('%@')",msg] waitUntilDone:NO];
                                          
                                          if (NCO([data JSONtoValue])) {
                                              pnnum = [[data JSONtoValue] objectForKey:@"resultCode"];
                                              
                                              if ([NCS([[data JSONtoValue] objectForKey:@"resultMessage"]) length] > 0) {
                                                  [self performSelectorOnMainThread:@selector(showToast:) withObject:[[data JSONtoValue] objectForKey:@"resultMessage"] waitUntilDone:NO];
                                              }
                                              
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              btn_chatword.enabled= YES;
                                              self.tvChat.text = @"";
                                              [self textViewDidChange:self.tvChat];
                                          });
                                      }
                                  }];
    [task resume];
}



- (void) commerrorALert {
    //오류 처리
    btn_chatword.enabled= YES;
    [self textFieldCancel];
    Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"라이브톡 전송을 실패하였습니다. 네트워크 상태를 확인 후 다시 시도해주세요." maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
    lalert.tag = 379;
    [ApplicationDelegate.window addSubview:lalert];
}

- (void) showToast:(NSString*)tstring {
    
    if (self.viewToast.hidden == NO && [self.lblToast.text hasPrefix:tstring]) {
        return;
    }
    NSLog(@"라벨프레임 %@",  NSStringFromCGSize( self.lblToast.frame.size ));
    self.lblToast.frame = CGRectMake(56.0, self.lblToast.frame.origin.y, APPFULLWIDTH - 56.0 - 24.0, self.lblToast.frame.size.height);
    NSString *strMessage = [NSString stringWithFormat:@"%@ ",tstring];
    
    self.lblToast.text = strMessage;
    [self.lblToast setAdjustsFontSizeToFitWidth: YES];
    NSLog(@"라벨프레임 %@",  NSStringFromCGSize( self.lblToast.frame.size ));
    
    CGRect frame = self.lblToast.frame;
    frame.size = [self.lblToast sizeThatFits:self.lblToast.frame.size];
    [self.lblToast setFrame: frame];
    
    CGFloat toastPosY = InputChattingArea.frame.origin.y - (frame.size.height + 28.0) - 5.0;
    
    if (self.tvChat.isFirstResponder) {
        toastPosY = InputChattingArea.frame.origin.y - (self.viewPrivacyToast.frame.size.height) - 5.0 - (frame.size.height + 28.0) - 5.0;
    }

    
    CGRect toastFrame  = CGRectMake(0.0, toastPosY, APPFULLWIDTH, frame.size.height + 28.0);
    [self.viewToast setFrame:toastFrame];
    [self.view addSubview:self.viewToast];
    self.viewToast.hidden = NO;
    
    NSLog(@"라벨프레임 %@",  NSStringFromCGSize( self.lblToast.frame.size ));
    NSLog(@"self.view.sub =%@",self.view.subviews);
    NSLog(@"self.viewToast =%@",self.viewToast);
    NSLog(@"self.lblToast =%@",self.lblToast);

    [UIView animateWithDuration:1.0
                         delay:3.0
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:(void (^)(void)) ^{
        self.viewToast.alpha = 0.0;
                    }
    
                    completion:^(BOOL finished){
        self.viewToast.hidden = YES;
        self.viewToast.alpha = 1.0;
        self.lblToast.text=@"";
                    }];
    
}

- (void) showPrivacyToast:(NSString*)tstring {
    
    
    self.lblPrivacyToast.frame = CGRectMake(56.0, self.lblPrivacyToast.frame.origin.y, APPFULLWIDTH - 56.0 - 24.0, self.lblPrivacyToast.frame.size.height);
    NSString *strMessage = [NSString stringWithFormat:@"%@ ",tstring];
    
    self.viewPrivacyToast.alpha = 0.0;
    self.viewPrivacyToast.hidden = NO;
    
    self.lblPrivacyToast.text = strMessage;
    [self.lblPrivacyToast setAdjustsFontSizeToFitWidth: YES];
    NSLog(@"라벨프레임 %@",  NSStringFromCGSize( self.lblToast.frame.size ));
    
    CGRect frame = self.lblPrivacyToast.frame;
    frame.size = [self.lblPrivacyToast sizeThatFits:self.lblPrivacyToast.frame.size];
    [self.lblPrivacyToast setFrame: frame];
    
    CGFloat toastPosY = InputChattingArea.frame.origin.y - (frame.size.height + 28.0) - 5.0;
    
    CGRect toastFrame  = CGRectMake(0.0, toastPosY, APPFULLWIDTH, frame.size.height + 28.0);
    [self.viewPrivacyToast setFrame:toastFrame];
    [self.view addSubview:self.viewPrivacyToast];
    self.viewPrivacyToast.hidden = NO;
    
    NSLog(@"라벨프레임 %@",  NSStringFromCGSize( self.lblToast.frame.size ));
    NSLog(@"self.view.sub =%@",self.view.subviews);
    NSLog(@"self.viewToast =%@",self.viewPrivacyToast);
    NSLog(@"self.lblToast =%@",self.lblPrivacyToast);

    [UIView animateWithDuration:0.5
                         delay:0
                       options:UIViewAnimationOptionBeginFromCurrentState
                    animations:(void (^)(void)) ^{
                        self.viewPrivacyToast.alpha = 1.0;
                    }
    
                    completion:^(BOOL finished){
        
                    }];
    
}

-(void)changePrivacyPopupY{
    CGFloat toastPosY = InputChattingArea.frame.origin.y - self.viewPrivacyToast.frame.size.height - 5.0;
    CGRect toastFrame  = CGRectMake(0.0, toastPosY, APPFULLWIDTH, self.viewPrivacyToast.frame.size.height);
    [self.viewPrivacyToast setFrame:toastFrame];
}

- (void) DrawCartCountstr{
    [self.player DrawCartCountstr];
}


#pragma mark -
#pragma mark uploadDelegate

- (void)didSuccesUpload:(NSDictionary *)dicResult {
    
    NSLog(@"");
    
}


- (IBAction)mediaAttach:(id)sender {
    NSLog(@"사진 등록 누름");
    //20160714 parksegun 로그인 체크 필요.
//    if(ApplicationDelegate.islogin == NO){
//        [self textFieldCancel];
//        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?"  maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
//        lalert.tag = 1133;
//        [ApplicationDelegate.window addSubview:lalert];
//        return;
//    }
    // 서버로 부터
    // if([requestString1 hasPrefix:@"toapp://attach"]) //파일첨부 페이지 호출 와 같은 형태로 호출되야함.
    
    isAttachShowAll = YES;
    [self setChattingViewFrame];
    if([self.tvChat.text length] > 0){
        [self textViewDidChange:self.tvChat];
    }
}

- (IBAction)mediaPhotoOrCam:(id)sender {
    if(ApplicationDelegate.islogin == NO) {
        [self textFieldCancel];
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?"  maintitle:@"알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 1133;
        [ApplicationDelegate.window addSubview:lalert];
        return;
    }
    
    if (isEndBroadCast) {
        [self showToast:@"생방송 중에만 입력이 가능합니다."];
        return;
    }
    
    NSInteger tagBtn = [(UIButton *)sender tag];
    self.intUploadType = tagBtn;
    [self performSelectorOnMainThread:@selector(callJscriptMethod:) withObject:@"gs.liveTalkWrite.attachImageClick()" waitUntilDone:NO];
}

@end


