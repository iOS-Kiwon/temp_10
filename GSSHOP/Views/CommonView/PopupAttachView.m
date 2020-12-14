//
//  PopupAttachView.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 19..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "PopupAttachView.h"

#import "AppDelegate.h"
#import "DataManager.h"
#import "AttachInfo.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Photos/Photos.h>

@implementation PopupAttachView

#define PlaceHoldComment  [NSString stringWithFormat:@"타인에게 노출될 수 있는 개인정보(주민번호, 카드정보 등) 입력에 주의해 주세요. 상담과 관련 없는 경우 임의 삭제될 수 있습니다."]

@synthesize delegate,urlpstr,descTextView;
@synthesize viewMainBG, bImgSend,btnforsend,restrictByteLabel;
@synthesize bgFrame;
@synthesize lblTitle;
@synthesize constTextBoxHeight;
@synthesize constTopHeight;
@synthesize constAllHeight;
@synthesize constTextBoxBottom;
@synthesize viewBoxLine;
@synthesize btnAccess;

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.sendimgArr = [[NSMutableArray alloc] init];
    self.viewMainBG.layer.cornerRadius = 4.0;
}

- (void)dealloc {
    self.viewMainBG = nil;
    self.descTextView = nil;
    self.btnforsend = nil;
    self.restrictByteLabel = nil;
}


- (void)openPopupWithFrame:(CGRect)aFrame
               superview:(UIView *)superview
                delegate:(id)delegate
                   param:(URLParser *)paramString
                animated:(BOOL)animated {
    
    
//    PopupAttachView *view = [[[NSBundle mainBundle] loadNibNamed:@"PopupAttachView" owner:self options:nil] firstObject];
    
    self.delegate = delegate;
    self.urlpstr = paramString;
    self.frame = CGRectMake(0 + APPFULLWIDTH, 0, aFrame.size.width, APPFULLHEIGHT);
    //view.bgFrame = aFrame;
    
    [self talkUISelect];
    
    [superview addSubview:self];
    
    [self.layer setMasksToBounds:NO];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:aFrame].CGPath;
    
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.frame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         
                         
                     }];

}

-(void)talkUISelect {
    
    self.viewBoxLine.layer.borderColor = [Mocha_Util getColor:@"E5E5E5"].CGColor;
    self.viewBoxLine.layer.borderWidth = 1.0;
    NSLog(@"[urlpstr valueForVariable:@talkui] = %@",[urlpstr valueForVariable:@"talkui"]);
    
    isTalkUITypeB = NO;
    
    if ([urlpstr valueForVariable:@"talkui"] == nil) {
        isTalkUIExist = NO;
    }
    else {
        isTalkUIExist = YES;
    }
    
    self.constTopHeight.constant = 210.0;
    self.lblTitle.hidden = NO;
    [self setup];
    [self pictureViewUI];
}

- (void)setup {
    self.popupTopMargin.constant = (IS_IPHONE_X_SERISE ? 50 : 30);
    isComming = NO;
    CTInfoDict = [[AttachInfo alloc] init];
    CTInfoDict.contentstr = nil;
    [CTInfoDict.arruploadimg removeAllObjects];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,  [[UIScreen mainScreen] bounds].size.height, APPFULLWIDTH, 44)];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 7.0) {
        toolBar.barStyle = UIBarStyleDefault;
    }
    else {
        toolBar.barStyle = UIBarStyleBlackTranslucent;
    }
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:(version >= 7.0)?GSSLocalizedString(@"common_txt_alert_btn_complete"):GSSLocalizedString(@"common_txt_alert_btn_close") style:(version >= 7.0)?UIBarButtonItemStylePlain:UIBarButtonItemStyleDone target:self action:@selector(confirm1:)];
    closeBtn.tag = 66;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects: flexibleSpace, closeBtn, nil] animated:NO];
    self.descTextView.textAlignment = NSTextAlignmentLeft;
    self.descTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.descTextView.delegate = self;
    self.descTextView.text = PlaceHoldComment;
    self.descTextView.editable = YES;
    self.descTextView.inputAccessoryView = toolBar;
    [self.descTextView setIsAccessibilityElement:YES];
    [self.descTextView setAccessibilityLabel:@"타인에게 노출될 수 있는 개인정보(주민번호, 카드정보 등) 입력에 주의해 주세요. 상담과 관련 없는 경우 임의 삭제될 수 있습니다."];
    [self.descTextView  setAccessibilityHint:@"터치하시면 문의글 내용을 편집하실 수 있습니다 "];
    ((UILabel*)[self viewWithTag:70001]).text = GSSLocalizedString(@"mobiletalk_header_title");
    ((UILabel*)[self viewWithTag:70002]).text = GSSLocalizedString(@"mobiletalk_txt_photo");
    [((UIButton*)[self viewWithTag:1]) setTitle:GSSLocalizedString(@"mobiletalk_btn_submittitle") forState:UIControlStateNormal];
}

