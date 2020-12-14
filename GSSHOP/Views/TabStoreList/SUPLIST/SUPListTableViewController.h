//
//  SUPListTableViewController.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <MOCHA/MOCHA.h>
#import "SectionTBViewController.h"

#import "AutoLoginViewController.h"

#import "SectionBAN_GSF_LOC_GBAtypeCell.h"
#import "SectionBAN_SLD_GBDtypeCell.h"
#import "SectionMAP_C8_SLD_GBAtypeCell.h"

#import "SectionMAP_CX_GBB_PRDtypeCell.h"
#import "SectionMAP_CX_GBB_MOREtypeCell.h"
#import "SectionMAP_CX_GBB_CATEtypeCell.h"
//#import "SectionSUP_ViewCateFreezePans.h"


static NSString *BAN_IMG_GSF_GBATypeIdentifier = @"SectionBAN_IMG_GSF_GBAtypeCell";
static NSString *BAN_GSF_LOC_GBAtypeIdentifier = @"SectionBAN_GSF_LOC_GBAtypeCell";
static NSString *BAN_SLD_GBDTypeIdentifier = @"SectionBAN_SLD_GBDtypeCell";
static NSString *MAP_C8_SLD_GBATypeIdentifier = @"SectionMAP_C8_SLD_GBAtypeCell";
static NSString *MAP_CX_GBB_TITLETypeIdentifier = @"SectionMAP_CX_GBB_TITLEtypeCell";
static NSString *MAP_CX_GBB_PRDTypeIdentifier = @"SectionMAP_CX_GBB_PRDtypeCell";
static NSString *MAP_CX_GBB_MORETypeIdentifier = @"SectionMAP_CX_GBB_MOREtypeCell";
static NSString *MAP_CX_GBB_CATETypeIdentifier = @"SectionMAP_CX_GBB_CATEtypeCell";
static NSString *SUPBannerModalTypeIdentifier = @"SectionSUPBannerModalCell";
static NSString *SCH_BAN_NO_DATATypeIdentifier = @"SCH_BAN_NO_DATATypeCell"; //no_data




@protocol SectionSUPListViewControllerDelegate <NSObject>
@optional
- (void)touchEventTBCellJustLinkStr:(NSString*)linkstr;
- (void)customscrollViewDidScroll:(UIScrollView*)scrollView;
- (void)customscrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)customscrollViewDidEndDecelerating:(UIScrollView*)scrollView;
- (void)tablereloadAction;
- (void)btntouchAction:(id)sender;
@end

@class SectionBAN_IMG_GSF_GBAtypeCell;

@interface SUPListTableViewController : SectionTBViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, SectionSUPListViewControllerDelegate,  UIScrollViewDelegate , LoginViewCtrlPopDelegate, UITextFieldDelegate> {
    SectionMAP_C8_SLD_GBAtypeCell *searchCell;    
}

@property (nonatomic, strong) NSDictionary *dicResult;
@property (nonatomic, strong) NSString *curRequestString;

@property (nonatomic, strong) IBOutlet UIView *viewCartPopup;
@property (nonatomic, strong) IBOutlet UIImageView *imgCartPopup;
@property (nonatomic, strong) NSTimer *timerCart;


- (void)reloadAction;
- (void)setResultDic:(NSDictionary *)resultDic;
- (void)onBtnSUPCellJustLinkStr:(NSString*)linkstr;
- (void)touchSubProductShowMoreIndexPath:(NSIndexPath*)idxPath;
- (void)addCartProcess:(NSDictionary *)dicSeleted;
- (void)onBtnSLD_GBD_ShowAll:(NSMutableArray *)arrAll;
- (void)callLogin:(NSString*)linkstr;
- (BOOL)goSearch:(UITextField *)textField;

- (IBAction)onBtnCartPopup:(id)sender;

- (void)onBtnCateFreezePans:(NSInteger)idxSelected;
- (void)changeMartDeliveryWithStrUrl:(NSString *)strUrl;
- (void)checkTableViewAppear; //테이블뷰나 나타날때 호출됩니다.
- (void)showTooltip:(SectionBAN_IMG_GSF_GBAtypeCell *)cell;
- (void)clearTextFiled; // 키보드 숨김처리
- (void)checkDeallocSUP;
- (void)removeFreezPanses; //탑으로 이동할때 카테고리 탭 제거
@end

@interface UIImage (FILLSIZE)
- (UIImage *)aspectFillToSize:(CGSize)size;
@end
