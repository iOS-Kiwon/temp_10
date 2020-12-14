//
//  NTCBroadCastHeaderCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "AppDelegate.h"
#import "NTCBroadCastHeaderCell.h"
#import "NTCBroadCastHeaderView.h"


@implementation NTCBroadCastHeaderCell

@synthesize nalHeaderView;

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
    [self.nalHeaderView removeFromSuperview];
    self.nalHeaderView = nil;
}

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfoDic{

    if (self.nalHeaderView == nil) {
        self.nalHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NTCBroadCastHeaderView" owner:self options:nil] firstObject];
        self.nalHeaderView.target = self;
    }
    
    self.nalHeaderView.frame = CGRectMake(0.0 , 0.0, APPFULLWIDTH,self.frame.size.height - 9.0);
   
    [self.nalHeaderView setCellInfoNDrawData:rowinfoDic];
    
    [self addSubview:self.nalHeaderView];

}

@end
