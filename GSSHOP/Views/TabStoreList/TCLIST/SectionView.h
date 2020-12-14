//
//  SectionView.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 3..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionTBViewController.h"
#import "URLDefine.h"
#import "SectionHomeFnSView.h"
#import "SubCategoryHomeListView.h"
#import "SectionFPCHeaderView.h"
#import "SectionBestSubCate.h"
#import "SectionFPC_SubCategoryView.h"
#import "SectionCX_SLD_HeaderView.h"
#import "SectionCX_CATE_HeaderView.h"


#define TBREFRESHBTNVIEW_TAG 3739
//특별히 tbv 두개를 가진 SPECIAL type의 우측 tbv 갱신가이드뷰를 위한
#define TBREFRESHBTNVIEWRIGHT_TAG 3740
#define  SECTION_SUBCATEGORY_BUTTON_TAG 20000
#define  SECTION_SUBCATEGORY_OPEN_BUTTON_TAG 21000
#define  SECTION_BANNER_BUTTON_TAG 30000
#define CURRENT_SECTION_INDEXDNUM 10000
#define SECTIONSEARCHVIEWHEIGHT 40.0f
#define SECTIONFPCVIEWHEIGHT 45.0f
//TDC섹션뷰 상단헤더
#define TDCSECTIONSEARCHVIEWHEIGHT 40.0f

@class TDCLiveTBViewController;
@class BCListTBViewController;
@class FXCListTBViewController;
@class EIListPSCViewController;
@class NTCListTBViewController;
@class NSTFCListTBViewController;
@class SListTBViewController;
@class FeedListTableViewController;
@class SUPListTableViewController;
@class VODListTableViewController;
@class NFXCListTableViewController;
@class NFXCListViewController;

typedef enum  {
    SectionViewTypeHome, //홈
    SectionViewTypeTVShop, //홈-TV쇼핑
    SectionViewTypeFlexible, //홈-플랙서블
    SectionViewTypeNewEvent, //홈-이벤트
    SectionViewTypeNalbang, //홈-날방
    SectionViewTypeShortbang, //홈-숏방
    SectionViewTypeSchedule, //홈-편성표매장    
    SectionViewTypeSUPList, //홈-GS SUPER매장
    SectionViewTypeVODList, //홈-내일TV VOD매장
    SectionViewTypeNewFlexible //홈-뉴플렉서블 Choice 매장
} SectionViewType;


@protocol SectionViewDelegate <NSObject>
@optional
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
- (void)touchEventTBCell:(NSDictionary *)dic;
- (void)touchEventBannerCell:(NSDictionary *)dic;
- (void)btntouchAction:(id)sender;
- (void)btntouchWithDicAction:(NSDictionary*)tdic tagint:(int)tint;
- (void)latelysetscrollstotop;
//베스트딜 하단 핫링크용
- (void)TopCategoryTabButtonClicked:(id)sender;
//GroupSection셀이 눌렸을 때, GroupSection셀 내부의 버튼이 눌렸을 때 호출됨
- (void)touchEventGroupTBCellWithRowInfo:(NSDictionary *)rowInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender;
//GroupSection 서브 카테고리 버튼, 상단 배너 버튼 눌렸을 때 호출됨. (하단 footer의 로그인 버튼 등은 기존 Section(Home) 방식으로 상속 처리)
- (void)btntouchGroupTBWithApiInfo:(NSDictionary *)apiInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender;
//GroupSection이 추천딜인데 데이터가 없는 경우 Alert 처리하기 위해 호출됨
- (void)showDealHasNoItemsAlertWithSectionInfo:(NSDictionary*)sectioninfo;
//숏방 클릭용
- (void)touchEventShortBang:(NSDictionary *)dic index:(NSInteger)index indexCate:(NSInteger)indexCate arrShortBangAll:(NSArray*)arrSB imageRect:(CGRect)imageRect backGroundImage:(UIImage *)image apiString:(NSString *)strApi;
@end

@class SectionTBViewController;
@interface SectionView : UIView <SectionViewDelegate> {
    NSMutableArray *sectionarrdata;
    id<SectionViewDelegate>  __weak delegatetarget;
    NSNumber *sectiongoTopnotinum;
    NSDictionary *_sectioninfoDic;
    BOOL isHiddenTopTabview;
    BOOL isBtnAlphaZero;
    BOOL isFirstwiseAppLog;
    CGFloat prevOffsety;
}

@property (strong, nonatomic) UIButton* btngoTop;
@property (strong, nonatomic) UIButton* btnSiren;
@property (weak, nonatomic) id<SectionViewDelegate> delegatetarget;
@property (strong, nonatomic) SectionTBViewController* tbv;
@property (strong, nonatomic) NSMutableArray *sectionarrdata;
@property (weak, nonatomic) NSURLSessionDataTask *currentOperation1;
@property (nonatomic) NSInteger currentCateinfoindex;
@property (nonatomic) NSInteger currentOrderinfoindex;
//HOME Filter N Order
@property (strong, nonatomic) SectionHomeFnSView* homeHeaderView;
@property (strong, nonatomic) SubCategoryHomeListView* subcategoryHomeListView;
//2016/05 베스트매장 카테고리용 yunsang.jin
@property (strong, nonatomic) SectionFPCHeaderView* headerViewFPC;
@property (strong, nonatomic) SectionFPCtypeSubview *viewFPC;
@property (strong, nonatomic) UIView* headerViewFPCSub;
@property (strong, nonatomic) SectionFPC_SubCategoryView *viewFPC_SubCate;
//2016/11 베스트 매장 서브카테고리 추가
@property (nonatomic ,strong) SectionBestSubCate *viewBestSubCate;
@property (strong, nonatomic) SectionCX_SLD_HeaderView * headerViewCX_SLD;
@property (nonatomic, strong) NSString* tabIdBysubCategoryName; //20180622 parksegun tabId로 이동시 필요값을 노출한다.
@property (strong, nonatomic) SectionCX_CATE_HeaderView * headerViewCX_CATE;
@property (nonatomic) SectionViewType sectionViewType; //sectionView 정보 외부에서 접근 가능하도록 수정

