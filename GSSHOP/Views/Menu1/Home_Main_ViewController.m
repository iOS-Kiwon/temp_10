//
//  Home_Main_ViewController.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 9. 10..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "Home_Main_ViewController.h"
#import "URLDefine.h"
#import "DataManager.h"
#import "LoginData.h"
#import "AppDelegate.h"

// App boy
#import <Appboy_iOS_SDK/AppboyKit.h>
#import <Appboy_iOS_SDK/ABKPushUtils.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PushData.h"
#import "FullWebViewController.h"
#import "Mocha_MPViewController.h"
#import "LatelySearchData.h"
#import "Common_Util.h"
#import "URLParser.h"
#import "NSData+MD5.h"
#import <GoogleTagManager/GoogleTagManager.h>
#import "MainSearchView.h"
#import "LiveTalkViewController.h"
#import "SectionTBViewController.h"
#import "NSTFCListTBViewController.h"
#import "NTCListTBViewController.h"
#import "TDCLiveTBViewController.h"
#import "FXCListTBViewController.h"
#import "SListTBViewController.h"
#import "SUPListTableViewController.h"
#import "VODListTableViewController.h"
#import "SectionView+SLIST.h"

// Air Bridge
#import <AirBridge/ABEcommerceEvent.h>
#import <AirBridge/AirBridge.h>


// MobileLive
#import "MobileLiveViewController.h"
#import <mach/mach.h>

// app url 정보 저장
NSString *FAVORITE_CRE_URL;
NSString *TV_LIVE_URL;
NSString *TVSHOP_LIVE_URL;
NSString *TVSHOP_DATA_URL;
NSString *TVSHOP_SALEINFO_URL;
NSString *BESTRCMDYN;
NSString *BESTRCMDURL;
//홈메인 듀얼용 신규 규격
NSString *HOME_MAIN_TVSHOP_LIVE_URL;
NSString *HOME_MAIN_TVSHOP_DATA_URL;
//모바일 라이브 갱신용 추가
NSString *HOME_MAIN_MOBILE_LIVE_URL;

//날방 URL
NSString *NALBANG_LIVE_URL;
//좌 네비게이션 딕
NSDictionary *LEFTNAVIGATION_DIC;

//헤더상단 네이티브
NSString *PRD_NATIVE_YN = @"N";

//UI controll position define
#define kTopSearchBarHeight 84 // + (IS_IPHONE_X_SERISE ? 30 : 0)
#define kTopBarHeight 0
//카루셀은 1px 추가되므로 height 45에서 1을 뺸~44
#define kTopCarouselHeight 44
//cart badge tag
#define kCARTBADGECOUNTERVIEWTAG 333
//하단탭바 터치관련정의
#define radians(degrees) degrees * M_PI / 90
#define CATEGORY_TAB_COUNT 1


typedef enum  {
    COMMENTHOLDERLABEL,
    COMMENTSEARCHTEXT
} SEARCHQTEXTTYPE;

@interface Home_Main_ViewController ()

//현재 탭의 섹션 정보 저장
@property (nonatomic, strong) NSMutableArray *sectionUIitem;
//모든 탭의 섹션 정보 저장
@property (nonatomic, strong) NSMutableDictionary *categoryUIitem;
//모든 탭의 그룹 정보 저장
@property (nonatomic, strong) NSMutableDictionary *categoryGroupInfo;
@property (nonatomic, strong) NSString              *m_BIAnimationURL;
@property (nonatomic, readwrite) BOOL               m_isBIaniViewReady;
@property (nonatomic, strong) NSString              *m_BIAniEndDate;
// 신규 프로모션 뷰
@property (nonatomic, weak) PromotionNewView * promotionNewView;

@end

@implementation Home_Main_ViewController
@synthesize sectionUIitem;
@synthesize HomewiseLogUrl;
@synthesize wview;
@synthesize tabBarView;
@synthesize curRequestString;
@synthesize currentOperation1;
@synthesize cuvframe;
@synthesize blurview;
@synthesize searchTopBarView;
@synthesize currentOperation2;
@synthesize currentOperation3;
@synthesize favoriteProductInfo;
@synthesize placeholderLabel;
@synthesize schTextField, btn_schTextFieldClear;
@synthesize imgSearchBG;
@synthesize m_btnCateSlide;
@synthesize isFirstLoadingAccessibility,loginView,isFirstAPI;
@synthesize recommendedRelatedSearchArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
//    if(ApplicationDelegate.isBackGround) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//           NSError *err = [NSError errorWithDomain:@"app_MemoryWarning" code:9005 userInfo:nil];
//            struct mach_task_basic_info info;
//                   mach_msg_type_number_t size = MACH_TASK_BASIC_INFO_COUNT;
//                   kern_return_t kerr = task_info(mach_task_self(),
//                                                  MACH_TASK_BASIC_INFO,
//                                                  (task_info_t)&info,
//                                                  &size);
//            NSString *msg = @"";
//                   if( kerr == KERN_SUCCESS ) {
//                       msg = [NSString stringWithFormat:@"메모리부족 경고: %llu Kb",info.resident_size/1000];
//                   }
//                   else {
//                       msg = [NSString stringWithFormat:@"메모리부족 경고: err(%s)",mach_error_string(kerr)];
//                   }
//           
//           [ApplicationDelegate SendExceptionLog:err msg:msg];
//        });
//    }
}

- (BOOL) isThisPromoStr:(SEARCHQTEXTTYPE)tqr {
    return  NO;
}


- (void)PromoSetOnSearchField {
    self.placeholderLabel.text = @"";
    if (self.recommendedRelatedSearchArray.count > 0) {
        NSString *value = NCS([[self.recommendedRelatedSearchArray objectAtIndex:0] objectForKey:@"rtq"]);
        if(value.length > 0) {
            self.placeholderLabel.text = value;
        }
        else {
            self.placeholderLabel.text = @"";
        }
    }
    else {
        self.placeholderLabel.text = @"";
    }
}


- (void) DrawCartCountstr {
    NSString* cartstr = [CooKieDBManager getCartCountstr];
    if( cartstr == nil || [cartstr isEqualToString:@"0"]) {
        [[self.searchTopBarView viewWithTag:kCARTBADGECOUNTERVIEWTAG] removeFromSuperview ];
    }
    else {
        if( [cartstr intValue] > 99) {
            cartstr = @"99";
        }
        
        CustomBadge *topcartbadge = [CustomBadge customBadgeWithString: cartstr];
        topcartbadge.tag = kCARTBADGECOUNTERVIEWTAG;
        [topcartbadge setFrame:CGRectMake(APPFULLWIDTH-(20+6), 4, topcartbadge.frame.size.width, topcartbadge.frame.size.height)];
        topcartbadge.alpha = 1.0f;
        topcartbadge.badgeLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.searchTopBarView addSubview:topcartbadge  ];
        
        NSLog(@"topcartbadge.frame = %@",NSStringFromCGRect(topcartbadge.frame));
    }
}
#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    
    [[self.searchTopBarView viewWithTag:kCARTBADGECOUNTERVIEWTAG] removeFromSuperview ];
    //[self performSelectorOnMainThread:@selector(DrawCartCountstr) withObject:nil waitUntilDone:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(DrawCartCountstr) userInfo:nil repeats:NO];
    
    //베딜 DSL_A 셀 자동 스크롤 , 동영상 pause & play
    if( [NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"sectionCode"]) isEqualToString:SECTIONCODE_HOME]) {
        SectionView *tview = [[[carousel2 itemViewAtIndex:carousel2.currentItemIndex] subviews] lastObject];
        [tview.tbv reconfigureVisibleCells];
    }
    //20160929 parksegun 타임딜 타이머가 화면에 노출될때 시작을 걸어줌(reconfigureVisibleCells 는 DSL_A, ML 타입 플레이 거는 메서드임)
    else if( [NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"sectionCode"]) isEqualToString:SECTIONCODE_TVSHOP]) {  //TV쇼핑
        SectionView *tview = [[[carousel2 itemViewAtIndex:carousel2.currentItemIndex] subviews] lastObject];
        if(tview != nil) {
            if(tview.tdcliveTbv) {
                [tview.tdcliveTbv reconfigureVisibleCells];
            }
        }
    }
    else {
        SectionView *tview = [[[carousel2 itemViewAtIndex:carousel2.currentItemIndex] subviews] lastObject];
        if(tview != nil) {
            if(tview.tbv) {
                [tview.tbv reconfigureVisibleCells];
            }
            else if(tview.fxcTbv) {
                [tview.fxcTbv reconfigureVisibleCells];
            }
            else if(tview.nfxcTbv2) {
                [tview.nfxcTbv2 checkTableViewAppear];
            }
            else if(tview.vodTbv) {
                [tview.vodTbv checkTableViewAppear];
            }
            else {
            }
        }
    }
    
    //[self PromoSetOnSearchField];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //안드로이드가 탭이동시마다 GASendlog보내고있어서~ 141216 -@"HOME"으로변경은 v.3.1.6.17
    [ApplicationDelegate GTMscreenOpenSendLog:@"Home"];
    
    //찜 등록 시 로그인 취소 대비
    if (self.favoriteProductInfo) {
        //for test
        NSLog(@"self.favoriteProductInfo != nil");
        self.favoriteProductInfo = nil;
    }
    
    if( isFirstSectionLoading == NO) {
        if([[[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"wiseLogUrl"] isKindOfClass:[NSNull class]] == NO) {
            ////탭바제거
            ///tabid호출 조건이면 와이즈로그를 호출하지 않는다. (아마 처음 한번만)
            NSString  *apiURL = [[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"wiseLogUrl"];
            if(ApplicationDelegate.isGsshopmobile_TabIdFlag == NO ) {
                NSLog (@"kiwon : viewWillAppear - isGsshopmobile_TabIdFlag NO - wiseAPPLogRequest");
                [ApplicationDelegate wiseAPPLogRequest:apiURL];
                
            }
            
            ///tabid호출 조건이면 와이즈로그를 호출하지 않는다. (아마 처음 한번만)
            if (ApplicationDelegate.isGsshopmobile_TabIdFlag && NCS(self.tabIdByTabId).length > 0) {
                if ([NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"navigationId"]) isEqualToString:NCS(self.tabIdByTabId)]) { //lseq가 있을경우에만
                    
                    //2019.06.24 회의때 lseq 처리는 웹뷰에서 넘어온 값만 처리하도록 합의 임매니저님 컨펌
                    NSString *strLseq = [NCS(self.tabIdByAddParam) copy];
                    apiURL = [NSString stringWithFormat:@"%@%@", apiURL,strLseq ];
                    self.tabIdByAddParam = @"";
                    self.tabIdByTabId = @"";
                    NSLog (@"kiwon : viewWillAppear - isGsshopmobile_TabIdFlag YES - wiseAPPLogRequest");
                    [ApplicationDelegate wiseAPPLogRequest:apiURL];
                    ApplicationDelegate.isGsshopmobile_TabIdFlag = NO;
                }
            }
        }
    }
    // Air Bridge - View home
    ABEcommerceEvent *abEvent = [[ABEcommerceEvent alloc] init];
    [abEvent sendViewHome];
    [super viewWillAppear:NO];
    
    [self showTabbarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    if(wview != nil) {
        [self.wview stopLoading];
    }
    
    //다른 화면 갈 때 사이즈 복귀
    if(carousel1 != nil) {
        //2016/12 사이드매뉴 도입으로인한 하단탭바 비노출처리
        //[self expandContentView:-900 scrollView:nil];
    }
    
    NSLog(@"");
    [self checkViewChangeForDealVideo:YES];
    
    if (isPromotionViewAdded == YES) {
        basePromotionView.hidden = YES;
    }
    
    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_STOP_SOCKET object:nil];
}




- (void)checkViewChangeForDealVideo:(BOOL)isForceStop{
    //홈메인에서 색션이 바뀔 경우 자동 재생중이던 베딜 동영상컨트롤
    //2016.01 추가로 생방송영역 플레이어 처리도 추가 , 딜셀과 조건이 다르므로 주의
    //2020.09 시그니처 매장중 동영상 셀이 있을경우도 추가
    NSLog(@"");
    @try {
        
        for (NSInteger i=0;i<[self.sectionUIitem count] ; i++) {
            
            NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"viewType"]);
            
            if ([NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"sectionCode"]) isEqualToString:SECTIONCODE_HOME]) { //베딜코드
                SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
                if (tview != nil) { //상단 생방송 영역 재생중인 생방송 멈춤 노티
                    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONLIVEVIDEOALLKILL object:nil userInfo:nil];
                    //[[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_DUAL_AB_PAUSE object:nil userInfo:nil];
                }
                //셀 사이사이 동영상 상품 셀들 정지 처리
                if (i == carousel2.currentItemIndex) {
                    if (isForceStop) {
                        [tview.tbv homeSectionChangedPauseDealVideo];
                    }
                    else {
                        NSLog(@"self.navigationController.visibleViewController = %@",self.navigationController.visibleViewController);
                        NSLog(@"self.navigationController.viewControllers = %@",self.navigationController.viewControllers);
                        if(self.navigationController.visibleViewController == self) {
                            [tview.tbv reconfigureVisibleCells];
                        }
                    }
                }
                else {
                    [tview.tbv homeSectionChangedPauseDealVideo];
                    
                    //2020.08.06 impression 효율추가
                    [tview.tbv invaildatePRD_C_SQ];
                }
            }
            
            else if ([NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"sectionCode"]) isEqualToString:SECTIONCODE_TVSHOP]) { //TV쇼핑
                //2016.01 생방송동영상셀 재생시 다른탭으로 이동시 정지처리
                SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
                if (tview != nil) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONLIVEVIDEOALLKILL object:nil userInfo:nil];
                }
                if(tview != nil) {
                    
                    if (i == carousel2.currentItemIndex) {
                        if(!isForceStop) {
                            //타임딜 타이머, 동여상을 다시 시작할때 홈탭이 아니면 재생하지 않도록 한다.(타탭에서 검색 버튼 눌렀다가 닫을 때 reconfigureVisibleCells를 호출하는 예외 처리
                            //홈메인에서 검색->상품 상세->검색 창 닫으면 타이머가 돈다... 조건 추가
                            if (![[self.navigationController visibleViewController] isKindOfClass:[self class]] || [DataManager sharedManager].selectTab != 0) {
                                break;
                            }
                            
                            if(tview.tdcliveTbv) {
                                [tview.tdcliveTbv reconfigureVisibleCells];
                            }
                        }
                        else {
                            if(tview.tdcliveTbv) {
                                [tview.tdcliveTbv homeSectionChangedPauseDealVideo];
                            }
                        }
                    }
                    else {
                        // 다르면 끄고
                        if(tview.tdcliveTbv) {
                            [tview.tdcliveTbv homeSectionChangedPauseDealVideo];
                        }
                    }
                }
            }
            
            //else if ([NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"sectionCode"]) isEqualToString:SECTIONCODE_VOD]) { //TV
            else if( [NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"navigationId"]) isEqualToString:@"492"]) {
                
                SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
                if (i != carousel2.currentItemIndex && tview != nil) {
                    //VOD매장 동영상 정지
                    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOPAUSE object:nil userInfo:nil];
                }
                
            }
            
            else if( [NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"navigationId"]) isEqualToString:@"492"]) {
                
                SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
                if (i != carousel2.currentItemIndex && tview != nil) {
                    //VOD매장 동영상 정지
                    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOPAUSE object:nil userInfo:nil];
                }
                
            }
            
            
            
            else if ([viewType isEqualToString:HOMESECTNFXCLIST]) { //시그니처 매장용 코드
                
                SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
                if(tview != nil) {
                    if (i == carousel2.currentItemIndex) {
                        if(isForceStop) { // 강제 정지일경우 무조건 정지
                            if(tview.nfxcTbv2 != nil) {
                                [tview.nfxcTbv2 checkSignatureVODStop];
                            }
                        }
                    }
                    else {
                        //현제 선택된 탭과 다들때에만 정지
                        if(tview.nfxcTbv2 != nil) {
                            [tview.nfxcTbv2 checkSignatureVODStop];
                        }
                    }
                }
            }
                
            else {
                SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
                if(tview != nil) {
                    if (i == carousel2.currentItemIndex) {
                        // 현재 선택과 같은 색션이면 시작~
                        if(!isForceStop) {
                            //타임딜 타이머, 동여상을 다시 시작할때 홈탭이 아니면 재생하지 않도록 한다.
                            //홈메인에서 검색->상품 상세->검색 창 닫으면 타이머가 돈다... 조건 추가
                            if (![[self.navigationController visibleViewController] isKindOfClass:[self class]] || [DataManager sharedManager].selectTab != 0) {
                                break;
                            }
                            
                            
                            if(tview.tbv != nil) {
                                [tview.tbv reconfigureVisibleCells];
                            }
                            else if(tview.fxcTbv != nil) {
                                [tview.fxcTbv reconfigureVisibleCells];
                            }
                            else {
                            }
                        }
                        else {
                            
                            if(tview.tbv != nil) {
                                [tview.tbv homeSectionChangedPauseDealVideo];
                            }
                            else if(tview.fxcTbv != nil) {
                                [tview.fxcTbv homeSectionChangedPauseDealVideo];
                            }
                            else {
                            }
                        }
                    }
                    else {
                        // 다르면 끔
                        if(tview.tbv != nil) {
                            [tview.tbv homeSectionChangedPauseDealVideo];
                        }
                        else if(tview.fxcTbv != nil) {
                            [tview.fxcTbv homeSectionChangedPauseDealVideo];
                        }
                        else {
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        GSException *gsExc = [[GSException alloc] initWithException:exception addString:@"App Boy Exception"];
        [ApplicationDelegate SendExceptionLog:gsExc];
    }
    @finally {
    }
}

- (void)checkViewChangeForDealVideoWithNoti:(NSNotification *)noti {
    NSLog(@"noti = %@",noti)
    BOOL isForceStop = NO;
    if([NCS([[noti userInfo] objectForKey:@"isForceStop"]) isEqualToString:@"YES"]) {
        isForceStop = YES;
    }
    [self checkViewChangeForDealVideo:isForceStop];
}


- (IBAction)goSmartCart:(id)sender {
    
//#if APPSTORE == 0
//    ///////////////////////
#if DEBUG
//    MobileLiveViewController *mvPlayer = [[MobileLiveViewController alloc] initWithNibName:@"MobileLiveViewController" bundle:nil];
//    mvPlayer.m_toappString = @"toapp://movetomobilelive?topapi=http://tm14.gsshop.com/app/section/mobilelive/2776/0";
//    [self.navigationController pushViewController:mvPlayer animated:YES];
//    return;
#endif
//
//    ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:@"http://tm14.gsshop.com/section/mobilelive?onAirInfo=Y"];
//    result.delegate = self;
//    result.view.tag = 505;
//    [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
//    return;
//
//    ///////////////////////
//#endif
    
    
    //481 GS Fresh 매장 네비아이디
    NSString *strCart = SMARTCART_URL;
    if ([@"481" isEqualToString:NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"navigationId"])]) {
        strCart = SMARTCART_GSFRESH_URL;
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=418824")];
    }
        
    [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_Main_Top_Cart" withLabel:strCart];

    ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:strCart];
    result.delegate = self;
    result.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
}

//GA 추적
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    // AirBridge 1.0.0
//    ABEcommerceEvent *ecommerceEvent = [[ABEcommerceEvent alloc] init];
//    [ecommerceEvent sendViewHome];
    NSLog(@"[ecommerceEvent sendViewHome]");
   

    // nami0342 - Accessibility test
//    if(UIAccessibilityIsVoiceOverRunning() == YES)
//    {
//        self.m_btnCateSlide.accessibilityLabel = @"상담원 주문 시 모바일과 동일한 혜택이 제공됩니다 카테고리";
//    }
//    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.m_btnCateSlide);
    
//    // nami0342 - CSP
    
    
   [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_START_SOCKET object:nil];

}





- (void) detectAccessibility : (NSNotification*) notification
{
    NSLog(@"#$$#$#$  Accessibility : %@", notification);
}




- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewMainTabBG.frame = CGRectMake(0.0, STATUSBAR_HEIGHT + kTopSearchBarHeight, APPFULLWIDTH, kTopCarouselHeight);
    
    self.m_BIAnimationURL = @"";        // BI animation json file url
    self.m_BIAniEndDate = @"";
    self.m_isBIaniViewReady = NO;
    
    self.aniView = [[LOTAnimationView alloc] init];
    
    [ApplicationDelegate callProcess];
    
    
    ApplicationDelegate.spviewController = [[SplashViewController alloc] init];
    [ApplicationDelegate.window addSubview:[ApplicationDelegate.spviewController view]];
    ApplicationDelegate.gactivityIndicator = [[SHActivityIndicatorView alloc] init];

