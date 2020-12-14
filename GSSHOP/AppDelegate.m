
//  AppDelegate.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 7. 18..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "AppDelegate.h"
#import "MemberDB.h"
#import "DataManager.h"
#import "PushData.h"
#import "LoginData.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MOCHA/MochaGetIpAdress.h>

#import "NormalFullWebViewController.h"

#import <AdSupport/AdSupport.h>

#import <GoogleTagManager/GoogleTagManager.h>


//#import "PushNotificationDelegate.h"

// Facebook DPA
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AirBridge/AirBridge.h>


// Amplitude
#import <Amplitude_iOS/Amplitude.h>

// App boy
#import <Appboy_iOS_SDK/AppboyKit.h>
#import <Appboy_iOS_SDK/ABKPushUtils.h>
#define ab_uri @"ab_uri"

//Fingerprint
#import <LocalAuthentication/LocalAuthentication.h>


// Air Bridge
#import <AirBridge/ABUserEvent.h>
#import <AirBridge/ABEcommerceEvent.h>

#import "NSHTTPCookie+JAVASCRIPT.h"
#import <Apptimize/Apptimize.h>         // nami0342 : Apptimize

typedef enum {
    kStatusForceUpdate,
    kStatusLaterUpdate,
    kStatusCommFailed,
    kStatusNoneUpdate
} StatusUpdateType;

@class ImageDownManager;
@interface AppDelegate ()<TAGCustomFunction>

//차기배포 UAinbox
//@property (nonatomic, strong) InboxDelegate *inboxDelegate;
//@property (nonatomic, strong) PushNotificationDelegate *pushDelegate;

-(void)launchingProcFirst;
-(StatusUpdateType)launchingProcVersionCheck;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize gsshopmainViewController;
@synthesize HMV;
@synthesize isauthing;

@synthesize URLSchemeString;
@synthesize gshop_http_core;

@synthesize gsshop_img_core;
@synthesize spviewController;

@synthesize activeApp;
@synthesize currentOperation1;
@synthesize currentOperation2;
@synthesize currentOpLogin;
@synthesize gactivityIndicator;

@synthesize islogin, serverAppvername, serverAppvercode, isdisplaypmsbox;
@synthesize appfirstLoading;


@synthesize viewDirectOrdOption;


@synthesize isTvShopLivePlaying,isTodayRecommendLivePlaying;

@synthesize isBackGround;

@synthesize isSideMenuOnTop;


@synthesize mainNVC;
@synthesize strMyShop,pushAgreePopupView,infoCommPopupView,uGradeValue,isTabbarHomeButtonClick_forSideMenu;
@synthesize m_strApptimize = _m_strApptimize;

// nami0342 - CSP
@synthesize m_btnCSPIcon = _m_btnCSPIcon;
@synthesize m_btnMessageNLink = _m_btnMessageNLink;
@synthesize m_dicMsg = _m_dicMsg;
@synthesize strNavigationTabID = _strNavigationTabID;
@synthesize m_isGotDisconnectCallback = _m_isGotDisconnectCallback;
@synthesize m_socket = _m_socket, m_manager = _m_manager;
@synthesize objectCSP;
@synthesize dpSerialQueue = _dpSerialQueue;
@synthesize isShowVodTooltipView;

//
@synthesize vMyShopNetworkDownView,lunchAfterActionUrl;


// static
static id isDeeplinkPrdDeal;

- (id)init
{
    if((self = [super init]))
    {
        //home_main 로딩바 제어를 위한 BOOL
        self.appfirstLoading = YES;
        self.activeApp = YES;
        self.islogin = NO;
        self.isauthing = NO;
        self.isdisplaypmsbox = NO;
        self.isDeeplinkPrdDeal = NO;
        self.isShowVodTooltipView = NO;
        if(self.objectCSP == nil) {
            self.objectCSP = [[NSMutableDictionary alloc] init];
        }
        self.isTabbarHomeButtonClick_forSideMenu = NO;
        
        self.dpSerialQueue = dispatch_queue_create("csp.serialqueue.gsshop.com", DISPATCH_QUEUE_SERIAL);
        ecidPairs = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSObject *)executeWithParameters:(NSDictionary *)parameters {
    return nil;//[super executeWithParameters:parameters];
}



#pragma mark - AppDelegate Functions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (@available(iOS 13, *)) {
        // 단말을 다크모드로 설정한 경우, 일반모드처럼 나오도록 수정
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    // 앱 업데이트 여부 판단
    // 앱 업데이트 할때마다 이미지 캐싱을 날리기 정책 - 2019.11.27
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appVersion = [NSString stringWithFormat:@"%@", [userDefaults valueForKey:@"appVersion"]];
    if ([CURRENTAPPVERSION isEqualToString:appVersion] == false) {
        [userDefaults setValue:CURRENTAPPVERSION forKey:@"appVersion"];
        [ImageDownManager clearCache];
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // AppScheme 또는 Push로 앱을 '실행'하는 경우,
    // TabID 값에 따라 해당 매장으로 이동 후 wise log를 1회만 전송하기 위한 Flag값 설정
    ///////////////////////////////////////////////////////////////////////////////////////
    
    // Network reachability 
    gshop_http_core = [[NetCore_GSSHOP_Comm alloc] init];
    [NetworkManager.shared startNetworkReachabilityObserver];
    
    // Disk 데이터(gs cookie, 베스트딜 자동실행 플래그값 등)를 읽어 싱글톤에 저장
    [[Common_Util sharedInstance] loadLocalDataFromDisk];
    [[DataManager sharedManager] GetLoginData];
    
    self.lunchAfterActionUrl = [[NSMutableArray alloc] init];
    
    // appScheme URL속에 TabID값이 있을 때 플래그값 저장
    NSString *tabIdValue = ((NSURL *)launchOptions[UIApplicationLaunchOptionsURLKey]).absoluteString;
    NSLog("isGsshopmobile_TabIdFlag tabIdValue = %@", tabIdValue);

    NSRange tabIdRange = [tabIdValue rangeOfString:@"tabId="];
    
    
    if ([tabIdValue hasPrefix:@"gsshopmobile://TABID?"] ||
        ((NSNotFound != tabIdRange.location) && tabIdRange.location > 0 )) {
        self.isGsshopmobile_TabIdFlag = YES;
    }
    
    NSDictionary *optionsDic = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    // appboy 푸시
    if (optionsDic != nil && [NCS(optionsDic[@"ab_uri"]) length] > 0 ){
        
        NSString *url = optionsDic[@"ab_uri"];
        NSRange tabIdRangeAB = [url rangeOfString:@"tabId="];
        
        if ([url hasPrefix:@"gsshopmobile://TABID?"] ||
            ((NSNotFound != tabIdRangeAB.location) && tabIdRangeAB.location > 0 )) {
            self.isGsshopmobile_TabIdFlag = YES;
        }
    }
    
    // pms 푸시
    if (optionsDic != nil && [NCS(optionsDic[@"l"]) length] > 0 ){
        
        NSString *url = optionsDic[@"l"];
        NSRange tabIdRangePMS = [url rangeOfString:@"tabId="];
        
        if ([url hasPrefix:@"gsshopmobile://TABID?"] ||
            ((NSNotFound != tabIdRangePMS.location) && tabIdRangePMS.location > 0 )) {
            self.isGsshopmobile_TabIdFlag = YES;
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////
    // nami0342 - Collect a app crash log in global.
    NSSetUncaughtExceptionHandler(&logingAppCrash);
    
    
    // CSP 에서 Disconnect callback이 왔을 경우을 상정하므로, 최초에는 YES로 세팅
    self.m_isGotDisconnectCallback = YES;

    // checkexcuteTime
    [Common_Util saveExcuteTimeLog];
    
    //20190219 parksegun 메인 로드 위치 앞으로 땡김- 뒤에 처리되는 부분들은 비동기 형태로 변경
    [self launchingProcFirst];
    
    [DataManager sharedManager].strGlobalSound = @"D";
    [DataManager sharedManager].strGlobal3GAgree = @"N";
    
//    self.HMV = [[Home_Main_ViewController alloc] initWithNibName:@"Home_Main_ViewController" bundle:nil];
//    self.mainNVC =[[MainNavigationController alloc] initWithRootViewController:self.HMV];
//    [self.window setRootViewController:self.mainNVC];
//    [self.window makeKeyAndVisible];
    

   
    // App boy
    @try {
        [Appboy startWithApiKey:@"fbb58229-c178-4530-a4de-2e5120e8d11b" inApplication:application withLaunchOptions:launchOptions];
        
        [Appboy sharedInstance].inAppMessageController.delegate = self;
        self.isAviableBrazeInAppMessagePopupShow = YES;                     // InAppMessage Popup 노출 허용
        
    } @catch (NSException *exception) {
        GSException *gsExc = [[GSException alloc] initWithException:exception addString:@"App Boy Exception"];
        logingAppCrash(gsExc);
    }

    
    ///////////////////////////////////////////////////////////////////////////////////////
    // AirBridge Deffered Deeplink 설정
    // nami0342 - AirBridge - 20cb649a3aa74caca563f778b83780d2
    [AirBridge getInstance:@"20cb649a3aa74caca563f778b83780d2" appName:@"gsshop" withLaunchOptions:launchOptions];
    //[AirBridge set ]
    
    NSLog(@"launchOptions = %@",launchOptions);
    // nami0342 - AirBridge Deffered deeplink - 이거 사용할 경우 Facebook Deffered Deeplink는 제거하도록 가이드 되어 페이스북꺼는 주석처리 08.01
    // AirBridge 1.10.1 대응
    // AirBirdge deeplink
    [AirBridge.deeplink setDeeplinkCallback:^(NSString * _Nonnull deeplink) {
        if ([NCS(deeplink) length] > 0) {
            NSString *strLinkURL = [deeplink stringByReplacingOccurrencesOfString:@"https://gsshop.airbridge.io/" withString:@"gsshopmobile://"];
            
            if ([NCS(self.strLastOpenUrl) isEqualToString:strLinkURL] == false ) {
                if(self.HMV != nil && self.HMV.isFirstAPI == FALSE) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self goUrlSchemeAction:strLinkURL];
                    });
                }
                else {
                    if(self.lunchAfterActionUrl != nil ) {
                        [self.lunchAfterActionUrl addObject:strLinkURL];
                    }
                }
            }
        }
    }];

    //네이버 로그인 초기화
    NaverThirdPartyLoginConnection *thirdConn = [NaverThirdPartyLoginConnection getSharedInstance];
    [thirdConn setServiceUrlScheme:naverServiceAppUrlScheme];
    [thirdConn setConsumerKey:naverConsumerKey];
    [thirdConn setConsumerSecret:naverConsumerSecret];
    [thirdConn setAppName:naverServiceAppName];
    NSLog(@"네이버 SDK 버전: %@",[thirdConn getVersion]);
    [[NaverThirdPartyLoginConnection getSharedInstance] setIsNaverAppOauthEnable:YES];  //네이티브 인증
    [[NaverThirdPartyLoginConnection getSharedInstance] setIsInAppOauthEnable:YES];     //인앱 브라우저 인증
    
    
    
    // nami0342 - 서버 점검 시 캐시가 먹으면 공사중 캐시가 잔존할 수 있는 버그가 있어 점검 후 캐시 처리
//    [gshop_http_core useCache];         // 일정 기간(5분)동안 API 정보를 로컬에 저장해서 재 사용한다.
    //file cache 사용
    [gsshop_img_core useCache];

    // nami0342 - FireBase analysis
    [FIRApp configure];
//    FIROptions *firOptions = [FIROptions defaultOptions];
//    [firOptions setTrackingID:@"UA-42058338-1"];
//    [FIRApp configureWithName:@"Default" options:firOptions];
    
    //GA Tracker
#if !TARGET_IPHONE_SIMULATOR
    {
        
        /*
        // Optional: automatically send uncaught exceptions to Google Analytics.
        [GAI sharedInstance].trackUncaughtExceptions = YES;

        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 1;


        // Optional: set Logger to VERBOSE for debug information.
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];

        // Initialize tracker.
        gtracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-42058338-1"];

        gtracker2 = [[GAI sharedInstance] trackerWithName:@"unionTracker"
                                               trackingId:@"UA-38519237-2"];
         */

    }
#endif

    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    [PMS initializePMS];
    [PMS setPMSDelegate:self];
    [PMS setAdvrId:APPLE_AD_ID];

    // nami0342 - PMS / Appboy에 현재 앱내 광고성 push 상태를 전송한다.
    //GS앱 설정화면의 푸시 수신여부값
    NSString *strADPushON = [userDefaults objectForKey:GS_PUSH_RECEIVE];
    if(strADPushON == nil || [strADPushON isEqualToString:@"N"] || [strADPushON length] == 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delayedPMSSetting:) userInfo:[NSNumber numberWithBool:NO] repeats:NO];
        [[Appboy sharedInstance].user setPushNotificationSubscriptionType: ABKUnsubscribed];
    }
    else
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delayedPMSSetting:) userInfo:[NSNumber numberWithBool:YES] repeats:NO];
        [[Appboy sharedInstance].user setPushNotificationSubscriptionType: ABKSubscribed];
    }


    // nami0342 - Facebook DPA
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    


    // Amplitude
    [[Amplitude instance] initializeApiKey:@"56d54c6d801092b4e8718b40c87a5441"];
    [[Amplitude instance] setTrackingSessionEvents:YES];
    
    
    
    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CSP_StartWithCustomerID:)
                                                 name:NOTI_CSP_START_SOCKET
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(CSP_Disconnect)
                                                 name:NOTI_CSP_STOP_SOCKET
                                               object:nil];
    
    
    
    
    self.HMV = [[Home_Main_ViewController alloc] initWithNibName:@"Home_Main_ViewController" bundle:nil];
    self.mainNVC =[[MainNavigationController alloc] initWithRootViewController:self.HMV];
    [self.window setRootViewController:self.mainNVC];
    [self.window makeKeyAndVisible];    

    return YES;
}

// nami0342 : AirBridge Universal Links Delegate
- (BOOL) application:(UIApplication *) application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // 유니버셜 링크로 들어오면 동작
    ///////////////////////////////////////////////////////////////////////////////////////
    
    // AirBridge 1.9.0 대응
    // AriBridge Deeplink 설정
    NSString *strLinkURL = [userActivity.webpageURL.absoluteString stringByReplacingOccurrencesOfString:@"https://gsshop.airbridge.io/" withString:@"gsshopmobile://"];
    
    NSLog(@"continueUserActivity appfirstLoading = %@",appfirstLoading?@"YES":@"N");
    
    //didfinish 가 끝났는지 확인하고 안끝났으면 큐잉(홈메인에서 실행), 끝났으면 실행...
    // 수신 링크 호출
    //[self goUrlSchemeAction:strLinkURL];
    //[self performSelector:@selector(goUrlSchemeAction:) withObject:strLinkURL afterDelay:1.0f]; //<- 아래 기존 로직을 보면 1초뒤에 실행하라고 되어 있음. 위에 didfinish가 먼저 실행되어 종료되길 바라면서...
     
     if(self.HMV != nil && self.HMV.isFirstAPI == FALSE) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self goUrlSchemeAction:strLinkURL];
               });
     }
     else {
         if(self.lunchAfterActionUrl != nil ) {
             [self.lunchAfterActionUrl addObject:strLinkURL];
         }
     }
    
    

    // AirBridge - 이벤트만 전송
    [AirBridge.deeplink handleUniversalLink:userActivity.webpageURL];
    NSLog(@"user Activity : %@", userActivity.webpageURL);
    
    
    return YES;
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // AppScheme 또는 Push 등으로 호출되며
    // 해당 app scheme 동작 또는 goUrlSchemeAction 함수를 호출한다.
    ///////////////////////////////////////////////////////////////////////////////////////
    
    NSLog(@"openURL appfirstLoading = %@",appfirstLoading?@"YES":@"N");
    
    //MAT SDK
    NSLog(@"url = %@, caller app str = %@ \n options = %@", [url absoluteString], app , options);
    
    
    // Aribridge Deeplink 설정
//    [[AirBridge instance] handleURL:url];
    
    // Facebook 광고를 사용하려면 반드시 SDK를 통해서 아래와 같이 딥링크 관련 설정
    // 기본 딥링크 설정이 완료되었다면 아래의 가이드를 통해서 에어브릿지의 매소드를 호출해서
    // 딥링크 통계를 에어브릿지 서버에서 받을 수 있도록 해주어야 합니다.
    // (만약 본 매소드를 호출해주지 않을 시 딥링크 관련 통계가 수집되지 않습니다.)
    // 참고 :  https://docs.airbridge.io/docs/facebook-channel.html#ios
    // nami0342 - 1.9.0 대응 : 이벤트만 전송
    [AirBridge.deeplink handleURLSchemeDeeplink:url];
    
    //네이버
    if ([[url scheme] isEqualToString:@"gsshopmobile"]) {
        if ([[url host] isEqualToString:kCheckResultPage]) {
            NaverThirdPartyLoginConnection *thirdConnection = [NaverThirdPartyLoginConnection getSharedInstance];
            THIRDPARTYLOGIN_RECEIVE_TYPE resultType = [thirdConnection receiveAccessToken:url];
            if (SUCCESS == resultType) {
                NSLog(@"Getting auth code from NaverApp success!");
            } else {
                // resultType에 따라 애플리케이션에서 오류 처리를 한다.
            }
            
            return NO;
        }
    }
    
    
    //kakao talk
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    
    if( [Mocha_Util strContain:@"media=" srcstring:[url absoluteString]]){
        @try {
            
            URLParser *parser = [[URLParser alloc] initWithURLString:[url absoluteString]];
            
            [GSDataHubTracker sharedInstance].DHmediaType =[parser valueForVariable:@"media"] ;
            
        }
        @catch (NSException *exception) {
            NSLog(@"openURL: sourceApplication: Exception : %@",exception);
            
        }
        @finally {
            
        }
    }

    
    if([[url absoluteString] hasPrefix:@"gsshopmobile://TID"] || [[url absoluteString] hasPrefix:@"gsshopmobile://KID"]
       || [[url absoluteString] hasPrefix:@"gsshopmobile://NID"] ) {
        
        URLString = [url absoluteString];
        NSLog(@"handleopenurl_URLString_handel = %@",URLString);
        return YES;
    }
    
    
    
    NSLog(@"url scheme호출 : %@", [url absoluteString]);
    
    
    
    
    /*
     20160309 parksegun 스키마 타고 들어올 경우 앱실행시 프로모션 팝업은 단품일경우 뜨지 않도록     */
    if( ( [Mocha_Util strContain:@"gsshopmobile://home" srcstring:[url absoluteString]] ) && (   [Mocha_Util strContain:@"prd.gs" srcstring:[url absoluteString]] || [Mocha_Util strContain:@"deal.gs" srcstring:[url absoluteString]] ))
    {
        //프로모션 팝업은 띄우지 않음.
        self.isDeeplinkPrdDeal = YES;
    }
    else
    {
        self.isDeeplinkPrdDeal = NO;
    }
    
    
    self.strLastOpenUrl = [url absoluteString];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(clearStrLastOpenUrl) userInfo:nil repeats:NO];
    
    if(self.activeApp == YES)//새로 앱이 시작
    {
        [self setApplicationBadgeNumber:0];
        // application.applicationIconBadgeNumber = 0;//벳지 넘버 초기화
        self.activeApp = NO;
        NSLog(@"self.activeApp = NO");
        //최초실행시  화면처리
        [self loadingDone];
        
        //방송 시청중 수신APNS에대한 화면처리
        [[NSNotificationCenter defaultCenter] postNotificationName:@"customovieViewRemove" object:nil userInfo:nil];
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        
        //URLScheme 액션처리 초기 런칭시 init 시간 확보를 위한 2.0f delay
        //[self performSelector:@selector(goUrlSchemeAction:) withObject:[url absoluteString] afterDelay:1.0f];
        if(self.lunchAfterActionUrl != nil ) {
            [self.lunchAfterActionUrl addObject:[url absoluteString]];
        }
        
        
    }
    else//앱이 열린 상태에서 URL scheme 호출 , PMS 푸시를 클릭해서 들어와도 결국 여기를 타게됨
    {
        // nami0342 - 표준 규격 추가
        if([@"gsshopmobile://" isEqualToString:[url absoluteString]] == YES)
            return YES;
        
        //방송 시청중 수신APNS에대한 화면처리
        [[NSNotificationCenter defaultCenter] postNotificationName:@"customovieViewRemove" object:nil userInfo:nil];
        [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        
        //URLScheme 액션처리
        [self performSelector:@selector(goUrlSchemeAction:) withObject:[url absoluteString] afterDelay:0.5f];
//        if(self.lunchAfterActionUrl != nil ) {
//            [self.lunchAfterActionUrl addObject:[url absoluteString]];
//        }
        
    }
    
    return YES;
}

-(void)clearStrLastOpenUrl{
    self.strLastOpenUrl = @"";
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    //yunsang.jin kakao talk
    [KOSession handleDidBecomeActive];
    
    
    // nami0342 - Facebook DPA
    [FBSDKAppEvents activateApp];
    
    
    [self setApplicationBadgeNumber:0];
    
    NSLog(@"applicationDidBecomeActive");
    
    
    
    
    
    //   self.activeApp = NO;
    NSLog(@"url = %@  ",URLString);
    if (URLString != nil ){
        if([URLString hasPrefix:@"gsshopmobile://TID"]) {
            self.activeApp = NO;
            NSLog(@"self.activeApp = NO");
            NSString *str = [URLString substringFromIndex:15];
            NSString *url = GSISPRECVURL(str);
            
            UINavigationController *navigationController = self.mainNVC;
            
            
            if([navigationController.viewControllers count] > 1  ) {
                if([[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] respondsToSelector:@selector(goWebView:)]) {
                    
                    [[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] goWebView:url];
                }
                
            }else if([navigationController.viewControllers count] == 1  ) {
                if([[navigationController.viewControllers objectAtIndex:0] respondsToSelector:@selector(goWebView:)]) {
                    
                    [[navigationController.viewControllers objectAtIndex:0] goWebView:url];
                }
                
            }
            else{
                // 예외처리 필요함.
            }
            
            
            
            
            URLString = nil;
            
        }
        
        
        //페이나우
        else if([URLString hasPrefix:@"gsshopmobile://NID"]) {
            self.activeApp = NO;
            NSLog(@"self.activeApp = NO");
            NSString *str = [URLString substringFromIndex:15];
            NSString *url = GSPAYNOWRECVURL(str);
            
            UINavigationController *navigationController = self.mainNVC;
            
            
            if([navigationController.viewControllers count] > 1  ) {
                if([[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] respondsToSelector:@selector(goWebView:)]) {
                    
                    [[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] goWebView:url];
                }
                
            }else if([navigationController.viewControllers count] == 1  ) {
                if([[navigationController.viewControllers objectAtIndex:0] respondsToSelector:@selector(goWebView:)]) {
                    
                    [[navigationController.viewControllers objectAtIndex:0] goWebView:url];
                }
                
            }
            else{
                //예외처리 필요함.
            }
            
            
            URLString = nil;
            
        }
    }
    
    // nami0342 - CSP
    //    if(self.islogin == YES)
    //    {
    //        [self isCNSStatusOK];
    //        [self CSP_StartWithCustomerID:[DataManager sharedManager].customerNo];
    //     }
    
    self.isBackGround = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSLog(@"applicationDidEnterBackground");
    //self.activeApp = YES;
    NSLog(@"self.activeApp = YES");
    
    [self gsCookieSave];
    self.isBackGround = YES;
    
    // nami0342 - CSP
    //    self.m_lServerBuild = 0;
    [self CSP_Disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //self.activeApp = YES;
    
    // nami0342 - 프로모션 팝업을 띄울 날짜를 비교.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strToday = [Mocha_Util  getCurrentDate:NO];
    NSString *strSaved = NCS([defaults objectForKey:PROMOTIONPOPUPDATE]);
    
    
    
    // nami0342 - 날짜가 바뀌면 팝업을 띄울 수 있게 메모리에서 초기화 해주고 프로모션 팝업을 호출한다.
    if([strSaved length] > 1 && [strToday isEqualToString:strSaved] == NO )
    {
        self.isPromotionPopup = NO;
        
        //201610 narava 프로모션 팝업을 비동기로 진행 시킨다
        ////탭바제거
        Home_Main_ViewController * HVC =  (Home_Main_ViewController *)[[self.mainNVC viewControllers] objectAtIndex:0];
        ////탭바제거
        [HVC showPromotionPopup_async];
    }
    
    // 필요성을 못느껴서 제거
    //[self gsCookieRestore];
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self gsCookieSave];
}



