//
//  iScroll.m
//  GSSHOP
//
//  Created by 조도연 on 2014. 6. 30..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "iScroll.h"




@interface iScroll () <UIScrollViewDelegate>



@property (strong, nonatomic) NSMutableArray *itemViewOrderedArray;
@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger movingToItemIndex;

@end



@implementation iScroll


- (void)setType:(iScrollType)type;
{
    _type = type;
    
    self.contentScrollView.pagingEnabled = (type == iScrollTypeMochaMainStyle);
    
    // UITapGestureRecognizer
    {
        //addTarget 및 removeTarget이 더 좋을듯
        for (int i=0; i<self.numberOfItems; i++)
        {
            UIView *view = [self itemViewAtIndex:i];
            
            for (UIGestureRecognizer *recognizer in view.gestureRecognizers)
            {
                if ([recognizer isMemberOfClass:[UITapGestureRecognizer class]])
                {
                    [view removeGestureRecognizer:recognizer];
                }
            }
        }
        
        if (type == iScrollTypeLinear)
        {
            for (int i=0; i<self.numberOfItems; i++)
            {
                UIView *view = [self itemViewAtIndex:i];
                
                UITapGestureRecognizer*	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
                [view addGestureRecognizer:tapGesture];
            }
        }
        
        
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer*)sender
{
    NSNumber *index = [NSNumber numberWithInteger:[self.itemViewOrderedArray indexOfObject:sender.view]];
    
    [self delayedDidSelectItemAtIndex:index];
    
    [self scrollToItemAtIndex:[index integerValue] animated:YES];
}

- (void)delayedDidSelectItemAtIndex:(NSNumber *)index
{
    if ([self.delegate respondsToSelector:@selector(carousel:didSelectItemAtIndex:)]) [self.delegate carousel:self didSelectItemAtIndex:[index integerValue]];
}

- (NSArray *)visibleItemViews
{
    return [NSArray arrayWithArray:self.itemViewOrderedArray];
}

- (UIView *)itemViewAtIndex:(NSInteger)index
{
    //index를 -1 등으로 세팅 허용
    return ((index < 0 || index >= [self.itemViewOrderedArray count]) ? nil : [self.itemViewOrderedArray objectAtIndex:index]);
}

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    //index를 -1 등으로 세팅 허용
    if (index < 0 || [self.itemViewOrderedArray count] <= index) return;
    
    CGFloat difference = ([self.itemViewOrderedArray count] == index + 1 ? 0 :
                          ((UIView *)[self.itemViewOrderedArray objectAtIndex:index + 1]).frame.origin.x -
                          ((UIView *)[self.itemViewOrderedArray objectAtIndex:index]).frame.origin.x);
    
    [(UIView *)[self.itemViewOrderedArray objectAtIndex:index] removeFromSuperview];
    [self.itemViewOrderedArray removeObjectAtIndex:index];
    
    if (animated)
    {
        [UIView animateWithDuration:0.2
                         animations:^(){
                             
                             for (int i=(int)index, j=(int)[self.itemViewOrderedArray count]; i<j; i++)
                             {
                                 UIView *view = [self.itemViewOrderedArray objectAtIndex:i];
                                 view.center = CGPointMake(view.center.x - difference, view.center.y);
                             }
                         }
                         completion:^(BOOL finished){
                         }];
    }
    else
    {
        for (int i=(int)index, j=(int)[self.itemViewOrderedArray count]; i<j; i++)
        {
            UIView *view = [self.itemViewOrderedArray objectAtIndex:i];
            view.center = CGPointMake(view.center.x - difference, view.center.y);
        }
    }
}

- (BOOL)dragging
{
    return self.contentScrollView.dragging;
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupDefault];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault
{
    self.clipsToBounds = YES;
    self.autoresizesSubviews = YES;
    self.backgroundColor = [UIColor clearColor];
    
    {
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:self.contentScrollView];
        
        self.contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.contentScrollView.backgroundColor = [UIColor clearColor];
        
        self.contentScrollView.scrollEnabled = YES;
        self.contentScrollView.pagingEnabled = YES;
        
        self.contentScrollView.bounces = YES;
        self.contentScrollView.alwaysBounceHorizontal = YES;
        self.contentScrollView.alwaysBounceVertical = NO;
        
        self.contentScrollView.showsHorizontalScrollIndicator = NO;
        self.contentScrollView.showsVerticalScrollIndicator = NO;
        
        self.contentScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        self.contentScrollView.scrollsToTop = NO;
        
        self.contentScrollView.delegate = self;
    }
    
    self.oldItemIndex = -1;
    self.currentItemIndex = 0;
    self.numberOfItems = 0;
    
    self.itemViewOrderedArray = [[NSMutableArray alloc] init];
    
    self.movingToItemIndex = -1;
    
    _type = -1;
}

