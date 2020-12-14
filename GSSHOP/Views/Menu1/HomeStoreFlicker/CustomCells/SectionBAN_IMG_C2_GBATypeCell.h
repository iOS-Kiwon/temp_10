//
//  SectionBAN_IMG_C2_GBATypeCell.h
//  GSSHOP
//
//  Created by admin on 2018. 4. 10..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBAN_IMG_C2_GBATypeCell : UITableViewCell


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
@property (nonatomic, weak) IBOutlet UILabel *L_TF;         // 타이틀 앞 텍스트 베너
@property (nonatomic, weak) IBOutlet UILabel *L_valuetext;  // 금액 정보 텍스트
@property (nonatomic, strong) NSString *L_imageURL;         // 상품이지미 경로
@property (nonatomic, weak) IBOutlet UIView *L_air_on;  // 방송중 구매가능 레이어
@property (nonatomic, strong) NSDictionary* L_infoDic;      // 좌측 상품 정보 구조체
@property (nonatomic, weak) IBOutlet UILabel *L_reviewCount;         // 상품평 갯수
@property (nonatomic, weak) IBOutlet UIView *L_viewPlay;         // 플레이버튼 뷰
@property (nonatomic, weak) IBOutlet UILabel *L_lblPlayTime;         // 플레이 시간
@property (nonatomic, weak) IBOutlet UIButton *L_btnPlay;         // 플레이버튼
@property (weak, nonatomic) IBOutlet UIButton *L_link;


//혜택 영역
@property (nonatomic, strong) IBOutlet UIView *L_viewBenefit01;
@property (nonatomic, strong) IBOutlet UIView *L_viewBenefit02;
@property (nonatomic, strong) IBOutlet UIView *L_viewBenefit03;
@property (nonatomic, strong) IBOutlet UIImageView *L_imgBenefit01;
@property (nonatomic, strong) IBOutlet UIImageView *L_imgBenefit02;
@property (nonatomic, strong) IBOutlet UIImageView *L_imgBenefit03;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *L_lconstBenefitWidth01;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *L_lconstBenefitWidth02;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *L_lconstBenefitWidth03;
@property (nonatomic, strong) NSString *L_strBenefitURL01;
@property (nonatomic, strong) NSString *L_strBenefitURL02;
@property (nonatomic, strong) NSString *L_strBenefitURL03;
//방송시간
@property (nonatomic, strong) IBOutlet UIView *L_tvTimeView;
@property (nonatomic, strong) IBOutlet UILabel *L_tvTimeText;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *L_lconstAirOnH;
@property (weak, nonatomic) IBOutlet UILabel *L_textBadgeInfo;




//R뷰용
@property (nonatomic, weak) IBOutlet UIImageView *R_productImageView;
@property (nonatomic, weak) IBOutlet UILabel *R_promotionName;
@property (nonatomic, weak) IBOutlet UILabel *R_productName;
@property (nonatomic, weak) IBOutlet UILabel *R_salePrice;
@property (nonatomic, weak) IBOutlet UILabel *R_exposePriceText;
@property (nonatomic, weak) IBOutlet UILabel *R_basePrice;
@property (nonatomic, weak) IBOutlet UILabel *R_basePrice_exposePriceText;
@property (nonatomic, weak) IBOutlet UIView  *R_basePriceCancelLine;
@property (nonatomic, weak) IBOutlet UILabel *R_TF;
@property (nonatomic, weak) IBOutlet UILabel *R_valuetext;
@property (nonatomic, weak) IBOutlet UIView *R_View;
@property (nonatomic, weak) IBOutlet UIView *R_under_line;
@property (nonatomic, strong) NSString *R_imageURL;
@property (nonatomic, weak) IBOutlet UIView *R_air_on;  // 방송중 구매가능 레이어
@property (nonatomic, strong) NSDictionary* R_infoDic;
@property (nonatomic, weak) IBOutlet UILabel *R_reviewCount;         // 상품평 갯수
@property (nonatomic, weak) IBOutlet UIView *R_viewPlay;         // 플레이버튼 뷰
@property (nonatomic, weak) IBOutlet UILabel *R_lblPlayTime;         // 플레이 시간
@property (nonatomic, weak) IBOutlet UIButton *R_btnPlay;         // 플레이버튼
@property (weak, nonatomic) IBOutlet UIButton *R_Link;
//혜택 영역
@property (nonatomic, strong) IBOutlet UIView *R_viewBenefit01;
@property (nonatomic, strong) IBOutlet UIView *R_viewBenefit02;
@property (nonatomic, strong) IBOutlet UIView *R_viewBenefit03;
@property (nonatomic, strong) IBOutlet UIImageView *R_imgBenefit01;
@property (nonatomic, strong) IBOutlet UIImageView *R_imgBenefit02;
@property (nonatomic, strong) IBOutlet UIImageView *R_imgBenefit03;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *R_lconstBenefitWidth01;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *R_lconstBenefitWidth02;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *R_lconstBenefitWidth03;
@property (nonatomic, strong) NSString *R_strBenefitURL01;
@property (nonatomic, strong) NSString *R_strBenefitURL02;
@property (nonatomic, strong) NSString *R_strBenefitURL03;
//방송시간
@property (nonatomic, strong) IBOutlet UIView *R_tvTimeView;
@property (nonatomic, strong) IBOutlet UILabel *R_tvTimeText;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *R_lconstAirOnH;
@property (weak, nonatomic) IBOutlet UILabel *R_textBadgeInfo;



// 상풍 정보 렌더링
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

// 상품 클릭 이벤트 (좌우 구분)
- (IBAction)onBtnContents:(id)sender;

// 동영상 클릭 이벤트 (좌우 구분)
- (IBAction)onBtnMovieContents:(id)sender;

@end
