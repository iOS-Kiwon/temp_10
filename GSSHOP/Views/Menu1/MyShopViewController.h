//
//  MyShopViewController.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 12. 15..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLoginViewController.h"
#import "PopupWebView.h"
#import "PopupAttachView.h"
#import "GSMediaUploader.h"
#import "LiveTalkSnsShareView.h"
//#import "LastPrdCustomTabBarView.h"
#import "GSWKWebview.h"

@interface MyShopViewController : UIViewController <LoginViewCtrlPopDelegate, UIScrollViewDelegate,   GSMediaUploaderDelegate,snsShareViewDelegate,UIPopoverPresentationControllerDelegate,WKNavigationDelegate,WKUIDelegate> {
    AutoLoginViewController *loginView;
    NSString* curRequestString;
    //웹뷰터치 초기 y포인트저장용
    float wv_instant_ypos;
    // nami0342 - 편성표 관련 리로딩
//    BOOL isBoardSchedule;
    
    //하단 탭바 뷰로 생성
    //LastPrdCustomTabBarView *tabBarView;
    NSTimer *timerVCBlocker;
    UIViewController *vcPresented;
    UIViewController *vcLastReturned;
    
    int abNomalCount;
}


@property (nonatomic) AutoLoginViewController* loginView;
@property (nonatomic, strong) GSWKWebview* wview;
@property (nonatomic, strong) NSString* curRequestString;
@property (nonatomic, assign) BOOL curUrlUse; //로그인이후 현재 페이지에서 이동이 일어날것이다.
@property (nonatomic, strong) PopupWebView *popupWebView;
@property (nonatomic, strong) PopupAttachView *popupAttachView;


-(void)goWebView:(NSString *)url;
-(void)callJscriptMethod:(NSString *)mthd;
-(void) firstProc;
-(void)webViewReload;
//- (void) subViewchangePropertyForScrollsToTop:(UIView *)sview boolval:(BOOL)val;

-(void)callPMSMessgaeBox;
//-(void)enablePMSLISTBtn;
//요청 생방송 재생 live
-(void)playrequestLiveVideo:(NSString*)requrl;
//요청 VOD 재생
-(void)playrequestVODVideo:(NSString*)requrl;
//공통영상 재생
-(void)playrequestCommonVideo: (NSString*)requrl;
//20160809 parksegun SNS 공유용 팝업뷰 호출(웹뷰 스크립트 호출 타입)
-(void)showSnsScriptView;
// 로드전 웹뷰를 초기화하고 다시 설정후 url로드함.
-(void) resetWebviewForLoad:(NSURLRequest *) urlRequest;


@end
