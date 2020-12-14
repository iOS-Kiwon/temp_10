//
//  SectionB_INStypeCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  백화점 매장에서만 사용되는 얇은띠형 이미지 , 클릭도 없음

#import <UIKit/UIKit.h>

@interface SectionB_INStypeCell : UITableViewCell
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic, strong) IBOutlet UIImageView *imgBanner;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo;

@end
