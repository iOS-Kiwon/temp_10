//
//  SectionDCMLtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 10. 21..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//  오늘추천 탭에 자주등장
//  기본 상품 셀에 동영상 플레이어를 올림

#import <UIKit/UIKit.h>
#import "BenefitTagView.h"

#define kCELLCONTENTSLEFTMARGIN 10.0f

#define kCELLCONTENTSBETWEENMARGIN 7.0f
@interface SectionDCMLtypeCell : UITableViewCell
{
    
    IBOutlet UIView *viewMPlayerArea;                           //동영상 플레이어 영역
    IBOutlet UIView *viewDimmed;                                //딤처리 영역
    
    IBOutlet UIView *viewProductInfo;                           //상품 정보
    
    float textAreaHeigth;                                       //영역 높이 기본 92
    BenefitTagView *benefitview;

}

@property (nonatomic, strong) NSDictionary *row_dic;

@property (nonatomic, weak) IBOutlet UIImageView *productImageViewBG;
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;


@property (nonatomic, assign) BOOL isPlayed;

@property (nonatomic, weak) IBOutlet UIView *view_Default;


@property (nonatomic, weak) IBOutlet UIView *soldoutView;;

@property (nonatomic, weak) IBOutlet UIImageView *videoImageView;



@property (nonatomic, weak) IBOutlet UILabel *promotionNameLabel;
 

@property (nonatomic, weak) IBOutlet UILabel *productTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *productSubTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *discountRateLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountRatePercentLabel;

@property (nonatomic, weak) IBOutlet UILabel *extLabel;

@property (nonatomic, weak) IBOutlet UILabel *gsPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *gsPriceWonLabel;

@property (nonatomic, weak) IBOutlet UILabel *originalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *originalPriceWonLabel;
@property (nonatomic, weak) IBOutlet UIView *originalPriceLine;


@property (nonatomic, weak) IBOutlet UILabel *saleCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *saleSaleLabel;
@property (nonatomic, weak) IBOutlet UILabel *saleSaleSubLabel;



@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperationByLT1;
@property (nonatomic, strong) NSString *imageURL;


@property (nonatomic, weak) id targettb;
@property (nonatomic, retain) UITableView *horizontalTableView;
@property (nonatomic, retain) NSArray *articles;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salesalelabel_width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalPricelabel_lmargin;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueinfolabel_lmargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *producttitlelabel_lmargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gspricelabel_lmargin;


@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB1;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB2;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB3;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB4;



@property (nonatomic, weak) IBOutlet UIImageView *dummytagVT1;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagVT2;

@property (nonatomic, weak) IBOutlet UIImageView *dummytagLT1;



@property (nonatomic, weak) IBOutlet UILabel *dummytagTF1;

@property (nonatomic, weak) IBOutlet UILabel *valuetextLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueinfoLabel;

@property (nonatomic,strong) IBOutlet UIImageView *imgAutoPlay;
@property (nonatomic,strong) IBOutlet UIButton *btnPlay;
@property (nonatomic,strong) IBOutlet UIButton *btnReplay;
@property (nonatomic,strong) IBOutlet UIButton *btnView;
@property (nonatomic,strong) IBOutlet UIView *viewDimmButton;

@property (nonatomic,assign) BOOL isSendPlay;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contLTHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contLTWidth;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textSpace_bottom;          //autolayout 하단 텍스트/벳지 영역 여백
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgSpace_bottom;          //autolayout 하단 텍스트/벳지 영역 여백
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineSpace_bottom;          //autolayout 하단 텍스트/벳지 영역 여백
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoiConBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoBoxBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPlayer_bottom;
@property (nonatomic) float benefitHeigth;                                       //혜택높이

-(void)cellScreenDefine;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

-(UIImage*) tagimageWithtype : (NSString*)ttype;

-(IBAction)onBtnViewProduct:(id)sender;

-(void)pauseMoviePlayer;
-(void)stopMoviePlayer;
-(IBAction)playMoviePlayer:(id)sender;

-(void)checkPlayStateAndResume;

-(float)nowPlayingRate;

-(IBAction)onStop:(id)sender;

@end

