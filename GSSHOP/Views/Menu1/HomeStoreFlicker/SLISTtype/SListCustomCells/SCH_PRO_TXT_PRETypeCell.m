//
//  SCH_PRO_TXT_PRETypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_PRO_TXT_PRETypeCell.h"
#import "SListTBViewController.h"

@implementation SCH_PRO_TXT_PRETypeCell
@synthesize dateText,target;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.dateText.text = @"";
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    if(NCO(rowinfoArr)){
        infoDic = rowinfoArr;
        self.dateText.text = NCS([rowinfoArr objectForKey:@"broadRightText"]);
    }
}

- (IBAction)onClick:(id)sender {
    if(self.target) {
        if ([self.target respondsToSelector:@selector(onHeaderFooterAction:data:)]) {
            [self.target onHeaderFooterAction:2 data:infoDic];
        }
        //효율코드
        if([self.target isLiveBrd]) {
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_S-PD")];
        }
        else {
            [ApplicationDelegate wiseLogRestRequest: WISELOGCOMMONURL(@"?mseq=A00323-L_S_D-PD")];
        }
    }
}



@end
