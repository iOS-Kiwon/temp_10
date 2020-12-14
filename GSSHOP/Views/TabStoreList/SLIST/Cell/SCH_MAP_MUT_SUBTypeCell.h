//
//  SCH_MAP_MUT_SUBTypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 17..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH_LIMIT_TV_SUB (APPFULLWIDTH - (16.0+127.0+12.0+16.0))

@interface SCH_MAP_MUT_SUBTypeCell : UITableViewCell
{
    NSDictionary *infoDic;
}

@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSDictionary *dicRow;

@property (weak, nonatomic) IBOutlet UIView *viewBackGround;
@property (weak, nonatomic) IBOutlet UIImageView *prdImage;
@property (weak, nonatomic) IBOutlet UIView *viewImageBorder;
@property (weak, nonatomic) IBOutlet UIView *InfoDimme;
@property (weak, nonatomic) IBOutlet UILabel *InfoDimmeText;
@property (weak, nonatomic) IBOutlet UIView *viewBroadTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBroadTime;
@property (weak, nonatomic) IBOutlet UIView *viewPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnAutoPlay;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBroadTimeHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstInfoHeight;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstPlayBtnBottom;

//@property (weak, nonatomic) IBOutlet UILabel *ProductName;
//@property (weak, nonatomic) IBOutlet UILabel *Price;
//@property (weak, nonatomic) IBOutlet UILabel *PriceText;
@property (weak, nonatomic) IBOutlet UILabel *buyNowText;
@property (weak, nonatomic) IBOutlet UIView *buyNow;

@property (weak, nonatomic) IBOutlet UIImageView *alarmOffImg;
@property (weak, nonatomic) IBOutlet UIImageView *alarmOnImg;
@property (weak, nonatomic) IBOutlet UIView *alarmView;
@property (nonatomic, weak) IBOutlet UIButton *btnProduct;
@property (nonatomic, weak) IBOutlet UIButton *btnAlarm;
@property (nonatomic, weak) IBOutlet UIButton *btnDirectOrd;

@property (weak, nonatomic) IBOutlet UIView *viewBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lconstAlarmTrailing;


@property (nonatomic, strong) IBOutlet UILabel *lblProductTitle;
@property (nonatomic, strong) IBOutlet UILabel *lblDiscountRate;                        //할인율
@property (nonatomic, strong) IBOutlet UILabel *lblBasePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblBasePriceWon;
@property (nonatomic, strong) IBOutlet UIView *viewBasePriceStrikeLine;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBasePriceLeading;
@property (nonatomic, strong) IBOutlet UILabel *lblPerMonth;
@property (nonatomic, strong) IBOutlet UILabel *lblSalePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblSalePriceWon;
@property (nonatomic, strong) IBOutlet UILabel *lblCounsel;
@property (nonatomic, strong) IBOutlet UILabel *lblBenefit;
@property (nonatomic, strong) IBOutlet UILabel *lblReview;

@property (nonatomic, strong) IBOutlet UIView *viewPricesArea;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstDisRateLeading;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstDisRateTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lconstPerMonthMargine;

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

- (void)alarmOn:(BOOL) isOn;

- (IBAction)onClick:(id)sender;
- (IBAction)onAlramClick:(id)sender;
- (IBAction)onBuyNowClick:(id)sender;

@end
