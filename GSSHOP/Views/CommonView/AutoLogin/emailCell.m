//
//  emailCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 5. 10..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "emailCell.h"

@implementation emailCell

@synthesize idText,domainText,background,checkimg;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}


- (void)prepareForReuse {
    
    [super prepareForReuse];
    self.idText.text = @"";
    self.domainText.text = @"";
    self.checkimg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
        self.background.backgroundColor = [UIColor getColor:@"00aebd" alpha:0.06 defaultColor:UIColor.clearColor];
        self.checkimg.hidden = NO;
    }
    else{
        self.background.backgroundColor = [UIColor whiteColor];
        self.checkimg.hidden = YES;
    }
}




@end
