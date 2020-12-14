//
//  InfoCommLawPopupView.h
//  GSSHOP
//
//  Created by Parksegun on 2017. 3. 6..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCommLawPopupView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnOk;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnOkBottomMargin;

- (IBAction)oOk:(id)sender;


@end
