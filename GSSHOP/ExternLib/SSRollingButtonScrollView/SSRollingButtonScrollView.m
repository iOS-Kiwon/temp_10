//
//  SSRollingButtonScrollView.m
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//

#import "SSRollingButtonScrollView.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SSRollingButtonScrollView
{
    BOOL _viewsInitialLoad;
    BOOL _lockCenterButton;
    
    NSMutableArray *_rollingScrollViewButtonTitles;
    SScontentLayoutStyle _layoutStyle;
    
    NSMutableArray *_rollingScrollViewButtons;
    NSMutableArray *_rollingScrollViewButtonIcons;
    NSMutableArray *_visibleButtons;
    UIView *_buttonContainerView;
    
    NSInteger _rightMostVisibleButtonIndex;
    NSInteger _leftMostVisibleButtonIndex;
    
    NSInteger _topMostVisibleButtonIndex;
    NSInteger _bottomMostVisibleButtonIndex;
    
    NSInteger _scrollViewSelectedIndex;
    CGPoint _lastOffset;
    NSTimeInterval _lastTimeCapture;
    CGFloat _scrollVelocity;
    UIButton *_currentCenterButton;
    
    CGFloat _width;
    CGFloat _height;
    
    UIImageView *_imgUnderLine;
    BOOL _isLayoutEnded;
    BOOL _isFromFCall;
}

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame]))
    {
        _viewsInitialLoad = YES;
        _lockCenterButton = NO;
        _isLayoutEnded = NO;
        
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        
        _rollingScrollViewButtonTitles = [NSMutableArray array];
        _rollingScrollViewButtons = [NSMutableArray array];
        _rollingScrollViewButtonIcons = [NSMutableArray array];
        _visibleButtons = [NSMutableArray array];
        _buttonContainerView = [[UIView alloc] init];
        _currentCenterButton = [[UIButton alloc] init];
        
        _imgUnderLine = [[UIImageView alloc] initWithFrame: CGRectMake(0, 41, 50, 3)];
        _imgUnderLine.backgroundColor = [Mocha_Util getColor:@"BED730"];
        
        self.fixedButtonWidth = -1.0f;
        self.fixedButtonHeight = -1.0f;
        self.spacingBetweenButtons = 0.0f;
        self.notCenterButtonBackgroundColor = [UIColor clearColor];
        self.centerButtonBackgroundColor = [UIColor clearColor];
        self.notCenterButtonBackgroundImage = nil;
        self.centerButtonBackgroundImage = nil;
        self.buttonNotCenterFont = [UIFont systemFontOfSize:16];
        self.buttonCenterFont = [UIFont boldSystemFontOfSize:20];
        self.notCenterButtonTextColor = [UIColor grayColor];
        self.centerButtonTextColor = [UIColor orangeColor];
        self.stopOnCenter = YES;
        self.centerPushedButtons = YES;
        self.idxToCenter = -1;
        
        
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        //
        _width = frame.size.width;
        _height = frame.size.height;
        
        self.delegate = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        _viewsInitialLoad = YES;
        _lockCenterButton = NO;
        _isLayoutEnded = NO;
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
        _rollingScrollViewButtonTitles = [NSMutableArray array];
        _rollingScrollViewButtons = [NSMutableArray array];
        _rollingScrollViewButtonIcons = [NSMutableArray array];
        _visibleButtons = [NSMutableArray array];
        _buttonContainerView = [[UIView alloc] init];
        _currentCenterButton = [[UIButton alloc] init];
        _imgUnderLine = [[UIImageView alloc] initWithFrame: CGRectMake(0, 41, 50, 3)];
        _imgUnderLine.backgroundColor = [Mocha_Util getColor:@"BED730"];
        
        self.fixedButtonWidth = -1.0f;
        self.fixedButtonHeight = -1.0f;
        self.spacingBetweenButtons = 0.0f;
        self.notCenterButtonBackgroundColor = [UIColor clearColor];
        self.centerButtonBackgroundColor = [UIColor clearColor];
        self.notCenterButtonBackgroundImage = nil;
        self.centerButtonBackgroundImage = nil;
        self.buttonNotCenterFont = [UIFont systemFontOfSize:16];
        self.buttonCenterFont = [UIFont boldSystemFontOfSize:20];
        self.notCenterButtonTextColor = [UIColor grayColor];
        self.centerButtonTextColor = [UIColor orangeColor];
        self.stopOnCenter = YES;
        self.centerPushedButtons = YES;
        self.idxToCenter = -1;
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        //
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        
        self.delegate = self;
    }
    return self;
}

