//
//  SListTBViewController.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 3. 28..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionTBViewController.h"
#import "SCH_MAP_MUT_LIVETypeCell.h"
#import "SCH_BAN_TXT_NEXTTypeCell.h"
#import "SCH_BAN_TXT_PRETypeCell.h"

#import "SCH_MAP_MUT_SUBTypeCell.h"
#import "SCH_BAN_TXT_TIMETypeCell.h"
#import "SCH_BAN_MUT_SPETypeCell.h"
#import "SCH_MAP_ONLY_TITLETypeCell.h"

#import "AutoLoginViewController.h"
#import "SListAlarmPopupView.h"

#import "SCH_MAP_MUT_LIVECell.h"

#define widthTableLeftProduct (APPFULLWIDTH - 102.0)

typedef enum {
    ProcessTypeReload          = 1,
    ProcessTypeInsertAtZero    = 2,
    ProcessTypeLastAdd         = 3,
    ProcessTypeNetError        = 4
} ProcessType;


static NSString *SCH_BAN_MUT_SPETypeIdentifier = @"SCH_BAN_MUT_SPETypeCell";
static NSString *SCH_MAP_MUT_LIVETypeIdentifier = @"SCH_MAP_MUT_LIVETypeCell";
static NSString *SCH_MAP_MUT_MAINTypeIdentifier = @"SCH_MAP_MUT_MAINTypeCell";
static NSString *SCH_MAP_MUT_SUBTypeIdentifier = @"SCH_MAP_MUT_SUBTypeCell";
static NSString *SCH_BAN_TXT_TIMETypeIdentifier = @"SCH_BAN_TXT_TIMETypeCell";
static NSString *SCH_BAN_IMG_W540TypeIdentifier = @"SCH_BAN_IMG_W540TypeCell";
static NSString *SCH_MAP_ONLY_TITLETypeIdentifier = @"SCH_MAP_ONLY_TITLETypeCell";
static NSString *SCH_BAN_MORETypeIdentifier = @"SCH_BAN_MORETypeCell";
static NSString *SCH_DAYTypeIdentifier = @"SCH_DAYTypeCell";
//static NSString *SCH_PRO_BAN_THMTypeIdentifier = @"SCH_PRO_BAN_THMTypeCell";
//static NSString *SCH_PRO_TXT_NEXTTypeIdentifier = @"SCH_PRO_TXT_NEXTTypeCell"; //footer
//static NSString *SCH_PRO_TXT_PRETypeIdentifier = @"SCH_PRO_TXT_PRETypeCell"; //header
//static NSString *SCH_PRO_TXT_DATETypeIdentifier = @"SCH_PRO_TXT_DATETypeCell";
static NSString *SCH_BAN_TXT_NEXTTypeIdentifier = @"SCH_BAN_TXT_NEXTTypeCell"; //header
static NSString *SCH_BAN_TXT_PRETypeIdentifier = @"SCH_BAN_TXT_PRETypeCell"; // footer
static NSString *SCH_BAN_TXT_DATETypeIdentifier = @"SCH_BAN_TXT_DATETypeCell";
//static NSString *SCH_PRO_NO_DATATypeIdentifier = @"SCH_PRO_NO_DATATypeCell"; //no_data

static NSString *SCH_MAP_MUT_LIVEIdentifier = @"SCH_MAP_MUT_LIVECell";

@protocol SListTBViewControllerDelegate <NSObject>
@optional
- (void)touchEventTBCell:(NSDictionary *)dic;
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
- (void)tablereloadAction;
- (void)btntouchWithDicAction:(NSDictionary*)tdic tagint:(int)tint;
- (void)sectiongoTop;
- (void)customscrollViewDidScroll:(UIScrollView*)scrollView;
- (void)customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)customscrollViewDidEndDecelerating:(UIScrollView*)scrollView;
@end


