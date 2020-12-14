//
//  MochaUIRatingAbstractCore.h
//  GSSHOP
//
//  Created by Hoecheon Kim on 12. 10. 16..
//  Copyright (c) 2012년 GS홈쇼핑. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MochaUIRatingScaleCore.h"


/**
 * @brief MochaUIRatingAbstractCore
 * 별점을 입력받기 위한 컨트롤러 Default 탬플릿의 protocol 정의, 본 NSObject를 재정의(상속)받거나 수정함으로서 확장가능.
 */


@interface MochaUIRatingAbstractCore : NSObject <MochaUIRatingScaleCore> {
	float rating;
	int imageWidth;
	int zeroAreaWidth;
@private
	UIImage * onImage;
	UIImage * offImage;
	UIImage * halfOnImage;
}

/**
 *  선택 아이콘의 0이되는 width범위 return
 *  ex) 이미지width의 1/3 영역정도
 *
 */

-(int) calcZeroAreaWidth;

/**
 *  swipe 시 최초 터치된 좌표로부터 계산된 rating값을 바탕으로 on,off,halfon 이미지값 반환
 *  return (UIImage)
 *
 */

-(UIImage *) imageForIndex:(int) index;


/**
 *  swipe 시 최초 터치된 좌표로부터 계산된 rating값- 시작 rating point 리턴
 *  return (float)
 *
 */

-(float) calcRatingFromTouchX:(int) touchX;

@end