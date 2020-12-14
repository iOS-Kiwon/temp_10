//
//  SectionNHPtypeCell.h
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 26..
// 날방 메인 상품셀
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNHPCALLTYPE @"NHP_TAGS"

@interface SectionNHPtypeCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UIView *view_Default;
@property (nonatomic, weak) IBOutlet UIImageView *productImage;     // 상품 이미지
@property (nonatomic, weak) IBOutlet UILabel *productName;          // 상품 명
@property (nonatomic, weak) IBOutlet UILabel *discountRate;         // 할인율
@property (nonatomic, weak) IBOutlet UILabel *discountRatePercent;  // 할인율% 혹은 텍스트
@property (nonatomic, weak) IBOutlet UILabel *salePrice;            // 기본가
@property (nonatomic, weak) IBOutlet UILabel *salePriceWon;         // 기본가 원/원~
@property (nonatomic, weak) IBOutlet UILabel *saleCount;            // 판매량
@property (nonatomic, weak) IBOutlet UILabel *saleCountMsg;         // 판매량 텍스트
@property (nonatomic, weak) IBOutlet UILabel *time;                 // 방송 플레이 시간
@property (nonatomic, weak) IBOutlet UIView *timeView;              // 방송 플레이 시간 백그라운드
@property (nonatomic, weak) IBOutlet UIView *hashTagView;           // 해시 태그 노출 뷰
@property (nonatomic, weak) IBOutlet UIButton *cellClick;           // 상품셀 클릭 버튼



@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation; // 상품 이미지 오퍼레이션
@property (nonatomic, strong) NSString *imageURL;                           // 상품 이미지 경로
@property (nonatomic, strong) NSDictionary *infoDic;                        // 상품 데이터 구조체
@property (nonatomic, strong) NSDictionary *infoHashTag;                    // 해시태그 구조체
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *salePriceWDiscountRateTrail;

@property (nonatomic, weak) id target;


// 해시태그 클릭 이벤트
- (IBAction)clickHashTag:(id)sender;

// 상풍 정보 렌더링
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

// 상품 클릭 이벤트(상세 이동)
- (IBAction)clickProduct:(id)sender;

@end
