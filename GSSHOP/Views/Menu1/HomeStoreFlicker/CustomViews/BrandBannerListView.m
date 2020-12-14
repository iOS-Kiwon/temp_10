//
//  BrandBannerListView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 18..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "BrandBannerListView.h"

#import "AppDelegate.h"

#define BRANDBANNERTOP_HEIGHT 120


@interface BrandBannerListView () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation BrandBannerListView

@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize  target;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
}


- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe
{
    
    self = [super init];
    if (self)
    {
        
        
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BrandBannerListView" owner:self options:nil];
        if([nibs count] <= 0) return self;
        self = [nibs objectAtIndex:0];
        
        target = sender;
        self.frame = tframe;

    }
    return self;
    
    
    
}


-(void)drawRect:(CGRect)rect {
    
    
    
    
}


-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr {
    
    
    NSLog(@"인포딕 %@", rowinfoArr);

    
    self.row_arr =  rowinfoArr;
    NSLog(@"수정  %ld", (unsigned long)[self.row_arr   count]);
    
    if([self.subviews count] < 1) {
        
        self.row_arr =  rowinfoArr;
        
        [self  addSubview:[self scrollcontainView]];
    }
    
}





- (UIView*)scrollcontainView
{
    UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT])] ;
    
    {
        iCarousel *pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT])];
        pageView.dataSource = self;
        pageView.delegate = self;
        pageView.type = iCarouselTypeLinear;
        pageView.decelerationRate = 0.40f;
        
        [crcontainview addSubview:pageView];
    
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [Common_Util DPRateOriginVAL:BRANDBANNERTOP_HEIGHT-20], APPFULLWIDTH, 20)];
        self.pageControl.numberOfPages = [self.row_arr  count];
        self.pageControl.userInteractionEnabled = NO;
        self.pageControl.pageIndicatorTintColor = [Mocha_Util getColor:@"F4F4F4"];
        self.pageControl.currentPageIndicatorTintColor = [Mocha_Util getColor:@"A4DD00"];
        [crcontainview addSubview:self.pageControl];
    }
    
    return crcontainview;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return [self.row_arr count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  carousel.frame.size.width   , carousel.frame.size.height)];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0,   carousel.frame.size.width  , carousel.frame.size.height)];
    
    imageView.image = [UIImage imageNamed:@"noimg_120.png"];
    [containerView addSubview:imageView];
    
    
    NSString *imageURL = [[self.row_arr objectAtIndex:index] objectForKey:@"imageUrl"];
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = fetchedImage;
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

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionVisibleItems:
            return [self.row_arr count];
        default:
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    self.pageControl.currentPage = carousel.currentItemIndex;
}


- (void)bannerButtonClicked:(id)sender
{
    NSLog(@"click tag: %ld",(unsigned long)[((UIButton *)sender) tag]);
    
    //calltype N andCnum 은 GTM 로깅용도
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]] andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"Main_WeeklyBestDealNo1"];
    
}

@end
