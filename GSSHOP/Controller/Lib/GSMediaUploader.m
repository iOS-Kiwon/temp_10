//
//  GSMediaUploader.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 27..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "GSMediaUploader.h"
#import "AppDelegate.h"
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation GSMediaUploader
@synthesize delegatetarget;

//치명 중요 이 파일은 toapp://attach 가 들어올떄마다 웹뷰에 이 뷰를 addsubview 하는 방식임
//따라서 애러,사용완료 시 꼭 removeFromSuperview 를 해줘야함 안할경우 더이상 앱을 사용하기어려움

-(void)awakeFromNib{
    [super awakeFromNib];
    
    viewCancel.layer.borderColor = [UIColor colorWithRed:17.0/255.0 green:17.0/255.0 blue:17.0/255.0 alpha:0.2].CGColor;
    viewCancel.layer.borderWidth = 1.0;
    viewCancel.layer.cornerRadius = 4.0;
    viewCancel.layer.shouldRasterize = YES;
    viewCancel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //하단탭바의 현재 상태를 저장
    tabbarStatus = ApplicationDelegate.HMV.tabBarView.hidden;
}

-(void)gsMediaUploadWithUrl:(NSString *)strToappAttach andTarget:(id<GSMediaUploaderDelegate>)target{

    self.delegatetarget = target;
    
    URLParser *parser = [[URLParser alloc] initWithURLString:strToappAttach];
    // caller 추가
    [DataManager sharedManager].caller = NCS([parser valueForVariable:@"caller"]);
    [DataManager sharedManager].imguploadTargetUrlstr = [parser valueForVariable:@"uploadUrl"];
    [DataManager sharedManager].imguploadTargetJsFuncstr = [parser valueForVariable:@"callback"];
    [DataManager sharedManager].uploadfiletypestr = [parser valueForVariable:@"mediatype"];
    [DataManager sharedManager].photoLimit = [[parser valueForVariable:@"imagecount"] intValue];
    
    if (NCO([parser valueForVariable:@"maxsize"]) || [[parser valueForVariable:@"maxsize"] intValue] > 0) {
        [DataManager sharedManager].videoSizeLimit = [[parser valueForVariable:@"maxsize"] intValue] * 1024 * 1024;
    }else{
        [DataManager sharedManager].videoSizeLimit = VIDEOUPLOADBYTELIMIT;
    }
    
    UIViewController* targetVC = (UIViewController*)target;
    self.frame = targetVC.view.frame;
    [targetVC.view addSubview:self];
        
    if([[parser valueForVariable:@"mediatype"] isEqualToString:@"image"])
    {
        [self pictureBtnShowAction:nil];
    }
    else
    {
        [self videoBtnShowAction];
    }
}

-(void)gsMediaUploadWithParser:(URLParser *)parser andTargetView:(id<GSMediaUploaderDelegate>)target andType:(NSInteger)index{
    
    self.delegatetarget = target;
    
    // caller 추가
    [DataManager sharedManager].caller = NCS([parser valueForVariable:@"caller"]);
    
    UIView* targetView = (UIView*)target;
    self.frame = targetView.frame;
    [targetView addSubview:self];
    
    [self showCamera:index];
}

-(void)gsMediaUploadWithParser:(NSString *)strToappAttach andTarget:(id<GSMediaUploaderDelegate>)target andType:(NSInteger)index{
    
    self.delegatetarget = target;
    
    URLParser *parser = [[URLParser alloc] initWithURLString:strToappAttach];
    // caller 추가
    [DataManager sharedManager].caller = NCS([parser valueForVariable:@"caller"]);
    [DataManager sharedManager].imguploadTargetUrlstr = [parser valueForVariable:@"uploadUrl"];
    [DataManager sharedManager].imguploadTargetJsFuncstr = [parser valueForVariable:@"callback"];
    [DataManager sharedManager].uploadfiletypestr = [parser valueForVariable:@"mediatype"];
    [DataManager sharedManager].photoLimit = [[parser valueForVariable:@"imagecount"] intValue];
    
    if (NCO([parser valueForVariable:@"maxsize"]) || [[parser valueForVariable:@"maxsize"] intValue] > 0) {
        [DataManager sharedManager].videoSizeLimit = [[parser valueForVariable:@"maxsize"] intValue] * 1024 * 1024;
    }else{
        [DataManager sharedManager].videoSizeLimit = VIDEOUPLOADBYTELIMIT;
    }
    
    UIViewController* targetVC = (UIViewController*)target;
    self.frame = targetVC.view.frame;
    [targetVC.view addSubview:self];
    
    if (index == 0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
            Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_cant_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
            lalert.tag = 379;
            [ApplicationDelegate.window addSubview:lalert];
            return;
        }
        else {
            [self showCamera:0];
            [DataManager sharedManager].cameraFlag = YES;
        }
    }else{
        [self showCamera:index];
    }
    
}

#pragma mark -
#pragma mark cameraload

