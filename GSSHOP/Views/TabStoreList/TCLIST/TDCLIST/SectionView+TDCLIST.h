//
//  SectionView+TDCLIST.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 16..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//


#import "SectionView.h"


#define TDC_SECTION_TAB1_TAG 40001
#define TDC_SECTION_TAB2_TAG 40002

@interface SectionView (TDCLIST)

//-(void)TDCScreenAlldefine;
- (void)ScreenDefineTDCWith:(BOOL)isReDefine;
- (void)ScreenDefineTDCLIST;
- (void)ScreenReDefineTDCLIST;

//- (TDCSectionTabView *)viewtdcheaderView;

-(UIView*)TDCRightRefreshGuideView;

//protocol method
//-(void)SELECTEDTDCTABWITHTAG:(NSNumber*)tnum;
 

@end
