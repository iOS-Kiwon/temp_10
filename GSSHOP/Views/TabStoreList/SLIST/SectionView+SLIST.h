//
//  SectionView+SLIST.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 3. 28..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionView.h"

@interface SectionView (SLIST)
- (void)ScreenDefineSLIST;                    //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineSLIST;                  //리로드시 호출 , 캐시 사용함
- (void)ScreenDefineSLISTWith:(BOOL)isReDefine broadType:(NSString *)type;
- (void)loadBroadTypeSLIST:(NSString *) type;

@end