//사진찍기 액션시트
- (void)pictureBtnShowAction:(NSString *)caller {
    UIAlertController *csheet = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cam = [UIAlertAction
                          actionWithTitle:GSSLocalizedString(@"assetpicker_actsheet_takepic")
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [csheet dismissViewControllerAnimated:YES completion:nil];
                              if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
                                  Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_cant_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                                  lalert.tag = 379;
                                  [ApplicationDelegate.window addSubview:lalert];
                                  return;
                              }
                              else {
                                  [self showCamera:0];
                                  [DataManager sharedManager].cameraFlag = YES;
                              }
                          }];
    UIAlertAction *album = [UIAlertAction
                            actionWithTitle:GSSLocalizedString(@"assetpicker_actsheet_album")
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [csheet dismissViewControllerAnimated:YES completion:nil];
                                [self showCamera:1];
                                [DataManager sharedManager].cameraFlag = YES;
                            }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:GSSLocalizedString(@"common_txt_alert_btn_cancel")
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                    [csheet dismissViewControllerAnimated:YES completion:nil];
                                    
                                    [self removeFromSuperview];
                             }];
    
    [csheet addAction:cam];
    [csheet addAction:album];
    [csheet addAction:cancel];
    
    if ([delegatetarget isKindOfClass:[UIViewController class]]) {
        UIViewController *target = (UIViewController *)delegatetarget;
        
        if(target != nil) {
            if( [csheet respondsToSelector:@selector(popoverPresentationController)] ) {
                csheet.popoverPresentationController.sourceView = target.view;
                // 위치를 중앙으로..(버튼위로)
                csheet.popoverPresentationController.sourceRect = CGRectMake(target.view.frame.size.width/2, (target.view.frame.size.height/7)*4-20, 0, 0);
            }
            if(tabbarStatus == NO) {
                ApplicationDelegate.HMV.tabBarView.hidden = YES;
            }
            
            [target presentViewController:csheet animated:YES completion:nil];
        }
        
    }
}

//비디오찍기 액션시트
- (void)videoBtnShowAction {
    //앨범에서 video만
    if(tabbarStatus == NO) {
        ApplicationDelegate.HMV.tabBarView.hidden = YES;
    }
    [self showCamera:2];
    [DataManager sharedManager].cameraFlag = YES;
}
// 카메라 show
- (void)showCamera:(NSInteger)index
{
    
    NSLog(@"camerashow = %ld",(long)index);
    UIImagePickerControllerSourceType sourceType;
    if(index == 0){
        //촬영
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            // do your logic
            NSLog(@"");
            
            sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController* pickerview = [[UIImagePickerController alloc] init];
            pickerview.delegate = self;
            pickerview.sourceType = sourceType;
            pickerview.allowsEditing = NO;
            [ApplicationDelegate.window.rootViewController presentViewController:pickerview animated:YES completion:nil];
            
            
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
            NSLog(@"");
            
            Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
            lalert.tag = 380;
            [ApplicationDelegate.window addSubview:lalert];
            
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
            Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
            lalert.tag = 380;
            [ApplicationDelegate.window addSubview:lalert];
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", mediaType);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImagePickerController* pickerview = [[UIImagePickerController alloc] init];
                        pickerview.delegate = self;
                        pickerview.sourceType = UIImagePickerControllerSourceTypeCamera;
                        pickerview.allowsEditing = NO;
                        [ApplicationDelegate.window.rootViewController presentViewController:pickerview animated:YES completion:nil];
                    });
                } else {
                    NSLog(@"Not granted access to %@", mediaType);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
                        lalert.tag = 380;
                        [ApplicationDelegate.window addSubview:lalert];
                    });
                }
            }];
        } else {
            // impossible, unknown authorization status
            // restricted, normally won't happen
            Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usecamera") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
            lalert.tag = 380;
            [ApplicationDelegate.window addSubview:lalert];
            
        }
        
        
        
        
        
    }else {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusDenied) {
            
            Mocha_Alert* lalert  = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"msg_require_usephoto") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"alert_authorization_no"),GSSLocalizedString(@"alert_authorization_yes"), nil]];
            lalert.tag = 380;
            [ApplicationDelegate.window addSubview:lalert];
            
            return;
            
        }
        
        //caller 정의
        //mobiletalk = 고객센터 상담문의 글쓰기
        //showmecafe = 쇼미카페
        if([@"mobiletalk" isEqualToString:[DataManager sharedManager].caller] || [@"livetalk" isEqualToString:[DataManager sharedManager].caller]){
            
            self.bsImagePickerController = [[BSImagePickerViewController alloc] init];
            self.bsImagePickerController.maxNumberOfSelections = 5;
            // 글자색상
            [self.bsImagePickerController.navigationBar setTintColor:UIColor.blackColor];
            [self.bsImagePickerController.albumButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            [self.bsImagePickerController.albumButton setTitleColor:UIColor.blackColor forState:UIControlStateHighlighted];
            
            
            // 완료 버튼 TEXT
            // 아래 설정으로 바뀌지 않아서 Localizable.strings 파일의
            // "Done" = "선택"; 으로 설정하니 바뀐다...
            //                self.bsImagePickerController.doneButton.title = @"선택";
            
            self.bsImagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [ApplicationDelegate.window.rootViewController bs_presentImagePickerController:self.bsImagePickerController animated:YES select:^(PHAsset * _Nonnull selectedAsset) {
                
                NSLog(@"selectedAsset");
            } deselect:^(PHAsset * _Nonnull deselectedAsset) {
                
                NSLog(@"deselectedAsset");
            } cancel:^(NSArray<PHAsset *> * _Nonnull canceledAsset) {
                
                // 취소 버튼을 눌렀을 때 호출되는 클로저 블록
                [self closeGSMediaUploaderView];
            } finish:^(NSArray<PHAsset *> * _Nonnull finshedAsset) {
                
                // 완료버튼을 눌렀을 때 호툴되는 클로저 블록
                [self didFinishPickingMediaWithAssets:finshedAsset sender:self.bsImagePickerController];
            } completion:nil selectLimitReached:^(NSInteger selectLimit) {
                
                // 제한갯수 이상 선택할 시 호출되는 클로저 블록
                dispatch_async(dispatch_get_main_queue(), ^{
                    Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"assetpicker_photo_validation") maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:nil buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                    [ApplicationDelegate.window addSubview:alt];
                });
            }];
            
        }else{
            UIImagePickerController* pickerview = [[UIImagePickerController alloc] init];
            pickerview.delegate = self;
            pickerview.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerview.allowsEditing = NO;
            pickerview.navigationBar.barStyle = UIBarStyleDefault;
            pickerview.navigationBar.translucent = NO;
            pickerview.modalPresentationStyle = UIModalPresentationOverFullScreen;
            pickerview.navigationBar.barTintColor = [UIColor whiteColor];
            pickerview.navigationBar.tintColor = [UIColor blackColor];
            
            
            if (@available(iOS 11.0, *)) {
                pickerview.videoExportPreset = AVAssetExportPresetPassthrough;
            }

            if(index == 2){
                //앨범에서 비디오만 가져오기
                [pickerview setMediaTypes:@[(NSString *)kUTTypeMovie]];
            }
            
            
            [ApplicationDelegate.window.rootViewController presentViewController:pickerview animated:YES completion:nil];
        }
    }
}

