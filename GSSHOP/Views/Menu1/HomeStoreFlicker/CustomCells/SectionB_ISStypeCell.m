//
//  SectionB_ISStypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 6. 1..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_ISStypeCell.h"
#import "Common_Util.h"
#import "AppDelegate.h"

@implementation SectionB_ISStypeCell
@synthesize imgBanner,borderView,cellClick,infoDic;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


-(void)prepareForReuse{
    [super prepareForReuse];
    imgBanner.image = nil;
    self.cellClick.accessibilityLabel = @"";
}


- (IBAction)onClick:(id)sender {
    
    [self.target dctypetouchEventTBCell:self.infoDic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"B_ISS"];
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    self.backgroundColor = [UIColor clearColor];
    
    self.infoDic = rowinfo;
     self.cellClick.accessibilityLabel = NCS([self.infoDic objectForKey:@"productName"]);
    [self.borderView.layer setMasksToBounds:NO];
    self.borderView.layer.shadowOffset = CGSizeMake(0, 0);
    self.borderView.layer.shadowRadius = 0.0;
    self.borderView.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    self.borderView.layer.borderWidth = 1;

    NSString *imageURL = NCS([self.infoDic objectForKey:@"imageUrl"]);
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
