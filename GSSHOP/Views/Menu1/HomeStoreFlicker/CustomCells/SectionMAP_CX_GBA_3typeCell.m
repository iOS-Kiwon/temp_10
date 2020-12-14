//
//  SectionMAP_CX_GBA_3typeCell.m
//  GSSHOP
//
//  Created by admin on 2018. 3. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_CX_GBA_3typeCell.h"
#import "SectionTBViewController.h"

@implementation SectionMAP_CX_GBA_3typeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.moreView.hidden = YES;
    self.openView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.moreView.hidden = YES;
    self.openView.hidden = YES;
    self.clickButton.accessibilityLabel = @"";
}

//더보기는. YES, 매장이동은 NO
- (void)setOpen:(BOOL) more {
    self.openView.hidden = !more;
    self.moreView.hidden = more;
    self.clickButton.accessibilityLabel = [self isOpen] ? @"상품 더보기" : @"브랜드샵 바로가기";
}

//더보기? YES, 매장? NO
- (BOOL)isOpen {
    return !self.openView.hidden;
}

- (IBAction)clickMoreAndOpen:(id)sender {
    if(!self.openView.hidden) {
        // 더보기
         if(self.target != nil && [self.target respondsToSelector:@selector(touchSubProductStatus:andIndexPath:)]) {
             [self.target touchSubProductStatus:[self isOpen] andIndexPath:self.idxPath];
         }
    }
    else {
        // 매장이동
        if(self.target != nil && [self.target respondsToSelector:@selector(dctypetouchEventTBCell:andCnum:withCallType:)]) {
            [self.target dctypetouchEventTBCell:self.row_dic andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag] ]withCallType:@"MAP_CX_GBA"];
        }
    }
}

@end
