//
//  HomeMainBroadMobileLive.h
//  GSSHOP
//
//  Created by gsshop iOS on 04/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#define HomeMainBroadMobileLive_heightPriceArea 116.0f
#define heightHomeMainBroadMobileLiveView (50.0+roundf((APPFULLWIDTH - 32.0)*(1.0/2.0))+ HomeMainBroadMobileLive_heightPriceArea +1.0)

#import <UIKit/UIKit.h>

@interface HomeMainBroadMobileLive : UIView{
    NSDictionary *rdic;
    BOOL isgraphAniming;
    
    IBOutlet UIView *viewDimmed;
    IBOutlet UIView *viewScreenBtn;
    
    BOOL isAgree3G;
    int TVCapirequestcount;
}

@property (nonatomic, weak) id target;
@property (nonatomic, strong) IBOutlet UIView *viewTopArea;
@property (nonatomic, strong) IBOutlet UIImageView *imgLiveStatus;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstLiveStausLeading;

@property (nonatomic, strong) IBOutlet UIImageView *noImageView;
@property (nonatomic, strong) IBOutlet UIImageView *productImageView;

@property (nonatomic, strong) IBOutlet UILabel *lefttimelabel;
@property (nonatomic, strong) IBOutlet UIView *viewLeftTime;
@property (nonatomic, strong) IBOutlet UIButton *btnLeftTime;
@property (nonatomic, strong) IBOutlet UILabel *productTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel *lblDiscountRate;                        //할인율

@property (nonatomic, strong) IBOutlet UILabel *lblBasePrice;
@property (nonatomic, strong) IBOutlet UIView *viewBasePriceStrikeLine;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBasePriceLeading;
@property (nonatomic, strong) IBOutlet UILabel *lblPerMonth;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstPerMonthMargine;

@property (nonatomic, strong) IBOutlet UILabel *lblSalePrice;
@property (nonatomic, strong) IBOutlet UILabel *lblSalePriceWon;

@property (nonatomic, strong) IBOutlet UIView *viewTvArea;
@property (nonatomic, strong) IBOutlet UIView *viewPriceArea;
@property (nonatomic, strong) IBOutlet UIView *view_dorder;
@property (nonatomic,strong) IBOutlet UIButton *btn_dorder;
@property (nonatomic,strong) IBOutlet UILabel *btn_dordertxt;

@property (nonatomic,strong) IBOutlet UIButton *btn_TVLink;
@property (nonatomic,strong) IBOutlet UIButton *btn_TVLinkPriceArea;


@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, strong) NSString *curRequestString;
@property (nonatomic, assign) BOOL isLivePlay;
@property (nonatomic, strong) NSString *mseqValue;

@property (nonatomic, assign) BOOL isEnterBackGround;

@property (nonatomic, strong) IBOutlet UILabel *lblBroadCastEnd;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong) NSString *strSectionName;
@property (nonatomic,strong) NSString *strSectionCode;

@property (nonatomic,strong) NSDictionary *dicMobileLiveInfo;
@property (nonatomic,strong) IBOutlet UILabel *lblMobileLiveGO;
@property (nonatomic,strong) IBOutlet UILabel *lblMobileLivePlayTime;
@property (nonatomic,assign) BOOL isPreparingBroad;

@property (nonatomic, strong) IBOutlet UILabel *lblBenefit;
@property (nonatomic, strong) IBOutlet UILabel *lblReview;

-(void) setCellInfoNDrawData:(NSDictionary*) infoDic;
-(IBAction)tvcBtnAction:(id)sender;
-(void)stopTimer;

@end
