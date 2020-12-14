//
//  AppDelegate.h  
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 7. 18..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//
//결제에 관한 중요사항
//selectTab 은 isp호출전에 저장해두는 각 탭별값으로 0~4 0:홈 4:나의쇼핑

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import "Home_Main_ViewController.h"
#import "MyShopViewController.h"

#import <UserNotifications/UserNotifications.h>

#import "NetCore_GSSHOP_Comm.h"
#import "NetCore_GSSHOP_IMG.h"
#import "NetCore_GTMGSSHOP_Comm.h"

#import "SplashViewController.h"
#import "PushDataRequest.h"
#import "SHActivityIndicatorView.h"

#import "iCarousel.h"

#import "UIView_Custom.h"

#import "URLDefine.h"


//PMS 추가
#import "PMS.h"
#import "AppPushNetworkAPI.h"

#import "MainViewController.h"

//#import <FacebookSDK/FacebookSDK.h>

#import <MOCHA/Mocha_ToastMessage.h>
#import "MainSearchView.h"
#import "DirectOrdOptionView.h"
#import "PopupSNSView.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

#import "InfoCommLawPopupView.h"
#import "PushAgreePopupView.h"

#import "MainNavigationController.h"

#import <AirBridge/AirBridge.h>

#import "WKManager.h"
#import "GSWKWebview.h"

#import <ABKInAppMessageControllerDelegate.h>

@import SocketIO;
//GAnalytics
@import Firebase;

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)




@class Home_Main_ViewController;
@class TAGManager;

typedef enum {
    RESULT_SUCCESS,
    RESULT_FAIL,
    NOT_TARGET
} AUTO_LOGIN;
//자동로그인 처리용.
typedef void (^ResponseResultBlock)(AUTO_LOGIN flag, NSDictionary *data);

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, AVAudioPlayerDelegate, PMSDelegate , UNUserNotificationCenterDelegate,WKNavigationDelegate, ABKInAppMessageControllerDelegate> {
    
    SplashViewController *spviewController;
    
    NSString *URLString;
    NSString *URLSchemeString;
    NSURLSessionDataTask *currentOperation1;
    NSURLSessionDataTask *currentOperation2;
    
    SHActivityIndicatorView *gactivityIndicator;
    
    //인증여부를 앱에서 사용할 전역변수 DataManager sharedManager].loginYN 에서 저장활용할 수 있으나
    //인증창에서 아이디저장 체크해제후 인증 사용자를 위한 휘발성 메모리에 인증최소정보 저장.
    //실제 인증을처리하는부분 = appdelegate, Home_Main_ViewController, AutoLoginViewController
    //자동로그인 data 관리 = sqlite(아이디저장,비밀번호저장,자동로그인여부...) , 하단전역변수는 앱내 인증관리저장용
    
    BOOL islogin;
    //gsTOKENAUTHURL - 중복인증 통신을 피하기 위함
    BOOL isauthing;
    
    BOOL appfirstLoading;
    
    //메세지 박스
    BOOL isdisplaypmsbox;
    
    //WiseLog
    WKWebView *wview;
    
    //START_URL ,UserAgent WiseLog랑 같이쓰려했으나 appstart 가 진행중 wiselog 가 들어올경우 씹힘
    WKWebView *wviewAppStart;
    
    
    //쿠키에서 ecid를 뽑아 구조화 함
    NSMutableDictionary *ecidPairs;// = [NSMutableDictionary dictionary];
    
    // 앱 실행이후 동작해야 하는 URL
    NSMutableArray *lunchAfterActionUrl;
}

@property (nonatomic, strong) Home_Main_ViewController *HMV;
@property (nonatomic, strong) NSString *URLSchemeString;
@property (nonatomic) BOOL appfirstLoading;
@property (nonatomic, strong) NSString* serverAppvername;
@property (nonatomic, strong) NSString* serverAppvercode;
@property (nonatomic, assign) BOOL islogin;
@property (nonatomic, assign) BOOL isauthing;
@property (nonatomic, assign) BOOL isdisplaypmsbox;
@property (nonatomic, assign) BOOL isDeeplinkPrdDeal;

