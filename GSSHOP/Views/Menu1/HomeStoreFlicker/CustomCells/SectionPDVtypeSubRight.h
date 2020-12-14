//
//  SectionPDVtypeSubRight.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 27..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  백화점 매장
//  백화점 매장 PDV 셀에서만 사용 , 뷰 오른쪽에 이미지 왼쪽에 상품설명

#import <UIKit/UIKit.h>

@interface SectionPDVtypeSubRight : UIView

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;                     //모든 변수 SectionPDVtypeSubLeft 와 동일한 구조
@property (nonatomic, weak) id target;
@property (nonatomic,strong) IBOutlet UIView *viewProductImage02;
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct02;
@property (nonatomic,strong) IBOutlet UIView *viewProductDesc02;
@property (nonatomic,strong) IBOutlet UILabel *lblSpecialCopy02;

@property (nonatomic, strong) IBOutlet UILabel *dummytagTF02;
@property (nonatomic, strong) IBOutlet UILabel *lblProductName02;

@property (nonatomic, strong) IBOutlet UILabel *promotionName02;
@property (nonatomic, strong) IBOutlet UILabel *valuetext02;

@property (nonatomic, strong) IBOutlet UILabel *discountRateLabel02;
@property (nonatomic, strong) IBOutlet UILabel *discountRatePercentLabel02;
@property (nonatomic, strong) IBOutlet UILabel *extLabel02;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gspricelabel_lmargin02;

@property (nonatomic, strong) IBOutlet UILabel *gsPriceLabel02;
@property (nonatomic, strong) IBOutlet UILabel *gsPriceWonLabel02;

@property (nonatomic, strong) IBOutlet UILabel *originalPriceLabel02;
@property (nonatomic, strong) IBOutlet UILabel *originalPriceWonLabel02;
@property (nonatomic, strong) IBOutlet UIView *originalPriceLine02;

@property (nonatomic, strong) NSDictionary *dicRow02;

@property (nonatomic, assign) NSInteger idxRow;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;

-(IBAction)onBtn:(id)sender;

@end
