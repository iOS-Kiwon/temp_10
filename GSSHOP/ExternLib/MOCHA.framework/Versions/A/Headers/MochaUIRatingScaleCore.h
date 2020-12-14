//
//  MochaUIRatingScaleCore.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 10. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

 

/**
 * @brief MochaUIRatingScaleCore
 * 별점을 입력받기 위한 컨트롤러 Default 탬플릿의 protocol 정의, MochaUIRatingAbstractCore Class가 상속하고 템플릿 별로MochaUIRatingAbstractCore class를 상속받아 구현하는 구조를 만들기위함.
 */


@protocol MochaUIRatingScaleCore

/// ------------------------------------
/// @name Properties
/// ------------------------------------


/**
 *  사용자가 선택한 좌표를 바탕으로 표현할 icon중 선택영역에 표현할 icon UIImage -on상태의 이미지
 *
 */
@property (nonatomic, retain) UIImage * onImage;

/**
 *  사용자가 선택한 좌표를 바탕으로 표현할 icon중 선택하지 않은 영역에 표현할 icon UIImage -off상태 이미지
 *
 */
@property (nonatomic, retain) UIImage * offImage;


/**
 *  사용자가 선택한 좌표를 바탕으로 표현할 icon중 절반선택한 영역에 표현할 icon UIImage -scale에 따라다를수있으나 Wholescale기준 0.5별점에 사용할 이미지
 *
 */
@property (nonatomic, retain) UIImage * halfOnImage;

/// ------------------------------------
/// @name Messages
/// ------------------------------------


/**
 *  1~5(최대)까지의 iconcount max 값까지 아이콘 그리는 동작수행
 *
 *
 */

 
-(void) drawImageAtIndex:(int) index;

/**
 *  선택 아이콘의 0이되는 width범위 return
 *  ex) 이미지width의 1/3 영역정도
 *
 */
 
-(int) calcZeroAreaWidth;

/**
 *  swipe 시 최초 터치된 좌표로부터 계산된 rating값- 시작 rating point 리턴
 *  return (int)
 *
 */
 
-(float) calcNewRatingFromTouchX:(int) touchX;

/**
 *  interactive 효과(터치,스와이프)를 통해 얻어진 현재 rating point
 *  @property float rating
 *
 */
 
@property (nonatomic) float rating;

/**
 *  interactive 효과(터치,스와이프)를 통해 얻어진 현재 rating point를 NSString 형태로 반환
 *  @property NSString formattedRating
 *
 */
-(NSString *) formattedRating;

@end
