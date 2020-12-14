//
//  SectionBSSStypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 14..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionBIXStypeCell.h"
#import "AppDelegate.h"

@implementation SectionBIXStypeCell

@synthesize thumbnailImage = thumbnailImage_;

@synthesize loadingImageURLString = loadingImageURLString_;
@synthesize imageLoadingOperation = imageLoadingOperation_;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}


-(void) prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImage.image = nil;
    self.loadingImageURLString = nil;
    self.backgroundColor = [UIColor clearColor];
    self.accessibilityLabel = @"";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    self.loadingImageURLString =  NCS([rowinfoArr objectForKey:@"imageUrl"]);
    self.accessibilityLabel = NCS([rowinfoArr objectForKey:@"productName"]);

    if([self.loadingImageURLString length] > 0) {
        [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                      self.thumbnailImage.image = fetchedImage;
                    }
                    else {
                      self.thumbnailImage.alpha = 0;
                      self.thumbnailImage.image = fetchedImage;
                      // nami0342 - main thread
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           self.thumbnailImage.alpha = 1;
                                       }
                                       completion:^(BOOL finished) {
                                       }];
                      });
                  }
                });
            }
      }];
    }
    else {
    }
}
@end
