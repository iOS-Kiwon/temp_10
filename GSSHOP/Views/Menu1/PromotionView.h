//
//  PromotionView.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 6. 20..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PromotionView : UIView {
    IBOutlet UIImageView *promoimg;
    NSDictionary *promoDic;
    
    IBOutlet UIScrollView *imgscrollview;

    
    
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    
    IBOutlet UIView *hline1;
    IBOutlet UIView *hline2;

}
@property (nonatomic, weak) id target;

-(void)setPromotionInfoData:(NSDictionary *)dic andTarget:(id)sender andImageData:(NSData *)dataImage;
-(IBAction)clickBtn:(id)sender;

@end
