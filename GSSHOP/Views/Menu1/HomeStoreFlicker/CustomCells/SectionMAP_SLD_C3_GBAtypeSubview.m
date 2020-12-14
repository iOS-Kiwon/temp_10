//
//  SectionMAP_SLD_C3_GBAtypeSubview.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 14..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_SLD_C3_GBAtypeSubview.h"

@implementation SectionMAP_SLD_C3_GBAtypeSubview
@synthesize price,priceWon,productImg,noImg;


-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
}

-(void) prepareForReuse {
    self.productImg.image = nil;
    self.priceWon.text = @"";
    self.price.text = @"";
    self.productName.text = @"";
    self.clickButton.accessibilityLabel = @"";
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo {
    if(NCO(rowinfo) && ![NCS([rowinfo objectForKey:@"imageUrl"]) isEqualToString:@""]) {
        self.row_dic = rowinfo;
        [self setImageView:self.productImg withURL:[self.row_dic objectForKey:@"imageUrl"]];
        self.productName.text = NCS([rowinfo objectForKey:@"productName"]);
        self.price.text = [NSString stringWithFormat:@"%@",NCS([rowinfo objectForKey:@"salePrice"])];
        self.priceWon.text = [NSString stringWithFormat:@"%@",NCS([rowinfo objectForKey:@"exposePriceText"])];
        self.clickButton.accessibilityLabel = [NSString stringWithFormat:@"%@ %@%@",self.productName.text, self.price.text, self.priceWon.text];
        [self layoutIfNeeded];
    }
}


-(void) setImageView:(UIImageView *)imgView withURL:(NSString *)imageURL {
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil  && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache) {
                    imgView.image = fetchedImage;
                }
                else {
                    imgView.alpha = 0;
                    imgView.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         imgView.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                     }];
                }
            });
        }
    }];
}

@end
