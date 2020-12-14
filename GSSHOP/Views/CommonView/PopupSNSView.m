//
//  PopupSNSView.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 7. 14..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "PopupSNSView.h"
#import "AppDelegate.h"
#import "SNSManager.h"


@implementation PopupSNSView



- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    //self.backgroundColor = [UIColor clearColor];
    //배경 라운딩
    //코너 모서리..
    UIBezierPath *maskPath_ph = [UIBezierPath bezierPathWithRoundedRect:self.popupView.bounds byRoundingCorners:UIRectCornerAllCorners  cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer_ph = [CAShapeLayer layer];
    maskLayer_ph.frame = self.popupView.bounds;
    maskLayer_ph.path = maskPath_ph.CGPath;
    self.popupView.layer.mask = maskLayer_ph;

    //딕셔너리구조체만들기
    NSMutableArray *snsinfoset = [NSMutableArray array];
    NSMutableDictionary *snsinfo = [NSMutableDictionary dictionary];
    
    /*
     카카오톡: &utm_source=kakao&utm_medium=sns&utm_campaign=sharekakao
    카카오스토리: &utm_source=kas&utm_medium=sns&utm_campaign=sharekas
    페이스북: &utm_source=facebook&utm_medium=sns&utm_campaign=sharefb
    트위터: &utm_source=twitter&utm_medium=sns&utm_campaign=sharetw
    핀터레스트: &utm_source=pinterest&utm_medium=sns&utm_campaign=sharepint
    라인: &utm_source=line&utm_medium=sns&utm_campaign=shareline
    URL복사: &utm_source=url&utm_medium=sns&utm_campaign=shareurl
*/
    
    [snsinfo setValue:@"카카오톡" forKey:SNS_TITLE];
    [snsinfo setValue:[NSNumber numberWithInt:TYPE_KAKAOTALK] forKey:SNS_ID];
    [snsinfo setValue:@"kakaotalk_icon.png" forKey:SNS_ICON];
    [snsinfo setValue:@"&utm_source=kakao&utm_medium=sns&utm_campaign=sharekakao" forKey:SNS_CODE];
    [snsinfo setValue:@"410385" forKey:MSEQ];
    [snsinfoset addObject:[snsinfo copy]];
    [snsinfo removeAllObjects];
    
    
    [snsinfo setValue:@"카카오스토리" forKey:SNS_TITLE];
    [snsinfo setValue:[NSNumber numberWithInt:TYPE_KAKAOSTORY] forKey:SNS_ID];
    [snsinfo setValue:@"kakaostory_icon.png" forKey:SNS_ICON];
    [snsinfo setValue:@"&utm_source=kas&utm_medium=sns&utm_campaign=sharekas" forKey:SNS_CODE];
    [snsinfo setValue:@"410386" forKey:MSEQ];
    [snsinfoset addObject:[snsinfo copy]];
    [snsinfo removeAllObjects];
    
    [snsinfo setValue:@"라인" forKey:SNS_TITLE];
    [snsinfo setValue:[NSNumber numberWithInt:TYPE_LINE] forKey:SNS_ID];
    [snsinfo setValue:@"line_icon.png" forKey:SNS_ICON];
    [snsinfo setValue:@"&utm_source=line&utm_medium=sns&utm_campaign=shareline" forKey:SNS_CODE];
    [snsinfo setValue:@"410387" forKey:MSEQ];
    [snsinfoset addObject:[snsinfo copy]];
    [snsinfo removeAllObjects];
    
    [snsinfo setValue:@"SMS" forKey:SNS_TITLE];
    [snsinfo setValue:[NSNumber numberWithInt:TYPE_SMSMESSAGE] forKey:SNS_ID];
    [snsinfo setValue:@"sms_icon.png" forKey:SNS_ICON];
    [snsinfo setValue:@"" forKey:SNS_CODE];
    [snsinfo setValue:@"410388" forKey:MSEQ];
    [snsinfoset addObject:[snsinfo copy]];
    [snsinfo removeAllObjects];
    
    [snsinfo setValue:@"페이스북" forKey:SNS_TITLE];
    [snsinfo setValue:[NSNumber numberWithInt:TYPE_FACEBOOK] forKey:SNS_ID];
    [snsinfo setValue:@"facebook_icon.png" forKey:SNS_ICON];
    [snsinfo setValue:@"&utm_source=facebook&utm_medium=sns&utm_campaign=sharefb" forKey:SNS_CODE];
    [snsinfo setValue:@"410389" forKey:MSEQ];
    [snsinfoset addObject:[snsinfo copy]];
    [snsinfo removeAllObjects];
    
    [snsinfo setValue:@"트위터" forKey:SNS_TITLE];
    [snsinfo setValue:[NSNumber numberWithInt:TYPE_TWITTER] forKey:SNS_ID];
    [snsinfo setValue:@"twitter_icon.png" forKey:SNS_ICON];
    [snsinfo setValue:@"&utm_source=twitter&utm_medium=sns&utm_campaign=sharetw" forKey:SNS_CODE];
    [snsinfo setValue:@"410390" forKey:MSEQ];
    [snsinfoset addObject:[snsinfo copy]];
    [snsinfo removeAllObjects];
    
    [snsinfo setValue:@"URL복사" forKey:SNS_TITLE];
    [snsinfo setValue:[NSNumber numberWithInt:TYPE_URLCOPY] forKey:SNS_ID];
    [snsinfo setValue:@"url_icon.png" forKey:SNS_ICON];
    [snsinfo setValue:@"&utm_source=url&utm_medium=sns&utm_campaign=shareurl" forKey:SNS_CODE];
    [snsinfo setValue:@"410392" forKey:MSEQ];
    [snsinfoset addObject:[snsinfo copy]];
    [snsinfo removeAllObjects];

    [self setSnsListData:snsinfoset];
    self.hidden = YES;
    
}


