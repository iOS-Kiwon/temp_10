//
//  SectionNO1typeView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 4. 3..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//







#import "SectionNO1typeView.h"
#import "AppDelegate.h"


@interface SectionNO1typeView () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end



@implementation SectionNO1typeView



//@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize  target;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
}


- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe
{
    
    self = [super init];
    if (self)
    {
        
        
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SectionNO1typeView" owner:self options:nil];
        
        self = [nibs objectAtIndex:0];
        
        target = sender;
        self.frame = tframe;

    }
    return self;
    
    
    
}


-(void)drawRect:(CGRect)rect {
    
    
    
    
}


-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr {
    
    
    NSLog(@"dic info: %@", rowinfoArr);

    
    self.row_arr =  rowinfoArr; 
 
    if([self.subviews count] < 1) {
        
        self.row_arr =  rowinfoArr;
        
        [self  addSubview:[self scrollcontainView]];
    }
     
}





- (UIView*)scrollcontainView
{
    UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH, [Common_Util DPRateVAL:172 withPercent:88])] ;
    
    {
        iCarousel *pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateVAL:150 withPercent:88])];
        pageView.dataSource = self;
        pageView.delegate = self;
        pageView.type = iCarouselTypeLinear;
        pageView.decelerationRate = 0.40f;
        
        [crcontainview addSubview:pageView];
        
    
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [Common_Util DPRateVAL:150 withPercent:88], APPFULLWIDTH, [Common_Util DPRateVAL:20 withPercent:50])];
        self.pageControl.numberOfPages = [self.row_arr  count];
        
        self.pageControl.pageIndicatorTintColor = [Mocha_Util getColor:@"C9C9C9"];
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
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  carousel.frame.size.width-(carousel.frame.size.width/8)   , carousel.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( [Common_Util DPRateOriginVAL:4], 0,   carousel.frame.size.width-(carousel.frame.size.width/8)-([Common_Util DPRateOriginVAL:4]*2) , carousel.frame.size.height)];
    
    imageView.image = [UIImage imageNamed:@"noimg_320.png"];
    [containerView addSubview:imageView];

    
    NSString *imageURL = NCS([[self.row_arr objectAtIndex:index] objectForKey:@"imageUrl"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = fetchedImage;
            });
            
                                      }
                                  }];
   
    [imageView.layer setMasksToBounds:NO];
    imageView.layer.shadowOffset = CGSizeMake(0, 0);
    imageView.layer.shadowRadius = 0.0;
    imageView.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    imageView.layer.borderWidth = 1;
    
    
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
    NSLog(@"넘버%ld",(unsigned long)[((UIButton *)sender) tag]);
    
     [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"Main_WeeklyBestDealNo1"   ];

}

@end