- (void)setContentSizeAndButtonContainerViewFrame
{
    if (_layoutStyle == SShorizontalLayout) {
        self.contentSize = CGSizeMake(5000, self.frame.size.height);
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width, 5000);
    }
    
    _buttonContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self addSubview:_buttonContainerView];
}

- (UIButton *)createAndConfigureNewButton:(NSString *)buttonTitle
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.titleLabel.font = self.buttonNotCenterFont;
    [button setTitleColor:self.notCenterButtonTextColor forState:UIControlStateNormal];
    //[button setTitleColor:self.centerButtonTextColor forState:UIControlStateHighlighted];
    [button setBackgroundColor:self.notCenterButtonBackgroundColor];
    
    if (self.notCenterButtonBackgroundImage != nil) {
        [button setBackgroundImage:self.notCenterButtonBackgroundImage forState:UIControlStateNormal];
    }
    return button;
}

- (void)createButtonArrayWithButtonTitles:(NSArray *)titles andIconUrl:(NSArray *)icons andLayoutStyle:(SScontentLayoutStyle)layoutStyle
{
    _rollingScrollViewButtonTitles = [NSMutableArray arrayWithArray:titles];
    _layoutStyle = layoutStyle;
    
    [self setContentSizeAndButtonContainerViewFrame];
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    _rollingScrollViewButtons = [NSMutableArray array];
    _rollingScrollViewButtonIcons = [NSMutableArray array];
    
    if (_layoutStyle == SShorizontalLayout) {
        
        while (x <= self.frame.size.width * 2) {
            NSInteger i=0;
            for (NSString *buttonTitle in _rollingScrollViewButtonTitles) {
                
                UIButton *button = [self createAndConfigureNewButton:buttonTitle];
                
                CGSize fittedButtonSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.buttonCenterFont}];
                
                if (self.fixedButtonWidth < 0) {
                    buttonWidth = ceilf(fittedButtonSize.width / 2) * 2;
                } else {
                    buttonWidth = self.fixedButtonWidth;
                }
                
                buttonWidth =  buttonWidth + self.spacingBetweenButtons;
                
                if (self.fixedButtonHeight < 0) {
                    buttonHeight = ceilf(fittedButtonSize.height / 2) * 2;
                } else {
                    buttonHeight = self.fixedButtonHeight;
                }
                
                button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
                
                //x += buttonWidth + self.spacingBetweenButtons;
                x += buttonWidth;
                
                [button addTarget:self action:@selector(scrollViewButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
                
                [_rollingScrollViewButtons addObject:button];
                if ([icons count] > i) {
                    [_rollingScrollViewButtonIcons addObject:[icons objectAtIndex:i]];
                }
                i++;
                
                [button setBackgroundImage:[Common_Util imageWithColor:[UIColor colorWithRed:0x00/255.0 green:0x00/255.0 blue:0x00/255.0 alpha:0.08]] forState:UIControlStateHighlighted];
            }
        }
        
    } else {
        
        while (y <= self.frame.size.height * 2) {
            
            for (NSString *buttonTitle in _rollingScrollViewButtonTitles) {
                
                UIButton *button = [self createAndConfigureNewButton:buttonTitle];
                
                CGSize fittedButtonSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.buttonCenterFont}];
                
                if (self.fixedButtonWidth < 0) {
                    buttonWidth = ceilf(fittedButtonSize.width / 2) * 2;
                } else {
                    buttonWidth = self.fixedButtonWidth;
                }
                
                if (self.fixedButtonHeight < 0) {
                    buttonHeight = ceilf(fittedButtonSize.height / 2) * 2;
                } else {
                    buttonHeight = self.fixedButtonHeight;
                }
                
                button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
                
                y += buttonHeight + self.spacingBetweenButtons;
                
                [button addTarget:self action:@selector(scrollViewButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
                
                [_rollingScrollViewButtons addObject:button];
            }
        }
    }
    
    [self addSubview:_buttonContainerView];
    [self moveButtonToViewCenter:_currentCenterButton animated:YES];
}

