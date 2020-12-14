//
//  SectionB_INStypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_INStypeCell.h"
#import "AppDelegate.h"

@implementation SectionB_INStypeCell
@synthesize imgBanner;
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
    self.accessibilityLabel = @"";
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    self.backgroundColor = [UIColor clearColor];
    NSString *imageURL = NCS([rowinfo objectForKey:@"imageUrl"]);
    self.accessibilityLabel = NCS([rowinfo objectForKey:@"productName"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache)
              {
                  imgBanner.image = fetchedImage;
              }
              else
              {
                  imgBanner.alpha = 0;
                  imgBanner.image = fetchedImage;
                  
                  
                  
                  
                  [UIView animateWithDuration:0.2f
                                        delay:0.0f
                                      options:UIViewAnimationOptionCurveEaseInOut
                                   animations:^{
                                       
                                       imgBanner.alpha = 1;
                                       
                                   }
                                   completion:^(BOOL finished) {
                                       
                                   }];
              }

            });
                      }
      }];
    
    
}

@end
