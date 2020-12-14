//
//  GoodsEstimationVC.h
//  GSSHOP
//
//  Created by uinnetworks on 11. 7. 15..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GSSHOPAppDelegate;
@class GoodsInfo;


@interface GoodsEstimationVC : UIViewController <UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIScrollView *scrollView;
    UIView *aniView;
    UIView *infoView;
    
    NSString *prdID;
    //GoodsInfo *goods;
    UITextField *titleText;
    UITextView *descTextView;
    
    CGFloat posGap;
    
    UIPickerView *picker;  
    UIActionSheet *pickerActionSheet;
    CGRect hiddenFrame;
	CGRect visibleFrame;
    NSInteger btnTag;//등급주기 버튼 태그 저장 
    NSInteger labelTag;//등급주기 별 텍스트 태그 저장 
    UIButton *textViewEndBtn;//상품평 완료 버튼 
    NSInteger starNum[4];
    NSInteger bImgSend;
    NSMutableDictionary *goodsInfoDict;
    
 
    
}
@property (nonatomic, assign) id target;
@property(nonatomic, assign) CGRect hiddenFrame;
@property(nonatomic, assign) CGRect visibleFrame;

//@property (nonatomic,retain) GoodsInfo *goods;
@property (nonatomic,retain) NSString *prdID;
@property (nonatomic) NSInteger btnTag;
@property (nonatomic) NSInteger labelTag;
@property (nonatomic) NSInteger bImgSend;
@property (nonatomic,retain)NSMutableDictionary *goodsInfoDict;
//@property (nonatomic) NSInteger starNum[4];

- (id)initWithPrdid:(id)sender prdids:(NSString *)prdid;
- (void)loadingDataSet;
-(void)starNumUI;
-(void)popPickerView;
-(void) toggle;

//- (void)startDataLoading;
- (void)pictureViewUI;
- (void)upLoadImageShow;
- (NSString *) applicationCacheDirectory ;
- (void)starDisplayUI;
- (void)iconFileDownload:(NSString *)imageUrl;
@end


