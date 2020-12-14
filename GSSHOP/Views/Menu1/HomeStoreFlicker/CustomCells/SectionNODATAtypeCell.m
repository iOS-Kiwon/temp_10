//
//  SectionNODATAtypeCell.m
//  GSSHOP
//  데이터가 없을경우 노출하는 셀
//  Created by admin on 2018. 4. 16..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionNODATAtypeCell.h"

@implementation SectionNODATAtypeCell

@synthesize infomationLabel,row_dic;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.infomationLabel.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.infomationLabel.text = @"";
}

- (void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic {
    self.row_dic = rowinfoDic;
    NSString *name = NCS([self.row_dic objectForKey:@"productName"]);
    if([name length] > 0) {
        self.infomationLabel.text = [NSString stringWithFormat:@"오늘은 '%@'에\n새로 오픈한 딜이 없습니다.", name];
    }
    else {
        self.infomationLabel.text = @"오늘은 새로 오픈한 딜이 없습니다.";
    }
}

@end
