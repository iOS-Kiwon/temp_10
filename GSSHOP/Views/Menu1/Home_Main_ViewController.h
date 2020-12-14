//
//  Home_Main_ViewController.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 9. 10..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "AutoLoginViewController.h"
#import "ResultWebViewController.h"
#import "UINavigationController+Category.h"
#import "GSWKWebview.h"
#import "PMS.h"
#import "SectionWebView.h"
#import "CustomBadge.h"
#import "PromotionView.h"
#import "SectionView.h"
#import "CooKieDBManager.h"
#import "iScroll.h"
#import "iCarousel.h"
#import "SSRollingButtonScrollView.h"
#import "LastPrdCustomTabBarView.h"
#import <Lottie/Lottie.h>

typedef enum  {
    CURMAINVIEWTYPEAPPMAIN,
    CURMAINVIEWTYPEWEBMAIN,
} CURMAINVIEWTYPE;


typedef void (^ResponseBlock)(BOOL isSuccess);

@interface Home_Main_ViewController : UIViewController <WKNavigationDelegate, LoginViewCtrlPopDelegate, UIScrollViewDelegate, UITextFieldDelegate, ResultWebViewDelegate, SSRollingButtonScrollViewDelegate,   iCarouselDelegate, iCarouselDataSource ,UINavigationControllerDelegate,MFMessageComposeViewControllerDelegate> {
    
    
    GSWKWebview* wview;
    NSString* curRequestString;
    UIView* basePromotionView;
    PromotionView* view_Promotion;
    UIView* basePersonalView;
    PromotionView* view_Personal;
    NSDictionary *_promotionInfoDic;
    NSDictionary *dicPersonalPopup;
    
    //터치뷰 초기 y포인트저장용
    float tspoint;
    CGRect cuvframe;
    float _carouselIsTouch;
    //웹뷰터치 초기 y포인트저장용
    float wv_initypos;
    float wv_instant_ypos;
    // 메인 탭 - 시작 섹션뷰 인덱스
    int _intmainsection;
    CURMAINVIEWTYPE _curmaintype;
    BOOL isfcd;
    int _carouselmenuMaxwidth;
    BOOL isPushProcing;
    SSRollingButtonScrollView *carousel1;
    iCarousel *carousel2;
	int _currentCategory;
    int _lastcarousel1tab;
	
	//검색 바
	UIView *searchBar;
    BOOL isCommingPromoKey;
    //최초 API 실행 플래그
    //BOOL isFirstAPI;
    BOOL isFirstSectionLoading;
    BOOL isFirstAppboylog;
    BOOL isValidRemoteResources;
    BOOL isingReloadComm;
    NSMutableArray *promotionKeyDic;
    
    
    BOOL isPopFromShortBang;
    BOOL isPromotionViewAdded;
    CustomBadge *badgeMyShop;

    
    //상하단 히든기능 아래 모든 메서드에서 return 처리제외
    CGPoint startScrollOffset;
    CGPoint lastScrollOffset;
    CGPoint targetScrollOffset;
    int scrollDirection;
    UIScrollView *currentScrollView;
    BOOL dragging;
    
    //20190225 parksegun 개인화 탭 편집 기능 API 및 파라메터
//    NSString *tabPrsnlSaveUrl;
//    BOOL tabPrsnlYn;
//    CGFloat tabPrsnlWidth;
//    BOOL prsnlSave; // 탭매장 저장 플래그
    //BOOL tabPrsnlAb; // 탭매장 편집 A/B 버튼 노출
    
    NSInteger idxPrevCarousel1;  //2019/09/26메인탭 무한루프 매장 인덱스 변경 체크용
    BOOL isMoveFromExt;
}

//최초 API 실행 플래그
@property (nonatomic, readwrite)   BOOL isFirstAPI;

@property (nonatomic, strong) LastPrdCustomTabBarView *tabBarView;
@property (nonatomic, strong) AutoLoginViewController *loginView;
@property (nonatomic, strong) NSString *HomewiseLogUrl;
@property (nonatomic, assign) CGRect cuvframe;
@property (nonatomic, strong) IBOutlet GSWKWebview *wview;
@property (nonatomic, strong) NSString* curRequestString;
@property (nonatomic, strong) NSString* curVODGoProductWiseLog;
@property (strong, nonatomic) NSURLSessionDataTask *currentOperation1;
//그룹매장 API용
@property (retain, nonatomic) NSURLSessionDataTask *currentOperation2;
//찜 API용
@property (retain, nonatomic) NSURLSessionDataTask *currentOperation3;
@property (nonatomic, strong) UIView *blurview;
@property (nonatomic, strong) IBOutlet UIButton *btn_gsbi;
@property (nonatomic, strong) IBOutlet UIImageView *imgGSBI;
@property (nonatomic, strong) IBOutlet UIImageView *imgSearchBG;
@property (nonatomic, strong) IBOutlet UIButton *btn_schbtn;
@property (nonatomic, strong) IBOutlet UITextField *schTextField;
@property (nonatomic, strong) IBOutlet UIButton *btn_schTextFieldClear;
@property (nonatomic, strong) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, strong) NSString* tabIdBysubCategoryName; //20180622 parksegun tabId로 이동시 필요값을 노출한다.
@property (nonatomic, strong) NSString* tabIdByTabId;        //20190627 yunsang.jin tabId
@property (nonatomic, strong) NSString* tabIdByAddParam;        //20190627 yunsang.jin tabId로 lseq처리용
@property (nonatomic, strong) IBOutlet UIButton *m_btnCateSlide;
@property (nonatomic, readwrite) BOOL isFirstLoadingAccessibility;