- (void) didFinishPickingMediaWithAssets:(NSArray *)assets sender:(UIViewController *) sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    [ApplicationDelegate.gactivityIndicator startAnimating];
    
    
    if([[DataManager sharedManager].uploadfiletypestr isEqualToString:@"image"]){
        
        [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            
            if (assets.count < 1) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                });
                return;
            }
            
            __block int intvi=0;
            
            //1:1모바일 상담용
            __block NSMutableArray *arrImages = [[NSMutableArray alloc] init];
            
            for (PHAsset *asset in assets) {
                //__block NSMutableDictionary *imageAssetInfo = [NSMutableDictionary new];
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = YES;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                //                options.networkAccessAllowed = YES;
                //                options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info){
                //                    NSLog(@"progressprogress = %f",progress);
                //                };
                
                [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                                  options:options
                                                            resultHandler:
                 ^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                     if ([info[@"PHImageResultIsInCloudKey"] isEqual:@YES] && imageData == nil) {
                         // in the cloud
                         NSLog(@"in the cloud (sync grabImageDataFromAsset)");
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             
                             [ApplicationDelegate.gactivityIndicator stopAnimating];
                             Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"assetpicker_photo_not_in_device")  maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:nil buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                             alt.tag = 444;
                             [ApplicationDelegate.window addSubview:alt];
                             return;
                         });
                     }
                     
                     //imageAssetInfo = [info mutableCopy];
                     if (imageData) {
                         //imageAssetInfo[@"IMAGE_NSDATA"] = imageData;
                         UIImage *image = [UIImage imageWithData:imageData];
                         
                         [DataManager sharedManager].imageLastUpload = [image copy];
                         
                         UIImage *img = [Common_Util imageResizeForGSUpload:image];
                         
                         NSLog(@"image SIze = %@  === upurl : %@",NSStringFromCGSize(img.size),  [DataManager sharedManager].imguploadTargetUrlstr);
                         // dispatch_after를 이용하는 경우
                         
                         if([@"mobiletalk" isEqualToString:[DataManager sharedManager].caller]){
                             //1:1 모바일 상담은 멀티 첨부라 여기 안타지만 나중에 첨부스타일 바뀌었을떄를 대비
                             [arrImages addObject:img];
                             intvi++;
                             
                             if (intvi == [assets count]) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:arrImages,@"arrImages", nil];
                                     if ([delegatetarget respondsToSelector:@selector(didSuccesUpload:)]) {
                                         [delegatetarget didSuccesUpload:dicResult];
                                     }
                                     
                                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                                    [self removeFromSuperview];
                                     return;
                                 });
                             }
                             
                         }else{
                             
                             
                            intvi++;
                            BOOL  neos = [self uploadAttachImage:img withPhNum:intvi];;
                            
                            if(neos ==YES){
                                if(intvi == [assets count]){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [ApplicationDelegate.gactivityIndicator stopAnimating];
                                        [self didSuccesUpload:nil];
                                    });
                                }
                                NSLog(@"올리고 %d", intvi);
                                
                                
                            }else {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                                    [self didFailedUpload];
                                });
                                
                                NSLog(@"실패하고 %d", intvi);
                                //실패했을경우 무조건 proc 종료
                                return;
                                
                            }
                         }
                         
                         
                         
                     }else{
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [ApplicationDelegate.gactivityIndicator stopAnimating];
                             [self didFailedGetAsset];
                         });
                     }
                 }];
            }
            
            
        }];
        
    }
    });
}

