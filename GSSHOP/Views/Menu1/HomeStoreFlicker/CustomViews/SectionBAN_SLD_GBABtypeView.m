//
//  SectionSEtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 7..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.

#import "SectionBAN_SLD_GBABtypeView.h"
#import "AppDelegate.h"

@interface SectionBAN_SLD_GBABtypeView() <iCarouselDataSource, iCarouselDelegate>
@end

@implementation SectionBAN_SLD_GBABtypeView
@synthesize target;
@synthesize viewPaging;
@synthesize lblCurrentPage;
@synthesize lblTotalPage;
@synthesize lblbar,pageView,isRandom,autoRollingValue;

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe Type:(NSString*)type {
    self = [super init];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SectionBAN_SLD_GBABtypeView" owner:self options:nil];
        self = [nibs objectAtIndex:0];
        target = sender;
        self.frame = tframe;
        gbType = type;
        self.autoRollingValue = 0;
        self.isRandom = NO;
        if(mapPosition == nil) {
            mapPosition = [[NSMutableDictionary alloc] init];
        }
        myPos = 0;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.row_arr == nil) {
        self.row_arr = [[NSMutableArray alloc] init];
    }
}


-(void)prepareForReuse {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.pageView = nil;
    self.viewPaging = nil;
    self.lblCurrentPage.text = @"";
    self.lblTotalPage.text = @"";
    self.lblbar.text = @"";
    self.autoRollingValue = 0;
    self.isRandom = NO;
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    myPos = 0;
}



- (void) setCellInfoNDrawData:(NSArray*) rowinfoArr {
    self.backgroundColor = [UIColor clearColor];
    [self.row_arr removeAllObjects];
    
    if ([rowinfoArr count] > 1) {
        [self.row_arr addObjectsFromArray:rowinfoArr];
        [self addSubview:[self scrollcontainView]];
    }
    else {
        [self.row_arr addObjectsFromArray:rowinfoArr];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160.0])];

        imageView.image = [UIImage imageNamed:@"noimg_320.png"];
        [self addSubview:imageView];
        if(NCA(self.row_arr ) && ([self.row_arr count] == 1) && [NCS([[self.row_arr objectAtIndex:0] objectForKey:@"imageUrl"]) length] > 0) {
            NSString *imageURL = NCS([[self.row_arr objectAtIndex:0] objectForKey:@"imageUrl"]);
            [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache) {
                            imageView.image = fetchedImage;
                        }
                        else {
                            imageView.alpha = 0;
                            imageView.image = fetchedImage;
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 imageView.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                             }];
                        }
                    });
                }
            }];
        }
        
        // Add a bottomBorder.
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, imageView.frame.size.height, imageView.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
        [imageView.layer addSublayer:bottomBorder];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [self addSubview:button];
        
        [button addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag =  0;
    }
}


