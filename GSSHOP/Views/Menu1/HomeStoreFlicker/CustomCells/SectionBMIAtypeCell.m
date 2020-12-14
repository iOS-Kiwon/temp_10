//
//  SectionBMIAtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 24..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionBMIAtypeCell.h"
#import "AppDelegate.h"

@interface SectionBMIAtypeCell () <iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation SectionBMIAtypeCell
@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize  target;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
}

-(void) prepareForReuse {
    [super prepareForReuse];
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }

    self.contentView.backgroundColor = [UIColor clearColor];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSMutableArray*) rowinfoArr  {
    
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *imgTodayHot = [[UIImageView alloc] initWithFrame:CGRectMake((APPFULLWIDTH/2.0 - 134.0/2.0), 0.0, 134.0, 22.0)];
    [imgTodayHot setImage:[UIImage imageNamed:@"tit_hot1.png"]];

    if(NCA(rowinfoArr)){
        self.row_arr =  rowinfoArr;
        [self.contentView addSubview:imgTodayHot];
        [self.contentView  addSubview:[self scrollcontainView]];
    }
}


- (UIView*)scrollcontainView{
    
    UIView *crcontainview = [[UIView alloc] initWithFrame:CGRectMake(0,  30, APPFULLWIDTH, [Common_Util DPRateOriginVAL:240.0] + 10)] ;
    
    //셀이1개 일경우 iCarousel 사용하면 가로스크롤 이벤트를 iCarousel이 가져가 버림 따라서 한개일때는 그냥 뷰로 붙이는게 깔끔한듯 더불어 셀이1일경우 pageControl
    
    if ([self.row_arr  count] > 1) {
        iCarousel *pageView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:240.0] + 10)];
        pageView.dataSource = self;
        pageView.delegate = self;
        pageView.type = iCarouselTypeLinear;
        pageView.decelerationRate = 0.40f;
        
        [crcontainview addSubview:pageView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [Common_Util DPRateOriginVAL:230], APPFULLWIDTH, [Common_Util DPRateVAL:20 withPercent:50])];
        self.pageControl.numberOfPages = [self.row_arr  count];
        self.pageControl.pageIndicatorTintColor = [Mocha_Util getColor:@"C9C9C9"];
        self.pageControl.currentPageIndicatorTintColor = [Mocha_Util getColor:@"A4DD00"];
        
        NSLog(@"[self.row_arr  count][self.row_arr  count] = %lu",(long)[self.row_arr  count]);
        
        [crcontainview addSubview:self.pageControl];
    }else{
        
        [crcontainview addSubview:[self addImageViewsWithArrayIndex:0]];
        
    }
    
    
    return crcontainview;
}

-(UIView *)addImageViewsWithArrayIndex:(NSInteger)index{
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  APPFULLWIDTH   , [Common_Util DPRateOriginVAL:250.0])];
    
    if([self.row_arr count] < index) //2016016 parksegun 예외추가
        return nil;
    
    NSArray *arrProduct = [[self.row_arr objectAtIndex:index] objectForKey:@"subProductList"];
    
    
    
    if (NCA(arrProduct) && [arrProduct count] > 0) {
        UIImageView *imageView01 = [[UIImageView alloc] initWithFrame:CGRectMake( 10.0, 0.0,   APPFULLWIDTH/2.0 - 14.0, [Common_Util DPRateOriginVAL:240.0])];
        
        imageView01.image = [UIImage imageNamed:@"noimg_500.png"];
        [containerView addSubview:imageView01];
        
        NSString *imageURL = NCS([[arrProduct objectAtIndex:0] objectForKey:@"imageUrl"]);
        
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                  {
                      imageView01.image = fetchedImage;
                  }
                  else
                  {
                      imageView01.alpha = 0;
                      imageView01.image = fetchedImage;
                      
                      
                      [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           
                                           imageView01.alpha = 1;
                                           
                                       }
                                       completion:^(BOOL finished) {
                                           
                                       }];
                  }

                });
                            }
          }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = imageView01.frame;
        [containerView addSubview:button];
        
        [button addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag =   index*10 + 0 ;
        
    }
    
    if (NCA(arrProduct) && [arrProduct count] > 1) {
        UIImageView *imageView02 = [[UIImageView alloc] initWithFrame:CGRectMake( APPFULLWIDTH/2.0 + 4.0, 0.0, APPFULLWIDTH/2.0 - 14.0, [Common_Util DPRateOriginVAL:240.0]/2.0 - 4.0)];
        
        imageView02.image = [UIImage imageNamed:@"noimg_500.png"];
        [containerView addSubview:imageView02];
        
        NSString *imageURL02 = NCS([[arrProduct objectAtIndex:1] objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL02 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL02 isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                  {
                      imageView02.image = fetchedImage;
                  }
                  else
                  {
                      imageView02.alpha = 0;
                      imageView02.image = fetchedImage;
                      
                      
                      
                      
                      [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           
                                           imageView02.alpha = 1;
                                           
                                       }
                                       completion:^(BOOL finished) {
                                           
                                       }];
                  }
                });
                  
            }
          }];
        
        UIButton *button02 = [UIButton buttonWithType:UIButtonTypeCustom];
        button02.frame = imageView02.frame;
        [containerView addSubview:button02];
        
        [button02 addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button02.tag =   index*10 + 1;
        
    }
    
    
    if (NCA(arrProduct) && [arrProduct count] > 2) {
        UIImageView *imageView03 = [[UIImageView alloc] initWithFrame:CGRectMake( APPFULLWIDTH/2.0 + 4.0, [Common_Util DPRateOriginVAL:240.0]/2.0 + 4.0, APPFULLWIDTH/2.0 - 14.0, [Common_Util DPRateOriginVAL:240.0]/2.0 - 4.0)];
        
        imageView03.image = [UIImage imageNamed:@"noimg_500.png"];
        [containerView addSubview:imageView03];
        
        NSString *imageURL03 = NCS([[arrProduct objectAtIndex:2] objectForKey:@"imageUrl"]);
        
        [ImageDownManager blockImageDownWithURL:imageURL03 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL03 isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                  {
                      imageView03.image = fetchedImage;
                  }
                  else
                  {
                      imageView03.alpha = 0;
                      imageView03.image = fetchedImage;
                      
                      
                      
                      
                      [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           
                                           imageView03.alpha = 1;
                                           
                                       }
                                       completion:^(BOOL finished) {
                                           
                                       }];
                  }
                });
                  
            }
          }];
        
        UIButton *button03 = [UIButton buttonWithType:UIButtonTypeCustom];
        button03.frame = imageView03.frame;
        [containerView addSubview:button03];
        
        [button03 addTarget:self action:@selector(bannerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button03.tag =   index*10 + 2;
    }

    
    return containerView;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.row_arr count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    UIView *containerView = nil;
    
    if (view == nil) {
        containerView = [self addImageViewsWithArrayIndex:index];
    }else{
        //셀 재사용시 다시 각 오브젝트 잡아서 설정해야하지만 iCarouselOptionVisibleItems 옵션이 카운트 갰수이므로 일단 패스
        return view;
    }
    
    
    
    
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
   
        NSDictionary *dic = [[[self.row_arr objectAtIndex:[((UIButton *)sender) tag]/10] objectForKey:@"subProductList"] objectAtIndex:[((UIButton *)sender) tag]%10];
    

        [target dctypetouchEventTBCell:dic andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:[NSString stringWithFormat:@"%d_%d_%@", (int)[self getIndexPath].row, (int)[((UIButton *)sender) tag],
                                                                                                                                                [dic objectForKey:@"linkUrl" ] ]
     
     ];
    }
    
}


@end