#pragma mark -  didFinishLaunching Function
-(void)launchingProcFirst {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명 - application didFinishLaunchingWithOptions: 에서만 호출됨.
    //
    // 1.세셔널쿠키삭제
    // 2.User Agent 변경
    // 3.shopstartURL 콜
    // 4.http Core 생성
    // 5.캐시 폴더 정리
    // 6.프로모션 팝업 닫기 bool = NO 초기화
    ///////////////////////////////////////////////////////////////////////////////////////
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wkSessionSuccess)
                                                 name:WKSESSION_SUCCESS
                                               object:nil];
    
    [CooKieDBManager deleteLogoutCookies];
    
    [self gsCookieRestore];
    
    NSMutableString *script = [[NSMutableString alloc] initWithString:@""];
    [script appendString:@"var cookieNames = document.cookie.split('; ').map(function(cookie) { return cookie.split('=')[0] } );\n"];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:script
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:NO];
    [userContentController addUserScript:cookieInScript];

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = userContentController;
    config.processPool = [[WKManager sharedManager] getGSWKPool];;
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        // Skip cookies that will break our script
        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
            continue;
        }
        
        // Create a line that appends this cookie to the web view's document's cookies
        //[script appendFormat:@"if (cookieNames.indexOf('%@') == -1) { document.cookie='%@'; };\n", cookie.name, cookie.wn_javascriptString];
        [script appendFormat:@"document.cookie='%@';\n", cookie.wn_javascriptString];
    }
    //20130411 작업 - 매체코드 iPad = BI, theother = BS 적용 - universal앱의 경우 다른방식으로구분.  //,AG001 20130916 추가 //20140520 107 Up!
    NSString * strUserAgent = [ApplicationDelegate getCustomUserAgent];
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:strUserAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    wviewAppStart = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    wviewAppStart.navigationDelegate = self;
    wviewAppStart.customUserAgent = strUserAgent;
    wviewAppStart.scrollView.scrollsToTop = NO;
    
    //지역설정값
    
    //appmediatype 쿠키 setting 20140514
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"appmediatype" forKey:NSHTTPCookieName];
    [cookieProperties setObject:[@"BS" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@".gsshop.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@".gsshop.com" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    //1 month
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    
    //adid 파라메타 추가 -> aid로 최종 낙찰 20171206
    NSString *shopStart = [NSString stringWithFormat:@"%@?aid=%@",SHOPSTART_URL, [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString];
    NSLog(@"shopStart=%@",shopStart);
    NSURL *logURL = [NSURL URLWithString:shopStart];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:logURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
    [wviewAppStart loadRequest:urlRequest];
    
    self.loadHTMLStart = CACurrentMediaTime();
    
    
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:strUserAgent  forKey:@"User-Agent"];
    
    NSLog(@"Change Agent = %@", strUserAgent);
    
    
    gsshop_img_core = [[NetCore_GSSHOP_IMG alloc] initCoreHostName:SERVERIMAGEDOMAIN
                                                           apiPath:nil
                                                customHeaderFields:headerFields];
    NSLog(@" %@", gsshop_img_core.cacheDirectoryName);
    
    [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
    
    //이하 케시폴더삭제 메서드는 Mocha v4.6.0 차기버전 교체적용시 ifNeedCacheRemoveDoIt:x1 x2 메서드 대체
    //20151118 추가
    NSString *cacheDirectory = [gsshop_img_core cacheDirectoryName];
    BOOL isDirectory = YES;
    BOOL folderExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory] && isDirectory;
    
    if (!folderExists) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory];
    
    if (fileExists) {
        NSError *attributesError =nil;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:cacheDirectory error:&attributesError];
        
        NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
        long long fileSize = [fileSizeNumber longLongValue];    // 1000 -> 1Mb
        
        NSLog(@"Cache memory capacity = %lu bytes", (unsigned long)[[NSURLCache sharedURLCache] memoryCapacity]);    // 512000 bytes (512 KB 가량)
        NSLog(@"Cache disk capacity = %lu bytes", (unsigned long)[[NSURLCache sharedURLCache] diskCapacity]);    // 10000000 bytes (10MB 가량)
        NSLog(@"Cache Memory Usage = %lu bytes", (unsigned long)[[NSURLCache sharedURLCache] currentMemoryUsage]);
        NSLog(@"Cache Disc Usage = %lu bytes", (unsigned long)[[NSURLCache sharedURLCache] currentDiskUsage]);
        
        // nami0342 - 파일 용량 비교로직으로 인해 파일 갯수에 대한 조건은 제외처리 / 용량 150Mb 이상일 경우 초기화
        if(fileSize > 150000 ) {
            [gsshop_img_core emptyCache];
        }
        
        NSLog(@"plist 있음 %@, fileSize = %ld \n\n attr : %@",cacheDirectory, (unsigned long)fileSize, fileAttributes);
        
    }
    //케시폴더 삭제 정책 적용 끝
    
    //프로모션 팝업 닫기 bool = NO 초기화
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:PROMOTIONPOPUPISDENY];
    
}


/// 버전체크및 자동로그인 처리 후 홈메인 호출프로세스 첨가됨.
- (void)callProcess {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // 버전체크및 자동로그인 처리 후 홈메인 호출프로세스 첨가됨.
    ///////////////////////////////////////////////////////////////////////////////////////
    
    if([self checkVersion]) {
        [self Launch_autoLoginProcess:@"첫시도" process:^(AUTO_LOGIN flag, NSDictionary *data) {
            if(flag == RESULT_SUCCESS) {
                //전체 데이터 세팅 프로세스..
                [self appdelegateBaseProcess];
                [self autoLogin_Sucess_Process:data];
            }
            else if(flag == RESULT_FAIL) {
                //한번 실패시 재시도 로직 추가
                //[NSThread sleepForTimeInterval:0.5]; // 0.5초 후에
                
                [self Launch_autoLoginProcess:@"재시도" process:^(AUTO_LOGIN flag2, NSDictionary *data2) {
                    if(flag2 == RESULT_SUCCESS) {
                        //전체 데이터 세팅 프로세스..
                        [self appdelegateBaseProcess];
                        [self autoLogin_Sucess_Process:data2];
                    }
                    else if(flag2 == RESULT_FAIL) {
                        
                        //세번째 시도
                        [self Launch_autoLoginProcess:@"삼세번" process:^(AUTO_LOGIN flag3, NSDictionary *data3) {
                            if(flag3 == RESULT_SUCCESS) {
                                //전체 데이터 세팅 프로세스..
                                [self appdelegateBaseProcess];
                                [self autoLogin_Sucess_Process:data3];
                            }
                            else if(flag3 == RESULT_FAIL) {
                                // 실패 했어도.. 그냥 진행
                                // 자동 로그인 실패 시 토스트 팝업 노출
                                [Mocha_ToastMessage toastWithDuration:2.0 andText:GSSLocalizedString(@"login_intro_fail") inView:ApplicationDelegate.window];
                                //전체 데이터 세팅 프로세스..
                                [self appdelegateBaseProcess];
                                //return;
                            }
                            else { //NOT_TARGET
                                //전체 데이터 세팅 프로세스..
                                [self appdelegateBaseProcess];
                            }
                        }];
                        
                    }
                    else { //NOT_TARGET
                        //전체 데이터 세팅 프로세스..
                        [self appdelegateBaseProcess];
                    }
                }];
            }
            else { // NOT_TARGET
                //자동로그인 대상 아님
                //전체 데이터 세팅 프로세스..
                [self appdelegateBaseProcess];
            }
        }];
    }
    else {
        //네트워크 연결안됨
    
    }
}

// nami0342 - 부평 IDC 네트워크 다운될 경우 FTP를 통해 점검중 상태로 변경한다.
/*
 URL : ftp.apperror.gsshop.gscdn.com
 PORT : 7777
 ID : apperror
 PW : )!app@#E8(1rror
 
 
 [서비스URL]
 URL : http://apperror.gsshop.com/oops.html    : 파일 내부 텍스트를 IDC_ERROR로 변경 시 점검중으로 처리login_intro_fail
 @@ http://apperror.gsshop.com/mc_parking.html : 점검중 상태를 표시하는 html 파일
 */

- (void)appdelegateBaseProcess {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // 홈 화면 및 햄버거 메뉴 UI 그리기
    // Push 수신동의에 따른 Push 등록
    // 동적 인트로 이미지 다운로드
    ///////////////////////////////////////////////////////////////////////////////////////
    
    [self.HMV homeMainBaseProcess];
    self.viewDirectOrdOption = [[[NSBundle mainBundle] loadNibNamed:@"DirectOrdOptionView" owner:self options:nil] firstObject];
    [self.window addSubview:self.viewDirectOrdOption];
    self.popupSNSView = [[[NSBundle mainBundle] loadNibNamed:@"PopupSNSView" owner:self options:nil] firstObject];
    [self.window addSubview:self.popupSNSView];
    NSLog("%f =!  %f",APPFULLHEIGHT, [[UIScreen mainScreen] bounds].size.height);
    
    self.viewMainSearch = [[[NSBundle mainBundle] loadNibNamed:@"MainSearchView" owner:self options:nil] firstObject];
    [self.viewMainSearch initWithDelegate:self Nframe:CGRectMake(0, 0 ,APPFULLWIDTH, APPFULLHEIGHT)];
    self.viewMainSearch.alpha = 0.0;
    [self.window addSubview:self.viewMainSearch];
    self.viewMainSearch.tbvSearch.scrollsToTop = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(LL(BESTDEAL_AUTOPLAYMOVIE) == nil) { //최초 설치에만 나와야 함으로 BESTDEAL_AUTOPLAYMOVIE 참조 하기로 결정
        SL(@"Y", BESTDEAL_AUTOPLAYMOVIE);
    }
    
    //인트로 이미지 먼저 호출함.
//    self.spviewController = [[SplashViewController alloc] init];
//    [self.window addSubview:[spviewController view]];
//    self.gactivityIndicator = [[SHActivityIndicatorView alloc] init];
    //프로모션 팝업 호출
    [self.HMV showPromotionPopup_async];
//        spviewController = [[SplashViewController alloc] init];
//        [self.window addSubview:[spviewController view]];
//       gactivityIndicator = [[SHActivityIndicatorView alloc] init];
    //정보통신법 개정안 적용 팝업
    self.infoCommPopupView = [[[NSBundle mainBundle] loadNibNamed:@"InfoCommLawPopupView" owner:self options:nil] firstObject];
    [self.window addSubview:self.infoCommPopupView];
    //!! 주의 정보통신법 개정안 팝업의 변경되면 INFOCOMMLAW_FLAG_VERSION의 버전값도 변경되야 한다.
    if(![[userDefaults valueForKey:INFOCOMMLAW_SHOW] isEqualToString:INFOCOMMLAW_FLAG_VERSION]) {
        [userDefaults removeObjectForKey:INFOCOMMLAW_SHOW];
        [userDefaults removeObjectForKey:INFOCOMMLAW_DATA_SEND];
    }

    if([userDefaults valueForKey:INFOCOMMLAW_SHOW] && [userDefaults valueForKey:INFOCOMMLAW_DATA_SEND]) {
        [self.infoCommPopupView removeFromSuperview];
    }
    else if([userDefaults valueForKey:INFOCOMMLAW_SHOW] && [userDefaults valueForKey:INFOCOMMLAW_DATA_SEND] == nil) {
        [self.infoCommPopupView removeFromSuperview];
        [self infoCommLawConfirmSend];
    }
    else {
        
    }
    
    if([NCS([userDefaults valueForKey:GS_PUSH_RECEIVE]) isEqualToString:@"Y"]) { //앱 푸시 수신을 동의한경우
        [self registerAPNS];
    }
    
    self.activeApp = NO;
    
    // nami0342 - Send criteo log
    [self performSelectorInBackground:@selector(sendCriteoLog) withObject:nil];
    
    // 동적 인트로 이미지 다운로드
    [self performSelector:@selector(checkIntroImage) withObject:nil afterDelay:3.0]; // 3초뒤.. 이미지 다운로드 시도
}




// nami0342 - Collect a app crash log and send a log to GS Shop server.
static void logingAppCrash(id exception)
{
    NSLog(@"XXX Statck trace : %@", [exception callStackSymbols]);
    
    NSString *strLastViewController = NSStringFromClass([[[ApplicationDelegate.mainNVC viewControllers] lastObject] class]);
    
    
    if ([strLastViewController isEqualToString:@"Home_Main_ViewController"]) {
        strLastViewController = [NSString stringWithFormat:@"Home_Main_ViewController %@",[ApplicationDelegate.HMV currentGSNavigationNameAndIndex]];
    }else if ([strLastViewController isEqualToString:@"ResultWebViewController"]) {
        ResultWebViewController *resultWVC = (ResultWebViewController *)[[ApplicationDelegate.mainNVC viewControllers] lastObject];
        NSLog(@"resultWVC = %@",resultWVC);
        NSString *strUrl = @"";
        if ([NCS(resultWVC.wview.currentDocumentURL) length] > 0) {
            strUrl = [resultWVC.wview.currentDocumentURL urlEncodedString];
        }else{
            strUrl = [resultWVC.wview.lastEffectiveURL urlEncodedString];
        }
        
        strLastViewController = [NSString stringWithFormat:@"ResultWebViewController %@",strUrl ];
        
    }else if ([strLastViewController isEqualToString:@"MyShopViewController"]) {
        MyShopViewController *myShopWVC = (MyShopViewController *)[[ApplicationDelegate.mainNVC viewControllers] lastObject];
        
        NSString *strUrl = @"";
        if ([NCS(myShopWVC.wview.currentDocumentURL) length] > 0) {
            strUrl = [myShopWVC.wview.currentDocumentURL urlEncodedString];
        }else{
            strUrl = [myShopWVC.wview.lastEffectiveURL urlEncodedString];
        }
        
        strLastViewController = [NSString stringWithFormat:@"MyShopViewController %@",strUrl];
    }
    
    
    
    
#if DEBUG
    return;
#endif
    
    
#if APPSTORE
    NSString *strSideMenuTop = (ApplicationDelegate.isSideMenuOnTop == YES)?@"sideMenuTop":@"";
    NSString *strDeathNote = [NSString stringWithFormat:@"%@ %@",strLastViewController,strSideMenuTop];
    NSMutableArray *arCrashSymbols = [NSMutableArray arrayWithArray:[exception callStackSymbols]];
    
    // Add exception desctription - 콜 스택만 나오면 해당 함수에서 왜 크래쉬 났는지 안 보여서 추가
    [arCrashSymbols insertObject:[NSString stringWithFormat:@"%@ DESC : %@",strDeathNote, [exception description]] atIndex:0];
    
    
    NSString *strNetwork;
    if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi)
    {
        strNetwork = @"wifi";
    }
    else if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWWAN)
    {
        strNetwork = @"lte";
    }
    
    // To JSON string
    NSString *strJson = [arCrashSymbols description];
    
    NSString *strDevice = [UIDevice currentDevice].deviceModelName;
    if([[strDevice lowercaseString] hasPrefix:@"simulator"] == YES)
        return;
    
    // Send a log to GSShop server if possibled.
    NSString *strURL = [NSString stringWithFormat:@"%@?seq=%@", SERVER_CRASH_LOG, DEVICEUUID];
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"POST"];
    
    NSMutableString *mstrPostDatas = [[NSMutableString alloc] init];
    [mstrPostDatas appendFormat:@"%@=%@&", @"app_version", CURRENTAPPVERSION];
    [mstrPostDatas appendFormat:@"%@=ios_crash_%@&", @"error_name", [exception name]];
    [mstrPostDatas appendFormat:@"%@=%@&", @"error_description", strJson];
    [mstrPostDatas appendFormat:@"%@=%@_%@&", @"customer_id", DEVICEUUID, [DataManager sharedManager].customerNo?[DataManager sharedManager].customerNo:@""];
    [mstrPostDatas appendFormat:@"%@=%@&", @"platform", @"iOS"];
    [mstrPostDatas appendFormat:@"%@=%@&", @"device_model", [UIDevice currentDevice].deviceModelName];
    [mstrPostDatas appendFormat:@"%@=%@&", @"os_version", [UIDevice currentDevice].systemVersion];
    [mstrPostDatas appendFormat:@"%@=%@&", @"network_type", strNetwork];
    [mstrPostDatas appendFormat:@"%@=%@", @"ip", @""];
    
    NSData *postData = [mstrPostDatas dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [urlRequest setHTTPBody: postData];
    NSError *error;
    NSURLResponse *response;
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (!result)
    {
        NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
    }
    else
    {
        NSLog(@"!!!!!Crash log send finished");
    }
#endif
}

#pragma mark - AppDelegate Push Notification
// RemoteNotification 등록 성공. deviceToken을 수신
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    //PMS 토큰 설정
    [PMS setPushToken:deviceToken];
    [self PMSsetUUIDNWapcidNpcid];
    [PMS authorize];
    
    
    NSMutableString *deviceTkstr = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceTkstr appendFormat:@"%02x", ptr[i]];
    }
    
    PushData *data = [[PushData alloc]init];
    data.deviceToken = [NSString stringWithString:deviceTkstr];
    //custNo 컬럼만 남겨둔체 customerNumber db에 저장하지 않음.
    data.custNo = @"0";
    
    [[DataManager sharedManager]deletePushInfo];
    [[DataManager sharedManager]insertPushInfo:data];
    // 2012.03.02 메모리 릭 발견 처리
    
    PushDataRequest *pushRequest = [[PushDataRequest alloc]init];
    if ([NCS([[DataManager sharedManager] customerNo]) length] == 0 ) {
        [pushRequest sendData:deviceTkstr  customNo:@"0"];
    }else{
        [pushRequest sendData:deviceTkstr  customNo:NCS([[DataManager sharedManager] customerNo])];
    }
    
    
    // App boy
    [[Appboy sharedInstance] registerDeviceToken:deviceToken];
    
    
    NSLog(@"APNS Device Token: %@", deviceTkstr);
    
    
#if GSSHOP
//    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:@"T_%@", deviceTkstr] maintitle:[NSString stringWithFormat:@"D_%@", DEVICEUUID] delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"), nil]];
//    [self.window addSubview:malert];
#endif
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    NSLog(@"didReceiveRemoteNotification fetchCompletionHandler");
    
    if(self.activeApp == YES)//새로 앱이 시작
    {
        [self setApplicationBadgeNumber:0];
        self.activeApp = NO;
        NSLog(@"self.activeApp = NO");
        
        NSLog(@"앱 시작시 푸시");
        // App boy
        if ([ABKPushUtils isAppboyRemoteNotification:userInfo]) { // 앱보이 일경우
            [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
            NSString *strAB_URI = NCS([userInfo objectForKey:ab_uri]);
            if ([strAB_URI length] > 0) {
                NSString *strAB_ENCODE =[strAB_URI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:strAB_ENCODE]];
            }
        }
        else {
            [PMS receivePush:userInfo  notiTime:PMSNotiBackground];
        }
    }
    else//앱이 구동된후
    {
        [self setApplicationBadgeNumber:0];
        
        //방송 시청중 수신APNS에대한 화면처리
        [[NSNotificationCenter defaultCenter] postNotificationName:@"customovieViewRemove" object:nil userInfo:nil];
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        
        if (self.isBackGround) { //백그라운드 일경우
            NSLog(@"백그라운드 푸시");
            // App boy
            if ([ABKPushUtils isAppboyRemoteNotification:userInfo]) { // 앱보이 일경우
                [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
                NSString *strAB_URI = NCS([userInfo objectForKey:ab_uri]);
                if ([strAB_URI length] > 0) {
                    NSString *strGOLink = [strAB_URI stringByReplacingOccurrencesOfString:@"gsshopmobile://home?" withString:@""];
                    if([[self.mainNVC.viewControllers lastObject] respondsToSelector:@selector(goWebView:)]) {
                        [[self.mainNVC.viewControllers lastObject] goWebView:strGOLink];
                    }
                    else {
                        ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:strGOLink];
                        [self.mainNVC pushViewControllerMoveInFromBottom:result];
                    }
                }
            }
            else {
                [PMS receivePush:userInfo  notiTime:PMSNotiBackground];
            }
        }
        else { // 앱이 포그라운드 일경우
            NSLog(@"켜짐상태 푸시");
            // App boy
            if ([ABKPushUtils isAppboyRemoteNotification:userInfo]) { // 앱보이 일경우
                [[Appboy sharedInstance] registerApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
                [self confirmAppBoyOldPush:userInfo];
            }
            else {
                [PMS receivePush:userInfo  notiTime:PMSNotiForeground];
            }
        }
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    //iOS 10 over 오로지 켜있일때에만 여기로
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    
    /*
     {
     ab =     {
     att =         {
     aof = 0;
     type = jpg;
     url = "https://appboy-images.com/appboy/communication/assets/image_assets/images/592d229f56ec31647e8e82b5/original.?1496130207";
     };
     c = "NTk3MTVkYWI1YzVhNjgzZWNmNzEyY2FmXzU5NzE1ZGFiNWM1YTY4M2VjZjcxMmNhYl9jbXA=";
     };
     "ab_uri" = "gsshopmobile://home?http://m.naver.com";
     aps =     {
     alert = "\Uc624\Ub298\Ub3c4 \Uc990\Uac70\Uc6b4 \Ud558\Ub8e8\Ub418\Uc138\Uc694.!!";
     badge = 1;
     "mutable-content" = 1;
     sound = "gsnoti.wav";
     };
     }
     */
    
    NSDictionary *strdic = [userInfo valueForKey:@"aps"];
    
    if([[strdic valueForKey:@"sound"] isEqualToString:@"gsnoti.wav"]){
        NSLog(@"어?");
        
        NSArray *argArrSound = [NCS([strdic valueForKey:@"sound"]) componentsSeparatedByString:@"."];
        SystemSoundID soundIDNoti;
        id sndPath = [[NSBundle mainBundle] pathForResource:[argArrSound objectAtIndex:0]
                                                     ofType:[argArrSound objectAtIndex:1]];
        // URL 타입 생성
        CFURLRef baseURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndPath]);
        // SoundID 생성
        AudioServicesCreateSystemSoundID(baseURL, &soundIDNoti);
        AudioServicesPlayAlertSound(soundIDNoti);
        
        if (baseURL) {
            CFBridgingRelease(baseURL);
        }
        
        
    }else {
        // 진동모드와 상관없이 진동 5회
        [Mocha_DeviceHandle Devicevibe:3];
    }
    
    NSLog(@"켜짐상태 푸시 userInfo = %@",userInfo);
    //[PMS receivePush:userInfo  notiTime:PMSNotiForeground];
    
    
    // custom code to handle push while app is in the foreground
    completionHandler(UNNotificationPresentationOptionAlert);
}


// nami0342 - Header 가 변경되어 수정
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    //iOS 10 over 백그라운드 또는 앱 꺼져있을경우
    NSLog( @"Handle push from background or closed" );
    // if you set a member variable in didReceiveRemoteNotification, you will know if this is from closed or background
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    if(self.activeApp == YES)//새로 앱이 시작
    {
        [self setApplicationBadgeNumber:0];
        
        self.activeApp = NO;
        NSLog(@"self.activeApp = NO");
        
        NSLog(@"앱 시작시 푸시");
        
        // App boy
        if ([ABKPushUtils isAppboyUserNotification:response]) { // 앱보이 일경우!
            NSLog(@"앱보이");
            if(@available(iOS 10.0, *)) {
                [[Appboy sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
            }
            else {
                NSString *strAB_URI = NCS([userInfo objectForKey:ab_uri]);
                if ([strAB_URI length] > 0) {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:strAB_URI]];
                }
            }
        }
        else{
            NSLog(@"PMS");
            [PMS receivePush:userInfo  notiTime:PMSNotiBackground];
        }
    }
    else {
        [self setApplicationBadgeNumber:0];
        //방송 시청중 수신APNS에대한 화면처리
        [[NSNotificationCenter defaultCenter] postNotificationName:@"customovieViewRemove" object:nil userInfo:nil];
        [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        
        //PMS 푸시내용 insert
        //[PMS receivePush:userInfo  notiTime:PMSNotiBackground];
        NSLog(@"백그라운드 푸시 userInfo = %@",userInfo);
        // App boy
        if ([ABKPushUtils isAppboyUserNotification:response]) { // 앱보이 일경우!
            NSLog(@"앱보이");
            if(@available(iOS 10.0, *)) {
                [[Appboy sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
            }
            else {
                NSString *strAB_URI = NCS([userInfo objectForKey:ab_uri]);
                if ([strAB_URI length] > 0) {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:strAB_URI]];
                }
            }
        }
        else{
            NSLog(@"PMS");
            [PMS receivePush:userInfo  notiTime:PMSNotiBackground];
        }
    }
    
    completionHandler();
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // APNS 에 RemoteNotification 등록 실패
    ///////////////////////////////////////////////////////////////////////////////////////
    NSLog(@"fail RemoteNotification Registration: %@", [error description]);
}