- (void)catchNotiCloseEvent {
    [self closeWithAnimated:NO];
}


- (void)closeButtonClicked:(id)sender {
    [self closeWithAnimated:YES];
}


- (void)closeWithAnimated:(BOOL)animated {
    //하단탭바가 노출되어 있던 상태면 노출 유지
    if(tabbarStatus == NO) {
        ApplicationDelegate.HMV.tabBarView.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"customovieViewRemove" object:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [ApplicationDelegate.gactivityIndicator stopAnimating];
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         self.frame = CGRectMake(self.frame.origin.x + APPFULLWIDTH, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}


//올릴 사진 보여주기, 사진이 없으면 안보여진다.
- (void)pictureViewUI {
    dispatch_async(dispatch_get_main_queue(),^{
        [ApplicationDelegate.gactivityIndicator stopAnimating];
    });
    NSLog(@"카운텃: %ld byte ",(unsigned long)[self.sendimgArr count]);
    
    int imginitialint=1001;
    int btninitialint=10001;
    int i=0;
    for(i=0; i<5; i++) {
        ((UIImageView*)[self viewWithTag:imginitialint+i]).hidden = YES;
        ((UIButton*)[self viewWithTag:btninitialint+i]).hidden = YES;
    }
    CGFloat heightConst = 55.0;
    
    if(isTalkUITypeB == YES) {
        heightConst = 50.0;
    }

    if([self.sendimgArr count] > 0) {//파일 존재하면
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.constAllHeight.constant = heightConst + 60.0;
                             [self layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                             
                         }];
        int j = 0;
        for (id oneObject in self.sendimgArr) {
            if ([oneObject isKindOfClass:[UIImage class]]) {
                ((UIImageView*)[self viewWithTag:imginitialint+j]).image = oneObject;
                ((UIImageView*)[self viewWithTag:imginitialint+j]).hidden = NO;
                ((UIButton*)[self viewWithTag:btninitialint+j]).hidden = NO;
                j++;
            }
        }
        self.bImgSend = 1;
    }
    else {
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             self.constAllHeight.constant = heightConst;
                             [self layoutIfNeeded];
                         }
                         completion:^(BOOL finished){
                         }];
        self.bImgSend = 0;
    }
}

- (void)goReturnURL:(NSString *)returnURL {
    NSLog(@"GoodsExtimate goreturnURL");
    [DataManager sharedManager].cameraFlag = NO;
    [self.delegate performSelector:@selector(goWebView:) withObject:returnURL];
    [self closeWithAnimated:YES];
    
}

- (IBAction)GoBack
{
    
    [self.descTextView resignFirstResponder];
    
    if( [self.descTextView.text length] > 0 ||  self.bImgSend == 1 ) {
        Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:@"작성중인 글이 있습니다.\n 취소하시겠습니까?" maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_cancel"),GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        lalert.tag = 777;
        [ApplicationDelegate.window addSubview:lalert];
    }
    else {
        [self justGoBack];
    }
}


