//
//  ViewMyOptionSNSPopup.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 7. 12..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "ViewMyOptionSNSPopup.h"
#import "AppDelegate.h"

@implementation ViewMyOptionSNSPopup

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
    
    self.viewPopupContents.layer.cornerRadius = 4.0;
    self.viewPopupContents.layer.shouldRasterize = YES;
    self.viewPopupContents.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    
    // 팝업 애니메이션
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = 0.2;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.2],
                        [NSNumber numberWithFloat:0.6],
                        [NSNumber numberWithFloat:1.0],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    [self.viewPopupContents.layer addAnimation:animation forKey:@"scaleAnimation"];
    
}

-(void)dealloc{
    NSLog(@"");
}

-(void)setViewInfoNDrawData:(NSDictionary*)dicToSet{
    
    
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                    NSForegroundColorAttributeName : [Mocha_Util getColor:@"111111"]
                                    };
    NSDictionary *specialTextAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                      NSForegroundColorAttributeName : [Mocha_Util getColor:@"00A4B3"]
                                      };
    
    
    
    NSString *strTop = NCS([dicToSet objectForKey:@"msgTop"]);
    NSString *strEmail = NCS([dicToSet objectForKey:@"email"]);
    NSString *strBottom = NCS([dicToSet objectForKey:@"msgBottom"]);
    NSString *strGround = NCS([dicToSet objectForKey:@"groundMsg"]);
    
    NSMutableAttributedString *attrTopAll = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSMutableAttributedString *attrTop = [[NSMutableAttributedString alloc]initWithString:strTop attributes:nomalTextAttr];
    NSMutableAttributedString *attrEmail = [[NSMutableAttributedString alloc]initWithString:strEmail attributes:specialTextAttr];
    NSMutableAttributedString *attrBottom = [[NSMutableAttributedString alloc]initWithString:strBottom attributes:nomalTextAttr];
    
    
    [attrTopAll appendAttributedString:attrTop];
    [attrTopAll appendAttributedString:attrEmail];
    [attrTopAll appendAttributedString:attrBottom];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    [attrTopAll addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrTopAll.string length])];
    
    self.lblTop.attributedText = attrTopAll;
    self.lblGround.text = strGround;
    
    CGSize topSize = [attrTopAll.string MochaSizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(self.viewPopupContents.frame.size.width - 30.0, 300.0) lineBreakMode:NSLineBreakByClipping];
    
    CGSize groundSize = [strGround MochaSizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(self.viewPopupContents.frame.size.width - 30.0, 300.0) lineBreakMode:NSLineBreakByClipping];
    
    
    self.lconstPopupViewHeight.constant = 25.0 + topSize.height + 19.0 + groundSize.height + 25.0 + 45.0;
    
    [self.viewPopupContents layoutIfNeeded];
    
}

-(IBAction)onBtnClose:(id)sender{
    [self removeFromSuperview];
}

@end
