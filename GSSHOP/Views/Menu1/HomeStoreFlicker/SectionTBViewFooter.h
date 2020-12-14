//
//  SectionTBViewFooter.h
//  GSSHOP
//
//  Created by gsshop on 2015. 10. 23..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyUnderlinedLabel.h"

@interface SectionTBViewFooter : UIView{
    
    IBOutlet UILabel *lblProvision;
    IBOutlet UILabel *lblPrivacy;
    IBOutlet UILabel *lblYouth;
    IBOutlet UILabel *lblApppush;
    
    IBOutlet UILabel *lblInfoCeo;
    IBOutlet UILabel *lblInfo;
    IBOutlet UILabel *lblInfoLogo;
    
    IBOutlet UIView *sinfo;
    IBOutlet UILabel *lblsinfo;
    IBOutlet UIView *bank;
    IBOutlet UILabel *lblbank;
    IBOutlet UIView *telInfo;
    
}

@property (nonatomic,weak) id target;

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe;
- (IBAction)onBtnContents:(id)sender;
- (IBAction)clickCall:(id)sender;


@end
