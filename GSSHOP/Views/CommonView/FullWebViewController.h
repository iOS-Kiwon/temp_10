//
//  FullWebViewController.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 11. 26..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AutoLoginViewController.h"
#import "GSWKWebview.h"

//
#import "PopupWebView.h"


@class AppDelegate;
@class Home_Main_ViewController;

@interface FullWebViewController : UIViewController<WKNavigationDelegate, LoginViewCtrlPopDelegate, UIScrollViewDelegate> {
    
    NSString *urlString;
    NSString *curRequestString;
    AutoLoginViewController *loginView;
    BOOL  firstLoading;
    //웹뷰터치 초기 y포인트저장용
    float wv_instant_ypos;
    int abNomalCount;
    
}
@property (nonatomic,weak) id target;
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic) AutoLoginViewController *loginView;
@property (nonatomic,strong) NSString *curRequestString;
@property (nonatomic) NSInteger backBtnCheck;
@property (nonatomic,strong) PopupWebView *popupWebView;
@property (nonatomic,strong) GSWKWebview *wview;
- (id)initWithUrlString:(id)gtarget tgurl:(NSString *)url;
- (void)webViewReload;
- (void) ispResultWeb:(NSString *)url;
- (void)catchNotiCloseEvent;

//요청 생방송 재생 live
- (void)playrequestLiveVideo:(NSString*)requrl;
//요청 VOD 재생
- (void)playrequestVODVideo:(NSString*)requrl;
//공통영상 재생
- (void)playrequestCommonVideo: (NSString*)requrl;


@end