- (void)justGoBack
{
    
    NSLog(@"GoodsExtimate goBack");
    //[self docFileDelete];
    
    //취소할경우 초기화 안되는 문제가 발견되어 추가함 2016/12/08 배포때 적용
    if(isTalkUIExist && [self.delegate respondsToSelector:@selector(callJscriptMethod:)]){
        [self.delegate callJscriptMethod:@"talkCancel()"];
    }
    
    
    [DataManager sharedManager].cameraFlag = NO;
    [self closeWithAnimated:YES];
    
}
 

- (void)confirm1:(id)sender {
    [descTextView resignFirstResponder];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {

        NSLog(@"return ");
    }
    return TRUE;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:PlaceHoldComment])
    {
        self.descTextView.text = @"";
        
        [self.restrictByteLabel setText:[NSString stringWithFormat:@"0"]];
        
        self.descTextView.textColor = [Mocha_Util getColor:@"000000"];
    }
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    CGFloat originTop = 30;
//
//    if(getLongerScreenLength == 480)self.viewMainBG.frame = CGRectMake(self.viewMainBG.frame.origin.x, originTop, self.viewMainBG.frame.size.width, self.viewMainBG.frame.size.height);
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
//    CGFloat originTop = -35.0;
//    if (isTalkUITypeB == YES) {
//        originTop = -55.0;
//    }
//    
//    if(getLongerScreenLength == 480)self.viewMainBG.frame = CGRectMake(self.viewMainBG.frame.origin.x,originTop, self.viewMainBG.frame.size.width, self.viewMainBG.frame.size.height);
    
    
    NSInteger convertedLength = [textView.text lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    
    [self.restrictByteLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)convertedLength]];
    
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger convertedLength = [textView.text lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    
    const char *target = [textView.text cStringUsingEncoding:(0x80000000 + 0x0422)];
    
    NSLog(@"%ld 글자 입력", (long)convertedLength);
    if (convertedLength > RESTRICTBYTEINTEGER) {
        
        @try { //알수없는 이유로 크래쉬 난것을 확인 , 방어코드 추가

            NSData *data = [NSData dataWithBytes:target length:RESTRICTBYTEINTEGER];
            NSString *convertedStr = [[NSString alloc] initWithData:data encoding:(0x80000000 + 0x0422)];
            
            if (convertedStr == nil) {
                data = [NSData dataWithBytes:target length:RESTRICTBYTEINTEGER-1];
                convertedStr = [[NSString alloc] initWithData:data encoding:(0x80000000 + 0x0422)];
            }
            textView.text = convertedStr;
        }
        @catch (NSException *exception) {
            
            NSLog(@"convertedStr exception: %@", exception);
        }
        @finally {
        }
        
        
        
        
        
        
        BOOL isthereMarlert = NO;
        for ( UIView* v in  [self.window subviews] )
        {
            
            if(v.tag == 379){
                isthereMarlert = YES;
            }
            
        }
        
        if(isthereMarlert==NO){
            
            
            [descTextView resignFirstResponder];
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"mobiletalk_exceed_len") maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 379;
            [ApplicationDelegate.window addSubview:lalert];
        }
        
        
    }
    convertedLength = [textView.text lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    [self.restrictByteLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)convertedLength]];
    
    NSLog(@"(unsigned long)convertedLength = %ld",(unsigned long)convertedLength);
    if ((unsigned long)convertedLength == 0) {
        self.btnAccess.backgroundColor = [UIColor clearColor];
    }else{
        self.btnAccess.backgroundColor = [Mocha_Util getColor:@"bed730"];
    }
    
    CTInfoDict.contentstr =  [Mocha_Util stringByStrippingHTML:textView.text];

    NSLog(@"reviewContents = %@",  CTInfoDict.contentstr);
    
}

