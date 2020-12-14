//
//  SectionBAN_ORD_GBAtypeview.h
//  GSSHOP
//
//  Created by admin on 10/04/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#define BAN_ORD_GBA_view_HEIGHT 80.0
NS_ASSUME_NONNULL_BEGIN

@interface SectionBAN_ORD_GBAtypeview : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *btnOdr;
@property (weak, nonatomic) IBOutlet UIButton *btnPop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthSize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightSize;
@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSArray *arrRow;
- (IBAction)ordAction:(id)sender;
- (IBAction)popAction:(id)sender;
- (void) setCellInfo:(NSDictionary*)infoDic index:(NSInteger)index target:(id)targetId;
@end

NS_ASSUME_NONNULL_END
