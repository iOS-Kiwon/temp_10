//
//  SectionPCtypeSubCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 4. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionPCtypeSubCell.h"
#import "SectionPCtypeCell.h"

@implementation SectionPCtypeSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.viewProgram];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) prepareForReuse {
    [super prepareForReuse];
    self.imgProgram.image = [UIImage imageNamed:@"noimg_160.png"];
    self.imgLive.image = nil;
    self.lblProgramTime.text = @"";
    self.lblProgramTitle.text = @"";
    self.btnProgram.accessibilityLabel = @"";
}

- (void)setCellInfoNDrawData:(NSDictionary*)rowInfodic andIndexPath:(NSIndexPath *)path{
    self.backgroundColor = [UIColor clearColor]; //iOS7 iPad 백그라운드칼라 버그 수정용
    self.myPath = path;
    CGFloat widthFirstRow = 0.0;
    if (path.row == 0) {
        widthFirstRow = 10.0;
    }
    self.viewProgram.frame = CGRectMake(widthFirstRow, 0, 78.0, 122.0);
    if ([NCS([rowInfodic objectForKey:@"imageUrl"]) length] > 0 && [[rowInfodic objectForKey:@"imageUrl"] hasPrefix:@"http"]) {
        self.imageURL = NCS([rowInfodic objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if (error == nil  && [self.imageURL isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(isInCache) {
                        self.imgProgram.image = fetchedImage;
                    }
                    else {
                        self.imgProgram.alpha = 0;
                        self.imgProgram.image = fetchedImage;
                        
                        [UIView animateWithDuration:0.2f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.imgProgram.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                             
                                         }];
                    }
                });
            }
        }];
    }
    self.lblProgramTitle.text = NCS([rowInfodic objectForKey:@"productName"]);
    self.lblProgramTime.text = NCS([rowInfodic objectForKey:@"promotionName"]);
    self.btnProgram.accessibilityLabel = [NSString stringWithFormat:@"%@ %@",NCS([rowInfodic objectForKey:@"promotionName"]),NCS([rowInfodic objectForKey:@"productName"])];
}

- (IBAction)onBtnProgram {
    if ([self.delegate respondsToSelector:@selector(onBtnBanner:)]) {
        [self.delegate onBtnBanner:self.myPath];
    }
}

@end
