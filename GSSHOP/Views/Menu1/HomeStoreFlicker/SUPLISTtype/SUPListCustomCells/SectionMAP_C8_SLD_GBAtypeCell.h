//
//  SectionMAP_C8_SLD_GBAtypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 11. 22..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionMAP_C8_SLD_GBAtypeSubCell.h"

@interface SectionMAP_C8_SLD_GBAtypeCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) id target;
- (void)setCellInfoNDrawData:(NSDictionary*) rowInfoDic;
- (void)onBtnMAP_C8_Category:(NSDictionary *)dicRow;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *clsButton;
@property (nonatomic,weak) NSIndexPath *myIndex;
@property (nonatomic, weak) NSString *searchLink;
- (IBAction)searchBtn:(id)sender;
@end
