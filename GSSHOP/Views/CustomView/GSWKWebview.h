//
//  GSWKWebview.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 10. 19..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <Pinterest/Pinterest.h>

#import "URLDefine.h"
#import <NaverThirdPartyLogin/NaverThirdPartyLogin.h>
#import <ContactsUI/ContactsUI.h>
@class WebPrdView;

@protocol WKDecisionDelegate <NSObject>
@optional
-(void)callJscriptMethod:(NSString *)mthd;
-(void)showSnsScriptView;
@end

@interface GSWKWebview : WKWebView <WKUIDelegate,MFMessageComposeViewControllerDelegate,UIScrollViewDelegate, MFMessageComposeViewControllerDelegate,NaverThirdPartyLoginConnectionDelegate,UIGestureRecognizerDelegate, Mocha_AlertDelegate,CNContactPickerDelegate> {
    NSString *selectedImageURL;        // 선택한 이미지 경로
    Pinterest *_pinterest;
    NaverThirdPartyLoginConnection *_thirdPartyLoginConn;
}

- (BOOL)isGSWKDecisionAllowURLString:(NSString *)requestString andNavigationAction:(WKNavigationAction *)navigationAction withTarget:(id)target;

- (NSString *)requestStringChecker:(NSString *)strRequested;

//딜, 단품 floating 처리
@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic, assign) CGRect lastTabBarFrame;
@property (nonatomic, strong) NSString *lastEffectiveURL;
@property (nonatomic, strong) NSString *currentDocumentURL;
@property (nonatomic, assign) CGFloat lastOriginOnWindow;
@property (strong, nonatomic) UIViewController *parentViewController;
@property (nonatomic, assign) BOOL isloginInfo;
@property (nonatomic, assign) BOOL noTab;
@property (nonatomic, assign) BOOL isViewHeaderFirstResponder;
@property (nonatomic, strong) WebPrdView *viewHeader;
@property (nonatomic, strong) NSString *strAddressJavaScript;

//- (void)addHeaderView:(UIView *)viewHeader withFrame:(CGRect)frame;
- (void)addHeaderViewWithResult:(NSDictionary *)dicResult andNavigationDelegate:(id)aDelegate andFrame:(CGRect)frame;
- (void)hideHeaderView;
@end