// 앱 실행이후 동작해야 하는 URL
@property (nonatomic, strong) NSMutableArray *lunchAfterActionUrl;


@property (nonatomic, assign) BOOL isTabbarHomeButtonClick_forSideMenu; //하단 탭바 홈버튼을 눌렀는지 체크 : 사이드 메뉴 갱신 처리 비교를 위해

@property (nonatomic, strong) SHActivityIndicatorView *gactivityIndicator;
@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet MainViewController *gsshopmainViewController;
@property (nonatomic, strong) IBOutlet MainNavigationController *mainNVC;
@property (strong, nonatomic) NetCore_GSSHOP_Comm *gshop_http_core;
@property (strong, nonatomic) NetCore_GSSHOP_IMG *gsshop_img_core;
@property (nonatomic, strong) SplashViewController *spviewController;
@property (nonatomic, assign) BOOL activeApp;
@property (nonatomic, assign) BOOL isBackGround;
@property (strong, nonatomic) NSURLSessionDataTask *currentOperation1;
@property (strong, nonatomic) NSURLSessionDataTask *currentOperation2;
@property (strong, nonatomic) NSURLSessionDataTask *currentOpLogin;

@property (nonatomic,strong) MainSearchView *viewMainSearch;
@property (nonatomic,strong) DirectOrdOptionView *viewDirectOrdOption;

@property (nonatomic,assign) BOOL isTvShopLivePlaying;
@property (nonatomic,assign) BOOL isTodayRecommendLivePlaying;

@property (nonatomic,strong) PopupSNSView *popupSNSView;
@property (nonatomic, readwrite) BOOL isPromotionPopup;                     // nami0342 - 프로모션 팝업이 호출되었는지 확인

@property (nonatomic,strong) InfoCommLawPopupView *infoCommPopupView;
@property (nonatomic,strong) PushAgreePopupView *pushAgreePopupView;

@property (nonatomic, assign) BOOL isSideMenuOnTop;

@property (nonatomic, strong) NSString *strMyShop;

@property (nonatomic, assign) BOOL isOutofService;      // nami0342 : 공사중
@property (strong, nonatomic) NSMutableDictionary *objectCSP;
@property (readwrite) dispatch_queue_t dpSerialQueue;

@property (nonatomic) NSTimeInterval loadHTMLStart;
@property (nonatomic, strong) NSString *groupCode;
@property (nonatomic, strong) NSString *uGradeValue; //등급값
@property (nonatomic, assign) BOOL isShowGsFreshTopView;                // kiwon - GSFresh매장 상단 새벽배송뷰 노출되었는지 확인
@property (nonatomic, assign) BOOL isActivateGsFreshTopView;            // kiwon - GSFresh매장 상단 새벽배송뷰의 인터렉션이 동작하였는지 확인.
@property (nonatomic, assign) BOOL isShowVodTooltipView;            // VOD매장 툴팁 노출되었는지 확인 - 앱켤때 마다 노출
@property (nonatomic, assign) NSString  *m_strApptimize;
@property (nonatomic, strong) NSString  *strLastOpenUrl;

// nami0342 - Myshop network down view check
@property (nonatomic, strong) UIView *vMyShopNetworkDownView;

@property (nonatomic, assign) BOOL isAviableBrazeInAppMessagePopupShow;


- (void)loadingDone;
- (void)timerloadingCheck;
//- (UIView*)GuideFlickingView;
//- (void)GuideAddFlickingView;
- (void)closeApp;
- (void)apppUpdateVersion;
- (BOOL)docFileDelete : (NSString*)tgFile;
- (BOOL)isthereMochaAlertView;
- (BOOL)isthereGuideAppView;
- (BOOL)goUrlSchemeAction:(NSString*)url;
- (void)onloadingindicator;
- (void)offloadingindicator;