//상품평 데이터 서버로 보내기
- (IBAction)btnAction:(id)sender
{
    if( isComming == YES)return;
    
    
    
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        
        isComming = YES;
        
        
        NSInteger convertedLength = [CTInfoDict.contentstr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"입력글자length: %ld",  (long)convertedLength);
        
        
        if (CTInfoDict.contentstr == nil)
        {
            [descTextView resignFirstResponder];
            
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"mobiletalk_validation_txt_nothing") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 379;
            [ApplicationDelegate.window addSubview:lalert];
            isComming = NO;
            return;
        }else {
            if(convertedLength < 1)
            {
                
                [descTextView resignFirstResponder];
                
                Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"mobiletalk_validation_txt_nothing") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                lalert.tag = 379;
                [ApplicationDelegate.window addSubview:lalert];
                isComming = NO;
                return;
            }
        }
        
        
        
        {
            NSString *str1 = CTInfoDict.contentstr;
            str1 = [str1 stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
            
            CTInfoDict.contentstr=str1;
            NSLog(@"reviewContents = %@",str1);
            [descTextView resignFirstResponder];
            if(self.bImgSend == 1)
            {
                
                CTInfoDict.arruploadimg = self.sendimgArr;
            }
            
            
            
            
            AttachInfoRequest *ge = [[AttachInfoRequest alloc]init];
            ge.delegate = self;
            
            if([CTInfoDict.contentstr length] == 0)
            {
                
            }
            else if([CTInfoDict.contentstr length] < RESTRICTBYTEINTEGER+1)
            {
                
            }
            else
            {
                CTInfoDict.contentstr = [str1 substringFromIndex:RESTRICTBYTEINTEGER];
            }
            
            
            CTInfoDict.urlreqparser = urlpstr;
            
            
            [ApplicationDelegate.gactivityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
            
            
            CFRunLoopRunInMode((CFStringRef)NSDefaultRunLoopMode, 0.25, NO);
            
            
            [ge sendData:CTInfoDict];
            
        }
    }
    
}


//결과넘어옴
- (BOOL)contain:(NSString*)string constring:(NSString *)containStr
{
    NSLog(@"---------");
    NSString *str = string;
    NSRange range = [str rangeOfString:containStr];
    if(range.location == NSNotFound)//없음
    {
        return NO;
    }
    else{
        
        return YES;
    }
    
}