#ifdef SM14
    
    // nami0342 - Accessibility
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectAccessibility:) name:UIAccessibilityAnnouncementKeyStringValue object:nil];
//
//    if(UIAccessibilityIsVoiceOverRunning() == YES)
//    {
//        if(isFirstLoadingAccessibility == NO)
//        {
//            isFirstLoadingAccessibility = YES;
//            self.m_btnCateSlide.accessibilityLabel = @"상담원 주문 시 모바일과 동일한 혜택이 제공됩니다 카테고리";
//        }
//        else
//        {
//            self.m_btnCateSlide.accessibilityLabel = @"";
//        }
//    }
#endif
    
    [self reInitWKWebView];
    
    self.topMarginSearchBar.constant = STATUSBAR_HEIGHT;
    self.lcontCoverViewHeight.constant = STATUSBAR_HEIGHT;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.view.backgroundColor =  [Mocha_Util getColor:@"FFFFFF"];
    //self.topSliderCoverView.backgroundColor = [Mocha_Util getColor:@"FFFFFF"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    imgSearchBG.layer.cornerRadius= 20.0;
    imgSearchBG.layer.masksToBounds = YES;
    self.navigationController.delegate = self;
    self.searchTopBarView.frame = CGRectMake(0, STATUSBAR_HEIGHT, APPFULLWIDTH, kTopSearchBarHeight);
    self.btn_gsbi.center = CGPointMake(APPFULLWIDTH/2.0, self.btn_gsbi.center.y);
    self.imgGSBI.center = self.btn_gsbi.center;
    //현재 카테고리
    _currentCategory = -1;
    //카테고리 정보
    self.categoryUIitem = [[NSMutableDictionary alloc] initWithCapacity:CATEGORY_TAB_COUNT];
    self.categoryGroupInfo = [[NSMutableDictionary alloc] initWithCapacity:CATEGORY_TAB_COUNT];
    //최초 API 실행 플래그
    isFirstAPI = TRUE;
    isFirstSectionLoading = YES;
    isValidRemoteResources = NO;
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    isPushProcing = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(WithPushGoSection)
                                                 name:MAINSECTIONPUSHMOVENOTI
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkViewChangeForDealVideoWithNoti:)
                                                 name:MAINSECTIONDEALVIDEOPAUSENOTI
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNextTabLoad)
                                                 name:MAINSECTION_API_FINISH
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reInitWKWebView) name:WKSESSION_REINIT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSplashView) name:@"NOTI_FINISH_SPLASHVIEW" object:nil];
    
    
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    self.tabIdBysubCategoryName = @""; //초기화
    
    
    // nami0342 - CSP
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StartCSPSocket)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    
    //상단 매장 탭 좌우 그라디에이션
    CAGradientLayer* sideLLayer = [CAGradientLayer layer];
    sideLLayer.frame = CGRectMake(0.0,0.0f, 20.0f, kTopCarouselHeight);
    sideLLayer.colors =  @[ (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                            (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                            (id)[UIColor colorWithWhite:1.0f alpha:0.7f].CGColor,
                            (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor];
    sideLLayer.locations =  @[@0.20f, @0.60f, @0.80f, @1.00f];
    sideLLayer.startPoint = CGPointMake(1.0, 0.5);
    sideLLayer.endPoint = CGPointMake(0.0, 0.5);
    [self.viewMainTabGradiLeft.layer addSublayer:sideLLayer];
    
    
    CAGradientLayer* sideRLayer = [CAGradientLayer layer];
    sideRLayer.frame = CGRectMake(0.0,   0.0f, 20.0f, kTopCarouselHeight);
    sideRLayer.colors =@[ (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                          (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                          (id)[UIColor colorWithWhite:1.0f alpha:0.7f].CGColor,
                          (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor];
    sideRLayer.locations = @[@0.20f, @0.60f, @0.80f, @1.00f];
    sideRLayer.startPoint = CGPointMake(0.0, 0.5);
    sideRLayer.endPoint = CGPointMake(1.0, 0.5);
    [self.viewMainTabGradiRight.layer addSublayer:sideRLayer];
    
}


// nami0342 - CSP 백그라운드로 갔다고 포어그라운드로 올때, 메인이 첫 화면이면, CSP 시작
- (void) StartCSPSocket
{
    if([ApplicationDelegate.mainNVC.visibleViewController isKindOfClass:[Home_Main_ViewController class]] == YES)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CSP_START_SOCKET object:nil];
    }
}


- (void)homeMainBaseProcess {
    tabBarView  = [[[NSBundle mainBundle] loadNibNamed:@"LastPrdCustomTabBarView" owner:self options:nil] firstObject];
    tabBarView.frame = CGRectMake(0.0, APPFULLHEIGHT - APPTABBARHEIGHT, APPFULLWIDTH, APPTABBARHEIGHT);
    tabBarView.autoresizesSubviews = NO;
    tabBarView.autoresizingMask = UIViewAutoresizingNone;
    //[self.view addSubview:tabBarView];
    //[ApplicationDelegate.window addSubview:tabBarView];
    if ( ApplicationDelegate.spviewController != nil ) {
        [ApplicationDelegate.window insertSubview:tabBarView belowSubview:ApplicationDelegate.spviewController.view];
    }
    else {
        [ApplicationDelegate.window addSubview:tabBarView];
    }
    [self firstProc];
    // nami0342 - 푸시 안내 팝업 이동 : Appdelegate -> MainViewController
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tempMsgFlag = [userDefaults valueForKey:GS_PUSH_RECEIVE];
    
    if(tempMsgFlag == nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [ApplicationDelegate showPushCheckAlert:@"INTROPUSH"];
        });
        
    }
    
    
}

-(BOOL)OnlineImageSaveProcWithUrl:(NSDictionary*)tdic withIndex:(int)idxnum withUpdateDate:(NSString*)udtstr{
    
    
    NSLog(@"사유알 %d, %@", idxnum, udtstr);
    if((id)udtstr == [NSNull null] ){
        udtstr = @"NULLSTR";
    }
    
    
    NSURL *turl = [NSURL URLWithString:[tdic objectForKey:@"smallIconImageUrl"]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSURLResponse *response;
    
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:kMKNetworkKitRequestTimeOutInSeconds error:&error];
    if (result)
    {
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *savepath = [DOCS_DIR stringByAppendingPathComponent:[NSString stringWithFormat:@"tbtn_on%d@2x.png", idxnum]];
        BOOL oldfileexits = [fileManager fileExistsAtPath:savepath];
        
        if(oldfileexits) {
            [fileManager removeItemAtPath:savepath error:NULL];
            NSLog(@"기존 FILE 삭제");
        }
        
        [result writeToFile:savepath atomically:YES];
        // FF!!!
        //NSError *error;
        //[result writeToFile:savepath options:NSDataWritingFileProtectionComplete error:&error];

        
    }
    
    else {
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:[NSString stringWithFormat:@"topbtn%d",idxnum]];
        [defaults synchronize];
        
        
        
        
        NSLog(@"리졀트1 없음");
        NSLog(@"error1 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
              [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
        return NO;
        
    }
    
    
    NSURL *turloff = [NSURL URLWithString:[tdic objectForKey:@"smallImageUrl"]];
    NSMutableURLRequest *offurlRequest = [NSMutableURLRequest requestWithURL:turloff];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    [offurlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [offurlRequest setHTTPMethod:@"GET"];
    [offurlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *offerror;
    NSURLResponse *offresponse;
    
    NSData* offresult = [NSURLSession sendSessionSynchronousRequest:offurlRequest returningResponse:&offresponse timeout:kMKNetworkKitRequestTimeOutInSeconds error:&offerror];
    if (offresult)
    {
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *savepath = [DOCS_DIR stringByAppendingPathComponent:[NSString stringWithFormat:@"tbtn_off%d@2x.png", idxnum]];
        BOOL oldfileexits = [fileManager fileExistsAtPath:savepath];
        
        if(oldfileexits) {
            [fileManager removeItemAtPath:savepath error:NULL];
            NSLog(@"기존 FILE 삭제");
        }
        
        [offresult writeToFile:savepath atomically:YES];
        // FF!!!
        //NSError *error;
        //[offresult writeToFile:savepath options:NSDataWritingFileProtectionComplete error:&error];
        
        NSLog(@"리졀트 값8: %@, %@",[offresult MD5],  udtstr);
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%@",udtstr] forKey:[NSString stringWithFormat:@"topbtn%d",idxnum]];
        [defaults synchronize];
        
        return  YES;
    }
    
    else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:[NSString stringWithFormat:@"topbtn%d",idxnum]];
        [defaults synchronize];
        
        NSLog(@"리졀트2 없음");
        NSLog(@"error2 %@\t%@\t%@\t%@", [offerror localizedDescription], [offerror localizedFailureReason],
              [offerror localizedRecoveryOptions], [offerror localizedRecoverySuggestion]);
        return NO;
        
    }
    
    
    
}




-(void)WithPushGoSection{
    isPushProcing = YES;
    if(_curmaintype == CURMAINVIEWTYPEAPPMAIN){
        NSLog(@"ddTarget URL: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"]);
        [self performSelector:@selector(sectionChangeWithTargetPushNum) withObject:nil afterDelay:1.0f inModes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        
        
    }
}

//APNS 등에 의해 (섹션)샵으로 직접 이동
-(void)sectionChangeWithTargetPushNum{
    NSLog(@"EETarget URL: %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"]);
    
    //카테고리 및 섹션 찾기
    int c=0;    // 카테고리
    int i=0;    // 섹션
    
    //메인 탭의 섹션만 검사 -> 그룹 탭의 섹션도 검사
    while (c < CATEGORY_TAB_COUNT)
    {
        NSArray *array = [self.categoryUIitem objectForKey:[NSNumber numberWithInt:c]];
        
        i = 0;
        
        for (NSDictionary *dic in array /*self.sectionUIitem*/) {
            
            
            //decimalNumber to #추가 및 NSString 형변환
            NSString *sectionCode = (c==0) ? [NSString stringWithFormat:@"#%@", [dic objectForKey:@"navigationId"] ] : [NSString stringWithFormat:@"#%@", [dic objectForKey:@"navigationId"] ];
            
            if([sectionCode isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"]]){
                
                break;
            }
            else
            {
                i++;
            }
        }
        
        if (i < [array count]) break;
        
        c++;
        
        if (c == CATEGORY_TAB_COUNT)
        {
            c = 0;
            i = -1;
            break;
        }
    }
    
    
    //하단 섹션 탭 및 섹션 컨텐츠 변경 요망
    [self changeCategoryTab:c sectionTab:i animated:YES];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PushTGurl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    isPushProcing = NO;
    
}


//카테고리 탭 (최상단 메인) 변경 시 하단의 섹션 탭 및 섹션 컨텐트 (carousel) 변경
- (void)changeCategoryTab:(int)categoryIndex sectionTab:(int)sectionIndex animated:(BOOL)animated
{
#if APPSTORE
#else
    //치명 아랫줄 삭제
    //_intmainsection = 0;
#endif
    //0 -1
    // sectionIndex 없는 경우 디폴트 처리
    if (sectionIndex < 0) {
        if (categoryIndex == 0) {
            sectionIndex = _intmainsection;
        }
        else {
            sectionIndex = 0;
        }
    }
    
    //화면 세팅 안되었으면 세팅
    BOOL justScreenDefined = FALSE;
    if (carousel1 == nil) {
        [self ScreenDefineFlickerType];
        justScreenDefined = TRUE;
    }

    
    // 현재 카테고리와 틀린 경우
    BOOL categoryChanged = (_currentCategory != categoryIndex);
    if (categoryChanged) {
        _currentCategory = categoryIndex;
        isFirstSectionLoading = YES;
        //iCarousel -> iScroll
        // 기존 섹션 뷰 삭제
        if (justScreenDefined == FALSE) {

            
            for (int i = (int)[carousel2 numberOfItems]-1; i >= 0; i--) {
                //타임딜 타이머를 탭이동시 viewwillappear 에서 타임딜 타이머를 구동한후 기본탭으로 이동하여 타이머에 의한 셀이 릴리즈 되지 못하고 기존타이머가 돌아버리는 현상을 해소
                SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
                if(tview.tbv) {
                    [tview.tbv homeSectionChangedPauseDealVideo];
                }
                else if(tview.fxcTbv) {
                    [tview.fxcTbv homeSectionChangedPauseDealVideo];
                }
                else if(tview.tdcliveTbv) {
                    [tview.tdcliveTbv homeSectionReloadTDCView];
                }
                else {
                    
                }
                //carousel content view 삭제
                [[carousel2 itemViewAtIndex:i] removeFromSuperview];
                [carousel2 removeItemAtIndex:i animated:NO];
            }
        }

        
            
            //2019/09/26메인탭 무한루프
            //[self setupCarousel1];
            
        
        
        self.sectionUIitem = [self.categoryUIitem objectForKey:[NSNumber numberWithInt:_currentCategory]];
        [carousel2 reloadData];
        
        //
        NSLog(@"sectionIndexsectionIndex = %ld",(long)sectionIndex);
        isMoveFromExt = YES;
        //2019/09/26메인탭 무한루프
        //[carousel2 setCurrentItemIndex:sectionIndex];
        [carousel2 scrollToItemAtIndex:sectionIndex animated:NO];
        [carousel1 scrollToButtonIndex:sectionIndex animated:NO];
        idxPrevCarousel1 =sectionIndex;
        isMoveFromExt = NO;
    }
    else {
        NSLog(@"sectionIndexsectionIndex = %ld",(long)sectionIndex);
        //2019/09/26메인탭 무한루프
        
        isMoveFromExt = YES;
        [carousel2 scrollToItemAtIndex:sectionIndex animated:NO];
        [carousel1 scrollToButtonIndex:sectionIndex animated:NO];
        idxPrevCarousel1 =sectionIndex;
        isMoveFromExt = NO;
        
        
        //20180703
        //현재 보이는 매징이 무엇인지 판단.
        SectionView *tview = [[[carousel2 itemViewAtIndex:sectionIndex] subviews] lastObject];
        //편성표 매장 갱신처리 인경우
        if (carousel2.currentItemIndex == sectionIndex && [self.tabIdBysubCategoryName length] > 0 && tview.sectionViewType == SectionViewTypeSchedule) {
            [tview loadBroadTypeSLIST:self.tabIdBysubCategoryName];
        }
        //20190402 parksegun 햄버거 메뉴에서 JBP 매장 하위로 이동 groupCd
        if([ApplicationDelegate.groupCode length]>0 && tview.sectionViewType == SectionViewTypeFlexible) {
            NSLog(@"내다... 갱신 하즈아..");
            
        }
    }
}


//베스트딜 하단 핫링크용
-(void)TopCategoryTabButtonClicked:(id)sender {
    NSLog(@"click!");
}
            
-(void)setupCarousel1{
    //2019/09/26메인탭 무한루프
    NSLog(@"setupCarousel1");
    //2019/09/26메인탭 무한루프
    //carousel1 = [[SSRollingButtonScrollView alloc] initWithFrame:CGRectMake(0.0, 20.0 + kTopSearchBarHeight, tabPrsnlWidth, kTopCarouselHeight)];
    self.viewMainTabBG.frame = CGRectMake(0.0, STATUSBAR_HEIGHT + kTopSearchBarHeight, APPFULLWIDTH, kTopCarouselHeight);
    
    if (carousel1 != nil) {
        [carousel1 removeFromSuperview];
        carousel1 = nil;
    }
    
    
    carousel1 = [[SSRollingButtonScrollView alloc] initWithFrame:CGRectMake(0.0,0.0, APPFULLWIDTH, kTopCarouselHeight)];
    carousel1.spacingBetweenButtons = 22.0f;
    carousel1.notCenterButtonTextColor = [UIColor blackColor];
    carousel1.centerButtonTextColor = [UIColor blackColor];
    carousel1.buttonNotCenterFont = [UIFont boldSystemFontOfSize:16.0];
    carousel1.buttonCenterFont = [UIFont boldSystemFontOfSize:16.0];
    carousel1.notCenterButtonTextColor = [Mocha_Util getColor:@"111111"];
    carousel1.centerButtonTextColor = [Mocha_Util getColor:@"111111"];
    carousel1.ssRollingButtonScrollViewDelegate = self;
    carousel1.fixedButtonHeight =kTopCarouselHeight;
    // nami0342 - 매장 네비게이션 스크롤 멈추는 속도 빠르게 처리 (마케팅 : 안지원, 천진아 요청)
    carousel1.decelerationRate = UIScrollViewDecelerationRateFast;
    carousel1.scrollsToTop = NO;
    
    NSMutableArray *arrTabMenu = [[NSMutableArray alloc] init];
    NSMutableArray *arrTabMenuIcons = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<[self.sectionUIitem count]; i++) {
        NSString *strMenu = NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"sectionName"]);
        NSString *imgUrl = NCS([[self.sectionUIitem objectAtIndex:i] objectForKey:@"sectionImgUrl"]);
        if ([strMenu length] > 0) {
            [arrTabMenu addObject:strMenu];
            [arrTabMenuIcons addObject:imgUrl];
        }
    }
    
    if ([arrTabMenu count] > 0) {
        [carousel1 createButtonArrayWithButtonTitles:arrTabMenu andIconUrl:arrTabMenuIcons andLayoutStyle:SShorizontalLayout];
    }
    
    [self.viewMainTabBG insertSubview:carousel1 atIndex:0];
    
    UIView *line = [[UIView alloc]  initWithFrame:CGRectMake(0.0, self.viewMainTabBG.frame.size.height - 0.4 , self.viewMainTabBG.frame.size.width, 0.4f)];
    line.backgroundColor = [Mocha_Util getColor:@"CACACA"];
    line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.viewMainTabBG insertSubview:line atIndex:1];
    
    
    self.viewMainTabGradiRight.frame = CGRectMake(APPFULLWIDTH - 20.0, 0.0, 20.0, kTopCarouselHeight);
    

}

-(void)reInitWKWebView{

    if (self.wview != nil) {
        [self.wview removeFromSuperview];
        self.wview.UIDelegate = nil;
        self.wview.navigationDelegate = nil;
        self.wview = nil;
    }
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [AirBridge.webInterface injectTo:userContentController withWebToken:@"2ddfb0a363604a0699b758eaa8ad23cf"];
    config.userContentController = userContentController;
    config.processPool = [[WKManager sharedManager] getGSWKPool];
    config.allowsInlineMediaPlayback = YES;
    
    self.wview = [[GSWKWebview alloc] initWithFrame:CGRectZero configuration:config];
    self.wview.navigationDelegate = self;
    self.wview.UIDelegate = self.wview;
    [self.view insertSubview:self.wview atIndex:0];
}

/**
 NSURLRequest(NSMutableURLRequest) 클래스의 setCachePolicy: 메소드 캐시 정책
 
 NSURLRequestUseProtocolCachePolicy(Default)
 - 프로토콜에 가장 부합하는 정책.
 NSURLRequestReloadIgnoringCacheData(NSURLRequestReloadIgnoringLocalCacheData)
 - URL로딩 시스템이 캐시를 완전히 무시하고 원격지 소스로부터 데이터를 로딩하는 정책.
 NSURLRequestReturnCacheDataElseLoad
 - 캐시된 데이터가 있다면, 로컬캐시로 부터 데이터를 가져오며, 없다면 원격지 소스로부터 데이터를 로딩한다.
 NSURLRequestReturnCacheDataDontLoad
 - (네트워크 연결 안함)로컬 캐시에 있는 정책만을 리턴함. 만약 응답이 로컬 캐시안에 없다면 nil이 리턴됨. 오프라인 모드에 대한 기능과 비슷함.
 */

//메인 탭, 그룹 매장 섹션 데이터 가져와서 저장, 화면 업데이트 호출
-(void) firstProc {
    
    [self checkViewChangeForDealVideo:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HOME_MAINSECTION_FIRSTPROC object:nil userInfo:nil];
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    [CooKieDBManager printSharedCookies];
    
    // 홈매장 정보 가져오는 코드
    {
        BESTRCMDYN =@"";
        BESTRCMDURL=@"";
        self.currentOperation2 = [ApplicationDelegate.gshop_http_core gsGROUPUILISTURL:^(NSDictionary *result) {
                                      //for test
                                      NSLog(@"GROUPUILISTURL \n%@", result);
             

                                      //20160125 segun 예외처리 방어 코드
                                      if(result == nil && [result count] <= 0) {
                                          if(![ApplicationDelegate isthereMochaAlertView]) {
                                              Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:GNET_ERRSERVER maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                              malert.tag = 555;
                                              [ApplicationDelegate.window addSubview:malert];
                                              
                                          }
                                          //
                                          isFirstAPI = FALSE;
                                          
                                          //이전에 가져온 데이터 있으면 그걸로 실행
                                          if ([self.categoryUIitem objectForKey:[NSNumber numberWithInt:0]])
                                          {
                                              [self performSelectorOnMainThread:@selector(updateContentWithServerData:) withObject:[NSNumber numberWithInt:0] waitUntilDone:NO];
                                          }
                                          
                                           [self performSelector:@selector(playHeaderBIAnimation) withObject:nil afterDelay:1.0f];
                                          
                                          return;
                                      }
                                      
                                      isFirstAPI = FALSE;
                                      
                                      _curmaintype = CURMAINVIEWTYPEAPPMAIN;
                                      
                                      // app url 정보 저장
                                      {
                                          NSDictionary *appInfoDic = [result valueForKey:@"appUseUrl"];
                                          
                                          self.m_BIAnimationURL = NCS([appInfoDic objectForKey:@"biImgUrl"]);
                                          self.m_BIAniEndDate = NCS([appInfoDic objectForKey:@"biImgEndDate"]);
                                          TV_LIVE_URL = [appInfoDic objectForKey:@"tvLiveUrl"];
                                          
                                          TVSHOP_LIVE_URL = [appInfoDic objectForKey:@"liveBrodUrl"];
                                          TVSHOP_DATA_URL = [appInfoDic objectForKey:@"dataBrodUrl"];
                                          TVSHOP_SALEINFO_URL = [appInfoDic objectForKey:@"salesInfoUrl"];
                                          FAVORITE_CRE_URL = [appInfoDic objectForKey:@"wishUrl"];
                                          
                                          //홈메인 듀얼 신규 규격
                                          HOME_MAIN_TVSHOP_LIVE_URL = [appInfoDic objectForKey:@"homeLiveBrodUrl"];
                                          HOME_MAIN_TVSHOP_DATA_URL = [appInfoDic objectForKey:@"homeDataBrodUrl"];
                                          HOME_MAIN_MOBILE_LIVE_URL = NCS([appInfoDic objectForKey:@"homeMobileliveUrl"]);
                                          
                                          BESTRCMDYN = [appInfoDic objectForKey:@"bestRcmdYN"];
                                          BESTRCMDURL = [appInfoDic objectForKey:@"bestRcmdUrl"];

                                          //단품 네이티브 적용 여부 플래그
                                          //헤더상단 네이티브
                                          //iOS 10.3.3. 단말에서 단품네이티브 오작동 확인
                                          if (@available(iOS 11.0, *)) {
                                              if(UIAccessibilityIsVoiceOverRunning() == YES) {
                                                  PRD_NATIVE_YN = @"N";
                                              }else{
                                                  PRD_NATIVE_YN = [appInfoDic objectForKey:@"applyNativeWeb"];
                                              }
                                          }else{
                                            PRD_NATIVE_YN = @"N";
                                          }


                                          //2017.02 //사이드 매뉴 네비게이션
                                          if (NCO([result valueForKey:@"leftNavigation"]) && [[result valueForKey:@"leftNavigation"] isKindOfClass:[NSDictionary class]]) {
                                              LEFTNAVIGATION_DIC = [result valueForKey:@"leftNavigation"];
                                          }
                                          
                                          
                                          //2016.01 라이브톡 SNS 공유용 추가
                                          if ([appInfoDic objectForKey:@"snsInfo"] != nil) {
                                              [DataManager sharedManager].strSNSINFO_URL = [appInfoDic objectForKey:@"snsInfo"];
                                          }
                                          
                                          //2016.06 날방 새로고침 URL 추가
                                          if ([appInfoDic objectForKey:@"tvLiveDealBannerUrl"] != nil) {
                                              NALBANG_LIVE_URL = [appInfoDic objectForKey:@"tvLiveDealBannerUrl"];
                                          }
                                          
                                          //for test
                                          NSLog(@"CHODY FAVORITE : %@", FAVORITEREGURL(@"chody"));
                                      }
            
                                    NSString *defaultNavigationId = @"";
            
            
                                    // 20192020 parksegun 개인 매장 편집정보 처리 부분 -> 개인화 메뉴 제거 2020.01.06 parksegun
                                    //매장정보를 담는 배열
                                    NSArray *groupSectionListArr = [result objectForKey:@"groupSectionList"];
            
                                    //--
                                      //20160119 네비게이션중 처음꺼만 사용하면 되지 않나????
                                      //->그래서 처음꺼만 저장하도록 변경
                                      int i = 0;
                                      if(NCO(groupSectionListArr) && [groupSectionListArr count] > 0) {
                                          NSDictionary *groupInfo = [groupSectionListArr objectAtIndex:i];
                                          defaultNavigationId = NCS([groupInfo objectForKey:@"defaultNavigationId"]);
                                          if(NCO(groupInfo) && NCO([groupInfo objectForKey:@"sectionList"])) {
                                              NSArray *originalSectionList = [groupInfo objectForKey:@"sectionList"];
                                              NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[originalSectionList count]];
                                              for (int k=0, l=(int)[originalSectionList count]; k<l; k++) {
                                                  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[originalSectionList objectAtIndex:k]];
                                                  // 필요한 그룹정보를 section 정보 dictionary에 추가
                                                  [dic setObject:[groupInfo objectForKey:@"defaultNavigationId"] forKey:@"defaultNavigationId"];
                                                  [dic setObject:[groupInfo objectForKey:@"groupSectionName"] forKey:@"groupSectionName"];
                                                  [dic setObject:[groupInfo objectForKey:@"groupSectionId"] forKey:@"groupSectionId"];
                                                  //20160119 homeNavigationId 추가
                                                  if ([groupInfo objectForKey:@"homeNavigationId"]) {
                                                      [dic setObject:[groupInfo objectForKey:@"homeNavigationId"] forKey:@"homeNavigationId"];
                                                  }
                                                  
                                                  [array addObject:dic];
                                              }
                                              
                                              // 그룹 섹션 리스트 저장
                                              [self.categoryUIitem setObject:array forKey:[NSNumber numberWithInt:i]];
                                              
                                              // 그룹 정보 저장
                                              NSMutableDictionary *groupInfoDic = [NSMutableDictionary dictionaryWithDictionary:groupInfo];
                                              [groupInfoDic removeObjectForKey:@"sectionList"];
                                              [self.categoryGroupInfo setObject:groupInfoDic forKey:[NSNumber numberWithInt:i]];
                                          }
                                      }
            
                                      // 기본 탭 - home (탭 0)
                                      if([self.categoryUIitem count] > 0) {
                                          // 20160125 segun 방어코드 추가
                                          self.sectionUIitem = [self.categoryUIitem objectForKey:[NSNumber numberWithInt:0]];
                                          _intmainsection = 0;
                                          for (int i=0, j=(int)[self.sectionUIitem count]; i<j; i++) {
                                              NSDictionary *dic = [self.sectionUIitem objectAtIndex:i];
                                              //20160119 homeNavigationId가 있으면 이것을 호출...
                                              if (ApplicationDelegate.appfirstLoading == YES && NCO([dic objectForKey:@"homeNavigationId"]) && [(NSNumber *)[dic objectForKey:@"homeNavigationId"] intValue] > 0) {
                                                  if ([(NSNumber *)[dic objectForKey:@"homeNavigationId"] intValue] == [(NSNumber *)[dic objectForKey:@"navigationId"] intValue]) {
                                                      //defaultNavigation 설정은 이곳에서 결정되어짐
                                                      _intmainsection = i;
                                                      break;
                                                  }
                                              }
                                              else {
                                                  if ([(NSNumber *)[dic objectForKey:@"defaultNavigationId"] intValue] == [(NSNumber *)[dic objectForKey:@"navigationId"] intValue]) {
                                                      //defaultNavigation 설정은 이곳에서 결정되어짐
                                                      _intmainsection = i;
                                                      break;
                                                  }
                                              }
                                          }//for end
                                          
                                          [self performSelectorOnMainThread:@selector(updateContentWithServerData:) withObject:[NSNumber numberWithInt:0] waitUntilDone:NO];
                                          [self performSelector:@selector(resetCSP:) withObject:defaultNavigationId afterDelay:0.0];//딜레이를 주면 csp 연결하는데 문제가 발생하지 않음.
                                          
                                          
                                          [self recommendedRelatedSearchTermsApi];
                                          
                                           [self performSelector:@selector(playHeaderBIAnimation) withObject:nil afterDelay:1.0f];
                                      }
                                  }
            onError:^(NSError* error) {
                                      //for test
                                      NSLog(@"GROUPUILISTURL error \n%@", [error localizedDescription]);
                                      
                                      // nami0342 : 공사중일 경우 이 부분으로 인해 네트워트 오류 팝업이 공사중 페이지를 덮는 현상이 있어서 막기
                                      if(ApplicationDelegate.isOutofService == NO) {
                                          if(![ApplicationDelegate isthereMochaAlertView]){
                                              Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GNET_SERVERDOWN maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                              malert.tag = 555;
                                              
                                              // nami0342 - 서버 점검중 웹뷰가 떠 있을 경우 얼럿 비 노출 처리
                                              if([ApplicationDelegate.window viewWithTag:505] == nil)
                                              {
                                                  [ApplicationDelegate.window addSubview:malert];
                                              }
                                              else
                                              {
                                                  // 서버 점검중 웹뷰가 떠 있으니 종료 시키지 않음.
                                              }
                                          }
                                      }
                                      isFirstAPI = FALSE;
                                      //prsnlSave = NO;
                                      //이전에 가져온 데이터 있으면 그걸로 실행
                                      if ([self.categoryUIitem objectForKey:[NSNumber numberWithInt:0]]) {
                                          [self performSelectorOnMainThread:@selector(updateContentWithServerData:) withObject:[NSNumber numberWithInt:0] waitUntilDone:NO];
                                      }
                                  }];
    }
    
    //CSP 데이터 초기화 위치조정
    [ApplicationDelegate.objectCSP removeAllObjects]; //CSP_초기화

}

