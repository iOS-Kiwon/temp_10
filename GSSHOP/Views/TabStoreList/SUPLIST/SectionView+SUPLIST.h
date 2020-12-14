//
//  SectionView+SUPLIST.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionView.h"

@interface SectionView (SUPLIST)
- (void)ScreenDefineSUPLIST;                    //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineSUPLIST;                  //리로드시 호출 , 캐시 사용함
- (void)ScreenDefineSUPLISTWith:(BOOL)isReDefine;

@end
