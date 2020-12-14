//
//  SectionPDVtypeSubLeft.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 27..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  백화점 매장
//  백화점 매장 PDV 셀에서만 사용 , 뷰 왼쪽에 이미지 오른쪽에 상품설명

#import <UIKit/UIKit.h>

@interface SectionPDVtypeSubLeft : UIView

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;                 //이미지 통신 오퍼레이션
@property (nonatomic, weak) id target;                                                      //클릭시 이벤트를 보낼 타겟
@property (nonatomic,strong) IBOutlet UIView *viewProductImage01;                           //상품 이미지가 들어갈 뷰
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct01;                            //상품 이미지뷰
@property (nonatomic,strong) IBOutlet UIView *viewProductDesc01;                            //상품 설명이 들어갈 뷰
@property (nonatomic,strong) IBOutlet UILabel *lblSpecialCopy01;                            //상품 특수 홍보글이 들어갈 라벨 << PDV 타입 에서만 사용

@property (nonatomic, strong) IBOutlet UILabel *dummytagTF01;                               //텍스트 칼라 들어가는 백화점 명 ex) [롯데백화점]
@property (nonatomic, strong) IBOutlet UILabel *lblProductName01;                           //상품명

@property (nonatomic, strong) IBOutlet UILabel *promotionName01;                            //프로모션 라벨
@property (nonatomic, strong) IBOutlet UILabel *valuetext01;                                //월랜탈료 같은 특수상품일때 사용하는 정보

@property (nonatomic, strong) IBOutlet UILabel *discountRateLabel01;                        //할인율
@property (nonatomic, strong) IBOutlet UILabel *discountRatePercentLabel01;                 //할인율 옆 퍼센트
@property (nonatomic, strong) IBOutlet UILabel *extLabel01;                                 //할인율과 연동해서 조건표시 라벨

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gspricelabel_lmargin01;          //autolayout GS가 좌측 마진값

@property (nonatomic, strong) IBOutlet UILabel *gsPriceLabel01;                             //GS가
@property (nonatomic, strong) IBOutlet UILabel *gsPriceWonLabel01;                          //GS가격옆 원

@property (nonatomic, strong) IBOutlet UILabel *originalPriceLabel01;                       //원래가격
@property (nonatomic, strong) IBOutlet UILabel *originalPriceWonLabel01;                    //원래가격 옆 원
@property (nonatomic, strong) IBOutlet UIView *originalPriceLine01;                         //원래가격 중앙선

@property (nonatomic, strong) IBOutlet UIView *lineTop;                                     //상단 라인

@property (nonatomic, strong) NSDictionary *dicRow01;                                       //뷰전체 구성 데이터

@property (nonatomic, assign) NSInteger idxRow;                                             //상위PDV 셀 에서의 row_arr index 값

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;                                       //셀 데이터 셋팅 , 테이블뷰에서 호출

-(IBAction)onBtn:(id)sender;                                                                //클릭시 이벤트
@end