//PMS SDK 리스트박스 화면표출
- (void) pressShowPMSLISTBOX;
- (int)PMSgetNewMSGCount;

-(void)FirstAppsettingWithOptinFlag:(BOOL)isyes withResultAlert:(BOOL)isalerttype;
-(void)ShowPushSettingToast;

//Google Analytics
//GA 화면 트래킹
- (void)GAsendLog:(NSString*)ltype tname:(NSString*)targetname;
//GA UIAction 이벤트 트래킹

//GA User Timings 트래킹
- (void)GAUiTimingWithCategorysendLog:(NSString*)catelabel   ttimeval:(NSNumber*)ttime withName:(NSString*)namestr withLabel:(NSString*)lbelstr;



//GTM UIAction 이벤트 트래킹   ==//GA UIAction 이벤트 트래킹 대응됩니다.
- (void)GTMsendLog:(NSString*)Category withAction:(NSString*)Action withLabel:(NSString*)Label;
//GTM 구매 이벤트 트래킹
-(void)GTMsendPurchaseLog:(NSDictionary*)Action withProducts:(NSArray*)Products;

//GTM ScreenName 이벤트 트래킹
- (void)GTMscreenOpenSendLog:(NSString*)ScrName;

//MAT Logging 회원가입
- (void)MobileAppTrackerSendLogMemberRegistration:(NSDictionary*)jstrdic;
//MAT Logging Add Cart, Purchase
- (void)MobileAppTrackerSendLogCartAndPurchase:(NSString*)CnP withDic:(NSDictionary*)jstrdic;
// FB DPA Logging View - 상품보기
- (void) MobileAppTrackerSendLogView:(NSDictionary *) jstrdic;

- (void)subViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val;
- (void)onlyProcSecondsubTBViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val;
- (void)onlyProcSecondsubViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val;


//딜, 단품 floating 처리
- (BOOL)checkFloatingPurchaseBarWithWebView:(GSWKWebview *)webview url:(NSString *)url;
- (void)PMSsetUUIDNWapcidNpcid;
- (NSMutableData*)generateFormDataFromPostDictionary:(NSDictionary*)dict;
- (NSMutableData*)generateFormVideoDataFromPostDictionary:(NSDictionary*)dict;

- (void)SearchviewShow;
- (void)SearchviewHidden;

- (void)directOrdOptionViewShowURL:(NSString *)strUrl;
- (void)directOrdOptionViewHidden;

- (void)showPushCheckAlert:(NSString*) category;

//20160715 parksegun SNS 공유 기능 Native 개발 // callType = 1:숏방 etc: 미정의 (솟방일때 mseq동작) //사이즈 추가
- (void)snsShareViewShow:(NSString *)url ShareImage:(NSString *)imgUrl ShareMessage:(NSString *)message callerType:(NSInteger) type imageSize:(CGSize)size;
- (void)snsShareViewHidden;

// 20160809 parksegun 웹뷰 + 스크립트 타입형 SNS공유
-(void)snsShareWithScriptTypeShow:(id)delegate;

- (void)pushchangeSction:(int)idx;
- (void)updateBadgeInfo:(NSNumber *)isreconect;

- (void)wiseLogRestRequest:(NSString*)reqURLstr;
- (void)wiseAPPLogRequest:(NSString*)reqURLstr;
-(void)wiseCommonLogRequest:(NSString*)reqURLstr;
-(void)wiseLogRestRequestNoCancel:(NSString*)reqURLstr;

- (BOOL)appjsProcLogin:(NSDictionary*)loginfo;
- (BOOL)appjsProcLogout:(NSDictionary*)loginfo;

- (BOOL)checkCookieLastPrd;
-(BOOL)checkCookieLastPrd:(NSString *) value;//최근본상품 최적화 코드

- (void)checkWebviewUrlLastPrdShow:(NSString *)requestString loadedUrlString:(NSString *)loadedUrlString;

// nami0342 : App Exception log
- (void) SendExceptionLog:(id)err;
//
- (void) SendExceptionLog:(id)err msg:(NSString *)str;

