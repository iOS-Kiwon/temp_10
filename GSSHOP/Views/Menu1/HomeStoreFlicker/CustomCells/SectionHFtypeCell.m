//
//  SectionHFtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 1..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionHFtypeCell.h"
#import "AppDelegate.h"
#import "NTCListTBViewController.h"

@implementation SectionHFtypeCell

@synthesize view_Default;
@synthesize arrHF;
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

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index andSearchResult:(NSDictionary *)tagResult{
    //[35]	(null)	@"productName" : @"캐주얼"
    self.backgroundColor = [UIColor clearColor];
    arrHF = [rowinfo objectForKey:@"subProductList"];
    
    NSInteger limit = ([arrHF count]<kMaxCountHF)?[arrHF count]:kMaxCountHF;
    
    CGFloat heightViewDefault = kHEIGHTHF * (limit/kRowPerCountHF + ((limit%kRowPerCountHF>0)?1.0:0.0));
    
    
    SectionHFtypeSubView *viewHF = [[[NSBundle mainBundle] loadNibNamed:@"SectionHFtypeSubView" owner:self options:nil] firstObject];
    viewHF.targetHF = self;
    viewHF.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH - 20.0,heightViewDefault);
    [viewHF setCellInfoNDrawData:arrHF seletedIndex:index];
    
    //NSLog(@"tagResulttagResult = %@",tagResult);
    
    if ([tagResult count] > 0) {
        
        NSString *strWord = [NSString stringWithFormat:@"#%@",NCS([tagResult objectForKey:kHFSEARCHTAG])];
        NSString *strCount = NCS([tagResult objectForKey:kHFSEARCHCOUNT]);
        
        CGSize sizeWord = [strWord MochaSizeWithFont: [UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(200.0, 16.0) lineBreakMode:NSLineBreakByWordWrapping];
        CGSize sizeCount = [strCount MochaSizeWithFont: [UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(100.0, 100.0) lineBreakMode:NSLineBreakByWordWrapping];
        
        UIView *viewSearchResult = [[UIView alloc] initWithFrame:CGRectMake(0.0, heightViewDefault, APPFULLWIDTH - 20.0, 32.0)];
        viewSearchResult.backgroundColor = [UIColor clearColor];
        
        UILabel *lblWord = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 12.0, sizeWord.width, 16.0)];
        lblWord.font = [UIFont boldSystemFontOfSize:15];
        lblWord.textColor = [Mocha_Util getColor:@"F7464E"];
        lblWord.backgroundColor = [UIColor clearColor];
        lblWord.text = strWord;
        
        
        UILabel *lblCount = [[UILabel alloc] initWithFrame:CGRectMake(lblWord.frame.origin.x + lblWord.frame.size.width + 8.0, 12.0, sizeCount.width, 16.0)];
        lblCount.font = [UIFont boldSystemFontOfSize:14];
        lblCount.textColor = [Mocha_Util getColor:@"444444"];
        lblCount.backgroundColor = [UIColor clearColor];
        lblCount.text = strCount;
        
        UILabel *lblNalBang = [[UILabel alloc] initWithFrame:CGRectMake(lblCount.frame.origin.x + lblCount.frame.size.width, 12.0,140.0 , 16.0)];
        lblNalBang.font = [UIFont systemFontOfSize:14];
        lblNalBang.textColor = [Mocha_Util getColor:@"444444"];
        lblNalBang.backgroundColor = [UIColor clearColor];
        lblNalBang.text = GSSLocalizedString(@"home_nalbang_movie_count_text");
        
        
        
        [viewSearchResult addSubview:lblWord];
        [viewSearchResult addSubview:lblCount];
        [viewSearchResult addSubview:lblNalBang];
        
        [view_Default addSubview:viewSearchResult];
        
        
        heightViewDefault = heightViewDefault +32;
    }
    
    view_Default.frame = CGRectMake(view_Default.frame.origin.x, view_Default.frame.origin.y, APPFULLWIDTH - 20.0, heightViewDefault);
    
    [view_Default addSubview:viewHF];
    
    
    
}

-(void)onBtnHashTags:(NSInteger)btnTag withInfoDic:(NSDictionary *)dic{
    
    //NSLog(@"[arrFPC objectAtIndex:btnTag] = %@",[arrHF objectAtIndex:btnTag]);
    
    [target onBtnHFTag:[arrHF objectAtIndex:btnTag] andCnum:[NSNumber numberWithInt:(int)btnTag] withCallType:@"HF"];
    
}


@end
