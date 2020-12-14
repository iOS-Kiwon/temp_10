//
//  SectionBAN_MUT_H55_GBAtypeCell.m
//  GSSHOP
//
//  Created by admin on 2017. 8. 10..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_MUT_H55_GBAtypeCell.h"

@implementation SectionBAN_MUT_H55_GBAtypeCell

@synthesize lblTitle,imgArrow;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // 링크가 없으면 무시한다.
    if(self.imgArrow.hidden)
        return;
    
    [super setSelected:selected animated:animated];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.lblTitle.text = @"";
    self.imgArrow.hidden = YES;
}




-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo {
    
    self.lblTitle.text = [rowinfo objectForKey:@"productName"];
    
    self.imgArrow.hidden = [NCS([rowinfo objectForKey:@"linkUrl"]) isEqualToString:@""];
}

@end
