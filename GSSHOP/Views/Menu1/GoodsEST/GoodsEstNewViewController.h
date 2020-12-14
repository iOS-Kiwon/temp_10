//
//  GoodsEstNewViewController.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 5..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Common_Util.h"

#import "PopupAttachView.h"
#import "WSAssetPicker.h"

#define RESTRICT_ESTPHOTOCOUNT  5
#define RESTRICT_ESTBYTEINTEGER 1000

#define CONTENT             @"_CONTENT_KEY"
#define TEMPLATEKEY         @"_TEMPLATE_KEY"
#define VIEWFILEPATH        @"_VIEW_FILE_PATH"

#define PRDIMG              @"prdImg"
#define EXPOSPRDNM          @"exposPrdNm"
#define PRDCD               @"prdCd"
#define PRDREVWTOTGRD       @"prdrevwTotGrd"
#define ECOINCNT            @"ecoinCnt"
#define PRDREVWTYPCD        @"prdrevwTypCd"
#define CUSTNM              @"custNm"
#define EVALITMNM1          @"evalItmNm1"
#define EVALITMNM2          @"evalItmNm2"
#define EVALITMNM3          @"evalItmNm3"
#define EVALITMNM4          @"evalItmNm4"
#define EVALITMVAL1         @"evalItmVal1"
#define EVALITMVAL2         @"evalItmVal2"
#define EVALITMVAL3         @"evalItmVal3"
#define EVALITMVAL4         @"evalItmVal4"
#define APPINSTLEXPOSFLG    @"appInstlExposFlg"
#define REPPRDCD            @"repPrdCd"
#define ATACHFILEPATH       @"atachFilePath"

#define HIDDENDATA          @"hiddenData"
#define PRDREVWID           @"prdrevwId"
#define ORDNO               @"ordNo"
#define ATACHFILEGBN        @"atachFileGbn"
#define ORDITEMOPTNM1       @"ordItemOptNm1"
#define ORDITEMOPTNM2       @"ordItemOptNm2"
#define HPTSTFLG            @"hptstFlg"
#define HPTSTPMONO          @"hptstPmoNo"
#define PRDREVWTITLE        @"prdrevwTitle"
#define PRDREVWBODY         @"prdrevwBody"
#define ORDITEMOPTEXPOSFLG  @"ordItemOptExposFlg"
#define BESTPRDREVWFLG      @"bestPrdrevwFlg"
#define PRDREVWWRITEPATH    @"prdrevwWritPath"
#define ECID                @"ecid"
#define CUSTNO              @"custNo"
#define CATVID              @"catvid"
#define ECCUSTNO            @"ecCustNo"
#define ECUSER              @"ecuser"
#define NICK                @"Nick"
#define ECLNAME             @"eclname"
#define PRDREVW             @"prdRevw"
#define RRDREVWIMAGE        @"prdRevwImage"


//2015.08 상품평 멀티이미지 개편시 추가
#define RRDREVWIMAGE_ARR    @"prdRevwImageArr"
#define ATACHFILEPATHLIST   @"atachFilePathList"


@class GSSHOPAppDelegate;
@class GoodsInfo;


@interface GoodsEstNewViewController : UIViewController <UIActionSheetDelegate,UITextViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, MochaUIRatingDelegate,WSAssetPickerControllerDelegate>{
    
    NSMutableArray *_sendimgArr;
    
    IBOutlet UIButton *btn_write;
    
    //향후 수정작업 및 디자인가이드 대응 차원에서 기능별 view 작업
    //하단 연간할인권 드립니다 안내뷰
    IBOutlet UIView *view_g1;
    //자세히-닫기 버튼
    IBOutlet UIButton *btn_g1_detail;
    
    IBOutlet UIView *view_g1_bottomLine;
    // IBOutlet UIView *view_hiddenview;
    IBOutlet UIImageView *imgview_detailimg;
    
    
    
