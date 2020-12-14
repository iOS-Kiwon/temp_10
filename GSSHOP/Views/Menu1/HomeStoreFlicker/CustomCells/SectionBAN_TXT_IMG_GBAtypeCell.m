//
//  SectionBAN_TXT_IMG_GBAtypeCell.m
//  GSSHOP
//
//  Created by admin on 2018. 2. 7..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_TXT_IMG_GBAtypeCell.h"
#import "SectionTBViewController.h"

@implementation SectionBAN_TXT_IMG_GBAtypeCell
@synthesize adImg, adImgWidth, adImgHeigth, countText, descriptionText;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    self.adImg.image = nil;
    self.countText.text = @"";
    self.descriptionText.text = @"";
}

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfo {
    NSString *countStr = NCS([rowinfo objectForKey:@"productName"]);
    NSString *descriptionStr = NCS([rowinfo objectForKey:@"promotionName"]);
    self.countText.text = countStr;
    self.descriptionText.text = [NSString stringWithFormat:@" %@", descriptionStr];
    
    // 접근성 설정
    if (countStr.length > 0 && descriptionStr.length > 0) {
        self.accessibilityLabel = [NSString stringWithFormat:@"%@ %@",countStr, descriptionStr];
    }
    
//    NSString *imageURL = NCS([rowinfo objectForKey:@"imageUrl"]);
//    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
//        if(error == nil && [imageURL isEqualToString:strInputURL]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(isInCache) {
//                    UIImage *resizeImage = [UIImage imageWithCGImage:fetchedImage.CGImage scale:fetchedImage.scale * 2.0f orientation:fetchedImage.imageOrientation];
//                    self.adImgWidth.constant = resizeImage.size.width;
//                    self.adImgHeigth.constant = resizeImage.size.height;
//                    self.adImg.image = fetchedImage;
//                }
//                else {
//                    self.adImg.alpha = 0;
//                    self.adImg.image = fetchedImage;
//                    [UIView animateWithDuration:0.2f
//                                          delay:0.0f
//                                        options:UIViewAnimationOptionCurveEaseInOut
//                                     animations:^{
//                                         self.adImg.alpha = 1;
//                                     }
//                                     completion:^(BOOL finished) {
//                                     }
//                     ];
//                }
//            });
//        }
//    }];
    
    [self.adImg layoutIfNeeded];
}

@end
