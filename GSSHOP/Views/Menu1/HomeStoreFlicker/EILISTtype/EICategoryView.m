//
//  EICategoryView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 26..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "EICategoryView.h"
#import "EIListPSCViewController.h"

@implementation EICategoryView
@synthesize target;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, APPFULLWIDTH,self.frame.size.height);
    viewBG.frame = CGRectMake(8, 0, APPFULLWIDTH - 16.0,self.frame.size.height);
    
    
}

-(void) setCellInfoNDrawData:(NSArray*)arrCate seletedIndex:(NSInteger)index{
    
    NSLog(@"self.arrCatearrCate = %@",arrCate);
    
    BOOL isBeforeSeleted = NO;
    
    CGFloat viewBGWidth = APPFULLWIDTH - 16.0;
    
    for (NSInteger i = 0 ; i<[arrCate count]; i++) {
        
        NSDictionary *dicRow = [arrCate objectAtIndex:i];
        
        
        UIButton *btnCate = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i != index) {
            
            CGFloat xPostionModifier = (isBeforeSeleted)?0.0:1.0;
            
            btnCate.frame = CGRectMake(0 + i*(viewBGWidth/[arrCate count]) + xPostionModifier , 8.0, viewBGWidth /[arrCate count] - 1.0, 28.0);
            
            
            
        }else{
            isBeforeSeleted = YES;
            btnCate.frame = CGRectMake(0 + i*(viewBGWidth/[arrCate count]), 8.0, viewBGWidth /[arrCate count], 28.0);
        }
        
        
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
        
        btnCate.tag = i;
        [btnCate addTarget:self action:@selector(onBtnCate:) forControlEvents:UIControlEventTouchUpInside];
        
        [viewBG addSubview:btnCate];
        
    }
    
    [self setCateIndex:index];
}


-(void)onBtnCate:(id)sender {
    
    NSLog(@"target = %@",target);
    
    NSLog(@"(int)[sender tag] = %d",(int)[((UIButton *)sender) tag]);
    
    if ([(EIListPSCViewController*)target respondsToSelector:@selector(onBtnEICategory:)]) {
        [(EIListPSCViewController*)target performSelector:@selector(onBtnEICategory:) withObject:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] ];
    }
    
    
    
}

-(void)setCateIndex:(NSInteger)indexCategory{
    for (int i=0; i<[[viewBG subviews] count]; i++) {
        UIButton *btnCate = (UIButton *)[[viewBG subviews] objectAtIndex:i];
        if ([btnCate tag]==indexCategory) {
            btnCate.selected = YES;
            
        }

    }
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

@end
