//
//  SectionMAP_CX_GBB_CATEtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 01/07/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_CX_GBB_CATEtypeCell.h"
//#import "SectionSUP_ViewCateFreezePans.h"

@implementation SectionMAP_CX_GBB_CATEtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
    for (UIView *viewSub in self.viewDefault.subviews) {
        [viewSub removeFromSuperview];
    }
}

- (void)setCellInfoNDrawData:(NSArray*)arrInfo andIndex:(NSInteger)idxSelected andTarget:(id)aTarget{
    SectionSUP_ViewCateFreezePans *viewCate = [[[NSBundle mainBundle] loadNibNamed:@"SectionSUP_ViewCateFreezePans" owner:self options:nil] firstObject];
    [viewCate setCellInfoNDrawData:arrInfo andIndex:idxSelected];
    viewCate.aTarget = aTarget;
    
    [self.viewDefault addSubview:viewCate];
}

@end
