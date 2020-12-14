//
//  MochaUIRating.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 10. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MochaUIRatingScaleCore.h"
 
 
@class MochaUIRating;

@protocol MochaUIRatingDelegate
@optional
-(void) DidChangePoint:(MochaUIRating *) rating;
@end




//별점 스케일 half... 스타일 추가확장
typedef enum {
	MochaRatingScaleWhole,
    MochaRatingScaleHalf
} MochaRatingScale;




/**
 * @brief MochaUIRating
 * 별점을 입력받기 위한 UIController로 터치-swipe 방식의 부드러운 효과 포함.
 */

@interface MochaUIRating : UIControl{
    
@private
    
    
    MochaRatingScale scale;
    
    NSObject<MochaUIRatingDelegate> * __weak delegate;
    int iconCount;
    
    int lastTouchX;
    NSObject<MochaUIRatingScaleCore> * scalecore;
    
  
}


@property(weak,nonatomic) NSObject<MochaUIRatingDelegate> * delegate;

/**
 *  self view boundary 내에 표현할 star icon의 갯수.
 *
 *   3~5개의 숫자로 제한 
 *
 */

@property (nonatomic) int iconCount;

/**
 *  self controller의 탬플릿 값.
 *
 *  MochaRatingScaleWhole 만 현재 구현 사용.
 *
 */
@property (nonatomic) MochaRatingScale scale;

/**
 *  사용자가 선택한 좌표를 바탕으로 계산된 별점 (float) value
 *
 */
@property (nonatomic) float rating;

 

/**
 *  사용자가 선택한 좌표를 바탕으로 표현할 icon중 선택영역에 표현할 icon UIImage -on상태의 이미지
 *
 */
@property (nonatomic, strong) UIImage *onRatingImage;

/**
 *  사용자가 선택한 좌표를 바탕으로 표현할 icon중 선택하지 않은 영역에 표현할 icon UIImage -off상태 이미지
 *
 */
@property (nonatomic, strong) UIImage *offRatingImage;

/**
 *  사용자가 선택한 좌표를 바탕으로 표현할 icon중 절반선택한 영역에 표현할 icon UIImage -scale에 따라다를수있으나 Wholescale기준 0.5별점에 사용할 이미지
 *
 */
@property (nonatomic, strong) UIImage *halfRatingImage;


@end
