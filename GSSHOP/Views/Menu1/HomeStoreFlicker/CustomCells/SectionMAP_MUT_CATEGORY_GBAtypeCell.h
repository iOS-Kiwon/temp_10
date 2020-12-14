//
//  SectionMAP_MUT_CATEGORY_GBAtypeCell.h
//  GSSHOP
//
//  Created by admin on 2017. 8. 11..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionMAP_MUT_CATEGORY_GBAtypeCell : UITableViewCell {
    IBOutlet UIView *viewBG;                        //백그라운드 뷰
    NSArray *arrCateInfo;                                       //카테고리 정보 배열
}


@property (nonatomic, weak) id target;              //클릭시 이벤트를 보낼 타겟

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo seletedIndex:(NSInteger)index;
-(void) setCateIndex:(NSInteger)indexCategory;

@end
