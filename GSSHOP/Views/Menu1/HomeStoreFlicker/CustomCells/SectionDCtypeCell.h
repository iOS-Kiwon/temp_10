//
//  SectionDCtypeCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 10. 21..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

//  모든 탭에 항상사용 , 상품 기본셀
//  !!!!!!!!!!!!!!!!앱의 핵심셀임 가장중요!!!!!!!!!!!!!!!!!!!
//  기본 상품 셀에 동영상 플레이어를 올림

#import <UIKit/UIKit.h>
#import "FXImageView.h"
#import "BenefitTagView.h"


#define kCELLCONTENTSLEFTMARGIN 10.0f

#define kCELLCONTENTSBETWEENMARGIN 7.0f
@interface SectionDCtypeCell : UITableViewCell
{
    NSDateFormatter *dateformat;
    NSString *timeDealValue;
    float textAreaHeigth;                                       //영역 높이 기본 92
    BenefitTagView *benefitview;
}

@property (nonatomic, weak) IBOutlet UIView *view_Default;                              //셀 베이스뷰
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;                     //상품 이미지뷰
@property (nonatomic, weak) IBOutlet UIImageView *noImageView;                     //NO 이미지뷰
@property (nonatomic, weak) IBOutlet UIImageView *soldoutimgView;                       //soldout 이미지
@property (nonatomic, weak) IBOutlet UIView *soldoutView;                               //soldout 뷰
@property (nonatomic, weak) IBOutlet UIImageView *videoImageView;                       //hasVod 일경우 동영상 아이콘표시
@property (nonatomic, weak) IBOutlet UILabel *promotionNameLabel;                       //프로모션이 있을경우 프로모션
@property (nonatomic, weak) IBOutlet UILabel *productTitleLabel;                        //상품 이름
@property (nonatomic, weak) IBOutlet UILabel *productSubTitleLabel;                     //상품 서브 설명 , 다른곳에서는 프로모션으로 처리
@property (nonatomic, weak) IBOutlet UILabel *discountRateLabel;                        //할인율
@property (nonatomic, weak) IBOutlet UILabel *discountRatePercentLabel;                 //할인율 옆 %
@property (nonatomic, weak) IBOutlet UIView *gsLabelView;                               //GS가 뷰
@property (nonatomic, weak) IBOutlet UILabel *extLabel;                                 //할인율과 연동해서 조건표시 라벨
@property (nonatomic, weak) IBOutlet UILabel *gsPriceLabel;                             //GS 가격
@property (nonatomic, weak) IBOutlet UILabel *gsPriceWonLabel;                          //GS 가격 옆 원
@property (nonatomic, weak) IBOutlet UILabel *originalPriceLabel;                       //원래가격
@property (nonatomic, weak) IBOutlet UILabel *originalPriceWonLabel;                    //원래가격 옆 원
@property (nonatomic, weak) IBOutlet UIView *originalPriceLine;                         //원래가격 중앙선
@property (nonatomic, weak) IBOutlet UILabel *saleCountLabel;                           //판매갯수
@property (nonatomic, weak) IBOutlet UILabel *saleSaleLabel;                            //개,
@property (nonatomic, weak) IBOutlet UILabel *saleSaleSubLabel;                         //구매중 , 판매수
@property (nonatomic, weak) IBOutlet UILabel *abPercentageLabel;                        // AB test - Percentage label
@property (nonatomic, assign) BOOL          m_isApptimizeON;                            // AB test - Apptimize



//@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;             //이미지 통신 오퍼레이션
//@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperationByLT1;        //이미지 통신 오퍼레이션 , 좌상단 벳지 전용
@property (nonatomic, strong) NSString *imageURL;                                       //이미지 주소


@property (nonatomic, weak) id targettb;                                                //클릭시 이벤트를 보낼 타겟

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;              //autolayout 전체 높이 조절용
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salesalelabel_width;           //autolayout 하단 구매중,판매수 의 넓이
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalPricelabel_lmargin;    //autolayout 원래 가격의 왼쪽 마진값
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *originalPricelabel_rmargin;    //autolayout 원래 가격의 오른쪽 마진값
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueinfolabel_lmargin;        //autolayout valueinfo 왼쪽 마진
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *producttitlelabel_lmargin;     //autolayout 상품제목 왼쪽 마진
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gspricelabel_lmargin;          //autolayout gs가 왼쪽 마진
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB1;                          //오른하단 무료배송,무이자,적립금 등~
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB2;                          //오른하단 무료배송,무이자,적립금 등~
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB3;                          //오른하단 무료배송,무이자,적립금 등~
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB4;                          //오른하단 무료배송,무이자,적립금 등~
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB5;                          //오른하단 무료배송,무이자,적립금 등~ 최대 5개

@property (nonatomic, weak) IBOutlet UIImageView *dummytagVT1;                          //해외직구,총알배송
@property (nonatomic, weak) IBOutlet UIImageView *dummytagVT2;                          //해외직구,총알배송

@property (nonatomic, weak) IBOutlet UIImageView *dummytagLT1;                          //좌상단 내려주는 배너

@property (nonatomic, weak) IBOutlet UILabel *dummytagTF1;                              //롯대백화점,현대백화점 등 색갈값과 텍스트

@property (nonatomic, weak) IBOutlet UILabel *valuetextLabel;                           //월랜탈료 같은 특수상품일때 사용하는 정보
@property (nonatomic, weak) IBOutlet UILabel *valueinfoLabel;                           //월랜탈료 같은 특수상품일때 사용하는 정보


@property (nonatomic, weak) IBOutlet UILabel *timeDealLabel;                            //타임딜 시간표시
@property (nonatomic, weak) IBOutlet UIView *timeDealView;                              //타임딜 뷰
@property (nonatomic, strong) NSTimer *timeDealTimer;                                   //타임딜 타이머

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contLTHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contLTWidth;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contPrdImageWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textSpace_bottom;          //autolayout 하단 텍스트/벳지 영역 여백
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgSpace_bottom;          //autolayout 하단 텍스트/벳지 영역 여백
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineSpace_bottom;          //autolayout 하단 텍스트/벳지 영역 여백
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoiConBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoBoxBottom;
@property (nonatomic) float benefitHeigth;                                       //혜택높이
@property (weak, nonatomic) IBOutlet UIButton *adPopupButton;
@property (weak, nonatomic) IBOutlet UIView *adPopup;


-(void)cellScreenDefine;                                                                //셀 화면 초기화
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;                                //셀 데이터 셋팅 , 테이블뷰에서 호출

-(UIImage*) tagimageWithtype : (NSString*)ttype;                                        //내부적으로 이미지 정보 있는 뱃지들 셋팅

-(void) stopTimeDealTimer;                                                              //타임딜 타이머를 종료한다.(화면에서 보이지 않을겨웅 호출됨)
-(void) startTimeDealTimer;                                                             //타임딜 타이머 시작
-(void) TimeDealTimerProcess;                                                           //타이머 계산해서 표시

- (IBAction)adPopupCloseClick:(id)sender;
- (IBAction)adPopupShowClick:(id)sender;

@end

