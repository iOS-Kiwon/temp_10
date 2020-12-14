//
//  SectionMAP_CX_GBB_CATEtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 01/07/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SectionMAP_CX_GBB_CATEtypeCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIView *viewDefault;
@property (nonatomic,strong) NSIndexPath *path;
- (void)setCellInfoNDrawData:(NSArray*)arrInfo andIndex:(NSInteger)idxSelected andTarget:(id)aTarget;
@end
