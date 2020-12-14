//
//  SectionNSTFCMoreView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionNSTFCMoreView : UITableViewHeaderFooterView

@property (nonatomic, strong) IBOutlet UIView *viewDefault;
@property (nonatomic, strong) IBOutlet UIView *viewBtn;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) IBOutlet UIView *viewLineTop;
@property (nonatomic, strong) IBOutlet UIView *viewLineBottom;

@property (nonatomic, strong) IBOutlet UIView *viewNoData;


-(void)setMoreModeNalbang:(BOOL)isNalBang;

@end
