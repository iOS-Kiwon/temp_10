//
//  SectionFPCtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionFPCtypeCell.h"
#import "AppDelegate.h"
#import "SectionFPC_SubCategoryView.h"

@implementation SectionFPCtypeCell
@synthesize view_Default;
@synthesize arrFPC;
@synthesize target;
@synthesize viewBottomLine;
@synthesize sectionViewTarget;
@synthesize viewFPC_SubCate;
@synthesize viewBackground;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.viewBackground.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    if (self.viewFPC_SubCate != nil) {
        [self.viewFPC_SubCate removeFromSuperview];
        self.viewFPC_SubCate = nil;
    }
    
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, kHEIGHTFPC);
    
    viewBottomLine.hidden = YES;
    
    for (UIView *view in view_Default.subviews) {
        
        [view removeFromSuperview];
    }
    
    
}

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index{
    self.backgroundColor = [UIColor clearColor];
    self.viewBackground.hidden = YES;
    arrFPC = [rowinfo objectForKey:@"subProductList"];
    
    CGFloat heightViewDefault = kHEIGHTFPC * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));
    
    NSLog(@"heightFPC = %f",heightViewDefault);
    
    NSLog(@"[arrFPC count] = %lu",(long)[arrFPC count]);
    
    SectionFPCtypeSubview *viewFPC = [[[NSBundle mainBundle] loadNibNamed:@"SectionFPCtypeSubview" owner:self options:nil] firstObject];
    viewFPC.targetFPC = self;
    viewFPC.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH - 20.0,heightViewDefault);
    [viewFPC setCellInfoNDrawData:arrFPC seletedIndex:index];
    
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, heightViewDefault);
    
    [view_Default addSubview:viewFPC];
    
    
    self.viewBackground.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, view_Default.frame.origin.y + view_Default.frame.size.height);
    
    
    NSLog(@"view_Default = %@",view_Default);
    NSLog(@"view_Default.subviews = %@",view_Default.subviews);
    
}

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index andSeletedSubIndex:(NSInteger)subIndex andBgColor:(NSString *)strBgColor andItemViewColorOn:(NSString *)strViewColorOn andItemViewColorOff:(NSString *)strViewColorOff andLineColor:(NSString *)strLineColor{
    
    viewBottomLine.hidden = NO;

    self.viewBackground.backgroundColor = [Mocha_Util getColor:strBgColor];
    
    arrFPC = [rowinfo objectForKey:@"subProductList"];
    
    CGFloat heightViewDefault = kHEIGHTFPC_S * ([arrFPC count]/3 + (([arrFPC count]%3>0)?1.0:0.0));
    
    NSLog(@"heightFPC = %f",heightViewDefault);
    
    NSLog(@"[arrFPC count] = %lu",(long)[arrFPC count]);
    
    SectionFPCtypeSubview *viewFPC = [[[NSBundle mainBundle] loadNibNamed:@"SectionFPCtypeSubview" owner:self options:nil] firstObject];
    viewFPC.targetFPC = self;
    viewFPC.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH - 20.0,heightViewDefault);
    //[viewFPC setCellInfoNDrawData:arrFPC seletedIndex:index isBest:YES];
    
    [viewFPC setCellInfoNDrawData:arrFPC seletedIndex:index andItemViewColorOn:strViewColorOn andItemViewColorOff:strViewColorOff andLineColor:strLineColor];
    
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, heightViewDefault);
    
    [view_Default addSubview:viewFPC];
    
    
    
    BOOL isValidSubSubList = NO;
    NSString *strSubSubText = nil;
    
    //베스트 매장의 대분류 아래의 서브 매장의 데이터와 ,promotionName 텍스트가 유효한지 검증
    if (NCA(arrFPC) && NCO([arrFPC objectAtIndex:index]) && NCA([[arrFPC objectAtIndex:index] objectForKey:@"subProductList"])) {
        
        NSArray *arrSubSubList = [[arrFPC objectAtIndex:index] objectForKey:@"subProductList"];
        
        if ([arrSubSubList count] > subIndex) {
            
            if (NCO([arrSubSubList objectAtIndex:subIndex]) && [NCS([(NSDictionary *)[arrSubSubList objectAtIndex:subIndex] objectForKey:@"promotionName"]) length] > 0) {
                
                strSubSubText = NCS([(NSDictionary *)[arrSubSubList objectAtIndex:subIndex] objectForKey:@"promotionName"]);
                
                isValidSubSubList = YES;
            }
        }
        
        
    }
    
    if (isValidSubSubList) {
        if (self.viewFPC_SubCate == nil) {
            self.viewFPC_SubCate = [[[NSBundle mainBundle] loadNibNamed:@"SectionFPC_SubCategoryView" owner:self options:nil] firstObject];
        }
        
        self.viewFPC_SubCate.frame = CGRectMake(0.0, view_Default.frame.origin.y + view_Default.frame.size.height, APPFULLWIDTH,55.0);
        self.viewFPC_SubCate.target = self.sectionViewTarget;
        [self.viewFPC_SubCate setCellInfoLabelText:strSubSubText];
        
        [self addSubview:viewFPC_SubCate];
        
        viewBottomLine.hidden = YES;
        
        NSLog(@"self.viewFPC_SubCate.frame = %@",self.viewFPC_SubCate);
        
        self.viewBackground.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, view_Default.frame.origin.y + view_Default.frame.size.height + 55.0);
        
    }else{
        if (self.viewFPC_SubCate != nil) {
            [self.viewFPC_SubCate removeFromSuperview];
            self.viewFPC_SubCate = nil;
        }
        self.viewBackground.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, view_Default.frame.origin.y + view_Default.frame.size.height + 11.0);
    }
    
    
    
    
    NSLog(@"view_Default = %@",view_Default);
    NSLog(@"view_Default.subviews = %@",view_Default.subviews);
    
}

-(void)onBtnCateTag:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic {
    
    NSLog(@"[arrFPC objectAtIndex:btnTag] = %@",[arrFPC objectAtIndex:btnTag]);
    
    [target onBtnFPCCate:[arrFPC objectAtIndex:btnTag] andCnum:[NSNumber numberWithInt:(int)btnTag] withCallType:@"FPC"];
    
}

-(void)modifyTopForDFCLIST{
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, 0.0, APPFULLWIDTH - 20.0, view_Default.frame.size.height);
}
@end
