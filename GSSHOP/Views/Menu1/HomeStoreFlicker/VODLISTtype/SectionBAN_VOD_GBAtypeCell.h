//
//  SectionBAN_VOD_GBAtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 4. 8..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
@import BrightcovePlayerSDK;

#define kLEFTMARGIN 10.0f
#define kBETWEENMARGIN 4.0f
#define VODVIEW_OPEN @"OPEN"
#define VODVIEW_CLOSE @"CLOSE"

typedef enum {
    TOMORROW_TV_BUTTONPLAY = 1,
    TOMORROW_TV_LIST_PRD_CLICK = 2,
    TOMORROW_TV_FULL_PRD_CLICK = 3
} TOMORROW_TV_AMP_SEND_TYPE;



@class BenefitTagView;

@interface SectionBAN_VOD_GBAtypeCell : UITableViewCell {
    NSDateFormatter *dateformat;
}
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSDictionary *dicAll;
@property (nonatomic, strong) NSDictionary *dicRow;
@property (nonatomic, strong) NSDictionary *dicPGM;
@property (nonatomic, strong) IBOutlet UIView *view_Default;                              //셀 베이스뷰
@property (nonatomic, strong) IBOutlet UIImageView *imgThumbnail;                         //썸네일 이미지뷰
@property (nonatomic, strong) IBOutlet UILabel *promotionNameLabel;                       //프로모션이 있을경우 프로모션
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lcontPromotionRmargin;                       
@property (nonatomic, strong) IBOutlet UILabel *productTitleLabel;                        //상품 이름
//@property (nonatomic, weak) IBOutlet UILabel *productSubTitleLabel;                     //상품 서브 설명 , 다른곳에서는 프로모션으로 처리
@property (nonatomic, strong) IBOutlet UILabel *discountRateLabel;                        //할인율
//@property (nonatomic, weak) IBOutlet UIView *gsLabelView;                               //GS가 뷰
@property (nonatomic, strong) IBOutlet UILabel *extLabel;                                 //할인율과 연동해서 조건표시 라벨
@property (nonatomic, strong) IBOutlet UILabel *gsPriceLabel;                             //GS 가격
@property (nonatomic, strong) IBOutlet UILabel *gsPriceWonLabel;                          //GS 가격 옆 원
@property (nonatomic, strong) IBOutlet UILabel *originalPriceLabel;                       //원래가격
@property (nonatomic, strong) IBOutlet UILabel *originalPriceWonLabel;                    //원래가격 옆 원
@property (nonatomic, strong) IBOutlet UIView *originalPriceLine;                         //원래가격 중앙선
@property (nonatomic, strong) IBOutlet UILabel *saleCountLabel;                           //판매갯수
@property (nonatomic, strong) IBOutlet UILabel *saleSaleLabel;                            //개,
@property (nonatomic, strong) IBOutlet UILabel *saleSaleSubLabel;                         //구매중 , 판매수
@property (nonatomic, strong) IBOutlet UIButton *btnPriceArea;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lconstLblDiscountLeading;

@property (nonatomic, strong) NSString *imageURL;                                       //이미지 주소


@property (nonatomic, weak) id targettb;                                                //클릭시 이벤트를 보낼 타겟

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;              //autolayout 전체 높이 조절용
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *salesalelabel_width;           //autolayout 하단 구매중,판매수 의 넓이
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *originalPricelabel_lmargin;    //autolayout 원래 가격의 왼쪽 마진값
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalPricelabel_rmargin;    //autolayout 원래 가격의 오른쪽 마진값
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *valueinfolabel_lmargin;        //autolayout valueinfo 왼쪽 마진
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *producttitlelabel_lmargin;     //autolayout 상품제목 왼쪽 마진
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gspricelabel_lmargin;          //autolayout gs가 왼쪽 마진


@property (nonatomic, strong) IBOutlet UILabel *dummytagTF1;                              //롯대백화점,현대백화점 등 색갈값과 텍스트

@property (nonatomic, strong) IBOutlet UILabel *valuetextLabel;                           //월랜탈료 같은 특수상품일때 사용하는 정보
@property (nonatomic, strong) IBOutlet UILabel *valueinfoLabel;                           //월랜탈료 같은 특수상품일때 사용하는 정보