- (void) playHeaderBIAnimation
{
    // 스플래시 구동중이면 패스
    if(self.m_isBIaniViewReady == NO)
        return;
    
    if(self.aniView != nil && self.aniView.isAnimationPlaying == YES)
        return;
    
//#if DEBUG
//    self.m_BIAnimationURL = @"http://image.gsshop.com/ui/gsshop/mc/common/images/GSSHOP_fl.json";
//#endif
    
    if([NCS(self.m_BIAnimationURL) length] == 0)
        return;
    
    //
    if([self.m_BIAniEndDate length] == 0)
        return;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];

    double now = [[formatter stringFromDate:[NSDate date]] doubleValue];
    double dEnddate = [self.m_BIAniEndDate doubleValue];
    
    // 종료일이후라면 노출 안한다.
    if(now > dEnddate)
        return;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.aniView downContentsOfURLWithCompletionBlock:[NSURL URLWithString:self.m_BIAnimationURL] onCompletion:^(BOOL animationFinished) {
            
            if(animationFinished == YES)
            {
                if(self.aniView.sceneModel != nil)
                {
                    // nami0342 - Lottie animation
                    self.aniView.frame = CGRectMake(0, 0, 132, 44);
                    self.aniView.center = self.btn_gsbi.center;
                    self.aniView.backgroundColor = [UIColor clearColor];
                    self.aniView.loopAnimation = NO;
                    [self.searchTopBarView insertSubview:self.aniView belowSubview:self.btn_gsbi];
                    
                    self.imgGSBI.hidden = YES;
                    self.aniView.hidden = NO;
                    [self.view layoutIfNeeded];
                    
                    [self.aniView playWithCompletion:^(BOOL animationFinished) {
                        
                        if(animationFinished == YES)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.imgGSBI.hidden = NO;
                                self.aniView.hidden = YES;
                                [self.aniView setFrame:CGRectZero];
                                [self.aniView removeFromSuperview];
                                [self.searchTopBarView layoutIfNeeded];
                            });
                        }
                    }];
                }
            }
        }];
    });
}



// nami0342 - After splash view was removed.
- (void) finishSplashView
{
    self.m_isBIaniViewReady = YES;
    [self performSelector:@selector(playHeaderBIAnimation) withObject:nil afterDelay:1.0f];
    
    // 2020. 09. 16 스플레시 화면이 닫힌 후 프로모션 팝업 애니메이션 동작
    if (self.promotionNewView != nil ) {
        [self.promotionNewView showAnimation];
    }
}


///추천연관검색어 호출 API parksegun 20200512
- (void)recommendedRelatedSearchTermsApi {
    //web -> rest cookie sync
    
    [WKManager.sharedManager copyToSharedCookieAll:^(BOOL isSuccess) {
    
        if(isSuccess == YES) {
    
            self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:RECOMMENDED_RELATED_SEARCH_TERMS isForceReload:YES onCompletion:^(NSDictionary *respstr) {
                NSLog(@"recommendedRelatedSearchTermsApi \n%@", respstr);
                if( NCA([respstr objectForKey:@"list"]) ) {
                     if(self.recommendedRelatedSearchArray == nil) {
                         self.recommendedRelatedSearchArray = [[NSMutableArray alloc] initWithArray:[respstr objectForKey:@"list"]];
                     }
                     else {
                         [self.recommendedRelatedSearchArray removeAllObjects];
                         [self.recommendedRelatedSearchArray addObjectsFromArray:[respstr objectForKey:@"list"]];
                     }
                }
                else {
                    if(self.recommendedRelatedSearchArray == nil) {
                        self.recommendedRelatedSearchArray = [[NSMutableArray alloc] init];
                    }
                    [self.recommendedRelatedSearchArray removeAllObjects];
                }
                //홈매장에 0번쨰 추천연관검색어 노출
                [self PromoSetOnSearchField];
                
            } onError:^(NSError *error) {
                 NSLog(@"recommendedRelatedSearchTermsApi error \n%@", [error localizedDescription]);
            }];
            
        }
        else {
            if(self.recommendedRelatedSearchArray == nil) {
                self.recommendedRelatedSearchArray = [[NSMutableArray alloc] init];
            }
            [self.recommendedRelatedSearchArray removeAllObjects];
        }
        
        }];
    
}


//
- (void)resetCSP:(NSString *)naviId {
    //CSP 데이터 초기화 위치조정
    NSLog(@"naviId: %@",naviId);
    [ApplicationDelegate CSP_JoinWithTabID:naviId];//홈 매장 ID
}


- (void)updateContentWithServerData:(NSNumber *)number
{
    
    if (carousel1 != nil) {
        [carousel1 removeFromSuperview];
        carousel1 = nil;
    }
    
    if (carousel2 != nil) {
        
        for (NSInteger i=0; i<[carousel2 numberOfItems]; i++) {
            UIView *tView = [carousel2 itemViewAtIndex:i];
            NSLog(@"tView.subviews = %@",tView.subviews);
            for (UIView *sectionView in tView.subviews) {
                [sectionView removeFromSuperview];
            }
        }

        
        [carousel2 removeFromSuperview];
        carousel2 = nil;
    }
    
    self.searchTopBarView.frame = CGRectMake(0.0, STATUSBAR_HEIGHT, searchTopBarView.frame.size.width, searchTopBarView.frame.size.height);
    
    int index = [number intValue];
    
    //현재 카테고리
    _currentCategory = -1;
    
    //VOD매장에서 하단 앱설정 -> 빽 했을경우 초기화 잘 안되는경우
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOALLKILL object:nil userInfo:nil];
    
    [self changeCategoryTab:index sectionTab:-1 animated:NO];
    
    
    //자동 로그인동작이 완료된후  firstproc 호출되는경우 장바구니 뱃지 draw
    [[self.searchTopBarView viewWithTag:kCARTBADGECOUNTERVIEWTAG] removeFromSuperview ];
    [self performSelectorOnMainThread:@selector(DrawCartCountstr) withObject:nil waitUntilDone:NO];
    
    
    
    
    if (ApplicationDelegate.appfirstLoading == YES)
    {
        NSLog(@"<updateContentWithServerData loadingDone>");
        [ApplicationDelegate loadingDone];
        
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
        
        [self performSelector:@selector(latelysetscrollstotop) withObject:nil afterDelay:2.0f];
    }
    else
    {
        if(ApplicationDelegate.isTabbarHomeButtonClick_forSideMenu != YES) {
            [ApplicationDelegate setIsTabbarHomeButtonClick_forSideMenu:NO]; //탭바 홈 눌림 체크 초기화
        }
        
        [ApplicationDelegate setIsTabbarHomeButtonClick_forSideMenu:NO]; //탭바 홈 눌림 체크 초기화
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] != nil)
    {
        NSLog(@"pushurl저장  %@ ", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"]);
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PushTGurl"] hasPrefix:@"#"] &&
            isPushProcing == NO)
        {
            [self WithPushGoSection];
        }
    }
    
    //여기에 예약된 앱런치 이후 이동 URL 체커
    if(ApplicationDelegate.lunchAfterActionUrl != nil && ApplicationDelegate.lunchAfterActionUrl.count > 0) {
        for (NSString * goUrl in ApplicationDelegate.lunchAfterActionUrl) {
            [ApplicationDelegate goUrlSchemeAction:goUrl];
        }
        [ApplicationDelegate.lunchAfterActionUrl removeAllObjects]; //제거
    }
    
}




-(void)showPromotionPopup_async
{
    [self performSelectorInBackground:@selector(ShowPromotionPopUp) withObject:nil];
    
}


-(void)ShowPromotionPopUp {
    
    __block BOOL isPromotionPopup = NO;
    
    
    //광고확인 동기통신 진행
    dispatch_async(dispatch_get_main_queue(), ^{
        
        isPromotionPopup = ApplicationDelegate.isPromotionPopup;
        
        //20160309 parksegun 딥링크를 타고온 경우 프로모션 팝업을 띄우지 않는다.
        if(ApplicationDelegate.isDeeplinkPrdDeal == YES){
            return;
        }
    });
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // nami0342 - 메모리에서 프로모션 팝업이 호출되어야할 경우에만 진행
    if(isPromotionPopup == NO) {
        
        
        
            
        NSLog(@"save date: %@ ==== %@", [Mocha_Util  getCurrentDate:NO], [defaults objectForKey:PROMOTIONPOPUPDATE]);
        
        //NSURL *turl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?today=20180207",PROMOTIONAPIURL]];
        NSURL *turl = [NSURL URLWithString:PROMOTIONAPIURL];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
        
        //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        
        // 20140120 Youngmin Jin -Start
        // 공개키요청이  get -> post 방식 & Content-Type 추가로 인한 설정 추가
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSError *error;
        NSURLResponse *response;
        
        NSLog(@"범인은 프로모션 !!!");
        
        NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:kMKNetworkKitRequestTimeOutInSeconds error:&error];
        
        _promotionInfoDic = [result JSONtoValue];
        
        // yunsang.jin // result 가 null은 아니나 json 이 아닐경우 아예 빼버림
        if (_promotionInfoDic != nil)
        {
            
            NSLog(@"_promotionInfoDic Dic %@",_promotionInfoDic);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            BOOL showPopup = NO;
            
            if ([NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"P"]) {
                
                NSLog(@"[[defaults objectForKey:PROMOTIONPOPUP_PUSHAGREE_NO7DAY] = %@",NCS((NSDate *)(LL(PROMOTIONPOPUP_PUSHAGREE_NO7DAY))));
                NSLog(@"[Mocha_Util  getCurrentDate:NO] = %@",NCS([Mocha_Util  getCurrentDate:YES]));
                
                if(
                   ([NCS([userDefaults objectForKey:GS_PUSH_RECEIVE]) isEqualToString:@"N"] == YES) //수신동의가N 인경우 에만 띄움
                   && [Common_Util ShowRecommendPushAgreePopup])
                   //(([defaults objectForKey:PROMOTIONPOPUP_PUSHAGREE_DATE] == nil) || (![[defaults objectForKey:PROMOTIONPOPUP_PUSHAGREE_DATE] isEqualToString:[Mocha_Util  getCurrentDate:NO]]))
                   //조르기 팝업 아니오 값이 없거나 , 조르기 팝업 저장 날자값이 오늘과 다를경우
                {
                    
                    showPopup = YES;
                }
                    
                
                
//                return;
            }else{ // M , S
            
                //금일날짜 저장값이 없거나 금일이 아닌경우에는 표출
                if( ([defaults objectForKey:PROMOTIONPOPUPDATE] == nil) || (![[defaults objectForKey:PROMOTIONPOPUPDATE] isEqualToString:[Mocha_Util  getCurrentDate:NO]])){
                    showPopup = YES;
                }
                
            }
            
            
            if(showPopup == YES && [NCS([_promotionInfoDic valueForKey:@"result"]) isEqualToString:@"Y"]  ){
                
                if([NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"P"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.promotionNewView != nil) {
                            [self.promotionNewView removeFromSuperview];
                            self.promotionNewView = nil;
                        }
                        PromotionNewView* promotionView = [[[NSBundle mainBundle] loadNibNamed:@"PromotionNewView" owner:self options:nil] firstObject];
                        self.promotionNewView = promotionView;
                        [promotionView setData:_promotionInfoDic target:self];
                        

                        // nami0342 - remove 하기전 메모리에 올라와있는지 확인.
                        if(basePromotionView != nil && [basePromotionView isKindOfClass:[UIView class]] == YES)
                        {
                            [basePromotionView removeFromSuperview];
                            basePromotionView = nil;
                        }
                        
                        basePromotionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)] ;
                        basePromotionView.backgroundColor = [UIColor clearColor];
                        
                        [basePromotionView addSubview:promotionView];
                        promotionView.translatesAutoresizingMaskIntoConstraints = NO;
                        [NSLayoutConstraint activateConstraints:@[
                            [promotionView.topAnchor constraintEqualToAnchor:basePromotionView.topAnchor],
                            [promotionView.leadingAnchor constraintEqualToAnchor:basePromotionView.leadingAnchor],
                            [promotionView.trailingAnchor constraintEqualToAnchor:basePromotionView.trailingAnchor],
                            [promotionView.bottomAnchor constraintEqualToAnchor:basePromotionView.bottomAnchor]
                        ]];
                        
                        NSString* tgs= [NSString stringWithFormat:@"%@_%@", [_promotionInfoDic valueForKey:@"bannertype"],[_promotionInfoDic valueForKey:@"link"] ];
                        [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_App_main_popup_impression" withLabel:tgs     ];
                        
                        //현재 네이게이션의 보여지는 뷰컨트롤러가 아닐경우 프로모션 히든
                        if (![[self.navigationController visibleViewController] isKindOfClass:[self class]] || [DataManager sharedManager].selectTab != 0) {
                            basePromotionView.hidden = YES;
                        }
                        
                        isPromotionViewAdded = YES;
                        
                        //탭바뷰 위로 올려야 함.
                        if(ApplicationDelegate.HMV.tabBarView != nil) {
                            [ApplicationDelegate.window insertSubview:basePromotionView aboveSubview:ApplicationDelegate.HMV.tabBarView];
                        }
                        else {
                            [ApplicationDelegate.window insertSubview:basePromotionView atIndex:1];
                        }
                        return;
                    });
                }
                
                if([NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"S"]||
                   [NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"M"])
                {
                    
                    //데이터가 유효할경우 image 를 바이너리 형태로 다운받아서 처리한다
                    NSString *strImgUrl = NCS([_promotionInfoDic objectForKey:@"imgurl"]);
                    
                    
                    
                    if ([strImgUrl length] > 0 && [strImgUrl hasPrefix:@"http"]) {
                        
                        NSError *error;
                        NSURLResponse *response;
                        NSData* timgdata;
                        
                        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strImgUrl]];
                        
                        //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
                        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
                        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
                        
                        [urlRequest setHTTPMethod:@"GET"];
                        timgdata = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:2.0 error:&error];
                        
                        if (error != nil || timgdata == nil) {
                            
                            NSLog(@"error != nil || timgdata == nil");
                            return;
                            
                        }else{
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                
                                
                                // nami0342 - remove 하기전 메모리에 올라와있는지 확인.
                                if(basePromotionView != nil && [basePromotionView isKindOfClass:[UIView class]] == YES)
                                {
                                    [basePromotionView removeFromSuperview];
                                    basePromotionView = nil;
                                }
                                
                                if(view_Promotion != nil && [view_Promotion isKindOfClass:[PromotionView class]] == YES)
                                {
                                    [view_Promotion removeFromSuperview];
                                    view_Promotion =nil;
                                }
                                
                                /* S 테스트 코드
                                 NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] initWithDictionary:_promotionInfoDic];
                                 [dicTemp setObject:@"S" forKey:@"bannertype"];
                                 _promotionInfoDic = (NSDictionary *)dicTemp;
                                 */
                                
                                basePromotionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)] ;
                                basePromotionView.backgroundColor = [UIColor clearColor];
                                
                                
                                
                                UIView* bpvdimv = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, APPFULLHEIGHT)];
                                [bpvdimv.layer setMasksToBounds:NO];
                                bpvdimv.layer.backgroundColor = [UIColor blackColor].CGColor;
                                bpvdimv.layer.opacity = 0.8;
                                [basePromotionView addSubview:bpvdimv];
                                
                                
                                view_Promotion = [[[NSBundle mainBundle] loadNibNamed:@"PromotionView" owner:self options:nil] firstObject];
                                [view_Promotion setPromotionInfoData:_promotionInfoDic andTarget:self andImageData:timgdata];
                                
                                
                                //M 타입
                                if([NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"M"]){
                                    
                                    //20161005 parksegun 프로모션 팝업 위치 변경(센터로 변경)
                                    view_Promotion.frame = CGRectMake((APPFULLWIDTH-300)/2, (APPFULLHEIGHT-300)/2, 300, 300);
                                }
                                //S 타입
                                else if([NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"S"]  ){
                                    view_Promotion.frame = CGRectMake((APPFULLWIDTH-300)/2, APPFULLHEIGHT, 300, 135+45);
                                }
                                
                                [basePromotionView addSubview:view_Promotion];
                                
                                
                                NSString* tgs= [NSString stringWithFormat:@"%@_%@", [_promotionInfoDic valueForKey:@"bannertype"],[_promotionInfoDic valueForKey:@"link"] ];
                                [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_App_main_popup_impression" withLabel:tgs     ];
                                
                                //현재 네이게이션의 보여지는 뷰컨트롤러가 아닐경우 프로모션 히든
                                if (![[self.navigationController visibleViewController] isKindOfClass:[self class]] || [DataManager sharedManager].selectTab != 0) {
                                    basePromotionView.hidden = YES;
                                }
                                
                                isPromotionViewAdded = YES;
                                //탭바뷰 위로 올려야 함.
                                
                                if(ApplicationDelegate.HMV.tabBarView != nil) {
                                    [ApplicationDelegate.window insertSubview:basePromotionView aboveSubview:ApplicationDelegate.HMV.tabBarView];
                                }
                                else {
                                    [ApplicationDelegate.window insertSubview:basePromotionView atIndex:1];
                                }
                                
                                
                                if([NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"S"] && basePromotionView.hidden == NO ){
                                    [self s_promovshow];
                                    
                                }
                            });
                            
                            
                            
                        }
                        
                        
                    }else{
                        
                        NSLog(@"FALSE [strImgUrl length] > 0 && [strImgUrl hasPrefix:http]");
                        return;
                    }
                    
                }
                else
                {
                    //S|M  아닌경우 리턴
                    NSLog(@"S|M|P  아닌경우 리턴");
                    return;
                }
                
            }
        }
        else {
            
            NSLog(@"promotion popup error3 %@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                  [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
            
        }
        
    }
}

-(void)s_promovshow{
    
    if (basePromotionView != nil) {
        
        view_Promotion.frame = CGRectMake((APPFULLWIDTH-300)/2, APPFULLHEIGHT, 300, 135+45);
        
        // 20160726 parksegun 앱크래시 수집 정보에 따른 수정
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(promovshowDidMain1)];
        
        view_Promotion.frame = CGRectMake((APPFULLWIDTH-300)/2, APPFULLHEIGHT-(135+45 + 80), 300, 135+45);
        [UIView commitAnimations];
    }
}


- (void)promovshowDidMain1 {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(promovshowDidMain2)];
        view_Promotion.transform = CGAffineTransformMakeTranslation(0.0f, 10.0f);
        [UIView commitAnimations];
    });
    
}

- (void)promovshowDidMain2 {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        view_Promotion.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
        [UIView commitAnimations];
        
    });
}


//플리커타입 화면 재구성
-(void) ScreenDefineFlickerType {
    
    carousel2.hidden = NO;
    carousel1.hidden = NO;
    wview.hidden = YES;
    
    
    if(carousel2 == nil) {
        
        //UI
        carousel2 = [[iCarousel alloc] initWithFrame:CGRectMake(0.0, STATUSBAR_HEIGHT+kTopSearchBarHeight + kTopCarouselHeight , APPFULLWIDTH, APPFULLHEIGHT-(STATUSBAR_HEIGHT+kTopSearchBarHeight + kTopCarouselHeight))];
        
        carousel2.isAccessibilityElement = NO;
        carousel2.backgroundColor = [UIColor whiteColor];//[Mocha_Util getColor:@"e5e5e5"];
        carousel2.dataSource = self;
        carousel2.delegate = self;
        carousel2.clipsToBounds = YES;
        
        carousel2.type = iCarouselTypeMochaMainStyle;
        carousel2.decelerationRate = 0.40f;
        [self.view addSubview:carousel2];
        
        //탭바 뷰타입
        [self.view bringSubviewToFront:tabBarView];
        
        if((_intmainsection == 0)  || (_intmainsection == [carousel2 currentItemIndex]))
        {
            [carousel2 setCurrentItemIndex:-1];
        }
    }
    
    if(carousel1 == nil) {
        //UI
        /*
        carousel1 = [[iScroll alloc] initWithFrame:CGRectMake(0.0, 20.0 + kTopSearchBarHeight, tabPrsnlWidth, kTopCarouselHeight)];
        carousel1.dataSource = self;
        carousel1.delegate = self;
        
        
        carousel1.type = iScrollTypeLinear;
        carousel1.decelerationRate = 0.80f;
        [self.view addSubview:carousel1];

        UIView *line = [[UIView alloc]  initWithFrame:CGRectMake(0.0, kTopCarouselHeight-1.0f, APPFULLWIDTH, 1.0f)];
        line.backgroundColor = [Mocha_Util getColor:@"e6e6e6"];
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [carousel1 addSubview:line];
        [carousel1 sendSubviewToBack:line];
        */
        [self setupCarousel1];
    }
    
    //2016/12 사이드매뉴 도입으로인한 하단탭바 비노출처리
    //[self expandContentView:0 scrollView:nil];
    
    return;
    
    
    
    
}