-(void)registerAPNS{
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // APNS 에 RemoteNotification 등록 실패
    ///////////////////////////////////////////////////////////////////////////////////////
    NSLog(@"registerAPNSregisterAPNSregisterAPNS");
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 // App boy
                 [[Appboy sharedInstance] pushAuthorizationFromUserNotificationCenter:granted];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[UIApplication sharedApplication] registerForRemoteNotifications]; // required to get the app to do anything at all about push notifications
                 });
                 
                 
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
             }
         }];
    }else { // iOS10 미만은 모두 여기
        
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


-(void)confirmAppBoyOldPush:(NSDictionary *)userInfo{
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // AppBoy Push 전달받을 시 호출됨
    // Push 메시지를 Alert으로 띄워줌
    ///////////////////////////////////////////////////////////////////////////////////////
    
    /*
     {
     ab =     {
     att =         {
     aof = 0;
     type = jpg;
     url = "https://appboy-images.com/appboy/communication/assets/image_assets/images/592d229f56ec31647e8e82b5/original.?1496130207";
     };
     c = "NTk3MTVkYWI1YzVhNjgzZWNmNzEyY2FmXzU5NzE1ZGFiNWM1YTY4M2VjZjcxMmNhYl9jbXA=";
     };
     "ab_uri" = "gsshopmobile://home?http://m.naver.com";
     aps =     {
     alert = "\Uc624\Ub298\Ub3c4 \Uc990\Uac70\Uc6b4 \Ud558\Ub8e8\Ub418\Uc138\Uc694.!!";
     badge = 1;
     "mutable-content" = 1;
     sound = "gsnoti.wav";
     };
     }
     */
    
    NSDictionary *strdic = [userInfo valueForKey:@"aps"];
    NSString *str = [NSString stringWithFormat:@"%@",[strdic valueForKey:@"alert"]];
    
    if([[strdic valueForKey:@"sound"] isEqualToString:@"gsnoti.wav"]){
        
        NSArray *argArrSound = [NCS([strdic valueForKey:@"sound"]) componentsSeparatedByString:@"."];
        SystemSoundID soundIDNoti;
        id sndPath = [[NSBundle mainBundle] pathForResource:[argArrSound objectAtIndex:0]
                                                     ofType:[argArrSound objectAtIndex:1]];
        // URL 타입 생성
        CFURLRef baseURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndPath]);
        // SoundID 생성
        AudioServicesCreateSystemSoundID(baseURL, &soundIDNoti);
        AudioServicesPlayAlertSound(soundIDNoti);
        
        if (baseURL) {
            CFBridgingRelease(baseURL);
        }
        
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:@"%@", str] maintitle:@"GSSHOP 알림" delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"), @"보기", nil]];
        malert.tag=1000;
        [self.window addSubview:malert];
        
    }else {
        // 진동모드와 상관없이 진동 5회
        [Mocha_DeviceHandle Devicevibe:3];
    }
    
    NSString *strAB_URI = NCS([userInfo objectForKey:ab_uri]);
    if ([strAB_URI length] > 0) {
        SL(strAB_URI, ab_uri);
    }
    
}



#pragma mark - Auto Login Process Functions
////////// 20190702 자동로그인 개편 ///////////////

///자동로그인 실행
- (void) Launch_autoLoginProcess:(NSString*)param process:(ResponseResultBlock) completionBlock {
    
    __block NSString * connectionStatus = [[Common_Util sharedInstance] connectedToNetwork];
    LoginData *obj = [DataManager sharedManager].m_loginData;
    
    if(NO == [param isEqualToString:@"재시도"]) {
        
        if([obj isKindOfClass:[LoginData class]]
           && obj.autologin == 1
           && [obj.loginid length] > 0
           && [obj.authtoken length] > 0
           && self.islogin == NO
           && self.isauthing == NO) {
            // 자동로그인 설정 되었으면
            self.isauthing = YES;
            self.currentOpLogin = [self.gshop_http_core gsTOKENAUTHURL: (NSString*)obj.loginid
                                                               serieskey : (NSString*)obj.serieskey
                                                                authtken : (NSString*)obj.authtoken
                                                                   snsTyp: (NSString*)obj.snsTyp
                                                             onCompletion:^(NSDictionary *result) {
                                                                 self.isauthing = NO;
                                                                 BOOL successval = [NCB([result valueForKey:@"succs"]) boolValue];
                                                                 if( !successval ) {
                                                                     if([[result valueForKey:@"errMsg"] isKindOfClass:[NSNull class]] == NO) {
                                                                         Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:[result valueForKey:@"errMsg"] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                                         [self.window addSubview:malert];
                                                                     }
                                                                     completionBlock(NOT_TARGET ,nil); // 실패이지만 재시도 하지 않고 그냥 알려주고 흘러가야 한다.
                                                                     return;
                                                                 }
                                                                 else {
                                                                     //로그인 성공
                                                                     if([self checkLoginCookie:YES] == NO){
                                                                         NSError *err = [NSError errorWithDomain:@"app_AutoLogin_Cookie_Failed" code:9002 userInfo:nil];
                                                                         NSString *msg = [[NSString alloc] initWithFormat:@"자동로그인후 쿠키값이 이상함을 확인" ];
                                                                         [ApplicationDelegate SendExceptionLog:err msg: msg];
                                                                     }
                                                                     
                                                                     // nami0342 - 거래거절고객 처리
                                                                     if([@"Y" isEqualToString:NCS([result objectForKey:@"txnRfuseCustYn"])] == YES)
                                                                     {
                                                                         [ApplicationDelegate SendPushRefuseWhenBlockUserLogin];
                                                                     }
                                                                 }
                                                                 self.activeApp = NO;
                                                                 //인증상태 배지정보최초 가져오기
                                                                 ////탭바제거
                                                                 [self performSelector:@selector(updateBadgeInfo:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.00f];
                                                                 completionBlock(RESULT_SUCCESS,result);
                                                             }
                                                                  onError:^(NSError* error) {
                                                                      //[self firstProc]; // 실패 하면 홈메인 호출전에 실패2회차에 한다.
                                                                      self.isauthing = NO;
                                                                      self.islogin = NO;
                                                                      NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                            [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                      // 네트워크 커넥션 상태 / 사용자 info 로그로 남기기
                                                                      NSLog(@"userInfo \n id: %@ \n seriesKey: %@ \n authtoken: %@ \n snsTyp: %@", obj.loginid, obj.serieskey, obj.authtoken, obj.snsTyp);
                                                                      self.activeApp = NO;
                                                                      NSString *msg = [NSString stringWithFormat:@"자동로그인 실패(%@) : Network 상태 : %@", param, connectionStatus];
                                                                      [self SendExceptionLog:error msg:msg];
                                                                      completionBlock(RESULT_FAIL,nil);
                                                                  }];
        }//자동로그인이 대상이 아님
        else {
            completionBlock(NOT_TARGET,nil);
        }
    }
    else { // 재시도
        
        if([obj isKindOfClass:[LoginData class]]
           && obj.autologin == 1
           && [obj.loginid length] > 0
           && [obj.authtoken length] > 0
           && self.islogin == NO
           && self.isauthing == NO) {
            // 자동로그인 설정 되었으면
            self.isauthing = YES;
            self.currentOpLogin = [self.gshop_http_core gsTOKENAUTHURL_Retry: (NSString*)obj.loginid
                                                            serieskey : (NSString*)obj.serieskey
                                                             authtken : (NSString*)obj.authtoken
                                                                snsTyp: (NSString*)obj.snsTyp
                                                          onCompletion:^(NSDictionary *result) {
                                                              self.isauthing = NO;
                                                              BOOL successval = [NCB([result valueForKey:@"succs"]) boolValue];
                                                              if( !successval ) {
                                                                  if([[result valueForKey:@"errMsg"] isKindOfClass:[NSNull class]] == NO) {
                                                                      Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:[result valueForKey:@"errMsg"] maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                                                      [self.window addSubview:malert];
                                                                  }
                                                                  completionBlock(NOT_TARGET ,nil); // 실패이지만 재시도 하지 않고 그냥 알려주고 흘러가야 한다.
                                                                  return;
                                                              }
                                                              else {
                                                                  //로그인 성공
                                                                  if([self checkLoginCookie:YES] == NO){
                                                                      NSError *err = [NSError errorWithDomain:@"app_AutoLogin_Cookie_Failed" code:9002 userInfo:nil];
                                                                      NSString *msg = [[NSString alloc] initWithFormat:@"자동로그인후 쿠키값이 이상함을 확인" ];
                                                                      [ApplicationDelegate SendExceptionLog:err msg: msg];
                                                                  }
                                                                  
                                                                  // nami0342 - 거래거절고객 처리
                                                                  if([@"Y" isEqualToString:NCS([result objectForKey:@"txnRfuseCustYn"])] == YES)
                                                                  {
                                                                      [ApplicationDelegate SendPushRefuseWhenBlockUserLogin];
                                                                  }
                                                                  
                                                              }
                                                              self.activeApp = NO;
                                                              //인증상태 배지정보최초 가져오기
                                                              ////탭바제거
                                                              [self performSelector:@selector(updateBadgeInfo:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.00f];
                                                              completionBlock(RESULT_SUCCESS,result);
                                                          }
                                                               onError:^(NSError* error) {
                                                                   //[self firstProc]; // 실패 하면 홈메인 호출전에 실패2회차에 한다.
                                                                   self.isauthing = NO;
                                                                   self.islogin = NO;
                                                                   NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                         [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                   // 네트워크 커넥션 상태 / 사용자 info 로그로 남기기
                                                                   NSLog(@"userInfo \n id: %@ \n seriesKey: %@ \n authtoken: %@ \n snsTyp: %@", obj.loginid, obj.serieskey, obj.authtoken, obj.snsTyp);
                                                                   self.activeApp = NO;
                                                                   NSString *msg = [NSString stringWithFormat:@"자동로그인 실패(%@) : Network 상태 : %@", param, connectionStatus];
                                                                   [self SendExceptionLog:error msg:msg];
                                                                   completionBlock(RESULT_FAIL,nil);
                                                               }];
        }//자동로그인이 대상이 아님
        else {
            completionBlock(NOT_TARGET,nil);
        }
    }
    
}


-(void) autoLogin_Sucess_Process:(NSDictionary*) result {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // 비밀번호 변경 여부 확인 & TV고객 로그인번호 변경여부 확인
    // webView Cookie 동기화
    // Amplitude 직원여부, 고객 등급 저장
    // 인트로에 사용자 이름 + 등급 나오도록 설정
    //
    ///////////////////////////////////////////////////////////////////////////////////////

    //2018.02.01 비밀번호 안보기 여부를 서버로 전송하기위해 평문으로 catvId 값 받음
    if ([NCS([result objectForKey:@"passwdNeedChgYn"]) isEqualToString:@"Y"] && [NCS([result objectForKey:@"passwdChgUrl"]) length] > 0) {
        
        [Common_Util checkPassWordChangeAlertShowWithUrl:NCS([result objectForKey:@"passwdChgUrl"]) andUserKey:[NSString stringWithFormat:@"%@", [result valueForKey:@"custNo"]]];
    }
    //20181017 parksegun TV고객 로그인번호 변경
    if ([NCS([result objectForKey:@"tvCustPasswdNeedChgYn"]) isEqualToString:@"Y"] && [NCS([result objectForKey:@"tvCustPasswdChgUrl"]) length] > 0) {
        [Common_Util checkTVUserPassWordChangeAlertShowWithUrl:NCS([result objectForKey:@"tvCustPasswdChgUrl"]) andUserKey:[NSString stringWithFormat:@"%@", [result valueForKey:@"custNo"]]];
    }
    
    // nami0342 - CSP
    [self CSP_StartWithCustomerID:[NSString stringWithFormat:@"%@", [result valueForKey:@"custNo"]]];
    
    [DataManager sharedManager].loginYN = @"Y";
    self.islogin = YES;
    //WKWebview Cookie동기화
    [[WKManager sharedManager] wkWebviewSetCookieAll:YES];
    
    // nami0342 - Set Amplitude identify : 직원여부, 고객 등급
    if(NCO([result valueForKey:@"custType"]) == YES) {
        [self setAmplitudeIdentifyWithSet:@"custType" value:[result valueForKey:@"custType"]];
    }
    
    if(NCO([result valueForKey:@"grade"]) == YES) {
        [self setUGradeValue:NCS([result valueForKey:@"grade"])];
        [self setAmplitudeIdentifyWithSet:@"grade" value:[result valueForKey:@"grade"]];
    }
    
    
    
    //인트로 텍스트 노출 스플래시떠있는지 알수 있을까??
    if(self.spviewController != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spviewController showUserInfo:[result objectForKey:@"custNm"] grade:[result valueForKey:@"grade"]];
        });
    }
    
    NSLog(@"로그인 성공 - 토큰갱신");
    
    //베스트딜 하단 추천상품 용으로 username 저장 2015.10.12 YS Jin
    [[DataManager sharedManager]setUserName:[result objectForKey:@"custNm"]];
    
    [[DataManager sharedManager]updateLoginAuthToken:[result objectForKey:@"certToken"]];
    
    //PMS아이디세팅  - 확인필요
    [PMS setUserId:[NSString stringWithFormat:@"%@",[result valueForKey:@"custNo"]] ];
    
    
    [self PMSsetUUIDNWapcidNpcid];
    [PMS login];
    
    //amplitude
    [self setAmplitudeUserId:[[result valueForKey:@"custNo"] stringValue]];
    
    
    //20160118 custNo 상품평을 위해 저장
    [[DataManager sharedManager]setCustomerNo:[result valueForKey:@"custNo"]];
    
    // App boy - Custom event sending
    NSString *strCustNo = [NSString stringWithFormat:@"%@",[result valueForKey:@"custNo"]];
    NSString *strUser = NCS(strCustNo);
    
    if ([strUser length] > 0) {
        [[Appboy sharedInstance] changeUser:strUser];
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"catvid" andStringValue:strUser];
    }
    
    if ([NCS(DEVICEUUID) length] > 0) {
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"uuid" andStringValue:DEVICEUUID];
    }
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"gd"]) {
            NSString *strGd = NCS([cookie.value copy]);
            if ([strGd length] > 0) {
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"gd" andStringValue:strGd];
                [self setGender:strGd];
            }
        }
        else if ([cookie.name isEqualToString:@"yd"]) {
            NSString *strYd = NCS([cookie.value copy]);
            if ([strYd length] > 0) {
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"yd" andStringValue:strYd];
                [self setAge:strYd];
            }
        }
    }
    // App boy end
    
    [[DataManager sharedManager]getPushInfo];
    // 디바이스 토큰이 없을때. nil로 푸시정보전송
    if([[DataManager sharedManager].m_pushData.deviceToken isEqualToString:@""] == YES) {
        PushDataRequest *pushRequest = [[PushDataRequest alloc]init];
        [pushRequest sendData:nil  customNo:[result valueForKey:@"custNo"]];
    }
    else {
        // 디바이스 토큰이 존재함. 정상적으로 토큰포함 푸시정보전송
        PushDataRequest *pushRequest = [[PushDataRequest alloc]init];
        [pushRequest sendData:[DataManager sharedManager].m_pushData.deviceToken customNo:[result valueForKey:@"custNo"]];
    }
    
    // AirBridge 1.9.0
    [AirBridge.state setUserID:[[result valueForKey:@"custNo"] stringValue]];
}

- (void)autoLoginProcess:(BOOL)isAutoLogin{
    self.isauthing = YES;
    self.currentOpLogin = [ApplicationDelegate.gshop_http_core gsREGAUTOAUTHURL:^(NSDictionary *result) {
        NSLog(@"gsREGAUTOAUTHURL login success");
        NSLog(@"resutl=%@",result);//custno
        NSLog(@"errmsg: %@", [result valueForKey:@"errMsg"] );
        
        if ([[result objectForKey:@"succs"] boolValue] == YES) {
            
            [[DataManager sharedManager] getPushInfo];
            if([[DataManager sharedManager].m_pushData.deviceToken isEqualToString:@""] == NO) {
                // 디바이스 토큰이 존재함. 정상적으로 토큰포함 푸시정보전송
                PushDataRequest *pushRequest = [[PushDataRequest alloc]init];
                [pushRequest sendData:[DataManager sharedManager].m_pushData.deviceToken customNo:[result valueForKey:@"custNo"]];
            }
            
            [DataManager sharedManager].loginYN = @"Y";
            ApplicationDelegate.islogin = YES;
            
            
            if([[[GSDataHubTracker sharedInstance] itscustclass] isEqualToString:@"02"] || [[[GSDataHubTracker sharedInstance] itscustclass] isEqualToString:@"05"]) {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"NO" forKey:@"isHide"];
                [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONHIDEBUTTONSIREN object:nil userInfo:userInfo];
            }
            
            
            //로그인 성공
            if([self checkLoginCookie:YES] == NO){
                NSError *err = [NSError errorWithDomain:@"app_anotherLogin_Cookie_Failed" code:9003 userInfo:nil];
                NSString *msg = [[NSString alloc] initWithFormat:@"기타 로그인후 쿠키값이 이상함을 확인" ];
                [ApplicationDelegate SendExceptionLog:err msg: msg];
            }
            
            
            
            
            //PMS아이디세팅
            [PMS setUserId:[NSString stringWithFormat:@"%@",[result valueForKey:@"custNo"]] ];
            [ApplicationDelegate PMSsetUUIDNWapcidNpcid];
            [PMS login];
            
        
            
            // App boy - Custom event sending
            NSString *strCustNo = [NSString stringWithFormat:@"%@",[result valueForKey:@"custNo"]];
            NSString *strUser = NCS(strCustNo);
            [[DataManager sharedManager]setUserName:[result objectForKey:@"custNm"]];
            [DataManager sharedManager].customerNo = strUser;
            
            if([strUser length] > 0) {
                [[Appboy sharedInstance] changeUser:strUser];
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"catvid" andStringValue:strUser];
                // nami0342 - Air Bridge 1.0.0
                ABUser *abuser = [[ABUser alloc] init];
                abuser.ID = strCustNo;
                ABUserEvent *abUserEvent = [[ABUserEvent alloc] initWithUser:abuser];
                [abUserEvent sendSignin];
            }
            
            // nami0342 - 거래거절고객 처리
            if([@"Y" isEqualToString:NCS([result objectForKey:@"txnRfuseCustYn"])] == YES)
            {
                [ApplicationDelegate SendPushRefuseWhenBlockUserLogin];
            }
            
            // nami0342 - CSP
            [self CSP_StartWithCustomerID:strUser];
            
            // nami0342 - Set Amplitude identify : 직원여부, 고객 등급
            if(NCO([result valueForKey:@"custType"]) == YES) {
                [ApplicationDelegate setAmplitudeIdentifyWithSet:@"custType" value:[result valueForKey:@"custType"]];
            }
            
            if(NCO([result valueForKey:@"grade"]) == YES) {
                [ApplicationDelegate setUGradeValue:NCS([result valueForKey:@"grade"])];
                [ApplicationDelegate setAmplitudeIdentifyWithSet:@"grade" value:[result valueForKey:@"grade"]];
            }
            
            if([NCS(DEVICEUUID) length] > 0) {
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"uuid" andStringValue:DEVICEUUID];
            }
            
            NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            
            NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
            for(NSHTTPCookie *cookie in gsCookies) {
                if([cookie.name isEqualToString:@"gd"]) {
                    NSString *strGd = NCS([cookie.value copy]);
                    if ([strGd length] > 0) {
                        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"gd" andStringValue:strGd];
                    }
                }
                else if ([cookie.name isEqualToString:@"yd"]) {
                    NSString *strYd = NCS([cookie.value copy]);
                    if ([strYd length] > 0) {
                        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"yd" andStringValue:strYd];
                    }
                }
            }
            // App boy end
            //인증상태 배지정보  가져오기
            [self updateBadgeInfo:[NSNumber numberWithBool:YES]];
            [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:1]];
            
            // nami0342 - DB -> 로컬 저장으로 변경
            [[DataManager sharedManager] GetLoginData];
            // nami0342 - 싱글톤 로그인 인스턴스에 로그인 값 저장
            [DataManager sharedManager].m_loginData.loginid  = ([NCS([result objectForKey:@"loginId"])length]>0)?NCS([result objectForKey:@"loginId"]):@"";
            [DataManager sharedManager].m_loginData.serieskey =  [result objectForKey:@"serisKey"];
            [DataManager sharedManager].m_loginData.authtoken = [result objectForKey:@"certToken"];
            [DataManager sharedManager].m_loginData.snsTyp =  NCS([result objectForKey:@"snsTyp"]);
            [DataManager sharedManager].m_loginData.simplelogin = NO;
            [DataManager sharedManager].m_loginData.autologin = isAutoLogin;
            [DataManager sharedManager].m_loginData.saveid = NO;
            [DataManager saveLoginData];
            //fingerprint
            //지문로그인이 살아 있다면 제거한다.
            SL(nil,FINGERPRINT_USE_KEY); // 연동해제
            
            [[Common_Util sharedInstance] saveToLocalData];
            
            
        }else{
            NSString *strErrMsg = NCS([result objectForKey:@"errMsg"]);
            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strErrMsg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            [self.window addSubview:malert];
            
        }
        
        
    } //result
                                                                           onError:^(NSError *error) {
                                                                               //... noting
                                                                           }];
}


#pragma mark - Version Check
- (BOOL)checkVersion {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // 통신오류값 전달시 (kStatusCommFailed),
    // 공사중 페이지가 있으면 호출 (http://m.gsshop.com/oops.html)
    ///////////////////////////////////////////////////////////////////////////////////////
    
    // TEST kiwon: 네트워크 연결상태를 iOS 프레임워크로 직접 확인
    NSString *isConnectNetwork = [[Common_Util sharedInstance] connectedToNetwork];
    NSLog("Device Nerwork is %@", isConnectNetwork);
    
    if( [@"Disconnected"  isEqual: isConnectNetwork] ) {
        if(![self isthereMochaAlertView]){
            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:GNET_SERVERDOWN maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_close"), GSSLocalizedString(@"View_on_the_web_text"), nil]];
            malert.tag = 555;
            [self.window addSubview:malert];
        }
    }
    else {
        //!!치명
        //강제업데이트일경우 이후 프로세스 진행하지 않음.
        StatusUpdateType ttype = [self launchingProcVersionCheck];
        if(ttype == kStatusForceUpdate ) {
            return NO;
        }
        else if(ttype == kStatusCommFailed) {
            //oops.html 통신
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GSMAINTAINSERVERFLAGURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0f];
            
            //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
            NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
            [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
            [urlRequest setHTTPMethod:@"GET"];
            [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
            NSError *derror;
            NSURLResponse *dresponse;
            // 공사중 페이지는 평소에는 없다가 서버 점검 시에만 나오는 페이지로 해당 페이지가 있다면, 서버 점검이므로 처리한다.
            NSData* resultstr = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&dresponse timeout:TIMEOUT_INTERVAL_REQUEST error:&derror];
            if(resultstr) {
                NSString *rsString = [[NSString alloc] initWithData:resultstr encoding:NSUTF8StringEncoding] ;
                NSLog(@"플결 %@",rsString );
                //개행 공백 제거후 비교 필!
                if([[Mocha_Util trim:rsString] isEqualToString:@"Y"]) {
                    NormalFullWebViewController *fullwv = [[NormalFullWebViewController alloc] initWithUrlString:SERVERURI];
                    [fullwv showPopup];
                    fullwv.view.tag = 505;
                    [DataManager sharedManager].selectTab = 0;
                    self.isOutofService = YES;
                    // check 후 call
                    fullwv.modalPresentationStyle =UIModalPresentationOverFullScreen;
                    [self.window.rootViewController presentViewController:fullwv animated:YES completion:nil];
                    return NO;
                }
            }
            else {
                NSLog(@"리졀트 없음");
                NSLog(@"error3 %@\t%@\t%@\t%@", [derror localizedDescription], [derror localizedFailureReason],
                      [derror localizedRecoveryOptions], [derror localizedRecoverySuggestion]);
                // nami0342 - Check IDC Network Down - IDC 네트워크가 다운될 경우 체크
                if([self isIDCServerNetworkDown] == YES) {
                    return NO;
                }
            }
        }
    }
    
    
    dispatch_queue_t cQueue = dispatch_queue_create("CSP_Socket", nil);
    dispatch_async(cQueue, ^{
        [self isCNSStatusOK];
    });
    
    
    return YES;
}

