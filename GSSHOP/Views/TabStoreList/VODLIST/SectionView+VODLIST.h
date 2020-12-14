//
//  SectionView+VODLIST.h
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 4. 8..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import "SectionView.h"

@interface SectionView (VODLIST) {
    
}
- (void)ScreenDefineVODLIST;                    //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineVODLIST;                  //리로드시 호출 , 캐시 사용함
- (void)ScreenDefineVODLISTWith:(BOOL)isReDefine;

@end
