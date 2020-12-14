//
//  DualPlayerSubView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 2. 9..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DualPlayerSubView : UIView

@property (nonatomic, weak) id target;
@property (nonatomic, weak) id targetTableView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constViewLiveTalkWidth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constPriceWidthLimit;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constBasePriceWidthLimit;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *constPerMonthWidthLimit;

@property (nonatomic, strong) IBOutlet UIButton *btnPurchase;
@property (nonatomic, strong) IBOutlet UIButton *btnLiveTalk;
@property (nonatomic, strong) IBOutlet UIButton *btnSchedule;
@property (nonatomic, strong) NSDictionary *dicRowInfo;


@property (nonatomic, strong) IBOutlet UIImageView *noImageView;
@property (nonatomic, strong) IBOutlet UIImageView *productImageView;
@property (nonatomic, strong) IBOutlet UIView *viewDimmed;

@property (nonatomic, strong) IBOutlet UILabel *lblOnAir;
@property (nonatomic, strong) IBOutlet UILabel *lefttimelabel;
@property (nonatomic, strong) IBOutlet UILabel *productTitleLabel;

@property (nonatomic, strong) IBOutlet UIView *viewTagMobilePrice;
@property (nonatomic, strong) IBOutlet UIView *viewTagPercent;
@property (nonatomic, strong) IBOutlet UIView *viewTagGsPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblMobilePrice;                         //생방송 모바일가
@property (nonatomic, strong) IBOutlet UILabel *lblGSPrice;                             //GS가
@property (nonatomic, strong) IBOutlet UILabel *lblDiscountRate;                        //할인율

@property (nonatomic, strong) IBOutlet UILabel *lblBasePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblBasePriceWon;
@property (nonatomic, strong) IBOutlet UIView *viewBasePriceStrikeLine;
@property (nonatomic, strong) IBOutlet UILabel *lblPerMonth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstSalePriceLeftMargin;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstSalePriceTopMargin;

@property (nonatomic, strong) IBOutlet UILabel *lblSalePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblSalePriceWon;

@property (nonatomic, strong) IBOutlet UILabel *lblCounsel;

@property (nonatomic,strong) IBOutlet UIButton *btn_TVLink;
@property (nonatomic,strong) IBOutlet UIButton *btn_TVLinkPriceArea;

@property (nonatomic, strong) IBOutlet UIView *viewPriceArea;

@property (nonatomic, strong) IBOutlet UIImageView *imgLeftTag01;
@property (nonatomic, strong) IBOutlet UIImageView *imgLeftTag02;
@property (nonatomic, strong) IBOutlet UIImageView *imgLeftTag03;

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, strong) NSString *imageTagURL01;
@property (nonatomic, strong) NSString *imageTagURL02;
@property (nonatomic, strong) NSString *imageTagURL03;

@property (nonatomic, strong) IBOutlet UIButton *btnPlay;
@property (nonatomic, strong) IBOutlet UIImageView *imgPlay;

@property (nonatomic, strong) IBOutlet UIImageView *imgLiveOrMyShop;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstWidthImgLiveOrShop;

@property (nonatomic, assign) BOOL isDualTvLive;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) IBOutlet UILabel *lblNextBroadCast;
@property (nonatomic,strong) NSString *strSectionName;

- (void) sectionReloadTimerRemove;
- (void) setCellInfoNDrawData:(NSDictionary*) infoDic;
@end
