//
//  LastPrdCustomTabBarView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 12. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "LastPrdCustomTabBarView.h"

#import "CustomBadge.h"
#import "AppDelegate.h"
#import "URLDefine.h"
#import "ResultWebViewController.h"
#import "DataManager.h"
#import "Common_Util.h"

#import "UINavigationController+Category.h"
#import "PushData.h"
#import "PushDataRequest.h"
#import "LoginData.h"

#import "AutoLoginViewController.h"
#import "MyShopViewController.h"

#import <SVGKit/SVGKit.h>


@implementation LastPrdCustomTabBarView
@synthesize naviCtrl;
@synthesize netwarnv;

@synthesize currentOperation1;

@synthesize lblTabHome = _lblTabHome;
@synthesize lblTabCate = _lblTabCate;
@synthesize lblTabMyShop = _lblTabMyShop;
@synthesize lblTabWish = _lblTabWish;
@synthesize lblTabHistory = _lblTabHistory;

@synthesize imgTabHome = _imgTabHome;
@synthesize imgTabCate = _imgTabCate;
@synthesize imgTabMyShop = _imgTabMyShop;
@synthesize imgTabWish = _imgTabWish;
@synthesize imgTabHistory = _imgTabHistory;
@synthesize imgLastPrd =_imgLastPrd;

@synthesize viewTabMyShop = _viewTabMyShop;
@synthesize btnLastClickPosition = _btnLastClickPosition;

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setBackgroundColor:[Mocha_Util getColor:@"F9F9F9"]];
    
    self.lblTabHome.text = GSSLocalizedString(@"menu_home");
    self.lblTabCate.text = GSSLocalizedString(@"menu_category");
    self.lblTabMyShop.text = GSSLocalizedString(@"menu_myshop");;
    self.lblTabWish.text = GSSLocalizedString(@"menu_wish");;
    self.lblTabHistory.text = GSSLocalizedString(@"menu_history");;

    self.imgLastPrd.layer.cornerRadius = 14.0;
    self.imgLastPrd.layer.shouldRasterize = YES;
    self.imgLastPrd.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.imgLastPrd.clipsToBounds = YES;
    
    [self updateBtnBG];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(badgeDrawingProc:)
                                                 name:BOTTOM_TABBAR_BADGE_UPDATE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(lastPrdDrawingProc:)
                                                 name:BOTTOM_TABBAR_LASTPRD_UPDATE
                                               object:nil];
    
    [ApplicationDelegate checkCookieLastPrd];
    //[self badgeDrawingProc:nil];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(badgeDrawingProc:) userInfo:nil repeats:NO];
}