- (void)closeGSMediaUploaderView {
    dispatch_async(dispatch_get_main_queue(), ^{
    [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self removeFromSuperview];
    }];
    });
}



#pragma mark - PickerControllerDelegate Methods
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if ( error ) {
        // error가 nil이 아닌 경우는 보존 실패
    } else {
        // nil이라면 보존 성공
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker {
    NSLog(@"camera cancel");
    
    // 취소되었을 때에 실시해야 할 처리를 하고 그 후 사진앨범을 닫는다
    [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
        [self removeFromSuperview];
    }];
    
    
}
//camera close.이미지를 선책하고 나올때 불려진다.
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{

    [ApplicationDelegate.gactivityIndicator startAnimating];
    [ApplicationDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"infoinfoinfo = %@",info);
        NSString *strMediaType = (NSString *)[info objectForKey:@"UIImagePickerControllerMediaType"];
        PHAsset *asset = (PHAsset *)[info objectForKey:@"UIImagePickerControllerPHAsset"];
        
        if ([(NSString *)kUTTypeImage isEqualToString:strMediaType] || [(NSString *)kUTTypeLivePhoto isEqualToString:strMediaType] ) {
            
            if (asset == nil) { //어셋이 없으면 사진 촬영임 따로 처리
                
                UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
                if ( !image ) {
                    // 편집한 사진이 없으면 오리지널 사진을 취득한다
                    image = [info objectForKey:UIImagePickerControllerOriginalImage];
                    NSLog(@"");
                }
                
                UIImage *img = [Common_Util imageResizeForGSUpload:image];
                
                NSLog(@"image SIze = %@  === upurl : %@",NSStringFromCGSize(img.size),  [DataManager sharedManager].imguploadTargetUrlstr);
                
                if([@"mobiletalk" isEqualToString:[DataManager sharedManager].caller]){
                    //1:1 모바일 상담만 특수 케이스임
                    NSArray *arrImages = [NSArray arrayWithObject:img];
                    NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:arrImages,@"arrImages", nil];
                    if ([delegatetarget respondsToSelector:@selector(didSuccesUpload:)]) {
                        [delegatetarget didSuccesUpload:dicResult];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        [ApplicationDelegate.gactivityIndicator stopAnimating];
                        
                    });
                    
                    [self removeFromSuperview];
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(),^{
                        [ApplicationDelegate.gactivityIndicator stopAnimating];
                        if(img != nil){
                            [self uploadAttachImage:img withPhNum:1];
                        }else{
                            [self didFailedGetAsset];
                        }
                        
                    });
                    
                }
                
                
                
                return;
            }//촬영 처리 끝
            
            //__block NSMutableDictionary *imageAssetInfo = [NSMutableDictionary new];
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.synchronous = YES;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                 if ([info[@"PHImageResultIsInCloudKey"] isEqual:@YES]) {
                     // in the cloud
                     NSLog(@"in the cloud (sync grabImageDataFromAsset)");
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [ApplicationDelegate.gactivityIndicator stopAnimating];
                         Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"assetpicker_photo_not_in_device")  maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:nil buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                         alt.tag = 444;
                         [ApplicationDelegate.window addSubview:alt];
                         return;
                     });
                 }
                 //imageAssetInfo = [info mutableCopy];
                 if (imageData) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [ApplicationDelegate.gactivityIndicator stopAnimating];
                     });
                     //imageAssetInfo[@"IMAGE_NSDATA"] = imageData;
                     UIImage *image = [UIImage imageWithData:imageData];
                     UIImage *img = [Common_Util imageResizeForGSUpload:image];
                     NSLog(@"image SIze = %@  === upurl : %@",NSStringFromCGSize(img.size),  [DataManager sharedManager].imguploadTargetUrlstr);
                     
                     
                     if([@"mobiletalk" isEqualToString:[DataManager sharedManager].caller]){
                         //1:1 모바일 상담은 멀티 첨부라 여기 안타지만 나중에 첨부스타일 바뀌었을떄를 대비
                         NSArray *arrImages = [NSArray arrayWithObject:img];
                         NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:arrImages,@"arrImages", nil];
                         if ([delegatetarget respondsToSelector:@selector(didSuccesUpload:)]) {
                             [delegatetarget didSuccesUpload:dicResult];
                         }
                         
                         dispatch_async(dispatch_get_main_queue(),^{
                             
                             [self removeFromSuperview];
                         });
                         
                         
                     }else{

                         dispatch_async(dispatch_get_main_queue(),^{
                             if(img != nil){
                                 [self uploadAttachImage:img withPhNum:0];
                             }else{
                                 [self didFailedGetAsset];
                             }
                             
                         });
                         
                     }
                     
                 }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ApplicationDelegate.gactivityIndicator stopAnimating];
                        [self didFailedGetAsset];
                    });
                 }
                
                
                
             }];
            
        }else if ([(NSString *)kUTTypeMovie isEqualToString:strMediaType] ) {
            
            __block NSURL *videoUrl = nil;
            __block unsigned long long length = 0;
            
            exportProgressBarTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateExportDisplay) userInfo:nil repeats:YES];
            dispatch_async(dispatch_get_main_queue(),^{
                viewUpload.hidden = NO;
                lblTitle.text = @"동영상 mp4 변환중";
            });
            
            if ([NCS( ((NSURL *)[info objectForKey:@"UIImagePickerControllerMediaURL"]).absoluteString ) length] > 0) {

                videoUrl = (NSURL *)[info objectForKey:@"UIImagePickerControllerMediaURL"];
                // use URL to get file content
                NSLog(@"videoUrlvideoUrl url:  %@",  [videoUrl absoluteString] );
                
                NSNumber *fileNumberSize = nil;
                NSError *error = nil;
                [videoUrl getResourceValue:&fileNumberSize forKey:NSURLFileSizeKey error:&error];
                NSLog(@"원본 fileNumberSize: %@\nerror: %@", fileNumberSize, error);
                length = [fileNumberSize unsignedLongLongValue];
            
                [self convertAndUpload:videoUrl];
                
            }else if((PHAsset *)[info objectForKey:@"UIImagePickerControllerPHAsset"] != nil){
                //만일 UIImagePickerControllerMediaURL 이 없는경우 이 아래로 추가해야함
             
                PHAsset *asset = (PHAsset *)[info objectForKey:@"UIImagePickerControllerPHAsset"];
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHVideoRequestOptionsVersionOriginal;
                
                [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                    if ([asset isKindOfClass:[AVURLAsset class]]) {
                        
                        videoUrl = [(AVURLAsset *)asset URL];
                        // use URL to get file content
                        NSLog(@"videoUrlvideoUrl url:  %@",  [videoUrl absoluteString] );
                        
                        NSNumber *fileNumberSize = nil;
                        NSError *error = nil;
                        [videoUrl getResourceValue:&fileNumberSize forKey:NSURLFileSizeKey error:&error];
                        NSLog(@"fileNumberSize: %@\nerror: %@", fileNumberSize, error);
                        
                        length = [fileNumberSize unsignedLongLongValue];
                        
                        [self convertAndUpload:videoUrl];
                    }
                }];
                 
            }else{ //동영상 파일 정모 못가져옴
            
                if ([exportProgressBarTimer isValid]) {
                    [exportProgressBarTimer invalidate];
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
                    viewUpload.hidden = YES;
                    [self didFailedGetAsset];
                });
            }
            
            
        }
    
    }];
}