//상단 Linear iscroll 옵셋 실시간 교정을 위한 추가 -by shawn
#pragma UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //상단 scroll offset교정을 위한
    if(_type == iScrollTypeMochaMainStyle){
        if(scrollView.contentOffset.x != 0.000000){
            if ([self.delegate respondsToSelector:@selector(carouselMenuItemOffsetDidChange:)]) [self.delegate carouselMenuItemOffsetDidChange:scrollView];
        }
    }
    
    else  if(_type == iScrollTypeTVSectionStyle){
        
        if(scrollView.contentOffset.x  > (self.numberOfItems * TVSectionStyleHight)-APPFULLWIDTH){
            
            NSLog(@"opttx  = %f", scrollView.contentOffset.x);
            if ([self.delegate respondsToSelector:@selector(carouselMenuItemOffsetDidChange:)]) [self.delegate carouselMenuItemOffsetDidChange:scrollView];
        }
        
    }
    
    
}



//
- (void)setDataSource:(id<iScrollDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
}


- (void)reloadDataWithIndex:(NSInteger)index
{
    _currentItemIndex = index;
    
    [self reloadData];
}


- (void)reloadData
{
    NSLog(@"CHODY_iScroll reloadData");
    
    // selector 수행 롤백-cancel
    [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    
    // 내용 뷰 삭제
    for (UIView *subview in self.contentScrollView.subviews)
    {
        [subview removeFromSuperview];
    }
    [self.itemViewOrderedArray removeAllObjects];
    
    // 데이터소스 없으면 중지
    if (!self.dataSource) return;
    
    // 내용 뷰 로드
    {
        self.numberOfItems = [self.dataSource numberOfItemsInCarousel:self];
        
        CGFloat totalWidth = 0;
        for (int i=0; i<self.numberOfItems; i++)
        {
            UIView *itemView = [self.dataSource carousel:self viewForItemAtIndex:i reusingView:nil];
            if (itemView == nil) itemView = [[UIView alloc] initWithFrame:CGRectZero];
            
            itemView.frame = CGRectMake(totalWidth, itemView.frame.origin.y, itemView.frame.size.width, itemView.frame.size.height);
            [self.contentScrollView addSubview:itemView];
            
            totalWidth += itemView.frame.size.width;
            
            [self.itemViewOrderedArray addObject:itemView];
        }
        
        
        //아이패드에서 상단메뉴 좌우 이동막음 -20141208
        if(_type == iScrollTypeLinear){
            
            if(totalWidth<self.frame.size.width){
                
                self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x,self.contentScrollView.frame.origin.y, totalWidth,  self.contentScrollView.frame.size.height);
                self.contentScrollView.scrollEnabled = NO;
            }else {
                
                self.contentScrollView.frame = CGRectMake(self.contentScrollView.frame.origin.x,self.contentScrollView.frame.origin.y, self.frame.size.width,  self.contentScrollView.frame.size.height);
                self.contentScrollView.scrollEnabled = YES;
            }
        }
        
        self.contentScrollView.contentSize = CGSizeMake(totalWidth, self.contentScrollView.frame.size.height);
        
    }
    
    
    // UITapGestureRecognizer
    {
        //addTarget 및 removeTarget이 더 좋을듯
        for (int i=0; i<self.numberOfItems; i++)
        {
            UIView *view = [self itemViewAtIndex:i];
            
            for (UIGestureRecognizer *recognizer in view.gestureRecognizers)
            {
                if ([recognizer isMemberOfClass:[UITapGestureRecognizer class]])
                {
                    [view removeGestureRecognizer:recognizer];
                }
            }
        }
        
        if (self.type == iScrollTypeLinear)
        {
            for (int i=0; i<self.numberOfItems; i++)
            {
                UIView *view = [self itemViewAtIndex:i];
                
                UITapGestureRecognizer*	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
                [view addGestureRecognizer:tapGesture];
            }
        }
    }
    
    // 초기 인덱스
    {
        self.oldItemIndex = (int)self.currentItemIndex;
        int newItemIndex;
        if (self.numberOfItems > self.currentItemIndex) newItemIndex = (int)self.oldItemIndex;
        else newItemIndex = 0;
        
        self.currentItemIndex = newItemIndex;
        
        //delegate 호출 (reloadData 시에 무조건 초기 페이지에 대해 delegate 호출)
        //지금 현재 라이브러리 활용 소스가 index = -1 로 한 후 다시 index 지정하므로 이 부분 막는다.

        if (self.oldItemIndex == newItemIndex)
        {

            [self delayedCurrentItemDidChangeToIndex:[NSNumber numberWithInteger:newItemIndex]];
        }

    }
}


