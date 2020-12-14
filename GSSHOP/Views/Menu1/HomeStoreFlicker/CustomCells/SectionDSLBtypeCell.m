//
//  SectionDSLBtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 14..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionDSLBtypeCell.h"
#import "AppDelegate.h"
#import "SectionDSLtypeSubProductView.h"

@interface SectionDSLBtypeCell () <iCarouselDataSource, iCarouselDelegate>
@end

@implementation SectionDSLBtypeCell
@synthesize  target;
@synthesize imgTopContents = _imgTopContents;
@synthesize carouselProduct = _carouselProduct;
@synthesize lblTotalPage = _lblTotalPage;
@synthesize lblCurrentPage = _lblCurrentPage;
@synthesize viewPaging, autoRollingValue, isRandom;;
@synthesize viewWhiteBG = _viewWhiteBG;
@synthesize viewBottomLine = _viewBottomLine;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.carouselProduct.type = iCarouselTypeLinear;
    self.carouselProduct.decelerationRate = 0.40f;
    self.carouselProduct.isAccessibilityElement = NO;
    /*20170214 parksegun 페이징 컨트롤 디자인 시작*/
    if(self.viewPaging == nil) {
        self.viewPaging = [[UIView alloc] init];
    }
    if(self.lblTotalPage == nil) {
        self.lblTotalPage = [[UILabel alloc] init];
    }
    if(self.lblCurrentPage == nil) {
        self.lblCurrentPage = [[UILabel alloc] init];
    }
    if(self.lblBar == nil) {
        self.lblBar = [[UILabel alloc] init];
    }
    
    // HOT 6의 붉은색 컬러부분의 센터에 중앙정렬이 되야함. 20170228 parksegun
    self.viewPaging.frame = CGRectMake(APPFULLWIDTH - 45 - 10 , ([Common_Util DPRateOriginVAL:37]/2) - (23/2), 45, 23);
    self.viewPaging.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //코너 모서리..
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewPaging.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(30, 30)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.viewPaging.bounds;
    maskLayer.path = maskPath.CGPath;
    self.viewPaging.layer.mask = maskLayer;
    
    float lableMargin = 11;
    float twoDigitsMargin = 0;
    if([self.row_arr count] > 9) {
        // 2자리 숫자이면 가운데 / 영역의 마진을 줄인다.
        lableMargin = 3.8;
        twoDigitsMargin = 2.8;
    }
    
    float forWidth = (self.viewPaging.frame.size.width - (lableMargin * 2)) / 3 ; //앞뒤 마진 11씩 빼고 3등분
    
    self.lblCurrentPage.frame = CGRectMake(lableMargin,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
    self.lblCurrentPage.font = [UIFont systemFontOfSize:13.0f];
    self.lblCurrentPage.textColor = [Mocha_Util getColor:@"FFFFFF"];
    self.lblCurrentPage.textAlignment = NSTextAlignmentRight;
    self.lblCurrentPage.lineBreakMode = NSLineBreakByClipping;
    
    self.lblBar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2), self.viewPaging.frame.size.height);
    self.lblBar.font = [UIFont systemFontOfSize:13.0f];
    self.lblBar.textColor = [Mocha_Util getColor:@"FFFFFF"];
    self.lblBar.alpha = 0.4f;
    self.lblBar.textAlignment = NSTextAlignmentCenter;
    
    self.lblTotalPage.frame = CGRectMake(self.lblBar.frame.origin.x + self.lblBar.frame.size.width ,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
    self.lblTotalPage.font = [UIFont systemFontOfSize:13.0f];
    self.lblTotalPage.textColor = [Mocha_Util getColor:@"FFFFFF"];
    self.lblTotalPage.alpha = 0.4f;
    self.lblTotalPage.textAlignment = NSTextAlignmentLeft;
    self.lblTotalPage.lineBreakMode = NSLineBreakByClipping;
    
    [self.viewPaging addSubview:self.lblBar];
    [self.viewPaging addSubview:self.lblCurrentPage];
    [self.viewPaging addSubview:self.lblTotalPage];
    
    [self addSubview:self.viewPaging];
    [self bringSubviewToFront:self.viewPaging];
    
    self.lblCurrentPage.text = [NSString stringWithFormat:@"1"];
    self.lblBar.text = [NSString stringWithFormat:@"/"];
    self.lblTotalPage.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.row_arr count]];
    
    /*페이징 컨트롤 디자인 종료*/
    
    self.autoRollingValue = 0;
    self.isRandom = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic{

    self.imgTopContents.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:45.0]);
    self.carouselProduct.frame = CGRectMake(0.0, self.imgTopContents.frame.size.height, APPFULLWIDTH,[Common_Util DPRateOriginVAL:135.0] + 58.0 + BENEFITTAG_HEIGTH);
    self.viewWhiteBG.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:45.0]+ [Common_Util DPRateOriginVAL:135.0] + 58.0 + BENEFITTAG_HEIGTH + 10);
    self.viewBottomLine.frame = CGRectMake(0.0, self.viewWhiteBG.frame.size.height -1.0, APPFULLWIDTH, 1.0);
    
    self.row_dic = rowinfoDic;
    self.backgroundColor = [UIColor clearColor];
    NSString *imageURL = NCS([self.row_dic objectForKey:@"imageUrl"]);

    
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache)
              {
                  self.imgTopContents.image = fetchedImage;
              }
              else
              {
                  self.imgTopContents.alpha = 0;
                  self.imgTopContents.image = fetchedImage;
                  
                  
                  
                  
                  [UIView animateWithDuration:0.2f
                                        delay:0.0f
                                      options:UIViewAnimationOptionCurveEaseInOut
                                   animations:^{
                                       
                                       self.imgTopContents.alpha = 1;
                                       
                                   }
                                   completion:^(BOOL finished) {
                                       
                                   }];
              }

            });
                    }
        }];
    
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"]) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {

        self.row_arr =  [rowinfoDic objectForKey:@"subProductList"];
        [self.carouselProduct reloadData];
        [self.carouselProduct scrollToItemAtIndex:0 animated:NO];
        
        
        /*사이즈 조정*/
        float lableMargin = 11;
        float twoDigitsMargin = 0;
        if([self.row_arr count] > 9) // 2자리 숫자이면 가운데 / 영역의 마진을 줄인다.
        {
            lableMargin = 3.8;
            twoDigitsMargin = 2.8;
        }
        
        float forWidth = (self.viewPaging.frame.size.width - (lableMargin * 2)) / 3 ; //앞뒤 마진 11씩 빼고 3등분
        
        self.lblCurrentPage.frame = CGRectMake(lableMargin,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
        self.lblBar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2),self.viewPaging.frame.size.height);
        self.lblTotalPage.frame = CGRectMake(self.lblBar.frame.origin.x + self.lblBar.frame.size.width ,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
        /*사이즈 조정 끝*/
        
        self.lblTotalPage.text = [NSString stringWithFormat:@"%d",(int)[self.row_arr count]];
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)self.carouselProduct.currentItemIndex+1];
        
        self.autoRollingValue = [NCS([rowinfoDic objectForKey:@"rollingDelay"]) floatValue];
        self.isRandom = [NCS([rowinfoDic objectForKey:@"randomYn"]) isEqualToString:@"Y"] ? YES : NO;
        
        if (self.autoRollingValue > 0) {
            [self autoScrollCarousel];
        }
        
        if(self.isRandom) {
            NSUInteger irandom = arc4random_uniform((int)self.carouselProduct.numberOfItems);
            [self.carouselProduct scrollToItemAtIndex:irandom animated:NO];
        }
    }
}


