//
//  SectionBAN_SLD_GBCtypeCell.m
//  GSSHOP
//
//  Created by admin on 2018. 2. 8..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_SLD_GBCtypeCell.h"
#import "AppDelegate.h"
#import "SectionDSLtypeSubProductView.h"

@interface SectionBAN_SLD_GBCtypeCell () <iCarouselDataSource, iCarouselDelegate>
@end

@implementation SectionBAN_SLD_GBCtypeCell
@synthesize target;
@synthesize carouselProduct = _carouselProduct;
@synthesize lblTotalPage;
@synthesize lblCurrentPage;
@synthesize viewPaging, autoRollingValue, isRandom;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.carouselProduct.type = iCarouselTypeLinear;
    self.carouselProduct.decelerationRate = 0.40f;
    self.carouselProduct.isAccessibilityElement = NO;
    self.lblCurrentPage.text = [NSString stringWithFormat:@"1"];
    self.lblTotalPage.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.row_arr count]];
    self.autoRollingValue = 0;
    self.isRandom = NO;
    if (self.row_arr == nil) {
        self.row_arr = [[NSMutableArray alloc] init];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic {    
    self.row_dic = rowinfoDic;
    self.backgroundColor = [UIColor clearColor];
    if (NCA([rowinfoDic objectForKey:@"subProductList"]) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {
        if ([(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] == 2) {
            isOnlyTwoItem = YES;
            [self.row_arr addObjectsFromArray:[rowinfoDic objectForKey:@"subProductList"]];
            [self.row_arr addObjectsFromArray:[rowinfoDic objectForKey:@"subProductList"]];
        }
        else {
            isOnlyTwoItem = NO;
            [self.row_arr addObjectsFromArray:[rowinfoDic objectForKey:@"subProductList"]];
        }
        
        [self.carouselProduct reloadData];
        [self.carouselProduct scrollToItemAtIndex:0 animated:NO];
       
        if(isOnlyTwoItem == YES) {
            self.lblTotalPage.text = @"2";
        }
        else {
            self.lblTotalPage.text = [NSString stringWithFormat:@"%d",(int)[self.row_arr count]];
        }
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)self.carouselProduct.currentItemIndex+1];
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


- (void) prepareForReuse {
    [super prepareForReuse];
    if (self.row_arr == nil) {
        self.row_arr = [[NSMutableArray alloc] init];
    }
    else {
        [self.row_arr removeAllObjects];
    }
    [self.carouselProduct reloadData];
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    self.autoRollingValue = 0;
    self.isRandom = NO;
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
            //return [self.row_arr count];
        default:
            return value;
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    
    if (isOnlyTwoItem && carousel.currentItemIndex > 1) {
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)carousel.currentItemIndex-1];
    }
    else {
        self.lblCurrentPage.text = [NSString stringWithFormat:@"%d",(int)carousel.currentItemIndex+1];
    }
}


-(void)carouselDidScroll:(iCarousel *)carousel {
    if (self.autoRollingValue > 0) {
        [self autoScrollCarousel];
    }
}


-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if ([timerScroll isValid]) {
        [timerScroll invalidate];
        timerScroll = nil;
    }
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:index]  andCnum:[NSNumber numberWithInt:(int)index] withCallType:@"BAN_SLD_GBC"];
}


-(void)runMethod {
    if(self.carouselProduct.currentItemIndex + 1 == [self.row_arr count]) {
        [self.carouselProduct scrollToItemAtIndex:0 animated:YES];
    }
    else {
        [self.carouselProduct scrollToItemAtIndex:self.carouselProduct.currentItemIndex+1 animated:YES];
    }
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

@end
