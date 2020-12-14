//
//  SectionTSLtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 11..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionSSLtypeCell.h"
#import "AppDelegate.h"
#import "SectionSSLtypeSubview.h"
#import "NSTFCListTBViewController.h"

@interface SectionSSLtypeCell () <iCarouselDataSource, iCarouselDelegate>
@end

@implementation SectionSSLtypeCell
@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize  target;
@synthesize imgBG = _imgBG;

@synthesize view_Default = _view_Default;

@synthesize indexPath;
@synthesize imgSeleted;
@synthesize isOnlyTwo;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carouselProduct.type = iCarouselTypeLinear;

    self.carouselProduct.decelerationRate = 0.40f;
    self.backgroundColor = [UIColor clearColor];
    self.isOnlyTwo = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSDictionary*)rowinfoDic{

    // 이미지 영역:가변 / 하단 부분:고정
    CGFloat imageHeight = [Common_Util DPRateOriginVAL:58];
    CGFloat viewHeight = imageHeight + 355 + 10;

    
    self.view_Default.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH,viewHeight);
    
    self.imgBG.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, imageHeight);
    self.imgContents.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, imageHeight);
    self.imgButton.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, imageHeight);

    self.carouselProduct.frame = CGRectMake(0.0, imageHeight-10, APPFULLWIDTH, 355 + 20);
    
    self.lblView.frame = CGRectMake(APPFULLWIDTH - self.lblView.frame.size.width - 10.0, imageHeight - self.lblView.frame.size.height-15, self.lblView.frame.size.width, self.lblView.frame.size.height);
    
    self.underLine.frame = CGRectMake(0.0, viewHeight-1, APPFULLWIDTH,1);
    
    self.row_dic = rowinfoDic;
    
    self.backgroundColor = [UIColor clearColor];
    
    NSString *imageURL = NCS([self.row_dic objectForKey:@"imageUrl"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache)
                                      {
                                          self.imgContents.image = fetchedImage;
                                      }
                                      else
                                      {
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
                                      
        }
      }];
    
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"]) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {
        
        self.row_arr = [rowinfoDic objectForKey:@"subProductList"];
        
        if (APPFULLWIDTH <= 414 && [self.row_arr count] == 2) { //데이터가 2개뿐이 안들어 왔을경우
            self.isOnlyTwo = YES;
            
            NSMutableArray *arrTwo = [[NSMutableArray alloc] init];
            [arrTwo addObjectsFromArray:[rowinfoDic objectForKey:@"subProductList"]];
            [arrTwo addObjectsFromArray:[rowinfoDic objectForKey:@"subProductList"]];
            
            self.row_arr = [NSArray arrayWithArray:arrTwo];
            [self.carouselProduct reloadData];
            [self.carouselProduct scrollToItemAtIndex:0 animated:NO];
            
        }else if (APPFULLWIDTH > 414 && [self.row_arr count] == 3) { //패드일경우
            [self.carouselProduct reloadData];
            [self.carouselProduct scrollToItemAtIndex:1 animated:NO];
            //self.lblView.hidden = YES;
            //self.carouselProduct.bounces = NO;
            //self.carouselProduct.scrolling = NO;
            
        }else {
            
            [self.carouselProduct reloadData];
            [self.carouselProduct scrollToItemAtIndex:0 animated:NO];
            
        }
        
        
        [self checkNowPages];
        
    }

    
    
}

-(void)checkNowPages{
    if([self.row_arr count] > 1)
    {
        
        if (self.isOnlyTwo == YES) {
            self.lblView.hidden = NO;
            self.lblPage.text = [NSString stringWithFormat:@"%d",(int)(self.carouselProduct.currentItemIndex%2)+1];
            self.lblTotalPage.text = [NSString stringWithFormat:@"/%d",2];
            
        }else{
            self.lblView.hidden = NO;
            self.lblPage.text = [NSString stringWithFormat:@"%d",(int)self.carouselProduct.currentItemIndex+1];
            self.lblTotalPage.text = [NSString stringWithFormat:@"/%d",(int)[self.row_arr count]];
        }
        
        
    }
    else
    {
        self.lblView.hidden = YES;
        self.carouselProduct.bounces = NO;
    }
    
}

-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    self.row_arr = nil;
    [self.carouselProduct reloadData];
    self.imgContents.image = nil;
    self.indexPath = nil;
    self.lblView.hidden = YES;
    self.isOnlyTwo = NO;
}



#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return [self.row_arr count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{

    SectionSSLtypeSubview *subView = nil;
    
    if (view == nil) {
        subView = [[SectionSSLtypeSubview alloc] initWithTarget:target];
    }else{
        subView = (SectionSSLtypeSubview *)view;
        [subView prepareForReuse];
    }
    
    [subView setCellInfoNDrawData:[self.row_arr objectAtIndex:index]];
    
    
    NSLog(@"subView = %@",NSStringFromCGRect(subView.frame));
    
    return subView;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
            if (APPFULLWIDTH > 414) { //패드일경우
                if ([self.row_arr count] > 3) {
                    return YES;
                }else{
                    return NO;
                }
            }else{
            
                if ([self.row_arr count] > 1) {
                    return YES;
                }else{
                    return NO;
                }
            }
            
            
        case iCarouselOptionVisibleItems:
            return 5;
        default:
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    [self checkNowPages];
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    //[target dctypetouchEventTBCell:[self.row_arr objectAtIndex:index]  andCnum:[NSNumber numberWithInt:(int)index] withCallType:@"SSL"];
    
    NSInteger senderTag = index;
    
    SectionSSLtypeSubview *subView = (SectionSSLtypeSubview *)[carousel itemViewAtIndex:index];
    
    
    if ([self.target respondsToSelector:@selector(touchEventSBTCell:andCnum:andCImage:indexPathCell:withCallType:)]) {
        
        if ([self.row_arr count] > senderTag) {
            [self.target touchEventSBTCell:[self.row_arr objectAtIndex:senderTag] andCnum:[NSNumber numberWithInt:(int)senderTag] andCImage:subView.productImage.image indexPathCell:indexPath withCallType:@"SSL"];
        }
    }
    
}


- (void)bannerButtonClicked:(id)sender
{
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"SSL"   ];
    
}

-(IBAction)backGroundButtonClicked:(id)sender{
    [target dctypetouchEventTBCell:self.row_dic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"SSLBACKGROUND"   ];
    
}


@end
