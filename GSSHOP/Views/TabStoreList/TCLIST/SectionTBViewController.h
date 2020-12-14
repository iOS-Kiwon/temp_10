//
//  SectionTBViewController.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 2. 3..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionDefaultCell.h"
#import "SectionDCtypeCell.h"
#import "SectionDCtypeCell.h"
#import "SectionPItypeCell.h"
#import "SectionEItypeCell.h"
#import "SectionDStypeCell.h"
#import "SectionNO1typeView.h"
#import "SectionTSLtypeCell.h"
#import "TVSCDHeaderView.h"
#import "Common_Util.h"
#import "URLDefine.h"
#import "AppDelegate.h"

#import "CellSubInfoData.h"
#import "SectionBIXLtypeCell.h"
#import "SectionDSLAtypeCell.h"
#import "SectionDSLBtypeCell.h"
#import "DataTVCategoryCell.h"
#import "SectionBIXStypeCell.h"
#import "SectionBIStypeCell.h"
#import "SectionBIMtypeCell.h"
#import "SectionBILtypeCell.h"
#import "SectionBIM440StypeCell.h"
#import "SectionBIXLtypeCell.h"
#import "SectionBMIAtypeCell.h"
#import "SectionBSIStypeCell.h"
#import "SectionPSLtypeCell.h"
//#import "SectionBTStypeCell.h"
#import "SectionDCMLtypeCell.h"
#import "SectionSEtypeView.h"
#import "SectionSPLtypeCell.h"
#import "SectionSPCtypeCell.h"
#import "SectionPCtypeCell.h"
#import "SectionB_HIMtypeCell.h"
#import "SectionB_IG4XNtypeCell.h"
#import "SectionTAB_SLtypeCell.h"
#import "SectionBTLtypeCell.h"
#import "SectionBFPtypeCell.h"
#import "SectionBTS2typeCell.h"
#import "MDCScrollBarLabel.h"
#import "SectionTCFtypeCell.h"
#import "SectionRPStypeCell.h"
#import "SectionFPCtypeCell.h"
#import "SectionTPStypeCell.h"
#import "SectionBP_OtypeCell.h"
#import "SectionB_INStypeCell.h"
#import "SectionPDVtypeCell.h"
#import "SectionB_TSCtypeCell.h"
#import "SectionB_ITtypeCell.h"
#import "SectionB_DHStypeCell.h"
#import "SectionNHPtypeCell.h"
#import "SectionB_ISStypeCell.h"
#import "SectionHFtypeCell.h"
#import "SectionNTCHeaderBroadCell.h"
#import "SectionNTCHeaderBannerCell.h"
#import "SectionNSTFCMoreView.h"
#import "SectionSCFtypeCell.h"
#import "SectionSBTtypeCell.h"
#import "SectionSSLtypeCell.h"
#import "SectionBestSubCate.h"
#import "SectionB_CMtypeCell.h"
#import "SectionBAN_SLD_GBABtypeView.h" //헤더
#import "SectionBAN_SLD_GBAtypeCell.h"
#import "SectionBAN_SLD_GBBtypeCell.h"
#import "SectionMAP_SLD_C3_GBAtypeCell.h"
#import "SectionTPSAtypeCell.h"
//AI 플랙서블
#import "SectionBAN_MUT_H55_GBAtypeCell.h"
#import "SectionMAP_MUT_CATEGORY_GBAtypeCell.h"
//AD 구좌 추가
#import "SectionBAN_TXT_IMG_GBAtypeCell.h"
#import "SectionBAN_SLD_GBCtypeCell.h"
//프로모션 구좌
#import "SectionMAP_CX_GBA_1typeCell.h"
#import "SectionMAP_CX_GBA_2typeCell.h"
#import "SectionMAP_CX_GBA_3typeCell.h"
//데이터 없음.
#import "SectionNODATAtypeCell.h"
//TV쇼핑탭 더블
#import "SectionBAN_IMG_C2_GBATypeCell.h"
//TV쇼핑탭 테마키워드쇼핑
#import "SectionBAN_IMG_C3_GBATypeCell.h"
#import "SectionBAN_TXT_IMG_COLOR_GBAtypeCell.h"
#import "SectionBAN_CX_SLD_CATE_GBATypeCell.h"
#import "SectionBAN_CX_CATE_GBATypeCell.h"
#import "SectionBAN_TXT_CHK_GBAtypeCell.h"
//CSP 배너
#import "SectionCSP_LOGIN_BAN_IMG_GBAtypeCell.h"