- (void)layoutSubviews
{
    
    // If change in view size (typically due to device rotation), prevent center button from changing.
    if (_width != self.bounds.size.width || _height != self.bounds.size.height) {
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        _lockCenterButton = YES;
    }
    
    [super layoutSubviews];
    
    if ([_rollingScrollViewButtonTitles count] > 0) {
        
        if (_lockCenterButton) {
            [self moveButtonToViewCenter:_currentCenterButton animated:NO];
            _lockCenterButton = NO;
        }
        
        [self recenterIfNecessary];
        [self tileContentInVisibleBounds];
        [self configureCenterButton:[self getCenterButton]];
        
        if (_viewsInitialLoad) {
            
            if (self.idxToCenter > -1) {
                UIButton *btnCenter = (UIButton *)[_rollingScrollViewButtons objectAtIndex:self.idxToCenter];
                NSLog(@"btnCenter frame = %@",NSStringFromCGRect(btnCenter.frame));
                [self configureCenterButton:btnCenter];
                [self moveGSButtonToViewCenter:btnCenter animated:NO];
                _imgUnderLine.frame = CGRectMake(btnCenter.frame.origin.x, 41.0, btnCenter.frame.size.width, 3.0);
                [_buttonContainerView addSubview:_imgUnderLine];

            }else{
                NSLog(@"_currentCenterButton frame = %@",NSStringFromCGRect(_currentCenterButton.frame));
                [self moveButtonToViewCenter:_currentCenterButton animated:NO];
                NSLog(@"_currentCenterButton frame = %@",NSStringFromCGRect(_currentCenterButton.frame));
            }
            
            [self tileContentInVisibleBounds];
            _viewsInitialLoad = NO;
            self.idxToCenter = -1;
        }
    }
    
    _isLayoutEnded = YES;
}

