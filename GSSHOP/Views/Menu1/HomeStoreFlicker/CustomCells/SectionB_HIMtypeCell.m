//
//  SectionB_HIMtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 23..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_HIMtypeCell.h"
#import "AppDelegate.h"

@implementation SectionB_HIMtypeCell

@synthesize target;
@synthesize view_Default;
@synthesize viewBanner01;
@synthesize viewBanner02;
@synthesize viewBanner03;
@synthesize imgBanner01;
@synthesize imgBanner02;
@synthesize imgBanner03;
@synthesize viewBottomLine;
@synthesize row_dic;
@synthesize loadingImageURLString;
@synthesize lblTitle;
@synthesize viewHBanners;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    view_Default.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, view_Default.frame.size.height);
    viewBottomLine.frame = CGRectMake(viewBottomLine.frame.origin.x, view_Default.frame.size.height, view_Default.frame.size.width, 1.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) prepareForReuse {
    [super prepareForReuse];
    self.imgBanner01.image = nil;
    self.imgBanner02.image = nil;
    self.imgBanner03.image = nil;
    self.oneButton.accessibilityLabel = @"";
    self.twoButton.accessibilityLabel = @"";
    self.threeButton.accessibilityLabel = @"";
    for (UIView *viewSub in self.viewHBanners.subviews){
        [viewSub removeFromSuperview];
    }
    self.viewHBanners.frame = CGRectMake(0.0, HeightB_HIM, APPFULLWIDTH, 0);
}

//셀 데이터 셋팅 , 테이블뷰에서 호출
-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic {
    self.row_dic = rowinfoDic;
    if ([[rowinfoDic objectForKey:@"productName"] isKindOfClass:[NSNull class]] == NO && [NCS([rowinfoDic objectForKey:@"productName"]) length] > 0) {
        lblTitle.text = [rowinfoDic objectForKey:@"productName"];
    }
    else {
        lblTitle.text = @"TV쇼핑 혜택";
    }
    
    NSString *imageURL = NCS([rowinfoDic objectForKey:@"imageUrl"]);
    if ([imageURL length] > 0 && [imageURL hasPrefix:@"http"]) {
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        self.imgTitleIcon.image = fetchedImage;
                    }
                    else {
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
    yPosHBanner = HeightB_HIM;
    NSArray *arrProduct = nil;
    if (NCA([self.row_dic objectForKey:@"subProductList"])) {
        NSDictionary *dicSquareBanners = [[self.row_dic objectForKey:@"subProductList"] objectAtIndex:0];
        if(NCA([dicSquareBanners objectForKey:@"subProductList"])){
            arrProduct = [[NSArray alloc] initWithArray:[dicSquareBanners objectForKey:@"subProductList"]];
            self.view_Default.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, yPosHBanner);
        }
        else {
            self.viewBanner01.hidden = YES;
            self.viewBanner02.hidden = YES;
            self.viewBanner03.hidden = YES;
            yPosHBanner = HeightB_HIM_TOP;
            self.view_Default.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, yPosHBanner);
        }
    }
    else {
        self.viewBanner01.hidden = YES;
        self.viewBanner02.hidden = YES;
        self.viewBanner03.hidden = YES;
        yPosHBanner = HeightB_HIM_TOP;
        self.view_Default.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, yPosHBanner);
    }
    
    NSArray *arrHBanners = nil;
    if (NCA([self.row_dic objectForKey:@"subProductList"]) && [[self.row_dic objectForKey:@"subProductList"] count] > 1) {
        NSDictionary *dicSubBanners = [[self.row_dic objectForKey:@"subProductList"] objectAtIndex:1];
        if(NCA([dicSubBanners objectForKey:@"subProductList"])){
            arrHBanners = [[NSArray alloc] initWithArray:[dicSubBanners objectForKey:@"subProductList"]];
        }
    }
    
    if ([arrProduct count] > 0) {
        NSString *imageURL = NCS([[arrProduct objectAtIndex:0] objectForKey:@"imageUrl"]);
        self.oneButton.accessibilityLabel = NCS([[arrProduct objectAtIndex:0] objectForKey:@"productName"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        imgBanner01.image = fetchedImage;
                    }
                    else {
                      imgBanner01.alpha = 0;
                      imgBanner01.image = fetchedImage;
                      [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           imgBanner01.alpha = 1;
                                       }
                                       completion:^(BOOL finished) {
                                       }];
                    }
                });
            }
          }];
    }
    
    if ([arrProduct count] > 1) {
        NSString *imageURL02 = NCS([[arrProduct objectAtIndex:1] objectForKey:@"imageUrl"]);
        self.twoButton.accessibilityLabel = NCS([[arrProduct objectAtIndex:1] objectForKey:@"productName"]);
        [ImageDownManager blockImageDownWithURL:imageURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL02 isEqualToString:strInputURL]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                      imgBanner02.image = fetchedImage;
                    }
                    else {
                      imgBanner02.alpha = 0;
                      imgBanner02.image = fetchedImage;
                      [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           imgBanner02.alpha = 1;
                                       }
                                       completion:^(BOOL finished) {
                                       }];
                  }
                });
            }
          }];
    }
    
    if ([arrProduct count] > 2) {
        NSString *imageURL03 = NCS([[arrProduct objectAtIndex:2] objectForKey:@"imageUrl"]);
        self.threeButton.accessibilityLabel = NCS([[arrProduct objectAtIndex:2] objectForKey:@"productName"]);
        [ImageDownManager blockImageDownWithURL:imageURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL03 isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                      imgBanner03.image = fetchedImage;
                  }
                  else {
                      imgBanner03.alpha = 0;
                      imgBanner03.image = fetchedImage;
                      [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           imgBanner03.alpha = 1;
                                       }
                                       completion:^(BOOL finished) {
                                       }];
                  }
                });
            }
          }];
    }
    

    if ([arrProduct count] == 1) {
        viewBanner01.hidden = NO;
        viewBanner02.hidden = YES;
        viewBanner03.hidden = YES;
        viewBanner01.center = view_Default.center;
    }
    else if ([arrProduct count] == 2) {
        viewBanner01.hidden = NO;
        viewBanner02.hidden = NO;
        viewBanner03.hidden = YES;
        viewBanner01.center = CGPointMake(APPFULLWIDTH/4.0, viewBanner01.center.y);
        viewBanner02.center = CGPointMake(APPFULLWIDTH/2.0 + APPFULLWIDTH/4.0, viewBanner02.center.y);
    }
    else if ([arrProduct count] > 2) {
        viewBanner01.hidden = NO;
        viewBanner02.hidden = NO;
        viewBanner03.hidden = NO;
        viewBanner01.center = CGPointMake(APPFULLWIDTH/6.0, viewBanner01.center.y);
        viewBanner02.center = CGPointMake(APPFULLWIDTH/3.0 + APPFULLWIDTH/6.0, viewBanner02.center.y);
        viewBanner03.center = CGPointMake((APPFULLWIDTH/3.0)*2 + APPFULLWIDTH/6.0, viewBanner03.center.y);
    }
    
    if ([arrHBanners count] > 0) {
        if ([arrHBanners count] > 5) {
            self.viewHBanners.frame = CGRectMake(0.0, yPosHBanner, APPFULLWIDTH, HeightB_HIMHBanner * 5);
        }
        else {
            self.viewHBanners.frame = CGRectMake(0.0, yPosHBanner, APPFULLWIDTH, HeightB_HIMHBanner * [arrHBanners count]);
        }
        viewBottomLine.frame = CGRectMake(0.0, viewHBanners.frame.origin.y + viewHBanners.frame.size.height, APPFULLWIDTH, 1.0);
    }
    else {
        viewBottomLine.frame = CGRectMake(viewBottomLine.frame.origin.x, view_Default.frame.size.height, view_Default.frame.size.width, 1.0);
    }
    
    CGFloat yPosBanner = 0.0;
    for (NSInteger i=0; i<[arrHBanners count]; i++) {
        UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, yPosBanner, APPFULLWIDTH, HeightB_HIMHBanner)];
        imgBg.image = [UIImage imageNamed:@"noimg_80.png"];
        UIImageView *imgBanner = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, yPosBanner, APPFULLWIDTH, HeightB_HIMHBanner)];
        UIButton *btnBanner = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBanner.frame = CGRectMake(0.0, yPosBanner, APPFULLWIDTH, HeightB_HIMHBanner);
        btnBanner.tag = i;
        [btnBanner addTarget:self action:@selector(onBtnHBanner:) forControlEvents:UIControlEventTouchUpInside];
        UIView *viewTopLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, yPosBanner, APPFULLWIDTH, 0.5)];
        viewTopLine.backgroundColor = [Mocha_Util getColor:@"E5E5E5"];
        [self.viewHBanners addSubview:imgBg];
        [self.viewHBanners addSubview:imgBanner];
        [self.viewHBanners addSubview:viewTopLine];
        [self.viewHBanners addSubview:btnBanner];
        NSString *imageURL = NCS([[arrHBanners objectAtIndex:i] objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        imgBanner.image = fetchedImage;
                    }
                    else {
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
        yPosBanner = yPosBanner + HeightB_HIMHBanner;
        if (i==4) {
            break;
        }
    }
}

