//
//  SectionBAN_CX_SLD_CATE_GBASubView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 5. 16..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iScroll.h"
#import "iCarousel.h"

#define SECTIONCX_SLDVIEWHEIGHT 44.0f

@interface SectionBAN_CX_SLD_CATE_GBASubView : UIView
@property (nonatomic,weak) id target;
@property (nonatomic, strong) iScroll *iScrollCate;

//2018.08.16 앰플리튜드 narava
- (void) setCellInfo:(NSDictionary*)infoDic index:(NSInteger)idxSelected target:(id)targetId sectionName:(NSString *)strSName;
- (void) subCategoryMoveWithGroupCode;//하위 카테고리 호출
@end
