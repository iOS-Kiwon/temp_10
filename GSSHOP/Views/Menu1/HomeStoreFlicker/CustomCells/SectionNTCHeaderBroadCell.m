//
//  SectionNTCHeaderBroadCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionNTCHeaderBroadCell.h"

@implementation SectionNTCHeaderBroadCell

@synthesize nalHeaderView;
@synthesize target;
@synthesize isShowTop;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    [self.nalHeaderView removeFromSuperview];
    self.nalHeaderView = nil;
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo cellHeight:(CGFloat)height{
    
    NSLog(@"");
    
    self.backgroundColor = [UIColor clearColor];
    
    if (self.nalHeaderView == nil) {
        self.nalHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NTCBroadCastHeaderView" owner:self options:nil] firstObject];
        self.nalHeaderView.target = target;
    }
    
    self.nalHeaderView.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, height);
    
    [self.nalHeaderView showViewTop:isShowTop];
    
    [self addSubview:self.nalHeaderView];
    
    [self.nalHeaderView setCellInfoNDrawData:rowinfo];
}


@end