#import "HomeMainBroadMobileLive.h"

//GroupSection 서브 카테고리 버튼, 상단 배너 버튼 tag base
#define GROUP_SECTION_SUBCATEGORY_BUTTON_TAG 20000
#define GROUP_SECTION_SUBCATEGORY_OPEN_BUTTON_TAG 21000
#define GROUP_SECTION_BANNER_BUTTON_TAG 30000
#define SPECIALRIGHTTOP_HEIGHT 36
#define BANNERHEIGHT 50.0f
#define LIVETALKBANNERHEIGHT 59.0f
//TVShopping section : TDCLiveTBV & TDCDataTBV
#define kTVSHOPPINGTVCHEIGHT 210
//BESTTVAreaView
#define kBESTDEALTVCHEIGHT 160
#define kTDCLIVEBROADHEIGHT 180 //LiveTVAreaView
#define kBESTDEALTVCBTNHEIGHT 40
#define kTVCVHEIGHT 216
#define kTVCBOTTOMMARGIN 9
#define MARGIN_NARROW 1
#define CATEGORYMENUTAG0 5000  //브랜드관 카테고리 태그1
#define CATEGORYMENUTAG1 5001  //브랜드관 카테고리 태그2
#define CATEGORYMENUTAG2 5002  //브랜드관 카테고리 태그3
#define CATEGORYMENUTAG3 5003  //브랜드관 카테고리 태그4
#define TVCREQUESTMAXCOUNT 30   //방송종료후 재요청 제한횟수
#define CALCCELLHEIGHT @"calcHeight" //동적 계산된 셀의 높이 키이름 (이미지 높이)
//#define BAN_IMG_C2_GBB_HEIGHT ((APPFULLWIDTH/2.0) - 15.0) + 109 + 4 + kTVCBOTTOMMARGIN        // 19.08.08 이전 BFPtype 높이
#define BAN_IMG_C2_GBB_HEIGHT (APPFULLWIDTH/2.0) + 100 + 16 + 4 + 16 + 13    // 가변이미지뷰(상하여백포함) + 제품뷰 + margin + 혜택뷰높이 + 사이 margin + 구매중 높이 + bot margin

#define HomeMainBroad_heightPriceArea 116.0f
#define heightHomeMainBroadView (50.0+roundf((APPFULLWIDTH - 32.0)*(1.0/2.0))+ HomeMainBroad_heightPriceArea +1.0)

