//
//  MobileLiveUserTalkCell.h
//  GSSHOP
//
//  Created by nami0342 on 11/02/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileLiveUserTalkCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel      *m_lbText;
@property (nonatomic, strong) IBOutlet UIView       *m_bgText;
@property (nonatomic, strong) IBOutlet UILabel      *m_lbName;
@property (nonatomic, assign) id m_idParent;

//@property (nonatomic, strong) IBOutlet UIView       *m_bgEmoticon;
//@property (nonatomic, strong) IBOutlet UIImageView  *m_imvEmoticon;


- (void) setCellInfoNDrawData : (NSDictionary *) dicData;
@end