- (void)setCurrentItemIndex:(NSInteger)index
{
    
    
    
    self.oldItemIndex = (int)_currentItemIndex;
    
    _currentItemIndex = index;
    
    if (!self.dataSource || self.numberOfItems <= 0) return;
    
    NSLog(@"CHODY_iScroll setCurrentItemIndex %ld", (long)index);
    
    
    
    
    
    if (self.type == iScrollTypeTVSectionStyle)
    {
    }
    else
        // contentOffset 조정
    {
        
        //index를 -1 등으로 세팅 허용
        if (index < 0 || index >= self.numberOfItems) return;
        UIView *curView = [self itemViewAtIndex:index];
        
        CGFloat newContentOffsetX = curView.center.x - self.contentScrollView.frame.size.width / 2.0;
        
        if (newContentOffsetX < 0)
            newContentOffsetX = 0;
        else if (newContentOffsetX + self.contentScrollView.frame.size.width > self.contentScrollView.contentSize.width)
            newContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width;
        
        self.contentScrollView.contentOffset = CGPointMake(newContentOffsetX, 0);
    }
    
    
    
    
    
    // delegate 호출 (페이지 변경 있는 경우만 호출)
    if (self.oldItemIndex != _currentItemIndex)
    {
        [self delayedCurrentItemDidChangeToIndex:[NSNumber numberWithInteger:_currentItemIndex]];
    }
}


- (void)delayedCurrentItemDidChangeToIndex:(NSNumber *)number
{
    NSLog(@"CHODY_iScroll carouselCurrentItemIndexDidChange %d", [number intValue]);
    
    if ([self.delegate respondsToSelector:@selector(carouselCurrentItemIndexDidChange:)]) [self.delegate carouselCurrentItemIndexDidChange:self];
    if ([self.delegate respondsToSelector:@selector(carouselCurrentItemIndexUpdated:)]) [self.delegate carouselCurrentItemIndexUpdated:self];
}



//iScrollTypeTVSectionStyle 전용
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    
    if (self.type == iScrollTypeTVSectionStyle) {
        int pageWidth = TVSectionStyleHight;
        
        
        if(scrollView.contentOffset.x  > (self.numberOfItems * pageWidth)-APPFULLWIDTH){
            return;
        }
        int pageX = self.currentItemIndex*pageWidth-scrollView.contentInset.left;
        if (targetContentOffset->x<pageX) {
            if (self.currentItemIndex>0) {
                self.currentItemIndex--;
            }
        }
        else if(targetContentOffset->x>pageX){
            if (self.currentItemIndex<self.numberOfItems) {
                self.currentItemIndex++;
                
            }
        }
        
        
        
        targetContentOffset->x = self.currentItemIndex*pageWidth-scrollView.contentInset.left;

    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if(_type == iScrollTypeTVSectionStyle){
        if(scrollView.contentOffset.x != 0.000000){
            if ([self.delegate respondsToSelector:@selector(carouselMenuItemOffsetDidChangeforEvent:)]) [self.delegate carouselMenuItemOffsetDidChangeforEvent:scrollView];
        }
    }
    
    
    else {
        if (!decelerate)
        {
            [self movingEndJob:scrollView];
        }
        
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.type != iScrollTypeTVSectionStyle) {
        [self movingEndJob:scrollView];
    }
}


- (void)movingEndJob:(UIScrollView *)scrollView
{
    if (self.type == iScrollTypeMochaMainStyle)
    {
        CGFloat contentCenterX = scrollView.contentOffset.x + scrollView.frame.size.width / 2.0;
        CGFloat minDifference = scrollView.frame.size.width;
        int viewIndex = 0;
        
        for (int i=0; i<self.numberOfItems; i++)
        {
            UIView *view = [self itemViewAtIndex:i];
            CGFloat difference = ABS(view.center.x - contentCenterX);
            
            if (minDifference >= difference)
            {
                minDifference = difference;
                viewIndex = i;
            }
        }
        
        NSLog(@"CHODY_iScroll movingEndJob %d (offset = %d)", viewIndex, (int)scrollView.contentOffset.x);
        
        self.currentItemIndex = viewIndex;
    }
    else if (self.type == iScrollTypeTVSectionStyle)
    {
       
    }
    else
    {
        
    }
    
}