-(StatusUpdateType)launchingProcVersionCheck {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명 - AppDelegate.m checkVersion()에서만 호출됨.
    //
    // 앱버전 체크 후 강제 / 선택 업데이트 Alert 노출 후 StatusUpdateType 반환
    ///////////////////////////////////////////////////////////////////////////////////////
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", SERVERURI,GSAPPVERSION]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0f];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    NSError *derror;
    NSURLResponse *dresponse;
    
    NSData* resultstr = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&dresponse timeout:TIMEOUT_INTERVAL_REQUEST error:&derror];
    
    if (resultstr) {
        NSDictionary* tmpInfoDic = [resultstr JSONtoValue ];
        
        //데이터를 수신했으나 정보가 불명확하다면..
        
        if(!NCO(tmpInfoDic) && !NCO([tmpInfoDic objectForKey:@"choice"]) && !NCO([tmpInfoDic objectForKey:@"force"]) && !NCO([tmpInfoDic objectForKey:@"vername"]) && !NCO([tmpInfoDic objectForKey:@"vercode"])) {
            return kStatusCommFailed;
        }
        
        NSLog(@"앱버전 체크 - 서버버전정보확인   comm:::%@:::%@:::%@:::%@:::\n\n\n\n %@", [tmpInfoDic objectForKey:@"choice"] , [tmpInfoDic objectForKey:@"force"], [tmpInfoDic objectForKey:@"vername"],[tmpInfoDic objectForKey:@"vercode"], tmpInfoDic);
        
        NSLog(@"앱버전 체크 - 로컬버전정보확인  comm:::%@:::%@:::%@:::", CURRENTAPPVERSION, COMPAREVERSIONCHOICE,COMPAREVERSIONFORCE);
        
        
        //테스트용 제거필요 0809 중요
        //result = @"2.0.0.0";
        
        serverAppvername = [tmpInfoDic objectForKey:@"vername"];
        serverAppvercode = [tmpInfoDic objectForKey:@"vercode"];
        
        int curvforcenum = [ COMPAREVERSIONFORCE intValue];
        int servforcenum = [ [tmpInfoDic objectForKey:@"force"] intValue];
        
        if (curvforcenum < servforcenum){
            
            spviewController = [[SplashViewController alloc] init];
            [self.window addSubview:[spviewController view]];
            gactivityIndicator = [[SHActivityIndicatorView alloc] init];
            
            //강제 처리
            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:[tmpInfoDic objectForKey:@"forcemsg"] maintitle:GSSLocalizedString(@"update_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"update_now"), nil]];
            malert.tag = TAGVIEWLAUNCHFORCEUPDATE;
            [ApplicationDelegate.window addSubview:malert];
            
            return kStatusForceUpdate;
        }
        
        int curv = [COMPAREVERSIONCHOICE intValue];
        int servv = [[tmpInfoDic objectForKey:@"choice"] intValue];
        
        //현재 앱버전이 서버에서 내려준 버전보다 낮다면 Alert
        if(curv < servv) {
            
            //선택 처리
            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:[tmpInfoDic objectForKey:@"choicemsg"] maintitle:GSSLocalizedString(@"update_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"update_later"),GSSLocalizedString(@"update_now"), nil]];
            malert.tag = TAGVIEWLAUNCHLATERUPDATE;
            [ApplicationDelegate.window addSubview:malert];
            
            return kStatusLaterUpdate;
        }
        
        return kStatusNoneUpdate;
        
    }
    else {
        NSLog(@"결과 없음");
        
        //result 없음 통신실패시 무사통과
        return kStatusCommFailed;
    }
    
    return kStatusNoneUpdate;
}

- (BOOL) isIDCServerNetworkDown
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:IDCSERVERDOWNURL]];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    NSError *derror;
    NSURLResponse *dresponse;
    
    
    // 공사중 페이지는 평소에는 없다가 서버 점검 시에만 나오는 페이지로 해당 페이지가 있다면, 서버 점검이므로 처리한다.
    NSData* resultstr = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&dresponse timeout:kMKNetworkKitRequestTimeOutInSeconds error:&derror];
    
    if (resultstr)
    {
        NSString *rsString = [[NSString alloc] initWithData:resultstr encoding:NSUTF8StringEncoding] ;
        
        
        NSLog(@"플결 %@",rsString );
        
        // nami0342 - 공백 제거 후 IDC_ERROR 문자열이 포함되어 있으면 점검중으로 처리 (혹시 모를 특수 문자가 들어갈 경우를 위해)
        NSString *strCode = [Mocha_Util trim:rsString];
        
        if([strCode rangeOfString:@"IDC_ERROR"].location != NSNotFound){
            
            // nami0342 : IDC 네트워크가 다운됐다면 프로모션 팝업도 정상 동작하지 않을 것이므로 프로모션 팝업을 안 뜨게하는 처리는 하지 않음.
            NormalFullWebViewController *fullwv = [[NormalFullWebViewController alloc] initWithUrlString:IDCLANDINGPAGE];
            fullwv.view.tag = 505;
            [DataManager sharedManager].selectTab = 0;
            
            
            // check 후 call
            [self.window.rootViewController presentViewController:fullwv animated:YES completion:nil];
            
            return YES;
        }
    }
    else
    {
        NSLog(@"리졀트 없음");
        NSLog(@"error3 %@\t%@\t%@\t%@", [derror localizedDescription], [derror localizedFailureReason],
              [derror localizedRecoveryOptions], [derror localizedRecoverySuggestion]);
        return NO;
    }
    
    return NO;
}





// TAGContainerOpenerNotifier callback.
//- (void)containerAvailable:(TAGContainer *)tcontainer {
    // Note that containerAvailable may be called on any thread, so you may need to dispatch back to
    // your main thread.
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.container = tcontainer;
//        // Register a function call macro handler using the macro name defined
//        // in the Google Tag Manager web interface.
//        if([self.container  stringForKey:@"bestdeal_ver"] != nil) {
//            [DataManager sharedManager].abBestdealVer = [self.container  stringForKey:@"bestdeal_ver"];
//        }
//        
//        if([self.container  stringForKey:@"bullet_ver"] != nil) {
//            [DataManager sharedManager].abBulletVer = [self.container  stringForKey:@"bullet_ver"];
//        }
//        
//        NSLog(@"티티티 %@ === %@  ",   [DataManager sharedManager].abBestdealVer ,[DataManager sharedManager].abBulletVer   );
//    });
//}




#pragma mark - Criteo log Sending Functions
// nami0342 - Send criteo log
- (void) sendCriteoLog {
    NSMutableDictionary *mdicLog = [[NSMutableDictionary alloc] init];
    // nami0342 - App bundle ID는 아이폰/ 안드로이드 공통으로 com.gsshop 으로 사용하기로 함.
    [mdicLog setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"com.gsshop", @"an", @"kr", @"cn", @"ko", @"ln",nil] forKey:@"account"];
    [mdicLog setObject:@"aios" forKey:@"site_type"];
    [mdicLog setObject:[NSDictionary dictionaryWithObjectsAndKeys:APPLE_AD_ID, @"gaid", nil] forKey:@"id"];
    [mdicLog setObject:@"s2s_v1.0.0" forKey:@"version"];
    
    // nami0342 - Event 호출 항목 및 설명
    /*
     viewHome       - App 최초 구동 시
     viewListing    - 여러 개의 상품이 있는 페이지를 볼 경우
     viewProduct    - 제품 상세 페이지를 볼 경우
     viewBasket     - 장바구니 진입 시
     trackTransaction   - 구매 성공 시
     appDeeplink    - App이 Deeplink로 실행될 때
     */
    [mdicLog setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"viewHome", @"event", @"", @"ci", nil] forKey:@"events"];
    
    
    // To JSON string + URL encoding
    NSString *strJson = [[mdicLog JSONtoString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    // Send a log to GSShop server if possibled.
    NSString *strURL = [NSString stringWithFormat:@"%@?data=%@", @"https://widget.as.criteo.com/m/event", strJson];
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"GET"];
    
    NSLog(@"sendCriteoLog");
    
    [NSURLSession Async_sendSessionRequest:urlRequest timeout:TIMEOUT_INTERVAL_REQUEST returnBlock:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
        }
        else {
            NSLog(@"Criteo log send finished");
        }
    }];
    
    
}


#pragma mark - Google Analytics & TagManager & Tracker
// Analytics
-(void)GAsendLog:(NSString*)ltype tname:(NSString*)targetname {
    
}

// Tag Manager
-(void)GTMsendLog:(NSString*)Category withAction:(NSString*)Action withLabel:(NSString*)Label {
    
    NSString*kCategory =@"eventCategory";
    NSString*keventAction =@"eventAction";
    NSString*keventLabel =@"eventLabel";
    
    [FIRAnalytics logEventWithName:Category parameters:@{@"event":@"imgClick",
                                                            kCategory: Category,
                                                            keventAction: Action,
                                                            keventLabel: Label}];
//    [self.tagManager.dataLayer push:@{@"event":@"imgClick",
//                                      kCategory: Category,
//                                      keventAction: Action,
//                                      keventLabel: Label  }];
    
    NSLog(@"GTMSendLog:: %@, %@, %@", Category, Action, Label);
}


-(void)GTMsendPurchaseLog:(NSDictionary*)Action withProducts:(NSArray*)Products {
    
    
    // Air Bridge 1.0.0
    //    NSMutableArray *arABlist = [[NSMutableArray alloc] init];
    
    //    NSString *strRevenue = NCS([Action objectForKey:@"revenue"]);
    //    NSString *strTransactionId = NCS([Action objectForKey:@"id"]);
    
    //    for(NSDictionary *dicItem in Products)
    //    {
    //        // Air Bridge 1.0.0
    //        ABProduct *abprd = [[ABProduct alloc] init];
    //        abprd.idx = NCS([dicItem objectForKey:@"id"]);
    //        abprd.name = NCS([dicItem objectForKey:@"name"]);
    //
    //        if([dicItem objectForKey:@"price"] != nil)
    //            abprd.price = [NSNumber numberWithDouble:[[dicItem objectForKey:@"price"] doubleValue]];
    //
    //        if([dicItem objectForKey:@"quantity"] != nil)
    //            abprd.quantity = [NSNumber numberWithInt:[[dicItem objectForKey:@"quantity"] intValue]];
    //
    //        abprd.currency = @"KRW";
    //        [arABlist addObject:abprd];
    //    }
    
    // nami0342 - Air Bridge 1.0.0
    //    ABEcommerceEvent *abEcomm = [[ABEcommerceEvent alloc] initWithProducts:arABlist];
    //    abEcomm.isInAppPurchase = NO;
    //    abEcomm.transactionID = strTransactionId;
    //    [abEcomm sendCompleteOrder];
    
    NSLog(@"GTMPurchaseSendLog:: %@, %@", Action, Products);
    // nami0342 - 해당 뎁스를 처리 못함 String으로 변경하던지 해야할 듯
//    [self.tagManager.dataLayer push:@{@"ecommerce": @{@"purchase": @{@"actionField":Action,@"products":Products}}}];
    [FIRAnalytics logEventWithName:@"ecommerce" parameters:@{@"ecommerce": @{@"purchase": @{@"actionField":Action,@"products":Products}}}];
}

-(void)GTMscreenOpenSendLog:(NSString*)ScrName {
    
    NSString*kCategory =@"screenName";
    [FIRAnalytics logEventWithName:ScrName parameters:@{@"event":@"screenOpen",kCategory: ScrName  }];
//    [self.tagManager.dataLayer push:@{@"event":@"screenOpen",
//                                      kCategory: ScrName  }];
}

// Tracker
-(void)GAUiTimingWithCategorysendLog:(NSString*)catelabel   ttimeval:(NSNumber*)ttime withName:(NSString*)namestr withLabel:(NSString*)lbelstr {
    NSLog(@"TTTIME: %f,  %@, %@, %@", (double)[ttime doubleValue], catelabel, namestr, lbelstr);
    
}

#pragma mark - AppBoy
-(void)FirstAppsettingWithOptinFlag:(BOOL)isyes withResultAlert:(BOOL)isalerttype{
    
    //APPPUSH_DEF_NOTI_FLAG 기준
    
    if (isyes == YES) {
        [self registerAPNS];
        [[Appboy sharedInstance].user setPushNotificationSubscriptionType: ABKSubscribed];
    }
    else
    {
        [[Appboy sharedInstance].user setPushNotificationSubscriptionType: ABKUnsubscribed];
    }
    
    NSString *custNo = NCS([[DataManager sharedManager] customerNo]);
    
    NSLog(@"custNocustNo = %@",custNo);
    
    //PMS푸시 수신여부 , N 하면 안 옴
    //2018.01.03 인터벌 3->1 로 줄임
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delayedPMSSetting:) userInfo:[NSNumber numberWithBool:isyes] repeats:NO];
    
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue: @"Y"  forKey:APPPUSH_DEF_MSG_FLAG];
    [userDefaults setValue:isyes?@"Y":@"N" forKey:APPPUSH_DEF_NOTI_FLAG];
    
    //GS앱 설정화면의 푸시 수신여부값
    [userDefaults setValue:isyes?@"Y":@"N" forKey:GS_PUSH_RECEIVE];
    
    if(isyes == YES){
        //DATAHUB CALL
        //D_1030 앱푸시수신신청
        @try {
            
            [[GSDataHubTracker sharedInstance] NeoCallGTMWithReqURL:@"D_1030" str2:nil str3:nil];
        }
        @catch (NSException *exception) {
            
            NSLog(@"D_1030 ERROR : %@", exception);
        }
        @finally {
        }
    }else {
        //DATAHUB CALL
        //D_1031 앱푸시수신해지
        @try {
            
            [[GSDataHubTracker sharedInstance] NeoCallGTMWithReqURL:@"D_1031" str2:nil str3:nil];
        }
        @catch (NSException *exception) {
            
            NSLog(@"D_1031 ERROR : %@", exception);
        }
        @finally {
        }
    }
    
    /*
     20160310 parksegun 팝업은 옵션창에서 띄움
     */
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [df setDateFormat:@"YYYY.MM.dd"];
    NSDate *curDate = [NSDate date];
    NSString *optinProcDate = [df stringFromDate:curDate];
    
    
    
    if(isalerttype == YES){
        //알럿
        NSString *strMessage = [NSString stringWithFormat:@"%@ (%@)", (isyes==YES)?GSSLocalizedString(@"apns_optin_result_accept"):GSSLocalizedString(@"apns_optin_result_reject"), optinProcDate];
        
        Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strMessage maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        [self.window addSubview:malert];
        
        
    }else{
        //토스트
        [self performSelector:@selector(ShowPushSettingToast) withObject:nil afterDelay:0.5];
    }
}

-(void)ShowPushSettingToast {

    BOOL isyes = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempMsgFlag = [userDefaults valueForKey:GS_PUSH_RECEIVE];
    
    
    if(tempMsgFlag==nil && [tempMsgFlag isEqualToString:@"N"]) {
        isyes = NO;
    } else if ([tempMsgFlag isEqualToString:@"Y"]) {
        isyes = YES;
    }else {
        isyes = NO;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [df setDateFormat:@"YYYY.MM.dd"];
    NSDate *curDate = [NSDate date];
    NSString *optinProcDate = [df stringFromDate:curDate];
    
    NSString *strMessage = [NSString stringWithFormat:@"%@ (%@)", (isyes==YES)?GSSLocalizedString(@"apns_optin_result_accept"):GSSLocalizedString(@"apns_optin_result_reject"), optinProcDate];
    
    [Mocha_ToastMessage toastWithDuration:2.0 andText:strMessage inView:ApplicationDelegate.window];
}







#pragma mark
-(void)MobileAppTrackerSendLogMemberRegistration:(NSDictionary*)jstrdic{
    // nami0342 - 나중에 마케팅 툴 추가 시 재 사용을 위해 함수만 놔둠.
}

-(void)MobileAppTrackerSendLogCartAndPurchase:(NSString*)CnP withDic:(NSDictionary*)jstrdic{
    
//    @try {
//
//        //cart
//        if ([CnP isEqualToString:@"add_to_cart"]) {
//
//            float totalrev = 0;
//
//            if(NCA([jstrdic objectForKey:@"item"]) == NO)
//                return;
//
//            NSArray* tarr = [NSArray arrayWithArray:[jstrdic objectForKey:@"item"]];
//
//            NSMutableString *mstrFBDPA_contentIDs = [[NSMutableString alloc] init];
//
//            // Facebook DPA
//            if([tarr count] > 1)
//            {
//                [mstrFBDPA_contentIDs appendString:@"[\""];
//            }
//
//
//            // Air Bridge 1.0.0
////            NSMutableArray *arABlist = [[NSMutableArray alloc] init];
//
//            for (int i=0; i<[tarr count]; i++) {
//
//                totalrev += [[[tarr objectAtIndex:i] objectForKey:@"revenue"] doubleValue];
//
//                // Air Bridge 1.0.0
////                ABProduct *abprd = [[ABProduct alloc] init];
////                abprd.name = NCS([[tarr objectAtIndex:i] objectForKey:@"itemName"]);
////                abprd.price = [NSNumber numberWithDouble:[[[tarr objectAtIndex:i] objectForKey:@"unitPrice"] doubleValue]];
////                abprd.currency = @"KRW";
////                abprd.quantity = [NSNumber numberWithInt:[[[tarr objectAtIndex:i] objectForKey:@"quantity"] intValue]];
////                [arABlist addObject:abprd];
//
//
//                // Facebook DPA
//                [mstrFBDPA_contentIDs appendString:[[tarr objectAtIndex:i] objectForKey:@"itemName"]];
//                if([tarr count] > 1)
//                {
//                    if([tarr count] -1 < i)
//                    {
//                        // middle
//                        [mstrFBDPA_contentIDs appendString:@"\", \""];
//                    }
//                    else
//                    {   // end
//                        [mstrFBDPA_contentIDs appendString:@"\"]"];
//                    }
//                }
//                else
//                {
//                    // 단 건일 경우 아무것도 안 함.
//                }
//            }
//
//
//
//
//            // nami0342 - Air Bridge 1.0.0
////            ABEcommerceEvent *abecomm = [[ABEcommerceEvent alloc] initWithProducts:arABlist];
////            [abecomm sendAddProductToCart];
//
//
//
//
//            // Facebook DPA
//            NSDictionary *dicFBDPA_Items = [NSDictionary dictionaryWithObjectsAndKeys:
//                                            @"KRW", FBSDKAppEventParameterNameCurrency,
//                                            @"product", FBSDKAppEventParameterNameContentType,
//                                            mstrFBDPA_contentIDs, FBSDKAppEventParameterNameContentID ,nil];
//            [FBSDKAppEvents logEvent:FBSDKAppEventNameAddedToCart valueToSum:totalrev
//                          parameters:dicFBDPA_Items];
//
//        }
//        //결제
//        else {
//            float totalrev = 0;
//
//            if(NCA([jstrdic objectForKey:@"item"]) == NO)
//                return;
//
//            NSArray* tarr = [NSArray arrayWithArray:[jstrdic objectForKey:@"item"]];
//
//            NSMutableString *mstrFBDPA_contentIDs = [[NSMutableString alloc] init];
//
//            // Facebook DPA
//            if([tarr count] > 1)
//            {
//                [mstrFBDPA_contentIDs appendString:@"[\""];
//            }
//
//
//            // Air Bridge 1.0.0 -> GTM으로 이관
//            for (int i=0; i<[tarr count]; i++) {
//                totalrev += [[[tarr objectAtIndex:i] objectForKey:@"revenue"] doubleValue];
//
//                // Facebook DPA
//                [mstrFBDPA_contentIDs appendString:[[tarr objectAtIndex:i] objectForKey:@"itemName"]];
//                if([tarr count] > 1)
//                {
//                    if([tarr count] -1 < i)
//                    {
//                        // middle
//                        [mstrFBDPA_contentIDs appendString:@"\", \""];
//                    }
//                    else
//                    {   // end
//                        [mstrFBDPA_contentIDs appendString:@"\"]"];
//                    }
//                }
//                else
//                {
//                    // 단 건일 경우 아무것도 안 함.
//                }
//
//            }
//
//
//
//            // Facebook DPA
//            NSDictionary *dicFBDPA_Items = [NSDictionary dictionaryWithObjectsAndKeys:
//                                            @"product", FBSDKAppEventParameterNameContentType,
//                                            mstrFBDPA_contentIDs, FBSDKAppEventParameterNameContentID ,nil];
//            [FBSDKAppEvents logPurchase:totalrev currency:mstrFBDPA_contentIDs parameters:dicFBDPA_Items];
//        }
//
//
//    }
//    @catch (NSException *exception) {
//        NSLog(@"MAT SDK Exception at Appdelegate Process : %@", exception);
//    }
}


// MAT Logging View - 상품보기
- (void) MobileAppTrackerSendLogView:(NSDictionary *) jstrdic
{
//    @try {
//        float totalrev = 0;
//        NSMutableString *mstrFBDPA_contentIDs = [[NSMutableString alloc] init];
////        NSMutableArray *marTuneItems = [NSMutableArray array];
//
//
//        if([jstrdic objectForKey:@"dealNo"] != nil && [[jstrdic objectForKey:@"dealNo"] isKindOfClass:[NSString class]] == YES&& [[jstrdic objectForKey:@"dealNo"] length] > 0)
//        {
//            [mstrFBDPA_contentIDs appendString:[jstrdic objectForKey:@"dealNo"]];
//            totalrev = [[jstrdic objectForKey:@"dealLowPrc"] floatValue];
//
//        }
//        else
//        {
//
//            if([jstrdic objectForKey:@"prdCd"] != nil && [[jstrdic objectForKey:@"prdCd"] isKindOfClass:[NSString class]] && [[jstrdic objectForKey:@"prdCd"] length] > 0)
//            {
//                [mstrFBDPA_contentIDs appendString:[jstrdic objectForKey:@"prdCd"]];
//                totalrev = [[jstrdic objectForKey:@"recopickRcmdPrdSalePrc"] floatValue];
//                if(totalrev == 0)
//                    totalrev = [[jstrdic objectForKey:@"prdPrc"] floatValue];
//            }
//        }
//
//        // Facebook DPA
//        if([mstrFBDPA_contentIDs length] > 0)
//        {
//            NSDictionary *dicFBDPA_Items = [NSDictionary dictionaryWithObjectsAndKeys:
//                                            @"KRW", FBSDKAppEventParameterNameCurrency,
//                                            @"product", FBSDKAppEventParameterNameContentType,
//                                            mstrFBDPA_contentIDs, FBSDKAppEventParameterNameContentID ,nil];
//            // Send Facebook DPA
//            [FBSDKAppEvents logEvent:FBSDKAppEventNameViewedContent valueToSum:totalrev
//                          parameters:dicFBDPA_Items];
//        }
//
//
//    }
//    @catch (NSException *exception) {
//        NSLog(@"MAT SDK Exception at Appdelegate Process : %@", exception);
//    }
    
}

#pragma mark - Private & Public Functions
-(void) loadingDone {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // SplashViewController 닫기
    // 구글 Analytics로 view 트레킹 로그 보내기
    ///////////////////////////////////////////////////////////////////////////////////////
    if(spviewController != nil)
    {
        //checkexcuteTime
        //5초보다 느리거나 실제 spview 존재시만 작동
        if( [[Common_Util writeExcuteTimeNSnumberLog] intValue] < 5000){
            
            [ApplicationDelegate GAUiTimingWithCategorysendLog:@"NATIVE_PAGE" ttimeval:[Common_Util writeExcuteTimeNSnumberLog]     withName:@"iOS" withLabel:@"INTRO"];
        }
        
        /*
         http://stackoverflow.com/questions/21322983/app-speed-in-google-analytics-3-03-ios-sdk/21408160#21408160
         I have had the same issue as you for a while, but finally found the solution that worked for me!
         It's not documented, as far as I can tell, but the createTimingWithCategory:interval:name:label: method takes the interval parameter as a NSNumber that is required to be contain an integer value
         Try replacing the first row of your method with this:
         NSNumber *n = [NSNumber numberWithInt:(int)(loadTime*1000)];
         */
        
        if (![spviewController.timer isValid]) {
            //인트로이미지
            [spviewController performSelector:@selector(finishedFading) withObject:nil afterDelay:0.1f];
            spviewController = nil;
        }
    }
}


- (BOOL) isCanUseBioAuth {
    if ([LAContext class] && !([Mocha_Util strContain:@"iPhone 5" srcstring:[UIDevice currentDevice].deviceModelName] ? ([Mocha_Util strContain:@"iPhone 5s" srcstring:[UIDevice currentDevice].deviceModelName] ? NO : YES) : NO)) {
        
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            return YES;
        } else {
            return NO;
        }
    }
    else{
        return NO;
    }
}