- (void)updateExportDisplay {
    viewProg.progress = exportSession.progress;
    lblPercent.text = [NSString stringWithFormat:@"%ld%%",(long)(exportSession.progress *100.0)];
    if (viewProg.progress > .99) {
        if ([exportProgressBarTimer isValid]) {
            [exportProgressBarTimer invalidate];
        }
        lblPercent.text = @"100%";
    }
}


#pragma mark - Convert & Upload

-(void)convertAndUpload:(NSURL *)videoUrl{
    NSString *tmpVideoPath = [NSString stringWithFormat:@"%@/iOSmedia.mp4",DOCS_DIR];
    AVAsset *avAsset = [AVAsset assetWithURL:videoUrl];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dbexits = [fileManager fileExistsAtPath:tmpVideoPath];
    
    if (dbexits) //존재하면 삭제
    {
        [fileManager removeItemAtPath:tmpVideoPath error:NULL];
        NSLog(@"delete tmp mp4 file complete!!!!!!!!");
    }
    
    exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = [NSURL fileURLWithPath:tmpVideoPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    CMTime start = CMTimeMakeWithSeconds(0.0, 600);
    CMTime duration = avAsset.duration;
    CMTimeRange range = CMTimeRangeMake(start, duration);
    exportSession.timeRange = range;
    
    NSLog(@"동영상 export 중~!!!");
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus status = [exportSession status];
        
        if (status == AVAssetExportSessionStatusFailed) {
            NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
            dispatch_async(dispatch_get_main_queue(),^{
                viewUpload.hidden = YES;
                if ([exportProgressBarTimer isValid]) {
                    [exportProgressBarTimer invalidate];
                }
                
                dispatch_async(dispatch_get_main_queue(),^{
                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                    [self didFailedConvert];
                    return;
                });
            });
        }else if (status == AVAssetExportSessionStatusCancelled) {
            dispatch_async(dispatch_get_main_queue(),^{
                viewUpload.hidden = YES;
                if ([exportProgressBarTimer isValid]) {
                    [exportProgressBarTimer invalidate];
                }
                dispatch_async(dispatch_get_main_queue(),^{
                    [ApplicationDelegate.gactivityIndicator stopAnimating];
                    //[self didCancelUpload];
                    return;
                });
                
            });
        }else if (status == AVAssetExportSessionStatusCompleted) {
            dispatch_async(dispatch_get_main_queue(),^{
                [ApplicationDelegate.gactivityIndicator stopAnimating];
                if ([exportProgressBarTimer isValid]) {
                    [exportProgressBarTimer invalidate];
                }
                
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:tmpVideoPath error:nil];

                NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                long long fileSize = [fileSizeNumber longLongValue];
                
                
                long long limit = 0;
                if ([DataManager sharedManager].videoSizeLimit != 0 ) {
                    limit =[DataManager sharedManager].videoSizeLimit;
                }else{
                    limit =VIDEOUPLOADBYTELIMIT;
                }
                
                NSLog(@"fileSizefileSize = %lld",fileSize);
                NSLog(@"limitlimitlimit = %lld",limit);

                if(fileSize > limit) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [ApplicationDelegate.gactivityIndicator stopAnimating];
                    
                        Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:[NSString stringWithFormat:GSSLocalizedString(@"assetpicker_video_size_over"),limit/(1024*1024) ] maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:self buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
                        alt.tag = 444;
                        [ApplicationDelegate.window addSubview:alt];
                        
                        if ([exportProgressBarTimer isValid]) {
                            [exportProgressBarTimer invalidate];
                        }
                        return;
                    });
                }else{
                    [self uploadAttachVideoPath:tmpVideoPath];
                }
                
            });
        }
        
    }];
}