-(void)ClickPromotionPopupBtn:(NSNumber*)sendernum {
    
    isPromotionViewAdded = NO;
    
    NSLog(@"btntag: %d", [sendernum intValue]);
    switch ([sendernum intValue])  {
            
            //링크 클릭
        case 1:
            
            
            if([NCS([_promotionInfoDic objectForKey:@"linktype"]) isEqualToString:@"L"]){
                
                if(NCO([_promotionInfoDic objectForKey:@"link"])){
                    //아래 rootViewController로 돌아간후 ResultView pushview 하는 이유는 디토앱에서 들어올경우 대비
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    
                    
                    ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:[_promotionInfoDic objectForKey:@"link"]   ];
                    result.delegate = self;
                    result.view.tag = 503;
                    [DataManager sharedManager].selectTab = 0;
                    [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
                    
                    NSString* tgs= [NSString stringWithFormat:@"%@_%@", [_promotionInfoDic valueForKey:@"bannertype"],[_promotionInfoDic valueForKey:@"link"] ];
                    
                    [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_App_main_popup_click" withLabel:tgs     ];
                    
                }
                
            }else {
                
                //SCHEMA or EXTERNAL_LINK
                if([_promotionInfoDic objectForKey:@"link"]  != nil){
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[_promotionInfoDic objectForKey:@"link"] ]];
                    
                    NSString* tgs= [NSString stringWithFormat:@"%@_%@", [_promotionInfoDic valueForKey:@"bannertype"],[_promotionInfoDic valueForKey:@"link"] ];
                    
                    [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_App_main_popup_click" withLabel:tgs     ];
                }
            }
            
            ApplicationDelegate.isPromotionPopup = YES;
            
            break;
            
        case 2:
            // 오늘 다시 보지 않기 + X 닫기
            ApplicationDelegate.isPromotionPopup = YES;
            
            break;
            
        case 3:
            // X 버튼 클릭
            ApplicationDelegate.isPromotionPopup = YES;
            
            break;
            
        case 4:
            break;
            
        default:
            break;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if([sendernum intValue] != 1) {
        //20160705 parkseugn 3.3.6 oops 수집건 대응: 애니메이션 처리시 Crach 발생
        [UIView animateWithDuration:1.0
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             basePromotionView.alpha = 0.0f;
                         }
         
                         completion:^(BOOL finished){
                             
                             [basePromotionView removeFromSuperview];
                             
                         }];
        
        
    }
    else {
        [basePromotionView removeFromSuperview];
        
    }
    
}

//2018.02.01 푸시수신동의 유도 프로모션 팝업클릭
-(void)ClickPushAgreePopupBtn:(NSNumber*)sendernum{
    
    if ([sendernum integerValue] == 2) { //취소
        //mseq 쏴라
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415590")];

        
        SL([NSDate date], PROMOTIONPOPUP_PUSHAGREE_NO7DAY);
        
        /*
        NSString *strMessage = [NSString stringWithFormat:@"%@",GSSLocalizedString(@"app_push_one_more_recommend_text")];
        Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strMessage maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"app_push_one_more_recommend_no"),GSSLocalizedString(@"app_push_one_more_recommend_yes"), nil]];
        malert.tag = 666;
        
        [ApplicationDelegate.window addSubview:malert];
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415591")];
        */
        
        
        
        
        
    }else if ([sendernum integerValue] == 3) { //확인
        //mseq 쏴라
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415589")];
        [ApplicationDelegate FirstAppsettingWithOptinFlag:YES withResultAlert:NO];
        if(![Mocha_Util ispushalertoptionenable])
        {
            [ApplicationDelegate showPushCheckAlert:@"SYSSETPUSH"];
        }
    }
    

    [UIView animateWithDuration:0.0
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         basePromotionView.alpha = 0.0f;
                     }
     
                     completion:^(BOOL finished){
                         
                         [basePromotionView removeFromSuperview];
                         
                     }];
}

-(void)ClickPersonalPopupBtn:(NSNumber*)sendernum{

    NSLog(@"dicPersonalPopupdicPersonalPopup = %@",dicPersonalPopup);
    
    
    NSMutableArray *arrNoLook = [[NSMutableArray alloc] init];
    NSString *strSavedSEQ = [dicPersonalPopup objectForKey:PERSONALPOPUP_KEY_DSPLSEQ];
    
    if(LL(PERSONALPOPUP_ARR_NOLOOK) != nil && [LL(PERSONALPOPUP_ARR_NOLOOK) isKindOfClass:[NSMutableArray class]]) {
        [arrNoLook addObjectsFromArray:LL(PERSONALPOPUP_ARR_NOLOOK)];
    }
    
    
    if ([sendernum integerValue] == 1) { //링크 고고

        //[ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415590")];
        
        if ([arrNoLook count] == 50) {
            [arrNoLook removeLastObject];
        }
        [arrNoLook insertObject:strSavedSEQ atIndex:0];
        
        SL(arrNoLook, PERSONALPOPUP_ARR_NOLOOK);
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        
        ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:[dicPersonalPopup objectForKey:@"linkUrl"]   ];
        result.delegate = self;
        result.view.tag = 503;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        
        
        
    }else if ([sendernum integerValue] == 2) { //다시는 안봄
        
        if ([arrNoLook count] == 50) {
            [arrNoLook removeLastObject];
        }
        [arrNoLook insertObject:strSavedSEQ atIndex:0];
        
        SL(arrNoLook, PERSONALPOPUP_ARR_NOLOOK);
        
        
    }else if ([sendernum integerValue] == 3) { //하루 안봄
        //mseq 쏴라
        //[ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415589")];

        NSMutableDictionary *dicTomorrow = [[NSMutableDictionary alloc] init];
        NSMutableArray *arrTomorrow = [[NSMutableArray alloc] init];
        
        if(LL(PERSONALPOPUP_DIC_TOMORROW) != nil && [LL(PERSONALPOPUP_DIC_TOMORROW) isKindOfClass:[NSMutableDictionary class]]) {
            
            [dicTomorrow addEntriesFromDictionary:LL(PERSONALPOPUP_DIC_TOMORROW)];
            [arrTomorrow addObjectsFromArray:(NSMutableArray *)[dicTomorrow objectForKey:PERSONALPOPUP_KEY_ARR_DSPLSEQ]];
            
            NSDate *dateSaved =  (NSDate *)[dicTomorrow objectForKey:PERSONALPOPUP_KEY_CONFIRM_DATE];
            
            if ([Common_Util ShowPersonalPopupWithCloseDate:dateSaved]) {
                [arrTomorrow removeAllObjects];
            }
            
        }
        
        
        NSDate *dateClosed = [NSDate date];
        
        [arrTomorrow insertObject:strSavedSEQ atIndex:0];
        
        [dicTomorrow setObject:dateClosed forKey:PERSONALPOPUP_KEY_CONFIRM_DATE];
        [dicTomorrow setObject:arrTomorrow forKey:PERSONALPOPUP_KEY_ARR_DSPLSEQ];
        
        NSLog(@"");
        SL(dicTomorrow, PERSONALPOPUP_DIC_TOMORROW);
        
    }
    
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         basePersonalView.alpha = 0.0f;
                     }
     
                     completion:^(BOOL finished){
                         
                         [basePersonalView removeFromSuperview];
                         
                     }];
    
}

//1웹뷰타입 화면 재구성
-(void) ScreenDefineWebViewType {
    
    wview.hidden=NO;
    
    //viewdidload 호출- 자동로그인 설정시 무조건 통신후 이곳으로 처리요청하므로...
    ApplicationDelegate.isauthing = NO;
    self.view.frame = CGRectMake(0, 0, APPFULLWIDTH, [[UIScreen mainScreen] bounds].size.height-65);
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    
    //[self.wview setScalesPageToFit:TRUE];
    self.wview.frame = CGRectMake(0,kTopBarHeight, APPFULLWIDTH,[[UIScreen mainScreen] bounds].size.height-65-kTopBarHeight);
    
    [(UIScrollView *)[[self.wview subviews] lastObject] setBounces:NO];
    self.wview.navigationDelegate = self;
    self.wview.UIDelegate = self.wview;
    //wview.dataDetectorTypes=UIDataDetectorTypeNone;
    
    [wview setBackgroundColor:[UIColor clearColor]];
    [wview setOpaque:NO];
    
    
    [ApplicationDelegate subViewchangePropertyForScrollsToTop:wview boolval:YES];
    [self webViewReload];
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}




- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"navigationAction.request.URL.absoluteString = %@",navigationAction.request.URL.absoluteString);
    
    NSString *requestString1 = navigationAction.request.URL.absoluteString ;
    BOOL isDecisionAllow = YES;
    
    NSLog(@"요청URL %@", requestString1);
    //20160913 parkseugn - hasSuffix 에서 예외 발생에 대한 대응 처리
    if(isDecisionAllow == YES && NCS(requestString1).length <= 0) {
        isDecisionAllow = NO;
    }
    
    //iOS7 대응
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"gsshopmobile://"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://movemessage"]) {
        [ApplicationDelegate pressShowPMSLISTBOX];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://eventrecv"]) {
        NSString* tstring = [Mocha_Util strReplace:@"toapp://eventrecv?" replace:@"" string:requestString1];
        NSLog(@"etvURL: %@", [NSString stringWithFormat:@"%@&devId=%@",tstring,DEVICEUUID]);
        NSURL *evtURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@&devId=%@",tstring,DEVICEUUID]];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:evtURL];
        [self.wview loadRequest:requestObj];
        isDecisionAllow = NO;
    }
    
    
    // start 2012.12.20 외부 safari 웹브라우저로 띄우기 start
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://browser"]) {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"browser?"];
        NSString *toquery = [livetv lastObject];
        
        if([toquery length] == NO) {
            NSLog(@"None URL... Go Homepage");
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else {
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.12.20 외부 safari 웹브라우저로 띄우기 end
    
    // start 2012.10.23 외부 safari 웹브라우저로 띄우기 start   (http 및 url schema대응)
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toweb://"]) {
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"toweb://"];
        NSString *toquery = [livetv lastObject];
        
        NSLog(@"toweb_query = %@",toquery);
        if([toquery length] == NO) {
            NSLog(@"None URL... Go Homepage");
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:SERVERURI]];
        }
        else {
            //http:// 가 있을경우 http//로 들어옴 http링크의경우만 수정, url schema 호출의경우 http 영향없음.
            toquery = [Mocha_Util strReplace:@"//" replace:@"://" string:toquery];
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[NSString stringWithFormat:@"%@",toquery]]];
        }
        isDecisionAllow = NO;
    }
    // end 2012.02.20 내장 웹브라우저로 띄우기 end
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"ispmobile://"]) {//isp 결제 주소
        NSURL *appUrl = [NSURL URLWithString:requestString1];
        BOOL isInstalled =[[UIApplication sharedApplication] openURL_GS:appUrl];
        if(isInstalled) {
            NSLog(@"ispmobile");
            [DataManager sharedManager].selectTab = 0;
        }
        else {
            NSURL *videoURL = [NSURL URLWithString:GSISPFAILBACKURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL];
            [self.wview loadRequest:requestObj];
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:GSISPDOWNURL]];
        }
        isDecisionAllow = NO;
    }
    
    // start 2012.02.09 신한안심클릭 추가 start
    //------------------------------------------------------------------------------
    if(isDecisionAllow == YES && [requestString1 isEqualToString:SHINHANDOWNURL] == YES) {
        NSLog(@"1.스마트신한 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:SHINHANAPPNAME]) {
        NSLog(@"2.스마트신한 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    // end 2012.02.09 신한안심클릭 추가 end
    
    // start 2013.09.10 신한Mobile 앱 다운로드 url start
    //------------------------------------------------------------------------------
    if (isDecisionAllow == YES && [requestString1 isEqualToString:SHINHANMAPPDOWNURL] == YES ) {
        NSLog(@"1. 스마트신한앱 관련 url 입니다. ==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    if (isDecisionAllow == YES && [requestString1 hasPrefix:SHINHANAPPCARDAPPNAME]) {
        NSLog(@"2. 신한Mobile결제 앱 관련 url 입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    // end 2013.09.10 신한Mobile 앱 다운로드 url end
    
    //start 2012.06.25 현대 안심 클릭 url start
    //------------------------------------------------------------------------------
    if(isDecisionAllow == YES && [requestString1 isEqualToString:HYUNDAIDOWNURL] == YES) {
        NSLog(@"현대안심클릭 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    if(isDecisionAllow == YES && [requestString1 hasPrefix:HYUNDAIAPPNAME]) {
        NSLog(@"2.현대안심클릭 관련 url입니다.==>%@",requestString1);
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    //------------------------------------------------------------------------------
    //end 2012.06.25 현대 안심 클릭 url end
    
    
    
    
    //VOD영상 재생 - 20130102   + 딜상품 VOD영상 재생 - 20130226 + 기본 VOD영상재생(버튼overlay없음) 20150211
    if(isDecisionAllow == YES &&  (([requestString1 hasPrefix:@"toapp://vod?url="]) || ([requestString1 hasPrefix:@"toapp://dealvod?url="]) || ([requestString1 hasPrefix:@"toapp://basevod?url="]))) {//vod 방송
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestVODVideo:requestString1];
        }
        else {
            self.curRequestString = [NSString stringWithString:requestString1];
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 888;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow =  NO;
    }
    
    
    //생방송
    if(isDecisionAllow == YES && (([requestString1 hasPrefix:@"toapp://liveBroadUrl?param="]) ||([requestString1 hasPrefix:@"toApp://liveBroadUrl?param="]))) { //live 방송
        NSArray *livetv = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query3 = [livetv lastObject];
        if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
            [self playrequestLiveVideo:query3];
        }
        else {
            self.curRequestString = [NSString stringWithString:query3];
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                   DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
            malert.tag = 777;
            [ApplicationDelegate.window addSubview:malert];
        }
        isDecisionAllow =  NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://back"]) {//웹에서 앱으로 백하는 버튼 클릭시
        //2.1.1.1 2.1.0.1 미반영부분 return NO 처리 필요.
        NSURL *goURL = [NSURL URLWithString:GSMAINURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
        [self.wview loadRequest:requestObj];
        isDecisionAllow =  NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"toapp://modal"] ) {
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"modal?"];
        NSString *query2 = (comp1.count > 1)?[comp1 objectAtIndex:1]:@"";
        NSLog(@"prdid = %@",query2);
        
        //간편주문
        if([query2 hasPrefix:[NSString stringWithFormat:@"%@/mobile/cert",SERVERURI]] && !ApplicationDelegate.islogin ) {
            FullWebViewController *result = [[FullWebViewController alloc]initWithUrlString:self tgurl:query2];
            result.view.tag = 505;
            [DataManager sharedManager].selectTab = 0;
            [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        }
        isDecisionAllow =  NO;
    }
    
    //로그인이 필요한 페이지는 로그인을 하고 페이지를 넘긴다.
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGINCHECKURL]) {
        //웹뷰가 toapp://login 호출할경우 기존에 로그인이 되어있으면 API로그아웃이 "아닌" APPJS 방식 로그아웃 호출
        if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin)) {
            NSError *err = [NSError errorWithDomain:@"app_Login_Abnormal_operation" code:9000 userInfo:nil];
            NSString *msg = [[NSString alloc] initWithFormat:@"앱로그인 상태에서 toapp://login 호출됨: home_Main_View 자동로그인인가? %@, requestString1 %@", ([DataManager sharedManager].m_loginData.autologin == 1 ? @"YES" : @"NO"),requestString1  ];
            [ApplicationDelegate SendExceptionLog:err msg: msg];
            return;
        }
        
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = ([comp1 count] > 1) ?[comp1 objectAtIndex:1]:@"";
        if([query2 isEqualToString:@""]) {
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
        }
        else {
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
        if([Mocha_Util strContain:@"isAdult=Y" srcstring:requestString1]) {
            loginView.loginViewMode = 2;
        }
        else if([Mocha_Util strContain:@"isPrdOrder=Y" srcstring:requestString1]) {
            loginView.loginViewMode = 1;
        }
        else {
            loginView.loginViewMode = 0;
        }
        
        loginView.view.hidden=NO;
        loginView.btn_naviBack.hidden = NO;
        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
        //20170615점유인증 & 회원 간소화
        if([Mocha_Util strContain:@"msg=" srcstring:requestString1]) {
            NSArray *msgTemp = [requestString1 componentsSeparatedByString:@"msg="];
            if( [msgTemp count] > 1 ) {
                NSArray *idTemp = [NCS([msgTemp objectAtIndex:1]) componentsSeparatedByString:@"&"];
                if( [idTemp count] > 0) {
                    loginView.textFieldId.text = NCS([idTemp objectAtIndex:0]);
                }
            }
        }
        isDecisionAllow = NO;
    }
    
    //로그아웃 요청URL
    if(isDecisionAllow == YES && [requestString1 hasPrefix:GSLOGOUTTOAPPURL]) {
        NSArray *comp1 = [requestString1 componentsSeparatedByString:@"param="];
        NSString *query2 = (comp1.count > 1) ?[comp1 objectAtIndex:1]:@"";
        if([query2 isEqualToString:@""]) {
            self.curRequestString = [NSString stringWithFormat:@"gsshopmobile://home"];
        }
        else {
            self.curRequestString = [NSString stringWithString:query2];
        }
        
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:LOGOUTALERTALSTR  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:LOGOUTCONFIRMSTR1,  LOGOUTCONFIRMSTR2, nil]];
        malert.tag = 444;
        [ApplicationDelegate.window addSubview:malert];
        isDecisionAllow = NO;
    }
    
    // -- start -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- start --
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"tel:"]) {
        NSString *tstring = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:requestString1];
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:tstring] ];
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"mailto:"]) {
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:requestString1]];
        isDecisionAllow = NO;
    }
    // -- end -- 2012.04.03 전화 이메일 실행 안되는 현상 수정. -- end --
    
    if(isDecisionAllow == YES && [requestString1 hasPrefix:@"about:blank"]) { //공백페이지
        isDecisionAllow = NO;
    }
    
    if(isDecisionAllow == YES && (([requestString1 isEqualToString:[NSString stringWithFormat:@"%@/index.gs#",SERVERURI]]) ||([requestString1 isEqualToString:[NSString stringWithFormat:@"%@/index.gs",SERVERURI]])||([requestString1 isEqualToString:[NSString stringWithFormat:@"%@/index.gs?",SERVERURI]]) ||([requestString1 isEqualToString:[NSString stringWithFormat:@"%@",WISELOGGSMAINURL]]) ||([requestString1 isEqualToString:[NSString stringWithFormat:@"%@/mobile/cookieset.jsp",SERVERURI]])  )){
        //2018.01.04 꼭 배포
        isDecisionAllow = NO;
    }
    else if(isDecisionAllow == YES && [Mocha_Util strContain:@"holdpage" srcstring:requestString1]) {
        
    }
    else if(isDecisionAllow == YES && [Mocha_Util strContain:@"#theme" srcstring:requestString1]) {
        
    } //google 통계 url 화면 전환 예외처리 20131205
    else if(isDecisionAllow == YES && [Mocha_Util strContain:@"google" srcstring:requestString1]) {
        
    } //api.recopick.com 통계 url 화면 전환 예외처리 20140115
    else if(isDecisionAllow == YES && [Mocha_Util strContain:@"api.recopick.com" srcstring:requestString1]) {
        
    } //criteo.com 통계 url 화면 전환 예외처리 20140115
    else if(isDecisionAllow == YES && [Mocha_Util strContain:@"criteo.com" srcstring:requestString1]) {
        
    }
    else  if(isDecisionAllow == YES && [requestString1 hasSuffix:@"#top"]) {
        
    }
    else  if(isDecisionAllow == YES && [requestString1 hasSuffix:@"#pageTop1"]) {
        
    }
    else if(isDecisionAllow == YES && [Mocha_Util strContain:@"mcMainSection1" srcstring:requestString1]) {
        
    }
    else {
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:requestString1];
        result.delegate = self;
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
        //iOS7 에서 return NO 아닌경우 이후진행에 문제 발생. 이전버전과 다른동작 - 20130612 shawn
        isDecisionAllow = NO;
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
    if(_curmaintype == CURMAINVIEWTYPEWEBMAIN) {
        if(ApplicationDelegate.appfirstLoading == NO) {  dispatch_async(dispatch_get_main_queue(),^{
            [ApplicationDelegate.gactivityIndicator startAnimating];
        });
        }
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(ApplicationDelegate.appfirstLoading == YES) {
        ApplicationDelegate.appfirstLoading = NO;
        NSLog(@"<webViewDidFinishLoad loadingDone>");
        [ApplicationDelegate loadingDone];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
        NSLog(@"-====== %@", [NSString stringWithFormat:@"%@",webView.URL]);
    }
    else {
        [ApplicationDelegate.gactivityIndicator stopAnimating];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"");
    
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(ApplicationDelegate.appfirstLoading == YES) {
        ApplicationDelegate.appfirstLoading = NO;
        NSLog(@"<webViewDidFinishLoad loadingDone>");
        [ApplicationDelegate loadingDone];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
        NSLog(@"-====== %@", [NSString stringWithFormat:@"%@",wview.URL]);
    }
    else {
        [ApplicationDelegate.gactivityIndicator stopAnimating];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"");
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    if (!(([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
          ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102))) {
        if(error.code != 101) {
            if(![ApplicationDelegate isthereMochaAlertView]){
                Mocha_Alert *malert = [[Mocha_Alert alloc] initWithTitle:GNET_UNSTABLE maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                [ApplicationDelegate.window addSubview:malert];
            }
        }
    }
}



//isp 처리후 다시 넘어 왔을때 넘어온 주소를 가지고 웹뷰로 다시 넘긴다.
-(void)goWebView:(NSString *)url {
    NSLog(@"gsurl = %@",url);
    NSURL *goURL = [NSURL URLWithString:url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
    [self.wview loadRequest:requestObj];
}

- (NSString*) definecurrentUrlString {
    return self.curRequestString;
}

- (void) hideLoginViewController:(NSInteger)loginviewtype {
    if(loginviewtype == 4) {//로그인후
        if(_curmaintype == CURMAINVIEWTYPEAPPMAIN) {
            //찜 등록
            if (self.favoriteProductInfo) {
                [self registerFavoriteProduct:self.favoriteProductInfo];
                self.favoriteProductInfo = nil;
            }
            else {
                [self performSelector:@selector(delayGoWebviewWithcurRequestString) withObject:nil afterDelay:1.0f];
            }
        }
        else {
            NSLog(@"1111self.curRequestString = %@", self.curRequestString);
            NSURL *goURL = [NSURL URLWithString:GSMAINURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
            [self.wview loadRequest:requestObj];
        }
    }
    else if(loginviewtype == 6) {
        //비회원배송조회
        NSURL *videoURL = [NSURL URLWithString: NONMEMBERORDERLISTURL(self.curRequestString)];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        [wview loadRequest:requestObj];
    }
    else if(loginviewtype == 7) {
        NSURL *videoURL = [NSURL URLWithString:NONMEMBERORDERURL(self.curRequestString)];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:videoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
        [wview loadRequest:requestObj];
    }
    else if(loginviewtype == 33) {
        [ApplicationDelegate.mainNVC popToRootViewControllerAnimated:NO];
        if([ApplicationDelegate.HMV respondsToSelector:@selector(firstProc)]){
            [ApplicationDelegate.HMV firstProc];
        }
    }
    else {
        //로그아웃  loginviewtype == 5 인경우
        //단순 reload 하는 경우 무한루프빠짐.
        if(_curmaintype == CURMAINVIEWTYPEAPPMAIN) {
        }
        else {
            NSLog(@"1111self.curRequestString = %@", self.curRequestString);
            NSURL *goURL = [NSURL URLWithString:GSMAINURL];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:kWebviewTimeoutinterval ];
            [wview loadRequest:requestObj];
        }
    }
}

//로그인 처리 이후 딜레이 필요
- (void)delayGoWebviewWithcurRequestString {
    ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:self.curRequestString];
    result.delegate = self;
    result.view.tag = 505;
    [self.navigationController  pushViewControllerMoveInFromBottom:result];
}

- (void)goJoinPage {
    NSURL *goURL = [NSURL URLWithString:JOINURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
    [self.wview loadRequest:requestObj];
}

- (IBAction)wvReload:(id)sender {
    if(_curmaintype == CURMAINVIEWTYPEWEBMAIN) {
        NSURL *goURL = [NSURL URLWithString:GSMAINURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:goURL];
        [self.wview loadRequest:requestObj];
    }
    else {
        if(carousel1 != nil) {
            //2016/12 사이드매뉴 도입으로인한 하단탭바 비노출처리
            [self expandContentView:-900 scrollView:nil];
        }
        [self textFieldCancel];
        //20160107 상단 홈버튼만 A00000으로 동작하도록 변경
        if(sender != nil) {
            ////탭바제거
            [ApplicationDelegate wiseCommonLogRequest: WISELOGCOMMONURL(@"?mseq=A00000")];
        }
        [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_Main_Top_Logo" withLabel:@"Click"];
        if([[[self.sectionUIitem objectAtIndex:_intmainsection] objectForKey:@"wiseLogUrl"] isKindOfClass:[NSNull class]] == NO) {
            [ApplicationDelegate wiseAPPLogRequest:[[self.sectionUIitem objectAtIndex:_intmainsection] objectForKey:@"wiseLogUrl"]];
        }
        //메모리 캐시 날려버림
        //why? 상단 홈버튼 누르면 캐시타면 안됨.
        [[UrlSessionCache sharedInstance] deleteAllMemory];
        [self firstProc];
    }
}

//가려젓다가 다시 나타 났을때 호출
- (void)webViewReload {
    NSLog(@"Reload Main Home Webview");
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
                
                NSLog(@"self.curRequestString = %@", self.curRequestString);
                //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                if(loginView == nil) {
                    loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                }else{
                    [loginView clearTextFields];
                }
                
                loginView.delegate = self;
                loginView.loginViewType = 5;
                //로그아웃  콜~
                
                loginView.isLogining = YES;
                [loginView goLogin];
                loginView.view.hidden=YES;
                
                
                
                
                break;
            default:
                break;
        }
    }
    //2018.02.01 푸시수신동의 유도 프로모션 팝업
    else if(alert.tag == 666) {
        switch (index) {
            case 1:
                NSLog(@"좋아요");
                //mseq 쏴라
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415592")];
                [ApplicationDelegate FirstAppsettingWithOptinFlag:YES withResultAlert:NO];
                if(![Mocha_Util ispushalertoptionenable])
                {
                    [ApplicationDelegate showPushCheckAlert:@"SYSSETPUSH"];
                }
                break;
            default:
                NSLog(@"아니용");
                //mseq 쏘고 하루 저장
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415593")];
                SL([NSDate date], PROMOTIONPOPUP_PUSHAGREE_NO7DAY);
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
                break;
        }
    }
    
    //
    else if(alert.tag == 21000) {
        [self changeCategoryTab:_currentCategory sectionTab:1 animated:YES];
    }
    
    //
    else if(alert.tag == 22000) {
        switch (index) {
            case 1:
                //찜으로 이동하기
                [self moveToFavoritePage];
                break;
            default:
                break;
        }
    }
    
    else if (alert.tag ==447){
        [schTextField becomeFirstResponder];
        
        [self textFieldEditStart:schTextField];
        
    }
    
    
    
    //통신불능 - 종료
    if(alert.tag == 555) {
        switch (index) {
            case 0:
                
                //                // nami0342 - 네비게이션 API 2번 호출 실패 시 서버 점검중인지 판단하는 로직을 태워 점검중일 경우 팝업을 노출한다.
                //                if([ApplicationDelegate isServerDown] == YES)
                //                {
                //                    // Server Down 이므로 점검중 팝업이 뜰 것이므로 따로 동작을 안 한다.
                //                }
                //                else
                //                {
                // Navigation API에서 요청을 2번 실패했으므로 앱 종료로 진행. (일반적인 네크워크 에러일 수 있음)
                exit(1);
                //                }
                break;
            default:
                break;
        }
    }
    
    
    
    
}





//MODAL관련
-(void)appModalReAction:(NSString*)tgurl{
    
    ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:tgurl];
    result.delegate = self;
    result.view.tag = 503;
    [DataManager sharedManager].selectTab = 0;
    [self.navigationController  pushViewController:result animated:NO];//url을 웹뷰로 보여줌
    
}


