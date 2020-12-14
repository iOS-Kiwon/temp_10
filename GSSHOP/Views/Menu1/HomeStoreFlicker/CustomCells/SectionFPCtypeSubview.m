//
//  SectionFPCtypeSubview.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionFPCtypeSubview.h"
#import "SectionFPCtypeCell.h"
#import "SectionTCFtypeCell.h"
#import "AppDelegate.h"

@implementation SectionFPCtypeSubview

@synthesize targetFPC;
@synthesize viewLineBottom;
@synthesize viewLineVer01;
@synthesize viewLineVer02;
@synthesize viewLineVer03;
@synthesize viewLineVer04;

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void) setCellInfoNDrawData:(NSArray*)arrCate seletedIndex:(NSInteger)index {
    idxSeleted = index;
    arrCateInfo = arrCate;
    CGFloat viewBGWidth = APPFULLWIDTH - 20.0;
    for (NSInteger i = 0 ; i<[arrCate count]; i++) {
        NSDictionary *dicRow = [arrCate objectAtIndex:i];
        UIView *viewCate = [[UIView alloc] initWithFrame:CGRectZero];
        viewCate.frame = CGRectMake(0 + (i%3)*(viewBGWidth/3), (kHEIGHTFPC * (i/3)), viewBGWidth /3.0 +1, kHEIGHTFPC+1);
        viewCate.backgroundColor = [UIColor whiteColor];
        if ([arrCate count] >= i + 1 && i%3 == 0) {
            UIView *viewMiddleLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, viewCate.frame.origin.y , viewBGWidth, 1.0)];
            if (i==0) {
                viewMiddleLine.backgroundColor = [Mocha_Util getColor:@"DDDDDD"];
            }
            else {
                viewMiddleLine.backgroundColor = [Mocha_Util getColor:@"EEEEEE"];
            }
            [self addSubview:viewMiddleLine];
        }
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectZero];
        lblText.textColor = [Mocha_Util getColor:@"666666"];
        lblText.font = [UIFont systemFontOfSize:14.0];
        lblText.text = NCS([dicRow objectForKey:@"productName"]);
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
        btnCate.accessibilityLabel = lblText.text;
        [viewCate addSubview:btnCate];
        [self insertSubview:viewCate atIndex:0];
    }
    if (([arrCate count]%3) != 0) {
        viewLineBottom.frame = CGRectMake(viewLineBottom.frame.origin.x, self.frame.size.height,  (viewBGWidth/3.0 *([arrCate count]%3)), 1.0);
        UIView *viewLineBottomMore = [[UIView alloc] initWithFrame:CGRectMake(viewLineBottom.frame.origin.x + viewLineBottom.frame.size.width +1, viewLineBottom.frame.origin.y - kHEIGHTFPC, viewBGWidth - (viewBGWidth/3.0) *([arrCate count]%3), 1.0)];
        viewLineBottomMore.backgroundColor  = [Mocha_Util getColor:@"DDDDDD"];
        [self addSubview:viewLineBottomMore];
    }
    else {
        viewLineBottom.frame = CGRectMake(viewLineBottom.frame.origin.x, self.frame.size.height,  viewBGWidth +1, 1.0);
    }
    
    viewLineVer01.frame = CGRectMake(0.0, 0.0, 1.0, self.frame.size.height);
    if (([arrCate count]%3) != 0) {
        NSInteger line02 = 0;
        if ([arrCate count]%3 > 0) {
            line02 = 1;
        }
        viewLineVer02.frame = CGRectMake(viewBGWidth/3 * 1 , 0.0, 1.0, kHEIGHTFPC *([arrCate count]/3 + line02));
        NSInteger line03 = 0;
        if ([arrCate count]%3 > 1) {
            line03 = 1;
        }
        viewLineVer03.frame = CGRectMake(viewBGWidth/3 * 2 , 0.0, 1.0, kHEIGHTFPC *([arrCate count]/3 + line03));
        UIView *viewLineMiddleMore = [[UIView alloc] initWithFrame:CGRectMake((viewBGWidth/3) * ([arrCate count]%3) , self.frame.size.height -  kHEIGHTFPC   , 1.0, kHEIGHTFPC + 1.0)];
        viewLineMiddleMore.backgroundColor  = [Mocha_Util getColor:@"DDDDDD"];
        [self addSubview:viewLineMiddleMore];
    }
    else {
        viewLineVer02.frame = CGRectMake(viewBGWidth/3 * 1 , 0.0, 1.0, self.frame.size.height);
        viewLineVer03.frame = CGRectMake(viewBGWidth/3 * 2 , 0.0, 1.0, self.frame.size.height);
    }
    viewLineVer04.frame = CGRectMake(viewBGWidth, 0.0, 1.0, kHEIGHTFPC * ([arrCate count]/3));
    [self setCateIndex:index];
}

