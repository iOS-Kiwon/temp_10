//
//  VODListTBViewController.h
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 4. 8..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import "SectionTBViewController.h"
#import "SectionBAN_ORD_GBAtypeCell.h"
#import "SectionBAN_VOD_GBAtypeCell.h"
#import "SectionBAN_ORD_GBAtypeview.h"

#define BRD_VODCell_heightPriceArea 116.0f

//#import "BRD_VODCell.h"

static NSString *BAN_ORD_GBAtypeIdentifier = @"SectionBAN_ORD_GBAtypeCell";
static NSString *BAN_IMG_SLD_GBAtypeIdentifier = @"SectionBAN_IMG_SLD_GBAtypeCell";
static NSString *BAN_VOD_GBAtypeIdentifier = @"SectionBAN_VOD_GBAtypeCell";
static NSString *MAP_CX_TXT_GBBtypeIdentifier = @"SectionMAP_CX_TXT_GBBtypeCell";

static NSString *BRD_VODCellIdentifier = @"BRD_VODCell";

@interface VODListTableViewController : SectionTBViewController <UITableViewDataSource, UITableViewDelegate, SectionTBViewControllerDelegate,  UIScrollViewDelegate,TTTAttributedLabelDelegate> {
    NSInteger idxORD;                            // CX_SLD 셀의 인덱스 indexPath.row SectionFPCtypeCell.h
    NSInteger idxORD_SelectedCate;                        // CX_SLD 셀의 선택된 카테고리 인덱스
    BOOL isORD;                                  // CX_SLD 셀 존재여부 , 테이블뷰 상단에 플로팅영역을 add 할지 말지의 조건
    CGRect rectORDCell;                          // CX_SLD 셀 CGRect값 , 테이블뷰의 스크롤이 해당 영역을 넘어갈경우 테이블뷰 상단에 플로팅 시킬때 사용
    CGFloat lastPostion;
    
    CGPoint lastOffset;
    NSTimeInterval lastOffsetCapture;
}
@property (nonatomic,strong) SectionBAN_ORD_GBAtypeview *BAN_ORD_GBAView; // 플로팅뷰 / 틀고정은 아니지만 위로 스크롤 할때만 나오는 뷰...
@property (nonatomic,weak) id sectionView;                  //상위 sectionView
@property (nonatomic,strong) NSIndexPath *pathVODPlaying;
@property (nonatomic,strong) NSMutableDictionary *dicOpenWaitCells; //셀이 펼쳐지기 전까지만 기록후 펼쳐지면 삭제
@property (nonatomic, assign) CGFloat fixedWidth;
@property (nonatomic, assign) CGFloat fixedHeight;

- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo;       //초기화
- (void)apiCall_ListChange:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
- (void)setIndexPathForVODPlaying:(NSIndexPath *)path andStatus:(NSString *)strStatus;
- (void)checkTableViewAppear; //테이블뷰나 나타날때 호출됩니다.
-(void)closeTooltip;

- (void)touchEventTBCell:(NSDictionary *)dic;
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
-(void)checkDeallocVOD;
@end
