//
//  SCH_MAP_MUT_LIVECell.h
//  GSSHOP
//
//  Created by gsshop iOS on 06/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#define SCH_MAP_MUT_LIVE_heightPriceArea 116.0f

#import <UIKit/UIKit.h>

@interface SCH_MAP_MUT_LIVECell : UITableViewCell {
    NSTimer *timerLive;
}
@property (nonatomic, strong) NSDictionary *dicRow;
@property (nonatomic, strong) NSDictionary *dicAll;
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSString *imageURL;


@property (nonatomic, strong) IBOutlet UIView *viewImageArea;
@property (nonatomic, strong) IBOutlet UIImageView *imgProduct;
@property (nonatomic, strong) IBOutlet UIImageView *imgNoImg;

@property (nonatomic, strong) IBOutlet UILabel *lblProductTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDiscountRate;                        //할인율
@property (nonatomic, strong) IBOutlet UILabel *lblBasePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblBasePriceWon;
@property (nonatomic, strong) IBOutlet UIView *viewBasePriceStrikeLine;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBasePriceLeading;
@property (nonatomic, strong) IBOutlet UILabel *lblPerMonth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstPerMonthMargine;

@property (nonatomic, strong) IBOutlet UILabel *lblSalePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblSalePriceWon;

//@property (nonatomic, strong) IBOutlet UILabel *lblCounsel;
@property (nonatomic, strong) IBOutlet UIButton *btnAlarm;
@property (nonatomic, strong) IBOutlet UIButton *btnLiveTalk;
@property (nonatomic, strong) IBOutlet UIButton *btnDirectOrd;

@property (nonatomic, strong) IBOutlet UIView *viewContents;
@property (nonatomic, strong) IBOutlet UIView *viewLiveTalk;
@property (nonatomic, strong) IBOutlet UIView *viewAlarm;
@property (nonatomic, strong) IBOutlet UIView *viewDirectOrd;
@property (nonatomic, strong) IBOutlet UILabel *lblDirectOrd;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewAlarmTrailing;

@property (nonatomic, strong) IBOutlet UILabel *lblTimer;
@property (nonatomic, strong) IBOutlet UILabel *lblTimerNameum;
@property (nonatomic, strong) IBOutlet UIImageView *imgIconTimerPlay;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewTimerPlay;
@property (nonatomic, strong) IBOutlet UIImageView *imgIconPlayOnly;
@property (nonatomic, strong) IBOutlet UIButton *btnIconPlayOnly;
@property (nonatomic, strong) IBOutlet UIView *viewLeftTime;
@property (nonatomic, strong) IBOutlet UIButton *btnLeftTime;

@property (nonatomic, strong) IBOutlet UIView *viewBottomLine;


@property (nonatomic, strong) IBOutlet UIView *viewTopPromotion;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewTopPromotion;
@property (nonatomic, strong) IBOutlet UIImageView *imgOnAir;
@property (nonatomic, strong) IBOutlet UILabel *lblTopTimeTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblBenefit;
@property (nonatomic, strong) IBOutlet UILabel *lblReview;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewTopHeight;
@property (nonatomic, strong) IBOutlet UIView *viewDefault;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstPriceViewHeight;


@property (nonatomic,strong) IBOutlet UIButton *btn_TVLink;
@property (nonatomic,strong) IBOutlet UIButton *btn_TVLinkPriceArea;

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, assign) BOOL isLivePlay;
@property (nonatomic, strong) NSString *mseqValue;
@property (nonatomic, assign) BOOL isTvShop;
@property (nonatomic, strong) NSIndexPath *indexPathNow;
@property (nonatomic, assign) BOOL isLiveCellNeedsReload;

@property (nonatomic, strong) IBOutlet UILabel *lblTopBenefit;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstTopBeneWidth;

-(void) setCellInfoNDrawData:(NSDictionary*) dicRowInfo andIndexPath:(NSIndexPath *)path;

-(void)goWebView:(NSString *)url;

@end