- (IBAction)onBtnHBanner:(id)sender {
    NSArray *arrHBanners = nil;
    if (NCA([self.row_dic objectForKey:@"subProductList"]) && [[self.row_dic objectForKey:@"subProductList"] count] > 1) {
        NSDictionary *dicSubBanners = [[self.row_dic objectForKey:@"subProductList"] objectAtIndex:1];
        if(NCA([dicSubBanners objectForKey:@"subProductList"])){
            arrHBanners = [[NSArray alloc] initWithArray:[dicSubBanners objectForKey:@"subProductList"]];
        }
    }
    if ([self.target respondsToSelector:@selector(dctypetouchEventTBCell:andCnum:withCallType:)]) {
        [self.target dctypetouchEventTBCell:[arrHBanners objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"B_HIM"];
    }
}
    
- (IBAction)onBtnBanner:(id)sender {
    NSArray *arrBanners = nil;
    if (NCA([self.row_dic objectForKey:@"subProductList"]) && [[self.row_dic objectForKey:@"subProductList"] count] > 0) {
        NSDictionary *dicSubBanners = [[self.row_dic objectForKey:@"subProductList"] objectAtIndex:0];
        if(NCA([dicSubBanners objectForKey:@"subProductList"])){
            arrBanners = [[NSArray alloc] initWithArray:[dicSubBanners objectForKey:@"subProductList"]];
        }
    }
    @try {
        [self.target dctypetouchEventTBCell:[arrBanners objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"B_HIM"];
    }
    @catch (NSException *exception) {
        
    }
}

@end
