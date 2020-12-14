//
//  SectionView+NTCLIST.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  날방 섹션뷰

#import "SectionView.h"
@interface SectionView (NTCLIST)
- (void)ScreenDefineNTCLIST;                    //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineNTCLIST;                  //리로드시 호출 , 캐시 사용함
- (void)ScreenDefineNTCWith:(BOOL)isReDefine;   //날방테이블뷰 디파인


@end