@interface SListTBViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,SListTBViewControllerDelegate,LoginViewCtrlPopDelegate> {
    NSInteger idxSelectedNavi;
    //NSInteger idxSelectedRight;
    NSInteger idxLeftOnAir;
    //BOOL isMoveFromRightTimeLine;
    BOOL isNaviBtnTouch;
    BOOL isLiveDataChanged;
    BOOL isFinishLoad;
    NSTimer *timerOnAir;
    SListAlarmPopupView *viewAlarmPopup;
    BOOL is_NODATA;    
}

@property (nonatomic,strong) IBOutlet UIView *viewLeftBGLine;
@property (nonatomic,strong) IBOutlet UIImageView *imgBgShadow;
@property (nonatomic,strong) IBOutlet UITableView *tableLeftProduct;
//@property (nonatomic,strong) IBOutlet UITableView *tableRightTimeLine;
@property (nonatomic,strong) IBOutlet UITableView *tableNavi;
@property (nonatomic,strong) IBOutlet UIView *viewDayNavi;
@property (nonatomic,strong) IBOutlet UIView *viewOnAir;
@property (nonatomic,strong) IBOutlet UILabel *lblOnAirTime;
@property (nonatomic, strong) NSDictionary *dicOnAir;
@property (nonatomic, strong) NSDictionary *dicResult;
@property (strong, nonatomic) NSMutableArray *arrLeftProduct;
//@property (strong, nonatomic) NSMutableArray *arrRightTimeLine;
@property (strong, nonatomic) NSMutableArray *arrDayNavi;
@property (strong, nonatomic) NSMutableDictionary *dicLeftAnchor;
//@property (strong, nonatomic) NSMutableDictionary *dicRightAnchor;
@property (strong, nonatomic) NSMutableDictionary *dicNaviAnchor;
@property (nonatomic, strong) NSDictionary *dicHeader;
@property (nonatomic, strong) NSDictionary *dicFooter;
@property (strong, nonatomic) NSDictionary *sectioninfodata;
@property (weak, nonatomic) id<SListTBViewControllerDelegate> delegatetarget;
@property (nonatomic, weak) MochaNetworkOperation* imageLoadingOperation;
@property (weak, nonatomic) NSURLSessionDataTask *currentOperation;
@property (weak, nonatomic) NSURLSessionDataTask *currentOperationOnAir;
@property (nonatomic,strong) NSString *strReloadUrl;
@property (weak, nonatomic) id<UIScrollViewDelegate> scrollExpandingDelegate;
@property (nonatomic,strong) NSDictionary *dicLiveUrl;
@property (nonatomic,strong) NSDictionary *dicDataUrl;
@property (nonatomic,strong) NSString *strBrdType;
@property (nonatomic,strong) NSMutableArray *arrLastMoreUrl;
@property (nonatomic,strong) IBOutlet UIView *viewToggleSwitch;
@property (nonatomic,strong) IBOutlet UIView *viewToggleBG;
@property (nonatomic,strong) IBOutlet UIView *viewToggleLive;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lconstToggleLive;

- (void)setResultDic:(NSDictionary *)resultDic withAddType:(ProcessType)requestType;
- (void)setScrollToTopLeftTableView;
- (void)onBtnNaviDay:(NSDictionary *)dic cellIndex:(NSInteger) index;
- (void)touchSubProductStatus:(BOOL)isShowMore andIndexPath:(NSIndexPath*)idxPath;
- (void)liveCellSaleCountEnd:(NSIndexPath *)path;
- (void)hideRightTimeLineOnImage:(NSIndexPath *)pathFromLeft;
- (void)requestAlarmWithDic:(NSDictionary *)dicProduct andProcess:(NSString *)strProcess andPeroid:(NSString *)strPeriod andCount:(NSString *)strCount;

/// cell 높이를 동적으로 변화되도록
- (void)tableCellReloadForHeight:(NSDictionary *)dic indexPath:(NSIndexPath *) indexPath;

// header, footer Action
- (void)onHeaderFooterAction:(NSInteger)tag data:(NSDictionary*)info;
- (IBAction)switchAction:(id)sender;

- (BOOL)isLiveBrd;
- (void)checkDeallocSList;
@end
