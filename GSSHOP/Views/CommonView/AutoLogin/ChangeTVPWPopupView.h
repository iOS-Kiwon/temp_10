//
//  ChangePWPopupView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 10. 24..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeTVPWPopupView : UIView
@property (nonatomic,strong) IBOutlet UIView *viewPopupContents;
@property (nonatomic,strong) NSString *strChangeUrl;
@property (nonatomic,strong) NSString *strUserKey;

-(IBAction)onClickBtn:(id)sender;
@end
