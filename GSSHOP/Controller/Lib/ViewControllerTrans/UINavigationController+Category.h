//
//  UIViewController+Category.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 2..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

//이하 큐브애니메이션적용분
/*
 typedef enum {
 LeftToRight = 0,
 RightToLeft,
 } RotationDirection;
 
 
 #ifdef HAS_STUATS_BAR
 #define PAGE_VERTICAL_WIDTH                      APPFULLWIDTH
 #define PAGE_VERTICAL_HEIGHT                     460.0f
 #define PAGE_HORIZONTAL_WIDTH                    480.0f
 #define PAGE_HORIZONTAL_HEIGHT                   300.0f
 #define CONTENT_Y_OFFSET                         20.0f
 #else
 #define PAGE_VERTICAL_WIDTH                      APPFULLWIDTH
 #define PAGE_VERTICAL_HEIGHT                     480.0f
 #define PAGE_HORIZONTAL_WIDTH                    480.0f
 #define PAGE_HORIZONTAL_HEIGHT                   APPFULLWIDTH
 #define CONTENT_Y_OFFSET                         0.0f
 #endif
 
 #define radians(degrees) degrees * M_PI / 180
 #define CUBESIZE APPFULLWIDTH
 
 static char const* const backgroundKey = "backgroundKey";
 static char const* const rotationLayerKey = "rotationLayerKey";
 static char const* const animationStyleStackKey = "animationStyleStackKey";
 
 */
@interface UINavigationController(Category)

- (void)pushViewControllerMoveInFromBottom:(UIViewController *)viewController;
- (void)popViewControllerMoveInFromTop;
- (void)pushViewControllerMoveInFromRise:(UIViewController *)viewController;
- (void)popViewControllerMoveInFromDown;
@end