//FPC_S 용
-(void) setCellInfoNDrawData:(NSArray*)arrCate seletedIndex:(NSInteger)index andItemViewColorOn:(NSString *)strViewColorOn andItemViewColorOff:(NSString *)strViewColorOff andLineColor:(NSString *)strLineColor {
    strCateBgColorOn = strViewColorOn;
    strCateBgColorOff = strViewColorOff;
    strCateLineColor = strLineColor;
    idxSeleted = index;
    arrCateInfo = arrCate;
    CGFloat viewBGWidth = APPFULLWIDTH - 20.0;
    for (NSInteger i = 0 ; i<[arrCate count]; i++) {
        NSDictionary *dicRow = [arrCate objectAtIndex:i];
        UIView *viewCate = [[UIView alloc] initWithFrame:CGRectZero];
        viewCate.frame = CGRectMake(0 + (i%3)*(viewBGWidth/3), (kHEIGHTFPC_S * (i/3)), viewBGWidth /3.0 +1, kHEIGHTFPC_S+1);
        viewCate.backgroundColor = [Mocha_Util getColor:strViewColorOff];
        if ([arrCate count] >= i + 1 && i%3 == 0) {
            UIView *viewMiddleLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, viewCate.frame.origin.y , viewBGWidth, 1.0)];
            viewMiddleLine.backgroundColor = [Mocha_Util getColor:strLineColor];
            [self addSubview:viewMiddleLine];
        }
        
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectZero];
        lblText.textColor = [Mocha_Util getColor:@"444444"];
        lblText.font = [UIFont systemFontOfSize:14.0];
        lblText.text = NCS([dicRow objectForKey:@"productName"]);
        lblText.lineBreakMode = NSLineBreakByClipping;
        lblText.backgroundColor = [UIColor clearColor];
        lblText.frame = CGRectMake(0.0, 0.0, viewCate.frame.size.width, viewCate.frame.size.height);
        lblText.textAlignment = NSTextAlignmentCenter;
        lblText.tag = 77;
        [viewCate addSubview:lblText];
        viewCate.tag = 200 + i;
        UIButton *btnCate = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCate.frame = CGRectMake(0.0, 0.0, viewCate.frame.size.width, viewCate.frame.size.height);
        btnCate.tag = i;
        [btnCate addTarget:self action:@selector(onBtnCate:) forControlEvents:UIControlEventTouchUpInside];
        btnCate.accessibilityLabel = lblText.text;
        [viewCate addSubview:btnCate];
        [self insertSubview:viewCate atIndex:0];
    }
    
    if (([arrCate count]%3) != 0) {
        viewLineBottom.frame = CGRectMake(viewLineBottom.frame.origin.x, self.frame.size.height,  (viewBGWidth/3.0 *([arrCate count]%3)), 1.0);
        UIView *viewLineBottomMore = [[UIView alloc] initWithFrame:CGRectMake(viewLineBottom.frame.origin.x + viewLineBottom.frame.size.width +1, viewLineBottom.frame.origin.y - kHEIGHTFPC_S, viewBGWidth - (viewBGWidth/3.0) *([arrCate count]%3), 1.0)];
        viewLineBottomMore.backgroundColor = [Mocha_Util getColor:strLineColor];
        [self addSubview:viewLineBottomMore];
    }
    else {
        viewLineBottom.frame = CGRectMake(viewLineBottom.frame.origin.x, self.frame.size.height,  viewBGWidth +1, 1.0);
    }
    viewLineVer01.frame = CGRectMake(0.0, 0.0, 1.0, self.frame.size.height);
    if (([arrCate count]%3) != 0) {
        NSInteger line02 = 0;
        if ([arrCate count]%3 > 0) {
            line02 = 1;
        }
        viewLineVer02.frame = CGRectMake(viewBGWidth/3 * 1 , 0.0, 1.0, kHEIGHTFPC_S *([arrCate count]/3 + line02));
        NSInteger line03 = 0;
        if ([arrCate count]%3 > 1) {
            line03 = 1;
        }
        viewLineVer03.frame = CGRectMake(viewBGWidth/3 * 2 , 0.0, 1.0, kHEIGHTFPC_S *([arrCate count]/3 + line03));
        UIView *viewLineMiddleMore = [[UIView alloc] initWithFrame:CGRectMake((viewBGWidth/3) * ([arrCate count]%3) , self.frame.size.height -  kHEIGHTFPC_S   , 1.0, kHEIGHTFPC_S + 1.0)];
        viewLineMiddleMore.backgroundColor  = [Mocha_Util getColor:strLineColor];
        [self addSubview:viewLineMiddleMore];
    }
    else {
        viewLineVer02.frame = CGRectMake(viewBGWidth/3 * 1 , 0.0, 1.0, self.frame.size.height);
        viewLineVer03.frame = CGRectMake(viewBGWidth/3 * 2 , 0.0, 1.0, self.frame.size.height);
    }
    viewLineVer04.frame = CGRectMake(viewBGWidth, 0.0, 1.0, kHEIGHTFPC_S * ([arrCate count]/3));
    viewLineVer01.backgroundColor = [Mocha_Util getColor:strLineColor];
    viewLineVer02.backgroundColor = [Mocha_Util getColor:strLineColor];
    viewLineVer03.backgroundColor = [Mocha_Util getColor:strLineColor];
    viewLineVer04.backgroundColor = [Mocha_Util getColor:strLineColor];
    viewLineBottom.backgroundColor = [Mocha_Util getColor:strLineColor];
    [self setCateIndex:index];
}