static NSString *DCtypeIdentifier = @"SectionDCtypeCell";
static NSString *DCtypeIdentifier_S = @"SectionDCtypeCell_S";
static NSString *PItypeIdentifier = @"SectionPItypeCell";
static NSString *EItypeIdentifier = @"SectionEItypeCell";
static NSString *DStypeIdentifier = @"SectionDStypeCell";
static NSString *Defaultdentifier = @"SectionDefaultCell";
static NSString *BIMtypeIdentifier = @"SectionBIMtypeCell";
static NSString *BIM440typeIdentifier = @"SectionBIM440StypeCell";
static NSString *BIXStypeIdentifier = @"SectionBIXStypeCell";
static NSString *BIStypeIdentifier = @"SectionBIStypeCell";
static NSString *BILtypeIdentifier = @"SectionBILtypeCell";
static NSString *BIXLtypeIdentifier = @"SectionBIXLtypeCell";
static NSString *BMIAtypeIdentifier = @"SectionBMIAtypeCell";
static NSString *BSIStypeIdentifier = @"SectionBSIStypeCell";
static NSString *PSLtypeIdentifier = @"SectionPSLtypeCell";
static NSString *BTStypeIdentifier = @"SectionBTStypeCell";
static NSString *TSLtypedentifier = @"SectionTSLtypeCell";
static NSString *DSLAtypedentifier = @"SectionDSLAtypeCell";
static NSString *DSLBtypedentifier = @"SectionDSLBtypeCell";
static NSString *SS_LINEtypedentifier = @"SectionSS_LINEtypeCell";
static NSString *SUBSECtypeIdentifier = @"DataTVCategoryCell";
//static NSString *SRLtypedentifier = @"SectionSRLtypeCell";
static NSString *SPLtypedentifier = @"SectionSPLtypeCell";
static NSString *SPCtypedentifier = @"SectionSPCtypeCell";
static NSString *PCtypedentifier = @"SectionPCtypeCell";
static NSString *B_HIMtypedentifier = @"SectionB_HIMtypeCell";
static NSString *B_IG4XNtypedentifier = @"SectionB_IG4XNtypeCell";
static NSString *TAB_SLtypedentifier = @"SectionTAB_SLtypeCell";
static NSString *BTLtypedentifier = @"SectionBTLtypeCell";
//20160501 parksegun 신규 뷰타입 추가
static NSString *BFPtypedentifier = @"SectionBFPtypeCell";
static NSString *BTS2typedentifier = @"SectionBTS2typeCell";
static NSString *TCFtypedentifier = @"SectionTCFtypeCell";
static NSString *RPStypedentifier = @"SectionRPStypeCell";
static NSString *FPCtypedentifier = @"SectionFPCtypeCell";
static NSString *TPStypeIdentifier = @"SectionTPStypeCell";
static NSString *BPISXtypeIdentifier = @"SectionBPISXtypeCell";
static NSString *BPOtypeIdentifier = @"SectionBP_OtypeCell";
static NSString *B_INStypedentifier = @"SectionB_INStypeCell";
static NSString *B_SICtypedentifier = @"SectionB_SICtypeCell";
static NSString *PDVtypedentifier = @"SectionPDVtypeCell";
static NSString *B_TSCtypedentifier = @"SectionB_TSCtypeCell";
static NSString *B_ITtypedentifier = @"SectionB_ITtypeCell";
static NSString *B_DHStypedentifier = @"SectionB_DHStypeCell";
static NSString *NHPtypedentifier = @"SectionNHPtypeCell";
static NSString *B_ISStypeIdentifier = @"SectionB_ISStypeCell";
static NSString *HFtypedentifier = @"SectionHFtypeCell";
static NSString *NTCHeaderBroadIdentifier = @"SectionNTCHeaderBroadCell";
static NSString *B_NIStypeIdentifier = @"SectionNTCHeaderBannerCell";
static NSString *NSTFCMoreIdentifier = @"SectionNSTFCMoreView";
static NSString *SCFtypedentifier = @"SectionSCFtypeCell";
//숏방
static NSString *SBTtypeIdentifier = @"SectionSBTtypeCell";
static NSString *SSLtypeIdentifier = @"SectionSSLtypeCell";
static NSString *B_CMtypeIdentifier = @"SectionB_CMtypeCell";
static NSString *BAN_SLD_GBAtypeIdentifier = @"SectionBAN_SLD_GBAtypeCell";
static NSString *BAN_SLD_GBBtypeIdentifier = @"SectionBAN_SLD_GBBtypeCell";
static NSString *MAP_SLD_C3_GBAtypeIdentifier = @"SectionMAP_SLD_C3_GBAtypeCell";
static NSString *TPSAtypeIdentifier = @"SectionTPSAtypeCell";
static NSString *BAN_MUT_H55_GBAtypeIdentifier = @"SectionBAN_MUT_H55_GBAtypeCell";
static NSString *MAP_MUT_CATEGORY_GBAtypeIdentifier = @"SectionMAP_MUT_CATEGORY_GBAtypeCell";
static NSString *BAN_IMG_H000_GBAtypeIdentifier = @"SectionBAN_IMG_H000_GBAtypeCell";
static NSString *BAN_IMG_H000_GBBtypeIdentifier = @"SectionBAN_IMG_H000_GBBtypeCell";
static NSString *BAN_TXT_IMG_GBAtypeIdentifier = @"SectionBAN_TXT_IMG_GBAtypeCell";
static NSString *BAN_SLD_GBCtypeIdentifier = @"SectionBAN_SLD_GBCtypeCell";
static NSString *MAP_CX_GBA_1typeIdentifier = @"SectionMAP_CX_GBA_1typeCell";
static NSString *MAP_CX_GBA_2typeIdentifier = @"SectionMAP_CX_GBA_2typeCell";
static NSString *MAP_CX_GBA_3typeIdentifier = @"SectionMAP_CX_GBA_3typeCell";
static NSString *NODATAtypeIdentifier = @"SectionNODATAtypeCell";
static NSString *BAN_IMG_C2_GBAtypeIdentifier = @"SectionBAN_IMG_C2_GBATypeCell";
static NSString *BAN_IMG_C2_GBBtypeBaseIdentifier = @"SectionBAN_IMG_C2_GBBTypeBaseCell";
static NSString *BAN_IMG_C3_GBAtypeIdentifier = @"SectionBAN_IMG_C3_GBATypeCell";
static NSString *BAN_TXT_IMG_COLOR_GBAtypeIdentifier = @"SectionBAN_TXT_IMG_COLOR_GBAtypeCell";
static NSString *BAN_CX_SLD_CATE_GBAtypeIdentifier = @"SectionBAN_CX_SLD_CATE_GBATypeCell";
static NSString *BAN_CX_CATE_GBAtypeIdentifier = @"SectionBAN_CX_CATE_GBAtypeCell";
static NSString *MAP_CX_TXT_GBAtypeIdentifier = @"SectionMAP_CX_TXT_GBAtypeCell";
static NSString *BAN_TXT_CHK_GBAtypeIdentifier = @"SectionBAN_TXT_CHK_GBAtypeCell";
static NSString *CSP_LOGIN_BAN_IMG_GBAtypeIdentifier = @"SectionCSP_LOGIN_BAN_IMG_GBAtypeCell";

