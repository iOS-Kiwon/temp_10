//
//  SectionView+NFXCLIST.h
//  GSSHOP
//
//  Created by gsshop iOS on 13/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "SectionView.h"

@interface SectionView (NFXCLIST)
- (void)ScreenDefineNFXCLIST;                    //초기 디파인, 강제 리로드시 호출 , 캐시 사용안함
- (void)ScreenReDefineNFXCLIST;                  //리로드시 호출 , 캐시 사용함
- (void)ScreenDefineNFXCLISTWith:(BOOL)isReDefine;
@end


