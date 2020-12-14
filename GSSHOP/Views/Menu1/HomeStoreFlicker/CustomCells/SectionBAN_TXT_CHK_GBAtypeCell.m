//
//  SectionBAN_TXT_CHK_GBAtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 9. 13..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_TXT_CHK_GBAtypeCell.h"
#import "SectionTBViewController.h"

@implementation SectionBAN_TXT_CHK_GBAtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dicRow = [[NSMutableDictionary alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.lblAll.text = @"";
    self.lblTitle.text = @"";
    self.btnAll.selected = NO;
}


- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoDic andIndex:(NSInteger)indexCell{
    //linkUrl": "http://sm20.gsshop.com/app/ajax/bestShop.gs?isAllView=false&version=5.2",
    
    self.index = indexCell;
    
    [self.dicRow removeAllObjects];
    [self.dicRow addEntriesFromDictionary:rowinfoDic];
    
    if (NCO(rowinfoDic) == YES) {
        if ([NCS([rowinfoDic objectForKey:@"productName"]) length] > 0) {
            self.lblTitle.text = [rowinfoDic objectForKey:@"productName"];
        }
        
        if ([NCS([rowinfoDic objectForKey:@"promotionName"]) length] > 0) {
            self.lblAll.text = [rowinfoDic objectForKey:@"promotionName"];
            self.btnAll.accessibilityLabel = [rowinfoDic objectForKey:@"promotionName"];
        }
    }
    //self.btnAll.selected = isSelected;

    NSArray *arrStrLinkUrl = [NCS([rowinfoDic objectForKey:@"linkUrl"]) componentsSeparatedByString:@"isAllView="];
    
    if ([arrStrLinkUrl count] > 1) {
        NSMutableString *strAllView = [[NSMutableString alloc] initWithString:[arrStrLinkUrl objectAtIndex:1]];
        if ([strAllView hasPrefix:@"false"]) {
            self.btnAll.selected = NO;
        }else if ([strAllView hasPrefix:@"true"]) {
            self.btnAll.selected = YES;
        }
    }
}

-(IBAction)onBtnShowAll:(id)sender{
    if ([self.target respondsToSelector:@selector(onBtnBAN_TXT_CHK_GBA:andIndex:)]) {
        [self.target onBtnBAN_TXT_CHK_GBA:self.dicRow andIndex:self.index];
    }
    
}

@end