@property (nonatomic, strong) IBOutlet UIView *viewMainTabBG;           //2019/09/26메인탭 무한루프 담을 뷰
@property (nonatomic, strong) IBOutlet UIView *viewMainTabGradiLeft;    //2019/09/26메인탭 무한루프 좌측 그라디에이션
@property (nonatomic, strong) IBOutlet UIView *viewMainTabGradiRight;   //2019/09/26메인탭 무한루프 우측 그라디에이션
@property (nonatomic, strong) LOTAnimationView      *aniView;


@property (nonatomic, strong) NSMutableArray *recommendedRelatedSearchArray; //20200512 추천 연관 검색어

- (void) DrawCartCountstr;
- (IBAction)wvReload:(id)sender;
- (IBAction)goSmartCart:(id)sender;
- (void)PromoSetOnSearchField;
//textfield Event mapping
- (IBAction)onEditingChanged;
- (IBAction)onEditingStart;
- (IBAction)onEditingEnd;
- (void)delayGoWebviewWithcurRequestString;
- (void)goWebView:(NSString *)url;
- (void) firstProc;
- (void)webViewReload;
- (void)appModalReAction:(NSString*)tgurl;
- (void)appModalLogin;

//요청 생방송 재생 live
- (void)playrequestLiveVideo:(NSString*)requrl;
//요청 VOD 재생 
- (void)playrequestVODVideo:(NSString*)requrl;
- (void)ShowPromotionPopUp;
- (void)WithPushGoSection;
- (void)sectionChangeWithTargetPushNum;
- (void)goselectidxCarousel1;
- (void)goselectidxCarousel2;
- (void)ScreenDefineFlickerType;
- (void)ScreenDefineWebViewType;
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
- (void)touchEventTBCell:(NSDictionary *)dic;
- (void)touchEventBannerCell:(NSDictionary *)dic;


- (void)latelysetscrollstotop;
- (void)ClickPromotionPopupBtn:(NSNumber*)sendernum;
- (void)ClickPushAgreePopupBtn:(NSNumber*)sendernum;

//매장 개인화 팝업 2018.04.05
- (void)ClickPersonalPopupBtn:(NSNumber*)sendernum;
- (BOOL)OnlineImageSaveProcWithUrl:(NSDictionary*)tdic withIndex:(int)idxnum withUpdateDate:(NSString*)udtstr;

// 상단 검색바
@property (nonatomic, strong) IBOutlet UIView *topSliderCoverView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lcontCoverViewHeight;
@property (nonatomic, retain) IBOutlet UIView *searchTopBarView;
- (void)expandContentView:(float)plusValue scrollView:(UIScrollView *)scrollView;

//찜 용 (로그인 후 동작 위해)
@property (retain, nonatomic) NSDictionary *favoriteProductInfo;
- (void)checkScrollsToTopProperty;
- (void)checkViewChangeForDealVideo:(BOOL)isForceStop;//홈메인에서 색션이 바뀔 경우 자동 재생중이던 베딜 동영상 pause
- (void)onBtnLoginFromAppGuideView;
- (void)moveWebViewStrUrl:(NSString *)strUrl;
- (void)showPromotionPopup_async;
- (IBAction)onBtnSideMenu:(id)sender;
- (IBAction)onBtnMyShop:(id)sender;
- (void)sectionChangeWithTargetShopNumber:(NSString *)strNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginSearchBar;
- (void)checkVODStatusAndPlay:(NSString *)strUrl goProuctWiseLog:(NSString *)strGoProuctWiseLog;
- (void)homeMainBaseProcess;
- (NSString*)currentGSNavigationNameAndIndex;
//매장ID로 리로드후 이동
- (void)sectionReloadWithTargetShopNumber:(NSString *)strNumber;
//
- (void) detectAccessibility : (NSNotification*) notification;

//VOD매장에서 지금매장이 VOD인지 확인하기위한 함수
-(BOOL)isCurrentHomeMainTabVODList;
-(BOOL)isCurrentHomeMainTabMyList:(NSString *) listName;

// 탭바를 노출한다.
-(void)showTabbarView;



@end
