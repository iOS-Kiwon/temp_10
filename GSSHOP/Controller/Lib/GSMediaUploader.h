//
//  GSMediaUploader.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 27..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKMultipartInputStream.h"
#import <BSImagePicker-Swift.h>

//치명 중요 이 파일은 toapp://attach 가 들어올떄마다 웹뷰에 이 뷰를 addsubview 하는 방식임
//따라서 애러,사용완료 시 꼭 removeFromSuperview 를 해줘야함 안할경우 더이상 앱을 사용하기어려움

@protocol GSMediaUploaderDelegate <NSObject>
@optional
- (void)didSuccesUpload:(NSDictionary *)dicResult;
@end

@interface GSMediaUploader : UIView <UINavigationControllerDelegate,UIImagePickerControllerDelegate, NSURLSessionDelegate,NSURLSessionTaskDelegate>{
    
    NSURLConnection *connect;
    NSMutableData *dataReceive;         //전송 결과 데이터
    
    IBOutlet UILabel* lblTitle;       //업로드 타이틀
    IBOutlet UIView* viewUpload;        //업로드 뷰
    IBOutlet UIView* viewCancel;        //취소 버튼뷰
    IBOutlet UILabel* lblPercent;       //업로드 진행률
    IBOutlet UIProgressView* viewProg;  //업로드 진행률 프로그래스 바
    
    NSTimer *exportProgressBarTimer;
    AVAssetExportSession *exportSession;
    NSURLSessionUploadTask *task;
    ///하단탭바 상태값
    BOOL tabbarStatus;
}
@property (weak, nonatomic) id<GSMediaUploaderDelegate> delegatetarget;
@property (nonatomic, strong) PKMultipartInputStream *inputStream;
@property (nonatomic, strong) BSImagePickerViewController *bsImagePickerController;

- (void)videoBtnShowAction;
- (void)pictureBtnShowAction:(NSString *)caller;
-(IBAction)onBtnCancel:(id)sender;
//GS내 이미지,동영상 첨부 공용
-(void)gsMediaUploadWithUrl:(NSString *)strToappAttach andTarget:(id<GSMediaUploaderDelegate>)target;
//1:1 모바일 상담용
-(void)gsMediaUploadWithParser:(URLParser *)parser andTargetView:(id<GSMediaUploaderDelegate>)target andType:(NSInteger)index;
//라이브톡 첨부용
-(void)gsMediaUploadWithParser:(NSString *)strToappAttach andTarget:(id<GSMediaUploaderDelegate>)target andType:(NSInteger)index;
@end