-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    self.row_arr = nil;
    [self.carouselProduct reloadData];
    self.imgTopContents.image = nil;
    
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    
    self.autoRollingValue = 0;
    self.isRandom = NO;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.row_arr count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    SectionDSLtypeSubProductView *subView = nil;
    
    if (view == nil) {
        //subView = [[SectionDSLtypeSubProductView alloc] initWithTarget:target with:];
        subView = [[SectionDSLtypeSubProductView alloc] initWithTarget:target with:NCS([self.row_dic objectForKey:@"viewType"])];
    }
    else {
        subView = (SectionDSLtypeSubProductView *)view;
        [subView prepareForReuse];
    }
    
    [subView setCellInfoNDrawData:[self.row_arr objectAtIndex:index]];
    return subView;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionVisibleItems:
            return 3;
        default:
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)carousel.currentItemIndex+1];
}

-(void)carouselDidScroll:(iCarousel *)carousel {
    if (self.autoRollingValue > 0) {
        [self autoScrollCarousel];
    }
}


-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:index]  andCnum:[NSNumber numberWithInt:(int)index] withCallType:@"DSL_B"];
}


-(void)runMethod {
    if(self.carouselProduct.currentItemIndex + 1 == [self.row_arr count]) {
        [self.carouselProduct scrollToItemAtIndex:0 animated:YES];
    }
    else {
        [self.carouselProduct scrollToItemAtIndex:self.carouselProduct.currentItemIndex+1 animated:YES];
    }
}

-(void)autoScrollCarousel {
    
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    
    if (self.autoRollingValue > 0) {
        timerScroll = [NSTimer scheduledTimerWithTimeInterval:self.autoRollingValue target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
    }
}


- (void)bannerButtonClicked:(id)sender {
}

-(IBAction)backGroundButtonClicked:(id)sender {
    
}



@end
