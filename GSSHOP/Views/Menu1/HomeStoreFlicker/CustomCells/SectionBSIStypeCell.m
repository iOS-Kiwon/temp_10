//
//  SectionBSIStypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 24..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//
#import "AppDelegate.h"

#import "SectionBSIStypeCell.h"

@interface SectionBSIStypeCell () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) iCarousel *pageView;
@end

@implementation SectionBSIStypeCell
@synthesize  target;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.autoRollingValue = 0;
}


-(void) prepareForReuse {
    [super prepareForReuse];
    self.row_arr = nil;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    self.autoRollingValue = 0;
    self.pageView = nil;
}



-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr {
    self.row_arr =  rowinfoArr;
    [self.contentView  addSubview:[self scrollcontainView]];
}



- (UIView*)scrollcontainView {
    UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:220.0])] ;
    
    UIView *viewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,  [Common_Util DPRateOriginVAL:220.0] , APPFULLWIDTH,1.0)];
    viewBottomLine.backgroundColor = [Mocha_Util getColor:@"E5E5E5"];
                              
    
    //셀이1개 일경우 iCarousel 사용하면 가로스크롤 이벤트를 iCarousel이 가져가 버림 따라서 한개일때는 그냥 뷰로 붙이는게 깔끔한듯 더불어 셀이1일경우 pageControl
    
    if (NCA(self.row_arr) && [self.row_arr  count] > 1) {
        
        if(self.pageView == nil) {
            self.pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:220.0])];
            self.pageView.dataSource = self;
            self.pageView.delegate = self;
            self.pageView.type = iCarouselTypeLinear;
            self.pageView.decelerationRate = 0.40f;
        }
        
        [crcontainview addSubview:self.pageView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [Common_Util DPRateOriginVAL:200], APPFULLWIDTH, [Common_Util DPRateVAL:20 withPercent:50])];
        self.pageControl.numberOfPages = [self.row_arr  count];
        self.pageControl.pageIndicatorTintColor = [Mocha_Util getColor:@"C9C9C9"];
        self.pageControl.currentPageIndicatorTintColor = [Mocha_Util getColor:@"A4DD00"];
        
        NSLog(@"[self.row_arr  count][self.row_arr  count] = %lu",(long)[self.row_arr  count]);

        [crcontainview addSubview:self.pageControl];
        
    }
    else {        
        [crcontainview addSubview:[self addImageViewsWithArrayIndex:0]];
    }

    
    [crcontainview addSubview:viewBottomLine];
    
    //parksegun 자동스크롤 여부 체크 20190826 autoRollingValue 값은 테이블뷰에서 설정해준다. 이 셀에선 구조체 정보를 못읽도록 되어 있음.
    if (self.autoRollingValue > 0) {
        [self autoScrollCarousel];
    }
    
    
    return crcontainview;
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
    if(self.pageView.currentItemIndex + 1 == [self.row_arr count]) {
        [self.pageView scrollToItemAtIndex:0 animated:YES];
    }
    else {
        [self.pageView scrollToItemAtIndex:self.pageView.currentItemIndex+1 animated:YES];
    }
}


-(UIView *)addImageViewsWithArrayIndex:(NSInteger)index{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  APPFULLWIDTH   , [Common_Util DPRateOriginVAL:220.0])];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0.0, 0.0,   APPFULLWIDTH, [Common_Util DPRateOriginVAL:220.0])];
    imageView.image = [UIImage imageNamed:@"noimg_500.png"];
    [containerView addSubview:imageView];    
    // nami0342 - NCA
    if(NCA(self.row_arr) == NO)
        return nil;
    
    if([self.row_arr count] < index)
        return nil;
    
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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = containerView.bounds;
    [containerView addSubview:button];
    
    [button addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag =   index;
    
    return containerView;
}



#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [self.row_arr count];
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    UIView *containerView = nil;
    if (view == nil) {
        containerView = [self addImageViewsWithArrayIndex:index];
    }
    else {
        //셀 재사용시 다시 각 오브젝트 잡아서 설정해야하지만 iCarouselOptionVisibleItems 옵션이 카운트 갰수이므로 일단 패스
        return view;
    }
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


- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.pageControl.currentPage = carousel.currentItemIndex;
}



- (NSIndexPath *)getIndexPath {
    return [[self getTableView] indexPathForCell:self];
}


- (UITableView *)getTableView {
    
    UIView *superView = self.superview;
    
    while (superView && ![superView isKindOfClass:[UITableView class]]) {
        superView = superView.superview;
    }
    
    if (superView) {
        
        return (UITableView *)superView;
    }
    
    return nil;
}


- (void)bannerButtonClicked:(id)sender {
    if(NCO(self.row_arr)) {
        BOOL isf  =   ([[[self.row_arr objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"productName"] length] > 1);
        
        [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:[NSString stringWithFormat:@"%d_%d_%@", (int)[self getIndexPath].row, (int)[((UIButton *)sender) tag],
                                                                                                                                                   (isf)?                                                [[self.row_arr objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"productName" ] : [[self.row_arr objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"linkUrl" ] ]
         ];
    }
}



@end
