//
//  SectionView+NSTFCLIST.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionView.h"

@interface SectionView (NSTFCLIST)
- (void)ScreenDefineNSTFCLIST;                    //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineNSTFCLIST;                  //리로드시 호출 , 캐시 사용함
- (void)ScreenDefineNSTFCWith:(BOOL)isReDefine;   //숏방테이블뷰 디파인
@end
