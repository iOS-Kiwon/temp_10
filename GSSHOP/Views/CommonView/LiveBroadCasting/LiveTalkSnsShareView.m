//
//  LiveTalkSnsShareView.m
//  GSSHOP
//
//  Created by gsshop on 2016. 1. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "LiveTalkSnsShareView.h"
#import "AppDelegate.h"

@implementation LiveTalkSnsShareView
@synthesize arrSNS;
@synthesize delegate;
//@synthesize viewSnsList;
@synthesize imageLoadingOperation;



- (id)initWithDelegate:(id)target;{
    self = [super init];
    if (self)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"LiveTalkSnsShareView" owner:self options:nil];
        self = [nibs objectAtIndex:0];
        self.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, APPFULLHEIGHT);
        
        //코너 모서리..
        UIBezierPath *maskPath_ph = [UIBezierPath bezierPathWithRoundedRect:self.popupView.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(7, 7)];
        CAShapeLayer *maskLayer_ph = [CAShapeLayer layer];
        maskLayer_ph.frame = self.popupView.bounds;
        maskLayer_ph.path = maskPath_ph.CGPath;
        self.popupView.layer.mask = maskLayer_ph;
        
        delegate = target;
        
    }
    return self;
    
    
}

-(void)setSnsListData:(NSMutableArray*)arrInfo{
    
    
    self.arrSNS = [NSArray arrayWithArray:arrInfo];
    
    NSLog(@"arrSNS = %@",self.arrSNS);
    
    self.popupView.center = self.center;
    
    float xmargin = 16; // 원래 가이드 간격보다 더 넓게 공간을 확보해야 한다. 그래서 생성된 마진값.
    float xPos = 25 - (xmargin/2);
    float yPos = 0.0;
    
    float iConWidth = 50;
    float iConHeigth = 50;
    
    float itemWidth = iConWidth + xmargin;
    
    
    for (NSInteger i=0; i<[self.arrSNS count]; i++) {
        
        // iCon
        UIImageView *imgSnsIcon = [[UIImageView alloc] initWithFrame:CGRectMake((xmargin/2), 0.0, iConWidth, iConHeigth)];
        imgSnsIcon.image = [UIImage imageNamed:[[self.arrSNS objectAtIndex:i] objectForKey:SNSICONURL]];
        
        // title
        UILabel *lblSnsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, iConHeigth + 10, itemWidth, 12.0)];
        lblSnsTitle.backgroundColor = [UIColor clearColor];
        lblSnsTitle.font = [UIFont systemFontOfSize:12.0f];
        lblSnsTitle.textAlignment = NSTextAlignmentCenter;
        lblSnsTitle.lineBreakMode = NSLineBreakByClipping;
        lblSnsTitle.textColor = [Mocha_Util getColor:@"444444"];
        lblSnsTitle.text = [[self.arrSNS objectAtIndex:i] objectForKey:SNSTITLE];
        
        
        // itmeView
        UIView *viewSnsItem = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, itemWidth , iConHeigth + 10 + lblSnsTitle.frame.size.height)];
        
        xPos = xPos + itemWidth + 17-xmargin;
        NSLog(@"cnt: %ld, xpos: %f",(long)i,xPos);
        // 뷰 너비를 넘어서면 줄바꿈 한다.
        if(self.subContentView.frame.size.width <= (xPos + itemWidth + 17-xmargin)){
            xPos = 25 - (xmargin/2);
            yPos +=  viewSnsItem.frame.size.height + 20;// 셀높이 + 셀간격
        }
        
        
        
        UIButton *btnClick = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClick.frame = CGRectMake(0.0, 0.0, viewSnsItem.frame.size.width, viewSnsItem.frame.size.height);
        btnClick.backgroundColor = [UIColor clearColor];
        
        btnClick.tag = i;
        [btnClick addTarget:self action:@selector(onBtnSnsButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [viewSnsItem addSubview:imgSnsIcon];
        [viewSnsItem addSubview:lblSnsTitle];
        [viewSnsItem addSubview:btnClick];
        
        
        [self.subContentView addSubview:viewSnsItem];
    }
    
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         
                         self.alpha = 1.0;
                         self.dimm.alpha = 0.7;
                         
                         
                     }
                     completion:^(BOOL finished){
                     }];
    
    
}

-(IBAction)onBtnSnsButton:(id)sender{
    
    if ([((UIButton *)sender) tag] != 100) {
        
        NSString *strSNSID = NCS([[arrSNS objectAtIndex:[((UIButton *)sender) tag]] objectForKey:SNSID]);
        NSString *strCheck = @"";
        NSMutableString *strMessage = [[NSMutableString alloc] initWithString:@""];
        [strMessage appendString:NCS([[arrSNS objectAtIndex:[((UIButton *)sender) tag]] objectForKey:SNSTITLE])];

        if ([@"shareKakaoTalk()" isEqualToString:strSNSID]) {
            strCheck = @"kakaolink://";
        }else if([@"shareKakaoStory()" isEqualToString:strSNSID]) {
            strCheck = @"storylink://";
        }else if([@"shareLine()" isEqualToString:strSNSID]) {
            strCheck = @"line://";
        }else if([@"shareTwitter()" isEqualToString:strSNSID]) {
            strCheck = @"twitter://";
        }
        
        NSURL *checkURL = [NSURL URLWithString:strCheck];
        
        if ([strCheck length] > 0 && [[UIApplication sharedApplication] canOpenURL:checkURL] == NO) {

            [strMessage appendString:@" 앱을 설치한 후에 사용할 수 있습니다."];
            
            Mocha_Alert* malert  = [[Mocha_Alert alloc] initWithTitle:strMessage maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            [ApplicationDelegate.window addSubview:malert];
            
        }else{
            [delegate callShareSnsWithString:[[arrSNS objectAtIndex:[((UIButton *)sender) tag]] objectForKey:SNSID]];
        }
        
        
    }
    [self closeView];
    
}

-(void)setIconImageWithUrl:(NSString *)imageURL andImageView:(UIImageView *)imgView{

    
    if ([imageURL hasPrefix:@"http://"]) {
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                  {
                      imgView.image = fetchedImage;
                  }
                  else
                  {
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
                });
                  
            }
      }];

    }else{
        
        imgView.image = [UIImage imageNamed:imageURL];
        
        
    }
    
}


-(void)closeView{
    
    self.hidden = YES;
    self.dimm.alpha = 0.0;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.alpha = 1.0;
                         
                     }
                     completion:^(BOOL finished){
                         self.alpha = 0.0;
                         self.hidden = YES;
                     }];
    
    [self removeFromSuperview];
}

-(void)dealloc{
    NSLog(@"dealloc LiveTalkSnsShareView");
}

- (IBAction)moreAppClick:(id)sender {
    
    [delegate callShareSnsWithString:@"shareEtc()"];
    [self closeWithAnimated:YES];

}

- (IBAction)closeClick:(id)sender {
    
    [self closeWithAnimated:YES];
}


- (void)closeWithAnimated:(BOOL)animated
{
    self.hidden = YES;
    self.dimm.alpha = 0.0;
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.alpha = 1.0;
                         
                     }
                     completion:^(BOOL finished){
                         self.alpha = 0.0;
                         self.hidden = YES;
                     }];
}


@end
