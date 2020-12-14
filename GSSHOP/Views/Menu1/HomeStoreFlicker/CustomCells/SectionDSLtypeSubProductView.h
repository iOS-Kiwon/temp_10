//
//  SectionDSLtypeSubProductView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 9..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  모든 탭에서 매우 자주 사용 , TSL,DSL_A,DSL_A2,DSL_B 모두 사용중
//  TSL,DSL_A,DSL_B 타입셀의 iCarousel 속에들어가는 상품뷰

#import <UIKit/UIKit.h>
#import "BenefitTagView.h"

@interface SectionDSLtypeSubProductView : UIView {
    UIView *tcontainerv;
    BenefitTagView *benefitview;
    NSString *viewType;                           //뷰타입값//optional
}
@property (nonatomic, weak) IBOutlet UIView *view_Default;                  //셀 베이스뷰

@property (nonatomic, weak) IBOutlet UIImageView *noImageView;              //noimg
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;         //상품 이미지뷰
@property (nonatomic, weak) IBOutlet UIImageView *adultImageView;           //19금 마크뷰
@property (nonatomic, weak) IBOutlet UIView *viewLabels;                    //상품정보가 표시되는 라벨 영역뷰
@property (nonatomic, weak) IBOutlet UIView *soldoutView;                   //soldout 뷰
@property (nonatomic, weak) IBOutlet UIImageView *soldoutImageView;         //soldout 이미지
@property (nonatomic, weak) IBOutlet UIImageView *videoImageView;           //hasVod 일경우 동영상 아이콘표시
@property (nonatomic, weak) IBOutlet UIView *viewImageBottomLine;           //상품 이미지 하단 경계 라인
@property (nonatomic, weak) IBOutlet UILabel *productTitleLabel;            //상품 이름
@property (nonatomic, weak) IBOutlet UILabel *productSubTitleLabel;         //프로모션이 있을경우 프로모션
@property (nonatomic, weak) IBOutlet UILabel *discountRateLabel;            //할인율
@property (nonatomic, weak) IBOutlet UILabel *discountRatePercentLabel;     //할인율 옆 %
@property (nonatomic, weak) IBOutlet UILabel *extLabel;                     //할인율과 연동해서 조건표시 라벨
@property (nonatomic, weak) IBOutlet UILabel *gsPriceLabel;                 //GS 가격
@property (nonatomic, weak) IBOutlet UILabel *gsPriceWonLabel;              //GS 가격 옆 원
@property (nonatomic, weak) IBOutlet UILabel *originalPriceLabel;           //원래가격
@property (nonatomic, weak) IBOutlet UILabel *originalPriceWonLabel;        //원래가격 옆 원
@property (nonatomic, weak) IBOutlet UIView *originalPriceLine;             //원래가격 중앙선
@property (nonatomic, weak) IBOutlet UILabel *saleCountLabel;               //판매갯수
@property (nonatomic, weak) IBOutlet UILabel *saleSaleLabel;                //개,
@property (nonatomic, weak) IBOutlet UILabel *saleSaleSubLabel;             //구매중 , 판매수
@property (weak, nonatomic) IBOutlet UIButton *LTbutton;
@property (weak, nonatomic) IBOutlet UIView *adPopup;

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation; //이미지 통신 오퍼레이션
@property (nonatomic, strong) NSString *imageURL;                           //이미지 url
@property (nonatomic, weak) id targettb;                                    //클릭시 이벤트를 보낼 타겟

//적립금 , 무료배송 등 조건 딱지
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB1;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB2;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB3;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB4;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagRB5;
@property (nonatomic, weak) IBOutlet UILabel *valuetextLabel;
@property (nonatomic, weak) IBOutlet UILabel *valueinfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *dummytagTF1;
@property (nonatomic, weak) IBOutlet UIImageView *dummytagLT1;

//- (id)initWithTarget:(id)sender;
- (id) initWithTarget:(id)sender with:(NSString*) viewtype; // DSL_A2의 경우를 분리하기 위해 뷰타입을 만든다.
- (void) cellScreenDefine;
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
- (void) prepareForReuse;
- (IBAction)adNotiClick:(id)sender;
- (IBAction)adNotiCloseClick:(id)sender;

@end
