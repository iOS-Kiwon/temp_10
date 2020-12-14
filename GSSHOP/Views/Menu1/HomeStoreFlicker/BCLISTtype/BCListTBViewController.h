//
//  BCListTBViewController.h
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 18..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  매장형 브랜드관
//  섹션 해더에 슬라이딩 가능한 배너 , 브랜드 카테고리별 2차원배열 데이터를 표현
//  2016.06.28 현재 노출 안되고 있음


#import <UIKit/UIKit.h>
#import "SectionTBViewController.h"
#import "BrandBannerListView.h"
 
@interface BCListTBViewController : SectionTBViewController {

    int selcategorybtntag;
    UIButton* btn_cate1;
    UIButton* btn_cate2;
    UIButton* btn_cate3;
    UIButton* btn_cate4;
    
    NSTimer *timer;
    BOOL isTimer;
}

@property (nonatomic, strong) UIView *tbheaderv;
@property (nonatomic, strong) NSMutableArray *brandBannerarr;

- (id)initWithSectionResult:(NSDictionary *)resultDic sectioninfo:(NSDictionary*)secinfo;
- (void)btntouchCategory:(id)sender;
- (UIView *)sectionFooterViewForBrand ;
- (UIView *)sectionHeaderViewForBrandWithSection:(NSInteger)section;

@end
