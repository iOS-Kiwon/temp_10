//
//  CMPrd2SubCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 12. 20..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "CMPrd2SubCell.h"

@implementation CMPrd2SubCell
@synthesize lblTitle;
@synthesize lblPrice;
@synthesize lblPriceWon;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lblTitle.font = [UIFont fontWithName:@"Campton-BoldDEMO" size:14];
    self.lblPrice.font = [UIFont fontWithName:@"Campton-LightDEMO" size:15];
    //self.lblPriceWon.font = [UIFont fontWithName:@"Campton-LightDEMO" size:14];
}

@end
