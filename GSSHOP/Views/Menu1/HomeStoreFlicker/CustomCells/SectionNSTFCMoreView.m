//
//  SectionNSTFCMoreView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionNSTFCMoreView.h"
#import "NSTFCListTBViewController.h"

@implementation SectionNSTFCMoreView

@synthesize viewDefault;
@synthesize target;
@synthesize section;
@synthesize viewBtn;
@synthesize viewLineTop;
@synthesize viewLineBottom;
@synthesize viewNoData;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, 65.0);
    
    NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
    
    NSLog(@"self.reuseIdentifier = %@",self.reuseIdentifier);
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = YES;
    
    
    self.viewBtn.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewBtn.layer.shadowRadius = 0.0;
    self.viewBtn.layer.cornerRadius = 2.0;
    self.viewBtn.layer.borderColor = [Mocha_Util getColor:@"d9d9d9"].CGColor;
    self.viewBtn.layer.borderWidth = 1.0;
    
    self.viewNoData.hidden = YES;
}


-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.target = nil;
    self.section = 0;
 
    self.viewDefault.hidden = NO;
}

-(void)setMoreModeNalbang:(BOOL)isNalBang{
    if (isNalBang) {
        viewDefault.backgroundColor = [UIColor clearColor];
        viewLineTop.hidden = YES;
        viewLineBottom.hidden = YES;
        viewBtn.hidden = NO;
    }else{
        
        viewDefault.backgroundColor = [UIColor whiteColor];
        viewLineTop.hidden = NO;
        viewLineBottom.hidden = NO;
        viewBtn.hidden = YES;
        
    }
}

-(IBAction)onBtnMore:(id)sender{
    if ([self.target respondsToSelector:@selector(tableViewSectionloadMoreButton:)]) {
        self.viewDefault.hidden = YES;
        [self.target tableViewSectionloadMoreButton:section];
    }
    
}


@end
