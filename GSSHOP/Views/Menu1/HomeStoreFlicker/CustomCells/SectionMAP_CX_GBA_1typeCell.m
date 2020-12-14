//
//  SectionMAP_CX_GBAtypeCell.m
//  GSSHOP
//
//  Created by admin on 2018. 3. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionMAP_CX_GBA_1typeCell.h"
#import "AppDelegate.h"

@implementation SectionMAP_CX_GBA_1typeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mainImg.image = nil;
    self.mainTitle.text = @"";
    self.accessibilityLabel = @"";
    self.btnZzim.accessibilityLabel = @"브랜드 찜하기";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



- (void) setCellInfoNDrawData:(NSDictionary*)rowinfoDic {
    self.backgroundColor = [UIColor clearColor];
    self.mainTitle.text = NCS([rowinfoDic objectForKey:@"productName"]);
    NSString *imageURL = NCS([rowinfoDic objectForKey:@"imageUrl"]);
    self.accessibilityLabel = NCS([rowinfoDic objectForKey:@"productName"]);
    
    self.zzimImg.highlighted = NCB([rowinfoDic objectForKey:@"isWish"]);
    
    zzimAddUrl = NCS([rowinfoDic objectForKey:@"brandWishAddUrl"]);
    zzimDelUrl = NCS([rowinfoDic objectForKey:@"brandWishRemoveUrl"]);
    
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isInCache) {
                    self.mainImg.image = fetchedImage;
                }
                else {
                    self.mainImg.alpha = 0;
                    self.mainImg.image = fetchedImage;
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         self.mainImg.alpha = 1;
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }
                     ];
                }
            });
        }
    }];
}


- (void) prepareForReuse {
    [super prepareForReuse];
    self.mainImg.image = nil;
    self.mainTitle.text = @"";
    self.zzimImg.highlighted = NO;
}


- (IBAction)zzimAction:(id)sender {
    
    //로그인 체크
    if(ApplicationDelegate.islogin == NO) {
        if(ApplicationDelegate.HMV.loginView == nil) {
            ApplicationDelegate.HMV.loginView = [[AutoLoginViewController alloc] initWithNibName:@"AutoLoginViewController" bundle:nil];
        }
        else {
            [ApplicationDelegate.HMV.loginView clearTextFields];
        }
        
        ApplicationDelegate.HMV.loginView.delegate = ApplicationDelegate.HMV;
        ApplicationDelegate.HMV.loginView.loginViewType = 33;
        ApplicationDelegate.HMV.loginView.loginViewMode = 0;
        ApplicationDelegate.HMV.loginView.view.hidden=NO;
        ApplicationDelegate.HMV.loginView.btn_naviBack.hidden = NO;
        if(![ApplicationDelegate.HMV.navigationController.topViewController isKindOfClass:[AutoLoginViewController class]]) {
            [ApplicationDelegate.HMV.navigationController pushViewControllerMoveInFromBottom:ApplicationDelegate.HMV.loginView];
        }
        return;
    }
    
    
    self.zzimImg.highlighted = !self.zzimImg.highlighted;
    BOOL isHighlightedZzimImg = self.zzimImg.highlighted;
    self.btnZzim.accessibilityLabel = isHighlightedZzimImg ? @"브랜드 찜 취소하기" : @"브랜드 찜하기";
    
    NSURL *turl = [NSURL URLWithString: self.zzimImg.highlighted ? zzimAddUrl : zzimDelUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"Contacting Server....");
    /*
    resultMessage : 결과 메세지
    resultCode : 결과 코드
    linkUrl : 링크 URL -  브랜드 바로가기 선택시 이동할 URL
    isFile : 파일 여부
    success : 성공 여부
    */
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:urlRequest
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if(!result) {
                        //실패
                        self.zzimImg.highlighted = NO;
                        self.btnZzim.accessibilityLabel = @"브랜드 찜하기";
                        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"잠시 후 다시 시도해주세요." maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                        [ApplicationDelegate.window addSubview:lalert];
                    }
                    else {
                        NSDictionary *resultj = [result JSONtoValue];
                        if( [NCB([resultj objectForKey:@"success"]) boolValue] ) {
                            //팝업 노출
                            [self.target brandZzimShowPopup:NCS([resultj objectForKey:@"linkUrl"]) add: isHighlightedZzimImg];
                            [self.target tableDataUpdate: isHighlightedZzimImg ? @"YES":@"NO" key:@"isWish" cellIndex:self.idxRow];
                        }
                        else {
                            //실패
                            self.zzimImg.highlighted = NO;
                            self.btnZzim.accessibilityLabel = @"브랜드 찜하기";
                            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"잠시 후 다시 시도해주세요." maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                            [ApplicationDelegate.window addSubview:lalert];
                        }
                    }
                }] resume];
    
}


@end
