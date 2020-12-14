//
//  SectionMAP_CX_GBA_3typeCell.h
//  GSSHOP
//
//  Created by admin on 2018. 3. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionMAP_CX_GBA_3typeCell : UITableViewCell
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSIndexPath* idxPath;
@property (nonatomic, strong) NSDictionary *row_dic;                            //셀 전체를 구성할때 사용하는 데이터
@property (weak, nonatomic) IBOutlet UIView *openView; //더보기 뷰
@property (weak, nonatomic) IBOutlet UIView *moreView; //매장 이동 뷰
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
//더보기는. YES, 매장이동은 NO
- (void)setOpen:(BOOL) more;
- (BOOL)isOpen;
@end
