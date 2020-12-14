//
//  SectionBAN_ORD_GBAtypeview.m
//  GSSHOP
//
//  Created by admin on 10/04/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_ORD_GBAtypeview.h"
#import "VODListTableViewController.h"

@implementation SectionBAN_ORD_GBAtypeview

- (void)awakeFromNib {
    [super awakeFromNib];
    // 초기값은 Odr이 활성
    [self.btnOdr setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateSelected];
    [self.btnOdr setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
    
    [self.btnPop setTitleColor:[Mocha_Util getColor:@"111111"] forState:UIControlStateSelected];
    [self.btnPop setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
    
    [self.btnOdr setSelected:YES];
    [self.btnPop setSelected:NO];    
}

- (void) setCellInfo:(NSDictionary*)infoDic index:(NSInteger)index target:(id)targetId {
    self.target = targetId;
    if(NCO(infoDic)) {
        [self setImageView:self.imgView withURL:NCS([infoDic objectForKey:@"imageUrl"])];
        self.arrRow = [infoDic objectForKey:@"subProductList"];
        if(NCA(self.arrRow)) {
            if(self.arrRow.count == 2) {
                self.btnOdr.hidden = NO;
                self.btnPop.hidden = NO;
                
                [self.btnOdr setTitle:[[self.arrRow objectAtIndex:0] objectForKey:@"productName"] forState:UIControlStateNormal];
                [self.btnOdr setTitle:[[self.arrRow objectAtIndex:0] objectForKey:@"productName"] forState:UIControlStateSelected];
                
                [self.btnPop setTitle:[[self.arrRow objectAtIndex:1] objectForKey:@"productName"] forState:UIControlStateNormal];
                [self.btnPop setTitle:[[self.arrRow objectAtIndex:1] objectForKey:@"productName"] forState:UIControlStateSelected];
            }
            else if(self.arrRow.count < 2) {
                self.btnOdr.hidden = NO;
                self.btnPop.hidden = YES;
                
                [self.btnOdr setTitle:[[self.arrRow objectAtIndex:0] objectForKey:@"productName"] forState:UIControlStateNormal];
                [self.btnOdr setTitle:[[self.arrRow objectAtIndex:0] objectForKey:@"productName"] forState:UIControlStateSelected];
            }
            else {
                self.btnOdr.hidden = YES;
                self.btnPop.hidden = YES;
            }
        }
        else {
            self.btnOdr.hidden = YES;
            self.btnPop.hidden = YES;
        }
    }
}

- (IBAction)ordAction:(id)sender {
    
    if (self.btnOdr.selected == YES) {
        return;
    }
    //추천
    [self.btnOdr setSelected:YES];
    [self.btnPop setSelected:NO];
    [self.target apiCall_ListChange:[self.arrRow objectAtIndex:0] andCnum:[NSNumber numberWithInt:0] withCallType:@"BAN_ORD_GBA"];
}

- (IBAction)popAction:(id)sender {
    if (self.btnPop.selected == YES) {
        return;
    }
    //인기
    [self.btnOdr setSelected:NO];
    [self.btnPop setSelected:YES];
    [self.target apiCall_ListChange:[self.arrRow objectAtIndex:1] andCnum:[NSNumber numberWithInt:1] withCallType:@"BAN_ORD_GBA"];
}


- (void) setImageView:(UIImageView *)imgView withURL:(NSString *)imageURL {
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil  && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgWidthSize.constant = fetchedImage.size.width/2;
                self.imgHeightSize.constant = fetchedImage.size.height/2;                
                if (isInCache) {
                    imgView.image = fetchedImage;
                }
                else {
                    imgView.alpha = 0;
                    imgView.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         imgView.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                     }];
                }
                
                [self.imgView layoutIfNeeded];
                [self layoutIfNeeded];
            });
        }
    }];
}
@end
