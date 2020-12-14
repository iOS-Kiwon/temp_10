//
//  TableHeaderDCtypeView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 4. 2..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  모든 매장 테이블뷰 헤더에서 사용가능하나 ,현재 사용안함
//  네비게이션 매장 데이터중 no1DealList 값이 있을경우 테이블뷰 헤더에 표현

//  사용안한지 너무 오래되고 배너 표현방식이 많이 바뀌어서 삭제여부 판단해야함

#import <UIKit/UIKit.h>

@interface TableHeaderDCtypeView : UIView {
    NSDictionary *rdic;
}

@property (nonatomic, weak) id target;

@property (nonatomic, weak) IBOutlet UIImageView *productImageView;
@property (nonatomic, weak) IBOutlet UIImageView *soldoutImageView;
@property (nonatomic, weak) IBOutlet UIImageView *videoImageView;

//tagimage
@property (nonatomic, weak) IBOutlet UIImageView *tagfreeImageView;
@property (nonatomic, weak) IBOutlet UIImageView *tagquickImageView;
@property (nonatomic, weak) IBOutlet UIImageView *tag_no1BestDeal;

@property (nonatomic, weak) IBOutlet UILabel *productTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *productSubTitleLabel;

@property (nonatomic, weak) IBOutlet UILabel *discountRateLabel;
@property (nonatomic, weak) IBOutlet UILabel *discountRatePercentLabel;

@property (nonatomic, weak) IBOutlet UIView *gsLabelView;

@property (nonatomic, weak) IBOutlet UILabel *extLabel;

@property (nonatomic, weak) IBOutlet UILabel *gsPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *gsPriceWonLabel;

@property (nonatomic, weak) IBOutlet UILabel *originalPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *originalPriceWonLabel;
@property (nonatomic, weak) IBOutlet UIView *originalPriceLine;



@property (nonatomic, weak) IBOutlet UILabel *saleCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *saleSaleLabel;
@property (nonatomic, weak) IBOutlet UILabel *saleSaleSubLabel;


@property (nonatomic,strong) IBOutlet UIButton *btn_no1best;

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) NSString *imageURL;

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe;
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;
-(IBAction)clickEvtwithDic:(id)sender;


@end
