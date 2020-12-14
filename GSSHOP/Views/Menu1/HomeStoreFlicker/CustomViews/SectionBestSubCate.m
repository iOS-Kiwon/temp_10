//
//  SectionBestSubCate.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 11. 23..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionBestSubCate.h"
#import "SectionView.h"

@implementation SectionBestSubCate
@synthesize carouselSubCate;
@synthesize target;
@synthesize indexSeletedSub;
@synthesize constViewOrigin;
@synthesize viewBg;

-(void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
    arrSubCateInfo = [[NSMutableArray alloc] init];
    
    
    self.carouselSubCate.type = iCarouselTypeLinear;
    //self.carouselSubCate.decelerationRate = 0.80f;
    self.carouselSubCate.vertical = YES;
    self.carouselSubCate.bounceDistance = 0.5;
    self.constViewOrigin.constant = APPFULLHEIGHT;
    
}

-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andSeletedIndex:(NSInteger)index andSeletedSubIndex:(NSInteger)indexSub{
    [arrSubCateInfo removeAllObjects];
    
    if (NCA([rowinfo objectForKey:@"subProductList"]) &&
        NCO([[rowinfo objectForKey:@"subProductList"] objectAtIndex:index]) &&
        NCA([[[rowinfo objectForKey:@"subProductList"] objectAtIndex:index] objectForKey:@"subProductList"])
        ) {
        
        NSArray *arrCheck = [[[rowinfo objectForKey:@"subProductList"] objectAtIndex:index] objectForKey:@"subProductList"];
        
        NSLog(@"arrCheck = %@",arrCheck);
        
        if (NCO([arrCheck objectAtIndex:indexSub]) && [NCS([[arrCheck objectAtIndex:indexSub] objectForKey:@"promotionName"]) length] > 0) {
            self.indexSeletedSub = indexSub;
            
            [arrSubCateInfo addObjectsFromArray:arrCheck];
            
        }
        
        
        
        
        
    }
    
    [self.carouselSubCate reloadData];
    
    if ([arrSubCateInfo count] > 0) {
        [self.carouselSubCate scrollToItemAtIndex:indexSub animated:YES];
    }
    
}

-(void)bestSubCateShow:(BOOL)isShow andCateHeaderShow:(BOOL)isHeaderShow{
    
    [self layoutIfNeeded];
    
    if (isShow) {
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.viewBg.alpha = 0.6f;
                             
                         }
                         completion:^(BOOL finished){
                             //한번에 해도 되는데 위의 scrollToItemAtIndex 부분이 어색하게 보여서 2단으로 나눔
                             
                             if (finished == YES) {
                                 [UIView animateWithDuration:0.2
                                                       delay:0
                                                     options:UIViewAnimationOptionBeginFromCurrentState
                                                  animations:(void (^)(void)) ^{
                                                      self.constViewOrigin.constant = APPFULLHEIGHT - 255.0;
                                                      [self layoutIfNeeded];
                                                      
                                                  }
                                                  completion:^(BOOL finished){
                                                      
                                                  }];
                             }
                            
                             
                             
                         }];
        
    }else{
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.viewBg.alpha = 0.0f;
                             self.constViewOrigin.constant = APPFULLHEIGHT;
                             [self layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished){
                             
                             if ([self.target respondsToSelector:@selector(FPCDisplaySubCategoryView:andCateHeaderShow:)]) {
                                 [self.target FPCDisplaySubCategoryView:NO andCateHeaderShow:isHeaderShow];
                             }
                             
                         }];
    }
}


-(IBAction)onBtnCate:(id)sender{
    NSInteger senderTag = [(UIButton *)sender tag];
    
    
    
    
    
    if (senderTag == 100) {
        
        [self bestSubCateShow:NO andCateHeaderShow:NO];
        
        if ([self.target respondsToSelector:@selector(onBtnCateSub:withInfoDic:)]) {
            
            if (NCA(arrSubCateInfo) && [arrSubCateInfo count] > self.carouselSubCate.currentItemIndex ) {
            
                [self.target onBtnCateSub:self.carouselSubCate.currentItemIndex withInfoDic:[arrSubCateInfo objectAtIndex:self.carouselSubCate.currentItemIndex]];
                
                
                if (NCO([[arrSubCateInfo objectAtIndex:self.carouselSubCate.currentItemIndex] objectForKey:@"wiseLog"]) && [[[arrSubCateInfo objectAtIndex:self.carouselSubCate.currentItemIndex] objectForKey:@"wiseLog"] hasPrefix:@"http://"]) {
                    
                    NSLog(@"subsub wiselog = %@",[[arrSubCateInfo objectAtIndex:self.carouselSubCate.currentItemIndex] objectForKey:@"wiseLog"]);
                    ////탭바제거
                    [ApplicationDelegate wiseAPPLogRequest:[[arrSubCateInfo objectAtIndex:self.carouselSubCate.currentItemIndex] objectForKey:@"wiseLog"]];
                }
            }
            
            
            
        }
        
        
    }else{
        
        [self bestSubCateShow:NO andCateHeaderShow:YES];
        
    }
}



#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [arrSubCateInfo count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
    
    UILabel *lblCategory = nil;
    
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  APPFULLWIDTH   , 44.0)];
        
        view.backgroundColor = [UIColor clearColor];
        
        lblCategory = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height)];
        lblCategory.font = [UIFont systemFontOfSize:17.0];
        lblCategory.textAlignment = NSTextAlignmentCenter;
        lblCategory.textColor = [Mocha_Util getColor:@"333333"];
        
        [view addSubview:lblCategory];
        NSLog(@"");
    }else{
        
        for(id viewSub in view.subviews){
            if ([viewSub isKindOfClass:[UILabel class]])
            {
                lblCategory = (UILabel *)viewSub;
            }
        }
        
        NSLog(@"");
    }
    
    lblCategory.text = NCS([[arrSubCateInfo objectAtIndex:index] objectForKey:@"promotionName"]);
    
    return view;
    
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
            return NO;
        case iCarouselOptionVisibleItems:
            return 9;
        default:
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    NSLog(@"");
    
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"didSelectItemAtIndex = %lu",(long)index);
}



@end
