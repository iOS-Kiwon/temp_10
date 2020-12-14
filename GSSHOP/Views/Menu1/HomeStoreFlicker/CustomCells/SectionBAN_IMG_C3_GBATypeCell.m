//
//  SectionBAN_IMG_C3_GBATypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 4. 26..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_IMG_C3_GBATypeCell.h"
#import "SectionTBViewController.h"

@implementation SectionBAN_IMG_C3_GBATypeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    self.view_Default.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, self.view_Default.frame.size.height);
    
    
    self.viewBanner01.layer.borderWidth = 1.0;
    self.viewBanner01.layer.cornerRadius = 2.0;
    self.viewBanner01.layer.shouldRasterize = YES;
    self.viewBanner01.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewBanner01.layer.borderColor = [Mocha_Util getColor:@"EEEEEE"].CGColor;
    
    self.viewBanner02.layer.borderWidth = 1.0;
    self.viewBanner02.layer.cornerRadius = 2.0;
    self.viewBanner02.layer.shouldRasterize = YES;
    self.viewBanner02.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewBanner02.layer.borderColor = [Mocha_Util getColor:@"EEEEEE"].CGColor;
    
    self.viewBanner03.layer.borderWidth = 1.0;
    self.viewBanner03.layer.cornerRadius = 2.0;
    self.viewBanner03.layer.shouldRasterize = YES;
    self.viewBanner03.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.viewBanner03.layer.borderColor = [Mocha_Util getColor:@"EEEEEE"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    self.imgBanner01.image = [UIImage imageNamed:@"noimg_280.png"];
    self.imgBanner02.image = [UIImage imageNamed:@"noimg_280.png"];
    self.imgBanner03.image = [UIImage imageNamed:@"noimg_280.png"];
 
    self.lblBanner01.text = @"";
    self.lblBanner02.text = @"";
    self.lblBanner03.text = @"";
    
}

//셀 데이터 셋팅 , 테이블뷰에서 호출
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic{
    
    self.row_dic = rowinfoDic;
    NSLog(@"[rowinfoDic objectForKey:@productName] = %@",[rowinfoDic objectForKey:@"productName"]);
    
    if ([[rowinfoDic objectForKey:@"productName"] isKindOfClass:[NSNull class]] == NO && [NCS([rowinfoDic objectForKey:@"productName"]) length] > 0) {
        self.lblTitle.text = [rowinfoDic objectForKey:@"productName"];
    }else{
        self.lblTitle.text = @"테마키워드 쇼핑";
    }
    
    NSString *imageURL = NCS([rowinfoDic objectForKey:@"imageUrl"]);
    if ([imageURL length] > 0 && [imageURL hasPrefix:@"http"]) {
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                    {
                        self.imgTitleIcon.image = fetchedImage;
                    }
                    else
                    {
                        self.imgTitleIcon.alpha = 0;
                        self.imgTitleIcon.image = fetchedImage;
                        
                        
                        
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             
                                             self.imgTitleIcon.alpha = 1;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    }
                });
                
            }
        }];
    }

    NSArray *arrProduct = nil;
    if (NCA([self.row_dic objectForKey:@"subProductList"])) {
        arrProduct = [[NSArray alloc] initWithArray:[self.row_dic objectForKey:@"subProductList"]];
    }
    if ([arrProduct count] > 0) {
        
        self.lblBanner01.text = NCS([[arrProduct objectAtIndex:0] objectForKey:@"productName"]);
        self.btnBanner01.accessibilityLabel = NCS([[arrProduct objectAtIndex:0] objectForKey:@"productName"]);
        
        NSString *imageURL = NCS([[arrProduct objectAtIndex:0] objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                    {
                        self.imgBanner01.image = fetchedImage;
                    }
                    else
                    {
                        self.imgBanner01.alpha = 0;
                        self.imgBanner01.image = fetchedImage;
                        
                        
                        
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             
                                             self.imgBanner01.alpha = 1;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                             
                                         }];
                    }
                    
                });
            }
        }];
        
    }
    
    if ([arrProduct count] > 1) {
        
        self.lblBanner02.text = NCS([[arrProduct objectAtIndex:1] objectForKey:@"productName"]);
        self.btnBanner02.accessibilityLabel = NCS([[arrProduct objectAtIndex:1] objectForKey:@"productName"]);
        
        NSString *imageURL02 = NCS([[arrProduct objectAtIndex:1] objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL02 isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                    {
                        self.imgBanner02.image = fetchedImage;
                    }
                    else
                    {
                        self.imgBanner02.alpha = 0;
                        self.imgBanner02.image = fetchedImage;
                        
                        
                        
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             
                                             self.imgBanner02.alpha = 1;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    }
                });
                
            }
        }];
        
        
    }
    
    
    if ([arrProduct count] > 2) {
        
        self.lblBanner03.text = NCS([[arrProduct objectAtIndex:2] objectForKey:@"productName"]);
        self.btnBanner03.accessibilityLabel = NCS([[arrProduct objectAtIndex:2] objectForKey:@"productName"]);
        
        NSString *imageURL03 = NCS([[arrProduct objectAtIndex:2] objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL03 isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                    {
                        self.imgBanner03.image = fetchedImage;
                    }
                    else
                    {
                        self.imgBanner03.alpha = 0;
                        self.imgBanner03.image = fetchedImage;
                        
                        
                        
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             
                                             self.imgBanner03.alpha = 1;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    }
                    
                });
            }
        }];
        
        
    }
    
    
    
    if ([arrProduct count] == 1) {
        
        self.viewBanner01.hidden = NO;
        self.viewBanner02.hidden = YES;
        self.viewBanner03.hidden = YES;
        
        self.viewBanner01.center = self.view_Default.center;
        
    }else if ([arrProduct count] == 2){
        
        self.viewBanner01.hidden = NO;
        self.viewBanner02.hidden = NO;
        self.viewBanner03.hidden = YES;
        
        
        self.viewBanner01.center = CGPointMake(APPFULLWIDTH/4.0, self.viewBanner01.center.y);
        self.viewBanner02.center = CGPointMake(APPFULLWIDTH/2.0 + APPFULLWIDTH/4.0, self.viewBanner02.center.y);
        
        
    }else if ([arrProduct count] > 2) {
        self.viewBanner01.hidden = NO;
        self.viewBanner02.hidden = NO;
        self.viewBanner03.hidden = NO;
        
        self.viewBanner01.center = CGPointMake(APPFULLWIDTH/6.0, self.viewBanner01.center.y);
        self.viewBanner02.center = CGPointMake(APPFULLWIDTH/3.0 + APPFULLWIDTH/6.0, self.viewBanner02.center.y);
        self.viewBanner03.center = CGPointMake((APPFULLWIDTH/3.0)*2 + APPFULLWIDTH/6.0, self.viewBanner03.center.y);
        
    }
    

    
}


-(IBAction)onBtnBanner:(id)sender{
    
    NSArray *arrBanners = nil;
    if (NCA([self.row_dic objectForKey:@"subProductList"]) && [[self.row_dic objectForKey:@"subProductList"] count] > 0) {
        arrBanners = [[NSArray alloc] initWithArray:[self.row_dic objectForKey:@"subProductList"]];
        
        if ([self.target respondsToSelector:@selector(dctypetouchEventTBCell:andCnum:withCallType:)]) {
            [self.target dctypetouchEventTBCell:[arrBanners objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BAN_IMG_C3_GBA"];
        }
    }
    
    
}

@end