-(BOOL)goUrlSchemeAction:(NSString*)url {
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // appScheme으로 앱 실행히 호출되며
    // scheme갑에 따른 설정 & 화면이동
    ///////////////////////////////////////////////////////////////////////////////////////
    
    //URLscheme로 호출될경우 자동로그인 설정시 무조건 통신후 이곳으로 처리요청하므로...
    self.isauthing = NO;
    
    
    //소문자화
    url = [Mocha_Util strReplace:KAKAONATIVEAPPKEY replace:@"" string:url];
    url = [Mocha_Util strReplace:KAKAONATIVEAPPKEY2 replace:@"" string:url];
    NSString *lowerurl= [url lowercaseString];
    
    
    
    
    //home URL호출시만 예외처리 url이없거나 home을 가르킬경우 기본 홈탭연결 20131011
    //20160318 parksegun https 일때도 동작하도록 수정
    if(([lowerurl isEqualToString:[NSString stringWithFormat:@"gsshopmobile://web?%@",GSMAINURL]])  || ([lowerurl  isEqualToString:@"gsshopmobile://web?/index.gs"]) || ([lowerurl isEqualToString:@"gsshopmobile://home"]) || ([lowerurl isEqualToString:@"gsshopmobile://home?http://m.gsshop.com/index.gs"]) || ([lowerurl isEqualToString:@"gsshopmobile://home?https://m.gsshop.com/index.gs"]) || ([lowerurl isEqualToString:@"gsshopmobile://home?http://app.gsshop.com/index.gs"]) || ([lowerurl isEqualToString:@"gsshopmobile://home?https://app.gsshop.com/index.gs"]) || ([lowerurl isEqualToString:@""])  )  {
        
        
        
        NSArray *arrPopVC =  [self.mainNVC popToRootViewControllerAnimated:NO];
        for (UIViewController *vc in arrPopVC) {
            NSLog(@"vcvcvcvc = %@",vc);
            if ([vc isKindOfClass:[ResultWebViewController class]]) {
                ResultWebViewController *rvc = (ResultWebViewController *)vc;
                [rvc removeAllObject];
            }
        }
        
        if([self.HMV respondsToSelector:@selector(firstProc)]){
            [ApplicationDelegate setIsTabbarHomeButtonClick_forSideMenu:YES]; //하단 홈버튼 눌림과 같은 동작으로 인식-사이드 매뉴 초기화 안함
            [self.HMV firstProc];
        }
        
        
        
        URLString = nil;
        return NO;
        
    }
    
    
    NSRange ishomestr = [url rangeOfString:@"gsshopmobile://home?" options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
    NSRange isTabId = [url rangeOfString:@"gsshopmobile://TABID?" options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
    if(ishomestr.length != 0 || isTabId.length != 0) {
        
        
        NSMutableString *preurlmutableString;
        preurlmutableString = [NSMutableString stringWithString: url];
        NSLog (@"Original string = %@", preurlmutableString);
        // 앱 실행후 백그라운드 상태에서 딥링크를 통해 들어왔을때, wiselog을 단 한번만 보내기 위한 Flag 설정
        if(isTabId.length > 0) {
            //탭아이디 처리용임
            self.isGsshopmobile_TabIdFlag = YES;
            NSLog (@"goUrlSchemeAction isGsshopmobile_TabIdFlag = YES");
            [preurlmutableString deleteCharactersInRange: isTabId];
        }
        else {
            NSRange tabIdRange = [preurlmutableString rangeOfString:@"tabId="];
            if ((NSNotFound != tabIdRange.location) && tabIdRange.location > 0 ) {
                NSLog (@"goUrlSchemeAction - isGsshopmobile_TabIdFlag YES");
                self.isGsshopmobile_TabIdFlag = YES;
            } else {
                // 로그 확인을 위한 else 문
                NSLog (@"goUrlSchemeAction isGsshopmobile_TabIdFlag = NO");
            }
            [preurlmutableString deleteCharactersInRange: ishomestr];
        }
        
        
        NSLog(@"New string = %@", preurlmutableString);
        NSString *add_schemeurl = [NSString stringWithFormat:@"%@",preurlmutableString];
        
        
        if(add_schemeurl != nil) {
            if([add_schemeurl hasPrefix:@"http"] )
            {
                // nami0342 - URL 인코딩 판단 후 디코딩 처리
                URLString = [Common_Util getURLEndcodingCheck:add_schemeurl];
            }
            else if([add_schemeurl hasPrefix:@"#"] ){
                //홈 섹션 #시퀀스넘버 저장
                URLString = add_schemeurl;
                NSLog(@"  %@",add_schemeurl);
            }
            else {
                //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                URLString = [NSString stringWithFormat:@"%@%@", SERVERURI, add_schemeurl];
            }
            NSLog(@"handleopenurl_URLString_handel = %@",URLString);
            
            //홈 index.gs 페이지가 Resultpage로 뜨는 문제 방어
            if(([URLString isEqualToString:[NSString stringWithFormat:@"%@/index.gs?",SERVERURI]]) || ([URLString isEqualToString:[NSString stringWithFormat:@"%@/index.gs",SERVERURI]])){
                URLString = nil;
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] != nil) {
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PushTGurl"];
                    //                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                
                ////탭바제거
                [self pushchangeSction:0];
                return  NO;
            }
            else {
                
                NSLog(@"URLStringURLString = %@",URLString);
                ///////////////
                // nami0342 - JSON 형태 제거는 외부 링크일 때만 사용 - 내부에서는 이벤트 같은 것을 JSON 형태로 전송하므로 공통으로 처리 불가 예) appjs://
                NSArray *strURLParse = [URLString componentsSeparatedByString:@"?"];
                
                for(int i = 0; i<strURLParse.count; i++)
                {
                    NSArray *arrQueryString = [[strURLParse objectAtIndex:i] componentsSeparatedByString:@"&"];
                    
                    for (int j=0; j < [arrQueryString count]; j++)
                    {
                        NSArray *arrElement = [[arrQueryString objectAtIndex:j] componentsSeparatedByString:@"="];
                        if ([arrElement count] == 2) {
                            
                            // nami0342 - Facebook 추가 파라미터 분리
                            //                            if([[arrElement objectAtIndex:0] isEqualToString:@"al_applink_data"] == YES)
                            //                            {
                            //                                URLString = [URLString stringByReplacingOccurrencesOfString:[arrElement objectAtIndex:1] withString:@""];
                            //                                continue;
                            //                            }
                            
                            // nami0342 - Json 형태일 경우 판단해서 날림. (예) Facebook deep link)
                            if(([[arrElement objectAtIndex:1] rangeOfString:@"{"].location != NSNotFound) ||
                               ([[arrElement objectAtIndex:1] rangeOfString:@"["].location != NSNotFound))
                            {
                                URLString = [URLString stringByReplacingOccurrencesOfString:[arrElement objectAtIndex:1] withString:@""];
                                continue;
                            }
                        }
                    }
                }
                ////////////////
                // nami0342 - Facebook Deferred deep link 추가 파라미터 분리
                NSRange range = [URLString rangeOfString:@"&al_applink_data"];
                if(range.location != NSNotFound)
                {
                    range.length = URLString.length - range.location;
                    URLString = [URLString stringByReplacingCharactersInRange:range withString:@""];
                }
                NSLog(@"**** URL URL ***** : %@", URLString);
                ///////////////
                
                
                
                [[NSUserDefaults standardUserDefaults] setObject:URLString  forKey:@"PushTGurl"];
                //                [[NSUserDefaults standardUserDefaults] synchronize];
                ////탭바제거
                [self pushchangeSction:0];
                
                URLString = nil;
                return NO;
            }
        }
    }
    
    
    
    
    //카테고리 CategorytabShow
    if ([lowerurl  hasPrefix:@"gsshopmobile://category"])
    {
        
        NSRange iscartstr = [url rangeOfString:@"gsshopmobile://category?" options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
        
        if(iscartstr.length != 0)
        {
            NSMutableString *preurlmutableString;
            preurlmutableString = [NSMutableString stringWithString: url];
            NSLog (@"Original string = %@", preurlmutableString);
            [preurlmutableString deleteCharactersInRange: [preurlmutableString rangeOfString: @"gsshopmobile://category?"  options:NSCaseInsensitiveSearch]];
            NSLog(@"New string = %@", preurlmutableString);
            NSString *add_schemeurl = [NSString stringWithFormat:@"%@",preurlmutableString];
            
            
            if(add_schemeurl != nil)
            {
                if([add_schemeurl hasPrefix:@"http"] )
                {
                    // nami0342 - URL 인코딩 판단 후 디코딩 처리
                    URLString = [Common_Util getURLEndcodingCheck:add_schemeurl];
                    //                     self.URLSchemeString = add_schemeurl;
                }
                else
                {
                    //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                    if([add_schemeurl length] == 0)
                    {
                        self.URLSchemeString = SecondURL;
                    }
                    else
                    {
                        self.URLSchemeString = [NSString stringWithFormat:@"%@%@", SERVERURI, add_schemeurl];
                    }
                }
            }
        }
        
        
        UIButton *dd = [[UIButton alloc] init];
        dd.tag = 1;
        ////탭바제거
        [[NSUserDefaults standardUserDefaults] setObject:self.URLSchemeString  forKey:@"PushTGurl"];
        [self pushchangeSction:0];
        
        URLString = nil;
        return NO;
    }
    
    
    //home 외에는 URLSchemeString 세팅
    //search
    if ([lowerurl  hasPrefix:@"gsshopmobile://search"])   {
        
        NSRange issearchstr = [url rangeOfString:@"gsshopmobile://search?" options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
        
        if(issearchstr.length != 0) {
            
            NSMutableString *preurlmutableString;
            preurlmutableString = [NSMutableString stringWithString: url];
            NSLog (@"Original string = %@", preurlmutableString);
            [preurlmutableString deleteCharactersInRange: issearchstr];
            NSLog(@"New string = %@", preurlmutableString);
            NSString *add_schemeurl = [NSString stringWithFormat:@"%@",preurlmutableString];
            
            
            
            if(add_schemeurl != nil) {
                if([add_schemeurl hasPrefix:@"http"] )
                {
                    // nami0342 - URL 인코딩 판단 후 디코딩 처리
                    URLString = [Common_Util getURLEndcodingCheck:add_schemeurl];
                    //                    self.URLSchemeString = add_schemeurl;
                }else if([add_schemeurl hasPrefix:@"ReadyForSearch"] ){
                    //홈탭 검색전용
                    self.URLSchemeString = add_schemeurl;
                }else {
                    //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                    if([add_schemeurl length] == 0) {
                        self.URLSchemeString = nil;
                    }else {
                        self.URLSchemeString = [NSString stringWithFormat:@"%@%@", SERVERURI, add_schemeurl];
                    }
                }
                
            }
        }
        
        
        UIButton *dd = [[UIButton alloc] init];
        dd.tag = 2;
        ////탭바제거
        [[NSUserDefaults standardUserDefaults] setObject:self.URLSchemeString  forKey:@"PushTGurl"];
        [self pushchangeSction:0];
        
        
        URLString = nil;
        return NO;
    }
    
    //스마트카트
    if ([lowerurl  hasPrefix:@"gsshopmobile://cart"])   {
        
        NSRange iscartstr = [url rangeOfString:@"gsshopmobile://cart?" options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
        
        if(iscartstr.length != 0) {
            
            
            NSMutableString *preurlmutableString;
            preurlmutableString = [NSMutableString stringWithString: url];
            NSLog (@"Original string = %@", preurlmutableString);
            [preurlmutableString deleteCharactersInRange: [preurlmutableString rangeOfString: @"gsshopmobile://cart?"  options:NSCaseInsensitiveSearch]];
            NSLog(@"New string = %@", preurlmutableString);
            NSString *add_schemeurl = [NSString stringWithFormat:@"%@",preurlmutableString];
            
            
            if(add_schemeurl != nil) {
                if([add_schemeurl hasPrefix:@"http"] ){
                    // nami0342 - URL 인코딩 판단 후 디코딩 처리
                    URLString = [Common_Util getURLEndcodingCheck:add_schemeurl];
                    //                    self.URLSchemeString = add_schemeurl;
                }else {
                    //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                    if([add_schemeurl length] == 0) {
                        self.URLSchemeString = SMARTCART_URL;
                    }else {
                        self.URLSchemeString = [NSString stringWithFormat:@"%@%@", SERVERURI, add_schemeurl];
                    }
                }
            }
        }
        
        
        UIButton *dd = [[UIButton alloc] init];
        dd.tag = 1;
        ////탭바제거
        [[NSUserDefaults standardUserDefaults] setObject:self.URLSchemeString  forKey:@"PushTGurl"];
        [self pushchangeSction:0];
        
        URLString = nil;
        return NO;
    }
    
    
    //주문배송
    if ([lowerurl  hasPrefix:@"gsshopmobile://order"])   {
        
        NSRange isorderstr = [url rangeOfString:@"gsshopmobile://order?" options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
        
        if(isorderstr.length != 0) {
            
            
            NSMutableString *preurlmutableString;
            preurlmutableString = [NSMutableString stringWithString: url];
            NSLog (@"Original string = %@", preurlmutableString);
            [preurlmutableString deleteCharactersInRange: [preurlmutableString rangeOfString: @"gsshopmobile://order?"  options:NSCaseInsensitiveSearch]];
            NSLog(@"New string = %@", preurlmutableString);
            NSString *add_schemeurl = [NSString stringWithFormat:@"%@",preurlmutableString];
            
            
            if(add_schemeurl != nil) {
                if([add_schemeurl hasPrefix:@"http"] ){
                    // nami0342 - URL 인코딩 판단 후 디코딩 처리
                    URLString = [Common_Util getURLEndcodingCheck:add_schemeurl];
                    //                    self.URLSchemeString = add_schemeurl;
                }else {
                    //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                    if([add_schemeurl length] == 0) {
                        self.URLSchemeString = MYORDER_URL;
                    }else {
                        self.URLSchemeString = [NSString stringWithFormat:@"%@%@", SERVERURI, add_schemeurl];
                    }
                }
                
            }
        }
        
        
        UIButton *dd = [[UIButton alloc] init];
        dd.tag = 1;
        ////탭바제거
        [[NSUserDefaults standardUserDefaults] setObject:self.URLSchemeString  forKey:@"PushTGurl"];
        [self pushchangeSction:0];
        
        URLString = nil;
        return NO;
    }
    
    
    
    //마이
    if ([lowerurl  hasPrefix:@"gsshopmobile://myshop"])   {
        
        NSRange ismyshopstr = [url rangeOfString:@"gsshopmobile://myshop?" options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
        
        if(ismyshopstr.length != 0) {
            
            
            NSMutableString *preurlmutableString;
            preurlmutableString = [NSMutableString stringWithString: url];
            NSLog (@"Original string = %@", preurlmutableString);
            [preurlmutableString deleteCharactersInRange: [preurlmutableString rangeOfString: @"gsshopmobile://myshop?"  options:NSCaseInsensitiveSearch]];
            NSLog(@"New string = %@", preurlmutableString);
            NSString *add_schemeurl = [NSString stringWithFormat:@"%@",preurlmutableString];
            
            
            if(add_schemeurl != nil) {
                if([add_schemeurl hasPrefix:@"http"] ){
                    // nami0342 - URL 인코딩 판단 후 디코딩 처리
                    URLString = [Common_Util getURLEndcodingCheck:add_schemeurl];
                    //                    self.URLSchemeString = add_schemeurl;
                }else {
                    //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                    if([add_schemeurl length] == 0) {
                        self.URLSchemeString = MYSHOP_URL;
                    }else {
                        self.URLSchemeString = [NSString stringWithFormat:@"%@%@", SERVERURI, add_schemeurl];
                    }
                }
                
            }
        }
        
        
        UIButton *dd = [[UIButton alloc] init];
        dd.tag = 2;
        ////탭바제거
        [[NSUserDefaults standardUserDefaults] setObject:self.URLSchemeString  forKey:@"PushTGurl"];
        [self pushchangeSction:0];
        
        URLString = nil;
        return NO;
    }
    
    
    
    
    
    //웹호출 URL 규약에 따라 홈-이후 네비게이션(Resultweb) 페이지에서 url 표출
    if([url  hasPrefix:@"gsshopmobile://web?"]) {
        
        
        NSArray *comp = [url componentsSeparatedByString:@"web?"];
        NSString *add_schemeurl = [comp lastObject];
        
        NSLog(@"%@", add_schemeurl);
        if(add_schemeurl != nil) {
            if([add_schemeurl hasPrefix:@"http"] ){
                // nami0342 - URL 인코딩 판단 후 디코딩 처리
                URLString = [Common_Util getURLEndcodingCheck:add_schemeurl];
                //                URLString = add_schemeurl;
            }else {
                //http:// 등 프로토콜 정의가 없으면 기본도메인 붙여서 절대경로로
                URLString = [NSString stringWithFormat:@"%@%@", SERVERURI, add_schemeurl];
            }
            NSLog(@"handleopenurl_URLString_handel = %@",URLString);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:URLString  forKey:@"PushTGurl"];
            //            [[NSUserDefaults standardUserDefaults] synchronize];
            //방송화면보기 중 수신을 위한 postObserver msg통지
            [[NSNotificationCenter defaultCenter] postNotificationName:@"customovieViewRemove" object:nil userInfo:nil];
            [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
            
            ////탭바제거
            [self pushchangeSction:0];
            
        }
    }
    return YES;
}

-(void)gsCookieRestore{
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // Local Data 값이 저장된 싱글톤 객체에서 Cookie 값을 가져온다
    // 가져온 cookie값을 HTTPStorage에 저장
    ///////////////////////////////////////////////////////////////////////////////////////
    NSData *cookiesdata = LL(GS_SAVECOOKIE);
    if(cookiesdata == nil)
        return;
    
    if([cookiesdata length]) {
        NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        
        
        NSLog(@"cookiescookies = %@",cookies);
        
        for (cookie in cookies) {
            if ([cookie.name isEqualToString:@"lastprdid"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }else if ([cookie.name isEqualToString:@"search"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }else if ([cookie.name isEqualToString:@"mediatype"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }else if ([cookie.name isEqualToString:@"appmediatype"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }else if ([cookie.name isEqualToString:@"pcid"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }else if ([cookie.name isEqualToString:@"wa_pcid"]) {
                NSLog(@"cookie = %@",cookie);
#if SM14 && !APPSTORE
                NSString *devPCID = [[NSUserDefaults standardUserDefaults] objectForKey:@"DEV_USER_INPUT_WA_PCID"];
                if(devPCID && devPCID.length > 0) {
                    NSString *newcookiestring = devPCID;
                    NSMutableDictionary *propscook = [[NSMutableDictionary alloc] initWithDictionary: [cookie properties]];
                    [propscook setObject:newcookiestring forKey:NSHTTPCookieValue];
                    NSHTTPCookie *newcookie = [NSHTTPCookie cookieWithProperties:propscook];
                    [sharedCookies setCookie:newcookie];
                }
                else {
                    //기본값으로 저장함.
                    [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"DEV_USER_INPUT_WA_PCID"];
                    NSLog(@"cookie = %@",cookie);
                    [sharedCookies setCookie:cookie];
                }
#else
                [sharedCookies setCookie:cookie];
#endif
            }else if ([cookie.name isEqualToString:@"view-type"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }else if ([cookie.name isEqualToString:@"quickOrdHide"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }
            else if ([cookie.name isEqualToString:@"martDeliHistoryFlag"]) {
                NSLog(@"cookie = %@",cookie);
                [sharedCookies setCookie:cookie];
            }
        }
    }
    
}

-(void)gsCookieSave{
    
    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *cookies = [sharedCookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    
    NSMutableArray *arrSaveCookie = [[NSMutableArray alloc] init];
    
    
    for (NSHTTPCookie *cookie in cookies) {
        
        if ([cookie.name isEqualToString:@"lastprdid"] ||
            [cookie.name isEqualToString:@"search"] ||
            [cookie.name isEqualToString:@"mediatype"] ||
            [cookie.name isEqualToString:@"appmediatype"] ||
            [cookie.name isEqualToString:@"pcid"] ||
            [cookie.name isEqualToString:@"wa_pcid"] ||
            [cookie.name isEqualToString:@"view-type"] ||
            [cookie.name isEqualToString:@"quickOrdHide"] ||
            [cookie.name isEqualToString:@"martDeliHistoryFlag"]
            ) {
            [arrSaveCookie addObject:cookie];
        }
    }
    
    NSLog(@"arrSaveCookie = %@",arrSaveCookie);
    
    NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:arrSaveCookie];
    
    SL(cookieData, GS_SAVECOOKIE);
}

-(void)touchIDSetting_Popup : (long) code {
    // Could not evaluate policy; look at authError and present an appropriate message to user
    NSLog(@"Required POLICY setting");
    // 알럿추가." 지문 등록이 필요합니다."
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416552")];
    Mocha_Alert *malert;
    if(code == LAErrorTouchIDNotAvailable || code == kLAErrorTouchIDNotAvailable) {
        // 사용자가 Face ID를 등록했으나, 앱 설정에서 거부했거나, 최초 승인에서 거부할 경우
        malert = [[Mocha_Alert alloc] initWithTitle: (IS_IPHONE_X_SERISE ? GSSLocalizedString(@"Info_faceid_available") : GSSLocalizedString(@"Info_fingerprint_setting")) maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"),nil] ];
    }
    else{
        malert = [[Mocha_Alert alloc] initWithTitle: (IS_IPHONE_X_SERISE ? GSSLocalizedString(@"Info_faceid_setting") : GSSLocalizedString(@"Info_fingerprint_setting")) maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"),nil] ];
        
    }
    [ApplicationDelegate.window addSubview:malert];
}


- (void) closeApp{
    exit(1);
}


- (void)setApplicationBadgeNumber:(NSInteger)badgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    
#ifdef __IPHONE_8_0
    // compile with Xcode 6 or higher (iOS SDK >= 8.0)
    
    if(SYSTEM_VERSION_LESS_THAN(@"8.0"))
    {
        application.applicationIconBadgeNumber = badgeNumber;
    }
    else
    {
        if ([self checkNotificationType:UIUserNotificationTypeBadge])
        {
            application.applicationIconBadgeNumber = badgeNumber;
        }
        else
            NSLog(@"access denied for UIUserNotificationTypeBadge");
    }
    
#else
    // compile with Xcode 5 (iOS SDK < 8.0)
    application.applicationIconBadgeNumber = badgeNumber;
    
#endif
}


#ifdef __IPHONE_8_0

- (BOOL)checkNotificationType:(UIUserNotificationType)type
{
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    return (currentSettings.types & type);
}

#endif


// 동적 인트로 이미지 다운로드할 것이 있는지 체크
-(void)checkIntroImage{
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?os=%@&h=%d&w=%d&density=",SERVERURI,GSINTROURL,@"I",(int)APPFULLHEIGHT*(int)[[UIScreen mainScreen] scale],(int)APPFULLWIDTH*(int)[[UIScreen mainScreen] scale]];
    
    NSLog(@"strUrl = %@",strUrl);
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    // 세마포어
//    NSData* tData = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:2.0 error:&error];
    [NSURLSession Async_sendSessionRequest:urlRequest timeout:TIMEOUT_INTERVAL_REQUEST returnBlock:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        
        NSLog(@"urlRequest.allHTTPHeaderFields = %@",urlRequest.allHTTPHeaderFields);
        NSLog(@"response = %@",response);
        NSLog(@"error = %@",error);
        NSDictionary *result = [taskData JSONtoValue];
        
        if (result != nil) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dicSplash = [userDefaults valueForKey:DIC_SPLASH];
            NSLog(@"dicSplash = %@",dicSplash);
            if ([dicSplash objectForKey:@"modiDate"] == nil || [[dicSplash objectForKey:@"modiDate"] doubleValue] != [[result objectForKey:@"modiDate"] doubleValue] || [[dicSplash objectForKey:@"endDate"] doubleValue] != [[result objectForKey:@"endDate"] doubleValue]) {
                NSLog(@"(long)[[dicSplash objectForKey:@modiDate] integerValue] %f",[[dicSplash objectForKey:@"modiDate"] doubleValue]);
                NSLog(@"(long)[[dicSplash objectForKey:@modiDate] integerValue] %f",[[result objectForKey:@"modiDate"] doubleValue]);
                [[DataManager sharedManager] downLoadIntroImages:result isRetry:YES];
            }
            //만료와 상관없이 변경?
            @try {
                [[DataManager sharedManager] introUserInfo:result];
            } @catch (NSException *exception) {
                [exception setValue:@"introUserInfo set result Data cresh!!" forKey:@"dev Message"];
                [ApplicationDelegate SendExceptionLog:exception];
            } @finally {
                
            }
            
        }
    }];
    
    
}

//도큐맨트에 파일 삭제하기/ 존재여부 확인후 삭제
- (BOOL)docFileDelete : (NSString*)tgFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *writableDBPath = [DOCS_DIR stringByAppendingPathComponent:tgFile];
    NSLog(@"file = %@",writableDBPath);
    BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
    
    if (dbexits) //존재하면 삭제
    {
        [fileManager removeItemAtPath:writableDBPath error:NULL];
        NSLog(@"delete complete!!!!!!!!");
    }
    
    return YES;
}

-(BOOL)isthereMochaAlertView{
    for ( UIScrollView* v in  [self.window subviews] )
    {
        if([[NSString stringWithFormat:@"%s",   object_getClassName([v class])] isEqualToString:@"Mocha_Alert"] && v.tag == 555){
            return YES;
        }
    }
    return NO;
}


-(void)onloadingindicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.gactivityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
}



-(void)offloadingindicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.gactivityIndicator performSelectorInBackground:@selector(stopAnimating) withObject:nil];
}

- (NSMutableData*)generateFormDataFromPostDictionary:(NSDictionary*)dict
{
    //NSStringEncoding EUCKR = -2147482590;
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSData class]])
        {
            // handle image data
            NSString *formstring = [NSString stringWithFormat:IMAGE_CONTENT];
            [result appendData: DATA(formstring)];
            [result appendData:value];
        }
        else
        {
            // all non-image fields assumed to be strings
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            [result appendData:DATA(value)];
            NSLog(@"formstring = %@, value = %@",formstring,value);
        }
        
        NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
    
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}




- (NSMutableData*)generateFormVideoDataFromPostDictionary:(NSDictionary*)dict
{
    //NSStringEncoding EUCKR = -2147482590;
    id boundary = @"------------0x0x0x0x0x0x0x0x";
    NSArray* keys = [dict allKeys];
    NSMutableData* result = [NSMutableData data];
    
    for (int i = 0; i < [keys count]; i++)
    {
        id value = [dict valueForKey: [keys objectAtIndex:i]];
        [result appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSData class]])
        {
            // handle image data
            NSString *formstring = [NSString stringWithFormat:MP4_CONTENT];
            [result appendData: DATA(formstring)];
            [result appendData:value];
        }
        else
        {
            // all non-image fields assumed to be strings
            NSString *formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
            [result appendData: DATA(formstring)];
            [result appendData:DATA(value)];
            NSLog(@"formstring = %@, value = %@",formstring,value);
        }
        
        NSString *formstring = @"\r\n";
        [result appendData:DATA(formstring)];
    }
    
    NSString *formstring =[NSString stringWithFormat:@"--%@--\r\n", boundary];
    [result appendData:DATA(formstring)];
    return result;
}


