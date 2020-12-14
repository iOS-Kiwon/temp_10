//
//  SectionMAP_CX_GBB_MOREtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 29..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_CX_GBB_MOREtypeCell.h"
#import "SUPListTableViewController.h"

@implementation SectionMAP_CX_GBB_MOREtypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic indexPath:(NSIndexPath *)path{
    self.dicInfo = rowInfoDic;
    self.idxPath = path;
    
    if ([[self.dicInfo objectForKey:@"noShow"] isEqualToString:@"Y"]) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    if ([NCS([self.dicInfo objectForKey:@"isMore"]) isEqualToString:@"Y"]) {
        self.viewGoShop.hidden = YES;
    }else{
        self.viewGoShop.hidden = NO;
    }
}
- (IBAction)onBtnGoShop:(id)sender{
    NSString *strLink = NCS([self.dicInfo objectForKey:@"linkUrl"]);
    if ([self.target respondsToSelector:@selector(onBtnSUPCellJustLinkStr:)] && [strLink length] > 0) {
        //효율코드 A00481-BA-2
        [ApplicationDelegate wiseAPPLogRequest:WISELOGCOMMONURL(@"?mseq=A00481-BA-2")];
        [self.target onBtnSUPCellJustLinkStr:strLink];
    }
}
- (IBAction)onBtnMore:(id)sender{
    
    if ([self.target respondsToSelector:@selector(touchSubProductShowMoreIndexPath:)]){
        NSLog(@"self.idxPath = %@",self.idxPath);
        //효율코드  A00481-LM-1
        [ApplicationDelegate wiseAPPLogRequest:WISELOGCOMMONURL(@"?mseq=A00481-LM-1")];
        [self.target touchSubProductShowMoreIndexPath:self.idxPath];
    }
}

@end
