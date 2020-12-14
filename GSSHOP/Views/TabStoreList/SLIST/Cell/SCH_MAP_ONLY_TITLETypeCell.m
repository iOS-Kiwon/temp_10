//
//  SCH_MAP_ONLY_TITLETypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 4. 25..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_MAP_ONLY_TITLETypeCell.h"
#import "SListTBViewController.h"

@implementation SCH_MAP_ONLY_TITLETypeCell
@synthesize lblTitle;
@synthesize btnLink;
@synthesize target;
@synthesize viewWhiteBG;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.viewWhiteBG.backgroundColor = [UIColor whiteColor];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.lblTitle.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)onBtnLink:(id)sender{
    if ([self.target respondsToSelector:@selector(touchEventTBCell:)] && NCO([self.dicAll objectForKey:@"product"])) {
        [self.target touchEventTBCell:[self.dicAll objectForKey:@"product"]];
    }
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr{
    self.dicAll = rowinfoArr;
    
    // Show Message
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                    };
    NSDictionary *boldTextAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]
                                   };
    
    NSString *strStartTime = [self.dicAll objectForKey:@"startTime"];
    //NSString *strBroadTime = [NSString stringWithFormat:@"%@:%@",[strStartTime substringWithRange:NSMakeRange(8, 2)],[strStartTime substringWithRange:NSMakeRange(10, 2)]];
    
    //NSString *strBroadTime = NCS([self.dicAll objectForKey:@"startTime"]);
    NSMutableAttributedString *strAttr = [[NSMutableAttributedString alloc]initWithString:strStartTime attributes:nomalTextAttr];
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9:]" options:0 error:&error];
    NSArray *arrMatch = [regex matchesInString:strStartTime options:NSMatchingReportCompletion range:NSMakeRange(0, strStartTime.length)];
    
    //NSLog(@"arrMatch = %@",arrMatch);
    
    if ([arrMatch count] > 0) {
        for (NSTextCheckingResult *resultMatch in arrMatch) {
            [strAttr setAttributes:boldTextAttr range:resultMatch.range];
        }
    }
    
    self.lblTime.attributedText = strAttr;
    self.lblTitle.text = NCS([[self.dicAll objectForKey:@"product"] objectForKey:@"exposPrdName"]);
    
    [self.viewTopPromotion layoutIfNeeded];
    [self.viewWhiteBG layoutIfNeeded];
    [self layoutIfNeeded];
    
    UIBezierPath *maskPath_ph = [UIBezierPath bezierPathWithRoundedRect:self.viewTopPromotion.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(self.viewTopPromotion.frame.size.height, self.viewTopPromotion.frame.size.height)];
    CAShapeLayer *maskLayer_ph = [CAShapeLayer layer];
    maskLayer_ph.frame = self.viewTopPromotion.bounds;
    maskLayer_ph.path = maskPath_ph.CGPath;
    self.viewTopPromotion.layer.mask = maskLayer_ph;
}

@end
