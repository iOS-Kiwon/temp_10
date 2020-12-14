//
//  SectionMAP_C8_SLD_GBAtypeSubCell.h
//  GSSHOP
//
//  Created by admin on 11/03/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAP_C8_SLD_GBA_SUB_CELL_HEIGHT 200
NS_ASSUME_NONNULL_BEGIN
static NSString *MAP_C8_SLD_GBASubTypeIdentifier = @"SectionMAP_C8_SLD_GBAtypeSubCell";
@interface SectionMAP_C8_SLD_GBAtypeSubCell : UICollectionViewCell
@property (nonatomic, weak) id targetCell;
@property (nonatomic, weak) NSArray *arrDic;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topTextView;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;

- (IBAction)cateAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTextView;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;


-(void) setCellInfoNDrawData:(NSArray*)arrRowInfo;
@end

NS_ASSUME_NONNULL_END
