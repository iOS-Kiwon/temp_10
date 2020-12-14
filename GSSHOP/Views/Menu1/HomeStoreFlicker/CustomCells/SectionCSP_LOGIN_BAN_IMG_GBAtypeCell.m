//
//  SectionBAN_IMG_H000_GBAtypeCell.m
//  GSSHOP
//
//  Created by admin on 2017. 10. 17..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SectionCSP_LOGIN_BAN_IMG_GBAtypeCell.h"
#import "AppDelegate.h"

@implementation SectionCSP_LOGIN_BAN_IMG_GBAtypeCell
@synthesize imgBanner,targetTableView,idxRow;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    apiUseYN = NO;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    imgBanner.image = nil;
    self.accessibilityLabel = @"";
    self.lconstHeight.constant = 0.0;
}


- (void) callApisetCellInfoDrawData:(NSDictionary*) rowinfoDic {
    //이미 호출된게 있으면 넘어가유~
    if(NCO(rowinfoDic)) {
        self.accessibilityLabel = NCS([rowinfoDic objectForKey:@"productName"]);
    }
    
    if(apiUseYN && NCO(self.row_dic)) {
        [self setCellInfoNDrawData: self.row_dic];
        return;
    }
    apiUseYN = YES;
    //CSP 호출 있으면 내놔
    [self.targetTableView callCSP];
}


- (IBAction)btnClick:(id)sender {
    if([NCS([self.row_dic objectForKey:@"linkUrl"]) length] > 0) {
        if ([self.targetTableView respondsToSelector:@selector(dctypetouchEventTBCell:andCnum:withCallType:)]) {
            [self.targetTableView dctypetouchEventTBCell:self.row_dic andCnum:0 withCallType:@"CSP_LOGIN_BAN_IMG_GBA"];
            
            // nami0342 - 킅릭 시 CSP event도 호출
            [ApplicationDelegate CSP_SendEventWithView:NO];
        }
    }
}


- (void) setCellInfoNDrawData:(NSDictionary*) rowinfo {
    self.row_dic = rowinfo;
    self.backgroundColor = [UIColor clearColor];
    self.imgBanner.alpha = 0;
    self.imgBanner.image = [rowinfo objectForKey:@"image"];
    
    NSLog(@"rowinfo = %@",rowinfo);
    
    self.lconstHeight.constant = -kTVCBOTTOMMARGIN;
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.2f
                           delay:0.0f
                         options:UIViewAnimationOptionCurveEaseInOut
                      animations:^{
                          self.imgBanner.alpha = 1;
                      }
                      completion:^(BOOL finished) {
                          [self layoutIfNeeded];
                      }];
}

@end