- (BOOL)uploadAttachImage:(UIImage *)image withPhNum:(NSUInteger)tpnum {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75f);
    NSLog(@"image byte: %ld byte ",(unsigned long)[imageData length]);
    
    if([imageData length] > PHOTOUPLOADBYTELIMIT) {
        Mocha_Alert *alt = [[Mocha_Alert alloc] initWithTitle:GSSLocalizedString(@"assetpicker_photo_size_over")  maintitle:GSSLocalizedString(@"common_txt_alert_title") delegate:nil buttonTitle:[NSArray arrayWithObjects:GSSLocalizedString(@"common_txt_alert_btn_confirm"), nil]];
        alt.tag = 444;
        [ApplicationDelegate.window addSubview:alt];
        return NO;
    }
    
    
    
    NSMutableDictionary* post_dict = [[NSMutableDictionary alloc] init];    
    
    NSURL *url = [NSURL URLWithString:[[DataManager sharedManager].imguploadTargetUrlstr urlDecodedString]];
    //NSURL *url = [NSURL URLWithString:@"http://10.52.38.13/cafe/common/doFileUploadApp.gs"];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod: @"POST"];
    [urlRequest setValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
    [post_dict setObject:@"iOSimage.jpg" forKey:@"fileName"];
    [post_dict setObject:imageData forKey:@"file"];
    
    //라이브톡용 이미지 업로드 규격적용
    if([[DataManager sharedManager].caller isEqualToString:@"livetalk"])
    {
        // 20160701 parksegun S:정사각형 V:세로 H:가로
        NSString *shape = @"H";
        
        if(image.size.height == image.size.width)
        {
            shape = @"S";
        }
        else if(image.size.height > image.size.width)
        {
            shape = @"V";
        }
        else//     if(image.size.height < image.size.width)
        {
            shape = @"H";
        }
        
        
        float imgSize = [imageData length];
        NSLog(@"image byte: %f byte ", imgSize);
        if(imgSize > LIVETALKPHOTOLIMIT)
        {
            
            float zipSize = 0.95f;
            imageData = UIImageJPEGRepresentation(image, zipSize);
            imgSize = [imageData length];
            NSLog(@"95%% image byte: %f byte ", imgSize);
            while(imgSize > LIVETALKPHOTOLIMIT )
            {
                zipSize = zipSize - 0.1f; // 10%씩 압축률을 올린다.
                if(zipSize < 5.0f) // 무한으로 빠지는것을 막기위해 5% 퀄리티 면 탈출!
                    break;
                imageData = UIImageJPEGRepresentation(image, zipSize); // 오리지널 이미지를 기준으로 압축한다.
                imgSize = [imageData length];
                NSLog(@"Quly: %lf ,image byte: %f byte ",zipSize, imgSize);
            }//18117
            
        }
        else
        {
            // 사이즈가 200kb 이하면 bypass
            NSLog(@"BY PASS");
        }
        
        [post_dict setObject:shape forKey:@"imgType"];
    }
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [urlRequest setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    //NSLog(@"   %%%%%%%% = %@",  post_dict);
    
    // Create the post data from the post dictionary
    NSData *postData = [ApplicationDelegate  generateFormDataFromPostDictionary:post_dict];
    
    
    [urlRequest setHTTPBody: postData];
    
    // Submit & retrieve results
    NSError *error;
    NSURLResponse *response;
    NSLog(@"Contacting Server....");
    NSData* result = [NSURLSession sendSessionSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    
    
    if (!result)
    {
        
        if([@"livetalk" isEqualToString:[DataManager sharedManager].caller]){
            //라이브톡 일경우 다중 업로드 임으로 다 처리된후에 판단한다
        }else{
            [self didFailedUpload];
        }
        
        return NO;
    }else {
        
        NSDictionary *resultj = [result JSONtoValue];
        
        NSString* drs1 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"result"]];
        NSString* drs2 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"tmpFileName"]];
        NSString* drs3 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"realFileName"]];
        NSString* drs4 = [NSString stringWithFormat:@"%@", [resultj objectForKey:@"fileUrl"]];
        NSString* strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\",\"%@\")",[DataManager sharedManager].imguploadTargetJsFuncstr,  drs1, drs2,drs3,drs4    ];
        NSLog(@"%@ === vvvvvvvvv ",     strjs);
        
        
        //webview callJscriptMethod runloop 오류 대응
        CFRunLoopRunInMode((CFStringRef)NSDefaultRunLoopMode, 0.25, NO);
        
        //[self performSelectorOnMainThread:@selector(callJscriptMethod:) withObject:strjs waitUntilDone:NO modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
        
        if([NCS([resultj objectForKey:@"result"]) isEqualToString:@"success"]){
            
            if([@"mobiletalk" isEqualToString:[DataManager sharedManager].caller]){
                [delegatetarget didSuccesUpload:resultj];
            }else{
                [self didSuccesUpload:resultj];
            }
            
            return YES;
        }
        
    }
    
    return NO;
    
    
}