//shawn 2012.07.13 subview의 class가 _UIWebViewScrollView 아닌 경우 scrollstoTop Property = (BOOL)NO
//주의.simulator 테스트시 _UIWebViewScrollView 가 UIScrollView로 나옴
- (void) subViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val{
    
    for (UIView *subview in sview.subviews) {
        if ([subview isKindOfClass:[UIScrollView class]]) {
            //NSLog(@"##presetscroll stat = %i", [(UIScrollView*)subview scrollsToTop] );
            if(([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"_UIWebViewScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UIScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UITableView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"PSCollectionView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"WKScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UICollectionView"])
               )
                
                ((UIScrollView *)subview).scrollsToTop = val;
            
            //                        NSLog(@"change class %@",   [NSString stringWithFormat:@"%s",   object_getClassName(subview)]);
            //                        NSLog(@"#########################aftersetscroll stat = %i", [(UIScrollView*)subview scrollsToTop] );
            
        }
        
        [self subViewchangePropertyForScrollsToTop:subview boolval:val];
    }
}

- (void)onlyProcSecondsubTBViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val{
    
    for (UIView *subview in sview.subviews) {
        
        
        
        
        if ([subview isKindOfClass:[UIScrollView class]]) {
            
            if(([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"_UIWebViewScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UITableView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"WKScrollView"])
               )
                
            {
                if(subview.hidden == NO  )
                {
                    ((UIScrollView *)subview).scrollsToTop = val;
                    NSLog(@"change class %@",   [NSString stringWithFormat:@"%s",   object_getClassName(subview)]);
                    NSLog(@"#########################aftersetscroll stat = %i", [(UIScrollView*)subview scrollsToTop] );
                }
                
            }
        }
    }
}

- (void)onlyProcSecondsubViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val{
    
    for (UIView *subview in sview.subviews) {
        
        if ([subview isKindOfClass:[UIScrollView class]]) {
            
            NSLog(@"subview = %s",object_getClassName(subview));
            
            if(([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"_UIWebViewScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UIScrollView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UITableView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"PSCollectionView"])
               ||
               ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"WKScrollView"])
               )
                
                if(subview.hidden == NO  ) {
                    ((UIScrollView *)subview).scrollsToTop = val;
                }
            
            
        }
        else if (([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"UIWebView"])
                 ||
                 ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"GSWKWebview"])
                 ||
                 ([ [NSString stringWithFormat:@"%s",   object_getClassName(subview)] isEqualToString:@"WKScrollView"])
                 ) {
            
            if(subview.hidden == NO  ) {
                
                ((WKWebView *)subview).scrollView.scrollsToTop = val;
                NSLog(@"subviewsubview = %@ %d",subview,(int)val);
            }
        }
        
    }
}

//딜, 단품 floating 처리
- (BOOL)checkFloatingPurchaseBarWithWebView:(GSWKWebview *)webview url:(NSString *)url {
    // gs 내부 URL 아닌 경우 처리 안함 (단품 페이지에서 페이지 로딩 완료시 이상한 페이지(광고 페이지??) 호출함)
    
    NSString *urlString = NCS(url);
    
    if([urlString hasPrefix:@"http:"] || [urlString hasPrefix:@"https:"]) {
        NSArray *array = [urlString componentsSeparatedByString:@"//"];
        if([array count] < 2) {
            return NO;
        }
        array = [[array objectAtIndex:1] componentsSeparatedByString:@"/"];
        if([[array objectAtIndex:0] rangeOfString:@"gsshop.com"].location == NSNotFound) {
            return NO;
        }
    }
    else {
        if([urlString length] > 0) {
            return NO;
        }
    }
    
    //20181031 웹에서 자동으로 다음 인풋박스에 포커싱을 주는 경우 키보드 활성화 안되어 해당 프로퍼티를 NO로 변경해야함.
    // 조건은 TV회원 로그인 페이지에서만 NO처리(사이드 방지)
    // WK웹뷰에서 아래 코드 동작하지 못함.
    //    if([urlString length] > 0 && [urlString rangeOfString:@"/member/tvLogIn.gs"].location != NSNotFound) {
    //        [GSWKWebview allowDisplayingKeyboardWithoutUserAction];
    //        //webview.keyboardDisplayRequiresUserAction = NO;
    //    }
    //    else {
    //        webview.keyboardDisplayRequiresUserAction = YES;
    //    }
    
    //    NSLog(@"노탭?: %@",webview.noTab ? @"노탭" : @"유탭");
    
    // 딜, 단품 인 경우 탭바 없앰
    // nami0342 - 주문서일 경우 하단 탭바 제거 요청 : 20191105 (안상미m) -> 배포일 연기로 12.18 배포로 진행
    if ([urlString length] > 0 &&
//        ([urlString rangeOfString:@"/deal.gs?"].location != NSNotFound ||
//         [urlString rangeOfString:@"/prd.gs?"].location != NSNotFound ||
////         [urlString rangeOfString:@"ordSht.gs"].location != NSNotFound ||
//         [urlString rangeOfString:@"/ordsht/addOrdSht.gs"].location != NSNotFound ||
//         [urlString rangeOfString:@"/ordsht/ordShtGate.gs"].location != NSNotFound ||
//         [urlString rangeOfString:@"/member/tvLogIn.gs"].location != NSNotFound ||
        ([urlString containsString:@"/deal.gs?"] ||
         [urlString containsString:@"/prd.gs?"] ||
         [urlString containsString:@"tabYn=N"] ||                     // 주문 요청으로 페이지가 아닌 파라미터에 따라 하단 탭바 노출/비 노출 처리 적용
         [urlString containsString:@"/ordsht/addOrdSht.gs"] || 
         [urlString containsString:@"/ordsht/ordShtGate.gs"] ||
         [urlString containsString:@"/member/tvLogIn.gs"] ||
         [urlString containsString:@"/addBasketForward.gs?"] ||
         [urlString containsString:@"about:blank"] ||
         [urlString containsString:@"ordSht.gs"] ||
         
         //about:blank
         //ordSht.gs
         
         //헤더상단 네이티브
         [urlString containsString:PRODUCT_NATIVE_BOTTOM_URL] ||
         [urlString containsString:DEAL_NATIVE_BOTTOM_URL] ||
         [webview noTab] //toapp://notabfullweb 시 적용
         )) {
                webview.lastFrame = webview.frame;
                webview.frame = CGRectMake(webview.frame.origin.x,
                                           webview.frame.origin.y,
                                           webview.frame.size.width,
                                           APPFULLHEIGHT - STATUSBAR_HEIGHT);
        
                self.HMV.tabBarView.hidden = YES;
  
            return YES;
        }
    // 아닌 경우
    else {
        [self.HMV showTabbarView];
        //self.HMV.tabBarView.hidden = NO;
        //in-call 스테이터스바 확장 대응 2016.01 yunsang.jin
        if(APPFULLHEIGHT > APPFULLWIDTH) { //세로
            webview.frame = CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH , APPFULLHEIGHT - STATUSBAR_HEIGHT - APPTABBARHEIGHT);
        }
        else {
            //아무짓도 안하면 잘못된 프레임 설정을 막을수있다. 다른 이슈는 다음에 생각하자....-_-;;
            //webview.frame = CGRectMake(STATUSBAR_HEIGHT, 0, APPFULLHEIGHT - STATUSBAR_HEIGHT - APPTABBARHEIGHT  , APPFULLWIDTH );
        }
        return NO;
    }
}




- (void)SearchviewShow {
    if(self.viewMainSearch != nil) {
        //검색어 노출전 wkwebview에서 shared로 쿠키복사후 노출
        [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
            [self.viewMainSearch openWithAnimated:YES];
        }];
    }
}
- (void)SearchviewHidden{
    if(self.viewMainSearch != nil){
        [self.viewMainSearch closeWithAnimated:YES];
    }
}

- (void)directOrdOptionViewShowURL:(NSString *)strUrl{
    if(self.viewDirectOrdOption != nil){
        [self.viewDirectOrdOption openWithAnimated:YES withUrl:strUrl];
    }
    
}
- (void)directOrdOptionViewHidden{
    if(self.viewDirectOrdOption != nil){
        [self.viewDirectOrdOption closeWithAnimated:YES];
    }
}

// SNS 공유를 위한 팝업 호출(띄우기)
- (void)snsShareViewShow:(NSString *)url ShareImage:(NSString *)imgUrl ShareMessage:(NSString *)message callerType:(NSInteger) type imageSize:(CGSize)size{
    if(self.popupSNSView != nil){
        [self.popupSNSView openWithAnimated:YES withShareUrl:url ShareImage:imgUrl ShareMessage:message callType:type imageSize:size];
    }
}

// SNS 공유를 위한 팝업 닫기
-(void)snsShareViewHidden{
    if(self.popupSNSView != nil){
        [self.popupSNSView closeWithAnimated:YES];
    }
}


// 20160809 parksegun 웹뷰 + 스크립트 타입형 SNS공유
-(void)snsShareWithScriptTypeShow:(id)delegate
{
    NSDictionary *kakaotalk = [NSDictionary dictionaryWithObjectsAndKeys:@"kakaotalk.png",SNSICONURL,@"shareKakaoTalk()",SNSID,@"카카오톡",SNSTITLE, nil];
    NSDictionary *kakaostory = [NSDictionary dictionaryWithObjectsAndKeys:@"kakaostory.png",SNSICONURL,@"shareKakaoStory()",SNSID,@"카카오스토리",SNSTITLE, nil];
    NSDictionary *line = [NSDictionary dictionaryWithObjectsAndKeys:@"line_icon.png",SNSICONURL,@"shareLine()",SNSID,@"라인",SNSTITLE, nil];
    NSDictionary *sms = [NSDictionary dictionaryWithObjectsAndKeys:@"sms.png",SNSICONURL,@"shareSms()",SNSID,@"SMS",SNSTITLE, nil];
    NSDictionary *facebook = [NSDictionary dictionaryWithObjectsAndKeys:@"facebook.png",SNSICONURL,@"shareFacebook()",SNSID,@"페이스북",SNSTITLE, nil];
    NSDictionary *twitter = [NSDictionary dictionaryWithObjectsAndKeys:@"twitter.png",SNSICONURL,@"shareTwitter()",SNSID,@"트위터",SNSTITLE, nil];
    NSDictionary *url = [NSDictionary dictionaryWithObjectsAndKeys:@"url_icon.png",SNSICONURL,@"shareUrl()",SNSID,@"URL복사",SNSTITLE, nil];
    //URL복사
    
    NSArray *arrTt = [NSArray arrayWithObjects:kakaotalk,kakaostory,line,sms,facebook,twitter,url, nil];
    
    
    
    LiveTalkSnsShareView* viewSNS = [[LiveTalkSnsShareView alloc] initWithDelegate:delegate];
    
    [viewSNS setSnsListData:arrTt];
    
    [ApplicationDelegate.window addSubview:viewSNS];
    
}



-(void)goWebView:(NSString *)url{
    
    UINavigationController *navigationController = self.mainNVC;
    
    NSLog(@"nav arr: %d", (int)[navigationController.viewControllers count]  );
    
    
    if ([navigationController isKindOfClass:[UINavigationController class]]) {

        if([navigationController.viewControllers count] > 1  ) {
            
            if([[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] respondsToSelector:@selector(goWebView:)]) {
                
                [[navigationController.viewControllers objectAtIndex:[navigationController.viewControllers count]-1] goWebView:url];
                
            }
            
            
        }else if([navigationController.viewControllers count] == 1  ) {
            if([[navigationController.viewControllers objectAtIndex:0] respondsToSelector:@selector(goWebView:)]) {
                
                [[navigationController.viewControllers objectAtIndex:0] goWebView:url];
            }
            
        }
        else{
            //예외처리 필요함
        }
    }
}


//20160328 parksegun 푸시체크용 팝업 띄우기
- (void)showPushCheckAlert:(NSString*) category
{
    
    if([category isEqualToString:@"MYSETPUSH"])
    {
        //마이설정으로 연결하기 위한 팝업을 띄음
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *msg = GSSLocalizedString(@"app_push_need_confirm_text");
            
            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithCloseBtn:msg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"section_cs_specialcatesetview_btn_set"), nil]];
            malert.fdurationTime = 0.5f;
            malert.tag = 998;
            [self.window addSubview:malert];
            
        });
        
    }
    else if([category isEqualToString:@"SYSSETPUSH"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSString *msg = GSSLocalizedString(@"app_push_need_change_setting_text");
            
            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithCloseBtn:msg maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"section_cs_specialcatesetview_btn_set"), nil]];
            malert.fdurationTime = 0.5f;
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"syssetInfo.png"]];
            
            //0.0 alert 시작됨.. 화면 기준으로 계산
            img.frame = CGRectMake((APPFULLWIDTH/2) - (img.frame.size.width/4), (APPFULLHEIGHT/2)-(img.frame.size.height/4) + 25 , img.frame.size.width/2, img.frame.size.height/2);
            
            //애니메이션(모카와 동일하게...)
            
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            
            animation.duration = malert.fdurationTime;
            animation.values = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.2],
                                [NSNumber numberWithFloat:0.4],
                                [NSNumber numberWithFloat:0.6],
                                [NSNumber numberWithFloat:0.8],
                                [NSNumber numberWithFloat:1.0],
                                nil];
            animation.keyTimes = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.2],
                                  [NSNumber numberWithFloat:0.4],
                                  [NSNumber numberWithFloat:0.6],
                                  [NSNumber numberWithFloat:0.8],
                                  [NSNumber numberWithFloat:1.0],
                                  nil];
            
            [img.layer addAnimation:animation forKey:@"opacityAnimation"];
            
            
            [malert addSubview:img];
            malert.tag = 999;
            [self.window addSubview:malert];
            
            
        });
    }
    else if([category isEqualToString:@"INTROPUSH"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.pushAgreePopupView = [[[NSBundle mainBundle] loadNibNamed:@"PushAgreePopupView" owner:self options:nil] firstObject];
            self.pushAgreePopupView.tag = TAGVIEWLAUNCHOPTIN;
            self.pushAgreePopupView.atarget = self;
            
            [self.window addSubview:self.pushAgreePopupView];
            
            // 항상 최상위여야 한다.
            [self.window bringSubviewToFront:self.infoCommPopupView];
                // 아이패드에서 Landscape상태에서 앱을 실행할떄,
                // bringSubViewToFront를 하고나면
                // frame이 재 조정되는 현상이 발생함.
                // 2020. 02.03 이기원 - 프레임 재설정 코드 추가
//            UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
//            if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
                self.pushAgreePopupView.frame = self.window.frame;
                self.infoCommPopupView.frame = self.window.frame;
//            }
        });
        
    }
}

////탭바에서 이사

- (void)pushchangeSction:(int)idx {
    
    [DataManager sharedManager].selectTab = 0;
    
    NSArray *arrPopVC =  [self.mainNVC popToRootViewControllerAnimated:NO];
    for (UIViewController *vc in arrPopVC) {
        NSLog(@"vcvcvcvc = %@",vc);
        if ([vc isKindOfClass:[ResultWebViewController class]]) {
            ResultWebViewController *rvc = (ResultWebViewController *)vc;
            [rvc removeAllObject];
        }
    }
    
    NSLog(@"Target URL: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"]);
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] hasPrefix:@"#"]){
        if(idx == 0){
            //홈탭이고 URL스키마로 섹션 시퀀스 콜 되었을경우
            //home_main_viewcontroller에서 해당 화면 섹션 전환 처리 처리는 홈탭에서
            NSLog(@"섹션 지정");
            [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONPUSHMOVENOTI object:nil];
        }
        
    }else {
        //안드로이드 PUSHEVENTURL 사용하지 않음 - SERVERURI 로 수정 20140711
        ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:([[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] != nil)?[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"]:SERVERURI];
        [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:result];
    }
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] hasPrefix:@"#"]){
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PushTGurl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    [ApplicationDelegate updateBadgeInfo:[NSNumber numberWithBool:YES]];
    
}

-(BOOL)appjsProcLogin:(NSDictionary*)loginfo{
    
    NSLog(@"appjs login proc: %@",loginfo);
    
    [[DataManager sharedManager] getPushInfo];
    if([[DataManager sharedManager].m_pushData.deviceToken isEqualToString:@""] == NO){
        // 디바이스 토큰이 존재함. 정상적으로 토큰포함 푸시정보전송
        
        
        PushDataRequest *pushRequest = [[PushDataRequest alloc]init];
        [pushRequest sendData:[DataManager sharedManager].m_pushData.deviceToken customNo:[loginfo valueForKey:@"cno"]];
    }
    
    [DataManager sharedManager].loginYN = @"Y";
    ApplicationDelegate.islogin = YES;
    
    //    if ([[[GSDataHubTracker sharedInstance] itscustclass] isEqualToString:@"02"] || [[[GSDataHubTracker sharedInstance] itscustclass] isEqualToString:@"05"]) {
    //
    //        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"NO" forKey:@"isHide"];
    //        [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONHIDEBUTTONSIREN object:nil userInfo:userInfo];
    //    }
    
    
    //PMS아이디세팅
    
    [PMS setUserId:[NSString stringWithFormat:@"%@",[loginfo valueForKey:@"cno"]] ];
    
    [ApplicationDelegate PMSsetUUIDNWapcidNpcid];
    [PMS login];
    
    
    // App boy - Custom event sending
    NSString *strCustNo = [NSString stringWithFormat:@"%@",[loginfo valueForKey:@"cno"]];
    NSString *strUser = NCS(strCustNo);
    
    if ([strUser length] > 0) {
        
        [[Appboy sharedInstance] changeUser:strUser];
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"catvid" andStringValue:strUser];
        
        // nami0342 - Air Bridge 1.0.0
        ABUser *abuser = [[ABUser alloc] init];
        [abuser setID:strCustNo];
        ABUserEvent *abUserEvent = [[ABUserEvent alloc] initWithUser:abuser];
        [abUserEvent sendSignin];
    }
    
    // nami0342 - CSP
    [self CSP_StartWithCustomerID:strUser];
    
    
    if ([NCS(DEVICEUUID) length] > 0) {
        [[Appboy sharedInstance].user setCustomAttributeWithKey:@"uuid" andStringValue:DEVICEUUID];
    }
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"gd"]){
            NSString *strGd = NCS([cookie.value copy]);
            if ([strGd length] > 0) {
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"gd" andStringValue:strGd];
            }
        }else if ([cookie.name isEqualToString:@"yd"]){
            NSString *strYd = NCS([cookie.value copy]);
            if ([strYd length] > 0) {
                [[Appboy sharedInstance].user setCustomAttributeWithKey:@"yd" andStringValue:strYd];
            }
            
        }
    }
    // App boy end
    
    //인증상태 배지정보  가져오기
    [self updateBadgeInfo:[NSNumber numberWithBool:YES]];
    
    //appjs 로그인시 누락되어 있던 회원정보 API 에서 추가로 내려줌에 따라 앱단 처리로직 추가 2016.05.09 yunsang.jin
    if (NCS([loginfo valueForKey:@"cnm"])) {
        [[DataManager sharedManager]setUserName:[loginfo valueForKey:@"cnm"]];
    }
    
    if (NCS([loginfo valueForKey:@"cno"])) {
        [[DataManager sharedManager]setCustomerNo:[loginfo valueForKey:@"cno"]];
    }
    
    if (NCS([loginfo valueForKey:@"cid"])) {
        
        [[DataManager sharedManager] GetLoginData];
        
        [DataManager sharedManager].m_loginData.loginid  = [loginfo valueForKey:@"cid"];
        [DataManager sharedManager].m_loginData.serieskey =  @"";
        [DataManager sharedManager].m_loginData.authtoken = @"";
        [DataManager sharedManager].m_loginData.snsTyp =  @"";
        [DataManager sharedManager].m_loginData.simplelogin = NO;
        [DataManager sharedManager].m_loginData.autologin = NO;
        [DataManager sharedManager].m_loginData.saveid = NO;
        [DataManager saveLoginData];
        
    }
    
    //fingerprint
    //지문로그인이 살아 있다면 제거한다.
    SL(nil,FINGERPRINT_USE_KEY); // 연동해제
    
    [[Common_Util sharedInstance] saveToLocalData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:1]];
    
    return YES;
    
}


