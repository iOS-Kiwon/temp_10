//
//  BenefitTagView.h
//  GSSHOP
//
//  Created by admin on 2017. 9. 28..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BENEFITTAG_HEIGTH 25

@interface BenefitTagView : UIView

@property (nonatomic, strong) IBOutlet UIView *viewBenefit01;
@property (nonatomic, strong) IBOutlet UIView *viewBenefit02;
@property (nonatomic, strong) IBOutlet UIView *viewBenefit03;
@property (nonatomic, strong) IBOutlet UIImageView *imgBenefit01;
@property (nonatomic, strong) IBOutlet UIImageView *imgBenefit02;
@property (nonatomic, strong) IBOutlet UIImageView *imgBenefit03;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBenefitWidth01;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBenefitWidth02;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *lconstBenefitWidth03;

@property (nonatomic, strong) NSString *strBenefitURL01;
@property (nonatomic, strong) NSString *strBenefitURL02;
@property (nonatomic, strong) NSString *strBenefitURL03;

- (void)setBenefitTag:(NSDictionary*) dicRow;

@end