- (void)scrollToItemAtIndexforX:(float)indexposx   {
    

    
    //index를 -1 등으로 세팅 허용
    if (indexposx < 0 || indexposx >= self.numberOfItems) return;
    
    if (self.type == iScrollTypeTVSectionStyle)
    {
        
        UIView *curView = [self itemViewAtIndex: fabs(indexposx)  ];
        
        float addx = indexposx - fabs(indexposx);
        
        CGFloat newContentOffsetX =  (addx*curView.frame.size.width)  ;
        
        if (newContentOffsetX < 0)
            newContentOffsetX = 0;
        else if (newContentOffsetX + self.contentScrollView.frame.size.width > self.contentScrollView.contentSize.width)
            newContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width;
        
        
        

        
        [UIView animateWithDuration:0.2
                         animations:^(){
                             
                             self.contentScrollView.contentOffset = CGPointMake(newContentOffsetX, 0);
                         }
                         completion:^(BOOL finished){
                             

                         }];
        
        
        
    }else {
        
        
        UIView *curView = [self itemViewAtIndex: fabs(indexposx)  ];
        
        float addx = indexposx - fabs(indexposx);
        
        CGFloat newContentOffsetX = curView.center.x + (addx*curView.frame.size.width) - self.contentScrollView.frame.size.width / 2.0;
        
        if (newContentOffsetX < 0)
            newContentOffsetX = 0;
        else if (newContentOffsetX + self.contentScrollView.frame.size.width > self.contentScrollView.contentSize.width)
            newContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width;
        
        
        
        self.contentScrollView.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.2
                         animations:^(){
                             
                             self.contentScrollView.contentOffset = CGPointMake(newContentOffsetX, 0);
                         }
                         completion:^(BOOL finished){
                             
                             self.contentScrollView.userInteractionEnabled = YES;
                         }];
        
        
    }
    
}



- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    NSLog(@"CHODY_iScroll scrollToItemAtIndex %ld", (long)index);
    
    //index를 -1 등으로 세팅 허용
    if (index < 0 || index >= self.numberOfItems) return;
    
    if (!animated)
    {
        self.currentItemIndex = index;
    }
    else
    {
        
        if (self.type == iScrollTypeTVSectionStyle)
        {
            UIView *curView = [self itemViewAtIndex:index];
            
            
            CGFloat newContentOffsetX =  (index*curView.frame.size.width)  ;
            if (newContentOffsetX < 0)
                newContentOffsetX = 0;
            else if (newContentOffsetX + self.contentScrollView.frame.size.width > self.contentScrollView.contentSize.width)
                newContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width;
            
            if (self.contentScrollView.contentOffset.x == newContentOffsetX)
            {
                self.currentItemIndex = index;
            }
            else
            {
                {

                    
                    [UIView animateWithDuration:0.2
                                     animations:^(){
                                         
                                         self.contentScrollView.contentOffset = CGPointMake(newContentOffsetX, 0);
                                     }
                                     completion:^(BOOL finished){
                                         
                                         self.currentItemIndex = index;
                                         

                                     }];
                }
                
            }
            
            
            
        }else {
            UIView *curView = [self itemViewAtIndex:index];
            
            CGFloat newContentOffsetX = curView.center.x - self.contentScrollView.frame.size.width / 2.0;
            
            if (newContentOffsetX < 0)
                newContentOffsetX = 0;
            else if (newContentOffsetX + self.contentScrollView.frame.size.width > self.contentScrollView.contentSize.width)
                newContentOffsetX = self.contentScrollView.contentSize.width - self.contentScrollView.frame.size.width;
            
            if (self.contentScrollView.contentOffset.x == newContentOffsetX)
            {
                self.currentItemIndex = index;
            }
            else
            {
                {
                    self.contentScrollView.userInteractionEnabled = NO;
                    
                    [UIView animateWithDuration:0.2
                                     animations:^(){
                                         
                                         self.contentScrollView.contentOffset = CGPointMake(newContentOffsetX, 0);
                                     }
                                     completion:^(BOOL finished){
                                         
                                         self.currentItemIndex = index;
                                         
                                         self.contentScrollView.userInteractionEnabled = YES;
                                     }];
                }
                
            }
        }
    }
}



- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.movingToItemIndex >= 0)
    {
        self.currentItemIndex = self.movingToItemIndex;
        self.movingToItemIndex = -1;
    }
}


@end