///인기검색어
static NSString *BAN_TXT_EXP_GBAtypeIdentifier = @"SectionBAN_TXT_EXP_GBATypeCell";
static NSString *BAN_TXT_EXP_GBA_OtypeIdentifier = @"SectionBAN_TXT_EXP_GBA_OTypeCell";
/// 서비스 매장 바로가기 영역
static NSString *BAN_IMG_C5_GBAtypeIdentifier = @"SectionBAN_IMG_C5_GBAtypeCell";

///배너
static NSString *BAN_TXT_IMG_LNK_GBBtypeIdentifier = @"SectionBAN_TXT_IMG_LNK_GBBtypeCell";
static NSString *BAN_TXT_IMG_LNK_GBAtypeIdentifier = @"SectionBAN_TXT_IMG_LNK_GBAtypeCell";


typedef enum {
    POPULARHIGH = 1,
    NEWEST = 2
} SECTIONORDERTYPE;


typedef enum {
    SectionContentsBase = 1,
    TVLiveContentsBase = 2,
    TVLiveContentReload = 3
} TVCONTENTBASE;


typedef enum {
    ONLYDATASETTING = 1,
    HOLDRELOADING = 2,
    FULLRELOADING = 3
} PAGEACTIONTYPE;

typedef enum {
    HEADER_BTYPE_LIVE = 1,
    HEADER_BTYPE_MYSHOP = 2,
    HEADER_BTYPE_MOBILELIVE = 3
} HEADER_BROAD_TYPE;

