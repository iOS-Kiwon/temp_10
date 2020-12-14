//
//  SectionPSLtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 24..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionPSLtypeCell.h"
#import "AppDelegate.h"

@interface SectionPSLtypeCell () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation SectionPSLtypeCell
@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize  target;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr {

    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    self.backgroundColor = [UIColor clearColor];

    UIImageView *imgTodayHot = [[UIImageView alloc] initWithFrame:CGRectMake((APPFULLWIDTH/2.0 - 116.0/2.0), 0.0, 116.0, 25.0)];
    [imgTodayHot setImage:[UIImage imageNamed:@"tit_mart_hot.png"]];
    
    self.row_arr =  rowinfoArr;
    
    
    [self.contentView  addSubview:imgTodayHot];
    [self.contentView  addSubview:[self scrollcontainView]];
    
}


-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
}



- (UIView*)scrollcontainView
{
    
    UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  32, APPFULLWIDTH, [Common_Util DPRateVAL:172 withPercent:88])] ;
    
    crcontainview.backgroundColor = [UIColor clearColor];
    
    {
        iCarousel *pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateVAL:150 withPercent:88])];
        pageView.dataSource = self;
        pageView.delegate = self;
        pageView.type = iCarouselTypeLinear;
        pageView.decelerationRate = 0.40f;
        
        pageView.backgroundColor = [UIColor clearColor];
        
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
    
    containerView.backgroundColor = [UIColor clearColor];

    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( [Common_Util DPRateOriginVAL:4], 0,   carousel.frame.size.width-(carousel.frame.size.width/8)-([Common_Util DPRateOriginVAL:4]*2) , carousel.frame.size.height)];
    
    imageView.image = [UIImage imageNamed:@"noimg_320.png"];
    [containerView addSubview:imageView];
    
    if([self.row_arr count] < index)
        return view;
    
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

- (void)bannerButtonClicked:(id)sender
{
    NSLog(@"셀번호1 %d",   (int)[self getIndexPath].row);
    
    NSLog(@"셀번호 %d",  (int)[((UIButton *)sender) tag])
    
    if(NCO(self.row_arr))
    {
        BOOL isf  =   ([[[self.row_arr objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"productName"] length] > 1);


        [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:[NSString stringWithFormat:@"%d_%d_%@", (int)[self getIndexPath].row, (int)[((UIButton *)sender) tag],
                                                                                                                                                   (isf)?                                                [[self.row_arr objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"productName" ] : [[self.row_arr objectAtIndex:[((UIButton *)sender) tag]] objectForKey:@"linkUrl" ] ]
         
         ];
    }
    
}



@end
