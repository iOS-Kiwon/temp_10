//
//  BenefitTagView.m
//  GSSHOP
//
//  Created by admin on 2017. 9. 28..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "BenefitTagView.h"

@implementation BenefitTagView

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)dealloc {

}

- (void)setBenefitTag:(NSDictionary*) dicRow {
    
    if (NCA([dicRow objectForKey:@"rwImgList"]) == YES) {
        self.viewBenefit01.hidden = YES;
        self.viewBenefit02.hidden = YES;
        self.viewBenefit03.hidden = YES;
        NSArray *arrBene = [dicRow objectForKey:@"rwImgList"];
        for (NSInteger i=0; i<[arrBene count]; i++) {
            if (i>3) {
                break;
            }
            
            if ([NCS([arrBene objectAtIndex:i]) length] == 0) {
                continue;
            }
            
            NSArray *arrSplit = [NCS([arrBene objectAtIndex:i]) componentsSeparatedByString:@"/"];
            NSArray *arrFileName = [[arrSplit lastObject] componentsSeparatedByString:@"."];
            NSString *strWidth = nil;
            if ([arrFileName count] >= 2) {
                strWidth = [[[arrFileName objectAtIndex:[arrFileName count]-2] componentsSeparatedByString:@"_"] lastObject];
            }
            else {
                continue;
            }
            
            CGFloat widthBenefit = 0.0;
            NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet]; //숫자가 아닌?
            if ([strWidth rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
                // 숫자가 아닌걸 못찾았다
                widthBenefit = (CGFloat)([strWidth integerValue]/2.0);
            }
            else {
                continue;
            }
            
            
            if (i == 0) {
                self.lconstBenefitWidth01.constant = widthBenefit;
                self.viewBenefit01.hidden = NO;
                self.imgBenefit01.image = nil;
                self.strBenefitURL01 = [arrBene objectAtIndex:i];
                
                [ImageDownManager blockImageDownWithURL:self.strBenefitURL01 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [self.strBenefitURL01 isEqualToString:strInputURL]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            
                            if (isInCache) {
                                self.imgBenefit01.alpha = 1;
                                self.imgBenefit01.image = fetchedImage;
                            }
                            else {
                                self.imgBenefit01.alpha = 0;
                                self.imgBenefit01.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgBenefit01.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }];
                
                
            }
            else if (i == 1) {
                self.lconstBenefitWidth02.constant = widthBenefit;
                self.viewBenefit02.hidden = NO;
                self.imgBenefit02.image = nil;
                self.strBenefitURL02 = [arrBene objectAtIndex:i];
                
                [ImageDownManager blockImageDownWithURL:self.strBenefitURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [self.strBenefitURL02 isEqualToString:strInputURL]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            
                            if (isInCache) {
                                self.imgBenefit02.alpha = 1;
                                self.imgBenefit02.image = fetchedImage;
                            }
                            else {
                                self.imgBenefit02.alpha = 0;
                                self.imgBenefit02.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imgBenefit02.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }];
            }
            else if (i == 2) {
                self.lconstBenefitWidth03.constant = widthBenefit;
                self.viewBenefit03.hidden = NO;
                self.imgBenefit03.image = nil;
                
                self.strBenefitURL03 = [arrBene objectAtIndex:i];
                
                [ImageDownManager blockImageDownWithURL:self.strBenefitURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [self.strBenefitURL03 isEqualToString:strInputURL]) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //정사각형 이미지 처리 분기
                            
                            if (isInCache) {
                                self.imgBenefit03.alpha = 1;
                                self.imgBenefit03.image = fetchedImage;
                            }
                            else {
                                self.imgBenefit03.alpha = 0;
                                self.imgBenefit03.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 
                                                 self.imgBenefit03.alpha = 1;
                                                 
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }
                }];
            }
        }
    }
    else {
        self.viewBenefit01.hidden = YES;
        self.viewBenefit02.hidden = YES;
        self.viewBenefit03.hidden = YES;
    }
}

@end