-(BOOL)uploadAttachVideoPath:(NSString *)tmpVideoPath {
    
    
    NSLog(@"업로드 시작~~!!");
    
    lblTitle.text = @"동영상 업로드";
    
    NSURL *url = [NSURL URLWithString:[[DataManager sharedManager].imguploadTargetUrlstr urlDecodedString]];
    //NSURL *url = [NSURL URLWithString:@"http://tevent.gsshop.com/cafe/common/doFileUploadApp.gs"];
    //NSURL *url = [NSURL URLWithString:@"http://sm20.gsshop.com/cafe/common/doFileUploadApp.gs"];
    NSLog(@"");
    
    self.inputStream = [[PKMultipartInputStream alloc] init];
    [self.inputStream addPartWithName:@"file" path:tmpVideoPath];
    
    NSLog(@"");
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:600];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [self.inputStream boundary]] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (long)[self.inputStream length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBodyStream:self.inputStream];
    [request setHTTPMethod:@"POST"];
    
    //2017.11.23 모든 NSMutableURLRequest User-Agent 일괄추가
    NSString *strUserAgent = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAgent"];
    [request setValue:strUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    NSLog(@"");
    
    if (dataReceive == nil) {
        dataReceive  = [[NSMutableData alloc] initWithLength:0];
    }
    
    [dataReceive setLength:0];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    task = [session uploadTaskWithStreamedRequest:request];
    [task resume];
    
    return NO;
    
    
}

-(IBAction)onBtnCancel:(id)sender{
//    [connect cancel];
//    [self didCancelUpload];
  
    AVAssetExportSessionStatus status = [exportSession status];
    
    if (status == AVAssetExportSessionStatusExporting || status == AVAssetExportSessionStatusWaiting || status == AVAssetExportSessionStatusUnknown) {
        [exportSession cancelExport];
    }
    
    if(task != nil){
        [task cancel];
    }
    
    [self didCancelUpload];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    if (((double)totalBytesSent/(double)totalBytesExpectedToSend) == 1.00) {
        //NSLog(@"totalBytesWritten = %lu",(long)totalBytesWritten);
        
    }
    
    
    dispatch_async(dispatch_get_main_queue(),^{
        lblPercent.text = [NSString stringWithFormat:@"%d %%",(int)((double)totalBytesSent/(double)totalBytesExpectedToSend*100.0)];
        viewProg.progress = (double)totalBytesSent/(double)totalBytesExpectedToSend;
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    completionHandler(self.inputStream);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"%s: error = %@; data = %@", __PRETTY_FUNCTION__, error, [[NSString alloc] initWithData:dataReceive encoding:NSUTF8StringEncoding]);
    
    if (error == nil) {
        NSDictionary *resultj = [dataReceive JSONtoValue];
        //NSLog(@"resultj = %@",resultj);
        dispatch_async(dispatch_get_main_queue(),^{
            [self didSuccesUpload:resultj];
        });
    }else{
        dispatch_async(dispatch_get_main_queue(),^{
            if ([error code] != -999) { //취소일경우 다른곳에서 알럿뜸
                [self didFailedUpload];
            }
        });
    }
    
}




#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    //self.responseData = [NSMutableData data];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [dataReceive appendData:data];
}

