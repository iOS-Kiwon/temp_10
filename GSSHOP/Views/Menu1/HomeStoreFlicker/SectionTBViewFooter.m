//
//  SectionTBViewFooter.m
//  GSSHOP
//
//  Created by gsshop on 2015. 10. 23..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionTBViewFooter.h"
#import "AppDelegate.h"



@implementation SectionTBViewFooter

@synthesize target;

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe {
    
    self = [super init];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SectionTBViewFooter" owner:self options:nil];
        self = [nibs objectAtIndex:0];
        target = sender;
        self.frame = tframe;
        lblProvision.text = GSSLocalizedString(@"sectionview_tablefooter_provision");
        lblPrivacy.text = GSSLocalizedString(@"sectionview_tablefooter_privacy");
        lblYouth.text = GSSLocalizedString(@"sectionview_tablefooter_youth");
        lblApppush.text = GSSLocalizedString(@"sectionview_tablefooter_apppush");
        lblInfoCeo.text = GSSLocalizedString(@"layout_main_info_ceo");
        lblInfo.text = GSSLocalizedString(@"layout_main_info");
        lblInfoLogo.text = GSSLocalizedString(@"layout_main_info_logo");
        lblsinfo.text = GSSLocalizedString(@"layout_main_info_sub1");
        lblbank.text = GSSLocalizedString(@"layout_main_info_sub2");
    }
    return self;
}

-(IBAction)onBtnContents:(id)sender{
    if ([target respondsToSelector:@selector(btntouchAction:)]) {
        [target btntouchAction:sender];
    }
}

- (IBAction)clickCall:(id)sender {
    if ([target respondsToSelector:@selector(btntouchAction:)]) {
        [target btntouchAction:sender];
    }
}


- (void)cornnerRound:(UIView*) view {
    UIBezierPath *maskPath_go = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer *maskLayer_go = [CAShapeLayer layer];
    maskLayer_go.frame = view.bounds;
    maskLayer_go.path = maskPath_go.CGPath;
    view.layer.mask = maskLayer_go;
}



@end
