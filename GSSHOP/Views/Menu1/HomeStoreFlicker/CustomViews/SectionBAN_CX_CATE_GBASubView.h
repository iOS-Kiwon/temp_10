//
//  SectionBAN_CX_CATE_GBASubView.h
//  GSSHOP
//
//  Created by admin on 2018. 6. 25..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kHEIGHTCATE 34.0f
#define CX_CATE_HEIGHT 54.0f
@interface SectionBAN_CX_CATE_GBASubView : UIView {
    NSArray *arrCateInfo;                                       //카테고리 정보 배열
    NSInteger idxSeleted;                                       //선택된 인덱스값 , 꼭 하나는 선텍 되어야함
}
@property (weak, nonatomic) IBOutlet UIView *viewCate;
@property (nonatomic, weak) id target;                           //클릭시 이벤트를 보낼 타겟
- (void) setCellInfo:(NSDictionary*)infoDic index:(NSInteger)index target:(id)targetId;
- (void) setCateIndex:(NSInteger)indexCategory;

@end
