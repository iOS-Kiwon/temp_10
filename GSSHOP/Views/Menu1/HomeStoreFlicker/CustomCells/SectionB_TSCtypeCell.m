//
//  SectionB_TSCtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_TSCtypeCell.h"

@implementation SectionB_TSCtypeCell

@synthesize lblTitle;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
    lblTitle.text = @"";
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    
    lblTitle.text = [rowinfo objectForKey:@"productName"];
}



@end
