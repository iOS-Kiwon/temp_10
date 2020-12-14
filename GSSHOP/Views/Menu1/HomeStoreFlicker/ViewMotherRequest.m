//
//  ViewMotherRequest.m
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 1. 15..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import "ViewMotherRequest.h"
#import "AppDelegate.h"
#import "Common_Util.h"
#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>

@implementation ViewMotherRequest

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)showPopupWithDic:(NSDictionary *)dic{
    self.dicMR = dic;
    
}

-(void)closeView{
    [self removeFromSuperview];
}

- (IBAction)onBtnSendKakaoTalk:(id)sender{
    
    NSString *strTest = [NSString stringWithFormat:@"[GS SHOP]\n%@",NCS([self.dicMR objectForKey:@"productName"])];
    NSString *strDesc = @"♡일이삼사오 륙칠팔구십 일이삼사오 륙칠팔구십 일이삼사오 륙칠팔구십♡";
    [self kakaoMotherRequestedImage:NCS([self.dicMR objectForKey:@"imageUrl"]) andTitle:strTest andDesc:strDesc andLinkURL:NCS([self.dicMR objectForKey:@"linkUrl"])];
}

- (void)kakaoMotherRequestedImage:(NSString *)strImageURL andTitle:(NSString *)strTitle andDesc:(NSString *)strDesc andLinkURL:(NSString *)strLinkURL{
    
    [ApplicationDelegate onloadingindicator];
    
    UIImage *imgFirst = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strImageURL]]];
    UIImage *imgSecond = [UIImage imageNamed:@"order_please.png"]; //엄마가 부탁해 이미지 고정
    UIImage *imgMixed = [Common_Util imageByCombiningImage:imgFirst withImage:imgSecond];
    
    if (imgMixed != nil) {
        [[KLKImageStorage sharedStorage] uploadWithImage:imgMixed
                                                 success:^(KLKImageInfo *original) {
                                                     // 업로드 성공
                                                     NSLog(@"Image URL: %@", original.URL);
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         [ApplicationDelegate offloadingindicator];
                                                         [self shareKakaoWithTitle:strTitle desc:strDesc imageURL:original.URL andImageSize:imgMixed.size urlLink:[NSURL URLWithString:strLinkURL]];
                                                     });
                                                     
                                                 } failure:^(NSError *error) {
                                                     // 업로드 실패
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         
                                                         Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"kakaoTalk_image_upload_failed") maintitle:@" " delegate:nil buttonTitle:[NSArray arrayWithObjects:@"OK", nil]];
                                                         [ApplicationDelegate.window addSubview:malert];
                                                     });
                                                 }];
    }
    
}

#pragma mark - 카카오톡 엄마가 부탁해
- (void)shareKakaoWithTitle:(NSString *)text desc:(NSString *)desc imageURL:(NSURL *)imgURL andImageSize:(CGSize)imgSize urlLink:(NSURL *)urlLink {
    // 카카오톡
    
    NSLog(@"urlLink.absoluteString = %@",urlLink.absoluteString);
    
    KMTTemplate *template = [KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
        // 콘텐츠
        feedTemplateBuilder.content = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
            contentBuilder.title = text;
            contentBuilder.desc = desc;
            contentBuilder.imageURL = imgURL;
            NSInteger w = 200, h = 200; //카톡 V2 대응용 이미지 사이즈
            if(imgSize.width > 200.0 && imgSize.height > 200.0){
                
                w = imgSize.width;
                h = imgSize.height;
            }
            
            contentBuilder.imageWidth = [NSNumber numberWithInteger:w];
            contentBuilder.imageHeight = [NSNumber numberWithInteger:h];
            
            contentBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = urlLink;
            }];
        }];
        
        // 버튼
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"웹으로 보기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = urlLink;
                linkBuilder.webURL = urlLink;
            }];
        }]];
        [feedTemplateBuilder addButton:[KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
            buttonBuilder.title = @"앱으로 보기";
            buttonBuilder.link = [KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
                linkBuilder.mobileWebURL = urlLink;
                linkBuilder.webURL = urlLink;
                linkBuilder.iosExecutionParams = [NSString stringWithFormat:@"url=gsshopmobile://home?%@",NCS(urlLink.absoluteString)];
                linkBuilder.androidExecutionParams = [NSString stringWithFormat:@"url=gsshopmobile://home?%@",[(NCS(urlLink.absoluteString)) urlEncodedString]];
            }];
        }]];
    }];
    
    [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template success:^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
        // 성공
        
        [self closeView];
        
    } failure:^(NSError * _Nonnull error) {
        // 에러
        
    }];
    
}


@end
