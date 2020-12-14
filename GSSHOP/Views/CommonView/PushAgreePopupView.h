//
//  PushAgreePopupView.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 3. 9..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushAgreePopupView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *infoImg;
@property (weak, nonatomic) IBOutlet UIImageView *ContentImg;
@property (weak, nonatomic) id atarget;

@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnNoBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnOkBottomMargin;
@end