// parksegun : 20170307 정보통신법 개정안
- (void) infoCommLawConfirmSend;

// parksegun : 20170309 수신동의 팝업 변경

// parkseugn : 20170720 Amplitude 설정
- (void) setAmplitudeUserId:(NSString *)userId;
- (void) setGenderAndAge;
- (void) setAmplitudeEvent:(NSString *)eventName;
- (void) setAmplitudeEventWithProperties:(NSString *)eventName properties:(NSDictionary *)params;
- (void) setGender:(NSString *)gender;
- (void) setAge:(NSString *)age;
- (void) setAmplitudeIdentifyWithSet : (NSString *)setKey value :(NSString *) value;                // Set identify

// parksegun : 20180305 AppBoy 설정
- (void) setAppBoyEvent:(NSString *)eventName;
- (void) setAppBoyEventWithProperties:(NSString *)eventName properties:(NSDictionary *)params;

//Bio Auth , Finger Print ,Face Auth
- (BOOL) isCanUseBioAuth;

- (void)appdelegateBaseProcess;
- (BOOL)checkVersion;
- (void)callProcess;

//2018/07/24 배포때 자동로그인 여부를 파라메터로 받기로 결정
- (void)autoLoginProcess:(BOOL)isAutoLogin;

- (void)touchIDSetting_Popup : (long) code;

//설정창 호출
- (void)showMyOptViewController;

//- (void)callImageSearch;//이미지 검색 호출

/// User-Agent 설정
- (NSString *) getCustomUserAgent;
    


// nami0342 - Connect Service Platform
// nami0342 - CSP
@property (nonatomic, strong) SocketManager  *m_manager;
@property (nonatomic, strong) SocketIOClient *m_socket;
@property (nonatomic, strong) UIButton      *m_btnCSPIcon;
@property (nonatomic, strong) UIButton      *m_btnMessageNLink;
//@property (nonatomic, strong) UIImageView   *m_imgArrow;
@property (nonatomic, strong) NSDictionary  *m_dicMsg;
@property (nonatomic, readwrite) BOOL       m_isAnimating;
@property (nonatomic, readwrite) BOOL       m_isGotDisconnectCallback;
@property (nonatomic, readwrite) long       m_lServerBuild;
@property (nonatomic, strong) NSString *strNavigationTabID;
@property (nonatomic, readwrite) BOOL       isGsshopmobile_TabIdFlag; //gsshopmobile://TABID?
@property (nonatomic, strong) NSHTTPCookie  *loginEcidCookies;
@property (nonatomic, strong) NSHTTPCookie  *loginisLoginCookies;

- (void) CSP_StartWithCustomerID : (NSString *) strCustNo;  // 고객번호와 함께 CSP 시작
- (void) CSP_JoinWithTabID : (NSString *) strTabID;         // 탭 이동 시마다 탭 아이디 전달
- (void) CSP_SendEventWithView : (BOOL) isViewed;                   // 뷰, 클릭 이벤트
//- (void) CSP_initUI;                                        // Init UI
//- (void) CSP_ShowMessage : (NSDictionary *) dicMsg;         // 메시지 처리
//- (void) CSP_ShowIcon : (NSDictionary *) dicType;           // 아이콘 처리
//- (void) CSP_clickIcon : (id) sender;
//- (void) CSP_WebLink : (id)sender;                          // Message & link리처리
- (void) CSP_Disconnect;                                    // 접속 종료

// 쿠키에서 ecid 값을 뽑아온다.
- (NSDictionary*) getCookieForEcid;

//로그인 쿠키 체크 및 save==YES이면 ecid값을 저장함.
- (BOOL) checkLoginCookie:(BOOL) save;

//자동로그인 프로세스
- (void) Launch_autoLoginProcess:(NSString*)param process:(ResponseResultBlock) completionBlock;

// 거래 거절 고객에 대한 푸시 수신거부 1회 처리
- (void) SendPushRefuseWhenBlockUserLogin;
@end


