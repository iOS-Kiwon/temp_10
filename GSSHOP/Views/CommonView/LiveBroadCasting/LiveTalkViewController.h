//
//  LiveTalkViewController.h
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "LiveTalkPlayer.h"
#import "GSWKWebview.h"

#import "AutoLoginViewController.h"
#import "PopupWebView.h"
#import "PopupAttachView.h"
#import "ResultWebViewController.h"

#import "LiveTalkSnsShareView.h"


@class LiveTalkPlayer;

@interface LiveTalkViewController : UIViewController <WKNavigationDelegate, LoginViewCtrlPopDelegate, talkPlayerViewDelegate, UITextFieldDelegate ,snsShareViewDelegate,GSMediaUploaderDelegate> {
    BOOL isthisLandingMode;
    BOOL isthisLive;
    
    BOOL iskeyboadOBActive;
    IBOutlet UIView *TopTitleView;
    IBOutlet UIView *TopPlayerBGView;
    IBOutlet UIView *InputChattingArea;
    IBOutlet UIButton *btn_chatword;
    
    AutoLoginViewController *loginView;
    
    NSString* pnnum;
    
    NSMutableArray *arrSns;
    BOOL isClose;
    NSTimer *timerEndCheck;
    BOOL isEndBroadCast;
    int abNomalCount;
    
    BOOL isAttachShowAll;
}

@property (nonatomic, weak) id target;

@property (nonatomic,strong) NSString *curRequestString;
@property (nonatomic,strong) PopupWebView *popupWebView;
@property (nonatomic,strong) PopupAttachView *popupAttachView;
@property (nonatomic,strong) NSString *brdinfoStr;
@property (nonatomic,strong) NSDictionary *BCinfoDic;
@property (nonatomic, strong) GSWKWebview *wview;

@property (nonatomic,weak) IBOutlet UIView *viewPhoto;
@property (nonatomic,weak) IBOutlet UIView *viewCamera;
@property (nonatomic,weak) IBOutlet UIView *viewAdd;
@property (nonatomic,weak) IBOutlet UIView *viewSendTalk;
@property (nonatomic,weak) IBOutlet UIView *viewBGchatword;
@property (nonatomic,weak) IBOutlet UITextView *tvChat;
@property (nonatomic,assign) NSInteger intUploadType;

@property (nonatomic,strong) IBOutlet UIView *viewToast;
@property (nonatomic,strong) IBOutlet UIView *viewToastBG;
@property (nonatomic,strong) IBOutlet UILabel *lblToast;

@property (nonatomic,strong) IBOutlet UIView *viewPrivacyToast;
@property (nonatomic,strong) IBOutlet UIView *viewPrivacyToastBG;
@property (nonatomic,strong) IBOutlet UILabel *lblPrivacyToast;

@property (nonatomic,assign) CGFloat heightBottomSafeArea;
@property (nonatomic,assign) BOOL firstShow;

- (id)initWithTarget:(id)sender withBCinfoStr:(NSString *)brddic;
- (void)ProcSyncAfter:(void (^)(void))handler;
- (IBAction)GoBack:(id)sender;
- (void)webViewReload;
- (IBAction)onBtnSearchView:(id)sender;
- (IBAction)goSmartCart:(id)sender;
- (IBAction)btn_regok_Press:(id)sender;
- (void) NalCHatSendData:(NSString*) nalroomnum
                message : (NSString*) msg
            phonenumber :(NSString*)pnum
                enddate :(NSString*) endd;
- (void) showToast:(NSString*)tstring;

-(void)getSnsInfo;
- (void) DrawCartCountstr;

@end
