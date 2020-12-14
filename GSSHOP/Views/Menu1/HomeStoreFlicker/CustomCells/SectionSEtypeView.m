//
//  SectionSEtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 9. 7..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionSEtypeView.h"
#import "AppDelegate.h"

@interface SectionSEtypeView () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation SectionSEtypeView
@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize  target;

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe
{
    
    self = [super init];
    if (self)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SectionSEtypeView" owner:self options:nil];
        
        self = [nibs objectAtIndex:0];
        
        target = sender;
        self.frame = tframe;
        
        
    }
    return self;
    
    
    
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if (self.row_arr == nil) {
        self.row_arr = [[NSMutableArray alloc] init];
    }
    
    
}



-(void) setCellInfoNDrawData:(NSArray*) rowinfoArr {

    
    self.backgroundColor = [UIColor clearColor];
    [self.row_arr removeAllObjects];
    

    
    if ([rowinfoArr count] > 1) {
        
        if ([rowinfoArr count] == 2) {
            isOnlyTwoItem = YES;
            [self.row_arr addObjectsFromArray:rowinfoArr];
            [self.row_arr addObjectsFromArray:rowinfoArr];
        }else{
            [self.row_arr addObjectsFromArray:rowinfoArr];
        }
        
        
        [self  addSubview:[self scrollcontainView]];
        
    }else{
        
        [self.row_arr addObjectsFromArray:rowinfoArr];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0,   APPFULLWIDTH,[Common_Util DPRateOriginVAL:160.0])];
        
        imageView.image = [UIImage imageNamed:@"noimg_320.png"];
        [self addSubview:imageView];

        
        if(NCA(self.row_arr ) && ([self.row_arr count] == 1) && [[self.row_arr objectAtIndex:0] objectForKey:@"imageUrl"] != nil){
            NSString *imageURL = NCS([[self.row_arr objectAtIndex:0] objectForKey:@"imageUrl"]);
            [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [imageURL isEqualToString:strInputURL]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isInCache)
                                              {
                                                  imageView.image = fetchedImage;
                                              }
                                              else
                                              {
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
        
        
        [imageView.layer setMasksToBounds:NO];
        imageView.layer.shadowOffset = CGSizeMake(0, 0);
        imageView.layer.shadowRadius = 0.0;
        imageView.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
        imageView.layer.borderWidth = 1;
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [self addSubview:button];
        
        [button addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag =   0;

    }

    
    
}

- (UIView*)scrollcontainView
{
    
    UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  0, APPFULLWIDTH,[Common_Util DPRateOriginVAL:152])] ;
    
    crcontainview.backgroundColor = [UIColor clearColor];
    
    {
        pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateVAL:136 withPercent:88])];
        pageView.dataSource = self;
        pageView.delegate = self;
        pageView.type = iCarouselTypeLinear;
        pageView.decelerationRate = 0.40f;
        
        pageView.backgroundColor = [UIColor clearColor];
        
        [crcontainview addSubview:pageView];
        
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [Common_Util DPRateVAL:136 withPercent:88], APPFULLWIDTH, [Common_Util DPRateVAL:20 withPercent:100])];
        
        if (isOnlyTwoItem) {
            self.pageControl.numberOfPages = 2;
        }else{
            self.pageControl.numberOfPages = [self.row_arr  count];
        }
        
        
        
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
    
    containerView.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( [Common_Util DPRateOriginVAL:4], 0,   carousel.frame.size.width-(carousel.frame.size.width/8)-([Common_Util DPRateOriginVAL:4]*2) , carousel.frame.size.height)];
    
    imageView.image = [UIImage imageNamed:@"noimg_320.png"];
    [containerView addSubview:imageView];
    
    if(NCA(self.row_arr) && self.row_arr.count > index && [[self.row_arr objectAtIndex:index] objectForKey:@"imageUrl"] != nil){
        NSString *imageURL = NCS([[self.row_arr objectAtIndex:index] objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                                          {
                                              imageView.image = fetchedImage;
                                          }
                                          else
                                          {
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

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (isOnlyTwoItem && carousel.currentItemIndex > 1) {
        
        self.pageControl.currentPage = carousel.currentItemIndex -2;
        
    }else{
        self.pageControl.currentPage = carousel.currentItemIndex;
    }
    
}

- (void)bannerButtonClicked:(id)sender
{
    if(NCA(self.row_arr) && self.row_arr.count > [((UIButton *)sender) tag]){
    
        [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"SE"];
    }
    
}

-(void)dealloc{
    self.row_arr = nil;
    pageView = nil;
    [self.imageLoadingOperation cancel];
    self.imageLoadingOperation = nil;
}

@end
