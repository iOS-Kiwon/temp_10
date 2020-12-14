//
//  SectionBP_OtypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionBP_OtypeCell : UITableViewCell {
}

@property (nonatomic, weak) IBOutlet UIView *view_Default;
@property (nonatomic, weak) IBOutlet UIView *contentsView;      // 상품 정보 뷰
@property (nonatomic, weak) IBOutlet UIImageView *bannerImage;  //상단 베너 이미지
@property (nonatomic, weak) IBOutlet UIImageView *noImage;      // 노이미지
@property (nonatomic, weak) IBOutlet UIImageView *productImage; // 상품 이미지
@property (nonatomic, weak) IBOutlet UIImageView *LT;           //상품 이미지 Left Top 벳지
@property (nonatomic, weak) IBOutlet UILabel *productName;      // 상품평
@property (nonatomic, weak) IBOutlet UILabel *discountRate;     // 할인율
@property (nonatomic, weak) IBOutlet UILabel *discountRatePercent; // 할인율% 혹은 텍스트
@property (nonatomic, weak) IBOutlet UILabel *salePrice;        // 할인가
@property (nonatomic, weak) IBOutlet UILabel *salePriceWon;     // 할인가 원/원~
@property (nonatomic, weak) IBOutlet UILabel *basePrice;        // 기본가
@property (nonatomic, weak) IBOutlet UIView *basePriceCancelLine; // 기본가 취소선
@property (nonatomic, weak) IBOutlet UILabel *valuetext;        // 금액 관련 정보 (원 렌탈료)
@property (nonatomic, weak) IBOutlet UILabel *valueinfo;        // 금액 관련 안내 (프로모션 네임)
@property (nonatomic, weak) IBOutlet UILabel *TF;               // 상품명 앞에 백화점/매장 정보
@property (nonatomic, weak) IBOutlet UIImageView *arrow;        // 화살표

@property (nonatomic, weak) IBOutlet UIView *underLine;         // 상단 베너 아래 라인
@property (nonatomic, weak) IBOutlet UIView *underLine2;        // 상품 아래 라인


@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;         // 상품 이미지 오퍼리에터
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperationBYbanner; // 상단 베너 이미지 오퍼레이터
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperationByLT;     // 상품 이미지 좌상단 벳지 이미지 오퍼레이터
@property (nonatomic, strong) NSString *imageURL;           // 상품 이미지 경로
@property (nonatomic, strong) NSString *imageURLBybanner;   // 상단 베너 이미지 경로
@property (nonatomic, strong) NSDictionary *infoDic;        // 셀 정보 구조체


@property (nonatomic, weak) id targettb;

// 상품 클릭시 상세이동
- (IBAction)clickProduct:(id)sender;
// 상풍 정보 렌더링
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;


@end