-(void)onBtnCate:(id)sender {
    NSInteger tag = [((UIButton *)sender) tag];
    if (tag == idxSeleted) {
        return;
    }
    
    if ([targetFPC respondsToSelector:@selector(onBtnCateTag:withInfoDic:)]) {
        [targetFPC onBtnCateTag:tag withInfoDic:[arrCateInfo objectAtIndex:tag]];
        if([[[arrCateInfo objectAtIndex:tag] objectForKey:@"wiseLog"] isKindOfClass:[NSNull class]] == NO && [[[arrCateInfo objectAtIndex:tag] objectForKey:@"wiseLog"] hasPrefix:@"http://"]) {
            [ApplicationDelegate wiseAPPLogRequest:[[arrCateInfo objectAtIndex:tag] objectForKey:@"wiseLog"]];
        }
    }
}

-(void)setCateIndex:(NSInteger)indexCategory {
    for (int i=0; i<[[self subviews] count]; i++) {
        if ([[[self subviews] objectAtIndex:i] isKindOfClass:[UIView class]]) {
            UIView *viewCate = (UIView *)[[self subviews] objectAtIndex:i];
            if ([viewCate tag] >= 200) {
                if ([viewCate tag]==indexCategory + 200) {
                    [self setViewCateStatus:viewCate andSelect:YES];
                }
                else {
                    [self setViewCateStatus:viewCate andSelect:NO];
                }
            }
        }
    }
}

-(void)setViewCateStatus:(UIView*)targetView andSelect:(BOOL)isSelected {
    targetView.backgroundColor = [UIColor whiteColor];
    if (strCateBgColorOn != nil && strCateBgColorOff != nil && strCateLineColor != nil) {
        UIColor *borderColor = [Mocha_Util getColor:strCateLineColor];
        [targetView.layer setMasksToBounds:NO];
        targetView.layer.shadowOffset = CGSizeMake(0, 0);
        targetView.layer.shadowRadius = 0.0;
        targetView.layer.borderColor = borderColor.CGColor;
        targetView.layer.borderWidth = 1;
        UILabel *lblText = [targetView viewWithTag:77];
        if (isSelected) {
            [self bringSubviewToFront:targetView];
            targetView.backgroundColor = [Mocha_Util getColor:strCateBgColorOn];
            lblText.font = [UIFont boldSystemFontOfSize:15.0];
        }
        else {
            [self insertSubview:targetView atIndex:0];
            targetView.backgroundColor = [Mocha_Util getColor:strCateBgColorOff];
            lblText.font = [UIFont systemFontOfSize:14.0];
        }
        
    }
    else {
        UIColor *borderColor = (isSelected)?[Mocha_Util getColor:@"86CF00"]:[Mocha_Util getColor:@"FFFFFF"];
        [targetView.layer setMasksToBounds:NO];
        targetView.layer.shadowOffset = CGSizeMake(0, 0);
        targetView.layer.shadowRadius = 0.0;
        targetView.layer.borderColor = borderColor.CGColor;
        targetView.layer.borderWidth = 1;
        if (isSelected) {
            [self bringSubviewToFront:targetView];
        }
        else {
            [self insertSubview:targetView atIndex:0];
        }
    }
    
    for (id view in targetView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imgCrown = (UIImageView *)view;
            imgCrown.highlighted = isSelected;
        }
        else if ([view isKindOfClass:[UILabel class]]) {
            UILabel *lblText = (UILabel *)view;
            if (isSelected) {
                lblText.textColor = [Mocha_Util getColor:@"111111"];
                lblText.font = [UIFont boldSystemFontOfSize:14.0];
            }
            else {
                lblText.textColor = [Mocha_Util getColor:@"666666"];
                lblText.font = [UIFont systemFontOfSize:14.0];
            }
        }
    }
}


@end