- (UIView*)scrollcontainView {
        UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH,[Common_Util DPRateOriginVAL:160])] ;

    crcontainview.backgroundColor = [UIColor clearColor];
    if(self.pageView == nil) {
                self.pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:160])];

        self.pageView.dataSource = self;
        self.pageView.delegate = self;
        self.pageView.type = iCarouselTypeLinear;
        self.pageView.isAccessibilityElement = NO; // 하위접근
        self.pageView.decelerationRate = 0.40f;
        self.pageView.backgroundColor = [UIColor clearColor];
        [crcontainview addSubview:self.pageView];
        if(self.viewPaging == nil) {
            self.viewPaging = [[UIView alloc] init];
        }
        if([NCS(gbType) isEqualToString:@"BAN_SLD_GBA"] || [NCS(gbType) isEqualToString:@"PMO_T2_IMG_C"]) {
            self.viewPaging.frame = CGRectMake(crcontainview.frame.size.width - 42 - 16 , crcontainview.frame.size.height - 22 - 16, 42, 22);
        }
        else if([NCS(gbType) isEqualToString:@"BAN_SLD_GBB"]) {
            self.viewPaging.frame = CGRectMake(crcontainview.frame.size.width - 42 - 16 , 16, 42, 22);
        }
        self.viewPaging.backgroundColor = [UIColor getColor:@"66111111" alpha:0.4 defaultColor:UIColor.blackColor];
        //코너 모서리..
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.viewPaging.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(30, 30)];
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = self.viewPaging.bounds;
//        maskLayer.path = maskPath.CGPath;
//        self.viewPaging.layer.mask = maskLayer;
        self.viewPaging.layer.cornerRadius = 22/2;
        float lableMargin = 10;
        float twoDigitsMargin = 0;
        if([self.row_arr count] > 9) {// 2자리 숫자이면 가운데 / 영역의 마진을 줄인다.
            lableMargin = 3.8;
            twoDigitsMargin = 2.8;
        }
        float forWidth = (self.viewPaging.frame.size.width - (lableMargin * 2) ) / 3 ; //앞뒤 마진 11씩 빼고 3등분
        if(self.lblCurrentPage == nil) {
            self.lblCurrentPage = [[UILabel alloc] init];
        }
        self.lblCurrentPage.frame = CGRectMake(lableMargin,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
        self.lblCurrentPage.font = [UIFont systemFontOfSize:12.0f];
        self.lblCurrentPage.textColor = [Mocha_Util getColor:@"FFFFFF"];
        self.lblCurrentPage.textAlignment = NSTextAlignmentRight;
        self.lblCurrentPage.lineBreakMode = NSLineBreakByClipping;
        [self.viewPaging addSubview:self.lblCurrentPage];
        if(self.lblbar == nil) {
            self.lblbar = [[UILabel alloc] init];
        }
        self.lblbar.frame = CGRectMake(self.lblCurrentPage.frame.origin.x + self.lblCurrentPage.frame.size.width ,0,forWidth - (twoDigitsMargin * 2),self.viewPaging.frame.size.height);
        self.lblbar.font = [UIFont systemFontOfSize:12.0f];
        self.lblbar.textColor = [UIColor getColor:@"FFFFFF" alpha:1 defaultColor:UIColor.whiteColor];
        self.lblbar.textAlignment = NSTextAlignmentCenter;
        [self.viewPaging addSubview:self.lblbar];
        if(self.lblTotalPage == nil) {
            self.lblTotalPage = [[UILabel alloc] init];
        }
        self.lblTotalPage.frame = CGRectMake(self.lblbar.frame.origin.x + self.lblbar.frame.size.width ,0,forWidth + twoDigitsMargin,self.viewPaging.frame.size.height);
        self.lblTotalPage.font = [UIFont systemFontOfSize:12.0f];
        self.lblTotalPage.textColor = [UIColor getColor:@"FFFFFF" alpha:1 defaultColor:UIColor.whiteColor];
        self.lblTotalPage.textAlignment = NSTextAlignmentLeft;
        self.lblTotalPage.lineBreakMode = NSLineBreakByClipping;
        [self.viewPaging addSubview:self.lblTotalPage];
        [crcontainview addSubview:self.viewPaging];
        /*좌우 버튼*/
        if(![NCS(gbType) isEqualToString:@"PMO_T2_IMG_C"]) {
            float btnClickWidth = crcontainview.frame.size.width/10;
            //왼쪽이동 버튼
            UIImageView* leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 14, 25)];
            leftImageView.center = CGPointMake((leftImageView.frame.size.width/2 + 10), crcontainview.frame.size.height/2);
            leftImageView.image = [UIImage imageNamed:@"gbarrow.png"];
            [crcontainview addSubview:leftImageView];
            UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftBtn setFrame:CGRectMake(0, 0, btnClickWidth, crcontainview.frame.size.height)];
            [leftBtn addTarget:self action:@selector(leftArrow:) forControlEvents:UIControlEventTouchUpInside];
            leftBtn.accessibilityLabel = @"왼쪽 이동";
            [crcontainview addSubview:leftBtn];
            //오른쪽이동 버튼
            UIImageView* rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(crcontainview.frame.size.width - 10 - 14, 0, 14, 25)];
            rightImageView.transform = CGAffineTransformMakeRotation(M_PI); //이미지 재활용.. < 이미지를 돌린다.
            rightImageView.center = CGPointMake(crcontainview.frame.size.width - (rightImageView.frame.size.width/2) - 10, crcontainview.frame.size.height/2);
            rightImageView.image = [UIImage imageNamed:@"gbarrow.png"];
            [crcontainview addSubview:rightImageView];
            UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setFrame:CGRectMake(crcontainview.frame.size.width - btnClickWidth, 0, btnClickWidth, crcontainview.frame.size.height)];
            [rightBtn addTarget:self action:@selector(rightArrow:) forControlEvents:UIControlEventTouchUpInside];
            rightBtn.accessibilityLabel = @"오른쪽 이동";
            [crcontainview addSubview:rightBtn];
        }
    }
    
    self.lblCurrentPage.text = [NSString stringWithFormat:@"1"];
    self.lblbar.text = [NSString stringWithFormat:@"/"];
    self.lblTotalPage.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.row_arr count]];
    if([NCS(gbType) isEqualToString:@"BAN_SLD_GBA"]) {
        self.autoRollingValue = 0;
        self.isRandom = NO;
    }
    if (self.autoRollingValue > 0) {
        [self autoScrollCarousel];
    }
    if(self.isRandom) {
        NSUInteger irandom = arc4random_uniform((int)self.pageView.numberOfItems);
        [self.pageView scrollToItemAtIndex:irandom animated:NO];
    }
    return crcontainview;
}