-(void)appModalLogin{
    self.curRequestString = [NSString stringWithString:GSMAINURL];
    NSLog(@"self.curRequestString = %@", self.curRequestString);
    //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
    if(loginView == nil) {
        loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
    }else{
        [loginView clearTextFields];
    }
    
    loginView.delegate = self;
    loginView.loginViewType = 4;
    
    
    if([[DataManager sharedManager].loginYN isEqualToString:@"Y"] && (ApplicationDelegate.islogin))
    {
        //로그아웃  콜~
        loginView.isLogining = YES;
        [loginView goLogin];
        loginView.view.hidden=YES;
    }
    else
    {
        loginView.view.hidden=NO;
        loginView.btn_naviBack.hidden = NO;
        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
        
    }
    
}






//생방송 재생
-(void)playrequestLiveVideo: (NSString*)requrl {
    
    
    //생방송 영상
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:nil];
    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    
    [vc playMovie:[NSURL URLWithString:requrl]];
    
}


//단품 VOD 재생
-(void)playrequestVODVideo:(NSString*)requrl   {
    
    
    
    URLParser *parser = [[URLParser alloc] initWithURLString:requrl];
    
    
    Mocha_MPViewController * vc = [[Mocha_MPViewController alloc] initWithTargetid:self tgstr:requrl];
    
    if ([NCS(self.curVODGoProductWiseLog) length] > 0) {
        vc.strGoProuctWiseLog = [self.curVODGoProductWiseLog copy];
        self.curVODGoProductWiseLog = nil;
    }

    vc.modalPresentationStyle =UIModalPresentationOverFullScreen;
    
    
    [ApplicationDelegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    
    
    
    if ([Mocha_Util strContain:@"videoid" srcstring:requrl] && [NCS([parser valueForVariable:@"videoid"]) length] > 4 ) {
        NSLog(@"videoid: %@",[parser valueForVariable:@"videoid"]);
        [vc playBrightCoveWithID:NCS([parser valueForVariable:@"videoid"])];
    }else{
        [vc playMovie:[NSURL URLWithString:[parser valueForVariable:@"url"]]];
    }
    
    
    
}





#pragma mark -
#pragma mark iCarosel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.sectionUIitem count];
}

- (UIView *)carousel:(iScroll *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH,APPFULLHEIGHT - STATUSBAR_HEIGHT - kTopSearchBarHeight - kTopCarouselHeight)];
        view.backgroundColor = [UIColor clearColor];
        view.opaque = YES;
    }
    
    return view;
}

- (CGFloat)carousel:(iScroll *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionVisibleItems:
            return [sectionUIitem count];
        default:
            return value;
    }
}

//클릭
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    //2019/09/26메인탭 무한루프
//    if(carousel == carousel1) {
//        [carousel2 scrollToItemAtIndex:index animated:NO];
//    }
}

- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carousel {

    //홈 카테고리
    if (_currentCategory == 0) {
//        NSLog(@"wisewebdummylog %@, %s 남바",[[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"wiseLogUrl"] , __FUNCTION__  );
        //더미로그
        
        if( isFirstSectionLoading == YES) {
            isFirstSectionLoading = NO;
        }
        else {
            if([[[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"wiseLogUrl"] isKindOfClass:[NSNull class]] == NO) {
                NSString __block *apiURL = [[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"wiseLogUrl"];
                if ([NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"sectionCode"]) isEqualToString:SECTIONCODE_HOME]) { //베딜일 경우에만 딱한번 진희대리가 컨펌했음
                    
                    static dispatch_once_t onceAppstart;
                    dispatch_once(&onceAppstart, ^{
                        //SHOPSTART_URL 삭제 20151029
                        apiURL = [NSString stringWithFormat:@"%@%@", apiURL, ([apiURL hasSuffix:@"&"]==NO)?@"&appstart=Y":@"appstart=Y" ];
                    });
                }
                ////탭바제거

                if(ApplicationDelegate.isGsshopmobile_TabIdFlag == NO ) {
                    NSLog (@"kiwon : carouselCurrentItemIndexUpdated - isGsshopmobile_TabIdFlag NO - wiseAPPLogRequest");
                    [ApplicationDelegate wiseAPPLogRequest:apiURL];
                    
                }
                
                ///tabid호출 조건이면 와이즈로그를 호출하지 않는다. (아마 처음 한번만)
                if (ApplicationDelegate.isGsshopmobile_TabIdFlag && NCS(self.tabIdByTabId).length > 0) {
                    if ([NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"navigationId"]) isEqualToString:NCS(self.tabIdByTabId)]) { //lseq가 있을경우에만
                        
                        //2019.06.24 회의때 lseq 처리는 웹뷰에서 넘어온 값만 처리하도록 합의 임매니저님 컨펌
                        NSString *strLseq = [NCS(self.tabIdByAddParam) copy];
                        apiURL = [NSString stringWithFormat:@"%@%@", apiURL,strLseq ];
                        self.tabIdByAddParam = @"";
                        self.tabIdByTabId = @"";
                        NSLog (@"kiwon : carouselCurrentItemIndexUpdated - isGsshopmobile_TabIdFlag YES - wiseAPPLogRequest");
                        [ApplicationDelegate wiseAPPLogRequest:apiURL];
                        ApplicationDelegate.isGsshopmobile_TabIdFlag = NO;
                    }
                }
            }
            
            
            //REST wiselog
            if([[[carousel2 itemViewAtIndex:carousel.currentItemIndex] subviews] count] > 0) {
                NSString* apiURL =  [Mocha_Util strReplace:[NSString stringWithFormat:@"%@/",SERVERURI] replace:@"" string:[[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"sectionLinkUrl"]];
                //SM서버용 대응
                apiURL =  [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
                apiURL =  [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
                apiURL =  [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
                apiURL =  [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
                apiURL =  [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
                
                apiURL =  [Mocha_Util strReplace:@"http://dm13.gsshop.com/" replace:@"" string:apiURL];
                apiURL =  [Mocha_Util strReplace:@"http://sm15.gsshop.com/" replace:@"" string:apiURL];
                if ([NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"sectionLinkParams"]) length] > 0) {
                    apiURL = [NSString stringWithFormat:@"%@?%@%@%@",
                              apiURL,
                              [[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"sectionLinkParams"],
                              @"&reorder=false",
                              ABTESTBULLETVERSTR([DataManager sharedManager].abBulletVer)];
                }
                else {
                    apiURL = [NSString stringWithFormat:@"%@?%@%@", apiURL, @"reorder=false",ABTESTBULLETVERSTR([DataManager sharedManager].abBulletVer)];
                }
                NSLog(@"wisereorderfalselog  %@",  apiURL);
                ////탭바제거
                [ApplicationDelegate wiseLogRestRequest:apiURL];
            }
            
            
            
            //상단sub섹션 gtm 홈매장
            @try {
                NSDictionary *groupInfo = [self.sectionUIitem objectAtIndex:carousel2.currentItemIndex];
                NSLog(@"tgrrp1 info: %@ == %@",groupInfo, [NSString stringWithFormat:@"2depth_%@", [groupInfo objectForKey:@"sectionName"]] );
                [ApplicationDelegate GTMscreenOpenSendLog:[groupInfo objectForKey:@"sectionName"]];
                [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_2depth" withLabel:[groupInfo objectForKey:@"sectionName"]  ];
                //Amplitude
                NSString *eventString = [NSString stringWithFormat:@"View-메인매장-%@",NCS([groupInfo objectForKey:@"sectionName"])];
                //[ApplicationDelegate setAmplitudeEvent:eventString];
                
                NSDictionary *dicProp = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"cateName", nil];
                [ApplicationDelegate setAmplitudeEventWithProperties:eventString properties:dicProp];
                
                
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"GTM top subsection TAB TAGGING ERROR : %@", exception);
            }
        }
    }
}


-(void)latelysetscrollstotop {
    [self checkScrollsToTopProperty];
}

//하단 컨텐츠 섹션 이동시 상단 메뉴 x offset 실시간 교정을 위한
-(void)carouselMenuItemOffsetDidChange:(UIScrollView *)scrollView {

}


-(void)carouselCurrentItemIndexDidChange:(iScroll *)carousel {
    
    NSLog(@"(long)carousel.currentItemIndex = %ld",(long)carousel.currentItemIndex);
    
    if ([carousel  isKindOfClass:[iCarousel class]]) {
        [self checkViewChangeForDealVideo:NO];
    }
    
    //[self goselectidxCarousel1];
    
    if ((iCarousel *)carousel == carousel2) {
        if([carousel currentItemIndex] == -1) {
            return;
        }
        if(  isingReloadComm == YES ) {
            return;
        }
        
//        if (isMoveFromExt == YES && carousel.currentItemIndex != carousel1.currentIndex) {
//            return;
//        }
        
        //2016/12 사이드매뉴 도입으로인한 하단탭바 비노출처리
        //2020/01 탭 이동시 상단GNB,하단 탭바 상태유지 안드와 맞춤
        //[self expandContentView:-900 scrollView:(UIScrollView*)carousel2 animating:NO];
        
        if([[[carousel itemViewAtIndex:carousel.currentItemIndex] subviews] count] < 1) {

            isingReloadComm = YES;
            dispatch_queue_t dqueue = dispatch_queue_create("mainprocs", NULL);
            dispatch_semaphore_t exeSignal = dispatch_semaphore_create(1);
            dispatch_async(dqueue, ^{
                dispatch_semaphore_wait(exeSignal, DISPATCH_TIME_FOREVER);
                NSLog(@"GCD: PROC1 START");
                dispatch_sync(dispatch_get_main_queue(), ^{
                    SectionView  *tview;
                    if (_currentCategory == 0) {
                        NSLog(@"비타입 %@", [[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] objectForKey:@"viewType"]    );
                        NSLog(@"sectionLinkUrl = %@",[[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] objectForKey:@"sectionLinkUrl"]);
                        NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] objectForKey:@"viewType"]);
                        if([viewType length] > 0 ) {
                            //TV쇼핑
                            if([viewType isEqualToString:HOMESECTTDCLIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeTVShop];
                            }
                            //플랙서블
                            else if([viewType isEqualToString:HOMESECTFXCLIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeFlexible];
                            }
                            //이벤트 개편 HOMESECTEILIST
                            else if([viewType isEqualToString:HOMESECTEILIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeNewEvent];
                            }
                            // 20.06.05 kiwon : 이벤트 UI개편 HOMESECTEFXCLIST
                            else if([viewType isEqualToString:HOMESECTEFXCLIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeNewFlexible];
                            }
                            //날방 개편 HOMESECTNTCLIST => 숏방으로 변경 => 다시 날방으로 변경
                            else if([viewType isEqualToString:HOMESECTNTCLIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeNalbang];
                            }
                            //편성표 매장 추가
                            else if([viewType isEqualToString:HOMESECTSLIST]) {
                                if([NCS(self.tabIdBysubCategoryName) length] <= 0) {
                                    tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeSchedule];
                                }
                                else {
                                    // broadType이 있다면
                                    tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeSchedule subCategory:self.tabIdBysubCategoryName];
                                    self.tabIdBysubCategoryName = @"";
                                }
                            }
                            //GS SUPER 매장 추가
                            else if([viewType isEqualToString:HOMESECTSUPLIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeSUPList];
                                [tview performSelector:@selector(SectionViewAppear) withObject:nil afterDelay:0.1];
                            }
                            //내일TV VOD매장 추가
                            else if([viewType isEqualToString:HOMESECTVODLIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeVODList];
                                [tview performSelector:@selector(SectionViewAppear) withObject:nil afterDelay:1.0];
                            }
                            //초이스 매장 NFXCLIST
                            else if([viewType isEqualToString:HOMESECTNFXCLIST]) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex] withType:(SectionViewType)SectionViewTypeNewFlexible];
                                
                            }
                            else {
                                tview = [[SectionView alloc] initWithTargetdic:[self.sectionUIitem objectAtIndex:carousel.currentItemIndex]];
                            }
                        }
                    }
                    else {
                        
                    }
                    tview.delegatetarget = (id)self;
                    tview.tag = 9999;
                    [[carousel2 itemViewAtIndex:carousel.currentItemIndex] addSubview: tview];
                    //in-call 스테이터스바 확장 대응 2016.01 yunsang.jin
                    tview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
                    tview.frame = tview.superview.bounds;
                    NSLog(@"footer check  tview.frame = %@",NSStringFromCGRect(tview.frame));
                    NSLog(@"footer check  tview.superview.bounds = %@",NSStringFromCGRect(tview.superview.bounds));
                    [self modifyCarouselViewSetting:carousel2 content:tview];
                    NSLog(@"footer check  tview.frame = %@",NSStringFromCGRect(tview.frame));
                    NSLog(@"footer check  tview.superview.bounds = %@",NSStringFromCGRect(tview.superview.bounds));
                    NSLog(@"GCD: PROC1 END");
                    isingReloadComm = NO;
                    [self checkPersonalPopup];
                    dispatch_semaphore_signal(exeSignal);
                });
            });

        }
        else {
            /* 필터복원 20141208 */
            //viewappear  처리
            
            // 편성표 갱신 처리
            SectionView * sectionView = (SectionView*)[[[carousel itemViewAtIndex:carousel.currentItemIndex] subviews] objectAtIndex:0];
            
            // nami0342 - 스와이프로 이동했을 경우 해당 매장이 네트워크 접속불가 화면일 경우 갱신처리
            UIView *RefreshView = [sectionView viewWithTag:TBREFRESHBTNVIEW_TAG];
            if(RefreshView != nil)
            {
                if([NetworkManager.shared currentReachabilityStatus] != NetworkReachabilityStatusNotReachable)
                {
                    if([sectionView canPerformAction:@selector(ScreenReDefine) withSender:nil] == YES)
                    {
                        [sectionView performSelectorOnMainThread:@selector(ScreenReDefine) withObject:nil waitUntilDone:NO];
                    }
                }
            }
            
            
            if([[[carousel itemViewAtIndex:carousel.currentItemIndex] subviews] count] > 0 && [ [NSString stringWithFormat:@"%s", object_getClassName(sectionView)] isEqualToString:@"SectionView"]) {
                if(sectionView.sectionViewType == SectionViewTypeSchedule) {
                    if(self.tabIdBysubCategoryName.length > 0) {
                        [sectionView performSelectorOnMainThread:@selector(SectionViewAppear:) withObject:self.tabIdBysubCategoryName waitUntilDone:NO];
                        self.tabIdBysubCategoryName = @"";
                    }
                    else {
                        [sectionView performSelectorOnMainThread:@selector(SectionViewAppear) withObject:nil waitUntilDone:NO];
                    }
                }
                else {
                    [sectionView performSelectorOnMainThread:@selector(SectionViewAppear) withObject:nil waitUntilDone:NO];
                }
            }
            [self checkPersonalPopup];
            
            [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(delayedNextTab) userInfo:nil repeats:NO];
        }
        [self checkScrollsToTopProperty];
        if (isMoveFromExt == NO) {
            [carousel1 scrollToButtonIndex:carousel2.currentItemIndex animated:YES];
            idxPrevCarousel1 =carousel2.currentItemIndex;
        }
        
    }
    
    // nami0342 - Appboy - tab을 클릭이던, 슬라이드던 이동하면, event 전달 + 매장 Id
    if(NCO([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"navigationId"])) {
        
        // nami0342 - CSP
        [ApplicationDelegate CSP_JoinWithTabID:NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"navigationId"])];
        
        
        if(isFirstAppboylog == NO) {
            isFirstAppboylog = YES;
        }
        else {
            NSDictionary *dicAppboy = [NSDictionary dictionaryWithObjectsAndKeys:[[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"navigationId"], @"navigationId", nil];
            [[Appboy sharedInstance] logCustomEvent:@"store_transfer" withProperties:dicAppboy];
        }
    }
}


-(void)delayedNextTab{
    [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_API_FINISH object:nil userInfo:nil];
}

