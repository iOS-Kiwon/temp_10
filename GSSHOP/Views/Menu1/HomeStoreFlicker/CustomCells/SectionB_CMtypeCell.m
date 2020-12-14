//
//  SectionB_CMtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 11. 23..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_CMtypeCell.h"
#import "SectionTBViewController.h"

@implementation SectionB_CMtypeCell
@synthesize lblCate;
@synthesize target;
@synthesize infoDic;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)prepareForReuse{
    [super prepareForReuse];
    lblCate.text = @"";
}


- (IBAction)onClick:(id)sender {
    
    if ([self.target respondsToSelector:@selector(dctypetouchEventTBCell:andCnum:withCallType:)]) {
        [self.target dctypetouchEventTBCell:self.infoDic  andCnum:0 withCallType:@"B_CM"];
    }
    
    
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    self.backgroundColor = [UIColor clearColor];
    
    self.infoDic = rowinfo;
    self.lblCate.text = NCS([rowinfo objectForKey:@"productName"]);
    
}



@end