@protocol SectionTBViewControllerDelegate <NSObject>
@optional
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
- (void)touchEventTBCell:(NSDictionary *)dic;
- (void)touchEventBannerCell:(NSDictionary *)dic;
- (void)tablereloadAction;
- (void)btntouchAction:(id)sender;
- (void)btntouchWithDicAction:(NSDictionary*)tdic tagint:(int)tint;
- (void)sectiongoTop;
- (void)setbtnTopDisplayed:(BOOL)displayed animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
- (void)touchEventShortBang:(NSDictionary *)dic index:(NSInteger)index indexCate:(NSInteger)indexCate arrShortBangAll:(NSArray*)arrSB imageRect:(CGRect)imageRect backGroundImage:(UIImage *)image apiString:(NSString *)strApi;
//베스트딜 하단 핫링크용
- (void)TopCategoryTabButtonClicked:(id)sender;
- (void)transform:(float)angle x:(float)x y:(float)y z:(float)z inView:(UIView*)View;
- (void)customscrollViewDidScroll:(UIScrollView*)scrollView;
- (void)customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)customscrollViewDidEndDecelerating:(UIScrollView*)scrollView;
//GroupSection셀이 눌렸을 때, GroupSection셀 내부의 버튼이 눌렸을 때 호출됨
- (void)touchEventGroupTBCellWithRowInfo:(NSDictionary *)rowInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender;
//GroupSection 서브 카테고리 버튼, 상단 배너 버튼 눌렸을 때 호출됨. (하단 footer의 로그인 버튼 등은 기존 Section(Home) 방식으로 상속 처리)
- (void)btntouchGroupTBWithApiInfo:(NSDictionary *)apiInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender;
- (void)viewheaderFPCTitle:(NSDictionary *)rowinfo andIndex:(NSInteger)index andSubIndex:(NSInteger)subIndex showCrown:(BOOL)isShow;
- (void)viewheaderCX_SLD;
- (void)viewheaderCX_CATE;
- (void)CX_SLDDisplayView:(BOOL)disp cateView:(SectionBAN_CX_SLD_CATE_GBASubView*)viewCX_SLD_CATE;
- (void)CX_CATEDisplayView:(BOOL)disp cateView:(SectionBAN_CX_CATE_GBASubView*)viewCX_CATE;
- (void)headerFlowViewDisplay:(BOOL)disp headerView:(UIView *) viewORD;

- (void)FPCCategoryOpenButtonClicked:(id)sender;
- (void)FPCGrvclose;
- (void)FPCDisplayCategoryView:(BOOL)disp;
- (void)FPCDisplayView:(BOOL)disp;
- (void)FPCApiFilter:(NSString*)strApiUrl;
@end

@class HomeMainBroadView;

@interface SectionTBViewController : PullRefreshTableViewController  <UITableViewDataSource, UITableViewDelegate, SectionTBViewControllerDelegate,  UIScrollViewDelegate,TTTAttributedLabelDelegate/*,UIViewControllerPreviewingDelegate*/>  {
    
@protected
    id<SectionTBViewControllerDelegate> __weak delegatetarget;
    UIImageView *bannerimg;
    UIImageView *tvcimg;
    UIImageView *broadgraphimg;
    NSMutableArray *sectionorigindata;
    NSDictionary *tvcdic;
    NSDictionary *tvcdicMyShop;
    NSDictionary *tvcdicMobileLive;
    
    
    BOOL isOnlySetText;
    BOOL isPagingComm;
    UILabel *lefttimelabel;
    int tableheaderBANNERheight;
    int tableheaderTVCVheight;
    int tableheaderTDCTVCBTNVheight;
    //아래는 베스트딜에서만 사용
    int tableheaderTVCBOTTOMMARGIN;
    int tableheaderListheight;
    int tableheaderNo1DealListheight;
    int tableheaderNo1DealZoneheight;
    int tablefooterLoginVheight;
    NSString *TvcNotifiTitle;
    int animtbindex;
    //방송 종료시점후 재요청
    int TVCapirequestcount;
    id<UIScrollViewDelegate> __weak scrollExpandingDelegate;
    int tbviewrowmaxNum;
    
