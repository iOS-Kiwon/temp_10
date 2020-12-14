//
//  SectionMAP_MUT_CATEGORY_GBAtypeCell.m
//  GSSHOP
//
//  Created by admin on 2017. 8. 11..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_MUT_CATEGORY_GBAtypeCell.h"
#import "AppDelegate.h"

@implementation SectionMAP_MUT_CATEGORY_GBAtypeCell

@synthesize target;


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    for(UIView *temp in viewBG.subviews)
    {
        [temp removeFromSuperview];
    }
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo seletedIndex:(NSInteger)index {
        
    CGFloat corner = 2.0;
    viewBG.layer.cornerRadius = corner;
    
    arrCateInfo = [rowinfo objectForKey:@"subProductList"];
    
    BOOL isBeforeSeleted = NO;
        
    CGFloat viewBGWidth = APPFULLWIDTH - 20.0;
        
    for (NSInteger i = 0 ; i<[arrCateInfo count]; i++) {
        
        NSDictionary *dicRow = [arrCateInfo objectAtIndex:i];
        UIButton *btnCate = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i != index) {
        CGFloat xPostionModifier = (isBeforeSeleted)?0.0:1.0;
            btnCate.frame = CGRectMake(0 + i*(viewBGWidth/[arrCateInfo count]) + xPostionModifier , 1.0, viewBGWidth /[arrCateInfo count] - 1.0, 36.0 - 2.0);
        }
        else {
            isBeforeSeleted = YES;
            btnCate.frame = CGRectMake(0 + i*(viewBGWidth/[arrCateInfo count]), 0.0, viewBGWidth /[arrCateInfo count], 36.0);
        }
        
        UIBezierPath *maskPath;
        
        
        if (i == 0) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:btnCate.bounds
                                             byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                                   cornerRadii:CGSizeMake(corner, corner)];
            
        }
        else if (i != 0 && i == [arrCateInfo count]-1) {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:btnCate.bounds
                                             byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerTopRight)
                                                   cornerRadii:CGSizeMake(corner, corner)];
        }
        else {
            maskPath = [UIBezierPath bezierPathWithRoundedRect:btnCate.bounds
                                             byRoundingCorners:UIRectCornerAllCorners
                                                   cornerRadii:CGSizeMake(0.0, 0.0)];
        }
        
        
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = btnCate.bounds;
        maskLayer.path = maskPath.CGPath;
        
        btnCate.layer.mask = maskLayer;
        [btnCate.layer setMasksToBounds:NO];
        
        
        
        [btnCate setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateNormal];
        [btnCate setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateReserved];
        [btnCate setTitleColor:[Mocha_Util getColor:@"FFFFFF"] forState:UIControlStateSelected];
        [btnCate setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateDisabled];
        [btnCate setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateHighlighted];
        
        //666666
        [btnCate setTitleShadowColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateNormal];
        [btnCate setTitleShadowColor:[Mocha_Util getColor:@"FFFFFF"] forState:UIControlStateSelected];
        
        [btnCate setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateHighlighted];
        [btnCate setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"A4DD00"]] forState:UIControlStateSelected];
        [btnCate setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"FFFFFF"]] forState:UIControlStateNormal];
        
        
        [btnCate.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [btnCate setTitle:[dicRow objectForKey:@"productName"] forState:UIControlStateNormal];
        [btnCate.titleLabel setLineBreakMode:NSLineBreakByClipping];
        
        btnCate.tag = i;
        [btnCate addTarget:self action:@selector(onBtnCate:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewBG addSubview:btnCate];
        
    } // for
        
    [self setCateIndex:index];
}




- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



-(void)onBtnCate:(id)sender {
    
    NSInteger tag = [((UIButton *)sender) tag];
    [target onBtnFlexCate:[arrCateInfo objectAtIndex:tag] andCnum:[NSNumber numberWithInt:(int)tag] withCallType:@"MAP_MUT_CATEGORY_GBA"];
}

-(void)setCateIndex:(NSInteger)indexCategory{
    for (int i=0; i<[[viewBG subviews] count]; i++) {
        UIButton *btnCate = (UIButton *)[[viewBG subviews] objectAtIndex:i];
        btnCate.selected = ([btnCate tag]==indexCategory)?YES:NO;
    }
}


@end