    IBOutlet UIView *view_g2;
    IBOutlet UIImageView *imgProduct;
    IBOutlet UILabel *lblProductName;
    
    IBOutlet UIView *view_g3;
    IBOutlet UIView *view_g4;
    IBOutlet UIView *view_g5;
    IBOutlet UIView *view_g6;
    IBOutlet UIView *view_g7;
    IBOutlet UILabel *infoMsg;
    IBOutlet UIImageView *infoIcon;
    
    IBOutlet UIScrollView *scrViewAttach;
    
    //IBOutlet UIImageView *viewg3_bg;
    IBOutlet UIView *viewg3_bg;
    
    IBOutlet UIView *viewg4_bg;
    IBOutlet UIView *viewg7_bg;
    
    IBOutlet UIButton *btnCancel;
    
    IBOutlet UIImageView *wguide_bg;
    IBOutlet UIImageView *wguide_txt;
    
    IBOutlet UILabel *reward_guidetxt;
    
    MochaUIRating * rating1;
    MochaUIRating * rating2;
    MochaUIRating * rating3;
    MochaUIRating * rating4;
    IBOutlet UILabel *label_vtitle;
    
    IBOutlet UIScrollView *scrollView;
    //UIView *aniView;
    UIView *infoView;
    
    NSString *prdID;
    //GoodsInfo *goods;
    //UITextField *titleText;
    UITextView *descTextView;
    
    CGFloat posGap;
    
    UIActionSheet *pickerActionSheet;
    CGRect hiddenFrame;
    CGRect visibleFrame;
    NSInteger btnTag;//등급주기 버튼 태그 저장
    NSInteger labelTag;//등급주기 별 텍스트 태그 저장
    UIButton *textViewEndBtn;//상품평 완료 버튼
    NSInteger starNum[4];
    NSInteger bImgSend;
    NSMutableDictionary *goodsInfoDict;
    
    NSString *goReturnURL;
    
}
@property (nonatomic, weak) id target;
@property (strong, nonatomic) MochaUIRating * rating1;
@property (strong, nonatomic) MochaUIRating * rating2;
@property (strong, nonatomic) MochaUIRating * rating3;
@property (strong, nonatomic) MochaUIRating * rating4;

@property(nonatomic, assign) CGRect hiddenFrame;
@property(nonatomic, assign) CGRect visibleFrame;

//@property (nonatomic,retain) GoodsInfo *goods;
@property (nonatomic,strong) NSString *prdID;
@property (nonatomic) NSInteger btnTag;
@property (nonatomic) NSInteger labelTag;
@property (nonatomic) NSInteger bImgSend;
@property (nonatomic,strong)NSMutableDictionary *goodsInfoDict;
//@property (nonatomic) NSInteger starNum[4];

@property (nonatomic, retain) IBOutlet UILabel *restrictByteLabel;

@property (nonatomic, strong) WSAssetPickerController *pickerController;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (weak, nonatomic) IBOutlet UIView *topHeaderView;


- (id)initWithPrdid:(id)sender prdids:(NSString *)prdid;
- (void)loadingDataSet;

- (IBAction)GoBack;
- (IBAction)GoBackNGoDetailURL;
- (IBAction)descTextViewendEditing:(id)sender;
//- (void)startDataLoading;
- (void)pictureViewUI;
- (void)upLoadImageShow;
- (NSString *) applicationCacheDirectory ;
- (void)starDisplayUI;

- (void)pictureBtnAction:(id)sender;

- (void)confirm1:(id)sender;


-(IBAction)detailViewSwitch:(id)sender;

-(void)closeCameraorAlbumModal;
// 20140116 Youngmin Jin unit test를 위해 선언 -Start
- (IBAction)btnAction:(id)sender;
// 20140116 Youngmin Jin unit test를 위해 선언 -End

//double avPixel(double x, double y, double z); 컴파일 애러로 잠시 주석


-(IBAction)onBtnAddPhoto:(id)sender;
-(IBAction)onBtnRemovePhoto:(id)sender;


@end
