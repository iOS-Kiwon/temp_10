//
//  SCH_PRO_TXT_DATETypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_PRO_TXT_DATETypeCell.h"

@implementation SCH_PRO_TXT_DATETypeCell

@synthesize dateText,viewTextBG;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.viewTextBG.layer.borderWidth = 1.0;
    self.viewTextBG.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewTextBG.layer.cornerRadius = 11.5;
    self.viewTextBG.layer.shouldRasterize = YES;
    self.viewTextBG.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.dateText.text = @"";
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr{
    
    if(NCO(rowinfoArr)){

        self.dateText.text = NCS([rowinfoArr objectForKey:@"startTime"]);

    }
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
}



@end