-(void)setSnsListData:(NSArray*)arrInfo{
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
        imgSnsIcon.image = [UIImage imageNamed:[[self.arrSNS objectAtIndex:i] objectForKey:SNS_ICON]];
        
        // title
        UILabel *lblSnsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, iConHeigth + 10, itemWidth, 12.0)];
        lblSnsTitle.backgroundColor = [UIColor clearColor];
        lblSnsTitle.font = [UIFont systemFontOfSize:12.0f];
        lblSnsTitle.textAlignment = NSTextAlignmentCenter;
        lblSnsTitle.lineBreakMode = NSLineBreakByClipping;
        lblSnsTitle.textColor = [Mocha_Util getColor:@"444444"];
        lblSnsTitle.text = [[self.arrSNS objectAtIndex:i] objectForKey:SNS_TITLE];
        
        
        // itmeView
        UIView *viewSnsItem = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, itemWidth , iConHeigth + 10 + lblSnsTitle.frame.size.height)];
        //viewSnsItem.backgroundColor = [UIColor yellowColor];
        
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
    
  
}

-(IBAction)onBtnSnsButton:(id)sender{

    //SNS 버튼이 클릭되면 해당 index의 데이터에서 SNS_ID를 조회하여 다음으로 넘긴다.
    NSNumber *snsid = [[self.arrSNS objectAtIndex:[((UIButton *)sender) tag]] objectForKey:SNS_ID];
    
    NSString *addGTM = [[self.arrSNS objectAtIndex:[((UIButton *)sender) tag]] objectForKey:SNS_CODE];

    NSString *shareUrl;
    
    if( [Mocha_Util strContain:@"?" srcstring:snsUrl] ) {
        shareUrl = [NSString stringWithFormat:@"%@%@",snsUrl,addGTM];

    }
    else {
        shareUrl = [NSString stringWithFormat:@"%@?%@",snsUrl,addGTM];

    }
    
    SNSManager *tsns = [SNSManager snsPostingWithUrl:shareUrl text:snsMessage imageUrl:snsImageUrl imageSize:imageSize];
    tsns.target = self;
    [tsns NSNSPosting:(TYPEOFSNS)[snsid intValue]];
    
    
    
    if( callerType == 1) //1이면 숏방
    {
         NSString *mseqCode = [NSString stringWithFormat:@"?mseq=%@",[[self.arrSNS objectAtIndex:[((UIButton *)sender) tag]] objectForKey:MSEQ]];
        //mseq 동작
        ////탭바제거
        [ApplicationDelegate wiseAPPLogRequest: WISELOGCOMMONURL(mseqCode)];
    }
 
    if ((TYPEOFSNS)[snsid intValue] == TYPE_FACEBOOK || (TYPEOFSNS)[snsid intValue] == TYPE_TWITTER) {
        [self closeWithAnimatedNoNoti:YES];
    }else{
        [self closeWithAnimated:YES];
    }
    
    
}


- (void)closeWithAnimated:(BOOL)animated
{
    if (self.alpha == 0 && self.hidden == YES) {
        return;
    }
    
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
                         //공유하기 창이 닫힘 노티
                         [[NSNotificationCenter defaultCenter] postNotificationName:MAINSECTIONSNSSHARECLOSE object:nil userInfo:nil];
                     }];
}

- (void)closeWithAnimatedNoNoti:(BOOL)animated
{
    if (self.alpha == 0 && self.hidden == YES) {
        return;
    }
    
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



- (void)openWithAnimated:(BOOL)animated withShareUrl:(NSString *)url ShareImage:(NSString *)imgUrl ShareMessage:(NSString *)message callType:(NSInteger)type imageSize:(CGSize)size;
{
    
    snsUrl = url;
    snsImageUrl = imgUrl;
    snsMessage = message;
    callerType = type;
    imageSize = size;
    
    self.hidden = NO;
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         
                         
                         self.alpha = 1.0;
                         self.dimm.alpha = 0.7;
                         
                         
                     }
                     completion:^(BOOL finished){
                         

                         
                         
                     }];
    
}




- (IBAction)closeClick:(id)sender {

    [self closeWithAnimated:YES];
}

- (IBAction)moreAppClick:(id)sender {
    
    SNSManager *tsns = [SNSManager snsPostingWithUrl:snsUrl
                                                text:snsMessage
                                            imageUrl:snsImageUrl
                                           imageSize:imageSize
                        ];
    tsns.target = self;
    [tsns NSNSPosting:TYPE_SHARE];
    
    
    if( callerType == 1) //1이면 숏방
    {
        NSString *mseqCode = [NSString stringWithFormat:@"?mseq=%@",@"410393"];
        //mseq 동작
        ////탭바제거
        [ApplicationDelegate wiseAPPLogRequest: WISELOGCOMMONURL(mseqCode)];
    }
    
    [self closeWithAnimated:YES];
}


#pragma mark - Alert View Delegate
- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index {
    if (alert.tag==141) {
        if (index==0) {
            // cancel
        } else {
            // 카카오톡 링크로 이동
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/id362057947"]];
        }
    }else if (alert.tag==142) {
        if (index==0) {
            // cancel
        } else {
            // 카카오스토리 링크로 이동
            [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:@"https://itunes.apple.com/kr/app/id486244601"]];
        }
    }
    
    
}

@end