- (void)tileContentInVisibleBounds
{
    CGRect visibleBounds = [self convertRect:[self bounds] toView:_buttonContainerView];
    
    if (_layoutStyle == SShorizontalLayout) {
        
        CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
        CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
        [self tileButtonsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
        
    } else {
        
        CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
        CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
        [self tileButtonsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
    }
    
    [self insertSubview:_buttonContainerView atIndex:0];
}

- (void)configureCenterButton:(UIButton *)centerButton
{
    if (centerButton != _currentCenterButton) {
        
        _currentCenterButton = centerButton;
        
        for (UIButton *button in _visibleButtons) {
            [button setBackgroundColor:self.notCenterButtonBackgroundColor];
            [button setBackgroundImage:self.notCenterButtonBackgroundImage forState:UIControlStateNormal];
            button.titleLabel.font = self.buttonNotCenterFont;
            [button setTitleColor:self.notCenterButtonTextColor forState:UIControlStateNormal];
        }
        [centerButton setBackgroundColor:self.centerButtonBackgroundColor];
        [centerButton setBackgroundImage:self.centerButtonBackgroundImage forState:UIControlStateNormal];
        centerButton.titleLabel.font = self.buttonCenterFont;
        centerButton.titleLabel.textColor = self.centerButtonTextColor;
        [centerButton setTitleColor:self.centerButtonTextColor forState:UIControlStateNormal];
        
        
        
        _imgUnderLine.frame = CGRectMake(centerButton.frame.origin.x, 41.0, centerButton.frame.size.width, 3.0);
        
        [_buttonContainerView addSubview:_imgUnderLine];
        
    }
}

- (UIButton *)getCenterButton
{
    UIButton *centerButton = [[UIButton alloc] init];
    
    CGFloat buttonMinimumDistanceFromCenter = 5000.0f;
    CGFloat currentButtonDistanceFromCenter = 5000.0f;
    
    for (UIButton *button in _visibleButtons) {
        
        currentButtonDistanceFromCenter = fabs([self buttonDistanceFromCenter:button]);
        
        if (currentButtonDistanceFromCenter < buttonMinimumDistanceFromCenter) {
            buttonMinimumDistanceFromCenter = currentButtonDistanceFromCenter;
            centerButton = button;
        }
    }
    
    return centerButton;
}

- (CGFloat)buttonDistanceFromCenter:(UIButton *)button
{
    CGFloat distanceFromCenter;
    
    if (_layoutStyle == SShorizontalLayout) {
        
        CGFloat visibleContentCenterX = self.contentOffset.x + [self bounds].size.width / 2.0f;
        distanceFromCenter = visibleContentCenterX - button.center.x;
        
    } else {
        
        CGFloat visibleContentCenterY = self.contentOffset.y + [self bounds].size.height / 2.0f;
        distanceFromCenter = visibleContentCenterY - button.center.y;
    }
    
    return distanceFromCenter;
}

- (void)moveButtonToViewCenter:(UIButton *)button animated:(BOOL)animated
{
    if (_layoutStyle == SShorizontalLayout) {
        
        CGPoint currentOffset = self.contentOffset;
        CGFloat distanceFromCenter = [self buttonDistanceFromCenter:button];
        
        CGPoint targetOffset = CGPointMake(currentOffset.x - distanceFromCenter, 0.0f);
        [self setContentOffset:targetOffset animated:animated];
        
    } else {
        
        CGPoint currentOffset = self.contentOffset;
        CGFloat distanceFromCenter = [self buttonDistanceFromCenter:button];
        
        CGPoint targetOffset = CGPointMake(0.0f, currentOffset.y - distanceFromCenter);
        [self setContentOffset:targetOffset animated:animated];
    }
}

- (void)recenterIfNecessary
{
    if (_layoutStyle == SShorizontalLayout) {
        
        CGPoint currentOffset = [self contentOffset];
        CGFloat contentWidth = [self contentSize].width;
        CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
        CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
        
        if (distanceFromCenter > (contentWidth / 4.0))
        {
            self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
            
            // move content by the same amount so it appears to stay still
            for (UIButton *button in _rollingScrollViewButtons) {
                CGPoint center = [_buttonContainerView convertPoint:button.center toView:self];
                center.x += (centerOffsetX - currentOffset.x);
                button.center = [self convertPoint:center toView:_buttonContainerView];
            }
        }
        
    } else {
        
        CGPoint currentOffset = [self contentOffset];
        CGFloat contentHeight = [self contentSize].height;
        CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
        CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
        
        if (distanceFromCenter > (contentHeight / 4.0))
        {
            self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
            
            // move content by the same amount so it appears to stay still
            for (UIButton *button in _rollingScrollViewButtons) {
                CGPoint center = [_buttonContainerView convertPoint:button.center toView:self];
                center.y += (centerOffsetY - currentOffset.y);
                button.center = [self convertPoint:center toView:_buttonContainerView];
            }
        }
        
    }
}

- (void)scrollViewButtonIsInCenter:(UIButton *)sender
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(rollingScrollViewButtonIsInCenter:ssRollingButtonScrollView:)]) {
        
        for (NSInteger i=0; i<[_rollingScrollViewButtons count]; i++) {
            if ([sender isEqual:(UIButton *)[_rollingScrollViewButtons objectAtIndex:i]]) {
                [self.ssRollingButtonScrollViewDelegate rollingScrollViewButtonIsInCenter:i ssRollingButtonScrollView:self];
                
                break;
            }
        }
    }
}