-(void)checkPersonalPopup {
    if (ApplicationDelegate.islogin == YES) {
        NSDictionary *dicSectionList = [self.sectionUIitem objectAtIndex:carousel2.currentItemIndex];
        BOOL isCheckServer = NO;
        if (NCO([dicSectionList objectForKey:@"pmoPopupInfo"]) == YES) {
            NSDictionary *dicPmoPopupInfo =[dicSectionList objectForKey:@"pmoPopupInfo"];
            NSString *strServerSEQ = NCS([dicPmoPopupInfo objectForKey:PERSONALPOPUP_KEY_DSPLSEQ]);
            NSArray *arrNoLook = LL(PERSONALPOPUP_ARR_NOLOOK);
            if ([arrNoLook containsObject:strServerSEQ] == NO) {
                //다시 안보기 값이 없음으로 일단 서버체크
                isCheckServer = YES;
                NSMutableDictionary *dicTomorrow = [[NSMutableDictionary alloc] init];
                NSMutableArray *arrTomorrow = [[NSMutableArray alloc] init];
                if(LL(PERSONALPOPUP_DIC_TOMORROW) != nil && [LL(PERSONALPOPUP_DIC_TOMORROW) isKindOfClass:[NSMutableDictionary class]]) {
                    [dicTomorrow addEntriesFromDictionary:LL(PERSONALPOPUP_DIC_TOMORROW)];
                    [arrTomorrow addObjectsFromArray:(NSMutableArray *)[dicTomorrow objectForKey:PERSONALPOPUP_KEY_ARR_DSPLSEQ]];
                    NSDate *dateSaved =  (NSDate *)[dicTomorrow objectForKey:PERSONALPOPUP_KEY_CONFIRM_DATE];
                    if ([Common_Util ShowPersonalPopupWithCloseDate:dateSaved]) {
                        
                    }
                    else {
                        for (NSInteger i=0; i<[arrTomorrow count]; i++) {
                            NSString *strSavedSEQ = [arrTomorrow objectAtIndex:i];
                            if ([strServerSEQ isEqualToString:strSavedSEQ]) {
                                isCheckServer = NO;
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        if(isCheckServer == YES && [NCS([dicSectionList objectForKey:@"pmoPopupCheckUrl"]) length] > 0 && [[dicSectionList objectForKey:@"pmoPopupCheckUrl"] hasPrefix:@"http"]) {
            NSURL *turl = [NSURL URLWithString:NCS([dicSectionList objectForKey:@"pmoPopupCheckUrl"])];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
            NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
            NSDictionary *dicPmoPopupInfo =[dicSectionList objectForKey:@"pmoPopupInfo"];
            NSString *strSEQ = NCS([dicPmoPopupInfo objectForKey:PERSONALPOPUP_KEY_DSPLSEQ]);
            NSMutableString *strPost = [[NSMutableString alloc] init];
            [strPost appendString:@"dsplSeq="];
            [strPost appendString:strSEQ];
            [strPost appendString:@"&custNo="];
            [strPost appendString:NCS([[DataManager sharedManager] customerNo])];
            NSLog(@"strPoststrPoststrPost  %@",strPost);
            NSData *postData = [strPost dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
            [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody:postData];
            [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
            NSLog(@"urlRequest = %@",urlRequest);
            NSError *error;
            NSURLResponse *response;
            NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:kMKNetworkKitRequestTimeOutInSeconds error:&error];
            NSDictionary *dicResult = [result JSONtoValue];
            NSLog(@"dicResultdicResultdicResult = %@",dicResult);
            NSLog(@"retMsgretMsg = %@",[dicResult objectForKey:@"retMsg"]);
            
            /*
             [Return(JSON)]
             isLogin : 로그인정보 (로그인 : "true", 비로그인 : "false")
             data     : 해당이벤트 대상여부 (대상 : "true", 비대상 : "false")
             retCd   :  조회상태   (에러 : "ERR", 정상: "SUCC")
             retMsg :  결과메세지("로그인 후 시도해 주세요.","이벤트 대상입니다.","이벤트 대상이 아닙니다.")
             EX>
             {"isLogin":"true","data":"false","retCd":"SUCC","retMsg":"이벤트 대상이 아닙니다."}
             
             data = true;
             isLogin = true;
             retCd = SUCC;
             retMsg = "\Uc774\Ubca4\Ud2b8 \Ub300\Uc0c1\Uc785\Ub2c8\Ub2e4.";
             
             */
            
            if (dicResult != nil && [[dicResult objectForKey:@"retCd"] isEqualToString:@"SUCC"] && [[dicResult objectForKey:@"data"] isEqualToString:@"true"]) {
                // 팝업 띄운다
                
                NSString *strImgUrl = NCS([dicPmoPopupInfo objectForKey:@"imageUrl"]);
                if ([strImgUrl length] > 0 && [strImgUrl hasPrefix:@"http"]) {
                    NSError *error;
                    NSURLResponse *response;
                    NSData* timgdata;
                    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strImgUrl]];
                    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
                    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
                    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
                    [urlRequest setHTTPMethod:@"GET"];
                    timgdata = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:2.0 error:&error];
                    if (error != nil || timgdata == nil) {
                        NSLog(@"error != nil || timgdata == nil");
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(basePersonalView != nil && [basePersonalView isKindOfClass:[UIView class]] == YES) {
                                [basePersonalView removeFromSuperview];
                                basePersonalView = nil;
                            }
                            
                            if(view_Personal != nil && [view_Personal isKindOfClass:[PromotionView class]] == YES) {
                                [view_Personal removeFromSuperview];
                                view_Personal =nil;
                            }
                            
                            basePersonalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)] ;
                            basePersonalView.backgroundColor = [UIColor clearColor];
                            
                            UIView* bpvdimv = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, APPFULLHEIGHT)];
                            [bpvdimv.layer setMasksToBounds:NO];
                            bpvdimv.layer.backgroundColor = [UIColor blackColor].CGColor;
                            bpvdimv.layer.opacity = 0.8;
                            [basePersonalView addSubview:bpvdimv];
                            
                            view_Personal = [[[NSBundle mainBundle] loadNibNamed:@"PromotionView" owner:self options:nil] firstObject];
                            dicPersonalPopup = [dicPmoPopupInfo copy];
                            [view_Personal setPromotionInfoData:dicPersonalPopup andTarget:self andImageData:timgdata];
                            view_Personal.frame = CGRectMake((APPFULLWIDTH-300)/2, (APPFULLHEIGHT-300)/2, 300, 300);
                            [basePersonalView addSubview:view_Personal];
                            //[ApplicationDelegate.window insertSubview:basePersonalView atIndex:1];
                            
                            if(ApplicationDelegate.HMV.tabBarView != nil) {
                                [ApplicationDelegate.window insertSubview:basePersonalView aboveSubview:ApplicationDelegate.HMV.tabBarView];
                            }
                            else {
                                [ApplicationDelegate.window insertSubview:basePersonalView atIndex:1];
                            }
                            
                            basePersonalView.alpha = 0.0;
                            [UIView animateWithDuration:0.5
                                                  delay:0
                                                options:UIViewAnimationOptionBeginFromCurrentState
                                             animations:(void (^)(void)) ^{
                                                 basePersonalView.alpha = 1.0;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }
                else {
                    NSLog(@"FALSE [strImgUrl length] > 0 && [strImgUrl hasPrefix:http]");
                }
            }
        }
    }
}




- (void)carouselDidScroll:(iCarousel *)carousel {
    // carousel 2 움직이면 carousel 1 같이 움직이게
    if((_carouselIsTouch ==0x16) && ((iCarousel*)carousel == carousel2)) {
        //NSLog(@"옵셋x  = %f", carousel2.scrollOffset);
        
        //2019/09/26메인탭 무한루프
        //[carousel1 scrollToItemAtIndexforX:carousel2.scrollOffset];
        
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    // 사용자가 carousel1를 드래그하는 경우
    if(_carouselIsTouch == 0x0b){
        //NSLog(@"%s",__FUNCTION__);
        //NSLog(@"1선택 index = %ld", (long)carousel.currentItemIndex);
        // 사용자가 carousel 1 움직임 완료 시 carousel 2 이동 시킴
        //[self performSelector:@selector(goselectidxCarousel2) withObject:nil afterDelay:0.4f];
        [self goselectidxCarousel2];
        _carouselIsTouch=0x00;
    }
    // 사용자가 carousel2를 드래그하는 경우
    else if(_carouselIsTouch ==0x16) {
        //NSLog(@"2선택 index = %ld", (long)carousel.currentItemIndex);
        //[self performSelector:@selector(goselectidxCarousel1) withObject:nil afterDelay:0.4f];
        [self goselectidxCarousel1];
        _carouselIsTouch=0x00;
    }
    else {
        _carouselIsTouch=0x00;
        [self checkScrollsToTopProperty];
        
        //2019/09/26메인탭 무한루프
        //[carousel1 scrollToItemAtIndexforX:carousel2.scrollOffset];
    }
}


-(void)goselectidxCarousel1 {
    //기본 애니메이션포함 이동
    
    //2019/09/26메인탭 무한루프
//    if(carousel2.currentItemIndex != carousel1.currentItemIndex) {
//        [carousel1 scrollToItemAtIndex:carousel2.currentItemIndex animated:YES];
//        NSLog(@"2선택 index 교정 = %ld", (long)carousel2.currentItemIndex);
//    }
    //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(goselectidxCarousel1) object:nil];
    
    if (idxPrevCarousel1 != carousel2.currentItemIndex) {
        [carousel1 scrollToButtonIndex:carousel2.currentItemIndex animated:YES];
        idxPrevCarousel1 =carousel2.currentItemIndex;
    }
}

-(void)goselectidxCarousel2 {
    //2019/09/26메인탭 무한루프
//    if(((carousel1.currentItemIndex + 1) == carousel2.currentItemIndex) ||((carousel1.currentItemIndex - 1) == carousel2.currentItemIndex)) {
//        if((carousel1.currentItemIndex) == carousel2.currentItemIndex) {
//        }
//        else {
//            [carousel2 scrollToItemAtIndex:carousel1.currentItemIndex animated:YES];
//        }
//    }
//    else {
//        [carousel2 scrollToItemAtIndex:carousel1.currentItemIndex animated:YES];
//    }
}


- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    //2019/09/26메인탭 무한루프
//    if((iScroll *)carousel==carousel1) {
//        _carouselIsTouch=0x0b;
//        NSLog(@"1111111 %s",__FUNCTION__);
//    }
//    else {
        _carouselIsTouch = 0x16;
        NSLog(@"2222222 %s",__FUNCTION__);
//    }

    // ???? chody ????
    if ((iCarousel*)carousel == carousel2) {
        NSUInteger itemCount = [self.sectionUIitem count];
        [self modifyCarouselViewSetting:carousel2 content:[[[carousel2 itemViewAtIndex:(carousel.currentItemIndex + 1 + itemCount) % itemCount] subviews] lastObject]];
        [self modifyCarouselViewSetting:carousel2 content:[[[carousel2 itemViewAtIndex:(carousel.currentItemIndex - 1 + itemCount) % itemCount] subviews] lastObject]];
    }
}


- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    NSLog(@"ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");  // 사용자가 carousel1를 드래그하는 경우
    
    /*//2019/09/26메인탭 무한루프
    if(_carouselIsTouch == 0x0b) {
        NSLog(@"%s",__FUNCTION__);
        NSLog(@"1선택 index = %ld", (long)carousel.currentItemIndex);
        // 사용자가 carousel 1 움직임 완료 시 carousel 2 이동 시킴
        [self performSelector:@selector(goselectidxCarousel2) withObject:nil afterDelay:0.4f];
        _carouselIsTouch=0x00;
    }
    // 사용자가 carousel2를 드래그하는 경우
    else
    */
        
    if(_carouselIsTouch ==0x16) {
        NSLog(@"2선택 index = %ld", (long)carousel.currentItemIndex);
        //[self performSelector:@selector(goselectidxCarousel1) withObject:nil afterDelay:0.3f];
        [self goselectidxCarousel1];
        _carouselIsTouch=0x00;
    }
    else {
        _carouselIsTouch=0x00;
        [self checkScrollsToTopProperty];
    }
}


#pragma mark -
#pragma mark ssRollingButtonScrollView delegate
- (void)rollingScrollViewButtonPushed:(NSInteger)idxButton ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView{
    
    if (carousel2.currentItemIndex != idxButton) {
        isMoveFromExt = YES;
        [carousel2 scrollToItemAtIndex:idxButton animated:NO];
    }
    
}
- (void)rollingScrollViewButtonIsInCenter:(NSInteger)idxButton ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView{

    //NSLog(@"(long)idxButton = %ld",(long)idxButton);
    
    [carousel2 scrollToItemAtIndex:idxButton animated:NO];
}

- (void)rollingScrollViewDidFinishScroll:(NSInteger)idxButton ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView{
    if (isMoveFromExt == NO && carousel2.currentItemIndex != idxButton) {
        [carousel2 scrollToItemAtIndex:idxButton animated:NO];
    }
    if (isMoveFromExt == YES) {
        isMoveFromExt = NO;
    }
}
- (void)rollingScrollWillBeginDragging:(UIScrollView *)scrollView{
}

- (void)touchEventTBCellJustLinkStr:(NSString*)strUrl {
    @try {
        NSLog(@"홈 link 이동 str : %@", strUrl);
        if([strUrl length] > 0 ) {
            if ([[strUrl lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                NSString *linkstr = [strUrl substringFromIndex:11];
                linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                NSLog(@"linkstr : %@", linkstr);
                if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                    [self goLiveTalkWithLinkStr:linkstr];
                }
                else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                    NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                    NSLog(@"linkstr : %@", strDirectOrd);
                    [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                }
//                else if([linkstr hasPrefix:@"leftnavi"]) { //2017.04 yunsang.jin 사이드매뉴 오픈 프로토콜 추가
//                    [DataManager sharedManager].lastSideViewController = nil;
//                    [ApplicationDelegate sideMenuViewShow:YES];
//                    if ([linkstr hasPrefix:@"leftnavi?wiselog=http"]) {
//                        NSArray *arrSplit = [linkstr componentsSeparatedByString:@"wiselog="];
//                        if ([arrSplit count] > 1 && [[arrSplit objectAtIndex:1] hasPrefix:@"http"]) {
//                            [ApplicationDelegate wiseAPPLogRequest:[Common_Util getURLEndcodingCheck:[arrSplit objectAtIndex:1]]];
//                        }
//                    }
//                }
                else if([linkstr hasPrefix:@"login"]) {
                    //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                    if(loginView == nil) {
                        loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                    }else{
                        [loginView clearTextFields];
                    }
                    
                    loginView.delegate = self;
                    loginView.loginViewType = 33;
                    loginView.loginViewMode = 0;
                    loginView.view.hidden=NO;
                    loginView.btn_naviBack.hidden = NO;
                    [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                    
                }
                else if([linkstr hasPrefix:@"setting"]) {
                    //설정창으로
                    My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                    [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                }
                else {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                }
            }
            else {
                [self moveWebViewStrUrl:strUrl];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Home_Main_ViewController Table cell touchEventTBCellJustLinkStr link Event ERROR : %@", exception);
    }
}

- (void)touchEventTBCell:(NSDictionary *)dic {
    @try {
        NSLog(@"홈메인 딕 : %@", dic);
        if([NCS([dic objectForKey:@"linkUrl"]) length] > 3) {
            if ([[[dic objectForKey:@"linkUrl"] lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                NSString *linkstr = [[dic objectForKey:@"linkUrl"] substringFromIndex:11];
                linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                NSLog(@"linkstr : %@", linkstr);
                if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                    [self goLiveTalkWithLinkStr:linkstr];
                }
                
                else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                    NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                    NSLog(@"linkstr : %@", strDirectOrd);
                    [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                }
//                else if([linkstr hasPrefix:@"leftnavi"]) { //2017.04 yunsang.jin 사이드매뉴 오픈 프로토콜 추가
//                    [DataManager sharedManager].lastSideViewController = nil;
//                    [ApplicationDelegate sideMenuViewShow:YES];
//                    if ([linkstr hasPrefix:@"leftnavi?wiselog=http"]) {
//                        NSArray *arrSplit = [linkstr componentsSeparatedByString:@"wiselog="];
//                        if ([arrSplit count] > 1 && [[arrSplit objectAtIndex:1] hasPrefix:@"http"]) {
//                            [ApplicationDelegate wiseAPPLogRequest:[Common_Util getURLEndcodingCheck:[arrSplit objectAtIndex:1]]];
//                        }
//                    }
//                }
                else if([linkstr hasPrefix:@"login"]) {
                    //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                    if(loginView == nil) {
                        loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                    }else{
                        [loginView clearTextFields];
                    }
                    
                    loginView.delegate = self;
                    loginView.loginViewType = 33;
                    loginView.loginViewMode = 0;
                    loginView.view.hidden=NO;
                    loginView.btn_naviBack.hidden = NO;
                    [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                    
                }
                else if([linkstr hasPrefix:@"setting"]) {
                    //설정창으로
                    My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                    [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                }
                else {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                }
            }
            else {
                [self moveWebViewStrUrl:[dic objectForKey:@"linkUrl"]];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Home_Main_ViewController Table cell touch Event ERROR : %@", exception);
    }
}


- (void)touchEventBannerCell:(NSDictionary *)dic {
    @try {
        if(dic != nil) {
            if(![NCS([dic objectForKey:@"linkUrl"]) isEqualToString:@""] && ([NCS([dic objectForKey:@"linkUrl"]) length] > 3)) {
                if([[dic objectForKey:@"linkUrl"] hasPrefix:@"gsshopmobile://"]) {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[dic objectForKey:@"linkUrl"]]];
                }
                else {
                    if ([[[dic objectForKey:@"linkUrl"] lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                        NSString *linkstr = [[dic objectForKey:@"linkUrl"] substringFromIndex:11];
                        linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                        NSLog(@"linkstr : %@", linkstr);
                        if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                            [self goLiveTalkWithLinkStr:linkstr];
                        }
                        
                        else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                            NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                            NSLog(@"linkstr : %@", strDirectOrd);
                            [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                        }
//                        else if([linkstr hasPrefix:@"leftnavi"]) { //2017.04 yunsang.jin 사이드매뉴 오픈 프로토콜 추가
//                            [DataManager sharedManager].lastSideViewController = nil;
//                            [ApplicationDelegate sideMenuViewShow:YES];
//                            if ([linkstr hasPrefix:@"leftnavi?wiselog=http"]) {
//                                NSArray *arrSplit = [linkstr componentsSeparatedByString:@"wiselog="];
//                                if ([arrSplit count] > 1 && [[arrSplit objectAtIndex:1] hasPrefix:@"http"]) {
//                                    [ApplicationDelegate wiseAPPLogRequest:[Common_Util getURLEndcodingCheck:[arrSplit objectAtIndex:1]]];
//                                }
//                            }
//                        }
                        else if([linkstr hasPrefix:@"login"]) {
                            //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                            if(loginView == nil) {
                                loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                            }else{
                                [loginView clearTextFields];
                            }
                            
                            loginView.delegate = self;
                            loginView.loginViewType = 33;
                            loginView.loginViewMode = 0;
                            loginView.view.hidden=NO;
                            loginView.btn_naviBack.hidden = NO;
                            [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                            
                        }
                        else if([linkstr hasPrefix:@"setting"]) {
                            //설정창으로
                            My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                            [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                        }
                        else {
                            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                        }
                    }
                    else {
                        [self moveWebViewStrUrl:[dic objectForKey:@"linkUrl"]];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Home_Main_ViewController Banner cell touch Event ERROR : %@", exception);
    }
}
- (void)btntouchAction:(id)sender {
    if([((UIButton *)sender) tag] == 1001) { //로그인-로그아웃
        if(ApplicationDelegate.islogin) {
            Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:LOGOUTALERTALSTR  maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:LOGOUTCONFIRMSTR1,  LOGOUTCONFIRMSTR2, nil]];
            malert.tag = 444;
            [ApplicationDelegate.window addSubview:malert];
        }
        else {
            NSLog(@"self.curRequestString = %@", self.curRequestString);
            //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
            if(loginView == nil) {
                loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
            }else{
                [loginView clearTextFields];
            }
            
            loginView.delegate = self;
            loginView.loginViewType = 4;
            loginView.loginViewMode = 0;
            loginView.view.hidden=NO;
            loginView.btn_naviBack.hidden = NO;
            [super.navigationController pushViewControllerMoveInFromBottom:loginView];
        }
    }
    else if([((UIButton *)sender) tag] == 1002) {
        //이용약관
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:MANUALGUIDEFOOTERURL];
        result.delegate = self;
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    else if([((UIButton *)sender) tag] == 1003) {
        //결제안내
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:PAYGUIDEIPHONEFOOTERURL];
        result.delegate = self;
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    else if([((UIButton *)sender) tag] == 1004) {
        //고객센터
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:CUSTOMERCENTERFOOTERURL];
        result.delegate = self;
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    else if([((UIButton *)sender) tag] == 1007) {
        //앱알림 설정
        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
    }
    else if([((UIButton *)sender) tag] == 1009) {
        //개인정보 취급방침
        
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlStringByNoTab:PRIVATEINFOFOOTERURL];
        result.delegate = self;
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    else if([((UIButton *)sender) tag] == 1010) {
        //청소년 보호정책
        ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlStringByNoTab:TEENAGERPOLICYFOOTERURL];
        result.delegate = self;
        result.view.tag = 505;
        [DataManager sharedManager].selectTab = 0;
        [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
    }
    //1050 : 10x10
    //1051: 29cm - 20180629 제거됨.
    //1052: call
    else if([((UIButton *)sender) tag] == 1050)  {
        //10x10
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:FAMILY_10X10]];
        return;
    }
    else if([((UIButton *)sender) tag] == 1052) {// call
        [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=415448")];
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:CUSTOMCENTER_TEL]];
        return;
    }
    else if([((UIButton *)sender) tag] == 1053) {// 2017.08.24 nPoint 추가
        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:FAMILY_NPOINT]];
        return;
    }
    else {
    }
}

- (void)btntouchWithDicAction:(NSDictionary*)tdic tagint:(int)tint {
    //TVCView 랜딩URL
    if(tint == 2001) {
        @try {
            if(![NCS([tdic objectForKey:@"linkUrl"]) isEqualToString:@""]) {
                NSLog(@"TVC 이미지영역 터치 : %@", tdic);
                if([[tdic objectForKey:@"linkUrl"] hasPrefix:@"gsshopmobile://"]) {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[tdic objectForKey:@"linkUrl"]]];
                }
                else {
                    NSString *landingURL = [tdic objectForKey:@"linkUrl"];
                    landingURL = [landingURL hasPrefix:@"/"] ? [NSString stringWithFormat:@"%@%@", SERVERURI, landingURL] : landingURL;
                    if ([[landingURL lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                        NSString *linkstr = [landingURL substringFromIndex:11];
                        linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                        NSLog(@"linkstr : %@", linkstr);
                        if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                            [self goLiveTalkWithLinkStr:linkstr];
                        }
                        
                        else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                            NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                            NSLog(@"linkstr : %@", strDirectOrd);
                            [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                        }
//                        else if([linkstr hasPrefix:@"leftnavi"]) { //2017.04 yunsang.jin 사이드매뉴 오픈 프로토콜 추가
//                            [DataManager sharedManager].lastSideViewController = nil;
//                            [ApplicationDelegate sideMenuViewShow:YES];
//                            if ([linkstr hasPrefix:@"leftnavi?wiselog=http"]) {
//                                NSArray *arrSplit = [linkstr componentsSeparatedByString:@"wiselog="];
//                                if ([arrSplit count] > 1 && [[arrSplit objectAtIndex:1] hasPrefix:@"http"]) {
//                                    [ApplicationDelegate wiseAPPLogRequest:[Common_Util getURLEndcodingCheck:[arrSplit objectAtIndex:1]]];
//                                }
//                            }
//                        }
                        else if([linkstr hasPrefix:@"login"]) {
                            //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                            if(loginView == nil) {
                                loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                            }else{
                                [loginView clearTextFields];
                            }
                            
                            loginView.delegate = self;
                            loginView.loginViewType = 33;
                            loginView.loginViewMode = 0;
                            loginView.view.hidden=NO;
                            loginView.btn_naviBack.hidden = NO;
                            [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                            
                        }
                        else if([linkstr hasPrefix:@"setting"]) {
                            //설정창으로
                            My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                            [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                        }
                        else {
                            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                        }
                    }
                    else {
                        [self moveWebViewStrUrl:landingURL];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Home_Main_ViewController TVC cell image touch Event ERROR : %@", exception);
        }
    }
    else if(tint == 2008) {
        @try {
            if(![NCS([tdic objectForKey:@"titleButtonLandingUrl"]) isEqualToString:@""]) {
                NSLog(@"타이틀영역 버튼 : %@", tdic);
                //타이틀영역 클릭시 이동
                if([NCS([tdic objectForKey:@"titleButtonLandingUrl"]) hasPrefix:@"gsshopmobile://"]) {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[tdic objectForKey:@"titleButtonLandingUrl"]]];
                }
                else {
                    if ([[NCS([tdic objectForKey:@"titleButtonLandingUrl"]) lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                        NSString *linkstr = [[tdic objectForKey:@"titleButtonLandingUrl"] substringFromIndex:11];
                        linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                        NSLog(@"linkstr : %@", linkstr);
                        if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                            [self goLiveTalkWithLinkStr:linkstr];
                        }
                        
                        else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                            NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                            NSLog(@"linkstr : %@", strDirectOrd);
                            [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                        }
//                        else if([linkstr hasPrefix:@"leftnavi"]) { //2017.04 yunsang.jin 사이드매뉴 오픈 프로토콜 추가
//                            [DataManager sharedManager].lastSideViewController = nil;
//                            [ApplicationDelegate sideMenuViewShow:YES];
//                            if ([linkstr hasPrefix:@"leftnavi?wiselog=http"]) {
//                                NSArray *arrSplit = [linkstr componentsSeparatedByString:@"wiselog="];
//                                if ([arrSplit count] > 1 && [[arrSplit objectAtIndex:1] hasPrefix:@"http"]) {
//                                    [ApplicationDelegate wiseAPPLogRequest:[Common_Util getURLEndcodingCheck:[arrSplit objectAtIndex:1]]];
//                                }
//                            }
//                        }
                        else if([linkstr hasPrefix:@"login"]) {
                            //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                            if(loginView == nil) {
                                loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                            }else{
                                [loginView clearTextFields];
                            }
                            
                            loginView.delegate = self;
                            loginView.loginViewType = 33;
                            loginView.loginViewMode = 0;
                            loginView.view.hidden=NO;
                            loginView.btn_naviBack.hidden = NO;
                            [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                            
                        }
                        else if([linkstr hasPrefix:@"setting"]) {
                            //설정창으로
                            My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                            [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                        }
                        else {
                            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                        }
                    }
                    else {
                        [self moveWebViewStrUrl:[tdic objectForKey:@"titleButtonLandingUrl"]];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Home_Main_ViewController TVC cell title area touch Event ERROR : %@", exception);
        }
    }
    else if(tint == 2002) {
        //생방송
        if(([[tdic objectForKey:@"playButtonLandingUrl"] hasPrefix:@"toapp://liveBroadUrl?param="]) ||([[tdic objectForKey:@"playButtonLandingUrl"] hasPrefix:@"toApp://liveBroadUrl?param="])) { //live 방송
            NSArray *livetv = [[tdic objectForKey:@"playButtonLandingUrl"] componentsSeparatedByString:@"param="];
            NSString *query3 = [livetv lastObject];
            
            if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
                [self playrequestLiveVideo:query3];
            }
            else {
                self.curRequestString = [NSString stringWithString:query3];
                Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                       DATASTREAM_ALERT   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
                malert.tag = 777;
                [ApplicationDelegate.window addSubview:malert];
            }
        }
        //VOD영상 재생 - 20130102   + 딜상품 VOD영상 재생 - 20130226 + 기본 VOD영상재생(버튼overlay없음) 20150211
        else if(([[tdic objectForKey:@"playButtonLandingUrl"] hasPrefix:@"toapp://vod?url="]) || ([[tdic objectForKey:@"playButtonLandingUrl"] hasPrefix:@"toapp://dealvod?url="]) || ([[tdic objectForKey:@"playButtonLandingUrl"] hasPrefix:@"toapp://basevod?url="])) {   //vod 방송
            if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
                [self playrequestVODVideo:[tdic objectForKey:@"playButtonLandingUrl"]];
            }
            else {
                self.curRequestString = [NSString stringWithString:[tdic objectForKey:@"playButtonLandingUrl"]];
                Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                                       DATASTREAM_ALERT maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
                malert.tag = 888;
                [ApplicationDelegate.window addSubview:malert];
            }
        }
        else {
            @try {
                if(![NCS([tdic objectForKey:@"playButtonLandingUrl"]) isEqualToString:@""]) {
                    NSLog(@"플레이 버튼 : %@", tdic);
                    if([NCS([tdic objectForKey:@"playButtonLandingUrl"]) hasPrefix:@"gsshopmobile://"]) {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[tdic objectForKey:@"playButtonLandingUrl"]]];
                    }
                    else {
                        if ([[NCS([tdic objectForKey:@"playButtonLandingUrl"]) lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                            NSString *linkstr = [[tdic objectForKey:@"playButtonLandingUrl"] substringFromIndex:11];
                            linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                            NSLog(@"linkstr : %@", linkstr);
                            if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                                [self goLiveTalkWithLinkStr:linkstr];
                            }
                            else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                                NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                                NSLog(@"linkstr : %@", strDirectOrd);
                                [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                            }
                            else {
                                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                            }
                        }
                        else {
                            [self moveWebViewStrUrl:[tdic objectForKey:@"playButtonLandingUrl"]];
                        }
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"Home_Main_ViewController TVC cell play btn  touch Event ERROR : %@", exception);
            }
        }
    }
    else if(tint == 2003) {
        @try {
            if(![NCS([tdic objectForKey:@"accmUrl"]) isEqualToString:@""]) {
                if ([[NCS([tdic objectForKey:@"accmUrl"]) lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [[tdic objectForKey:@"accmUrl"] substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        NSLog(@"linkstr : %@", strDirectOrd);
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:[tdic objectForKey:@"accmUrl"]];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Home_Main_ViewController TVC cell5 적립 랜딩 btn  touch Event ERROR : %@", exception);
        }
    }
    else if(tint == 2004) {
        @try {
            if(![NCS([tdic objectForKey:@"broadScheduleLinkUrl"]) isEqualToString:@""]) {
                if ([[NCS([tdic objectForKey:@"broadScheduleLinkUrl"]) lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [[tdic objectForKey:@"broadScheduleLinkUrl"] substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    NSLog(@"linkstr : %@", linkstr);
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        NSLog(@"linkstr : %@", strDirectOrd);
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:[tdic objectForKey:@"broadScheduleLinkUrl"]];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Home_Main_ViewController 편성표 랜딩 btn  touch Event ERROR : %@", exception);
        }
    }
    else if(tint == 2005) {
        @try {
            if(![NCS([tdic objectForKey:@"directorderButtonLandingUrl"]) isEqualToString:@""]) {
                if ([[NCS([tdic objectForKey:@"directorderButtonLandingUrl"]) lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [[tdic objectForKey:@"directorderButtonLandingUrl"] substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:[tdic objectForKey:@"directorderButtonLandingUrl"]];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Home_Main_ViewController 바로주문 랜딩 btn  touch Event ERROR : %@", exception);
        }
    }
    else if(tint == 2007) {
        @try {
            if([[tdic objectForKey:@"listBottomUrl"] isKindOfClass:[NSNull class]] == NO) {
                if([[tdic objectForKey:@"listBottomUrl"] hasPrefix:@"gsshopmobile://"]) {
                    [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:[tdic objectForKey:@"listBottomUrl"]]];
                }
                else {
                    if ([[[tdic objectForKey:@"listBottomUrl"] lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                        NSString *linkstr = [[tdic objectForKey:@"listBottomUrl"] substringFromIndex:11];
                        linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                        NSLog(@"linkstr : %@", linkstr);
                        if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                            [self goLiveTalkWithLinkStr:linkstr];
                        }
                        else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                            NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                            [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                        }
                        else if([linkstr hasPrefix:@"login"]) {
                            //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                            if(loginView == nil) {
                                loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                            }else{
                                [loginView clearTextFields];
                            }
                            loginView.delegate = self;
                            loginView.loginViewType = 33;
                            loginView.loginViewMode = 0;
                            loginView.view.hidden=NO;
                            loginView.btn_naviBack.hidden = NO;
                            [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                            
                        }
                        else if([linkstr hasPrefix:@"setting"]) {
                            //설정창으로
                            My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                            [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                        }
                        else {
                            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                        }
                    }
                    else {
                        [self moveWebViewStrUrl:[tdic objectForKey:@"listBottomUrl"]];
                    }
                }
            }
            else {
                return;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Home_Main_ViewController 이벤트 전체보기 랜딩 btn  touch Event ERROR : %@", exception);
        }
    }
}


//GroupSection셀이 눌렸을 때, GroupSection셀 내부의 버튼이 눌렸을 때 호출됨
- (void)touchEventGroupTBCellWithRowInfo:(NSDictionary *)rowInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender {
    NSString *sectionType = [sectionInfoDic objectForKey:@"sectionType"];
    // 그룹 - 대분류 매장
    if ([sectionType isEqualToString:@"L"]) {
        if (sender == nil) {
            NSString *landingURL = [rowInfoDic objectForKey:@"linkUrl"];
            landingURL = [landingURL hasPrefix:@"/"] ? [NSString stringWithFormat:@"%@%@", SERVERURI, landingURL] : landingURL;
            if ([landingURL hasPrefix:@"gsshopmobile://"]) {
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:landingURL]];
            }
            else {
                if ([[landingURL lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [landingURL substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:landingURL];
                }
            }
        }
        else {
            //셀 내부 버튼 클릭 처리
            int tag = (int)[(UIView *)sender tag];
            //찜 등록
            if (tag == 100) {
                if ([(NSNumber *)NCB([rowInfoDic objectForKey:@"isWish"]) boolValue]) {
                    //찜 등록 팝업
                    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"favor_msg_already")
                                                                   maintitle:nil
                                                                    delegate:nil
                                                                 buttonTitle:[NSArray arrayWithObjects:@"계속 쇼핑하기", nil]];
                    [ApplicationDelegate.window addSubview:malert];
                }
                else {
                    if (ApplicationDelegate.islogin) {
                        [self registerFavoriteProduct:rowInfoDic];
                    }
                    else {
                        self.favoriteProductInfo = rowInfoDic;
                        self.curRequestString = nil;
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 4;
                        loginView.loginViewMode = 0;
                        loginView.btn_naviBack.hidden = NO;
                        loginView.view.hidden=NO;
                        [self.navigationController pushViewControllerMoveInFromBottom:loginView];
                    }
                }
            }
        }
    }
    // 그룹 - 딜 매장
    else if ([sectionType isEqualToString:@"D"]) {
        if (sender == nil) {
            NSString *landingURL = [rowInfoDic objectForKey:@"linkUrl"];
            landingURL = [landingURL hasPrefix:@"/"] ? [NSString stringWithFormat:@"%@%@", SERVERURI, landingURL] : landingURL;
            
            if ([landingURL hasPrefix:@"gsshopmobile://"]) {
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:landingURL]];
            }
            else {
                if ([[landingURL lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [landingURL substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    NSLog(@"linkstr : %@", linkstr);
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:landingURL];
                }
            }
        }
        else {
            //셀 내부 버튼 클릭 처리
        }
    }
    else {
        if (sender == nil) {
            NSString *landingURL = [rowInfoDic objectForKey:@"linkUrl"];
            landingURL = [landingURL hasPrefix:@"/"] ? [NSString stringWithFormat:@"%@%@", SERVERURI, landingURL] : landingURL;
            if ([landingURL hasPrefix:@"gsshopmobile://"]) {
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:landingURL]];
            }
            else {
                if ([[landingURL lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [landingURL substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    NSLog(@"linkstr : %@", linkstr);
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:landingURL];
                }
            }
        }
        else {
            //셀 내부 버튼 클릭 처리
        }
    }
}



//GroupSection 서브 카테고리 버튼, 상단 배너 버튼 눌렸을 때 호출됨. (하단 footer의 로그인 버튼 등은 기존 Section(Home) 방식으로 상속 처리)
- (void)btntouchGroupTBWithApiInfo:(NSDictionary *)apiInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender {
    NSString *sectionType = [sectionInfoDic objectForKey:@"sectionType"];
    // 그룹 - 대분류 매장
    if ([sectionType isEqualToString:@"L"]) {
        int buttonTag = (int)((UIButton *)sender).tag;
        // 중분류 카테고리
        if (GROUP_SECTION_SUBCATEGORY_BUTTON_TAG <= buttonTag && buttonTag < GROUP_SECTION_SUBCATEGORY_BUTTON_TAG + 1000) {
            NSString *landingURL = [[[apiInfoDic objectForKey:@"middleSectionList"] objectAtIndex:(buttonTag - GROUP_SECTION_SUBCATEGORY_BUTTON_TAG)] objectForKey:@"sectionLinkUrl"];
            landingURL = [landingURL hasPrefix:@"/"] ? [NSString stringWithFormat:@"%@%@", SERVERURI, landingURL] : landingURL;
            
            if ([landingURL hasPrefix:@"gsshopmobile://"]) {
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:landingURL]];
            }
            else {
                if ([[landingURL lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [landingURL substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:landingURL];
                }
            }
        }
        // 상단 배너
        else if (GROUP_SECTION_BANNER_BUTTON_TAG <= buttonTag && buttonTag < GROUP_SECTION_BANNER_BUTTON_TAG + 1000) {
            NSString *landingURL = [[[apiInfoDic objectForKey:@"planningProductList"] objectAtIndex:(buttonTag - GROUP_SECTION_BANNER_BUTTON_TAG)] objectForKey:@"linkUrl"];
            landingURL = [landingURL hasPrefix:@"/"] ? [NSString stringWithFormat:@"%@%@", SERVERURI, landingURL] : landingURL;
            
            if ([landingURL hasPrefix:@"gsshopmobile://"]) {
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:landingURL]];
            }
            else {
                if ([[landingURL lowercaseString] hasPrefix:GSEXTERNLINKPROTOCOL]) {
                    NSString *linkstr = [landingURL substringFromIndex:11];
                    linkstr = [Mocha_Util strReplace:@"tel:" replace:@"telprompt:" string:linkstr];
                    if ([linkstr hasPrefix:@"livetalk?"]) { //2016.01 jin 라이브톡 프로토콜 추가
                        [self goLiveTalkWithLinkStr:linkstr];
                    }
                    else if([linkstr hasPrefix:@"directOrd?"]) { //2017.06 바로구매 공통처리추가
                        NSString *strDirectOrd = [linkstr stringByReplacingOccurrencesOfString:@"directOrd?" withString:@""];
                        [ApplicationDelegate directOrdOptionViewShowURL:strDirectOrd];
                    }
                    else if([linkstr hasPrefix:@"login"]) {
                        //로그인 창을 띄우고 로그인 한 다음 url을 가지고 다시 webview로 넘긴다.
                        if(loginView == nil) {
                            loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
                        }else{
                            [loginView clearTextFields];
                        }
                        loginView.delegate = self;
                        loginView.loginViewType = 33;
                        loginView.loginViewMode = 0;
                        loginView.view.hidden=NO;
                        loginView.btn_naviBack.hidden = NO;
                        [super.navigationController pushViewControllerMoveInFromBottom:loginView];
                        
                    }
                    else if([linkstr hasPrefix:@"setting"]) {
                        //설정창으로
                        My_Opt_ViewController *myoptVC = [[My_Opt_ViewController alloc] initWithTarget:self];
                        [self.navigationController pushViewControllerMoveInFromBottom:myoptVC];
                    }
                    else {
                        [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:linkstr ]];
                    }
                }
                else {
                    [self moveWebViewStrUrl:landingURL];
                }
            }
        }
    }
}


- (void)goLiveTalkWithLinkStr:(NSString *)strLink {
    //2016.01 라이브톡 추가
    //웹호출 URL 규약에 따라 홈-이후 네비게이션(Resultweb) 페이지에서 url 표출
    if([strLink  hasPrefix:@"livetalk?"]) {
        NSString *add_schemeurl = [strLink substringFromIndex:9];
        NSLog(@"%@", add_schemeurl);
        if(add_schemeurl != nil) {
            LiveTalkViewController *goliveBVV = [[LiveTalkViewController alloc] initWithTarget:self withBCinfoStr:add_schemeurl];
            //네이티브 라이브톡 호출시에는
            [self.navigationController pushViewControllerMoveInFromBottom:goliveBVV];
        }
    }
}



- (void)showDealHasNoItemsAlertWithSectionInfo:(NSDictionary*)sectioninfo {
    // 현재 딜 페이지가 보여지고 있는지 검사
    if ([self.sectionUIitem count] > 0  && sectioninfo == [self.sectionUIitem objectAtIndex:0] && carousel2.currentItemIndex == 0 &&
        ![self isthereMochaAlertView]) {
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"favor_msg_wrongdeal")
                                                       maintitle:nil
                                                        delegate:self
                                                     buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        malert.tag = 21000;
        [ApplicationDelegate.window addSubview:malert];
    }
}


-(BOOL)isthereMochaAlertView {
    for ( UIScrollView* v in  [ApplicationDelegate.window subviews] ) {
        if([[NSString stringWithFormat:@"%s",   object_getClassName([v class])] isEqualToString:@"Mocha_Alert"]){
            return YES;
        }
    }
    return NO;
}


- (void)registerFavoriteProduct:(NSDictionary *)rowInfoDic {
    [self.currentOperation3 cancel];
    //찜 등록 팝업
    self.currentOperation3 = [ApplicationDelegate.gshop_http_core
                              gsFAVORITEREGURL:[NSString stringWithFormat:@"%d", [(NSNumber *)[rowInfoDic objectForKey:@"productCd"] intValue]]
                              onCompletion:^(NSDictionary *result) {
                                  //for test
                                  NSLog(@"FAVORITEREGURL RESULT \n%@", result);
                                  if ([NCS([result objectForKey:@"retCd"]) isEqualToString:@"SUCC"]) {
                                      Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"favor_msg_successl")
                                                                                     maintitle:nil
                                                                                      delegate:self
                                                                                   buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"favor_btn_continue"), GSSLocalizedString(@"favor_btn_gofavor"), nil]];
                                    malert.tag = 22000;
                                    [ApplicationDelegate.window addSubview:malert];
                                    //찜 데이터 업데이트
                                    [(NSMutableDictionary *)rowInfoDic setObject:[NSNumber numberWithBool:YES] forKey:@"isWish"];
                                  }
                                  else {
                                      NSString *errorMsg = [result objectForKey:@"retMsg"];
                                      NSLog(@"CHODY FAVORITE ERROR : %@", errorMsg);
                                      if ([errorMsg length] == 0) errorMsg = GSSLocalizedString(@"favor_msg_failed");
                                      Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:errorMsg
                                                                                     maintitle:nil
                                                                                      delegate:nil
                                                                                   buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                      [ApplicationDelegate.window addSubview:malert];
                                  }
                              }
                              onError:^(NSError* error) {
                                  Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"favor_msg_failed")
                                                                                 maintitle:nil
                                                                                  delegate:nil
                                                                               buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                  [ApplicationDelegate.window addSubview:malert];
                              }];
}



//찜으로 이동하기
- (void)moveToFavoritePage {
    ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:FAVORITE_PAGE_URL];
    result.delegate = self;
    result.view.tag = 505;
    [DataManager sharedManager].selectTab = 0;
    [self.navigationController  pushViewControllerMoveInFromBottom:result];//url을 웹뷰로 보여줌
}

-(void)checkNextTabLoad{
    
    NSInteger idxNextItem = 0;
    NSInteger idxPrevItem = 0;
    
    if (carousel2.currentItemIndex+1 < [self.sectionUIitem count]) {
        idxNextItem = carousel2.currentItemIndex+1;
    }else{
        idxNextItem = 0;
    }
    
    if (carousel2.currentItemIndex-1 < 0) {
        idxPrevItem = [self.sectionUIitem count] - 1;
    }else{
        idxPrevItem = carousel2.currentItemIndex-1;
    }
    
    
    if([[[carousel2 itemViewAtIndex:idxNextItem] subviews] count] > 0) {
        //현 상태 탭 오른쪽카루셀에 뷰가 이미 있으면 바로 패스하고 왼쪽 아이템 로딩
        idxNextItem = idxPrevItem;
    }
    
    
    if([[[carousel2 itemViewAtIndex:idxNextItem] subviews] count] < 1) {
       //dispatch_queue_t dqueue = dispatch_queue_create("mainprocs_next", NULL);
       // dispatch_semaphore_t exeSignal = dispatch_semaphore_create(1);
       // dispatch_async(dqueue, ^{
       //     dispatch_semaphore_wait(exeSignal, DISPATCH_TIME_FOREVER);
            NSLog(@"GCD: PROC1 START");
            dispatch_async(dispatch_get_main_queue(), ^{
                SectionView  *tview;
                if (_currentCategory == 0) {
                    NSLog(@"비타입 %@", [[self.sectionUIitem objectAtIndex:idxNextItem] objectForKey:@"viewType"]);
                    NSLog(@"sectionLinkUrl = %@",[[self.sectionUIitem objectAtIndex:idxNextItem] objectForKey:@"sectionLinkUrl"]);
                    NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:idxNextItem] objectForKey:@"viewType"]);
                    if([viewType length] > 0 ) {
                        //TV쇼핑
                        if([viewType isEqualToString:HOMESECTTDCLIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeTVShop];
                        }
                        //플랙서블
                        else if([viewType isEqualToString:HOMESECTFXCLIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeFlexible];
                        }
                        //이벤트 개편 HOMESECTEILIST
                        else if([viewType isEqualToString:HOMESECTEILIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeNewEvent];
                        }
                        // 혜택 매장 신규 HOMESECTEFXCLIST
                        else if([viewType isEqualToString:HOMESECTEFXCLIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeNewFlexible];
                        }
                        //날방 개편 HOMESECTNTCLIST => 숏방으로 변경 => 다시 날방으로 변경
                        else if([viewType isEqualToString:HOMESECTNTCLIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeNalbang];
                        }
                        //편성표 매장 추가
                        else if([viewType isEqualToString:HOMESECTSLIST]) {
                            if([NCS(self.tabIdBysubCategoryName) length] <= 0) {
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeSchedule];
                            }
                            else {
                                // broadType이 있다면
                                tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeSchedule subCategory:self.tabIdBysubCategoryName];
                                self.tabIdBysubCategoryName = @"";
                            }
                        }                        
                        //GS SUPER 매장 추가
                        else if([viewType isEqualToString:HOMESECTSUPLIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeSUPList];
                        }
                        //내일TV VOD매장추가
                        else if([viewType isEqualToString:HOMESECTVODLIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeVODList];
                        }
                        //초이스 매장 NFXCLIST
                        else if([viewType isEqualToString:HOMESECTNFXCLIST]) {
                            tview = [[SectionView alloc] initSpecialTypeWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem] withType:(SectionViewType)SectionViewTypeNewFlexible];
                            
                        }
                        else {
                            tview = [[SectionView alloc] initWithTargetdic:[self.sectionUIitem objectAtIndex:idxNextItem]];
                        }
                    }
                }
                else {
                    
                }
                tview.delegatetarget = (id)self;
                tview.tag = 9999;
                [[carousel2 itemViewAtIndex:idxNextItem] addSubview: tview];
                //in-call 스테이터스바 확장 대응 2016.01 yunsang.jin
                tview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
                tview.frame = tview.superview.bounds;
                [self modifyCarouselViewSetting:carousel2 content:tview];
                NSLog(@"GCD: PROC1 END");
       //         dispatch_semaphore_signal(exeSignal);
            });
      //  });
    }
    
}

#pragma mark - Expanding by scroll


//
- (void)modifyCarouselViewSetting:(UIView *)carousel content:(UIView *)tview {
    if (carousel != tview && tview) {
        [self modifyCarouselViewSetting:carousel content:[tview superview]];
        tview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        if ([tview.superview isKindOfClass:[UIScrollView class]]) {
            tview.frame = CGRectMake(tview.frame.origin.x, 0, tview.superview.bounds.size.width, tview.superview.bounds.size.height);
        }
        else {
            tview.frame = tview.superview.bounds;
        }
    }
}




//
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    currentScrollView = scrollView;
    dragging = YES;
    startScrollOffset = scrollView.contentOffset;
    lastScrollOffset = startScrollOffset;
}


//
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (currentScrollView == scrollView) {
        dragging = NO;
        if (!decelerate) {
            [self glueScrollView:scrollView];
        }
    }
}


//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (currentScrollView == scrollView) {
        if (dragging) {
            CGFloat offsetValue = scrollView.contentOffset.y - lastScrollOffset.y;
            if (!(scrollView.contentOffset.y <= APPTABBARHEIGHT && scrollView.contentSize.height <= APPTABBARHEIGHT + scrollView.bounds.size.height)) {
                if ((scrollView.contentOffset.y <= 0 && offsetValue > 0) || (scrollView.contentSize.height <= scrollView.contentOffset.y + scrollView.bounds.size.height && offsetValue < 0)) {
                    return;
                }
            }
            //2016/12 사이드매뉴 도입으로인한 하단탭바 비노출처리
            [self expandContentView:offsetValue scrollView:scrollView animating:NO];
        }
        lastScrollOffset = scrollView.contentOffset;
    }
}


//
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (currentScrollView == scrollView) {
        dragging = NO;
        [self checkScrollsToTopProperty];
        [self glueScrollView:scrollView];
    }
}


//
- (void)glueScrollView:(UIScrollView *)scrollView {
    if((APPFULLHEIGHT - tabBarView.frame.origin.y) >= 25) {
        [self animateExpanding:-900 scrollView:scrollView]; //Show
    }
    else {
        [self animateExpanding:900 scrollView:scrollView];  //Hidden
    }
}


//
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)_targetContentOffset {
    if (currentScrollView == scrollView) {
        dragging = NO;
        float offset = 0;
        //스크롤 영역 밖일 때 스크롤 처리 막음
        if ((scrollView.contentSize.height <= scrollView.contentOffset.y + scrollView.bounds.size.height) || (scrollView.contentOffset.y <= 0)) {
        }
        else {
            //  맨 위는 그냥 탭 보이게
            if (_targetContentOffset->y <= 0) {
                offset = -900;
            }
            //이동 위치가 50 이상인 경우 탭 조정 처리
            else if (ABS((_targetContentOffset->y - scrollView.contentOffset.y)) > 50) {
                if (scrollView.contentOffset.y < _targetContentOffset->y) {
                    offset = 900;
                }
                else {
                    offset = -900;
                }
            }
        }
        if (offset != 0) {
            //2016/12 사이드매뉴 도입으로인한 하단탭바 비노출처리
            [self animateExpanding:offset scrollView:scrollView];
        }
    }
}



- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    @try {
        //2016/12 사이드매뉴 도입으로인한 하단탭바 비노출처리
        [self animateExpanding:-900 scrollView:scrollView];
    }
    @catch (NSException *exception) {
        NSLog(@"pointer being freed was not allocated: %@",exception);
    }
    @finally {
        
    }
    return YES;
}


