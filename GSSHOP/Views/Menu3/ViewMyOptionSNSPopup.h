//
//  ViewMyOptionSNSPopup.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 7. 12..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewMyOptionSNSPopup : UIView
@property (nonatomic,strong) IBOutlet UIView *viewPopupContents;
@property (nonatomic,strong) IBOutlet UILabel *lblTop;
@property (nonatomic,strong) IBOutlet UILabel *lblGround;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *lconstPopupViewHeight;

-(void)setViewInfoNDrawData:(NSDictionary*)dicToSet;
-(IBAction)onBtnClose:(id)sender;

@end