- (void)scrollViewButtonPushed:(UIButton *)sender
{
    if (_centerPushedButtons) {
        [self moveButtonToViewCenter:sender animated:YES];
    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(rollingScrollViewButtonPushed:ssRollingButtonScrollView:)]) {
        //[self.ssRollingButtonScrollViewDelegate rollingScrollViewButtonPushed:sender ssRollingButtonScrollView:self];
        
        for (NSInteger i=0; i<[_rollingScrollViewButtons count]; i++) {
            if ([sender.titleLabel.text isEqualToString:((UIButton *)[_rollingScrollViewButtons objectAtIndex:i]).titleLabel.text]) {
                [self.ssRollingButtonScrollViewDelegate rollingScrollViewButtonPushed:i ssRollingButtonScrollView:self];
                break;
            }
        }
    }
}

- (void)scrollToButtonIndex:(NSInteger)index animated:(BOOL)animated{

    UIButton *btn = [_rollingScrollViewButtons objectAtIndex:index];
    
    if (_viewsInitialLoad == NO) {
        
        for (UIButton *btnRoll in _rollingScrollViewButtons) {
            if ([btnRoll.titleLabel.text isEqualToString:NCS([_rollingScrollViewButtonTitles objectAtIndex:index])]) {

                if (btnRoll.center.x != btn.center.x) {
                    CGFloat distanceBtnRoll = fabs([self buttonDistanceFromCenter:btnRoll]);
                    CGFloat distanceBtn = fabs([self buttonDistanceFromCenter:btn]);

                    if (distanceBtn > distanceBtnRoll) {
                        btn = btnRoll;
                    }
                }
            }
        }
        
        [self moveGSButtonToViewCenter:btn animated:animated];
    }else{
        self.idxToCenter = index;
    }
}