-(BOOL)appjsProcLogout:(NSDictionary*)loginfo{
    
    
    NSLog(@"appjs logout proc: %@",loginfo);
    
    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_STOP_SOCKET object:nil];
    
    
    [CooKieDBManager deleteLogoutCookies];
    
    
    
    //자동로그인 정보 및 비밀번호 초기화
    [[DataManager sharedManager] deleteLoginInfo];
    [DataManager sharedManager].loginYN = @"N";
    ApplicationDelegate.islogin = NO;
    //WKWebview Cookie동기화
    [[WKManager sharedManager] wkWebviewSetCookieAll:NO];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"YES" forKey:@"isHide"];
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONHIDEBUTTONSIREN object:nil userInfo:userInfo];
    
    //베스트딜 하단 추천상품 용으로 username 저장 2015.10.12 YS Jin
    [[DataManager sharedManager]setUserName:nil];
    [[DataManager sharedManager]setCustomerNo:nil];
    [ApplicationDelegate PMSsetUUIDNWapcidNpcid];
    //PMS로그아웃
    [PMS logout];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONGOTOPNRELOADNOTI object:[NSNumber numberWithInt:1]];
    [self updateBadgeInfo:[NSNumber numberWithBool:YES]];
    
    return YES;
    
}


//최근본 상품 - 최적화(불필요한 루프 동작 방지)
-(BOOL)checkCookieLastPrd:(NSString *) value  {
    BOOL isExist = NO;
    NSArray *arrPrdList = [value componentsSeparatedByString:@"%25"];
    if ([arrPrdList count] > 0 ) {
        NSString *strLastPrdId = (NSString *)[arrPrdList firstObject];
        if ([NCS(strLastPrdId) length] > 4){
            isExist = YES;
            NSString *strLastPrdImageUrl = [Common_Util productImageUrlWithPrdid:strLastPrdId withType:@"V1"];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:strLastPrdImageUrl forKey:@"imageUrl"];
            [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_LASTPRD_UPDATE object:nil userInfo:userInfo];
        }
        
    }
    
    if (isExist == NO) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"" forKey:@"imageUrl"];
        [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_LASTPRD_UPDATE object:nil userInfo:userInfo];
    }
    return isExist;
}




-(BOOL)checkCookieLastPrd {
    
    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *gsCookies = [sharedCookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    
    BOOL isExist = NO;
    
    //id cookkkkkk = httpCookies.cookies;
    
    for (NSHTTPCookie *cookie in gsCookies) {
        
        if ([cookie.name isEqualToString:@"lastprdid"]) {
            NSLog(@"cookiecookiecookie = %@",cookie)
            NSLog(@"cookie.valuecookie.value = %@",cookie.value);
            
            
            NSArray *arrPrdList = [cookie.value componentsSeparatedByString:@"%25"];
            
            
            NSLog(@"arrPrdList = %@",arrPrdList);
            
            if ([arrPrdList count] > 0 ) {
                
                NSString *strLastPrdId = (NSString *)[arrPrdList firstObject];
                
                if ([NCS(strLastPrdId) length] > 4){
                    isExist = YES;
                    
                    NSString *strLastPrdImageUrl = [Common_Util productImageUrlWithPrdid:strLastPrdId withType:@"V1"];
                    
                    //http://image.gsshop.com/image/18/25/12/18251215_T1.jpg
                    
                    //strLastPrdImageUrl = @"http://image.gsshop.com/mi09/deal/dealno/230/20161024160411516053.jpg";
                    
                    NSLog(@"strLastPrdImageUrlstrLastPrdImageUrl = %@",strLastPrdImageUrl);
                    
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:strLastPrdImageUrl forKey:@"imageUrl"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_LASTPRD_UPDATE object:nil userInfo:userInfo];
                    break;
                }
                
            }
        }
    }
    
    if (isExist == NO) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"" forKey:@"imageUrl"];
        [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_LASTPRD_UPDATE object:nil userInfo:userInfo];
    }
    
    return isExist;
}

- (void)checkWebviewUrlLastPrdShow:(NSString *)requestString loadedUrlString:(NSString *)loadedUrlString{
    
    if (([requestString rangeOfString:@"/deal.gs?"].location == NSNotFound &&
         [requestString rangeOfString:@"/prd.gs?"].location == NSNotFound)){
        
        NSLog(@"requestString1 = %@",requestString);
        NSLog(@"loadedUrlString = %@",loadedUrlString);
        if (([loadedUrlString rangeOfString:@"/deal.gs?"].location != NSNotFound ||
             [loadedUrlString rangeOfString:@"/prd.gs?"].location != NSNotFound)){
            
            NSLog(@"updateBtnBGupdateBtnBGupdateBtnBG");
            
            [self checkCookieLastPrd];
            
        }
        
    }
}

-(void)wiseLogRestRequest:(NSString*)reqURLstr {
    
    [self.currentOperation2 cancel];
    self.currentOperation2 = [ApplicationDelegate.gshop_http_core    gsAPPWISELOGREQPROC:reqURLstr
                                                                            onCompletion:^(NSDictionary *result)  {
                                                                                //reOrder=false 므로 값을 주면 아니되나 서버에서 내려옴 불필요한 값이므로 nil처리
                                                                                result =nil;
                                                                                
                                                                                NSLog(@"wiseLogRestRequest send success url = %@",reqURLstr);
                                                                                
                                                                            }
                                                                                 onError:^(NSError* error) {
                                                                                     NSLog(@"wise log request error %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                                           [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                                 }];
    
    
    
    
    
    
}

-(void)wiseLogRestRequestNoCancel:(NSString*)reqURLstr {

    self.currentOperation2 = [ApplicationDelegate.gshop_http_core    gsAPPWISELOGREQPROC:reqURLstr
                                                                            onCompletion:^(NSDictionary *result)  {
                                                                                //reOrder=false 므로 값을 주면 아니되나 서버에서 내려옴 불필요한 값이므로 nil처리
                                                                                result =nil;
                                                                                
                                                                                NSLog(@"wiseLogRestRequestNoCancel send success url = %@",reqURLstr);
                                                                                
                                                                            }
                                                                                 onError:^(NSError* error) {
                                                                                     NSLog(@"wise log request error %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                                           [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                                 }];
    
    
    
    
    
    
}

-(void)wiseAPPLogRequest:(NSString*)reqURLstr {
    
#if APPSTORE
    
#else
    //[Mocha_ToastMessage toastWithDuration:3.0 andText:reqURLstr inView:ApplicationDelegate.window];
#endif
    
    NSLog(@"dummy weblog requrl = %@", reqURLstr);
    
    @try {
        
        if ([reqURLstr length] == 0) {
            
        }
        else
        {
            //REST REQUEST to WEB URL REQUEST 방식교체
            
            if (wview == nil) {
                
                WKUserContentController *userContentController = [[WKUserContentController alloc] init];
                WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
                config.userContentController = userContentController;
                config.processPool = [[WKManager sharedManager] getGSWKPool];
                wview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
                wview.navigationDelegate = self;
                wview.scrollView.scrollsToTop = NO;
            }
            
            NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
            if (strUserAgent == nil) {
                strUserAgent = [ApplicationDelegate getCustomUserAgent];
            }
            wview.customUserAgent = strUserAgent;
            if ([reqURLstr hasPrefix:@"http"] == false) {
                // kiwon : Swift 파일에서 호출시, WISELOGCOMMONURL를 호출할수 없어서 추가함
                reqURLstr = WISELOGCOMMONURL(reqURLstr);
            }
            NSURL *logURL = [NSURL URLWithString:reqURLstr];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:logURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
            [wview loadRequest:requestObj];
            
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"WebWiseLog Exception at CustomTabBarController : %@", exception);
    }
    
    
    
    
    
}


-(void)wiseCommonLogRequest:(NSString*)reqURLstr {
    
    
    
    NSLog(@"dummy weblog requrl CommonLog = %@", reqURLstr);
    
    @try {
        
        if ([reqURLstr length] == 0) {
            
        }
        else
        {
            //REST REQUEST to WEB URL REQUEST 방식교체
            
            if (wview == nil) {
                
                WKUserContentController *userContentController = [[WKUserContentController alloc] init];
                WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
                config.userContentController = userContentController;
                config.processPool = [[WKManager sharedManager] getGSWKPool];
                wview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
                wview.navigationDelegate = self;
                wview.scrollView.scrollsToTop = NO;
            }
            
            NSURL *logURL = [NSURL URLWithString:reqURLstr];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:logURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
            [wview loadRequest:requestObj];
            
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"WebWiseLog Exception at CustomTabBarController : %@", exception);
    }
    
    
    
    
    
}

-(void)infoCommLawConfirmSend {
    
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];
    
    [post_dict setValue:[Common_Util getSHA256:[NSString stringWithFormat:@"%@_GS",DEVICEUUID]] forKey:@"gsuuid"];
    [post_dict setValue:[UIDevice currentDevice].systemVersion forKey:@"osVersion"];
    [post_dict setValue:@"I" forKey:@"osGB"];
    [post_dict setValue:CURRENTAPPVERSION forKey:@"appVersion"];
    [post_dict setValue:@"03" forKey:@"appGB"];
    [post_dict setValue:@"Y" forKey:@"confirmYN"];
    
    NSLog(@"comm dictionary %%%%%%%% = %@",post_dict);
    
    NSData *postData = [[post_dict jsonEncodedKeyValueString] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"json str %@", [post_dict jsonEncodedKeyValueString]);
    
    // Establish the API request. Use upload vs uploadAndPost for skip tweet
    NSString *baseurl = INFOCOMMLAW_URL;
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    // Submit & retrieve results
    // NSError *error;
    // NSHTTPURLResponse *response;
    NSLog(@"Contacting Server....");
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      if(!result) {
                                          NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
                                          //실패
                                          //1. 다시 띄우지 않음
                                          //2. 데이터 전송 완료 결과 저장 안함.
                                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                          [defaults setObject:INFOCOMMLAW_FLAG_VERSION forKey:INFOCOMMLAW_SHOW];
                                      }
                                      else {
                                          NSLog(@"!!!!!send finished");
                                          NSDictionary *resultj = [result JSONtoValue];
                                          NSString* rj = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"result"]];
                                          
                                          NSLog(@"resultresult =%@",result);
                                          
                                          if([rj isEqualToString:@"S"]) {
                                              //성공
                                              //1. 다시 띄우지 않음
                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                              // 버전을 저장하고 버전이 다를경우 다시 띄울 수 있도록한다.
                                              [defaults setObject:INFOCOMMLAW_FLAG_VERSION forKey:INFOCOMMLAW_SHOW];
                                              //2. 데이터 전송 완료 결과 저장
                                              [defaults setObject:@"Y" forKey:INFOCOMMLAW_DATA_SEND];
                                              //[defaults synchronize];
                                          }
                                          else {
                                              //실패
                                              //1. 다시 띄우지 않음
                                              //2. 데이터 전송 완료 결과 저장 안함.
                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                              [defaults setObject:INFOCOMMLAW_FLAG_VERSION forKey:INFOCOMMLAW_SHOW];
                                          }
                                      }
                                  }];
    [task resume];
    
    /*
     NSOperationQueue *queue = [[NSOperationQueue alloc] init];
     [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
     NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     if(!result) {
     NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
     //실패
     //1. 다시 띄우지 않음
     //2. 데이터 전송 완료 결과 저장 안함.
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:INFOCOMMLAW_FLAG_VERSION forKey:INFOCOMMLAW_SHOW];
     }
     else {
     NSLog(@"!!!!!send finished");
     NSDictionary *resultj = [result JSONtoValue];
     NSString* rj = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"result"]];
     NSLog(@"resultjresultj = %@",resultj);
     
     if([rj isEqualToString:@"S"]) {
     //성공
     //1. 다시 띄우지 않음
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     // 버전을 저장하고 버전이 다를경우 다시 띄울 수 있도록한다.
     [defaults setObject:INFOCOMMLAW_FLAG_VERSION forKey:INFOCOMMLAW_SHOW];
     //2. 데이터 전송 완료 결과 저장
     [defaults setObject:@"Y" forKey:INFOCOMMLAW_DATA_SEND];
     //[defaults synchronize];
     }
     else {
     //실패
     //1. 다시 띄우지 않음
     //2. 데이터 전송 완료 결과 저장 안함.
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:INFOCOMMLAW_FLAG_VERSION forKey:INFOCOMMLAW_SHOW];
     }
     }
     }];
     [queue waitUntilAllOperationsAreFinished];
     */
}

- (NSDictionary*) getCookieForEcid {
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if ([cookie.name isEqualToString:@"ecid"]) {
            NSString *ecid = NCS([cookie.value copy]);
            //양끝의 따옴표 제거
            NSArray *ecidArr = [[ecid stringByReplacingOccurrencesOfString:@"\"" withString:@""] componentsSeparatedByString:@"~"];
            if(ecidArr.count == ecidPairs.count) { // 이미 동일하다면 그냥 끝냄
                return [ecidPairs copy];
            }
            [ecidPairs removeAllObjects];
            for(NSString *pairString in ecidArr) {
                NSArray *pair = [pairString componentsSeparatedByString:@"="];
                if ([pair count] != 2) {
                    continue;
                }
                [ecidPairs setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
            }
            break;
        }
        else {
        }
    }
    return [ecidPairs copy];
}

- (void)showMyOptViewController {
    My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
    [self.mainNVC pushViewControllerMoveInFromBottom:myoptVC];
}

- (NSString *) getCustomUserAgent {
    NSString *interfaceName = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?@"iPhone":@"iPad";
    NSString *systemVersion;
    if([NSProcessInfo processInfo].operatingSystemVersion.patchVersion <= 0) {
        systemVersion = [NSString stringWithFormat:@"%ld_%ld",(long)[NSProcessInfo processInfo].operatingSystemVersion.majorVersion, (long)[NSProcessInfo processInfo].operatingSystemVersion.minorVersion ];
    }
    else {
        systemVersion = [NSString stringWithFormat:@"%ld_%ld_%ld",(long)[NSProcessInfo processInfo].operatingSystemVersion.majorVersion, (long)[NSProcessInfo processInfo].operatingSystemVersion.minorVersion,(long)[NSProcessInfo processInfo].operatingSystemVersion.patchVersion ];
    }
    
    NSString* secretAgent = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16B91",interfaceName,interfaceName,systemVersion ];
    NSString *strUserAgent = [NSString stringWithFormat:@"%@,%@,%@,%@", secretAgent, USERAGENTCUSTOMVERSION, USERAGENTCODE, USERAGENTAPPGB];
    return strUserAgent;
}


#pragma mark - PMS Functions
-(void)PMSsetUUIDNWapcidNpcid {
    
    NSString* wapcidstr =   @"0";
    NSString* pcidstr =   @"0";
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"wa_pcid"]){
            wapcidstr = cookie.value;
        }else if([cookie.name isEqualToString:@"pcid"]){
            pcidstr = cookie.value;
        }
    }

    NSLog(@"pcidstr = %@",pcidstr);
    NSLog(@"wapcidstr = %@",wapcidstr);
    
    [PMS setDeviceUid:[NSString stringWithFormat:@"%@",DEVICEUUID]];
    [PMS setWaPcId:[NSString stringWithFormat:@"%@",wapcidstr]];
    [PMS setPcId:[NSString stringWithFormat:@"%@",pcidstr]];
}


-(void)delayedPMSSetting:(NSTimer *)sender{
    
    NSNumber *numYesOrNo = sender.userInfo;
    BOOL isyes = [numYesOrNo boolValue];
    
    NSLog(@"(int)isyes(int)isyes(int)isyes(int)isyes(int)isyes = %d",(int)isyes);
    //PMS푸시 수신여부 , N 하면 안 옴
    [[AppPushNetworkAPI sharedNetworkAPI] setConfig:isyes];
}

#pragma mark - PMS Delegate

- (BOOL)showPMS {
    return YES;
}
- (void)loginPMS:(BOOL)argResult {
    //
}
- (void)logoutPMS:(BOOL)argResult {
    //
}
- (void)newMessageCount:(int)argCount {
    
}


// kiwon : AppPushMainViewController.m 에 중복선언으로 인한 삭제
/*
#define APNS_MSG_ID_KEY     @"i"
#define APNS_MSG_TYPE_KEY   @"t"
#define APNS_MSG_LINK_KEY   @"l"
#define APNS_KEY            @"aps"
#define APNS_SOUND_KEY      @"sound"
#define APNS_ALERT_KEY      @"alert"
*/
//20150430 더이상 꺼짐 상태에서 수신하는 푸시의 처리를 하단 메서드에서 처리하지 않음 직접처리... by shawn
- (void)interlockPMS:(NSString *)argCode
                data:(NSString *)argData
{
    
    
    NSLog(@" argCode = %@ \n argData = %@", argCode, argData);
    if([argCode isEqualToString:@"home://"]){
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"gsshopmobile://home"]];
    }
    
    
    else {
        
        argCode = [Mocha_Util strReplace:@" " replace:@"" string:argCode];
        
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:argCode]];
        
    }
    
    ////탭바제거
    [self performSelector:@selector(updateBadgeInfo:) withObject:[NSNumber numberWithBool:NO] afterDelay:2.0f];
    
}




- (void)interlockTBTOUCHPMS:(NSString *)argCode
                       data:(NSString *)argData {
    
    NSLog(@"TB셀터치 argCode = %@ \n argData = %@", argCode, argData);
    if([argCode isEqualToString:@"home://"]){
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"gsshopmobile://home"]];
    }else if([argCode hasPrefix:@"gsshopmobile://"]  ){
        
        //[self    goUrlSchemeAction:argCode];
        
        NSString *strGOLink = [argCode stringByReplacingOccurrencesOfString:@"gsshopmobile://home?" withString:@""];
        
        if([[self.mainNVC.viewControllers lastObject] respondsToSelector:@selector(goWebView:)]) {
            
            [[self.mainNVC.viewControllers lastObject] goWebView:strGOLink];
            
        }else{
            ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:strGOLink];
            [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:result];
        }
        
    }
    else {
        
        argCode = [Mocha_Util strReplace:@" " replace:@"" string:argCode];
        
        
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:argCode]];
        
    }
    
    ////탭바제거
    [self performSelector:@selector(updateBadgeInfo:) withObject:[NSNumber numberWithBool:NO] afterDelay:2.0f];
    
    
}

- (void)interlockTouchHeader:(NSString *)argLink
                        data:(NSString *)argData {
    
    NSLog(@"TB헤더 터치 argLink = %@ \n argData = %@", argLink, argData);
    
    if([[self.mainNVC.viewControllers lastObject] respondsToSelector:@selector(goWebView:)]) {
        
        [[self.mainNVC.viewControllers lastObject] goWebView:argLink];
        
    }else{
        ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:argLink];
        [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:result];
    }
    
    
    ////탭바제거
    [self performSelector:@selector(updateBadgeInfo:) withObject:[NSNumber numberWithBool:NO] afterDelay:2.0f];
    
    
}


-(void) pressShowPMSLISTBOX {
    
    [ApplicationDelegate onloadingindicator];
    [PMS showMessageBox];
}



-(int)PMSgetNewMSGCount {
    return [PMS getNewMessageCount];
    
}

#pragma mark - Badge Update Function
- (void)updateBadgeInfo:(NSNumber *)isreconect;
{
    
    
    NSLog(@"isreconect = %d",(int)[isreconect boolValue]);
    
    if([isreconect boolValue] == YES) {
        
        if(self.currentOperation1 != nil){
            [self.currentOperation1 cancel];
        }
        self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsGETBADGEURL:^(NSDictionary *result)  {
            NSLog(@"badgeinfo response %@", result);
            
            //배열관리 - 중요확인
            
            self.strMyShop = [NSString stringWithFormat:@"%d",   [[result objectForKey:@"myshop"] intValue]  ];
            
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.strMyShop forKey:@"myshop"];
            [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_BADGE_UPDATE object:nil userInfo:userInfo];
            
            
        }
                                                                            onError:^(NSError* error) {
                                                                                
                                                                                
                                                                                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"0" forKey:@"myshop"];
                                                                                [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_BADGE_UPDATE object:nil userInfo:userInfo];
                                                                                
                                                                                NSLog(@"error3 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                                                      [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                                                
                                                                                
                                                                            }];
        
        
        
        
        
        
    }
    
}

#pragma mark - Exception log Sending Functions
// nami0342 : Send exception log
- (void) SendExceptionLog:(id)err
{
    if(err == nil)
        return;
    
    
    if([err isKindOfClass:[NSError class]] == YES)
    {
        NSError *error = err;
        // 웹뷰에서 작업 완료 불가 오류 - 웹뷰 로딩중에 다른 URL을 호출할 경우 발생하는 문제.
        if(error.code == -999)
            return;
        
        // toapp 처림 프로그램적으로 프레임로드를 중단할 때 나오는 문제
        if(error.code == 102)
            return;
    }
    
    
    NSLog(@"XXX Exception description : %@", [err localizedDescription]);
    
#if DEBUG
    return;
#endif
    
    
#if APPSTORE
    dispatch_queue_t dqueue = dispatch_queue_create("send_exception_log", NULL);
    dispatch_async(dqueue, ^{
        
        NSMutableString *strDescription = [[NSMutableString alloc] init];
        NSString *strNetwork;
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWWAN )
        {
            strNetwork = @"wifi";
        }
        else if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWWAN)
        {
            strNetwork = @"lte";
        }
        
        
        NSString *strDevice = [UIDevice currentDevice].deviceModelName;
        if([[strDevice lowercaseString] hasPrefix:@"simulator"] == YES)
            return;
        
        
        NSMutableString *mstrPostDatas = [[NSMutableString alloc] init];
        [mstrPostDatas appendFormat:@"%@=%@&", @"app_version", CURRENTAPPVERSION];
        [mstrPostDatas appendFormat:@"%@=%@_%@&", @"customer_id", DEVICEUUID, [DataManager sharedManager].customerNo?[DataManager sharedManager].customerNo:@""];
        [mstrPostDatas appendFormat:@"%@=%@&", @"platform", @"IOS"];
        [mstrPostDatas appendFormat:@"%@=%@&", @"device_model", [UIDevice currentDevice].deviceModelName];
        [mstrPostDatas appendFormat:@"%@=%@&", @"os_version", [UIDevice currentDevice].systemVersion];
        
        
        if([err isKindOfClass:[NSError class]] == YES)
        {
            // Add exception desctription
            [strDescription appendString:[NSString stringWithFormat:@"DESC : %@", [err localizedDescription]]];
            
            if([err userInfo] != nil && [[err userInfo] count] > 0)
            {
                NSDictionary *dicTemp = [err userInfo];
                for(NSString *strKey in [dicTemp allKeys])
                {
                    [strDescription appendFormat:@"%@ = %@\r\n", strKey, [dicTemp objectForKey:strKey]];
                }
            }
            
            [mstrPostDatas appendFormat:@"%@=ios_exception_%@&", @"error_name", [err localizedDescription]];
            [mstrPostDatas appendFormat:@"%@=%@&", @"error_description", strDescription?strDescription:[err localizedFailureReason]];
            
        }
        else if([err isKindOfClass:[NSException class]] == YES)
        {
            NSMutableArray *arCrashSymbols = [NSMutableArray arrayWithArray:[err callStackSymbols]];
            
            // Add exception desctription
            [arCrashSymbols insertObject:[NSString stringWithFormat:@"DESC : %@", [err description]] atIndex:0];
            
            [strDescription appendFormat:@"%@", [arCrashSymbols description]];
            
            [mstrPostDatas appendFormat:@"%@=ios_exception_%@&", @"error_name", [err name]];
            [mstrPostDatas appendFormat:@"%@=%@&", @"error_description", strDescription?strDescription:[err reason]];
        }
        else
        {
            return;
        }
        
        
        [mstrPostDatas appendFormat:@"%@=%@&", @"network_type", strNetwork];
        [mstrPostDatas appendFormat:@"%@=%@", @"ip", @""];
        
        // Send a log to GSShop server if possibled.
        NSString *strURL = [NSString stringWithFormat:@"%@?seq=%@", SERVER_CRASH_LOG, DEVICEUUID];
        NSURL *url = [NSURL URLWithString:strURL];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        
        [urlRequest setHTTPMethod: @"POST"];
        
        
        NSData *postData = [mstrPostDatas dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        [urlRequest setHTTPBody: postData];
        NSError *error;
        NSURLResponse *response;
        NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
        if (!result)
        {
            NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
        }
        else
        {
            NSLog(@"!!!!!Exception log send finished");
        }
    });