@property (strong, nonatomic) UIView *headerFlowView; // 플로팅뷰,틀고정뷰

// nami0342 - CSP
@property (nonatomic, strong) NSNumber *m_iNavigationID;
@property (nonatomic, strong) UIButton *m_btnCSPIcon;
@property (nonatomic, strong) UIButton *m_btnMessageNLink;
@property (nonatomic, strong) UIButton *m_btnMessageNLink2;

@property (nonatomic, strong) NSDictionary  *m_dicMsg;
@property (nonatomic, readwrite) int        m_iType;
@property (nonatomic, readwrite) BOOL       m_isAnimating;
@property (nonatomic, readwrite) float      m_fXpos;
@property (nonatomic, strong) NSString  *m_strCSPType;
@property (nonatomic, strong) UIImageView   *m_imgvCursor;

- (void) CSP_ShowIcon : (NSNotification *) notification;
- (void) CSP_HideIcon : (NSNotification *) notification;
- (void) CSP_clickIcon : (id) sender;
- (void) CSP_WebLink : (id)sender;
- (void) CSP_ShowMessage : (NSDictionary *) dicMsg;
- (void) CSP_disappearMessage;



- (SectionHomeFnSView *)viewhomeheaderView;
- (void)viewheaderFPCTitle:(NSDictionary *)rowinfo andIndex:(NSInteger)index andSubIndex:(NSInteger)subIndex showCrown:(BOOL)isShow;
- (id)initWithTargetdic:(NSDictionary*)sectioninfo;
- (void)ScreenDefine;
- (void)ScreenReDefine;
- (void)ScreenDefineHomeWith:(BOOL)isReDefine;
- (void)sectiongoTop;
- (void)ActionBtnContentRefresh:(id)sender;
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
- (void)touchEventTBCell:(NSDictionary *)dic;
- (void)touchEventBannerCell:(NSDictionary *)dic;
- (void)sectiongoTopNReload: (NSNotification *)noti;
- (id)initSpecialTypeWithTargetdic:(NSDictionary*)sectioninfo withType:(SectionViewType)stype;
- (id)initSpecialTypeWithTargetdic:(NSDictionary*)sectioninfo withType:(SectionViewType)stype subCategory:(NSString *)subCate;
- (SectionViewType)getSectionViewType;
- (UIView*)RefreshGuideView;
- (void)SectionViewAppear;
- (void)SectionViewAppear:(NSString *) subCate;
- (void)SectionViewDisappear;
//HOME Filter N Order
- (void)HomeGrvclose;
- (void)HomeDisplaysubCategoryView:(BOOL)disp;
- (void)HomeSubcategoryOpenButtonClicked:(id)sender;
- (void)FILTERACTIONHOMECATEGORYSELECT:(NSString*)catename  andtag:(NSInteger)index;
- (void)ProcSyncAfter:(void (^)(void))handler;
- (void)FPCDisplayView:(BOOL)disp;
- (void)FPCGrvclose;
- (void)FPCCategoryOpenButtonClicked:(id)sender;
- (void)FPCDisplayCategoryView:(BOOL)disp;
- (void)FPCDisplaySubCategoryView:(BOOL)disp andCateHeaderShow:(BOOL)isHeaderShow;
- (void)onBtnCateTag:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic;
- (void)onBtnCateSub:(NSInteger)subIndex withInfoDic:(NSDictionary *)dic;
- (NSDictionary *)loadTestApiUrl:(NSString *)strUrl;
-(NSString *)checkAdidRequest:(NSString *)strRequest;

@property (nonatomic, strong) NSDictionary *homeSectionApiResult;
@property (strong, nonatomic) UIView *bg_section_mask;
//for TV쇼핑
@property (strong, nonatomic) TDCLiveTBViewController* tdcliveTbv;
//for Flexiable 2015/07/22 jin
@property (strong, nonatomic) FXCListTBViewController* fxcTbv;
//for NewEvent
@property (strong, nonatomic) EIListPSCViewController* eiPcv;
//for 날방
@property (strong, nonatomic) NTCListTBViewController* nalTbv;
//for 숏방
@property (strong, nonatomic) NSTFCListTBViewController* shortTbv;
//for 편성표 매장
@property (strong, nonatomic) SListTBViewController* scheduleTbv;
//for 29cm 매장
@property (strong, nonatomic) FeedListTableViewController* feedTbv;
//for GS SUPER 매장
@property (strong, nonatomic) SUPListTableViewController* supTbv;
//for VOD 매장
@property (strong, nonatomic) VODListTableViewController* vodTbv;

//for Choice 매장
//@property (strong, nonatomic) NFXCListTableViewController* nfxcTbv;

/// NFXC 매장 ViewController
@property (strong, nonatomic) NFXCListViewController* nfxcTbv2;

//CSLIST & TDCLIST 사용중
@property (nonatomic, strong) NSDictionary *specialSectionApiResult;
@property (nonatomic, strong) NSDictionary *specialSectionRightApiResult;
@end
