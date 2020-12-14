//
//  ShortBangTransition.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 7..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortBangTransition : NSObject <UIViewControllerAnimatedTransitioning>

-(id)initWithFrame:(CGRect)imageRect isPushView:(BOOL)push;
@end