#endif
}




// nami0342 : Send exception log
- (void) SendExceptionLog:(id)err msg:(NSString *)str
{
    if(err == nil)
        return;
    
    
    if([err isKindOfClass:[NSError class]] == YES)
    {
        NSError *error = err;
        // 웹뷰에서 작업 완료 불가 오류 - 웹뷰 로딩중에 다른 URL을 호출할 경우 발생하는 문제.
        if(error.code == -999)
            return;
        
        // toapp 처림 프로그램적으로 프레임로드를 중단할 때 나오는 문제
        if(error.code == 102)
            return;
    }
    
    
    NSLog(@"XXX Exception description : %@", [err localizedDescription]);
    
#if DEBUG
    return;
#elif APPSTORE
    dispatch_queue_t dqueue = dispatch_queue_create("send_exception_log", NULL);
    dispatch_async(dqueue, ^{
        
        NSMutableString *strDescription = [[NSMutableString alloc] init];
        NSString *strNetwork;
        
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi)
        {
            strNetwork = @"wifi";
        }
        else if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWWAN)
        {
            strNetwork = @"lte";
        }
        
        
        NSString *strDevice = [UIDevice currentDevice].deviceModelName;
        if([[strDevice lowercaseString] hasPrefix:@"simulator"] == YES)
            return;
        
        
        NSMutableString *mstrPostDatas = [[NSMutableString alloc] init];
        [mstrPostDatas appendFormat:@"%@=%@&", @"app_version", CURRENTAPPVERSION];
        [mstrPostDatas appendFormat:@"%@=%@_%@&", @"customer_id", DEVICEUUID, [DataManager sharedManager].customerNo?[DataManager sharedManager].customerNo:@""];
        [mstrPostDatas appendFormat:@"%@=%@&", @"platform", @"IOS"];
        [mstrPostDatas appendFormat:@"%@=%@&", @"device_model", [UIDevice currentDevice].deviceModelName];
        [mstrPostDatas appendFormat:@"%@=%@&", @"os_version", [UIDevice currentDevice].systemVersion];
        
        
        if([err isKindOfClass:[NSError class]] == YES)
        {
            // Add exception desctription
            [strDescription appendString:[NSString stringWithFormat:@"DESC : %@", [err localizedDescription]]];
            
            if([err userInfo] != nil && [[err userInfo] count] > 0)
            {
                NSDictionary *dicTemp = [err userInfo];
                for(NSString *strKey in [dicTemp allKeys])
                {
                    [strDescription appendFormat:@"%@ = %@\r\n", strKey, [dicTemp objectForKey:strKey]];
                }
            }
            
            [strDescription appendFormat:@"%@ = %@\r\n", @"AutoLogin_Info", str];
            
            [mstrPostDatas appendFormat:@"%@=ios_exception_%@&", @"error_name", [err localizedDescription]];
            [mstrPostDatas appendFormat:@"%@=%@&", @"error_description", strDescription?strDescription:[err localizedFailureReason]];
            
        }
        else if([err isKindOfClass:[NSException class]] == YES)
        {
            NSMutableArray *arCrashSymbols = [NSMutableArray arrayWithArray:[err callStackSymbols]];
            
            // Add exception desctription
            [arCrashSymbols insertObject:[NSString stringWithFormat:@"DESC : %@", [err description]] atIndex:0];
            
            [strDescription appendFormat:@"%@", [arCrashSymbols description]];
            
            [mstrPostDatas appendFormat:@"%@=ios_exception_%@&", @"error_name", [err name]];
            [mstrPostDatas appendFormat:@"%@=%@&", @"error_description", strDescription?strDescription:[err reason]];
        }
        else
        {
            return;
        }
        
        
        [mstrPostDatas appendFormat:@"%@=%@&", @"network_type", strNetwork];
        [mstrPostDatas appendFormat:@"%@=%@", @"ip", @""];
        
        // Send a log to GSShop server if possibled.
        NSString *strURL = [NSString stringWithFormat:@"%@?seq=%@", SERVER_CRASH_LOG, DEVICEUUID];
        NSURL *url = [NSURL URLWithString:strURL];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        
        [urlRequest setHTTPMethod: @"POST"];
        
        
        NSData *postData = [mstrPostDatas dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        [urlRequest setHTTPBody: postData];
        NSError *error;
        NSURLResponse *response;
        NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
        if (!result)
        {
            NSLog(@"Server Error.... %@",[NSString stringWithFormat:@"Submission error: %@", [error localizedDescription]]);
        }
        else
        {
            NSLog(@"!!!!!Exception log send finished");
        }
    });
#endif
}


#pragma mark - Amplitude Functions
- (void) setAmplitudeUserId:(NSString *)userId {
    [[Amplitude instance] setUserId:userId];
}

- (void) setGender:(NSString *)gender{
    AMPIdentify *identify = [[AMPIdentify identify] set:@"gd" value:gender];
    [[Amplitude instance] identify:identify];
}

- (void) setAge:(NSString *)age{
    NSLog("age: %@",age);
    if(NCS(age).length > 0) {
        NSInteger iage = age.integerValue;
        if (iage < 10 || iage > 80 ) { // 10 <= yd <=80
            return;
        }
    }
    
    AMPIdentify *identify = [[AMPIdentify identify] set:@"yd" value:age];
    [[Amplitude instance] identify:identify];
}

// nami0342 - Amplitude set identify. 
- (void) setAmplitudeIdentifyWithSet : (NSString *)setKey value :(NSString *) value
{
    AMPIdentify *idetify = [[AMPIdentify identify] set:setKey value:value];
    [[Amplitude instance] identify:idetify];
}


- (void) setGenderAndAge {
    NSString* gender =   @"";
    NSString* age = @"";
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    NSArray *gsCookies =  [cookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    for (NSHTTPCookie *cookie in gsCookies) {
        if([cookie.name isEqualToString:@"gd"]) {
            gender = cookie.value;
        }
        if([cookie.name isEqualToString:@"yd"]) {
            age = cookie.value;
        }
    }
    AMPIdentify *identify = [[[AMPIdentify identify] set:@"gd" value:gender] set:@"yd" value:age];
    [[Amplitude instance] identify:identify];
}

- (void) setAmplitudeEvent:(NSString *)eventName{
    [[Amplitude instance] logEvent:eventName];
}

- (void) setAmplitudeEventWithProperties:(NSString *)eventName properties:(NSDictionary *)params {
    [[Amplitude instance] logEvent:eventName withEventProperties:params];
}


- (void) setAppBoyEvent:(NSString *)eventName {
    [[Appboy sharedInstance] logCustomEvent:eventName];
}

- (void) setAppBoyEventWithProperties:(NSString *)eventName properties:(NSDictionary *)params {
    [[Appboy sharedInstance] logCustomEvent:eventName withProperties:params];
}


#pragma mark - Conenct Service Platform

- (void) isCNSStatusOK
{
    ///////////////////////////////////////////////////////////////////////////////////////
    // 동작 설명
    //
    // 모바일 라이브톡의 실시간 서버(TCP/IP)의 상태 체크 후 m_LServerBuild에 상태값 저장
    ///////////////////////////////////////////////////////////////////////////////////////
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:CPS_SERVER_STATUS_URL]];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = kMKNetworkKitRequestTimeOutInSeconds;
    config.timeoutIntervalForResource = kMKNetworkKitRequestTimeOutInSeconds;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *taskData, NSURLResponse *response, NSError *error) {
        
        dispatch_semaphore_signal(semaphore);
        
        if (!taskData) {
            //NSLog(@"%@", error);
            self.m_lServerBuild = 0;
            return;
        }
        
        NSDictionary *dic = [taskData JSONtoValue];
        
        NSString *strStatus = [dic objectForKey:@"status"];
        if(NCS(strStatus).length > 0 && [strStatus isEqualToString:@"OK"] == YES)
        {
            NSString *strAppBuild = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            long iAppbuild = strAppBuild.integerValue;
            NSNumber *nServer = [dic objectForKey:@"IOS"];
            long iServerBuild = nServer.longValue;
            if(iAppbuild >= iServerBuild)
            {
                self.m_lServerBuild = iServerBuild;
                return;
            }
            else
            {
                self.m_lServerBuild = 0;
                return;
            }
        }
        
        self.m_lServerBuild = 0;
        return;
        
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}



// nami0342 - CSP : Connect to the CSP Socket Server
- (void) CSP_StartWithCustomerID : (NSString *) strCustNo
{
    
    NSLog(@"❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️");
    
    
    // 버전 체크에서 실패하거나 서버 버전이 더 높을 경우 이 값이 0 이며, 동작 중지.
     if(self.m_lServerBuild == 0)
         return;
    
    
    if(strCustNo == nil || [strCustNo isKindOfClass:[NSString class]] == NO)
    {
        strCustNo = [NSString stringWithFormat:@"%@",[DataManager sharedManager].customerNo];
    }
    
    if(NCS(strCustNo).length == 0) {
        return;
    }
    
    if( NCS(self.strNavigationTabID).length == 0 ){
        return;
    }
    
    
    
    // Set TabId
    //NSString * strTabID = @"54"; //탭아이디를 가지고 온다
    NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:@"GSSHOP", @"A", strCustNo, @"U", NCS(self.strNavigationTabID), @"P", nil];
    
//#if DEBUG
//    NSURL* url = [[NSURL alloc] initWithString:@"http://ec2-52-78-159-230.ap-northeast-2.compute.amazonaws.com:8080"];
//#else
    NSURL* url = [[NSURL alloc] initWithString:@"https://csp.gsshop.com"];
//#endif
    

    
    
    
        
        
       dispatch_async(_dpSerialQueue, ^{
        if(self.m_isGotDisconnectCallback == NO)
        {

            return;
        }
        
        if(self.m_manager != nil && self.m_socket != nil)
        {
            [self CSP_Disconnect];

            return;
        }
    
        
        self.m_manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"connectParams":dicParam, @"forceWebsockets":@YES}];
        self.m_manager.reconnects = NO;
    
        NSString *strNamespace = @"/global";
//        socket = [manager defaultSocket];
        self.m_socket = [self.m_manager socketForNamespace:strNamespace];
        
        // nami0342 - Connect hanlder
        [self.m_socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {

            NSLog(@"😁 socket connected");
            self.m_isGotDisconnectCallback = NO;
            
            // nami0342 - Tab 변경 시 마다 매장 탭 ID 알려주기
            [self CSP_JoinWithTabID:NCS(self.strNavigationTabID)];
        }];
        
        
        // Message listener (Handler)
        [self.m_socket on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];
                NSLog(@"😁 MSG : %@", [dicReceived objectForKey:@"MG"]);
                
                

                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;

                    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.strNavigationTabID, @"navigationId", dicReceived, @"msg", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_SHOW_MESSAGES object:nil userInfo:dicUserInfo];
                }
            }
        }];
        
        // CSP Banner
        [self.m_socket on:@"banner" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"😁 msg received");
            
            if(NCA(data) == YES)
            {
                NSLog(@"❤️ data : %@", data[0]);
                NSMutableDictionary *dicReceived = data[0];
                NSLog(@"😁 Banner : %@", [dicReceived objectForKey:@"I"]);
                
                
                
                if(NCO(dicReceived) == YES)
                {
                    self.m_dicMsg = dicReceived;
                    
                    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:self.strNavigationTabID, @"navigationId", dicReceived, @"msg", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_SHOW_MESSAGES object:nil userInfo:dicUserInfo];
                }
            }
        }];
        
        [self.m_socket on:@"disconnect" callback:^(NSArray * arrdata , SocketAckEmitter * ack) {
            NSLog(@"___________ Socket Manager error : %@", arrdata);
            self.m_isGotDisconnectCallback = YES;
        }];
        
        // Socket connect
        [self.m_socket connect];
        
    });
}



// nami0342 - Send TabID
- (void) CSP_JoinWithTabID : (NSString *) strTabID {
    
    if(self.m_lServerBuild == 0)
        return;
    
    

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_ALL_CLEAR object:nil userInfo:nil];

    
    
    self.strNavigationTabID = strTabID;
    
    
    dispatch_async(_dpSerialQueue, ^{
    
        if(self.m_manager == nil || self.m_socket == nil) {
            [self CSP_StartWithCustomerID:[NSString stringWithFormat:@"%@",[DataManager sharedManager].customerNo]];
            return;
        }
        
        NSDictionary *dicSendData = [NSDictionary dictionaryWithObjectsAndKeys:strTabID, @"P", nil];
        NSArray *arSendData = [NSArray arrayWithObjects:dicSendData, nil];
        
        [self.m_socket emit:@"join" with:arSendData];

    });
}


// nami0342 - Send CSP events.
- (void) CSP_SendEventWithView : (BOOL) isViewed
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        if(self.m_manager == nil || self.m_socket == nil) {
            return;
        }
        
        NSDictionary *dicSendData;
        if(isViewed == YES)
        {
            dicSendData = [NSDictionary dictionaryWithObjectsAndKeys:[self.m_dicMsg objectForKey:@"AID"], @"AID", @"V", @"TP", nil];
        }
        else
        {
            dicSendData = [NSDictionary dictionaryWithObjectsAndKeys:[self.m_dicMsg objectForKey:@"AID"], @"AID", @"C", @"TP", nil];
        }
        NSArray *arSendData = [NSArray arrayWithObjects:dicSendData, nil];
        
        [self.m_socket emit:@"activity" with:arSendData];
    });
}



// nami0342 - Disconnect
- (void) CSP_Disconnect
{
    dispatch_async(_dpSerialQueue, ^{
        if(self.m_manager != nil)
        {
            [self.m_socket disconnect];
            [self.m_manager disconnect];
            self.m_socket = nil;
            self.m_manager = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_ALL_CLEAR object:nil userInfo:nil];
    });
}

#pragma mark - MochaAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    
    //업데이트알럿 - Deprecated
    if(alert.tag == 1) {
        switch (index) {
            case 0:
                NSLog(@"YES");
                break;
            case 1:
                
                NSLog(@"NO");
                exit(1);
                break;
            default:
                break;
        }
    }
    
    //optin
    if(alert.tag == TAGVIEWLAUNCHOPTIN) {
        
        if(index == 0) {
            NSLog(@"YES");
            //20160310 parksegun 수신동의팝업 YES일 경우에맨 시스템 알림 팝업 노출
            [ApplicationDelegate FirstAppsettingWithOptinFlag:YES withResultAlert:NO];
        }
        
    }
    
    //푸시 shawn
    //gurl주석시작
    
    if(alert.tag == 1000) {
        switch (index) {
            case 0:
                NSLog(@"앱보이 푸시알럿창 닫기");
                break;
            case 1:
                
                //방송화면보기 중 수신을 위한 postObserver msg통지
                [[NSNotificationCenter defaultCenter] postNotificationName:@"customovieViewRemove" object:nil userInfo:nil];
                [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
                //보기
                
                if ([NCS(LL(ab_uri)) length] > 0) {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:NCS(LL(ab_uri))]];
                }
                
                break;
            default:
                break;
        }
    }
    
    //gurl주석끝
    
    
    //최신버전 확인 통신 실패 존재Alert
    if(alert.tag == TAGVIEWLAUNCHLATERUPDATE) {
        switch (index) {
            case 0:
                //나중에
                break;
            case 1:
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UPDATENEWVERSIONURL]];
                break;
            default:
                break;
        }
    }
    
    //업데이트- 강제 마켓이동
    if(alert.tag == TAGVIEWLAUNCHFORCEUPDATE) {
        switch (index) {
            case 0:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UPDATENEWVERSIONURL]];
                //강제업데이트가 필요합니다.
                exit(1);
                break;
            default:
                break;
        }
    }
    
    
    
    //통신불능 - 종료
    // nami0342 - 웹으로 보기 추가 
    if(alert.tag == 555) {
        switch (index) {
            case 0:                
                exit(1);
                break;
            case 1:
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
                [NSThread sleepForTimeInterval:1.5f];
                exit(1);
                break;
            default:
                break;
        }
    }
    
    //20160328 parksegun 999는 시스템 푸시설정창으로 이동 998은 마이숍 설정으로 이동
    if(alert.tag == 999)
    {
        switch (index) {
            case 0:
                [Common_Util systemNofificationCenterOpen];
                break;
                
            default:
                break;
        }
        
    }
    else if(alert.tag == 998) // 마이쇼핑 -> 설정하기로 이동
    {
        if(index == 0)
        {
            //3. 설정하기 바로 염
            My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
            UINavigationController *navigationController = nil;
            navigationController = self.mainNVC;
            [navigationController pushViewControllerMoveInFromBottom:myoptVC];
        }
        
    }
    else if(alert.tag == 7) { //지문로그인 유도
        if(index == 0) {
            //다시안보기
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416702")];
            SL(@"YES",INFOFINGERPRINTSUGGEST);
        }
        else {
            //동의 -  지문로그인 활성화
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=416703")];
            if([ApplicationDelegate isCanUseBioAuth]) {
                [[DataManager sharedManager] GetLoginData];
                SL([DataManager sharedManager].m_loginData,FINGERPRINT_USE_KEY);
                SL(@"YES",INFOFINGERPRINTSUGGEST);
            }
            else {                     // 지문을 단말기에 등록하세요.
                //현재 로그인 창이 떠있지 않는다면 새롭게.. 생성후 처리
                [self touchIDSetting_Popup:0];
            }
        }
    }
    
}


#pragma mark - WKWebviewDelegate

-(void)wkSessionSuccess{
    //로그인 또는 로그아웃 될경우 wiseLog용 웹뷰 초기화
    wview.UIDelegate = nil;
    wview.navigationDelegate = nil;
    wview = nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"navigationAction.request.URL.absoluteString = %@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *arrResponseCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@""]];
    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    NSArray *arrSharedCookie = [sharedCookies cookies];
    
    
    for (NSHTTPCookie *cookie in arrResponseCookies) {

        if (cookie !=nil && ([cookie.name length] > 0)) {
            
            NSLog(@"decidePolicyForNavigationResponse cookie.name cookie.name =%@",cookie.name);
            
            for (NSHTTPCookie *deleteCookie in arrSharedCookie) {
                if ([[deleteCookie domain] isEqualToString:[cookie domain]] && [[deleteCookie name] isEqualToString:[cookie name]]) {
                    NSLog(@"WKNavigationResponse delete Cookie = %@",deleteCookie);
                    [sharedCookies deleteCookie:deleteCookie];
                }
            }
            [sharedCookies setCookie:cookie];
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
    NSLog(@"errorerror = %@",error)
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"");
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"webView.URL.absoluteString = %@",webView.URL.absoluteString);
    
    if ([webView isEqual:wviewAppStart]) {

        NSTimeInterval delta = CACurrentMediaTime() - self.loadHTMLStart;
        NSLog(@"wviewAppStart LoadFinish TIME: %f", delta);
        
        [wviewAppStart evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
            if ([NCS(result) length] > 0) {
                NSString *strResult = [NSString stringWithFormat:@"%@",(NSString *)result];
                NSArray *arrResult = [strResult componentsSeparatedByString:@";"];
                
                for (NSInteger i=0; i<[arrResult count]; i++) {
                    
                    NSString *strToSplit = [arrResult objectAtIndex:i];
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
                    
                    NSLog(@"cookie log strKey: %@", strKey);
                    NSLog(@"cookie log strValue: %@", strValue);
                    
                    //appstart는 다썻으니 더이상 사용하지 않도록 처리
                    wviewAppStart.UIDelegate = nil;
                    wviewAppStart.navigationDelegate = nil;
                    wviewAppStart = nil;
                    
                    
                }
            }
            
        }];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    // SSL 인증서 오류 시, 무시하도록 설정
    NSURLCredential * credential = [[NSURLCredential alloc] initWithTrust:[challenge protectionSpace].serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    
    NSError * error = [challenge error];
    if (error != nil) {
        NSString *msg = [NSString stringWithFormat:@"didReceiveAuthenticationChallenge 호출됨. 인증서 오류로 의심됨. %@", error.localizedDescription ] ;
        [self SendExceptionLog:error msg:msg];
    }
}

#pragma mark - |----------------------------------------------------------|

#pragma mark -  Unused Functions


-(void)doneRequest:(NSString *)status
{
    NSLog(@"token comm-result status = %@",status);
}


-(void)timerloadingCheck {
    if(spviewController != nil) {
        //화면처리
        NSLog(@"Network Delay");
        [self loadingDone];
    }
}

-(BOOL)isthereGuideAppView{
    for ( UIView* v in  [self.window subviews] )
    {
        
        if(v.tag == 8888){
            return YES;
        }
        
    }
    return NO;
}

-(void)apppUpdateVersion {
    //업데이트 URL
    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UPDATENEWVERSIONURL]];
}





//오디오 음원재생후  player release
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"melody src release");
}


//(자동) 로그인 이후 쿠키가 정상인지 확인하는 로직
-(BOOL) checkLoginCookie:(BOOL) save {
    NSHTTPCookieStorage *sharedCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [sharedCookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray *cookies = [sharedCookies cookiesForURL:[NSURL URLWithString:@"http://gsshop.com"]];
    
    BOOL isLogin = NO, isEcid = NO;
    for (NSHTTPCookie *cookie in cookies) {
        if( [@"login" isEqualToString:cookie.name] && [@"true" isEqualToString:cookie.value]) {
            if(save == YES) {
                self.loginisLoginCookies = cookie;
            }
            isLogin = YES;
        }
        if( [@"ecid" isEqualToString:cookie.name] && [cookie.value length] > 0) {
            if(save == YES) {
                self.loginEcidCookies = cookie;
            }
            isEcid = YES;
        }
        //둘다있어야 정상 루프 돌다 먼저 만나면 탈출
        if(isLogin && isEcid) {
            return YES;
        }
    }
    //둘다있어야 정상
    if(isLogin && isEcid) {
        return YES;
    }
    else {
        return NO;
    }
}



// nami0342 - 거래 거절 고객일 경우 1회에 한정 수신 거부 전송 - Braze / PMS, 설정도 변경
- (void) SendPushRefuseWhenBlockUserLogin
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strResult = [userDefaults objectForKey:@"CHECK_PUSH_REFUSED_USER_SETTING"];
    
    if([NCS(strResult) length] == 0)
    {
        // 푸시 수신거부 정보 전송.
        [[Appboy sharedInstance].user setPushNotificationSubscriptionType: ABKUnsubscribed];
        
        //PMS푸시 수신여부 , N 하면 안 옴
        //2018.01.03 인터벌 3->1 로 줄임
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(delayedPMSSetting:) userInfo:[NSNumber numberWithBool:NO] repeats:NO];
        
        // 푸시 허용 거부
        [[GSDataHubTracker sharedInstance] NeoCallGTMWithReqURL:@"D_1031" str2:nil str3:nil];
        
        // Save data to local
        [userDefaults setObject:@"N" forKey:GS_PUSH_RECEIVE];
        [userDefaults setValue:@"N" forKey:APPPUSH_DEF_NOTI_FLAG];
        [userDefaults setObject:@"N" forKey:@"CHECK_PUSH_REFUSED_USER_SETTING"];
    }
}



#pragma mark
#pragma mark Appboy InappMessage Delegate
- (ABKInAppMessageDisplayChoice)beforeInAppMessageDisplayed:(ABKInAppMessage *)inAppMessage
{
    
    if(self.isAviableBrazeInAppMessagePopupShow == YES)
    {
        return ABKDisplayInAppMessageNow;
    }
    else
    {
        return ABKDisplayInAppMessageLater;
    }
   
    NSLog(@"👹👹👹👹👹👹 %@", inAppMessage);
    
}
@end