@property (nonatomic,strong) IBOutlet UIView *view3GAlert;
@property (nonatomic,strong) IBOutlet UIView *viewBtn3GAlertCancel;
@property (nonatomic,strong) IBOutlet UIView *viewBtn3GAlertConfirm;
@property (nonatomic,strong) IBOutlet UIButton *btn3GAlertConfirm;


@property (nonatomic, strong) NSString *imageTagURL01;
@property (nonatomic, strong) NSString *imageTagURL02;
@property (nonatomic, strong) NSString *imageTagURL03;

@property (nonatomic, strong) IBOutlet UIView *viewMPlayerArea;
@property (nonatomic, strong) IBOutlet UIButton *btnPlay;
@property (nonatomic, strong) IBOutlet UIButton *btnMute;
@property (nonatomic,strong) IBOutlet UIButton *btnFullMovie;
@property (nonatomic,strong) IBOutlet UIView *viewDimmed;
@property (nonatomic, strong) IBOutlet UILabel *lblLeftTime;
@property (nonatomic, strong) NSString *strViewType;
@property (nonatomic, strong) NSString *strPosterUrl;
@property (nonatomic, strong) UIImage *imgPoster;

@property (strong, nonatomic) IBOutlet UIView *viewVideoArea;
@property (strong, nonatomic) IBOutlet UIImageView *imgVerticalVideoBG;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lconstViewVideoAreaRatio;

@property (strong, nonatomic) IBOutlet UIView *viewPGMArea;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lconstHeightPGMArea;
@property (strong, nonatomic) IBOutlet UIView *viewPGMImageBorder;
@property (strong, nonatomic) IBOutlet UIImageView *imgPGM;
@property (strong, nonatomic) IBOutlet UILabel *lblPGM;
@property (strong, nonatomic) IBOutlet UIButton *btnPGM;
@property (strong, nonatomic) NSString *strPGMImageUrl;

@property (strong, nonatomic) NSIndexPath *path;
@property (nonatomic, assign) BOOL isFullScreenPause;

//@property (nonatomic, strong) IBOutlet UIView *viewBeneBG;
//@property (nonatomic, strong) IBOutlet BenefitTagView *benefitview;

//@property (strong, nonatomic) IBOutlet UIView *tagView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewWidth;
//@property (weak, nonatomic) IBOutlet UILabel *tagViewText;
@property (nonatomic, strong) IBOutlet UIImageView *imgTagLive;
@property (nonatomic, strong) IBOutlet UIImageView *imgTagMyShop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lconstPromotionLeading;

@property (nonatomic,strong) IBOutlet UIButton *btnDimms;
@property (nonatomic,strong) IBOutlet UIView *viewImageDimm;

@property (nonatomic,strong) IBOutlet UIView *viewShowProduct;
@property (nonatomic,strong) IBOutlet UIView *viewBottomGraDimm;
@property (nonatomic,strong) IBOutlet UIButton *btnDimmClose;

@property (nonatomic,strong) NSString *strAutoPlay;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
    
@property (nonatomic, strong) IBOutlet UIView *view_dorder;
@property (nonatomic,strong) IBOutlet UIButton *btn_dorder;
@property (nonatomic,strong) IBOutlet UILabel *btn_dordertxt;

@property (nonatomic, strong) IBOutlet UIImageView *imgRightTag01;
@property (nonatomic, strong) IBOutlet UIImageView *imgRightTag02;
@property (nonatomic, strong) IBOutlet UIImageView *imgRightTag03;
@property (nonatomic, strong) IBOutlet UIView *viewBadge;

@property (nonatomic, assign) BOOL isVODExit;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) CGFloat fixedWidth;
@property (nonatomic, assign) CGFloat fixedHeight;

-(void)goWebView:(NSString *)url;

-(void)cellScreenDefine;                                                                //셀 화면 초기화
-(void)setCellInfoNDrawData:(NSDictionary*) infoDic;   //셀 데이터 셋팅 , 테이블뷰에서 호출

-(void)checkEndDisplayingCell;
-(BOOL)isPlayerValid;
- (void)stopMoviePlayer;
@end
