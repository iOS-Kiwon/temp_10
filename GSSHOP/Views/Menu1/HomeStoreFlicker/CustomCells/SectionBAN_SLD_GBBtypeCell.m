//
//  SectionBAN_SLD_GBAtypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 1..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_SLD_GBBtypeCell.h"


@implementation SectionBAN_SLD_GBBtypeCell
@synthesize target,cell;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.cell = [[SectionBAN_SLD_GBABtypeView alloc] initWithTarget:self Nframe:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160] + 10) Type:@"BAN_SLD_GBB"];
    [self addSubview:cell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) prepareForReuse{
    [super prepareForReuse];
    [self.cell prepareForReuse];
}

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr index:(NSInteger) position {
    [self setCellInfoNDrawData:rowinfoArr];
    [self.cell setPositionKey:position];
    [self.cell setSlidePostion:position];
}

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    self.cell.autoRollingValue = [NCS([rowinfoArr objectForKey:@"rollingDelay"]) floatValue];
    self.cell.isRandom = [NCS([rowinfoArr objectForKey:@"randomYn"]) isEqualToString:@"Y"] ? YES : NO;
    [self.cell setCellInfoNDrawData:[rowinfoArr objectForKey:@"subProductList"]];
    self.cell.target = target;
}

@end
