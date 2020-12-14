//
//  SectionFPC_SubCategoryView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 11. 21..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionFPC_SubCategoryView : UIView

@property (nonatomic, weak) id target;
@property (nonatomic, strong) IBOutlet UIView *viewGreenBorder;

@property (nonatomic, strong) IBOutlet UILabel *lblSubCate;

-(void)setCellInfoLabelText:(NSString *)strSubCate;

-(IBAction)onBtnSubCategory:(id)sender;

@end
