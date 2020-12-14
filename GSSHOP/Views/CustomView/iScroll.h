//
//  iScroll.h
//  GSSHOP
//
//  Created by 조도연 on 2014. 6. 30..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    iScrollTypeLinear = 0,
    iScrollTypeMochaMainStyle,
    iScrollTypeTVSectionStyle,
}
iScrollType;

static int TVSectionStyleHight = 268;

@protocol iScrollDataSource, iScrollDelegate;

@interface iScroll : UIView

@property (nonatomic, weak) id<iScrollDataSource> dataSource;
@property (nonatomic, weak) id<iScrollDelegate> delegate;
@property (nonatomic, assign) iScrollType type;
@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (nonatomic, assign) CGFloat decelerationRate;	//안쓰임
@property (nonatomic, assign) CGFloat scrollOffset;		//안쓰임
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger currentItemIndex;
@property (nonatomic, assign) NSInteger oldItemIndex;
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToItemAtIndexforX:(float)indexposx;
- (UIView *)itemViewAtIndex:(NSInteger)index;
- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadData;
- (void)reloadDataWithIndex:(NSInteger)index;

@end



@protocol iScrollDataSource <NSObject>

- (NSUInteger)numberOfItemsInCarousel:(iScroll *)carousel;
- (UIView *)carousel:(iScroll *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view;

@end


@protocol iScrollDelegate <NSObject>

@optional

- (void)carouselCurrentItemIndexDidChange:(iScroll *)carousel;

// 클릭 처리 (categroy carousel)
- (void)carousel:(iScroll *)carousel didSelectItemAtIndex:(NSInteger)index;

//deprecated
- (void)carouselCurrentItemIndexUpdated:(iScroll *)carousel;

// add by shawn
-(void)carouselMenuItemOffsetDidChange:(UIScrollView *)scrollView;


-(void)carouselMenuItemOffsetDidChangeforEvent:(UIScrollView *)scrollView;

@end
