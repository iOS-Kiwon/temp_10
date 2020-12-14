//
//  SCH_BAN_THUMBTypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 5..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_PRO_BAN_THMTypeCell.h"

@implementation SCH_PRO_BAN_THMTypeCell

@synthesize onAirImg,backgroundImg,timeText,titleText,selectLine,imgDimm;


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.imgDimm.image = [UIImage imageNamed:@"timeline_on_dim.png"];
    self.onAirImg.hidden = YES;
    self.selectLine.hidden = YES;
    self.backgroundImg.image = nil;
    self.titleText.text = @"";
    self.titleText.textAlignment = NSTextAlignmentLeft;
    self.selectLine.layer.borderColor = [Mocha_Util getColor:@"FFFFFF"].CGColor;
    self.selectLine.layer.borderWidth = 4.0;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.onAirImg.hidden = YES;
    self.timeText.text = @"";
    self.selectLine.hidden = YES;
    self.backgroundImg.image = nil;
    self.titleText.text = @"";
    self.titleText.textAlignment = NSTextAlignmentLeft;
    self.imgDimm.image = [UIImage imageNamed:@"timeline_on_dim.png"];
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    if(NCO(rowinfoArr)) {
        celldic = rowinfoArr;
        if( !NCO([celldic objectForKey:@"product"]) ) {
            return;
        }
        
        imageURL = NCS([[celldic objectForKey:@"product"] objectForKey:@"subPrdImgUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        self.backgroundImg.image = fetchedImage;
                    }
                    else {
                    self.backgroundImg.alpha = 0;
                    self.backgroundImg.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         self.backgroundImg.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                     }];
                    }
                });
            }
        }];
        self.titleText.text = NCS([[celldic objectForKey:@"product"] objectForKey:@"prdName"]);
        self.timeText.text = NCS([celldic objectForKey:@"startTime"]);
    }
    else {
    }
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // 선택되면 사각 테두리를 만든다.
    self.selectLine.hidden = !selected;
}



// 생방송 상품 설정
- (void)setOnAir:(BOOL) isOnair {
    self.onAirImg.hidden = !isOnair;
    self.timeText.hidden = isOnair; // onAir이면 시간 숨김
}

@end
