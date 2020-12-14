//
//  NTCBroadCastHeaderView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 2..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  날방 생방송 영역

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <MOCHA/TTTAttributedLabel.h>

@interface NTCBroadCastHeaderView : UIView <iCarouselDelegate,iCarouselDataSource>{
    
    NSMutableArray *arrNalTalk;             //날톡 리스트 배열
    NSTimer *scrollTimer;                   //날톡 자동 스크롤 타이머
}

@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;
@property (nonatomic,strong) id target;
@property (nonatomic,strong) IBOutlet UIView *viewDefault;                  //생방송 영역 베이스뷰
@property (nonatomic,strong) IBOutlet UIView *viewTop;                      //생방송 영역 상단뷰 , 공지사항, 생방송 바로보기 버튼 영역
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcViewTopHeight; //생방송 영역 상단뷰 높이값 autolayout 에서 조절하기위해 필요함

@property (nonatomic,strong) IBOutlet UIView *viewTopIconText;              //상단뷰 아이콘과 텍스트가 같이 노출될 뷰
@property (nonatomic,strong) IBOutlet TTTAttributedLabel *lblStatus;        //상단뷰 아이콘과 텍스트가 같이 노출될 , 라벨
@property (nonatomic,strong) IBOutlet UIView *viewTopLiveGoBtn;             //상단뷰 생방송 바로보기 버튼영역

@property (nonatomic,strong) IBOutlet UIView *viewImgArea;                  //중단 이미지 영역
@property (nonatomic,strong) IBOutlet UIView *viewImgAreaOnAir;             //생방송일경우 남은시간을 보여줄 BG 이미지
@property (nonatomic,strong) IBOutlet UIImageView *imgProduct;              //방송 대표 이미지
@property (nonatomic,strong) IBOutlet UILabel *lblLiveTime;                 //생방송일경우 남은시간 라벨
@property (nonatomic,strong) IBOutlet UIView *viewImgAreaVodTime;           //VOD 일경우 재생시간 표시뷰
@property (nonatomic,strong) IBOutlet UILabel *lblVodTime;                  //VOD 일경우 재생시간 표시 라벨

@property (nonatomic,strong) IBOutlet UIView *viewNalTalk;                  //하단 날톡뷰 , 날톡이 존재할때만 노출
@property (nonatomic,strong) IBOutlet iCarousel *carouselNalTalk;           //하단 날톡뷰 카루셀 , 날톡이 존재할때만 노출
@property (nonatomic,strong) IBOutlet UIView *viewProductDesc;              //하단 상품 상세뷰 , 상품정보가 있을때만 노출

@property (nonatomic,strong) IBOutlet UIView *viewProductDescVNP;           //하단 상품 설명뷰 , 상품정보가 제목만 있을경우 노출
@property (nonatomic, strong) IBOutlet UILabel *productTitleLabelVNP;       //하단 상품 설명뷰 , 상품정보가 제목 라벨


@property (nonatomic, strong) IBOutlet UILabel *dummytagTF1;                //상품 특수설명 색갈값과 텍스트 ex) [롯데백화점]

@property (nonatomic, strong) IBOutlet UIView *soldoutView;                 //매진 일경우 표시
@property (nonatomic, strong) IBOutlet UIImageView *soldoutimgView;         //매진 일경우 표시 이미지뷰


@property (nonatomic, strong) IBOutlet UILabel *productTitleLabel;          //상품 이름


@property (nonatomic, strong) IBOutlet UILabel *discountRateLabel;          //할인율 라벨
@property (nonatomic, strong) IBOutlet UILabel *discountRatePercentLabel;   //할인율 옆 %라벨

@property (nonatomic, strong) IBOutlet UIView *gsLabelView;                 //특가 뷰 , 위 라벨과 조건비교

@property (nonatomic, strong) IBOutlet UILabel *extLabel;                   //특가 GS가 라벨 , 위 라벨과 조건비교

@property (nonatomic, strong) IBOutlet UILabel *gsPriceLabel;               //GS 가격
@property (nonatomic, strong) IBOutlet UILabel *gsPriceWonLabel;            //GS 가격 의 원

@property (nonatomic, strong) IBOutlet UILabel *originalPriceLabel;         //원래 가격
@property (nonatomic, strong) IBOutlet UILabel *originalPriceWonLabel;      //원래 가격의 원
@property (nonatomic, strong) IBOutlet UIView *originalPriceLine;           //원래 가격에 그어지는 라인

@property (nonatomic, strong) IBOutlet UILabel *saleCountLabel;             //구매수 , 판매수
@property (nonatomic, strong) IBOutlet UILabel *saleSaleLabel;              //개
@property (nonatomic, strong) IBOutlet UILabel *saleSaleSubLabel;           //구매중 , 판매수

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *salesalelabel_width; //autolayout 용 판매수 넓이

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *originalPricelabel_lmargin; //autolayout 용 원래가격 왼쪽 마진

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *originalPricelabel_rmargin; //autolayout 용 원래가격 오른쪽 마진

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *valueinfolabel_lmargin; //autolayout 용 벨류인포 왼쪽 마진
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *producttitlelabel_lmargin; //autolayout 용 상품이름 왼쪽 마진
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *gspricelabel_lmargin; //autolayout 용 GS가 왼쪽 마진

@property (nonatomic, strong) IBOutlet UILabel *valuetextLabel;
@property (nonatomic, strong) IBOutlet UILabel *valueinfoLabel;

@property (nonatomic, strong) IBOutlet UIImageView *dummytagVT1;
@property (nonatomic, strong) IBOutlet UIImageView *dummytagVT2;

@property (nonatomic, strong) NSDictionary *dicRow;
@property (nonatomic, strong) NSDictionary *dicProduct;

-(void)showViewTop:(BOOL)isShow;
-(void)setCellInfoNDrawData:(NSDictionary*)infoDic;
-(void)setTextWithNextBoardTime:(NSString *)strTimeString;

//날방 영역별 링크
-(IBAction)onBtnNalBangImage:(id)sender;
-(IBAction)onBtnNalTalk:(id)sender;
-(IBAction)onBtnProductDesc:(id)sender;
@end
