//
//  SectionTSLtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 11..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionTSLtypeCell.h"
#import "AppDelegate.h"
#import "SectionDSLtypeSubProductView.h"

@interface SectionTSLtypeCell () <iCarouselDataSource, iCarouselDelegate>
@end

@implementation SectionTSLtypeCell
//@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize target;
@synthesize imgBG = _imgBG;
@synthesize viewPaging, lblBar,lblTotalPage,lblCurrentPage,autoRollingValue, isRandom;
@synthesize view_Default = _view_Default;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carouselProduct.type = iCarouselTypeLinear;
    self.carouselProduct.decelerationRate = 0.40f;
    self.carouselProduct.isAccessibilityElement = NO;
    self.backgroundColor = [UIColor clearColor];
    
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
    
    //TSL 위치 조정
    self.viewPaging.frame = CGRectMake(APPFULLWIDTH - 45 - 10 , [Common_Util DPRateOriginVAL:44], 45, 23);
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
    
    self.autoRollingValue = 0;
    self.isRandom = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic {    
    CGFloat viewHeight = roundf([Common_Util DPRateOriginVAL:72.0] + [Common_Util DPRateOriginVAL:135.0] + 58.0 + BENEFITTAG_HEIGTH + 10.0);
    self.view_Default.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH,viewHeight);
    self.viewBottomLine.frame = CGRectMake(0.0, self.view_Default.frame.size.height - 1.0, APPFULLWIDTH, 1.0);
    self.imgBG.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH + BENEFITTAG_HEIGTH, viewHeight); //늘어난 높이 만큼 폭을 늘려 비율을 유지- 넘어가는 부분은 크롭된다.
    self.imgContents.frame = self.imgBG.frame;
    self.carouselProduct.frame = CGRectMake(0.0, [Common_Util DPRateOriginVAL:72.0], APPFULLWIDTH,[Common_Util DPRateOriginVAL:135.0] + 58.0 + BENEFITTAG_HEIGTH );
    self.row_dic = rowinfoDic;
    self.backgroundColor = [UIColor clearColor];
    NSString *imageURL = NCS([self.row_dic objectForKey:@"imageUrl"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if (error == nil  && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache) {
                    self.imgContents.image = fetchedImage;
                }
                else {
                    self.imgContents.alpha = 0;
                    self.imgContents.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         self.imgContents.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                     }];
                }
            });
        }//if
    }];
    
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"] ) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {
        self.row_arr =  [rowinfoDic objectForKey:@"subProductList"];
        [self.carouselProduct reloadData];
        [self.carouselProduct scrollToItemAtIndex:0 animated:NO];
        
        /*사이즈 조정*/
        float lableMargin = 11;
        float twoDigitsMargin = 0;
        if([self.row_arr count] > 9) {
            // 2자리 숫자이면 가운데 / 영역의 마진을 줄인다.
            lableMargin = 3.8;
            twoDigitsMargin = 2.8;
        }
        float forWidth = (self.viewPaging.frame.size.width - (lableMargin * 2)) / 3 ; //앞뒤 마진 11씩 빼고 3등분
        self.lblCurrentPage.frame = CGRectMake(lableMargin,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
        self.lblBar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2),self.viewPaging.frame.size.height);
        self.lblTotalPage.frame = CGRectMake(self.lblBar.frame.origin.x + self.lblBar.frame.size.width ,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
        /*사이즈 조정 끝*/
        self.lblTotalPage.text = [NSString stringWithFormat:@"%d",(int)[self.row_arr count]];
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
    self.imgContents.image = nil;
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    self.autoRollingValue = 0;
    self.isRandom = NO;
    self.accessibilityLabel = @"";
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.row_arr count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    SectionDSLtypeSubProductView *subView = nil;    
    if (view == nil) {
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


-(void)carouselDidScroll:(iCarousel *)carousel {
    if (self.autoRollingValue > 0) {
        [self autoScrollCarousel];
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)carousel.currentItemIndex+1];
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:index]  andCnum:[NSNumber numberWithInt:(int)index] withCallType:@"TSL"];
}


- (void)bannerButtonClicked:(id)sender {
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"TSL"   ];
}

-(IBAction)backGroundButtonClicked:(id)sender {
    [target dctypetouchEventTBCell:self.row_dic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"TSLBACKGROUND"   ];
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

-(void)runMethod {
    if(self.carouselProduct.currentItemIndex + 1 == self.carouselProduct.numberOfItems) {
        [self.carouselProduct scrollToItemAtIndex:0 animated:YES];
    }
    else {
        [self.carouselProduct scrollToItemAtIndex:self.carouselProduct.currentItemIndex+1 animated:YES];
    }
}
@end