//상담 text 데이터 넘기고 받을 결과
- (void)doneRequest:(NSString *)status
{
    
    isComming = NO;
    
    if(status == nil) {
        
        NSLog(@"최종 등록실패!!");
        //[self docFileDelete];
        [DataManager sharedManager].cameraFlag = NO;
        
        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\")",[urlpstr valueForVariable:@"callback"], @"", @"-40000", @""     ];
        [self.delegate performSelector:@selector(callJscriptMethod:) withObject:strjs ];
        [self closeWithAnimated:YES];
        
        return;
    }else {
        
        
        NSLog(@"status = %@",status);
        // nami0342 - JSON
        NSDictionary *result = [status JSONtoValue];
     
        //[self docFileDelete];
        [DataManager sharedManager].cameraFlag = NO;
        
        
        
        NSString* talk_id_str;
        NSString* err_str;
        
        if ([NCS([result objectForKey:@"error_message"]) length] >0) {
            NSLog(@"errMstr=1:%@", [result objectForKey:@"error_message"]);
            err_str= [[result objectForKey:@"error_message"] stringByRemovingPercentEncoding];
            err_str =  [Mocha_Util strReplace:@"\n" replace:@"<br>" string:err_str];
            NSLog(@"errMstr=2:%@", err_str);
        }
        
        if (NCO([result objectForKey:@"data"]) && NCO([[result objectForKey:@"data"] objectForKey:@"messages"]) && NCO([[[result objectForKey:@"data"] objectForKey:@"messages"] objectAtIndex:0]) && [NCS([[[[result objectForKey:@"data"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"talk_id"]) length] >0) {
            talk_id_str= [[[[result objectForKey:@"data"] objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"talk_id"];
        }else {
            talk_id_str = @"null";
        }
        
        
        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\")",[urlpstr valueForVariable:@"callback"],  talk_id_str, [result objectForKey:@"error_code"],  err_str  ];
        
        
        
        NSLog(@"ㄹㄹㄹㄹㄹ callback호출, %@", strjs);
        [self.delegate performSelector:@selector(callJscriptMethod:) withObject:strjs ];

        [self closeWithAnimated:YES];
        
        [self sendGTMConsultComplete];//상담신청 완료시 GTM 전송 2015/10/19 yunsang.jin
    }
    
    
}


//상담 img 데이터 넘기고 받을 결과
- (void)doneimgRequest:(NSString *)status
{
    
    
    if(status == nil) {
        
        NSLog(@"최종 등록실패!!");
        //[self docFileDelete];
        [DataManager sharedManager].cameraFlag = NO;
        
        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\")",[urlpstr valueForVariable:@"callback"], @"", @"-40000", @""     ];
        [self.delegate performSelector:@selector(callJscriptMethod:) withObject:strjs ];
        [self closeWithAnimated:YES];
        
        return;
    }else {
        
        
        //javascript 호출 정상 등록
        //[self docFileDelete];
        [DataManager sharedManager].cameraFlag = NO;
        
        NSLog(@"최종 정상등록이거나 에러거나 callback호출, %@", status);
        [self.delegate performSelector:@selector(callJscriptMethod:) withObject:status ];
        [self closeWithAnimated:YES];
        
        [self sendGTMConsultComplete];//상담신청 완료시 GTM 전송 2015/10/19 yunsang.jin
    }
    
    
}

-(void)sendGTMConsultComplete{
    @try {
        
        [[GSDataHubTracker sharedInstance] NeoCallGTMWithReqURL:@"D_4030101" str2:nil str3:nil];
    }
    @catch (NSException *exception) {
        
        NSLog(@"D_4030101 ERROR : %@", exception);
    }
    @finally {
    }
}

#pragma mark UICustomAlertDelegate

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    //업로드성공
    if(alert.tag == 12) {
        
        NSLog(@" %@", [urlpstr valueForVariable:@"callback"] );
        if([urlpstr valueForVariable:@"callback"] != nil){
            [self goReturnURL:[urlpstr valueForVariable:@"callback"]   ];
        }else {
            [self.delegate performSelector:@selector(webViewReload)];
        }

        [self closeWithAnimated:YES];
        
        
    }else if(alert.tag == 379) {
        //일반 알럿
        
    }
    else if(alert.tag == 380) {
        
        switch (index) {
            case 1:
                NSLog(@"설정");
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            default:
                break;
        }
        
    }
    else if(alert.tag == 444) {
        //사진 삭제alert Y or N
        
        if(index==1){
            
            //[self docFileDelete];
            NSLog(@"Image 삭제!");
            
            self.bImgSend = 0;
            [self pictureViewUI];
        }
        
    }else if(alert.tag == 777) {
        //작성중인 글이 있습니다.취소하시겠습니까? 취소 확인
        
        if(index==1){
            
            [self justGoBack];
        }
        
    }
    
    else {
        [self justGoBack];
    }
    
    
}


#pragma mark -
#pragma mark uploadDelegate

- (void)didSuccesUpload:(NSDictionary *)dicResult{
    
    NSLog(@"");
 
    if(NCO(dicResult) && NCA([dicResult objectForKey:@"arrImages"])) {
        NSArray *arrImages = [dicResult objectForKey:@"arrImages"];
        for (UIImage *img in arrImages) {
            [self.sendimgArr addObject:img];
        }
        
        [self pictureViewUI];
    }
}

- (IBAction)pictureBtnAction:(id)sender {
    UIButton *cbtn = (UIButton*)sender;
    if(cbtn.tag == 1) {
        if([self.sendimgArr count] >= RESTRICTPHOTOCOUNT){
            Mocha_Alert *lalert = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:@"첨부 이미지는 %d개까지 선택해 주세요.",RESTRICTPHOTOCOUNT ]   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 444;
            [ApplicationDelegate.window addSubview:lalert];
            return;
        }
        

        [descTextView resignFirstResponder];

        //액션시트로 이미지 가져오기 선택(카메라 찍기, 앨범에서 가져오기)
        
        UIAlertController *csheet = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cam = [UIAlertAction
                              actionWithTitle:GSSLocalizedString(@"assetpicker_actsheet_takepic")
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                if(tabbarStatus == NO) {
                                       ApplicationDelegate.HMV.tabBarView.hidden = NO;
                                   }
                                  [csheet dismissViewControllerAnimated:YES completion:nil];
                                  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
                                      Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_cant_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                      lalert.tag = 379;
                                      [ApplicationDelegate.window addSubview:lalert];
                                      return;
                                  }
                                  else {
                                      /*
                                      [self showCamera:0];
                                      [DataManager sharedManager].cameraFlag = YES;
                                       */
                                      
                                      [DataManager sharedManager].cameraFlag = YES;
                                      GSMediaUploader *uploder = [[[NSBundle mainBundle] loadNibNamed:@"GSMediaUploader" owner:self options:nil] firstObject];
                                      [uploder gsMediaUploadWithParser:self.urlpstr andTargetView:self andType:0];
                                  }
                              }];
        UIAlertAction *album = [UIAlertAction
                                actionWithTitle:GSSLocalizedString(@"assetpicker_actsheet_album")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [csheet dismissViewControllerAnimated:YES completion:nil];
                                    
                                    [DataManager sharedManager].imguploadTargetUrlstr = @"";
                                    [DataManager sharedManager].imguploadTargetJsFuncstr = @"";
                                    [DataManager sharedManager].uploadfiletypestr = @"image";
                                    [DataManager sharedManager].photoLimit = RESTRICTPHOTOCOUNT -[self.sendimgArr count] ;
                                    //[self showCamera:1];
                                    [DataManager sharedManager].cameraFlag = YES;
            
            GSMediaUploader *uploder = [[[NSBundle mainBundle] loadNibNamed:@"GSMediaUploader" owner:self options:nil] firstObject];
            [uploder gsMediaUploadWithParser:self.urlpstr andTargetView:self andType:1];
            if(tabbarStatus == NO) {
                   ApplicationDelegate.HMV.tabBarView.hidden = NO;
               }
            
                                }];
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:GSSLocalizedString(@"common_txt_alert_btn_cancel")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                    if(tabbarStatus == NO) {
                                           ApplicationDelegate.HMV.tabBarView.hidden = NO;
                                       }
                                     [csheet dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [csheet addAction:cam];
        [csheet addAction:album];
        [csheet addAction:cancel];
        
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            UIViewController *target = (UIViewController *)self.delegate;
            if(target != nil) {
                if( [csheet respondsToSelector:@selector(popoverPresentationController)] ) {
                    csheet.popoverPresentationController.sourceView = target.view;
                    // 위치를 중앙으로..(버튼위로)
                    csheet.popoverPresentationController.sourceRect = CGRectMake(target.view.frame.size.width/2, (target.view.frame.size.height/7)*4-20, 0, 0);
                }
                
                tabbarStatus = ApplicationDelegate.HMV.tabBarView.hidden;
                if(tabbarStatus == NO) {
                    ApplicationDelegate.HMV.tabBarView.hidden = YES;
                }
                
                [target presentViewController:csheet animated:YES completion:nil];
            }
            //[target presentViewController:csheet animated:YES completion:nil];
        }
        
        self.bImgSend = 0;
    } else {
        //삭제
        //10001
        
        int btninitialint=10001;
        NSUInteger tgindex = (NSUInteger)cbtn.tag - btninitialint;
        [self.sendimgArr removeObjectAtIndex:tgindex];
        [self pictureViewUI];        
    }
    
}

@end
