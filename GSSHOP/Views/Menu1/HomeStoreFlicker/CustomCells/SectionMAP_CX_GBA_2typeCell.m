//
//  SectionMAP_CX_GBA_2typeCell.m
//  GSSHOP
//
//  Created by admin on 2018. 3. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_CX_GBA_2typeCell.h"
#import "SectionTBViewController.h"

@implementation SectionMAP_CX_GBA_2typeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //280
    self.viewThreeDeal.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH,floor([Common_Util DPRateOriginVAL:93] + 100));
    
    self.sub1 = (SectionMAP_SLD_C3_GBAtypeSubview *)[[[NSBundle mainBundle] loadNibNamed:@"SectionMAP_SLD_C3_GBAtypeSubview" owner:self options:nil] firstObject];
    self.sub2 = (SectionMAP_SLD_C3_GBAtypeSubview *)[[[NSBundle mainBundle] loadNibNamed:@"SectionMAP_SLD_C3_GBAtypeSubview" owner:self options:nil] firstObject];
    self.sub3 = (SectionMAP_SLD_C3_GBAtypeSubview *)[[[NSBundle mainBundle] loadNibNamed:@"SectionMAP_SLD_C3_GBAtypeSubview" owner:self options:nil] firstObject];
    [self.viewThreeDeal addSubview:self.sub1];
    [self.viewThreeDeal addSubview:self.sub2];
    [self.viewThreeDeal addSubview:self.sub3];
    self.subArray = [[NSArray alloc] initWithObjects:self.sub1,self.sub2,self.sub3, nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.backgroundColor = [UIColor whiteColor];
    for (SectionMAP_SLD_C3_GBAtypeSubview* subview in self.viewThreeDeal.subviews) {        
        [subview prepareForReuse];
        subview.hidden = YES;
    }
}

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfo {
    //데이터 확인후 렌더링(1개에 대해서만)
    if(NCO(rowinfo) && NCA([rowinfo objectForKey:@"subProductList"]) == YES) {
        self.row_dic = rowinfo;
        [self subThreeDeals:[self.row_dic objectForKey:@"subProductList"]];
    }
}

- (void)subThreeDeals:(NSArray *)subProduct {
    float rlmargin = 5;
    /*하단 3개 상품*/
    //왼쪽 정렬
    if(NCA(subProduct)) {
        float itemSize = (self.viewThreeDeal.frame.size.width-(rlmargin*2))/3;
        float xPos = (self.viewThreeDeal.frame.size.width-(rlmargin*2))/6;
        int count = 0;
        for (NSDictionary*subItem in subProduct) {
            SectionMAP_SLD_C3_GBAtypeSubview *sub1 = [self.subArray objectAtIndex:count];
            [sub1 setCellInfoNDrawData:subItem];
            sub1.frame = CGRectMake(0, 0, itemSize, self.viewThreeDeal.frame.size.height);
            sub1.center = CGPointMake(xPos + rlmargin, sub1.frame.size.height/2);
            xPos = xPos + itemSize;
            [sub1.clickButton addTarget:self action:@selector(dealButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            sub1.clickButton.tag = count;
            sub1.hidden = NO;
            count++;
        }
    }
}

- (void)dealButtonClicked:(id)sender {
    if(self.target != nil && [self.target respondsToSelector:@selector(dctypetouchEventTBCell:andCnum:withCallType:)]) {
        [self.target dctypetouchEventTBCell:[[self.row_dic objectForKey:@"subProductList"] objectAtIndex:[((UIButton *)sender) tag]] andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag] ]withCallType:@"MAP_CX_GBA"];
    }
}

@end
