//
//  SectionBFPtypeCell.h
//  GSSHOP
// 기획전 / 백화점 매장에 들어가는 좌우 분살 상품 셀
//  Created by Parksegun on 2016. 5. 2..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SectionBFPtypeCell : UITableViewCell

@property (nonatomic, weak) id target;

//L뷰용
@property (nonatomic, weak) IBOutlet UIImageView *L_productImageView;   // 상품 이미지
@property (nonatomic, weak) IBOutlet UILabel *L_promotionName;          // 프로모션명
@property (nonatomic, weak) IBOutlet UILabel *L_productName;            // 상품명
@property (nonatomic, weak) IBOutlet UILabel *L_salePrice;              // 판매가
@property (nonatomic, weak) IBOutlet UILabel *L_exposePriceText;        // 판매가 원/원~

@property (nonatomic, weak) IBOutlet UILabel *L_basePrice;                  // 기본가
@property (nonatomic, weak) IBOutlet UILabel *L_basePrice_exposePriceText;  // 기본가 원/원~
@property (nonatomic, weak) IBOutlet UIView  *L_basePriceCancelLine;        // 기본가 취소선

@property (nonatomic, weak) IBOutlet UIImageView *L_LT;     // 상품 이미지 좌상단 카운트 벳지 배경
@property (nonatomic, weak) IBOutlet UILabel *L_LTvalue;    // 상품 이미지 좌상단 카운트
@property (nonatomic, weak) IBOutlet UIImageView *L_LT2;    // 상품 이미지 좌상단 벳지

@property (nonatomic, weak) IBOutlet UILabel *L_TF;         // 타이틀 앞 텍스트 베너
@property (nonatomic, weak) IBOutlet UILabel *L_valuetext;  // 금액 정보 텍스트


@property (nonatomic, strong) NSString *L_imageURL;         // 상품이지미 경로

@property (nonatomic, weak) IBOutlet UIView *L_air_on;  // 방송중 구매가능 레이어

@property (nonatomic, strong) NSDictionary* L_infoDic;      // 좌측 상품 정보 구조체
@property (weak, nonatomic) IBOutlet UIButton *L_link;

@property (weak, nonatomic) IBOutlet UILabel *L_discountValue;
@property (weak, nonatomic) IBOutlet UILabel *L_discountValueText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *L_valuetextLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *L_basePriceLeading;
@property (nonatomic, weak) IBOutlet UIView *L_under_line;

//R뷰용
@property (nonatomic, weak) IBOutlet UIImageView *R_productImageView;

@property (nonatomic, weak) IBOutlet UILabel *R_promotionName;
@property (nonatomic, weak) IBOutlet UILabel *R_productName;
@property (nonatomic, weak) IBOutlet UILabel *R_salePrice;
@property (nonatomic, weak) IBOutlet UILabel *R_exposePriceText;

@property (nonatomic, weak) IBOutlet UILabel *R_basePrice;
@property (nonatomic, weak) IBOutlet UILabel *R_basePrice_exposePriceText;
@property (nonatomic, weak) IBOutlet UIView  *R_basePriceCancelLine;

@property (nonatomic, weak) IBOutlet UIImageView *R_LT;
@property (nonatomic, weak) IBOutlet UILabel *R_LTvalue;
@property (nonatomic, weak) IBOutlet UIImageView *R_LT2;

@property (nonatomic, weak) IBOutlet UILabel *R_TF;
@property (nonatomic, weak) IBOutlet UILabel *R_valuetext;

@property (nonatomic, weak) IBOutlet UIView *R_View;


@property (weak, nonatomic) IBOutlet UILabel *R_discountValue;
@property (weak, nonatomic) IBOutlet UILabel *R_discountValueText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *R_valuetextLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *R_basePriceLeading;

@property (nonatomic, weak) IBOutlet UIView *R_under_line;

@property (nonatomic, strong) NSString *R_imageURL;

@property (nonatomic, weak) IBOutlet UIView *R_air_on;  // 방송중 구매가능 레이어

@property (nonatomic, strong) NSDictionary* R_infoDic;
@property (weak, nonatomic) IBOutlet UIButton *R_link;

@property (nonatomic, assign) BOOL isBanImgC2GBB;
@property (nonatomic, assign) BOOL isBanImgC2GBBLastLine;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lcontTopMargin;
@property (nonatomic, strong) IBOutlet UIView *viewBottomLine;


// 상풍 정보 렌더링
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

// 상품 클릭 이벤트 (좌우 구분)
- (IBAction)onBtnContents:(id)sender;

@end
