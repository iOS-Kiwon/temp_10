//
//  SectionFPC_SubCategoryView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 11. 21..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionFPC_SubCategoryView.h"
#import "SectionView.h"

@implementation SectionFPC_SubCategoryView
@synthesize viewGreenBorder;
@synthesize target;

@synthesize lblSubCate;



-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.viewGreenBorder.layer.borderColor = [Mocha_Util getColor:@"A4DE00"].CGColor;
    self.viewGreenBorder.layer.borderWidth = 1.0f;
    
}

-(void)setCellInfoLabelText:(NSString *)strSubCate{
    self.lblSubCate.text = NCS(strSubCate);
}


-(IBAction)onBtnSubCategory:(id)sender{
    if ([self.target respondsToSelector:@selector(FPCDisplaySubCategoryView: andCateHeaderShow:)]) {
        [self.target FPCDisplaySubCategoryView:YES andCateHeaderShow:YES];
    }
}


@end
