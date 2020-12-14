//
//  SectionMAP_CX_GBB_PRDtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 29..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionMAP_CX_GBB_PRDtypeCell : UITableViewCell
@property (nonatomic, weak) id target;

//L뷰용
@property (nonatomic, weak) IBOutlet UIImageView *L_productImageView;   // 상품 이미지
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LvalueTextLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LbasePriceLeading;

@property (nonatomic, weak) IBOutlet UILabel  *L_lblPercent; //퍼센트라벨
@property (nonatomic, weak) IBOutlet UILabel  *L_lblPercentText; //퍼센트라벨Text %

@property (nonatomic, strong) NSString *L_imageURL;         // 상품이지미 경로

@property (nonatomic, weak) IBOutlet UIView *L_air_on;  // 방송중 구매가능 레이어

@property (nonatomic, strong) MochaNetworkOperation* L_imageLoadingOperation;       // 상품 이미지 오퍼레이션
@property (nonatomic, strong) MochaNetworkOperation* L_imageLoadingOperationByLT;   // 좌상단 벳지 이미지 오퍼레이션
@property (nonatomic, strong) NSDictionary* L_infoDic;      // 좌측 상품 정보 구조체
@property (weak, nonatomic) IBOutlet UIButton *L_LinkBtn01;
@property (weak, nonatomic) IBOutlet UIButton *L_LinkBtn02;
@property (weak, nonatomic) IBOutlet UIButton *L_cartBtn;
@property (nonatomic, weak) IBOutlet UIView  *L_viewFullBanner; //꽉차는 배너가 깔릴뷰
@property (nonatomic, weak) IBOutlet UIImageView  *L_imgFullBanner; //꽉차는 배너


//R뷰용
@property (nonatomic, weak) IBOutlet UIImageView *R_productImageView;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RvalueTextLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *RbasePriceLeading;

@property (nonatomic, weak) IBOutlet UIView *R_View;

@property (nonatomic, strong) NSString *R_imageURL;

@property (nonatomic, weak) IBOutlet UIView *R_air_on;  // 방송중 구매가능 레이어

@property (nonatomic, strong) MochaNetworkOperation* R_imageLoadingOperation;
@property (nonatomic, strong) MochaNetworkOperation* R_imageLoadingOperationByLT;
@property (nonatomic, strong) NSDictionary* R_infoDic;
@property (weak, nonatomic) IBOutlet UIButton *R_LinkBtn01;
@property (weak, nonatomic) IBOutlet UIButton *R_LinkBtn02;
@property (weak, nonatomic) IBOutlet UIButton *R_cartBtn;


@property (nonatomic, weak) IBOutlet UILabel  *R_lblPercent; //퍼센트라벨
@property (nonatomic, weak) IBOutlet UILabel  *R_lblPercentText; //퍼센트라벨Text %

@property (nonatomic, weak) IBOutlet UIView  *R_viewFullBanner; //꽉차는 배너가 깔릴뷰
@property (nonatomic, weak) IBOutlet UIImageView  *R_imgFullBanner; //꽉차는 배너


// 상풍 정보 렌더링
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

// 상품 클릭 이벤트 (좌우 구분)
- (IBAction)onBtnContents:(id)sender;

@end