#pragma mark - UICustomAlertDelegate

//치명 중요 이 파일은 toapp://attach 가 들어올떄마다 웹뷰에 이 뷰를 addsubview 하는 방식임
//따라서 애러,사용완료 시 꼭 removeFromSuperview 를 해줘야함 안할경우 더이상 앱을 사용하기어려움

- (void)customAlertView:(UIView *)alert clickedButtonAtIndex:(NSInteger)index{
    
    if(alert.tag == 379) {
        [self removeFromSuperview];
    }else if(alert.tag == 380) {
        [self removeFromSuperview];
        switch (index) {
            case 1:
                NSLog(@"설정");
                [[UIApplication sharedApplication] openURL_GS:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                break;
            default:
                break;
        }
        
    }else if(alert.tag == 444) {
        [self removeFromSuperview];
    }
    
}

- (void) removeFromSuperview {
    //하단탭바가 노출되어 있던 상태면 노출 유지
    if(tabbarStatus == NO) {
        ApplicationDelegate.HMV.tabBarView.hidden = NO;
    }
    [super removeFromSuperview];
}


#pragma mark - GSMediaUploaderDelegate

- (void)didSuccesUpload:(NSDictionary *)dicResult{
    
    if (dicResult !=nil && [delegatetarget respondsToSelector:@selector(callJscriptMethod:)]) {
        //[delegatetarget didSuccesUpload:dicResult];
        
        NSLog(@"dicResultdicResult = %@",dicResult);
        
        NSString *strType = NCS([dicResult objectForKey:@"imgType"]);
        NSString *strThumbnail = NCS([dicResult objectForKey:@"thumbnail"]);
        
        NSString* drs1 = [NSString stringWithFormat:@"%@", [dicResult objectForKey:@"result"]];
        NSString* drs2 = [NSString stringWithFormat:@"%@", [dicResult objectForKey:@"tmpFileName"]];
        NSString* drs3 = [NSString stringWithFormat:@"%@", [dicResult objectForKey:@"realFileName"]];
        NSString* drs4 = [NSString stringWithFormat:@"%@", [dicResult objectForKey:@"fileUrl"]];
        
        NSString* strjs = nil;
        
        if ([@"video" isEqualToString:strType] && [strThumbnail hasPrefix:@"http"]  ) {
            strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[DataManager sharedManager].imguploadTargetJsFuncstr,  drs1, drs2,drs3,drs4,strType,strThumbnail];
        }else{
            
            if([@"livetalk" isEqualToString:[DataManager sharedManager].caller]){
                strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",[DataManager sharedManager].imguploadTargetJsFuncstr,  drs1, drs2,drs3,drs4,strType];
                
            }else{
                strjs = [NSString stringWithFormat:@"javascript:%@(\"%@\",\"%@\",\"%@\",\"%@\")",[DataManager sharedManager].imguploadTargetJsFuncstr,  drs1, drs2,drs3,drs4];
            }
        }

        NSLog(@"%@ === vvvvvvvvv ",     strjs);
        UIViewController *vc = (UIViewController *)delegatetarget;
        [vc performSelectorOnMainThread:@selector(callJscriptMethod:) withObject:strjs waitUntilDone:NO];
        
        //의미는 없으나 필요하면 호출
        [delegatetarget didSuccesUpload:dicResult];
    }
    
    [self removeFromSuperview];
    
    
}
- (void)didFailedUpload{
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:@"업로드가 실패 했습니다."
                                                   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
    malert.tag = 444;
    [ApplicationDelegate.window addSubview:malert];
}
- (void)didCancelUpload{
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:@"취소하셨습니다."
                                                   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
    
    malert.tag = 444;
    [ApplicationDelegate.window addSubview:malert];
}

- (void)didFailedConvert{
    
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:@"동영상 변환중 애러가 발생했습니다."
                                                   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
    malert.tag = 444;
    [ApplicationDelegate.window addSubview:malert];
}

- (void)didFailedGetAsset{
    
    Mocha_Alert* malert = [[Mocha_Alert alloc] initWithTitle:@"파일 정보를 가져오지 못했습니다."
                                                   maintitle:nil delegate:self buttonTitle:[NSArray arrayWithObjects:  GSSLocalizedString(@"common_txt_alert_btn_yes"), nil]];
    malert.tag = 444;
    [ApplicationDelegate.window addSubview:malert];
}


@end
