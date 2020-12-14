//
//  ResultWebViewController.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 29..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLoginViewController.h"
#import "PopupWebView.h"
#import "PopupAttachView.h"
#import "GSMediaUploader.h"
#import "LiveTalkSnsShareView.h"
//#import "LastPrdCustomTabBarView.h"
#import "GSWKWebview.h"

#define NoTAB 9900 //탭없은 설정값
#define ABNOMALMAX 3 //abNomalCount 최대값

typedef void (^NativeAPI_CompletionBlock)(NSDictionary *dicApiResult);
typedef void (^NativeAPI_ErrorBlock)(NSError *error);

@protocol ResultWebViewDelegate;
@class AppDelegate;
@class WebPrdNaviBarView;
@class WebPrdLoadingView;
@protocol WebPrdNaviBarViewDelegate;

@interface ResultWebViewController : UIViewController<LoginViewCtrlPopDelegate, UIScrollViewDelegate,  UIActionSheetDelegate,GSMediaUploaderDelegate,snsShareViewDelegate,UIPopoverPresentationControllerDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler> {
    NSString *urlString;
    AutoLoginViewController *loginView;
    id <ResultWebViewDelegate> delegate;
    BOOL  firstLoading;
    //웹뷰터치 초기 y포인트저장용
    float wv_instant_ypos;
    //하단 탭바 뷰로 생성
    //LastPrdCustomTabBarView *tabBarView;
    NSTimer *timerVCBlocker;
    UIViewController *vcPresented;
    UIViewController *vcLastReturned;
    NSInteger noTab;
    int abNomalCount; //재시도 횟수 제한
    BOOL isClickedWebPrdView;
    BOOL isShowing; // 현재 뷰가 노출되고 있는지 확인용 willappear = YES, willdisappear = NO
}
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) NSString *curRequestString;
@property (nonatomic, strong)id <ResultWebViewDelegate> delegate;
@property (nonatomic,strong) PopupWebView *popupWebView;
@property (nonatomic,strong) PopupAttachView *popupAttachView;
@property (nonatomic,assign) BOOL ordPass;
@property (nonatomic,strong) GSWKWebview *wview;
@property (nonatomic, assign) BOOL curUrlUse; //로그인이후 현재 페이지에서 이동이 일어날것이다.
@property (nonatomic,assign) BOOL isDealAndPrd; //현재 로딩된 페이지가 딜/단품 여부 확인
@property (nonatomic,assign) CGFloat headerHeight;
@property (nonatomic,strong) NSDictionary *dicHeader;
@property (nonatomic,assign) BOOL isNativePassUrl;
///단품 네이티브 영역 네비게이션바 View
@property (nonatomic, strong) WebPrdNaviBarView *webPrdNaviBarView;
@property (nonatomic, strong)id <WebPrdNaviBarViewDelegate> webPrdNaviBarViewDelegate;
//단품 네이티브 API 호출용
@property (strong, nonatomic) NSURLSessionDataTask *currentOperation;
@property (nonatomic,strong) NSString *typeCode;
//@property (nonatomic, assign) NSInteger     m_RetryCount;

//@property (nonatomic, assign) BOOL isPassFirst; //WKWebview 빽처리 추가로직
//addBasketForward.gs 를 깔고 시작해야하는데 UIWebview 와 달라서 viewWillAppear시점에 addBasketForward.gs를 인지하고
//빽되는 현상이 있어서 이를 강제로 한번 피하기위한 플레그


@property (nonatomic) NSTimeInterval loadHTMLStart;


@property (nonatomic,assign) BOOL isPostRequest;

- (id)initWithUrlString:(NSString *)url;
- (id)initWithUrlStringByNoTab:(NSString *)url;
- (id)initWithUrlString:(NSString *)url methodPost:(BOOL)isPost;

- (void)webViewReload;
- (void)ispResultWeb:(NSString *)url;

//요청 생방송 재생 live
-(void)playrequestLiveVideo:(NSString*)requrl;
//요청 VOD 재생
-(void)playrequestVODVideo:(NSString*)requrl;
//공통 video 재생
-(void)playrequestCommonVideo: (NSString*)requrl;


- (void)callJscriptMethod:(NSString *)mthd;
- (void)showSnsScriptView;
- (void)goWebView:(NSString *)url;
- (void)backFromWebviewHeader;
- (void)homeFromWebviewHeader;
- (void)dealPrdUrlAction:(NSString *) urlString withParam:(NSString*) param loginCheck:(BOOL)isLogin;

//==================================================
// Kiwon : 단품 관련 변수 & 함수들
@property (nonatomic, strong) NSString *jspPrefix;
@property (nonatomic, strong) WebPrdView *viewHeader;
@property (nonatomic, strong) NSLayoutConstraint *topLayoutConstraint;
@property (nonatomic, assign) BOOL isUpdateWebHeight;

-(void)callWebViewHeaderAPI:(NSString *)strCheckUrl  isCookieSync:(BOOL)isSync OnCompletion:(NativeAPI_CompletionBlock)completionBlock onError:(NativeAPI_ErrorBlock)errorBlock;

/// 단품 높이에 따른 웹뷰 높이 업데이트 - javascript
-(void) updateWebHeight:(CGFloat) height;
//==================================================

//애러났을경우 , 배송지 변경시 사용
-(NSString *)reChangeNativeProductURLOnError:(NSString *)strCheck;
//엠플리튜드, mseq 수집
-(void)sendAmplitudeAndMseqWithAction:(NSString *)strAction;
-(void)sendBhrGbnEvent:(NSString *)strEvent andTotalTime:(NSTimeInterval)timeTotal andCurrentTime:(NSTimeInterval)timeCurrent;
-(void)removeAllObject;
@end


@protocol ResultWebViewDelegate <NSObject>
@optional
-(void)moveBack:(NSInteger)backcheck;
@end
