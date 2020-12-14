//
//  SectionBTS2typeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionBTS2typeCell.h"

@implementation SectionBTS2typeCell

@synthesize lblTitle,lblTime;
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.lblTitle.textColor = [Mocha_Util getColor:@"111111"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    lblTitle.text = @"";
    lblTime.text = @"";
    
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr{
    self.backgroundColor = [UIColor clearColor];
    lblTitle.text = NCS([rowinfoArr objectForKey:@"productName"]);
    lblTime.text = NCS([rowinfoArr objectForKey:@"promotionName"]);
    
    if ([lblTitle.text length] > 0) {
        lblTitle.text = [NSString stringWithFormat:@"%@",lblTitle.text];
    }
    
    
    
}

@end
