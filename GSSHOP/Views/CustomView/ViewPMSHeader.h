//
//  ViewPMSHeader.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 1. 13..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MOCHA/TTTAttributedLabel.h>

@interface ViewPMSHeader : UIView {
    NSDictionary *dicRankColor;
    NSDictionary *dicRankArrow;
    
    NSDictionary *dicRow;
}


@property (nonatomic,strong) IBOutlet NSLayoutConstraint *constImgArrowSizeWidth;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *constImgArrowLeading;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *constImgArrowBottom;

@property (nonatomic,strong) IBOutlet NSLayoutConstraint *constLblCustInfoWidth;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *constLblCustInfoHeight;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *constLblCustExpireHeight;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *constLblCustExpireWidth;

@property (nonatomic,strong) IBOutlet UIImageView *imgCenterArrow;

@property (nonatomic,strong) IBOutlet UIImageView *imgGradeState;

@property (nonatomic,strong) IBOutlet TTTAttributedLabel *lblTitleWithRanking;
@property (nonatomic,strong) IBOutlet UILabel *lblCustInfo;
@property (nonatomic,strong) IBOutlet UILabel *lblCustExpire;

@property (nonatomic,weak) id delegate;

-(void)setCellInfo:(NSDictionary *)dicInfo;
-(IBAction)onBtnRealMemberShip:(id)sender;
    
@end
