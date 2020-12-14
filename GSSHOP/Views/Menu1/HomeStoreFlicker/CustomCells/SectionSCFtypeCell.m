//
//  SectionSCFtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 20..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionSCFtypeCell.h"
#import "AppDelegate.h"
#import "NSTFCListTBViewController.h"

@implementation SectionSCFtypeCell
@synthesize view_Default;
@synthesize arrSCF;
@synthesize target;

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
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, kHEIGHTHF);
    
    for (UIView *view in view_Default.subviews) {
        
        [view removeFromSuperview];
    }
    
    
}

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index{
    //[35]	(null)	@"productName" : @"캐주얼"
    self.backgroundColor = [UIColor clearColor];
    arrSCF = [rowinfo objectForKey:@"subProductList"];
    
    NSInteger limit = ([arrSCF count]<kMaxCountHF)?[arrSCF count]:kMaxCountHF;
    
    CGFloat heightViewDefault = kHEIGHTHF * (limit/kRowPerCountHF + ((limit%kRowPerCountHF>0)?1.0:0.0));
    
    
    SectionHFtypeSubView *viewHF = [[[NSBundle mainBundle] loadNibNamed:@"SectionHFtypeSubView" owner:self options:nil] firstObject];
    viewHF.targetHF = self;
    viewHF.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH - 20.0,heightViewDefault);
    viewHF.strHighlightColor = @"F26630";
    
    [viewHF setCellInfoNDrawData:arrSCF seletedIndex:index];
    
    //NSLog(@"tagResulttagResult = %@",tagResult);
    
    
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, heightViewDefault);
    
    [view_Default addSubview:viewHF];
    
    
    
}

-(void)onBtnHashTags:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic{
    
    //NSLog(@"[arrFPC objectAtIndex:btnTag] = %@",[arrHF objectAtIndex:btnTag]);
    
    [target onBtnSCFTag:[arrSCF objectAtIndex:btnTag] andCnum:[NSNumber numberWithInt:(int)btnTag] withCallType:@"SCF"];
    
}


@end
