//
//  SectionNTCHeaderBannerCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionNTCHeaderBannerCell.h"
#import "AppDelegate.h"
#import "Common_Util.h"

@implementation SectionNTCHeaderBannerCell

@synthesize imgBanner;
@synthesize btnBanner;
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
    imgBanner.image = nil;
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    self.backgroundColor = [UIColor clearColor];
    
    dicRow = rowinfo;
    
    [Common_Util setImageView:imgBanner withStrURL:[rowinfo objectForKey:@"imageUrl"]];
        
}

-(IBAction)onBtnBanner:(id)sender{
    if ([target respondsToSelector:@selector(touchEventTBCellJustLinkStr:)]) {
        [target touchEventTBCellJustLinkStr:[dicRow objectForKey:@"linkUrl"]];
    }
    
}

@end