-(void)dealloc{
    NSLog(@"deallocdeallocdealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//탭관련 주의사항   0 1 2 3 4정상
- (IBAction)selectTabMenuSction:(id)sender {
    
    self.btnLastClickPosition = sender;
    
    // nami0342 - Remove net check view
    [self removeNetworkCheckView];
    [self updateBtnBG];
    
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    
    
    if([((UIButton *)sender) tag] == 0)
    {
        //20160107 wiseLog 더비 페이지 추가 하단탭바 홈버튼은 A00000에서 398049로 변경됨.
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=398049")];
    
    }else if([((UIButton *)sender) tag] == 1) {
        
        //201701 햄거버 개편하면서 카테고리 클릭시 레스트 통신 추가
        //[ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=398050")];
            
    }
    
    //마이샵,찜,최근본상품 은 URL 속에있는 mseq 만 수집
    
    
    UINavigationController * navigationController = ApplicationDelegate.mainNVC;
    
    
    
    if ([((UIButton *)sender) tag] == 0) {
        [ApplicationDelegate setIsTabbarHomeButtonClick_forSideMenu:YES]; //탭바 홈 눌림 체크
        [DataManager sharedManager].lastSideViewController = nil;
        
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            NSArray *arrPopVC =  [navigationController popToRootViewControllerAnimated:NO];
            for (UIViewController *vc in arrPopVC) {
                NSLog(@"vcvcvcvc = %@",vc);
                if ([vc isKindOfClass:[ResultWebViewController class]]) {
                    ResultWebViewController *rvc = (ResultWebViewController *)vc;
                    [rvc removeAllObject];
                }
            }
            
            [[navigationController.viewControllers objectAtIndex:0] firstProc];
            
            
            
        }
        
        
        [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if ([((UIButton *)sender) tag] == 1) {
        [DataManager sharedManager].lastSideViewController = nil;
        
        //20200728 parksegun 웹 카테고리로 전환
        ResultWebViewController *resultWebView = nil;
        NSString *strGoUrl = nil;
        if ([[navigationController.viewControllers lastObject] isKindOfClass:[ResultWebViewController class]]) {
            resultWebView = (ResultWebViewController *)[navigationController.viewControllers lastObject];
        }
        
        if([self netcheck] == YES) {
            if (resultWebView !=nil && [resultWebView.wview.URL.absoluteString hasPrefix:CATEGORY_URL] ) {
                return;
            }
            
            strGoUrl = [NSString stringWithFormat:@"%@398050", CATEGORY_URL];
            if (resultWebView !=nil) {
                [resultWebView goWebView:strGoUrl];
            }
            else {
                resultWebView = [[ResultWebViewController alloc]initWithUrlString:strGoUrl];
                [navigationController pushViewControllerMoveInFromBottom:resultWebView];
            }
        }
        
        return;
    }
    
    if ([((UIButton *)sender) tag] == 2 || [((UIButton *)sender) tag] == 3 || [((UIButton *)sender) tag] == 4) {
        
        ResultWebViewController *resultWebView = nil;
        MyShopViewController *myShopWebView = nil;

        if ([[navigationController.viewControllers lastObject] isKindOfClass:[ResultWebViewController class]]) {
            
            resultWebView = (ResultWebViewController *)[navigationController.viewControllers lastObject];
        }else if ([[navigationController.viewControllers lastObject] isKindOfClass:[MyShopViewController class]]) {
            myShopWebView = (MyShopViewController *)[navigationController.viewControllers lastObject];
        }
        
        
        
        NSString *strGoUrl = nil;
        if ([((UIButton *)sender) tag] == 2) {
            
            if([self netcheck] == YES)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[Mocha_Util  getCurrentDate:NO] forKey:@"myshopbadgeDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                ApplicationDelegate.strMyShop = @"0";
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"0" forKey:@"myshop"];
                [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_BADGE_UPDATE object:nil userInfo:userInfo];
                
            
                BOOL isFindMyShop = NO;
                
                
                for (NSInteger i=0; i<[navigationController.viewControllers count]; i++) {
                    if ([[navigationController.viewControllers objectAtIndex:i] isKindOfClass:[MyShopViewController class]]) {
                        NSLog(@"[navigationController.viewControllers objectAtIndex:i] = %@",[navigationController.viewControllers objectAtIndex:i]);
                        myShopWebView = [navigationController.viewControllers objectAtIndex:i];
                        isFindMyShop = YES;
                    }
                    
                    if (isFindMyShop == YES && [[navigationController.viewControllers objectAtIndex:i] isEqual:[DataManager sharedManager].lastSideViewController]) {
                        [DataManager sharedManager].lastSideViewController = nil;
                    }
                }
                
                if (myShopWebView !=nil) {
                    [myShopWebView firstProc];
                    [navigationController popToViewController:myShopWebView animated:YES];
                }else{
                    myShopWebView = [[MyShopViewController alloc] initWithNibName:@"MyShopViewController" bundle:nil];
                    [myShopWebView firstProc];
                    [navigationController pushViewControllerMoveInFromBottom:myShopWebView];
                }
            }
        }else if ([((UIButton *)sender) tag] == 3 || [((UIButton *)sender) tag] == 4){
            
            if([self netcheck] == YES)
            {
                if ([((UIButton *)sender) tag] == 3){
                    if (resultWebView !=nil && [resultWebView.wview.URL.absoluteString isEqualToString:WISH_URL]) {
                        return;
                    }
                    
                    if (myShopWebView !=nil && [myShopWebView.wview.URL.absoluteString isEqualToString:WISH_URL]) {
                        return;
                    }
                    
                    strGoUrl = WISH_URL;
                    
                }else if ([((UIButton *)sender) tag] == 4){
                    
                    if (resultWebView !=nil && [resultWebView.wview.URL.absoluteString isEqualToString:HISTORY_URL]) {
                        return;
                    }
                    
                    if (myShopWebView !=nil && [myShopWebView.wview.URL.absoluteString isEqualToString:HISTORY_URL]) {
                        return;
                    }
                    
                    
                    strGoUrl = HISTORY_URL;
                }
                
                
                if (resultWebView !=nil) {
                    
                    [resultWebView goWebView:strGoUrl];
                
                }else if (myShopWebView !=nil) {
                    
                    [myShopWebView goWebView:strGoUrl];
                    
                }else{
                    resultWebView = [[ResultWebViewController alloc]initWithUrlString:strGoUrl];
                    [navigationController pushViewControllerMoveInFromBottom:resultWebView];
                }
            }
        }
    }
    
    [ApplicationDelegate updateBadgeInfo:[NSNumber numberWithBool:NO]];
}



-(void)updateBtnBG {
    
    NSString *strImageHistory_Off = nil;
    
    if(isLastPrdExist == YES) {
        strImageHistory_Off = @"tabbar_ring_history";
        self.imgLastPrd.hidden = NO;
    }else{
        strImageHistory_Off = @"tabbar_ic_history";
        self.imgLastPrd.hidden = YES;
    }
    
    self.lblTabHome.textColor = [Mocha_Util getColor:@"444444"];
    self.lblTabCate.textColor = [Mocha_Util getColor:@"444444"];
    self.lblTabMyShop.textColor = [Mocha_Util getColor:@"444444"];
    self.lblTabWish.textColor = [Mocha_Util getColor:@"444444"];
    self.lblTabHistory.textColor = [Mocha_Util getColor:@"444444"];
    
    NSString *imagePathHome = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_home" ofType:@"svg"];
    SVGKImage *svgImageHome = [SVGKImage imageWithContentsOfFile:imagePathHome];
    self.imgTabHome.image = svgImageHome.UIImage;
    
    NSString *imagePathCate = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_cate" ofType:@"svg"];
    SVGKImage *svgImageCate = [SVGKImage imageWithContentsOfFile:imagePathCate];
    self.imgTabCate.image = svgImageCate.UIImage;
    
    NSString *imagePathMy = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_my" ofType:@"svg"];
    SVGKImage *svgImageMy = [SVGKImage imageWithContentsOfFile:imagePathMy];
    self.imgTabMyShop.image = svgImageMy.UIImage;
    
    NSString *imagePathWish = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_wish" ofType:@"svg"];
    SVGKImage *svgImageWish = [SVGKImage imageWithContentsOfFile:imagePathWish];
    self.imgTabWish.image = svgImageWish.UIImage;
    
    NSString *imagePathHistory = [[NSBundle mainBundle] pathForResource:strImageHistory_Off ofType:@"svg"];
    SVGKImage *svgImageHistory = [SVGKImage imageWithContentsOfFile:imagePathHistory];
    self.imgTabHistory.image = svgImageHistory.UIImage;
    
}

-(IBAction)onBtnPressTab:(id)sender{
    
    NSInteger num = [((UIButton *)sender) tag];
    
    NSString *strImageHistory_On = nil;
    
    if(isLastPrdExist == YES) {
        strImageHistory_On = @"tabbar_ring_history_on";
        self.imgLastPrd.hidden = NO;
    }else{
        strImageHistory_On = @"tabbar_ic_history_on";
        self.imgLastPrd.hidden = YES;
    }

    
    if (num == 0) {
        NSString *imagePathHome = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_home_on" ofType:@"svg"];
        SVGKImage *svgImageHome = [SVGKImage imageWithContentsOfFile:imagePathHome];
        self.imgTabHome.image =  self.imgTabHome.image = svgImageHome.UIImage;
    }else if (num == 1){
        NSString *imagePathCate = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_cate_on" ofType:@"svg"];
        SVGKImage *svgImageCate = [SVGKImage imageWithContentsOfFile:imagePathCate];
        self.imgTabCate.image =  self.imgTabCate.image = svgImageCate.UIImage;
    }else if (num == 2){
        NSString *imagePathMy = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_my_on" ofType:@"svg"];
        SVGKImage *svgImageMy = [SVGKImage imageWithContentsOfFile:imagePathMy];
        self.imgTabMyShop.image =  self.imgTabMyShop.image = svgImageMy.UIImage;
    }else if (num == 3){
        NSString *imagePathWish = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_wish_on" ofType:@"svg"];
        SVGKImage *svgImageWish = [SVGKImage imageWithContentsOfFile:imagePathWish];
        self.imgTabWish.image =  self.imgTabWish.image = svgImageWish.UIImage;
    }else if (num == 4){
        NSString *imagePathHistory = [[NSBundle mainBundle] pathForResource:strImageHistory_On ofType:@"svg"];
        SVGKImage *svgImageHistory = [SVGKImage imageWithContentsOfFile:imagePathHistory];
        self.imgTabHistory.image = self.imgTabHistory.image = svgImageHistory.UIImage;
    }
            
    
    
}


- (IBAction) DragOutside:(id)sender
{
    NSInteger num = [((UIButton *)sender) tag];
    
    NSString *strImageHistory = nil;

    if(isLastPrdExist == YES) {
        strImageHistory = @"tabbar_ring_history";
        self.imgLastPrd.hidden = NO;
    }else{
        strImageHistory = @"tabbar_ic_history";
        self.imgLastPrd.hidden = YES;
    }

    
    if (num == 0) {
        NSString *imagePathHome = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_home" ofType:@"svg"];
        SVGKImage *svgImageHome = [SVGKImage imageWithContentsOfFile:imagePathHome];
        self.imgTabHome.image =  self.imgTabHome.image = svgImageHome.UIImage;
    }else if (num == 1){
        NSString *imagePathCate = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_cate" ofType:@"svg"];
        SVGKImage *svgImageCate = [SVGKImage imageWithContentsOfFile:imagePathCate];
        self.imgTabCate.image =  self.imgTabCate.image = svgImageCate.UIImage;
    }else if (num == 2){
        NSString *imagePathMy = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_my" ofType:@"svg"];
        SVGKImage *svgImageMy = [SVGKImage imageWithContentsOfFile:imagePathMy];
        self.imgTabMyShop.image =  self.imgTabMyShop.image = svgImageMy.UIImage;
    }else if (num == 3){
        NSString *imagePathWish = [[NSBundle mainBundle] pathForResource:@"tabbar_ic_wish" ofType:@"svg"];
        SVGKImage *svgImageWish = [SVGKImage imageWithContentsOfFile:imagePathWish];
        self.imgTabWish.image =  self.imgTabWish.image = svgImageWish.UIImage;
    }else if (num == 4){
        NSString *imagePathHistory = [[NSBundle mainBundle] pathForResource:strImageHistory ofType:@"svg"];
        SVGKImage *svgImageHistory = [SVGKImage imageWithContentsOfFile:imagePathHistory];
        self.imgTabHistory.image = self.imgTabHistory.image = svgImageHistory.UIImage;
    }
    
}



-(void)lastPrdDrawingProc:(NSNotification*) notification{
 
    NSString *strLastPrdImageUrl = NCS([[notification userInfo] objectForKey:@"imageUrl"]);
    
    NSLog(@"strLastPrdImageUrl = %@",strLastPrdImageUrl);
    
    isLastPrdExist = ([strLastPrdImageUrl length] > 0)?YES:NO;
    
    if (isLastPrdExist) {
        [ImageDownManager blockImageDownWithURL:strLastPrdImageUrl isForce:NO useMemory:YES responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isCache, NSError *error) {
            
            if(error == nil  && [strLastPrdImageUrl isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isCache)
                {
                    self.imgLastPrd.image = fetchedImage;
                    
                }
                else
                {
                    self.imgLastPrd.alpha = 0;
                    self.imgLastPrd.image = fetchedImage;
                    
                    
                    
                    
                    [UIView animateWithDuration:0.1f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         
                                         self.imgLastPrd.alpha = 1;
                                         
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }];
                }

                });
                                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imgLastPrd.image = nil;
                });
                
                NSLog(@"error = %@ , strLastPrdImageUrl = %@ , strInputURL = %@",error,strLastPrdImageUrl,strInputURL);
                
            }
            
        }];

    }
    
    
    
    [self updateBtnBG];
    
    
}