    NSMutableDictionary *dicNeedsToCellClear;     // ML동영상셀의 동영상 끝까지 플레이 여부, 리로드시 처음부터 재생할지,재생된 상태로 표현할지의 여부
    NSMutableDictionary *dicMLCellPlayControl;     // ML동영상의셀의 스크롤뷰 위치를 비교해서 자동플레이 , 스탑 여부조절용
    NSInteger idxTCF;                               // TCF 셀의 인덱스 indexPath.row SectionTCFtypeCell.h
    NSInteger idxFPC;                               // FPC 셀의 인덱스 indexPath.row SectionFPCtypeCell.h
    NSInteger idxTCFCate;                           // TCF 셀의 선택된 카테고리 인덱스
    NSInteger idxFPCCate;                           // FPC 셀의 선택된 카테고리 인덱스
    NSMutableDictionary *dicFPCInfo;                // FPC 셀 정보 , 테이블뷰의 스크롤이 해당 영역을 넘어갈경우 테이블뷰 상단에 플로팅 시킬때 사용
    CGRect rectFPCCell;                             // FPC 셀 CGRect값 , 테이블뷰의 스크롤이 해당 영역을 넘어갈경우 테이블뷰 상단에 플로팅 시킬때 사용
    BOOL isFPC;                                     // FPC 셀 존재여부 , 테이블뷰 상단에 플로팅영역을 add 할지 말지의 조건
    NSInteger idxFPCCateSub;                        // FPC 셀 서브 카테고리 인덱스 값 2016/11 추가
    BOOL isHFCell;                                  // HF 셀 존재여부 SectionHFtypeCell
    NSInteger idxHF;                                // HF 셀 인덱스 indexPath.row
    NSInteger idxHFCate;                            // HF 셀 선택된 카테고리 인덱스
    CGRect rectHFCell;                              // HF 셀 CGRect값 , 해쉬테그를 클릭할경우 테이블 뷰의 스크롤 포지션이동을 위해 저장
    NSMutableDictionary *dicHFResult;               // HF 셀 아래 선택된 헤쉬테그와 , 검색된 갯수 저장
    NSMutableDictionary  *m_dicRPSs;                      // RPS 셀이 여러 개일 경우 처리
    NSInteger idxFlexCate;                          // MAP_MUT_CATEGORY_GBA용 위치 인덱스
    NSInteger idxFlexCateSelected;                  // MAP_MUT_CATEGORY_GBA용 선택인덱스
    NSString *ajaxPageUrl;                          // 페이징 처리할 URL 저장소. 없으면 처리 하지 않는다. for ajaxPageUrl
    
    NSInteger idxCX_SLD;                            // CX_SLD 셀의 인덱스 indexPath.row SectionFPCtypeCell.h
    NSInteger idxCX_SLDCate;                        // CX_SLD 셀의 선택된 카테고리 인덱스
    BOOL isCX_SLD;                                  // CX_SLD 셀 존재여부 , 테이블뷰 상단에 플로팅영역을 add 할지 말지의 조건
    CGRect rectCX_SLDCell;                          // CX_SLD 셀 CGRect값 , 테이블뷰의 스크롤이 해당 영역을 넘어갈경우 테이블뷰 상단에 플로팅 시킬때 사용
    
    NSInteger idxCX_CATE;                            // CX_CATE 셀의 인덱스
    NSInteger idxCX_SelectCate;                        // CX_CATE 셀의 선택된 카테고리 인덱스
    BOOL isCX_CATE;                                  // CX_CATE 셀 존재여부 , 테이블뷰 상단에 플로팅영역을 add 할지 말지의 조건
    CGRect rectCX_CATECell;                          // CX_CATE 셀 CGRect값 , 테이블뷰의 스크롤이 해당 영역을 넘어갈경우 테이블뷰 상단에 플로팅 시킬때 사용
    
    
    //brand Zzim Popup UI
    UIView *dimmView;
    UIImageView *brdZzimImg;
    UIButton *brdZzimClose;
    UIButton *brdZzimBtn;
    NSString *brdZzimTargetUrl;
    
