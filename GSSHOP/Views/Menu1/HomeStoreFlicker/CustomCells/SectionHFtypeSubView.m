//
//  SectionHFtypeSubView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 1..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionHFtypeSubView.h"
#import "SectionHFtypeCell.h"
#import "AppDelegate.h"

@implementation SectionHFtypeSubView
@synthesize targetHF;

@synthesize viewLineBottom;
@synthesize viewLineLeading;
@synthesize viewLineVer01;
@synthesize viewLineVer02;
@synthesize viewLineVer03;
@synthesize viewLineVer04;
@synthesize viewLineVer05;
@synthesize viewLineTrailing;
@synthesize strHighlightColor;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    strHighlightColor = @"FA626C"; //디폴트값 설정
}

-(void) setCellInfoNDrawData:(NSArray*)arrHash seletedIndex:(NSInteger)index{
    
    idxSeleted = index;
    
    arrHashInfo = arrHash;
    
    CGFloat viewBGWidth = APPFULLWIDTH - 20.0;
    
    NSInteger limit = ([arrHash count]<kMaxCountHF)?[arrHash count]:kMaxCountHF;
    
    NSInteger limitRowPerCount = kRowPerCountHF;
    if ([arrHash count] < kMaxCountHF && [arrHash count] < kRowPerCountHF) {
        limitRowPerCount = [arrHash count];
    }
    
    for (NSInteger i = 0 ; i<limit; i++) {
        
        NSDictionary *dicRow = [arrHash objectAtIndex:i];
        
        UIView *viewCate = [[UIView alloc] initWithFrame:CGRectZero];
        
        viewCate.frame = CGRectMake(0 + (i%limitRowPerCount)*(viewBGWidth/limitRowPerCount), (kHEIGHTHF * (i/limitRowPerCount)), viewBGWidth /limitRowPerCount +1, kHEIGHTHF+1);
        viewCate.backgroundColor = [UIColor whiteColor];
        
        if (limit >= i + 1 && i%limitRowPerCount == 0) {
            UIView *viewMiddleLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, viewCate.frame.origin.y , viewBGWidth, 1.0)];
            if (i==0) {
                viewMiddleLine.backgroundColor = [Mocha_Util getColor:@"DDDDDD"];
            }else{
                viewMiddleLine.backgroundColor = [Mocha_Util getColor:@"EEEEEE"];
            }
            
            [self addSubview:viewMiddleLine];
            
        }
        
        
        
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectZero];
        
        lblText.textColor = [Mocha_Util getColor:@"666666"];
        
        lblText.text = [dicRow objectForKey:@"productName"];
        if (APPFULLWIDTH <= 640) {
            lblText.font = [UIFont systemFontOfSize:([lblText.text length]>3)?12.0:14.0];
        }else{
            lblText.font = [UIFont systemFontOfSize:14];
        }
        
        
        
        lblText.lineBreakMode = NSLineBreakByClipping;
        lblText.backgroundColor = [UIColor clearColor];
        
        
        lblText.frame = CGRectMake(0.0, 0.0, viewCate.frame.size.width, viewCate.frame.size.height);
        lblText.textAlignment = NSTextAlignmentCenter;
        
        [viewCate addSubview:lblText];
        
        viewCate.tag = 200 + i;
        
        UIButton *btnCate = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCate.frame = CGRectMake(0.0, 0.0, viewCate.frame.size.width, viewCate.frame.size.height);
        
        btnCate.tag = i;
        [btnCate addTarget:self action:@selector(onBtnCate:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewCate addSubview:btnCate];
        
        [self insertSubview:viewCate atIndex:0];
        
        
        
        
    }
    
    
    
    if ((limit%limitRowPerCount) != 0) {
        viewLineBottom.frame = CGRectMake(viewLineBottom.frame.origin.x, self.frame.size.height,  (viewBGWidth/limitRowPerCount *(limit%limitRowPerCount)), 1.0);
        
        UIView *viewLineBottomMore = [[UIView alloc] initWithFrame:CGRectMake(viewLineBottom.frame.origin.x + viewLineBottom.frame.size.width +1, viewLineBottom.frame.origin.y - kHEIGHTHF, viewBGWidth - (viewBGWidth/limitRowPerCount) *(limit%limitRowPerCount), 1.0)];
        
        viewLineBottomMore.backgroundColor  = [Mocha_Util getColor:@"DDDDDD"];
        [self addSubview:viewLineBottomMore];
        
    }else{
        viewLineBottom.frame = CGRectMake(viewLineBottom.frame.origin.x, self.frame.size.height,  viewBGWidth +1, 1.0);
    }
    
    
    viewLineLeading.frame = CGRectMake(0.0, 0.0, 1.0, self.frame.size.height);
    
    if ((limit%limitRowPerCount) != 0) {
        
        
        NSInteger line01 = 0;
        if (limit%limitRowPerCount > 0) {
            line01 = 1;
        }
        
        viewLineVer01.frame = CGRectMake(viewBGWidth/limitRowPerCount * 1 , 0.0, 1.0, kHEIGHTHF *(limit/limitRowPerCount + line01));
        
        
        NSInteger line02 = 0;
        if (limit%limitRowPerCount > 1) {
            line02 = 1;
        }
        
        viewLineVer02.frame = CGRectMake(viewBGWidth/limitRowPerCount * 2 , 0.0, 1.0, kHEIGHTHF *(limit/limitRowPerCount + line02));
        
        NSInteger line03 = 0;
        if (limit%limitRowPerCount > 2) {
            line03 = 1;
        }
        
        viewLineVer03.frame = CGRectMake(viewBGWidth/limitRowPerCount * 3 , 0.0, 1.0, kHEIGHTHF *(limit/limitRowPerCount + line03));
        
        
        NSInteger line04 = 0;
        if (limit%limitRowPerCount > 3) {
            line04 = 1;
        }
        
        viewLineVer04.frame = CGRectMake(viewBGWidth/limitRowPerCount * 4 , 0.0, 1.0, kHEIGHTHF *(limit/limitRowPerCount + line04));
        
        
        NSInteger line05 = 0;
        if (limit%limitRowPerCount > 4) {
            line05 = 1;
        }
        
        viewLineVer05.frame = CGRectMake(viewBGWidth/limitRowPerCount * 5 , 0.0, 1.0, kHEIGHTHF *(limit/kRowPerCountHF + line05));
        
        
        
        UIView *viewLineMiddleMore = [[UIView alloc] initWithFrame:CGRectMake((viewBGWidth/limitRowPerCount) * (limit%limitRowPerCount) , self.frame.size.height -  kHEIGHTHF   , 1.0, kHEIGHTHF + 1.0)];
        
        viewLineMiddleMore.backgroundColor  = [Mocha_Util getColor:@"DDDDDD"];
        
        [self addSubview:viewLineMiddleMore];
        
        
    }else{
        viewLineVer01.frame = CGRectMake(viewBGWidth/limitRowPerCount * 1 , 0.0, 1.0, self.frame.size.height);
        viewLineVer02.frame = CGRectMake(viewBGWidth/limitRowPerCount * 2 , 0.0, 1.0, self.frame.size.height);
        viewLineVer03.frame = CGRectMake(viewBGWidth/limitRowPerCount * 3 , 0.0, 1.0, self.frame.size.height);
        viewLineVer04.frame = CGRectMake(viewBGWidth/limitRowPerCount * 4 , 0.0, 1.0, self.frame.size.height);
        viewLineVer05.frame = CGRectMake(viewBGWidth/limitRowPerCount * 5 , 0.0, 1.0, self.frame.size.height);
    }
    
    
    
    
    viewLineTrailing.frame = CGRectMake(viewBGWidth, 0.0, 1.0, kHEIGHTHF * (limit/limitRowPerCount));
    
    [self bringSubviewToFront:viewLineLeading];
    
    if (index > -1) {
        [self setCateIndex:index];
    }
    
}