- (void)moveGSButtonToViewCenter:(UIButton *)button animated:(BOOL)animated
{
    
    CGPoint currentOffset = self.contentOffset;
    CGFloat distanceFromCenter = 0.0;
    
    BOOL isButtonVisible = NO;
    for (UIButton *btnSearch in _visibleButtons) {
        if ([btnSearch isEqual:button]) {
            isButtonVisible = YES;
            break;
        }
    }
    
    if (isButtonVisible == YES) {
        CGFloat visibleContentCenterX = self.contentOffset.x + [self bounds].size.width / 2.0f;
        distanceFromCenter = visibleContentCenterX - button.center.x;
    }else{
        UIButton *btnVisibleLast = (UIButton *)[_visibleButtons lastObject];
        CGFloat originX = 0;
        BOOL lastButtonFound = NO;
        for (UIButton *btn in _rollingScrollViewButtons) {
            if ([btn isEqual:btnVisibleLast]) {
                originX = btnVisibleLast.frame.origin.x + btnVisibleLast.frame.size.width;
                lastButtonFound = YES;
            }else{
                if (lastButtonFound == YES) {
                    
                    if ([btn isEqual:button]) {
                        //NSLog(@"button.frame = %@",NSStringFromCGRect(button.frame));
                        button.frame = CGRectMake(originX, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
                    }else{
                        originX = originX + btn.frame.size.width;
                    }
                }
            }
        }
        
        //NSLog(@"button.frame = %@",NSStringFromCGRect(button.frame));
        CGFloat visibleContentCenterX = self.contentOffset.x + [self bounds].size.width / 2.0f;
        distanceFromCenter = visibleContentCenterX - button.center.x;
        //NSLog(@"button.frame = %@",NSStringFromCGRect(button.frame));
    }
    
    
    CGPoint targetOffset = CGPointMake(currentOffset.x - distanceFromCenter, 0.0f);
    [self setContentOffset:targetOffset animated:animated];
}

#pragma mark - Label Tiling

- (CGFloat)placeNewButtonOnRight:(CGFloat)rightEdge
{
    _rightMostVisibleButtonIndex++;
    if (_rightMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
        _rightMostVisibleButtonIndex = 0;
    }
    
    
    
    UIButton *button = _rollingScrollViewButtons[_rightMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons addObject:button]; // add rightmost label at the end of the array
    
    CGRect frame = [button frame];
    frame.origin.x = rightEdge;
    frame.origin.y = (([_buttonContainerView bounds].size.height - frame.size.height) / 2.0f ) +1.0;
    [button setFrame:frame];
    
    if ([_rollingScrollViewButtonIcons count] > _rightMostVisibleButtonIndex) {
        NSString *imgUrl = NCS(_rollingScrollViewButtonIcons[_rightMostVisibleButtonIndex]);
        UIImageView *titleIcon = nil;
        if([[Mocha_Util trim:imgUrl] length]  > 0) {
            //titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width ,0.0,12.0,43.0)];
            
            //이미지가 있고 버튼의 최종 서브뷰가 이미지뷰가 아닐경우에만 붙힘
            if ([[button.subviews lastObject] isKindOfClass:[UIImageView class]] == NO) {
                titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width-1.0 -(self.spacingBetweenButtons/2.0),-(button.frame.origin.y + 1.0) ,12.0,43.0)];
                titleIcon.contentMode = UIViewContentModeScaleAspectFit;
                [button addSubview:titleIcon];
                
                [ImageDownManager blockImageDownWithURL:imgUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if (error == nil  && [imgUrl isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //실제 사이즈 대비 1/2로 축소
                            UIImage *resizeImage = [UIImage imageWithCGImage:fetchedImage.CGImage scale:fetchedImage.scale * 2.0f orientation:fetchedImage.imageOrientation];
                            //NSLog(@"%f,%f",resizeImage.size.width,resizeImage.size.height);
                            
                            if (isInCache) {
                                titleIcon.image = resizeImage;
                            }
                            else {
                                titleIcon.alpha = 0;
                                titleIcon.image = resizeImage;
                                [UIView animateWithDuration:0.1f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     titleIcon.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished) {
                                                     
                                                 }];
                            }
                        });
                    }
                }];
            }
        }
    }
    
    
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewButtonOnLeft:(CGFloat)leftEdge
{
    _leftMostVisibleButtonIndex--;
    if (_leftMostVisibleButtonIndex < 0) {
        _leftMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
    }
    
    UIButton *button = _rollingScrollViewButtons[_leftMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons insertObject:button atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [button frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = (([_buttonContainerView bounds].size.height - frame.size.height) / 2.0f ) +1.0;
    [button setFrame:frame];
    
    if ([_rollingScrollViewButtonIcons count] > _leftMostVisibleButtonIndex) {
        
        NSString *imgUrl = NCS(_rollingScrollViewButtonIcons[_leftMostVisibleButtonIndex]);
        UIImageView *titleIcon = nil;
        if([[Mocha_Util trim:imgUrl] length]  > 0) {
            //titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.width ,0.0,12.0,43.0)];
            
            //이미지가 있고 버튼의 최종 서브뷰가 이미지뷰가 아닐경우에만 붙힘
            if ([[button.subviews lastObject] isKindOfClass:[UIImageView class]] == NO) {
                titleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width-1.0 -(self.spacingBetweenButtons/2.0),-(button.frame.origin.y + 1.0) ,12.0,43.0)];
                titleIcon.contentMode = UIViewContentModeScaleAspectFit;
                [button addSubview:titleIcon];
                
                [ImageDownManager blockImageDownWithURL:imgUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    if (error == nil  && [imgUrl isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //실제 사이즈 대비 1/2로 축소
                            UIImage *resizeImage = [UIImage imageWithCGImage:fetchedImage.CGImage scale:fetchedImage.scale * 2.0f orientation:fetchedImage.imageOrientation];
                            NSLog(@"%f,%f",resizeImage.size.width,resizeImage.size.height);
                            
                            if (isInCache) {
                                titleIcon.image = resizeImage;
                            }
                            else {
                                titleIcon.alpha = 0;
                                titleIcon.image = resizeImage;
                                [UIView animateWithDuration:0.1f
                                                      delay:0.0f
                                                    options:UIViewAnimationOptionCurveEaseInOut
                                                 animations:^{
                                                     titleIcon.alpha = 1;
                                                 }
                                                 completion:^(BOOL finished) {
                                                     
                                                 }];
                            }
                        });
                    }
                }];
            }
        }
        
    }
    
    return CGRectGetMinX(frame);
}

