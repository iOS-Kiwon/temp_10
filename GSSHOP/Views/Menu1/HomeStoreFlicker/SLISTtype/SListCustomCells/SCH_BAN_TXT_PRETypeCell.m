//
//  SCH_BAN_TXT_PRETypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_BAN_TXT_PRETypeCell.h"
#import "SListTBViewController.h"

@implementation SCH_BAN_TXT_PRETypeCell
@synthesize dateText,target,imgPlus,viewBG;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.dateText.text = @"";
    self.imgPlus.hidden = YES;
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    if(NCO(rowinfoArr)) {
        infoDic = rowinfoArr;
        self.dateText.text = NCS([rowinfoArr objectForKey:@"broadLeftText"]);
        self.imgPlus.hidden = NO;
    }
}

- (IBAction)onClick:(id)sender {
    if(self.target) {
        if ([self.target respondsToSelector:@selector(onHeaderFooterAction:data:)]) {
            [self.target onHeaderFooterAction:0 data:infoDic];
        }
    }
}



@end