//
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    return;
}



//
- (void)expandContentView:(float)offsetValue scrollView:(UIScrollView *)scrollView {
    [self expandContentView:offsetValue scrollView:scrollView animating:NO];
}



- (void)expandContentView:(float)offsetValue scrollView:(UIScrollView *)scrollView animating:(BOOL)animating {
    UIView *searchTopView = self.searchTopBarView;
    UIView *subcategoryView = self.viewMainTabBG;
    UIView *contentView = nil;
    if ([[UIDevice currentDevice].deviceModelName isEqualToString:@"iPhone 4"]) {
        contentView = carousel2.currentItemView;
    }
    else {
        contentView = carousel2;
    }
    
    UIView *customTabBarView = tabBarView;
    if(searchTopView == nil || subcategoryView == nil || contentView == nil || customTabBarView == nil) {
        return;
    }
    //!!! 왜 오프셋 벨류가 900이지?
    if(offsetValue == 900 ) {
        customTabBarView.center = CGPointMake(customTabBarView.center.x, APPFULLHEIGHT + APPTABBARHEIGHT/2.0);
        //self.topMarginSearchBar.constant = (STATUSBAR_HEIGHT - kTopSearchBarHeight);
        searchTopView.frame = CGRectMake(0.0, (STATUSBAR_HEIGHT - kTopSearchBarHeight), searchTopView.frame.size.width, searchTopView.frame.size.height);
        
        subcategoryView.frame = CGRectMake(0.0, STATUSBAR_HEIGHT, subcategoryView.frame.size.width, subcategoryView.frame.size.height);
    }
    else if(offsetValue == -900 ) {
        customTabBarView.center = CGPointMake(customTabBarView.center.x, APPFULLHEIGHT - APPTABBARHEIGHT/2.0);
        //self.topMarginSearchBar.constant = STATUSBAR_HEIGHT;
        
        searchTopView.frame = CGRectMake(0.0, STATUSBAR_HEIGHT, searchTopView.frame.size.width, searchTopView.frame.size.height);
        
        subcategoryView.frame = CGRectMake(0.0, STATUSBAR_HEIGHT + kTopSearchBarHeight, subcategoryView.frame.size.width, subcategoryView.frame.size.height);
    }
    else {
        CGFloat contModify = searchTopView.frame.origin.y - offsetValue;
        CGFloat orginSubY = kTopSearchBarHeight;
        
        //NSLog(@"contModifycontModifycontModify = %f",contModify);
        
        if (contModify > STATUSBAR_HEIGHT ) {
            //self.topMarginSearchBar.constant = STATUSBAR_HEIGHT;
            searchTopView.frame = CGRectMake(0.0, STATUSBAR_HEIGHT, searchTopView.frame.size.width, searchTopView.frame.size.height);
            orginSubY = kTopSearchBarHeight;
        }else if (contModify <= (STATUSBAR_HEIGHT - kTopSearchBarHeight)){
            //self.topMarginSearchBar.constant = (STATUSBAR_HEIGHT - kTopSearchBarHeight);
            searchTopView.frame = CGRectMake(0.0, (STATUSBAR_HEIGHT - kTopSearchBarHeight), searchTopView.frame.size.width, searchTopView.frame.size.height);
            orginSubY = 0.0;
        }else{
            searchTopView.frame = CGRectMake(0.0, contModify, searchTopView.frame.size.width, searchTopView.frame.size.height);
            
            orginSubY = kTopSearchBarHeight - (STATUSBAR_HEIGHT - searchTopView.frame.origin.y);
            //NSLog(@"orginSubYorginSubY = %f",orginSubY);
        }
        //NSLog(@"self.topMarginSearchBar.constant = %f",self.topMarginSearchBar.constant);


        subcategoryView.frame = CGRectMake(0.0, STATUSBAR_HEIGHT + orginSubY , subcategoryView.frame.size.width, subcategoryView.frame.size.height);
        
        customTabBarView.center = CGPointMake(customTabBarView.center.x, customTabBarView.center.y + offsetValue);
        if(customTabBarView.center.y > APPFULLHEIGHT + APPTABBARHEIGHT/2.0) {
            customTabBarView.center = CGPointMake(customTabBarView.center.x, APPFULLHEIGHT + APPTABBARHEIGHT/2.0);
        }
        else if(customTabBarView.center.y < APPFULLHEIGHT - APPTABBARHEIGHT/2.0 ) {
            customTabBarView.center = CGPointMake(customTabBarView.center.x, APPFULLHEIGHT - APPTABBARHEIGHT/2.0);
        }
        
        
    }
    
    CGRect rectContentView = contentView.frame;
    CGRect rectToChange = CGRectMake(0.0,subcategoryView.frame.origin.y + subcategoryView.frame.size
                                     .height,contentView.frame.size.width, customTabBarView.frame.origin.y - (subcategoryView.frame.origin.y + subcategoryView.frame.size.height));
    if(CGRectEqualToRect(rectContentView, rectToChange) == NO) {
        if([[UIDevice currentDevice].deviceModelName isEqualToString:@"iPhone 4"]) {
            if(offsetValue == 900 || offsetValue == -900) {
                contentView.frame = rectToChange;
            }
        }
        else {
            contentView.frame = rectToChange;
        }
    }
}


