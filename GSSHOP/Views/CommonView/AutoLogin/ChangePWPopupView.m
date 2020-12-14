//
//  ChangePWPopupView.m
//  GSSHOP
//
//  Created by gsshop iOS on 2017. 10. 24..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "ChangePWPopupView.h"
#import "AppDelegate.h"

@implementation ChangePWPopupView
@synthesize viewPopupContents;
@synthesize strChangeUrl;
@synthesize strUserKey;

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
    
    self.viewPopupContents.layer.cornerRadius = 2.0;
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


-(IBAction)onClickBtn:(id)sender{
    NSInteger tagBtn = [((UIButton *)sender) tag];
    
    if (tagBtn == 1010) {   //10일동안 보지않기
        
        NSString *strSHA256UserKey = [Common_Util getSHA256:strUserKey];
        
        //2018.02.01
        if (strSHA256UserKey != nil) {
            SL([NSDate date], strSHA256UserKey);
        }
        
        NSURL *turl = [NSURL URLWithString:GSPASSWORDCHANGE30(strUserKey)];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:turl];
        NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
        [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
        [urlRequest setHTTPMethod:@"GET"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSLog(@"Contacting Server....");
        
//
//
//        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//         {
//             NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//             NSLog(@"resultString = %@",strResult);
//             //결과값 무시
//         }];
//        [queue waitUntilAllOperationsAreFinished];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:urlRequest
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"resultString = %@",strResult);
                }] resume];
        
        
    }else if (tagBtn == 1020) {     //비밀번호 변경하기
        
        //self.strChangeUrl = @"http://m.gsshop.com/member/personInfoManagement.gs";
        
        if ([NCS(self.strChangeUrl) length] > 0 && [self.strChangeUrl hasPrefix:@"http"]) {
            
            UINavigationController *navi = ApplicationDelegate.mainNVC;
            id viewController = [[navi viewControllers] lastObject];
            
            if ([viewController isKindOfClass:[ResultWebViewController class]] ||
                [viewController isKindOfClass:[MyShopViewController class]]
                ) {
                
                if([viewController respondsToSelector:@selector(goWebView:)]){
                    [viewController goWebView:self.strChangeUrl];
                }else{
                    ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:self.strChangeUrl];
                    [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:result];
                }
            }else{
                ResultWebViewController *result = [[ResultWebViewController alloc]initWithUrlString:self.strChangeUrl];
                [ApplicationDelegate.mainNVC pushViewControllerMoveInFromBottom:result];
            }

            
        }
    }
    
    [self removeFromSuperview];
    
    
}

@end