-(void)onBtnCate:(id)sender {
    
    NSInteger tag = [((UIButton *)sender) tag];
    
    if ([targetHF respondsToSelector:@selector(onBtnHashTags:withInfoDic:)]) {
        [targetHF onBtnHashTags:tag withInfoDic:[arrHashInfo objectAtIndex:tag]];
    }
    
    
}

-(void)setCateIndex:(NSInteger)indexCategory{
    for (int i=0; i<[[self subviews] count]; i++) {
        if ([[[self subviews] objectAtIndex:i] isKindOfClass:[UIView class]]) {
            UIView *viewCate = (UIView *)[[self subviews] objectAtIndex:i];
            if ([viewCate tag] >= 200) {
                
                if ([viewCate tag]==indexCategory + 200) {
                    [self setViewCateStatus:viewCate andSelect:YES];
                }else{
                    [self setViewCateStatus:viewCate andSelect:NO];
                }
                
            }
            
            
        }
    }
    
}

-(void)setViewCateStatus:(UIView*)targetView andSelect:(BOOL)isSelected{

    targetView.backgroundColor = [UIColor whiteColor];
    
    UIColor *borderColor = (isSelected)?[Mocha_Util getColor:strHighlightColor]:[Mocha_Util getColor:@"FFFFFF"];
    [targetView.layer setMasksToBounds:NO];
    targetView.layer.shadowOffset = CGSizeMake(0, 0);
    targetView.layer.shadowRadius = 0.0;
    targetView.layer.borderColor = borderColor.CGColor;
    targetView.layer.borderWidth = 1;
    
    
    if (isSelected) {
        [self bringSubviewToFront:targetView];
    }else{
        [self insertSubview:targetView atIndex:0];
    }
    
    
    for (id view in targetView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imgCrown = (UIImageView *)view;
            imgCrown.highlighted = isSelected;
            
        }else if ([view isKindOfClass:[UILabel class]]) {
            UILabel *lblText = (UILabel *)view;
            if (isSelected) {
                lblText.textColor = [Mocha_Util getColor:@"111111"];
                
                
                if (APPFULLWIDTH <= 640) {
                    lblText.font = [UIFont boldSystemFontOfSize:([lblText.text length]>3)?12.0:14.0];
                }else{
                    lblText.font = [UIFont boldSystemFontOfSize:14.0];
                }
                
            }else{
                lblText.textColor = [Mocha_Util getColor:@"666666"];
                if (APPFULLWIDTH <= 640) {
                    lblText.font = [UIFont systemFontOfSize:([lblText.text length]>3)?12.0:14.0];
                }else{
                    lblText.font = [UIFont systemFontOfSize:14.0];
                }
                
            }
            
        }
    }
    
    
    
    
}


@end
