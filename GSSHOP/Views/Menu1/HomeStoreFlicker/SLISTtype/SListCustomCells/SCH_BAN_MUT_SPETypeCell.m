//
//  SCH_BAN_MUT_SPETypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 24..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_BAN_MUT_SPETypeCell.h"
#import "SListTBViewController.h"

@implementation SCH_BAN_MUT_SPETypeCell
@synthesize imgBanner,target;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgBanner.image = nil;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imgBanner.image = nil;

}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr{
    
    if(NCO(rowinfoArr)){
        
        celldic = rowinfoArr;
        
        if( [NCS([celldic objectForKey:@"specialPgmYn"]) isEqualToString:@"Y"] && NCO([celldic objectForKey:@"specialPgmInfo"])==YES) // 스패셜프로그램은 베너 노출
        {
            self.imgBanner.hidden = NO;
            
            NSString *imageURL = NCS([[celldic objectForKey:@"specialPgmInfo"] objectForKey:@"imageUrl"]);
            [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [imageURL isEqualToString:strInputURL])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache)
                    {
                        self.imgBanner.image = fetchedImage;
                    }
                    else
                    {
                        self.imgBanner.alpha = 0;
                        self.imgBanner.image = fetchedImage;
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             
                                             self.imgBanner.alpha = 1;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    }

                    });
                                    }
            }];
        }
    }
}

- (IBAction)bannerClick:(id)sender {
    if(self.target)
    {
        if ([self.target respondsToSelector:@selector(touchEventTBCellJustLinkStr:)] && NCO([celldic objectForKey:@"specialPgmInfo"]) == YES && [NCS([[celldic objectForKey:@"specialPgmInfo"] objectForKey:@"linkUrl"]) hasPrefix:@"http"]) {
            
            [self.target touchEventTBCellJustLinkStr:NCS([[celldic objectForKey:@"specialPgmInfo"] objectForKey:@"linkUrl"])];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
