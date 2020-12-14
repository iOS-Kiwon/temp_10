//
//  SectionMAP_CX_GBB_MOREtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 29..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionMAP_CX_GBB_MOREtypeCell : UITableViewCell
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSDictionary *dicInfo;
@property (nonatomic, strong) NSIndexPath *idxPath;
@property (nonatomic, strong) IBOutlet UIView *viewGoShop;

- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic indexPath:(NSIndexPath *)path;
- (IBAction)onBtnGoShop:(id)sender;
- (IBAction)onBtnMore:(id)sender;
@end