- (void)tileButtonsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleButtons count] == 0)
    {
        _rightMostVisibleButtonIndex = -1;
        _leftMostVisibleButtonIndex = 0;
        [self placeNewButtonOnRight:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    UIButton *lastButton = [_visibleButtons lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastButton frame]);
    
    while (rightEdge < maximumVisibleX)
    {
        //rightEdge += self.spacingBetweenButtons;
        rightEdge = [self placeNewButtonOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    UIButton *firstButton = _visibleButtons[0];
    CGFloat leftEdge = CGRectGetMinX([firstButton frame]);
    while (leftEdge > minimumVisibleX)
    {
        //leftEdge -= self.spacingBetweenButtons;
        leftEdge = [self placeNewButtonOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastButton = [_visibleButtons lastObject];
    while ([lastButton frame].origin.x > maximumVisibleX)
    {
        [lastButton removeFromSuperview];
        [_visibleButtons removeLastObject];
        lastButton = [_visibleButtons lastObject];
        
        _rightMostVisibleButtonIndex--;
        if (_rightMostVisibleButtonIndex < 0) {
            _rightMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
        }
    }
    
    // remove labels that have fallen off left edge
    firstButton = _visibleButtons[0];
    while (CGRectGetMaxX([firstButton frame]) < minimumVisibleX)
    {
        [firstButton removeFromSuperview];
        [_visibleButtons removeObjectAtIndex:0];
        firstButton = _visibleButtons[0];
        
        _leftMostVisibleButtonIndex++;
        if (_leftMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
            _leftMostVisibleButtonIndex = 0;
        }
    }
    
}

- (CGFloat)placeNewButtonOnBottom:(CGFloat)bottomEdge
{
    _bottomMostVisibleButtonIndex++;
    if (_bottomMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
        _bottomMostVisibleButtonIndex = 0;
    }
    
    UIButton *button = _rollingScrollViewButtons[_bottomMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons addObject:button]; // add bottommost label at the end of the array
    
    CGRect frame = [button frame];
    frame.origin.y = bottomEdge;
    frame.origin.x = ([_buttonContainerView bounds].size.width - frame.size.width) / 2.0f;
    [button setFrame:frame];
    return CGRectGetMaxY(frame);
}

- (CGFloat)placeNewButtonOnTop:(CGFloat)topEdge
{
    _topMostVisibleButtonIndex--;
    if (_topMostVisibleButtonIndex < 0) {
        _topMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
    }
    
    UIButton *button = _rollingScrollViewButtons[_topMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons insertObject:button atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [button frame];
    frame.origin.y = topEdge - frame.size.height;
    frame.origin.x = ([_buttonContainerView bounds].size.width - frame.size.width) / 2.0f;
    [button setFrame:frame];
    
    return CGRectGetMinY(frame);
}

- (void)tileButtonsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleButtons count] == 0)
    {
        _bottomMostVisibleButtonIndex = -1;
        _topMostVisibleButtonIndex = 0;
        [self placeNewButtonOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    UIButton *lastButton = [_visibleButtons lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastButton frame]);
    
    while (bottomEdge < maximumVisibleY)
    {
        //bottomEdge += self.spacingBetweenButtons;
        bottomEdge = [self placeNewButtonOnBottom:bottomEdge];
    }
    
    // add labels that are missing on left side
    UIButton *firstButton = _visibleButtons[0];
    CGFloat topEdge = CGRectGetMinY([firstButton frame]);
    while (topEdge > minimumVisibleY)
    {
        //topEdge -= self.spacingBetweenButtons;
        topEdge = [self placeNewButtonOnTop:topEdge];
    }
    
    // remove labels that have fallen off right edge
    lastButton = [_visibleButtons lastObject];
    while ([lastButton frame].origin.y > maximumVisibleY)
    {
        [lastButton removeFromSuperview];
        [_visibleButtons removeLastObject];
        lastButton = [_visibleButtons lastObject];
        
        _bottomMostVisibleButtonIndex--;
        if (_bottomMostVisibleButtonIndex < 0) {
            _bottomMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
        }
    }
    
    // remove labels that have fallen off left edge
    firstButton = _visibleButtons[0];
    while (CGRectGetMaxY([firstButton frame]) < minimumVisibleY)
    {
        [firstButton removeFromSuperview];
        [_visibleButtons removeObjectAtIndex:0];
        firstButton = _visibleButtons[0];
        
        _topMostVisibleButtonIndex++;
        if (_topMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
            _topMostVisibleButtonIndex = 0;
        }
    }
    
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.stopOnCenter) {
        
        if (_layoutStyle == SShorizontalLayout) {
            
            CGPoint currentOffset = self.contentOffset;
            NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval timeChange = currentTime - _lastTimeCapture;
            CGFloat distanceChange = currentOffset.x - _lastOffset.x;
            _scrollVelocity = distanceChange / timeChange;
            
            if (scrollView.decelerating) {
                if (fabs(_scrollVelocity) < 150) {
                    [self moveButtonToViewCenter:_currentCenterButton animated:YES];
                }
            }
            _lastOffset = currentOffset;
            _lastTimeCapture = currentTime;
            
        } else {
            
            CGPoint currentOffset = self.contentOffset;
            NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval timeChange = currentTime - _lastTimeCapture;
            CGFloat distanceChange = currentOffset.y - _lastOffset.y;
            _scrollVelocity = distanceChange / timeChange;
            
            if (scrollView.decelerating) {
                if (fabs(_scrollVelocity) < 75) {
                    [self moveButtonToViewCenter:_currentCenterButton animated:YES];
                }
            }
            _lastOffset = currentOffset;
            _lastTimeCapture = currentTime;
        }
    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
//        [self.ssRollingButtonScrollViewDelegate scrollViewWillBeginDragging:scrollView];
//    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(rollingScrollWillBeginDragging:)]) {
        [self.ssRollingButtonScrollViewDelegate rollingScrollWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.stopOnCenter) {
        if (!decelerate) {
            [self moveButtonToViewCenter:_currentCenterButton animated:YES];
            [self scrollViewButtonIsInCenter:[self getCenterButton]];
        }
    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewButtonIsInCenter:[self getCenterButton]];
    
//    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
//        [self.ssRollingButtonScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
//    }
//    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(rollingScrollViewDidFinishScroll:ssRollingButtonScrollView:)]) {
//
//        for (NSInteger i=0; i<[_rollingScrollViewButtons count]; i++) {
//            if ([_currentCenterButton isEqual:(UIButton *)[_rollingScrollViewButtons objectAtIndex:i]]) {
//                [self.ssRollingButtonScrollViewDelegate rollingScrollViewDidFinishScroll:i ssRollingButtonScrollView:self];
//                break;
//            }
//        }
//    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    if (_currentCenterButton.center.x != _imgUnderLine.center.x) {
        //_imgUnderLine.frame = CGRectMake(_currentCenterButton.frame.origin.x - 11.0, 41.0, _currentCenterButton.frame.size.width + 22.0, 3.0);
        _imgUnderLine.frame = CGRectMake(_currentCenterButton.frame.origin.x, 41.0, _currentCenterButton.frame.size.width, 3.0);
    }
    
//    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
//        [self.ssRollingButtonScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
//    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(rollingScrollViewDidFinishScroll:ssRollingButtonScrollView:)]) {
        
        for (NSInteger i=0; i<[_rollingScrollViewButtons count]; i++) {
            if ([_currentCenterButton isEqual:(UIButton *)[_rollingScrollViewButtons objectAtIndex:i]]) {
                [self.ssRollingButtonScrollViewDelegate rollingScrollViewDidFinishScroll:i ssRollingButtonScrollView:self];
                break;
            }
        }
    }
}



@end