-(void)badgeDrawingProc:(NSNotification*) notification {
    
    if (badgeMyShop != nil) {
        //뱃지 icon 일괄삭제
        [badgeMyShop removeFromSuperview];
        badgeMyShop = nil;
        NSLog(@"bdg remove!");
        
    }
    
    NSString *strMyShop = ApplicationDelegate.strMyShop;
    
    
    
    // nami0342 - Main Thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        //NSLog(@"myshop: %@ , myorder: %@", myshop, order);
        
        
        //마이쇼핑
        if( ( ![Mocha_Util strContain:@"null" srcstring:strMyShop])  && (![strMyShop isEqualToString:@"0"]) && (![[defaults objectForKey:@"myshopbadgeDate"] isEqualToString:[Mocha_Util  getCurrentDate:NO]])){
            
            //NSString *conString3 = [NSString stringWithFormat:@"N"];
            
            
            badgeMyShop = [[UIView alloc] initWithFrame:CGRectMake(self.imgTabMyShop.frame.origin.x + 24.0, 9.0, 6.0, 6.0)]; //[CustomBadge customBadgeWithString:conString3];
            badgeMyShop.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:31.0/255.0 blue:96.0/255.0 alpha:1.0];
            badgeMyShop.layer.cornerRadius = 3.0;
            badgeMyShop.layer.shouldRasterize = YES;
            badgeMyShop.layer.rasterizationScale = [UIScreen mainScreen].scale;
            badgeMyShop.clipsToBounds = YES;
            
            //int badgepos = (int)(self.imgTabMyShop.frame.origin.x + self.imgTabMyShop.frame.size.width/2);
            //20160104 마이 쇼핑 위치 보정 -> 20160105 다시 원상 복구
            //[badgeMyShop setFrame:CGRectMake(badgepos+3, 2, badgeMyShop.frame.size.width, badgeMyShop.frame.size.height)];
            
            
            //badgeMyShop.alpha = 1.0f;
            [self.viewTabMyShop insertSubview:badgeMyShop aboveSubview:self.imgTabMyShop];
            
            [self.viewTabMyShop layoutIfNeeded];
            
            NSLog(@"customBadge3 = %@",badgeMyShop);
            
            NSLog(@"self.viewTabMyShop.subviews = %@",self.viewTabMyShop.subviews);
            
            
        }
    });
}


