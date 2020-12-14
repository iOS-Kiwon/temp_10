//
//  SectionNTCHeaderBroadCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NTCBroadCastHeaderView.h"

@interface SectionNTCHeaderBroadCell : UITableViewCell

@property (strong, nonatomic) NTCBroadCastHeaderView *nalHeaderView;        //헤더뷰에 붙는 생방송 영역
@property (nonatomic, weak) id target;
@property (nonatomic, assign) BOOL isShowTop;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo cellHeight:(CGFloat)height;

@end