- (void)animateExpanding:(float)offset scrollView:(UIScrollView *)scrollView {
    
    @try {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             [self expandContentView:offset scrollView:scrollView animating:NO];
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    @catch (NSException *exception) {
        NSLog(@"pointer being freed was not allocated: %@",exception);
    }
    @finally {
        
    }
}




#pragma mark UITextFieldDelegate

- (IBAction)onEditingChanged {
    schTextField.textColor = [UIColor darkGrayColor];
    self.placeholderLabel.alpha = (schTextField.text.length > 0) ? 0.0 : 0.0;
    if(schTextField.text.length > 0) {
        self.btn_schTextFieldClear.hidden = NO;
    }
    else {
        self.btn_schTextFieldClear.hidden = YES;
    }
}


- (IBAction)onEditingStart {
    [self textFieldEditStart:schTextField];
    self.btn_schTextFieldClear.hidden = NO;
    schTextField.textColor = [UIColor darkGrayColor];
    // onediting 시작 순간부터 holderlabel 항상 히든
    self.placeholderLabel.alpha = (schTextField.text.length > 0) ? 0.0 : 0.0;
    self.placeholderLabel.text= GSSLocalizedString(@"search_description_search");
    if(schTextField.text.length > 0) {
        self.btn_schTextFieldClear.hidden = NO;
    }
    else {
        self.btn_schTextFieldClear.hidden = YES;
    }
    //체킹1
    if([self.schTextField isFirstResponder]) {
        NSLog(@"어사인");
    }
    else {
        
    }
}


- (IBAction)onEditingEnd {
    schTextField.textColor = [Mocha_Util getColor:@"a3a3a3"];
    self.placeholderLabel.alpha = (schTextField.text.length > 0) ? 0.0 : 0.0;
    //체킹1
    if([self.schTextField isFirstResponder]) {
        NSLog(@"어사인");
    }
    else {
        
    }
}


- (void)textFieldEditStart:(UITextField *)textField {
    schTextField.inputAccessoryView=nil;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, APPFULLWIDTH, 44)];
        toolBar.barStyle = UIBarStyleDefault;
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:GSSLocalizedString(@"common_txt_alert_btn_complete") style:UIBarButtonItemStylePlain target:self action:@selector(textFieldCancel)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects: flexibleSpace, closeBtn, nil] animated:YES];
        schTextField.inputAccessoryView = toolBar;
    }
    else {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, APPFULLWIDTH, 44)];
        toolBar.barStyle = UIBarStyleBlackOpaque;
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:GSSLocalizedString(@"common_txt_alert_btn_close") style:UIBarButtonItemStyleDone target:self action:@selector(textFieldCancel)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBar setItems:[NSArray arrayWithObjects: flexibleSpace, closeBtn, nil] animated:YES];
        schTextField.inputAccessoryView = toolBar;
    }
}


-(void)textFieldPriv:(UIBarButtonItem *)sender {
    UITextField *nextField = (UITextField *)[self.view viewWithTag:sender.tag-1];
    if (nextField != nil) {
        [nextField becomeFirstResponder];
    }
    else {
        [self textFieldCancel];
    }
}


- (void)textFieldNext:(UIBarButtonItem *)sender {
    UITextField *nextField = (UITextField *)[self.view viewWithTag:sender.tag+1];
    if (nextField != nil) {
        [nextField becomeFirstResponder];
    }
    else {
        [self textFieldCancel];
    }
}

- (void)textFieldCancel {
    self.btn_schTextFieldClear.hidden = YES;
    [schTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self textFieldCancel];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text =@"";
    self.placeholderLabel.alpha = (schTextField.text.length > 0) ? 0.0 : 1.0;
    return  YES;
}

- (IBAction)clearschTextField:(id)sender {
    schTextField.text =@"";
    self.placeholderLabel.alpha = (schTextField.text.length > 0) ? 0.0 : 1.0;
    self.btn_schTextFieldClear.hidden = YES;
    [self onEditingChanged];
}


- (IBAction)onBtnSearch:(id)sender {
    [ApplicationDelegate  GTMsendLog:@"Area_Tracking" withAction:@"MC_SEARCH_App" withLabel:@"Click"];
    // nami0342 - 효율코드수정요청 : 20160509 이주현
    ////탭바제거
    [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=398051")];
    
    if(ApplicationDelegate.viewMainSearch != nil) {
        //검색어 노출전 wkwebview에서 shared로 쿠키복사후 노출
        [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
            [ApplicationDelegate.viewMainSearch openWithAnimated:YES showRelated:YES];
        }];
    }
    
    
    
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
}







#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    return nil;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([[DataManager sharedManager].lastSideViewController isEqual:self.navigationController.viewControllers.lastObject]) {
        ApplicationDelegate.isSideMenuOnTop = YES;
        
        if ([self.navigationController.viewControllers.lastObject isKindOfClass:[AutoLoginViewController class]] && [self.navigationController.viewControllers.lastObject respondsToSelector:@selector(textFieldCancel)]) {
            AutoLoginViewController *lastLoginView = (AutoLoginViewController *)self.navigationController.viewControllers.lastObject;
            [lastLoginView textFieldCancel];
        }
    }    
    else {
        ApplicationDelegate.isSideMenuOnTop = NO;
    }
    if ([viewController isKindOfClass:[self class]]) {
        if (isPromotionViewAdded == YES) {
            basePromotionView.hidden = NO;
            if([NCS([_promotionInfoDic valueForKey:@"bannertype"]) isEqualToString:@"S"]) {
                [self s_promovshow];
            }
        }
    }
    if ([viewController isKindOfClass:[Home_Main_ViewController class]]) {
        [self checkScrollsToTopProperty];
    }
    else {
        [ApplicationDelegate onlyProcSecondsubViewchangePropertyForScrollsToTop:viewController.view boolval:YES];
    }
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isEqual:self]) {
        [[WKManager sharedManager] copyToSharedCookieAll:^(BOOL isSuccess) {
            
        }];
    }else{
        //[[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOALLKILL object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTION_VODVIDEOPAUSE object:nil userInfo:nil];
    }
    
}




- (void)delayedScrollShortBangTop:(NSNumber *)idxShortBang {
    NSInteger idx = [idxShortBang integerValue];
    SectionView *tview = [[[carousel2 itemViewAtIndex:idx] subviews] lastObject];
    if (tview.shortTbv != nil && [tview.shortTbv respondsToSelector:@selector(scrollToShortBangSectionTop)]) {
        [tview.shortTbv scrollToShortBangSectionTop];
    }
}


- (void)onBtnLoginFromAppGuideView {
    if(loginView == nil) {
        loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
    }else{
        [loginView clearTextFields];
    }
    loginView.loginViewType = 4;
    loginView.btn_naviBack.hidden = NO;
    if(![self.navigationController.topViewController isKindOfClass:[AutoLoginViewController class]]) {
        [self.navigationController pushViewControllerMoveInFromBottom:loginView];
    }
}


- (IBAction)onBtnSideMenu:(id)sender {
    [ApplicationDelegate subViewchangePropertyForScrollsToTop:self.view boolval:NO];
    //[ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=412109")];
       
    
    UINavigationController * navigationController = ApplicationDelegate.mainNVC;
    //20200728 parksegun 웹 카테고리로 전환
    ResultWebViewController *resultWebView = nil;
    NSString *strGoUrl = nil;
    if ([[navigationController.viewControllers lastObject] isKindOfClass:[ResultWebViewController class]]) {
       resultWebView = (ResultWebViewController *)[navigationController.viewControllers lastObject];
    }

   
    if (resultWebView !=nil && [resultWebView.wview.URL.absoluteString hasPrefix:CATEGORY_URL]) {
       return;
    }

    strGoUrl = [NSString stringWithFormat:@"%@412109", CATEGORY_URL];;
    if (resultWebView !=nil) {
       [resultWebView goWebView:strGoUrl];
    }
    else {
       resultWebView = [[ResultWebViewController alloc]initWithUrlString:strGoUrl];
       [navigationController pushViewControllerMoveInFromBottom:resultWebView];
    }
    
           
    
    //슈퍼이면.. 키보드 올라와 있는것 취소
    NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"viewType"]);
    if( [viewType isEqualToString:HOMESECTSUPLIST]) {
        SectionView *tview = [[carousel2 itemViewAtIndex:carousel2.currentItemIndex].subviews lastObject];
        [tview.supTbv clearTextFiled];
    }
    
}

- (IBAction)onBtnMyShop:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[Mocha_Util  getCurrentDate:NO] forKey:@"myshopbadgeDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ApplicationDelegate.strMyShop = @"0";
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"0" forKey:@"myshop"];
    [[NSNotificationCenter defaultCenter] postNotificationName:BOTTOM_TABBAR_BADGE_UPDATE object:nil userInfo:userInfo];
    UINavigationController * navigationController = ApplicationDelegate.mainNVC;
    MyShopViewController *myShopWebView = myShopWebView = [[MyShopViewController alloc] initWithNibName:@"MyShopViewController" bundle:nil];
    [myShopWebView firstProc];
    [navigationController pushViewControllerMoveInFromBottom:myShopWebView];
}

- (void)checkScrollsToTopProperty {
    [ApplicationDelegate subViewchangePropertyForScrollsToTop:self.view boolval:NO];
    NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"viewType"]);
    if( [viewType isEqualToString:HOMESECTTDCLIST]) {
        [ApplicationDelegate onlyProcSecondsubTBViewchangePropertyForScrollsToTop:[[carousel2 itemViewAtIndex:carousel2.currentItemIndex].subviews lastObject] boolval:YES];
    }
    else if ([viewType isEqualToString:HOMESECTSLIST]) {
        SectionView *tview = [[carousel2 itemViewAtIndex:carousel2.currentItemIndex].subviews lastObject];
        if (NCO(tview) == YES && [tview.scheduleTbv respondsToSelector:@selector(setScrollToTopLeftTableView)]) {
            [tview.scheduleTbv setScrollToTopLeftTableView];
        }
    }
    //예외를 제거
//    else if ([viewType isEqualToString:HOMESECTEILIST]) {
//        SectionView *tview = [[carousel2 itemViewAtIndex:carousel2.currentItemIndex].subviews lastObject];
//        [ApplicationDelegate onlyProcSecondsubViewchangePropertyForScrollsToTop:[tview.subviews firstObject] boolval:YES];
//    }
    
    
    else if ([viewType isEqualToString:HOMESECTSUPLIST]) {
        //SectionBAN_SLD_GBDtypeCell 자동스크롤제어
        [[NSNotificationCenter defaultCenter] postNotificationName:BAN_SLD_GBD_CHECK object:nil];
        [ApplicationDelegate onlyProcSecondsubViewchangePropertyForScrollsToTop:[[carousel2 itemViewAtIndex:carousel2.currentItemIndex].subviews lastObject] boolval:YES];
    }
    
    else {
        [ApplicationDelegate onlyProcSecondsubViewchangePropertyForScrollsToTop:[[carousel2 itemViewAtIndex:carousel2.currentItemIndex].subviews lastObject] boolval:YES];
        
    }
}

#pragma mark - 메시지 전송 delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//클릭,외부링크,웹뷰 링크에 의해 매장이동
- (void)sectionChangeWithTargetShopNumber:(NSString *)strNumber {
    NSLog(@"매장번호 : %@",strNumber);
    //카테고리 및 섹션 찾기
    int c = 0; // 카테고리 한개 밖에 없음
    NSArray *array = [self.categoryUIitem objectForKey:[NSNumber numberWithInt:c]];
    for (NSInteger i = 0; i < [array count] ; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *sectionCode = NCS([dic objectForKey:@"navigationId"]);
        if([sectionCode isEqualToString:strNumber]) {
            //하단 섹션 탭 및 섹션 컨텐츠 변경 요망
            if([NCS(ApplicationDelegate.groupCode) length] > 0) {
                // sidemenu에서 이동할때 애니메이션을 빼줬으면 한다고 해서 예외 처리 추가 (예정)
                [self changeCategoryTab:c sectionTab:(int)i animated:NO];
            }
            else {
                [self changeCategoryTab:c sectionTab:(int)i animated:YES];
            }
            return;
        }
    }
}

//매장번호로 검색후 존재할경우 매장 리로드후 이동
- (void)sectionReloadWithTargetShopNumber:(NSString *)strNumber {
    NSLog(@"리로드 매장번호 : %@",strNumber);
    //카테고리 및 섹션 찾기
    int c = 0; // 카테고리 한개 밖에 없음
    NSArray *array = [self.categoryUIitem objectForKey:[NSNumber numberWithInt:c]];
    for (NSInteger i = 0; i < [array count] ; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        NSString *sectionCode = NCS([dic objectForKey:@"navigationId"]);
        NSLog(@"sectionCode = %@",sectionCode);
        if([sectionCode isEqualToString:strNumber]) {
            //하단 섹션 탭 및 섹션 컨텐츠 변경 요망
            SectionView *tview = [[[carousel2 itemViewAtIndex:i] subviews] lastObject];
            [tview ScreenDefine];
            [self changeCategoryTab:c sectionTab:(int)i animated:YES];
            return;
        }
    }
    //여기까지온건...TabId 처리가 안된것임. 즉, 매장번호가 없음.  그럼 홈으로 던짐.
    [self.navigationController popViewControllerMoveInFromTop];
}

- (void)moveWebViewStrUrl:(NSString *)strUrl{
    if ([Mocha_Util strContain:@".gsshop.com/index.gs" srcstring:strUrl] && [Mocha_Util strContain:@"tabId=" srcstring:strUrl]) {
        URLParser *parser = [[URLParser alloc] initWithURLString:strUrl];
        if([parser valueForVariable:@"tabId"] != nil) {
            if([parser valueForVariable:@"broadType"] != nil) {
                //편성표 전용 값
                self.tabIdBysubCategoryName = [parser valueForVariable:@"broadType"];
            }
            //20190402 parksegun JBP 하위 매장이동
            //groupCd=416018
            if([parser valueForVariable:@"groupCd"] != nil) {
                [ApplicationDelegate setGroupCode:[parser valueForVariable:@"groupCd"]];
            }
            
            [self sectionChangeWithTargetShopNumber:[parser valueForVariable:@"tabId"]];
            
            if([parser valueForVariable:@"mseq"] != nil) {
                NSString *strSeq = [NSString stringWithFormat:@"?mseq=%@",[parser valueForVariable:@"mseq"]];
                [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(strSeq)];
            }
        }
        
    }
    else if([Mocha_Util strContain:@"/mygsshop/myshopInfo.gs" srcstring:strUrl] ) { //20180427 parksegun 매장에서 myshop링크가 들어오면 하단 탭 누르는 효과 나도 록 수정
        
        NSArray *arrParam = [strUrl componentsSeparatedByString:@"/mygsshop/myshopInfo.gs"];
        if ([arrParam count] > 1 && [NCS([arrParam objectAtIndex:1]) length] > 0) {
            ApplicationDelegate.URLSchemeString = strUrl;
        }
        
        [self onBtnMyShop:nil];
    }
    else {

        //2020/09/14 휴먼 애러도 방어하기위해 리퀘스트 직전에 trim 추가 (기존 로직 수정 안하려고 리퀘스트 할때에만 trim)
        NSString *strCheck = [strUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        URLParser *parser = [[URLParser alloc] initWithURLString:strUrl];
        NSString *strTQ = NCS([parser valueForVariable:@"tq"]);
        if(strTQ.length > 0 && [strUrl rangeOfString:@"%"].location == NSNotFound) {
            strCheck = [strCheck stringByReplacingOccurrencesOfString:strTQ withString:[strTQ urlEncodedString]];
        }
        
        NSURL *urlPreCheck = [NSURL URLWithString:strUrl];
        if ([urlPreCheck.path isEqualToString:@"/prd/prd.gs"] && [urlPreCheck.query containsString:@"prdid="]) {
            strCheck = [NSString stringWithFormat:@"%@&ispre=y",strCheck];
        }

        
        //링크 url 앞에 도메인이 없는경우 웹뷰 로딩 안함
        if ([strCheck hasPrefix:@"http"]){
            ResultWebViewController *result = [[ResultWebViewController alloc] initWithUrlString:strCheck];
            result.delegate = self;
            result.view.tag = 505;
            //result.curUrlUse = YES;
            [DataManager sharedManager].selectTab = 0;
            [self.navigationController  pushViewControllerMoveInFromBottom:result];
        }
    }
}


- (NSDictionary *)loadTestApiUrl:(NSString *)strUrl {
    NSURL *turl = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    [urlRequest setHTTPMethod:@"GET"];
    NSError *error;
    NSURLResponse *response;
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response timeout:30 error:&error];
    return [result JSONtoValue];
}


- (NSString*)currentGSNavigationNameAndIndex {
    NSString *strCurrent = @"";
    SectionView *tview = [[[carousel2 itemViewAtIndex:carousel2.currentItemIndex] subviews] lastObject];
    NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"viewType"]);
    NSString* strIndexPath = @"";
    if([viewType length] > 0 ) {
        //TV쇼핑
        if([viewType isEqualToString:HOMESECTTDCLIST]) {
            NSIndexPath *path = (NSIndexPath *)[[tview.tdcliveTbv.tableView indexPathsForVisibleRows] firstObject];
            strIndexPath = [NSString stringWithFormat:@"index:%ld",(long)path.row];
        }
        //플랙서블
        else if([viewType isEqualToString:HOMESECTFXCLIST] || [viewType isEqualToString:HOMESECTEILIST] ) {
            NSIndexPath *path = (NSIndexPath *)[[tview.fxcTbv.tableView indexPathsForVisibleRows] firstObject];
            strIndexPath = [NSString stringWithFormat:@"index:%ld",(long)path.row];
        }
        //날방 개편 HOMESECTNTCLIST => 숏방으로 변경 => 다시 날방으로 변경
        else if([viewType isEqualToString:HOMESECTNTCLIST]){
            NSIndexPath *path = (NSIndexPath *)[[tview.nalTbv.tableView indexPathsForVisibleRows] firstObject];
            strIndexPath = [NSString stringWithFormat:@"index:%ld",(long)path.row];
        }
        //편성표 매장 추가
        else if([viewType isEqualToString:HOMESECTSLIST]) {
            NSIndexPath *path = (NSIndexPath *)[[tview.scheduleTbv.tableLeftProduct indexPathsForVisibleRows] firstObject];
            strIndexPath = [NSString stringWithFormat:@"index:%ld",(long)path.row];
        }
        //GS SUPER 매장 추가
        else if([viewType isEqualToString:HOMESECTSUPLIST]) {
            NSIndexPath *path = (NSIndexPath *)[[tview.supTbv.tableView indexPathsForVisibleRows] firstObject];
            strIndexPath = [NSString stringWithFormat:@"index:%ld",(long)path.row];
        }
        //내일TV VOD매장 추가
        else if([viewType isEqualToString:HOMESECTVODLIST]) {
            NSIndexPath *path = (NSIndexPath *)[[tview.vodTbv.tableView indexPathsForVisibleRows] firstObject];
            strIndexPath = [NSString stringWithFormat:@"index:%ld",(long)path.row];
        }
        else {
            NSIndexPath *path = (NSIndexPath *)[[tview.tbv.tableView indexPathsForVisibleRows] firstObject];
            strIndexPath = [NSString stringWithFormat:@"index:%ld",(long)path.row];
        }
    }
    
    strCurrent = [NSString stringWithFormat:@"Navi Id:%@ %@",NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"navigationId"]),strIndexPath];
    
    return strCurrent;
}

- (void)checkVODStatusAndPlay:(NSString *)strUrl goProuctWiseLog:(NSString *)strGoProuctWiseLog {
    self.curVODGoProductWiseLog = strGoProuctWiseLog;
    if([NetworkManager.shared currentReachabilityStatus] ==  NetworkReachabilityStatusViaWiFi) {
        [self playrequestVODVideo:strUrl];
    }
    else {
        self.curRequestString = [NSString stringWithString:strUrl];
        Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:
                               DATASTREAM_ALERT maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_no"),  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
        malert.tag = 888;
        [ApplicationDelegate.window addSubview:malert];
    }
    
}


#pragma mark - 매장 편집기능 관련 메서드



//VOD매장에서 지금매장이 VOD인지 확인하기위한 함수
-(BOOL)isCurrentHomeMainTabVODList{
    
    NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"viewType"]);
    if([viewType isEqualToString:HOMESECTVODLIST]) {
        return YES;
    }else{
        return NO;
    }
}

//현재 선택된 매장이 (노출되는) 내껀지 확인하기 위한 메서드
-(BOOL)isCurrentHomeMainTabMyList:(NSString *) listName {
    NSString* viewType = NCS([[self.sectionUIitem objectAtIndex:carousel2.currentItemIndex] objectForKey:@"viewType"]);
    if([viewType isEqualToString:listName]) {
        return YES;
    }
    else {
        return NO;
    }
}




- (IBAction)searchAction:(id)sender {
    //20200520 parksegun
    // 검색버튼 기능 살림
    // 프로모션 텍스트가 있으면 바로 검색 기능 추가
    
    if(self.placeholderLabel.text.length > 0 && ApplicationDelegate.viewMainSearch != nil) {
        [ApplicationDelegate.viewMainSearch goWebViewWithSearchWordOnlyRecommended:self.placeholderLabel.text isHome:YES];
    }
    else {
        //그냥 검색창 열기
        [self onBtnSearch:nil];
    }
    
}


#pragma mark
#pragma mark 키보드 노출 / 비노출 콜백 이벤트 핸들러
- (void) KeyboardWillShow
{
    ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = NO;
}

- (void) KeyboardWillHide
{
    ApplicationDelegate.isAviableBrazeInAppMessagePopupShow = YES;
}


-(void)showTabbarView {
    self.tabBarView.hidden = NO;
    self.tabBarView.frame = CGRectMake(0.0, APPFULLHEIGHT - APPTABBARHEIGHT, APPFULLWIDTH, APPTABBARHEIGHT);
}


@end


