//
//  FXCListTBViewController.h
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  플랙서블 매장용 테이블뷰 컨트롤러

#import "SectionTBViewController.h"

@interface FXCListTBViewController : SectionTBViewController {
    
}
@property (nonatomic,assign) NSInteger indexFXC;            //상단 카테고리 탭이 있는경우 인덱스값
@property (nonatomic,weak) id sectionView;                  //상위 sectionView

- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo;       //초기화
- (void)checkDeallocFXC;
@end