    NSTimer *timerPRD_C_SQ;
    BOOL isCheckPRD_C_SQ;                       //개인화 셀 노출여부와 전송여부를 동시에 체크
}


@property (nonatomic, strong) MDCScrollBarLabel *scrollBarLabel;
@property (nonatomic, assign) NSTimeInterval scrollBarFadeDelay;
@property (nonatomic, strong) NSDictionary *apiResultDic;
@property (nonatomic, strong) NSString *sectionType;
@property (strong, nonatomic) NSMutableArray *sectionarrdata;
@property (strong, nonatomic) NSDictionary *sectioninfodata;
@property (strong, nonatomic) NSMutableArray *BottomCellInforow;
@property (weak, nonatomic) id<SectionTBViewControllerDelegate> delegatetarget;
@property (nonatomic, weak) MochaNetworkOperation* imageLoadingOperation;
@property (weak, nonatomic) NSURLSessionDataTask *currentOperation1;
@property (strong, nonatomic) CAAnimation *cubeAnimation;
@property (assign, nonatomic) BOOL isExistADCategory;
@property (nonatomic, strong) SectionBAN_CX_SLD_CATE_GBASubView *CX_SLD_CATEView;
@property (nonatomic, strong) SectionBAN_CX_CATE_GBASubView *CX_CATEView;
@property (nonatomic, assign) NSInteger idxCSPbanner;

@property (nonatomic, strong) NSTimer *timerBrdZzimPopup;

@property (nonatomic, assign) BOOL isTVLiveA;

@property (nonatomic, strong) HomeMainBroadView *viewHeaderLive;
@property (nonatomic, strong) HomeMainBroadView *viewHeaderMyShop;
@property (nonatomic, strong) HomeMainBroadMobileLive *viewHeaderMobileLive;

@property (nonatomic, assign) CGRect frameMoviePlaying;
@property (nonatomic, assign) BOOL isHeaderMoviePlaying;
@property (nonatomic, assign) CGRect frame3GAlert;
@property (nonatomic, assign) BOOL isHeader3GAlert;

//동영상 전체보기 진입할경우 가로세로 바뀌는경우가 발생해서 사용함
@property (nonatomic, assign) CGFloat widthFixed;
@property (nonatomic, assign) BOOL  m_isABTest;

//DealCell 터치 전용
- (void)touchEventDealCell:(NSDictionary *)dic;
- (void)setApiResultDic:(NSDictionary *)resultDic;
- (id)initWithSectionResult:(NSDictionary*)resultDic sectioninfo:(NSDictionary*)secinfo;
- (void)sectionarrdataNeedMoreData:(PAGEACTIONTYPE)atype;
///filter관련
- (NSMutableArray*)orderprocforfilter:(NSMutableArray*)dataSet ordertype:(SECTIONORDERTYPE)otype subcateidx:(NSInteger)cateindex;
- (void)filteredApiResultDicforHome:(NSInteger)cateindex;
- (void)btntouchWithLinkStr:(id)sender;
- (void)btntouchWithLinkStrBD:(id)sender;
- (void)dctypetouchEventTBCell:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
//FPC 셀 카테고리 선택
- (void)onBtnFPCCate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
- (void)onBtnFPCCateSub:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
- (void)setFPCSubCateView:(SectionBestSubCate *)viewSubCate;
- (void)reloadAction;
- (void)refresh;
- (void)btngoTop;
- (void)tableHeaderDraw:(TVCONTENTBASE)tvcbasesource;
- (void)tableFooterDraw;
- (UIView*)footerLoginView;
- (UIView*)footerHotLinkLoginView;
- (UIView*)topBannerview;
- (UIView*)listBottomview;
//- (NSString *)getDateLeft:(NSString *)date;
- (BOOL)isExsitSectionBanner;
- (void)tvshoppingHeaderReload;

