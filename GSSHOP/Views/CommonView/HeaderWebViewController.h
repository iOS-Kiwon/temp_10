//
//  HeaderWebViewController
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 29..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLoginViewController.h"
#import "GSWKWebview.h"
#import "PopupWebView.h"
#import "PopupAttachView.h"
#import "GSMediaUploader.h"
#import "LiveTalkSnsShareView.h"
//#import "LastPrdCustomTabBarView.h"

@protocol ResultWebViewDelegate;
@class AppDelegate;


@interface HeaderWebViewController : UIViewController<WKNavigationDelegate, LoginViewCtrlPopDelegate, UIScrollViewDelegate,  GSMediaUploaderDelegate,snsShareViewDelegate,UIPopoverPresentationControllerDelegate> {
    NSString *urlString;
    AutoLoginViewController *loginView;
    GSWKWebview *wview;
    id <ResultWebViewDelegate> delegate;
    BOOL  firstLoading;
    //웹뷰터치 초기 y포인트저장용
    float wv_instant_ypos;
    //하단 탭바 뷰로 생성
    //LastPrdCustomTabBarView *tabBarView;
    NSTimer *timerVCBlocker;
    UIViewController *vcPresented;
    UIViewController *vcLastReturned;
    int abNomalCount;
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

- (id)initWithUrlString:(NSString *)url withString:(NSString *)title;
- (void)webViewReload;
- (void)ispResultWeb:(NSString *)url;
- (void)goWebView:(NSString *)url;
- (void)callJscriptMethod:(NSString *)mthd;

//요청 생방송 재생 live
-(void)playrequestLiveVideo:(NSString*)requrl;
//요청 VOD 재생
-(void)playrequestVODVideo:(NSString*)requrl;
//공통 video 재생
-(void)playrequestCommonVideo: (NSString*)requrl;
//20160809 parksegun SNS 공유용 팝업뷰 호출(웹뷰 스크립트 호출 타입)
-(void)showSnsScriptView;
@end

//
//@protocol ResultWebViewDelegate <NSObject>
//@optional
//-(void)moveBack:(NSInteger)backcheck;
//@end
