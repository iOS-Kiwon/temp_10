//
//  UIImageReflection.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 7. 25..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

 
#import <UIKit/UIKit.h>

/**
 * @brief UIImage Categories 구현 - 거울에 비치는 이미지 효과를 간단하게 구현  
 * 몰의 상품진열용 UI를 고려하여 이미지 하단부 효과를 주기위해 구현.
 */

@interface UIImage (MochaUIImageReflection)
/**
 *   UIImage 객체내에 확장 구현된 기능으로 [UIImage객체명 addImageReflection:0.3]; 과 같이 사용.
 *
 *   @param reflectionFraction 이미지의 하단의 몇퍼센트정도에 효과를 적용할것인가에 관한 수치   (CGFloat)
 *   @return UIImage
 *
 *   @see TutorialApp UI - PeekScroll_ViewController 부분참조.
 */

- (UIImage *)addImageReflection:(CGFloat)reflectionFraction;

@end