- (double)leftLiveTVTime;
//tv방송종료확인 새로고침
//- (void)refreshCheckNDrawTVC;
- (void)reconfigureVisibleCells;//베딜 오토스크롤 제어용 + 동영상 자동재생 제어용
- (void)homeSectionChangedPauseDealVideo;//홈메인에서 색션이 바뀔 경우 자동 재생중이던 베딜 동영상을 무조건 pause

@property (weak, nonatomic) id<UIScrollViewDelegate> scrollExpandingDelegate;


//FPC셀이 있을경우 애드 및 테이블뷰 스크롤 포지션 조절
- (void)checkFPCMenu;
//TCF셀 카테고리 선택
- (void)selectLiveBestCategory:(NSInteger)index;
//날방에서 배너 링크 프로토 타입이필요해서 추가
- (void)BannerCellPress;
//- (void)procGraphAnimation:(TVCONTENTBASE)sbase;
- (void)onBtnFlexCate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
- (void)touchSubProductStatus:(BOOL)isShowMore andIndexPath:(NSIndexPath*)idxPath;

- (void)loadMoreDataUrl;

//GS X Brand
- (void)onBtnCX_SLDCate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
//event
- (void)onBtnCX_Cate:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
// 해당셀 숨김
- (void)tableCellRemove:(NSInteger )position;
// 해당셀을 리로드
- (void)tableCellReload:(NSInteger)position;
// 계산된 셀 높이를 갱신한다.
- (void)tableCellReloadForHeight:(NSString*)h indexPath:(NSIndexPath*)indexPath;
// 변경된 구조체를 갱신한다.
- (void)tableCellReloadForDic:(NSDictionary *)dic cellIndex:(NSIndexPath *)position;
//베스트 매장 전체보기
- (void)onBtnBAN_TXT_CHK_GBA:(NSDictionary *)dic andIndex:(NSInteger)index;
//CSP 데이터 요청 메서드 비동기
- (void)callCSP;

-(void)showMotherRequest:(NSDictionary *)dicRequest;

//브랜드 찜 팝업 노출
- (void)brandZzimShowPopup:(NSString *)targetUrl add:(BOOL) isAdd;
//데이터파일 키/값 업데이트
- (void)tableDataUpdate:(NSObject *)value key:(NSString*)rkey cellIndex:(NSInteger)position;
- (void)tableDataUpdateBool:(BOOL)value key:(NSString*)rkey cellIndex:(NSInteger)position viewType:(NSString *) type;

//듀얼플레이어 클릭
-(void)touchEventDualPlayerJustLinkStr:(NSString *)strLink;
//듀얼플레이어 사이즈변경
-(void)tableHeaderChangeSizeDual:(CGSize)sizeChange;
//B타입 펼지고 접기
-(void)tableHeaderChangeSizeBTypeIsSpread:(BOOL)isSpread isLiveBroad:(HEADER_BROAD_TYPE)headerBrdType mobileLiveBroadStart:(BOOL)isMLStart;

-(void)updateHeaderDicInfo:(NSDictionary*)dicToUpdate broadType:(HEADER_BROAD_TYPE)headerBrdType;
-(void)updateHeaderMoviePlaying:(BOOL)isPlaying;
-(void)updateHeader3GAlert:(BOOL)isShow3GAlert andHeaderType:(HEADER_BROAD_TYPE)headerBrdType;

- (BOOL)isPMOIMG:(NSString *) veiwType;

-(void)touchEventTBCellJustLinkStr:(NSString *)strLink;
    
-(void)reCheckPRD_C_SQ;
-(void)invaildatePRD_C_SQ;

-(void)checkDealloc;
// nami0342 -  3D touch
//@property (nonatomic, strong) id previewingContext;
//-(void)forceTouchIntialize;
@end
