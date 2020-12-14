//
//  PopupAttachView.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 19..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLParser.h"
#import "AttachInfo.h"
#import "AttachInfoRequest.h"
#import "GSMediaUploader.h"


#define RESTRICTPHOTOCOUNT  5
#define RESTRICTBYTEINTEGER 2000

@interface PopupAttachView : UIView <UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, AttachInfoRequestDelegate, GSMediaUploaderDelegate> {
    
    AttachInfo *CTInfoDict;
    
    BOOL isComming;
    BOOL isTalkUITypeB;
    BOOL isTalkUIExist;
    BOOL tabbarStatus;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) URLParser *urlpstr;
@property (nonatomic) NSInteger bImgSend;
@property  (nonatomic, strong)  IBOutlet UITextView *descTextView;
@property  (nonatomic, strong)  IBOutlet UIView *viewMainBG;
@property  (nonatomic, strong)  IBOutlet UIButton *btnforsend;
@property (nonatomic, retain) IBOutlet UILabel *restrictByteLabel;
@property (nonatomic, assign) CGRect bgFrame;

@property  (nonatomic, strong)  IBOutlet UILabel *lblTitle;
@property  (nonatomic, strong)  IBOutlet NSLayoutConstraint *constTextBoxHeight;
@property  (nonatomic, strong)  IBOutlet NSLayoutConstraint *constTopHeight;
@property  (nonatomic, strong)  IBOutlet NSLayoutConstraint *constAllHeight;
@property  (nonatomic, strong)  IBOutlet NSLayoutConstraint *constTextBoxBottom;
@property  (nonatomic, strong)  IBOutlet UIView *viewBoxLine;
@property  (nonatomic, strong)  IBOutlet UIButton *btnAccess;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupTopMargin;
@property (nonatomic, strong) NSMutableArray *sendimgArr;


- (void)openPopupWithFrame:(CGRect)aFrame
               superview:(UIView *)superview
                delegate:(id)delegate
                   param:(URLParser *)paramString
                animated:(BOOL)animated;

- (void)closeWithAnimated:(BOOL)animated;
- (void)setup;
- (IBAction)pictureBtnAction:(id)sender;
- (IBAction)btnAction:(id)sender;
- (void)justGoBack;
- (void)doneRequest:(NSString *)status;
- (void)doneimgRequest:(NSString *)status;
@end
