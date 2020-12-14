//
//  SectionMAP_C8_SLD_GBAtypeSubCell.m
//  GSSHOP
//
//  Created by admin on 11/03/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_C8_SLD_GBAtypeSubCell.h"
#import "SectionMAP_C8_SLD_GBAtypeCell.h"

@implementation SectionMAP_C8_SLD_GBAtypeSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
    self.topTextView.text = @"";
    self.topImageView.image = nil;
    self.bottomTextView.text = @"";
    self.bottomImageView.image = nil;
}

-(void) setCellInfoNDrawData:(NSArray*)arrRowInfo {
    if(NCA(arrRowInfo)) {
        self.arrDic = arrRowInfo;
        if(arrRowInfo.count == 1) {
            self.topView.hidden = NO;
            self.bottomView.hidden = YES;
            [self topViewSetting:[arrRowInfo objectAtIndex:0]];
        }
        else if(arrRowInfo.count == 2) {
            self.topView.hidden = NO;
            self.bottomView.hidden = NO;
            [self topViewSetting:[arrRowInfo objectAtIndex:0]];
            [self bottomViewSetting:[arrRowInfo objectAtIndex:1]];            
        }
    }
}


- (void) topViewSetting:(NSDictionary *) dicRowInfo {
    NSString *imageURL = NCS([dicRowInfo objectForKey:@"imageUrl"]);
    self.topBtn.accessibilityLabel = NCS([dicRowInfo objectForKey:@"productName"]);
    self.topTextView.text = NCS([dicRowInfo objectForKey:@"productName"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isInCache) {
                    self.topImageView.image = fetchedImage;
                }
                else {
                    self.topImageView.alpha = 0;
                    self.topImageView.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         self.topImageView.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }
                     ];
                }
            });
        }
    }];
}

- (void) bottomViewSetting:(NSDictionary *) dicRowInfo {
    NSString *imageURL = NCS([dicRowInfo objectForKey:@"imageUrl"]);
    self.bottomBtn.accessibilityLabel = NCS([dicRowInfo objectForKey:@"productName"]);
    self.bottomTextView.text = NCS([dicRowInfo objectForKey:@"productName"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isInCache) {
                    self.bottomImageView.image = fetchedImage;
                }
                else {
                    self.bottomImageView.alpha = 0;
                    self.bottomImageView.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         self.bottomImageView.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }
                     ];
                }
            });
        }
    }];
}


- (IBAction)cateAction:(id)sender {
    NSDictionary *dicRow = [self.arrDic objectAtIndex:[((UIButton *)sender) tag]];
    if ([self.targetCell respondsToSelector:@selector(onBtnMAP_C8_Category:)]) {
        [self.targetCell onBtnMAP_C8_Category:dicRow];
    }
}
@end
