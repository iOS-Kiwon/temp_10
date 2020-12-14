//
//  ShortBangTransition.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 7..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "ShortBangTransition.h"

@interface ShortBangTransition ()
@property (nonatomic,assign)CGRect aniRect;
@property (nonatomic,assign)BOOL isPush;
@end

@implementation ShortBangTransition
@synthesize aniRect;
@synthesize isPush;

-(id)initWithFrame:(CGRect)imageRect isPushView:(BOOL)push{
    
    self = [super init];
    if (self != nil) {
        self.aniRect = imageRect;
        self.isPush = push;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(self.isPush){
        return 0.4;
    }else{
        return 0.4;
    }
    
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    
    
    UICollectionViewController *fromVC = (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController *toVC = (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPush) {
        [transitionContext.containerView addSubview:toVC.view];
    
        toVC.view.center = CGPointMake(CGRectGetMidX(self.aniRect), CGRectGetMidY(self.aniRect));
        
        //toVC.view.frame = self.aniRect;
        
        
        
        toVC.view.transform = CGAffineTransformMakeScale(self.aniRect.size.width/APPFULLWIDTH, self.aniRect.size.height/APPFULLHEIGHT);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
             usingSpringWithDamping:1.0
              initialSpringVelocity:1.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toVC.view.center = CGPointMake(APPFULLWIDTH/2.0, APPFULLHEIGHT/2.0);
                             toVC.view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }else{
        
        
        [transitionContext.containerView addSubview:toVC.view];
        [transitionContext.containerView addSubview:fromVC.view];
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             fromVC.view.center = CGPointMake(CGRectGetMidX(self.aniRect), CGRectGetMidY(self.aniRect)-20.0);
                             
                             //fromVC.view.frame = self.aniRect;
                             
                             fromVC.view.transform = CGAffineTransformMakeScale(self.aniRect.size.width/APPFULLWIDTH, self.aniRect.size.height/APPFULLHEIGHT);
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }
    
    
}


@end
