//
//  SCH_MAP_MUT_LIVETypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 7..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTNumberScrollAnimatedView.h"
#import "Mocha_MPViewController.h"
@import BrightcovePlayerSDK;

@interface SCH_MAP_MUT_LIVETypeCell : UITableViewCell {
    
    BOOL isgraphAniming;
    BOOL isAgree3G;
    
    //NSInteger countBtn;
    NSTimer *timerLive;
}



@property (nonatomic, strong) NSDictionary *dicRow;
@property (nonatomic, strong) NSDictionary *dicAll;
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, strong) IBOutlet UIView *viewBannerArea;
@property (nonatomic, strong) IBOutlet UIImageView *imgSpeBanner;
@property (nonatomic, strong) NSString *strBannerURL;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewBannerHeight;


@property (nonatomic, strong) IBOutlet UIView *viewImageArea;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewImageHeight;
@property (nonatomic, strong) IBOutlet UIView *viewPGMArea;
@property (nonatomic, strong) IBOutlet UIView *viewMPlayerArea;
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstLeadingBtnPause;
@property (nonatomic, strong) IBOutlet UIButton *btnGOLink;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstCenterBtnFullScr;
@property (nonatomic, strong) IBOutlet UIView *viewDimmed;
//@property (nonatomic, strong) IBOutlet UIView *viewScreenBtn;
//@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBtnFullScrTop;
@property (nonatomic, strong) IBOutlet UIImageView *imgBackGround;
@property (nonatomic, strong) IBOutlet UIImageView *imgProduct;
@property (nonatomic, strong) IBOutlet UIView *viewPrdWhiteDimmed;
@property (nonatomic, strong) IBOutlet UIView *viewPrdDimmed;
@property (nonatomic, strong) IBOutlet UIView *viewImageLayer;
@property (nonatomic, strong) IBOutlet UILabel *lblImageLayer;

@property (nonatomic, strong) IBOutlet UIView *viewImageAreaBorder;

@property (nonatomic, strong) IBOutlet UILabel *lblProductTitle;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstTitleLabelTop;

@property (nonatomic, strong) IBOutlet UIView *viewTagMobilePrice;
@property (nonatomic, strong) IBOutlet UIView *viewTagPercent;
@property (nonatomic, strong) IBOutlet UIView *viewTagGsPrice;
@property (nonatomic, strong) IBOutlet UILabel *lblMobilePrice;                         //생방송 모바일가
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
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstCounselLeading;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstCounselBottom;

@property (nonatomic,strong) IBOutlet UIButton *btn_TVLink;
@property (nonatomic,strong) IBOutlet UIButton *btn_TVLinkPriceArea;


@property (nonatomic, strong) IBOutlet UIView *viewPriceArea;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewPriceAreaHeight;

@property (nonatomic, strong) IBOutlet UIView *viewBottomBtns;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstViewBottomHeight;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBtnAlarmTrailing;
@property (nonatomic, strong) IBOutlet UIButton *btnAlarm;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBtnLiveTalkTrailing;
@property (nonatomic, strong) IBOutlet UIButton *btnLiveTalk;

@property (nonatomic, strong) IBOutlet UIButton *btnDirectOrd;

@property (nonatomic, strong) IBOutlet UIView *viewBottomDirectOrd;
@property (nonatomic, strong) IBOutlet UILabel *lblBottomDirectOrd;

@property (nonatomic, strong) IBOutlet UIView *viewBenefit01;
@property (nonatomic, strong) IBOutlet UIView *viewBenefit02;
@property (nonatomic, strong) IBOutlet UIView *viewBenefit03;
@property (nonatomic, strong) IBOutlet UIImageView *imgBenefit01;
@property (nonatomic, strong) IBOutlet UIImageView *imgBenefit02;
@property (nonatomic, strong) IBOutlet UIImageView *imgBenefit03;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBenefitWidth01;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBenefitWidth02;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBenefitWidth03;

@property (nonatomic, strong) IBOutlet UIView *view_graphcontainner;
@property (nonatomic, strong) IBOutlet UILabel *label_saletext;

@property (nonatomic, strong) IBOutlet UILabel *label_tailtext;
@property (nonatomic, strong) IBOutlet JTNumberScrollAnimatedView *label_ordqty;

@property (nonatomic, strong) IBOutlet UIView *viewProcCount;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconsLblOrdqtyWidth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconsLblOrdqtyX;
@property (nonatomic, strong) IBOutlet UIButton *btnPlay;
@property (nonatomic, strong) IBOutlet UIView *viewBtnPlay;
@property (nonatomic, strong) IBOutlet UILabel *lblTimer;
@property (nonatomic, strong) IBOutlet UIView *viewBottomLine;

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) NSString *strBenefitURL01;
@property (nonatomic, strong) NSString *strBenefitURL02;
@property (nonatomic, strong) NSString *strBenefitURL03;
@property (nonatomic, strong) NSString *curRequestString;
@property (nonatomic, assign) BOOL isLivePlay;
@property (nonatomic, strong) NSString *mseqValue;
@property (nonatomic, assign) BOOL isTvShop;
@property (nonatomic, strong) NSIndexPath *indexPathNow;
@property (nonatomic, assign) BOOL isLiveCellNeedsReload;

@property (nonatomic,strong) IBOutlet UIView *view3GAlert;
@property (nonatomic,strong) IBOutlet UIView *viewBtn3GAlertCancel;
@property (nonatomic,strong) IBOutlet UIView *viewBtn3GAlertConfirm;

-(void) setCellInfoNDrawData:(NSDictionary*) dicRowInfo andIndexPath:(NSIndexPath *)path;
-(void)procGraphAnimation:(NSDictionary*)dic;
-(void)RemoveGraphView;

-(void)goWebView:(NSString *)url;

-(void)stopMoviePlayer;

-(IBAction)onBtnSpeBanner:(id)sender;

-(IBAction)onBtnMoviePlay:(id)sender;

-(IBAction)onBtnMovieScreen:(id)sender;

-(IBAction)onBtnMovieScreenBtn:(id)sender;

@end
