//
//  UIViewController+Category.m
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 8. 2..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import "UINavigationController+Category.h"
#import "Appdelegate.h"

@implementation UINavigationController(Category)


/*
+ (dispatch_queue_t)timeoutLockQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("timeout lock queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}


 
 - (void)popViewControllerMoveInFromTop {
 [CATransaction begin];
 CATransition *transition;
 transition = [CATransition animation];
 transition.type = kCATransitionMoveIn;
 transition.subtype = kCATransitionFromTop;
 transition.duration = 0.7;
 
 [CATransaction setValue:(id)kCFBooleanTrue
 forKey:kCATransactionDisableActions];
 
 [self.view.layer addAnimation:transition forKey:nil];
 [self  popViewControllerAnimated:NO];
 [CATransaction commit];
 }
 
 */


/*
 
 - (void)pushViewControllerMoveInFromBottom:(UIViewController *)viewController {
 
 [CATransaction begin];
 CATransition *transition;
 transition = [CATransition animation];
 transition.type = kCATransitionReveal;
 transition.subtype = kCATransitionFromRight;
 transition.duration = 0.1;
 
 [CATransaction setValue:(id)kCFBooleanTrue
 forKey:kCATransactionAnimationDuration];
 
 
 [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
 [self  pushViewController:viewController animated:YES];
 [CATransaction commit];
 
 }
 
 - (void)popViewControllerMoveInFromTop {
 
 [CATransaction begin];
 __block CATransition *transition;
 transition = [CATransition animation];
 transition.type = kCATransitionReveal;
 transition.subtype = kCATransitionFromLeft;
 transition.duration = 0.1;
 
 [CATransaction setValue:(id)kCFBooleanTrue
 forKey:kCATransactionAnimationDuration];
 
 [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
 [self  popViewControllerAnimated:YES];
 [CATransaction commit];
 
 
 }
 */



 



- (void)pushViewControllerMoveInFromBottom:(UIViewController *)viewController {
  
    // Enable iOS 7 back gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
     // disable
     if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
         self.navigationController.interactivePopGestureRecognizer.enabled = NO;
     }
    
//    [self pushViewController:viewController animated:YES];
    [CATransaction begin];
    CATransition *transition;
    transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 0.3;
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionAnimationDuration];
    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    [self pushViewController:viewController animated:NO];

    [CATransaction commit];
    
    ApplicationDelegate.isSideMenuOnTop = NO;
}

- (void)popViewControllerMoveInFromTop {
    
//    [self  popViewControllerAnimated:YES];
    [CATransaction begin];
    __block CATransition *transition;
    transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.duration = 0.3;
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionAnimationDuration];

    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    [self  popViewControllerAnimated:NO];
    NSLog(@"self.viewControllers = %@",self.viewControllers);
    [CATransaction commit];
}



//아래서 위로 올라옴
- (void)pushViewControllerMoveInFromRise:(UIViewController *)viewController {
    
    // Enable iOS 7 back gesture
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
    
    // disable
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [CATransaction begin];
    CATransition *transition;
    transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.3;
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionAnimationDuration];
    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    [self pushViewController:viewController animated:NO];
    
    [CATransaction commit];
    
    ApplicationDelegate.isSideMenuOnTop = NO;
}


- (void)popViewControllerMoveInFromDown {
    
    [CATransaction begin];
    __block CATransition *transition;
    transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.duration = 0.3;
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionAnimationDuration];
    
    [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
    [self  popViewControllerAnimated:NO];
    NSLog(@"self.viewControllers = %@",self.viewControllers);
    [CATransaction commit];
}




- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}







