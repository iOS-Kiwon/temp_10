//
//  SectionBAN_TXT_IMG_COLOR_GBAtypeCell.m
//  GSSHOP
//
//  Created by admin on 2018. 4. 24..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_TXT_IMG_COLOR_GBAtypeCell.h"
#import "AppDelegate.h"
//#import "SectionTBViewController.h"

@implementation SectionBAN_TXT_IMG_COLOR_GBAtypeCell

@synthesize imageIcon,userName,arrowImg;

- (void)awakeFromNib {
    [super awakeFromNib];
    apiUseYN = NO;
    self.arrowImg.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void) prepareForReuse {
    [super prepareForReuse];
    self.imageIcon.image = nil;
    self.userName.text = @"";
    self.arrowImg.hidden = YES;
}

- (void) callApisetCellInfoDrawData:(NSDictionary*) rowinfoDic {
    if(apiUseYN && NCO(self.row_dic)) { 
        [self setCellInfoNDrawData: self.row_dic];
        return;
    }
    apiUseYN = YES;
    NSString *apiURL = [Mocha_Util strReplace:[NSString stringWithFormat:@"%@/",SERVERURI] replace:@"" string:NCS([rowinfoDic objectForKey:@"linkUrl"])];
    apiURL = [Mocha_Util strReplace:@"http://mt.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://tm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://sm.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://tm14.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://sm20.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://dm13.gsshop.com/" replace:@"" string:apiURL];
    apiURL = [Mocha_Util strReplace:@"http://sm15.gsshop.com/" replace:@"" string:apiURL];
    
    // nami0342 - urlsession
    self.currentOperation1 = [ApplicationDelegate.gshop_http_core gsSECTIONUILISTURL:apiURL
                                                                                  isForceReload:YES
                                                                                   onCompletion:^(NSDictionary *result) {
                                                                                       dispatch_async( dispatch_get_main_queue(),^{
                                                                                           if ([self.targetTableView respondsToSelector:@selector(tableCellReloadForDic:cellIndex:)] && [NCS([result objectForKey:@"productName"]) length] == 0) {
                                                                                               //기본에 데이터가 없으면 구조체에서 날렸는데.. 동적배너시 높이 조정하다 오류발생!!! 그래서 뷰타입을 없는걸로 변경
                                                                                               NSIndexPath *path = [NSIndexPath indexPathForRow:self.idxRow inSection:0];
                                                                                               NSMutableDictionary *tempDic = [rowinfoDic mutableCopy];
                                                                                               [tempDic setValue:@"" forKey:@"viewType"];
                                                                                               [self.targetTableView tableCellReloadForDic:tempDic cellIndex: path];
                                                                                           }
                                                                                           else {
                                                                                               [self setCellInfoNDrawData:result];                                                                                               
                                                                                           }
                                                                                       });
                                                                                   }
                                                                                      onError:^(NSError* error) {
                                                                                          if ([self.targetTableView respondsToSelector:@selector(tableCellRemove:)]) {
                                                                                              //[self.targetTableView tableCellRemove:self.idxRow];
                                                                                              //기본에 데이터가 없으면 구조체에서 날렸는데.. 동적배너시 높이 조정하다 오류발생!!! 그래서 뷰타입을 없는걸로 변경
                                                                                              NSIndexPath *path = [NSIndexPath indexPathForRow:self.idxRow inSection:0];
                                                                                              NSMutableDictionary *tempDic = [rowinfoDic mutableCopy];
                                                                                              [tempDic setValue:@"" forKey:@"viewType"];
                                                                                              [self.targetTableView tableCellReloadForDic:tempDic cellIndex: path];
                                                                                          }
                                                                                      }];

}

- (IBAction)onClickLink:(id)sender {
    if (NCO(self.row_dic) && [self.targetTableView respondsToSelector:@selector(dctypetouchEventTBCell:andCnum:withCallType:)]) {
        [self.targetTableView dctypetouchEventTBCell:self.row_dic andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BAN_TXT_IMG_COLOR_GBA"];
    }
}

- (void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic {
    if(!NCO(self.row_dic)) {
        self.row_dic = rowinfoDic;
    }
    NSString *imgUrl = NCS([rowinfoDic objectForKey:@"imageUrl"]);
    if([imgUrl length] > 0) {
        [ImageDownManager blockImageDownWithURL:imgUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            if(error == nil  && [imgUrl isEqualToString:strInputURL]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                        self.imageIcon.image = fetchedImage;
                    }
                    else {
                        self.imageIcon.alpha = 0;
                        self.imageIcon.image = fetchedImage;
                        [UIView animateWithDuration:0.1f
                                              delay:0.0f
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.imageIcon.alpha = 1;
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                    }
                });
            }
        }];
    }
    
    NSDictionary *nomalTextAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:16],
                               NSForegroundColorAttributeName : [Mocha_Util getColor:@"111111"]
                               };
    NSDictionary *spetialTextAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
                                      NSForegroundColorAttributeName : [Mocha_Util getColor:([NCS([rowinfoDic objectForKey:@"etcText1"]) length] > 0)?NCS([rowinfoDic objectForKey:@"etcText1"]) : @"111111"]
                                    };
    
    NSString *preText = [NSString stringWithFormat:@"%@%@ ",NCS([[DataManager sharedManager] userName]),NCS([rowinfoDic objectForKey:@"productName"])];
    NSString *endText = [NSString stringWithFormat:@"%@ %@",NCS([rowinfoDic objectForKey:@"exposePriceText"]), NCS([rowinfoDic objectForKey:@"valueText"])];
    
    NSMutableAttributedString *attrPre = [[NSMutableAttributedString alloc]initWithString:preText attributes:nomalTextAttr];
    NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc]initWithString:NCS([rowinfoDic objectForKey:@"salePrice"]) attributes:spetialTextAttr];
    NSMutableAttributedString *attrEnd = [[NSMutableAttributedString alloc]initWithString:endText attributes:nomalTextAttr];
    [attrPrice appendAttributedString:attrEnd];
    [attrPre appendAttributedString:attrPrice];
    
    self.userName.attributedText = attrPre;
    
    if([NCS([rowinfoDic objectForKey:@"linkUrl"]) length] > 0 ) {
        self.arrowImg.hidden = NO;
    }
    else {
        self.arrowImg.hidden = YES;
    }
}


@end
