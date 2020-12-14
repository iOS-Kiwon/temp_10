//
//  SectionMAP_SLD_C3_GBAtypeSubview.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//  오토레이아웃이 적용된 가변 사이즈 단순 상품뷰

#import <UIKit/UIKit.h>

@interface SectionMAP_SLD_C3_GBAtypeSubview : UIView

@property (nonatomic,strong) IBOutlet UIImageView *noImg;                //노이미지뷰
@property (nonatomic,strong) IBOutlet UIImageView *productImg;
@property (nonatomic,strong) IBOutlet UILabel *price;
@property (nonatomic,strong) IBOutlet UILabel *priceWon;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (nonatomic, strong) NSDictionary *row_dic;                    //셀 전체를 구성할때 사용하는 데이터
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;
-(void) prepareForReuse;

@end