-(BOOL)netcheck {
    
    if([NetworkManager.shared currentReachabilityStatus] == NetworkReachabilityStatusNotReachable)
    {
        [self removeNetworkCheckView];
        self.netwarnv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT-APPTABBARHEIGHT)];
        
        self.netwarnv.backgroundColor = [UIColor whiteColor];
        [self.netwarnv addSubview:[self RefreshGuideView]];
        [ApplicationDelegate.window addSubview:self.netwarnv];
        ApplicationDelegate.vMyShopNetworkDownView = self.netwarnv;
        
        return NO;
    }else {
        [self removeNetworkCheckView];
    }
    
    return YES;
}


- (void) removeNetworkCheckView
{
    if (ApplicationDelegate.vMyShopNetworkDownView != nil) {
        [ApplicationDelegate.vMyShopNetworkDownView removeFromSuperview];
        ApplicationDelegate.vMyShopNetworkDownView = nil;
    }
    
    UIView *checkView = [ApplicationDelegate.window viewWithTag:TBREFRESHBTNVIEW_TAG];
    if(checkView != nil)
    {
        [checkView removeFromSuperview];
        checkView = nil;
        [ApplicationDelegate.window setNeedsDisplay];
    }
}


-(UIView*)RefreshGuideView {
    
    UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    [containView setCenter:CGPointMake(ApplicationDelegate.window.center.x, ApplicationDelegate.window.center.y + 50)];
    containView.backgroundColor= [UIColor whiteColor];
    containView.tag = TBREFRESHBTNVIEW_TAG;
    //새로고침아이콘
    UIImageView* loadingimgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Network_error_icon.png"]];
    [loadingimgView setFrame:CGRectMake(150-37, 40, 75, 88)];
    [containView addSubview:loadingimgView];
    
    
    UILabel* gmentLabel = [[UILabel alloc] init];
    gmentLabel.text = [NSString stringWithFormat:@"%@", @"데이터 연결이 원활하지 않습니다."];
    gmentLabel.textAlignment = NSTextAlignmentCenter;
    gmentLabel.font = [UIFont boldSystemFontOfSize:17];
    gmentLabel.backgroundColor = [UIColor clearColor];
    gmentLabel.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.64] ;
    gmentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [gmentLabel setFrame:CGRectMake(25, 147, 250, 24)];
    [containView addSubview:gmentLabel];
    UILabel* gmentLabel1 = [[UILabel alloc] init];
    gmentLabel1.text = [NSString stringWithFormat:@"%@", @"잠시 후 다시 시도해 주시기 바랍니다."];
    gmentLabel1.textAlignment = NSTextAlignmentCenter;
    gmentLabel1.font = [UIFont boldSystemFontOfSize:14];
    gmentLabel1.backgroundColor = [UIColor clearColor];
    gmentLabel1.textColor = [[Mocha_Util getColor:@"111111"] colorWithAlphaComponent:0.48] ;
    gmentLabel1.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [gmentLabel1 setFrame:CGRectMake(25, 175, 250, 20)];
    [containView addSubview:gmentLabel1];
    
    //새로고침 버튼
    UIButton* cbtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn1 setFrame:CGRectMake(containView.frame.size.width/2 - 85,205,70,32)];
    [cbtn1 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn1.backgroundColor = [UIColor whiteColor];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateNormal];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn1 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn1 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn1.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn1.layer.cornerRadius = 4.0f;
    [cbtn1.layer setMasksToBounds:NO];
    cbtn1.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn1.layer.shadowRadius = 0.0;
    cbtn1.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn1.layer.borderWidth = 1;
    cbtn1.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn1.tag = 1;
    [containView addSubview:cbtn1];
    
    // nami0342 - [웹으로 보기] 버튼 추가
    UIButton* cbtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [cbtn2 setFrame:CGRectMake(containView.frame.size.width/2 -7,205,85,32)];
    [cbtn2 addTarget:self action:@selector(ActionBtnContentRefresh:) forControlEvents:UIControlEventTouchUpInside];
    cbtn2.backgroundColor = [UIColor whiteColor];
    [cbtn2 setTitle:GSSLocalizedString(@"View_on_the_web_text")  forState:UIControlStateNormal];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateNormal];
    [cbtn2 setTitle:GSSLocalizedString(@"sectionview_refresh")  forState:UIControlStateHighlighted];
    [cbtn2 setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateHighlighted];
    cbtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    cbtn2.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    cbtn2.layer.cornerRadius = 4.0f;
    
    [cbtn2.layer setMasksToBounds:NO];
    cbtn2.layer.shadowOffset = CGSizeMake(0, 0);
    cbtn2.layer.shadowRadius = 0.0;
    cbtn2.layer.borderColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    cbtn2.layer.borderWidth = 1;
    cbtn2.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleRightMargin;
    cbtn2.tag = 2;
    [containView addSubview:cbtn2];
    
    return containView;
}


//버튼 전용
-(void)ActionBtnContentRefresh:(id)sender {
    [ApplicationDelegate onloadingindicator];
    
    if(sender == nil)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *btnTemp = (UIButton *)sender;
        
        if(btnTemp.tag == 1)
        {
            [self removeNetworkCheckView];
            [self selectTabMenuSction:self.btnLastClickPosition];
        }
        else if(btnTemp.tag == 2)
        {
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
    });
}

@end
