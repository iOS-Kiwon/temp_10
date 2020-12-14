//
//  SectionTCFtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionTCFtypeCell.h"
#import "AppDelegate.h"
#import "TDCLiveTBViewController.h"

@implementation SectionTCFtypeCell
@synthesize target;
@synthesize view_Default;
@synthesize lblTitle;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self clearCateGoryView];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)clearCateGoryView{
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, kHEIGHTFPC * 2);
    
    for (UIView *view in view_Default.subviews) {
        
        [view removeFromSuperview];
    }
}


-(void)onBtnCateTag:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic {
    
    if ([target respondsToSelector:@selector(selectLiveBestCategory:)]) {
        [target selectLiveBestCategory:btnTag];
    }
    
    
}

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index{
    self.backgroundColor = [UIColor clearColor];
    [self clearCateGoryView];
    
    NSLog(@"[rowinfo objectForKey:@productName] = %@",[rowinfo objectForKey:@"productName"]);
    
    if ([[rowinfo objectForKey:@"productName"] isKindOfClass:[NSNull class]] == NO && [NCS([rowinfo objectForKey:@"productName"]) length] > 0) {
        lblTitle.text = [rowinfo objectForKey:@"productName"];
    }else{
        lblTitle.text = @"TV쇼핑 추천상품";
    }
    
    
    
    NSArray *arrFPC = [rowinfo objectForKey:@"subProductList"];
    
    CGFloat heightViewDefault = kHEIGHTFPC * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));

    
    SectionFPCtypeSubview *viewFPC = [[[NSBundle mainBundle] loadNibNamed:@"SectionFPCtypeSubview" owner:self options:nil] firstObject];
    viewFPC.targetFPC = self;
    viewFPC.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH - 20.0,heightViewDefault);
    [viewFPC setCellInfoNDrawData:arrFPC seletedIndex:index];
    
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, heightViewDefault);
    
    [view_Default addSubview:viewFPC];    
}




@end
