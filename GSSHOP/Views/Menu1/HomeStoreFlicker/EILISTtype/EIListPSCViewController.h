//
//  EIListPSCViewController.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 25..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  이벤트 탭 테이블뷰 컨트롤러

#import "PSCollectionView.h"
#import "Common_Util.h"
#import "URLDefine.h"
#import "SectionTBViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f
typedef enum {
    collectionType          = 1,        //핀터레스트 스타일
    tableType           = 2,            //일반 테이블뷰 스타일
} TABLEVIEWTYPE;

@protocol SectionPSCViewControllerDelegate <NSObject>
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
- (void)touchEventTBCell:(NSDictionary *)dic;
- (void)touchEventBannerCell:(NSDictionary *)dic;
- (void)tablereloadAction;
- (void)btntouchAction:(id)sender;
- (void)btntouchWithDicAction:(NSDictionary*)tdic tagint:(int)tint;
- (void)sectiongoTop;

//베스트딜 하단 핫링크용
-(void)TopCategoryTabButtonClicked:(id)sender;

-(void)transform:(float)angle x:(float)x y:(float)y z:(float)z inView:(UIView*)View;
-(void) customscrollViewDidScroll:(UIScrollView*)scrollView;
-(void)customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
-(void)customscrollViewDidEndDecelerating:(UIScrollView*)scrollView;

//GroupSection셀이 눌렸을 때, GroupSection셀 내부의 버튼이 눌렸을 때 호출됨
- (void)touchEventGroupTBCellWithRowInfo:(NSDictionary *)rowInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender;
//GroupSection 서브 카테고리 버튼, 상단 배너 버튼 눌렸을 때 호출됨. (하단 footer의 로그인 버튼 등은 기존 Section(Home) 방식으로 상속 처리)
- (void)btntouchGroupTBWithApiInfo:(NSDictionary *)apiInfoDic sectionInfo:(NSDictionary *)sectionInfoDic sender:(id)sender;
@end

@class EICategoryView;

@interface EIListPSCViewController : UIViewController <UIScrollViewDelegate,PSCollectionViewDataSource,PSCollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    EICategoryView *eicView;                    //상단 카테고리 선택뷰 이벤트홈,핫이슈,혜택,TV존
    
    CGFloat heightfloatingHeaderView;           //해더뷰 높이 , 핀터레스트 스타일일경우 플로팅 ,일반테이블뷰일경우 sectionHeader 로 처리
    
    int pscViewheaderBANNERheight;              //최상단 띠배너 높이
    int pscViewheaderNo1DealZoneheight;         //넘버원 딜이 있을경우 헤더높이
    int pscViewheaderListheight;                //SE 타입이나 B_IM 타입이 들어올경우 높이값
    int pscViewheaderCateViewHeight;            //카테고리뷰 높이
    int pscViewfooterLoginVheight;              //푸터 높이 ,기존 네이밍 복사해와서 좀 이상함
    
    UIImageView *bannerimg;
    
    NSMutableArray *sectionorigindata;          //이벤트 탭에 뿌려질 모든 데이터 원본 배열

    UIView *refreshHeaderView;                  //테이블뷰 위의 pulltoRefresh
    UIImageView *refreshGSSHOPCircle;           //pulltoRefresh 속의 원형 인디케이터 이미지
    BOOL isDragging;                            //pulltoRefresh 에서 화면 드래깅 여부
    BOOL isLoading;                             //pulltoRefresh 에서 화면 로드중 여부
    
    UIScrollView *scrRefresh;                   //선택된 테이블뷰의 스크롤뷰 포인터
    
}

@property (nonatomic, strong) UIView *refreshHeaderView;
@property (nonatomic, strong) UIImageView *refreshGSSHOPCircle;


@property (nonatomic, strong) NSDictionary *apiResultDic;
@property (nonatomic, strong) NSString *sectionType;

@property (strong, nonatomic) NSMutableArray *sectionarrdata;
@property (strong, nonatomic) NSDictionary *sectioninfodata;

@property (strong, nonatomic) NSMutableArray *BottomCellInforow;

@property (nonatomic, strong) PSCollectionView *pscView;
@property (nonatomic, strong) UITableView *eiTableView;
@property (nonatomic,assign) TABLEVIEWTYPE tableViewType;

@property (weak, nonatomic) id<SectionPSCViewControllerDelegate> delegatetarget;
@property (nonatomic, weak) MochaNetworkOperation* imageLoadingOperation;
@property (weak, nonatomic) MochaNetworkOperation *currentOperation1;
@property (strong, nonatomic) CAAnimation *cubeAnimation;

@property (weak, nonatomic) id<UIScrollViewDelegate> scrollExpandingDelegate;

@property (nonatomic, assign) CGFloat leftPSC; //collection view 좌측 여백

@property (nonatomic,assign) NSInteger indexEIC;
@property (nonatomic,weak) id sectionView;

- (id)initWithSectioninfo:(NSDictionary*)secinfo;

- (void)addPullToRefreshHeader:(UIView *)target;
- (void)startLoading;
- (void)stopLoading;

- (void)reloadAction;
- (void)sectionarrdataNeedMoreData:(PAGEACTIONTYPE)atype;

- (UIView*)topBannerview;
- (BOOL)isExsitSectionBanner;
- (void) tableHeaderDraw;
- (void) tableFooterDraw;

- (void)btntouchAction:(id)sender;


-(void)onBtnEICategory:(NSNumber*)tnum;
- (void)dctypetouchEventTBCell:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;

@end