- (void) setSlidePostion:(NSInteger) postion {
    myPos = postion;
    NSString* index = [mapPosition objectForKey:[NSString stringWithFormat:@"%ld",postion]];
    if( [index length] > 0) {
        [self.pageView scrollToItemAtIndex:index.integerValue animated:NO];
    }
    else {
        [self.pageView scrollToItemAtIndex:0 animated:NO];
    }
    NSLog(@"SlidePostion: %ld = %@", postion, index);
}


- (void)leftArrow:(id)sender {
     if(self.pageView != nil) {
         [self.pageView scrollToItemAtIndex:pageView.currentItemIndex - 1 animated:YES];
     }
}

- (void)rightArrow:(id)sender {
    if(self.pageView != nil) {
        [self.pageView scrollToItemAtIndex:pageView.currentItemIndex + 1 animated:YES];
    }
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.row_arr count];
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  carousel.frame.size.width   , carousel.frame.size.height)];
    containerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,   carousel.frame.size.width , carousel.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"noimg_320.png"];
    [containerView addSubview:imageView];
    
    if(NCA(self.row_arr) && self.row_arr.count > index && [NCS([[self.row_arr objectAtIndex:index] objectForKey:@"imageUrl"]) length] > 0) {
        NSString *imageURL = NCS([[self.row_arr objectAtIndex:index] objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        imageView.image = fetchedImage;
                    }
                    else {
                        imageView.alpha = 0;
                        imageView.image = fetchedImage;
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             imageView.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }
                });
            }
        }];
    }
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, imageView.frame.size.height, imageView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [Mocha_Util getColor:@"D9D9D9"].CGColor;
    [imageView.layer addSublayer:bottomBorder];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = containerView.bounds;
    [containerView addSubview:button];    
    
    // 접근성 설정
    NSString *accessStr = NCS([[self.row_arr objectAtIndex:index] objectForKey:@"productName"]);
    if (accessStr.length > 0) {
        button.accessibilityLabel = NCS([[self.row_arr objectAtIndex:index] objectForKey:@"productName"]);
    } else {
        button.accessibilityLabel = @"이미지 베너 입니다.";
    }
    [button addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = index;
    
    return containerView;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionSpacing:
            return value * 1.0;
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionVisibleItems:
            return [self.row_arr count];
        default:
            return value;
    }
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    if (self.autoRollingValue > 0) {
        [self autoScrollCarousel];
    }
}


- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.lblCurrentPage.text = [NSString stringWithFormat:@"%ld",(long)carousel.currentItemIndex + 1];
    [mapPosition setValue:[NSString stringWithFormat:@"%ld",carousel.currentItemIndex] forKey:[NSString stringWithFormat:@"%ld",myPos]];
}

- (void)setPositionKey:(NSInteger )key {
    myPos=key;
    if(![[mapPosition allKeys] containsObject:[NSString stringWithFormat:@"%ld",key]]){
        //[mapPosition setNilValueForKey:[NSString stringWithFormat:@"%ld",key]];
        [mapPosition setValue:@"0" forKey:[NSString stringWithFormat:@"%ld",key]];
    }
}


- (void)bannerButtonClicked:(id)sender {
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    if(NCA(self.row_arr) && self.row_arr.count > [((UIButton *)sender) tag]) {
        [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:gbType];
    }
}


- (void)autoScrollCarousel {
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    if (self.autoRollingValue > 0) {
        timerScroll = [NSTimer scheduledTimerWithTimeInterval:self.autoRollingValue target:self selector:@selector(runMethod) userInfo:nil repeats:YES];
    }
}


- (void)runMethod {
    if(self.pageView != nil) {
        [self.pageView scrollToItemAtIndex:self.pageView.currentItemIndex + 1 animated:YES];
    }
}


- (void)dealloc{
    self.row_arr = nil;
    self.pageView = nil;
}

@end
