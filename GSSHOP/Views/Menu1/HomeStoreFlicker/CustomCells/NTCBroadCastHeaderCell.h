//
//  NTCBroadCastHeaderCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTCBroadCastHeaderView;

@interface NTCBroadCastHeaderCell : UITableViewCell {
    
}

@property (nonatomic,strong) NTCBroadCastHeaderView *nalHeaderView;

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic;

@end
