//
//  TVSCDHeaderCellView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BenefitTagView.h"
#import "AppDelegate.h"

@interface TVSCDHeaderCellView : UIView {
    IBOutlet UILabel *label_broadType;
    IBOutlet UILabel *productTitleLabel;
    
    BenefitTagView *benefitview;
}

@property (nonatomic, weak) id target;

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong)  IBOutlet UILabel *priceLabel;
@property (nonatomic, strong)  IBOutlet UILabel *originalPriceLabel;
@property (nonatomic, strong)  IBOutlet UIView *originalPriceLine;
@property (nonatomic, strong)  IBOutlet UILabel *originalPriceWonLabel;
@property (nonatomic, strong) IBOutlet  UILabel *wonLabel;
@property (nonatomic, strong) IBOutlet  UILabel *onAirText;
@property (nonatomic, strong) IBOutlet  UILabel *onAirTime;
@property (nonatomic, strong) IBOutlet  UILabel *councelText;
@property (nonatomic, weak) IBOutlet UIImageView *productImageView;

@property (nonatomic, strong)  IBOutlet UIView *air_buy;
@property (nonatomic, strong)  IBOutlet UIView *sold_out;

- (id) initWithTarget:(id)sender Nframe:(CGRect)tframe;
- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr;

@end
