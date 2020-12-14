//
//  SectionDSLAtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 9..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionDSLAtypeCell.h"
#import "AppDelegate.h"
#import "SectionDSLtypeSubProductView.h"

@interface SectionDSLAtypeCell () <iCarouselDataSource, iCarouselDelegate>
@end

@implementation SectionDSLAtypeCell
@synthesize  target;
@synthesize imgTopContents = _imgTopContents;
@synthesize carouselProduct = _carouselProduct;
@synthesize lblTotalPage = _lblTotalPage;
@synthesize lblCurrentPage = _lblCurrentPage;
@synthesize viewPaging;
@synthesize viewWhiteBG = _viewWhiteBG;
@synthesize viewBottomLine = _viewBottomLine;
@synthesize isAutoRolling = _isAutoRolling;
@synthesize topHeight;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.carouselProduct.type = iCarouselTypeLinear;
    self.carouselProduct.decelerationRate = 0.40f;
    self.isAutoRolling = YES;
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
    
    self.topHeight = [Common_Util DPRateOriginVAL:45.0]; //디폴드 값이 이거임
    
    //DSL_A일경우 위치
    self.viewPaging.frame = CGRectMake(APPFULLWIDTH - 45 - 10 , 7, 45, 23);
    self.viewPaging.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    
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
    
    self.lblBar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2),self.viewPaging.frame.size.height);
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic {

    viewType = [rowinfoDic objectForKey:@"viewType"];
    float benefitH = BENEFITTAG_HEIGTH;
    if( [viewType isEqualToString:@"DSL_A2"] ) {
        benefitH = 0;
    }
    self.imgTopContents.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, self.topHeight);
    self.carouselProduct.frame = CGRectMake(0.0, self.topHeight, APPFULLWIDTH,[Common_Util DPRateOriginVAL:135.0] + 58.0 + benefitH);
    self.viewWhiteBG.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, self.topHeight+ [Common_Util DPRateOriginVAL:135.0] + 58.0 + benefitH + 10);
    self.viewBottomLine.frame = CGRectMake(0.0, self.viewWhiteBG.frame.size.height -1.0, APPFULLWIDTH, 1.0);
    self.titleText.frame = CGRectMake(10.0, 0.0, APPFULLWIDTH-10.0, self.topHeight);
    self.row_dic = rowinfoDic;
    
    self.backgroundColor = [UIColor clearColor];
    NSString *imageURL = NCS([self.row_dic objectForKey:@"imageUrl"]);
    NSString *productName = NCS([self.row_dic objectForKey:@"productName"]);
    //20180110 텍스트가 있으면 이미지보다 우선순위가 높이 노출됨. DSL_A일경우만.
    if([viewType isEqualToString:@"DSL_A2"] && [productName length] > 0) {
        self.titleText.hidden = NO;
        self.imgTopContents.hidden = YES;
        self.titleText.text = productName;
    }
    else {
        self.titleText.hidden = YES;
        self.imgTopContents.hidden = NO;
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        self.imgTopContents.image = fetchedImage;
                    }
                    else {
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
                    }//ifelse
                });
            }
        }];
    }
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"] ) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {
        self.row_arr =  [rowinfoDic objectForKey:@"subProductList"];
        [self.carouselProduct reloadData];
        [self.carouselProduct scrollToItemAtIndex:0 animated:NO];

        //DSL_A2일경우 위치 변경 - 20180102, 20180111 DSL_A2일경우 디자인이 변경됨.
        if( [viewType isEqualToString:@"DSL_A2"] ) {
            
            float lableMargin = 11;
            float twoDigitsMargin = 0;
            if([self.row_arr count] > 9) {
                // 2자리 숫자이면 가운데 / 영역의 마진을 줄인다.
                lableMargin = 3.8;
                twoDigitsMargin = 2.8;
            }
            
            
            self.viewPaging.frame = CGRectMake(APPFULLWIDTH - 52 - 10 , (self.topHeight - 23) /2.0 , 52, 23);
            
            
            //코너 모서리..
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewPaging.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(0, 0)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.viewPaging.bounds;
            maskLayer.path = maskPath.CGPath;
            self.viewPaging.layer.mask = maskLayer;
            
            float forWidth = (self.viewPaging.frame.size.width - (lableMargin * 2)) / 3 ; //앞뒤 마진 11씩 빼고 3등분
            self.lblTotalPage.frame = CGRectMake(self.viewPaging.frame.size.width - forWidth - twoDigitsMargin,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
            self.lblBar.frame = CGRectMake(self.lblTotalPage.frame.origin.x - forWidth + (twoDigitsMargin * 2) ,0,forWidth - (twoDigitsMargin * 2),self.viewPaging.frame.size.height);
            self.lblCurrentPage.frame = CGRectMake(self.lblBar.frame.origin.x - forWidth - twoDigitsMargin ,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
                        
            self.lblCurrentPage.font = [UIFont systemFontOfSize:15.0f];
            self.lblCurrentPage.textColor = [Mocha_Util getColor:@"111111"];
            self.lblBar.font = [UIFont systemFontOfSize:15.0f];
            self.lblBar.textColor = [Mocha_Util getColor:@"999999"];
            self.lblBar.alpha = 1.0f;
            self.lblTotalPage.font = [UIFont systemFontOfSize:15.0f];
            self.lblTotalPage.textColor = [Mocha_Util getColor:@"999999"];
            self.lblTotalPage.alpha = 1.0f;
            self.viewPaging.backgroundColor = UIColor.clearColor;
            
            
        }
        else {
            self.viewPaging.frame = CGRectMake(APPFULLWIDTH - 45 - 10 , 7, 45, 23);
            
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
            // 센터 정렬
            float forWidth = (self.viewPaging.frame.size.width - (lableMargin * 2)) / 3 ; //앞뒤 마진 11씩 빼고 3등분
            self.lblCurrentPage.frame = CGRectMake(lableMargin,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
            self.lblBar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2),self.viewPaging.frame.size.height);
            self.lblTotalPage.frame = CGRectMake(self.lblBar.frame.origin.x + self.lblBar.frame.size.width ,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
            
            self.lblCurrentPage.font = [UIFont systemFontOfSize:13.0f];
            self.lblCurrentPage.textColor = [Mocha_Util getColor:@"FFFFFF"];
            self.lblBar.font = [UIFont systemFontOfSize:13.0f];
            self.lblBar.textColor = [Mocha_Util getColor:@"FFFFFF"];
            self.lblBar.alpha = 0.4f;
            self.lblTotalPage.font = [UIFont systemFontOfSize:13.0f];
            self.lblTotalPage.textColor = [Mocha_Util getColor:@"FFFFFF"];
            self.lblTotalPage.alpha = 0.4f;
            self.viewPaging.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
            
        }
        
        /*사이즈 조정 끝*/
        self.lblTotalPage.text = [NSString stringWithFormat:@"%d",(int)[self.row_arr count]];
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)self.carouselProduct.currentItemIndex+1];
        
        if (self.isAutoRolling) {
            [self autoScrollCarousel];
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
    self.titleText.text = nil;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.row_arr count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    
    SectionDSLtypeSubProductView *subView = nil;    
    if (view == nil) {
        //subView = [[SectionDSLtypeSubProductView alloc] initWithTarget:target];
        subView = [[SectionDSLtypeSubProductView alloc] initWithTarget:target with:viewType]; // == self.isAutoRolling 같은 의미
    }
    else {
        subView = (SectionDSLtypeSubProductView *)view;
        [subView prepareForReuse];
    }

    NSDictionary *dicRow = [self.row_arr objectAtIndex:index];
    [subView setCellInfoNDrawData:dicRow];
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
    if (self.isAutoRolling) {
        [self autoScrollCarousel];
    }
}


-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:index]  andCnum:[NSNumber numberWithInt:(int)index] withCallType:viewType];
}

-(void)autoScrollCarousel {

    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    
    if (self.isAutoRolling == YES) {
        timerScroll = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
    }
}


-(void)runMethod {
   
    if(self.carouselProduct.currentItemIndex+1== self.carouselProduct.numberOfItems) {
        [self.carouselProduct scrollToItemAtIndex:0 animated:YES];
    }
    else {
        [self.carouselProduct scrollToItemAtIndex:self.carouselProduct.currentItemIndex+1 animated:YES];
    }
}

- (void)bannerButtonClicked:(id)sender {
    
}

-(IBAction)backGroundButtonClicked:(id)sender {
    
}



@end