//이하 큐브애니메이션적용분 objc/runtime
/*
 
 
 
 
 - (CAAnimation*) makeRotationAnimation:(RotationDirection)aDirection duration:(float)aDuration {
 [CATransaction flush];
 CABasicAnimation* rotation;
 CABasicAnimation* translationX;
 CABasicAnimation* translationZ;
 CAAnimationGroup* group = [CAAnimationGroup animation];
 group.delegate = self;
 group.duration = aDuration;
 
 if (aDirection == RightToLeft) {
 translationX = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.x"];
 translationX.toValue = [NSNumber numberWithFloat:-(PAGE_VERTICAL_WIDTH / 2)];
 rotation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
 rotation.toValue = [NSNumber numberWithFloat:radians(-90)];
 }
 else {
 translationX = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.x"];
 translationX.toValue = [NSNumber numberWithFloat:(PAGE_VERTICAL_WIDTH / 2)];
 rotation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
 rotation.toValue = [NSNumber numberWithFloat:radians(90)];
 }
 
 translationZ = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.translation.z"];
 translationZ.toValue = [NSNumber numberWithFloat:-(PAGE_VERTICAL_WIDTH / 2)];
 group.animations = [NSArray arrayWithObjects:rotation, translationX, translationZ, nil];
 group.fillMode = kCAFillModeForwards;
 group.removedOnCompletion = NO;
 group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 return group;
 }
 
 
 
 - (CALayer*) makeLayer {
 CALayer* rotateLayer = [CALayer layer];
 rotateLayer.frame = self.view.frame;
 
 rotateLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
 CATransform3D sublayerTransform = CATransform3DIdentity;
 sublayerTransform.m34 = 1.0 / -750;
 [rotateLayer setSublayerTransform:sublayerTransform];
 return rotateLayer;
 }
 
 
 - (CALayer*) layerFromView:(UIView*)view {
 CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height);
 CALayer* imageLayer = [CALayer layer];
 imageLayer.anchorPoint = CGPointMake(1, 1);
 imageLayer.frame = rect;
 
 UIGraphicsBeginImageContext(view.frame.size);
 [view.layer renderInContext:UIGraphicsGetCurrentContext()];
 UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 imageLayer.contents = (__bridge id) [viewImage CGImage];
 return imageLayer;
 }
 
 - (CALayer*) layerFromView:(UIView*)view withTransform:(CATransform3D)transform
 {
 CALayer *layer = [self layerFromView:view];
 layer.transform = transform;
 return layer;
 }
 - (UIView*) makeBackgroundWithColor:(UIColor*)color {
 UIView* background = [[UIView alloc] initWithFrame:self.view.frame];
 [background setBackgroundColor:color];
 return background;
 }
 
 
 - (void) animationDidStop:(CAAnimation*)animation finished:(BOOL)finished {
 [objc_getAssociatedObject(self, rotationLayerKey) removeFromSuperlayer];
 [objc_getAssociatedObject(self, backgroundKey) removeFromSuperview];
 }
 
 
 - (void)pushViewControllerMoveInFromBottom:(UIViewController *)viewController {
 
 CALayer* rotateLayer = [self makeLayer];
 CATransform3D world = CATransform3DMakeTranslation(0, 0, 0);
 [rotateLayer addSublayer:[self layerFromView:self.view withTransform:world]];
 world = CATransform3DRotate(world, radians(90), 0, 1, 0);
 world = CATransform3DTranslate(world, CUBESIZE, 0, 0);
 
 [self pushViewController:viewController animated:NO];
 [rotateLayer addSublayer:[self layerFromView:self.view withTransform:world]];
 
 UIView* background = [self makeBackgroundWithColor:[UIColor blackColor]];
 [self.view addSubview:background];
 
 [self.view.layer addSublayer:rotateLayer];
 [rotateLayer addAnimation:[self makeRotationAnimation:RightToLeft duration:0.50f] forKey:nil];
 
 
 objc_setAssociatedObject(self, rotationLayerKey, rotateLayer, OBJC_ASSOCIATION_ASSIGN);
 objc_setAssociatedObject(self, backgroundKey, background, OBJC_ASSOCIATION_ASSIGN);
 //   [[[[self.view subviews] objectAtIndex:0] layer] addAnimation:animation forKey:nil];
 // [self  pushViewController:viewController animated:NO];
 
 
 }
 
 - (void)popViewControllerMoveInFromTop {
 
 CALayer* rotateLayer = [self makeLayer];
 CATransform3D world = CATransform3DMakeTranslation(0, 0, 0);
 [rotateLayer addSublayer:[self layerFromView:self.view withTransform:world]];
 world = CATransform3DRotate(world, radians(90), 0, 1, 0);
 world = CATransform3DTranslate(world, CUBESIZE, 0, 0);
 world = CATransform3DRotate(world, radians(90), 0, 1, 0);
 world = CATransform3DTranslate(world, CUBESIZE, 0, 0);
 world = CATransform3DRotate(world, radians(90), 0, 1, 0);
 world = CATransform3DTranslate(world, CUBESIZE, 0, 0);
 
 [self popViewControllerAnimated:NO];
 
 [rotateLayer addSublayer:[self layerFromView:self.view withTransform:world]];
 
 
 UIView* background = [self makeBackgroundWithColor:[UIColor blackColor]];
 [self.view addSubview:background];
 
 [self.view.layer addSublayer:rotateLayer];
 [rotateLayer addAnimation:[self makeRotationAnimation:LeftToRight duration:0.50f] forKey:nil];
 objc_setAssociatedObject(self, rotationLayerKey, rotateLayer, OBJC_ASSOCIATION_ASSIGN);
 objc_setAssociatedObject(self, backgroundKey, background, OBJC_ASSOCIATION_ASSIGN);
 
 
 
 
 }
 
 
 
 */




@end
