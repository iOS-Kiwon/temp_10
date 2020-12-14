//
//  MainSearchView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 12..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  앱 메인 검색창 , 엡델리게이트에서 alloc 후 앱 전체에서 필요할떄마다 show & hide

#import <UIKit/UIKit.h>
#import "MainSearchCell.h"

#define BTN_RECENT_TAG 4000 //최근검색어
#define BTN_POPUALR_TAG 4001 //인기검색어

@interface MainSearchView : UIView <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    //IBOutlet UIView *viewDimm;                  //배경 딤뷰
    IBOutlet UIView *viewTextFieldArea;         //상단 검색어 입력하는 뷰 영역
    IBOutlet UIView *viewTabArea;               //최근검색어, 인기검색어 버튼 둘이 노출되는 영역

    
    IBOutlet UIButton *btnClearAll;             //텍스트 필드 안쪽 검색어 삭제 X 버튼
    
    IBOutlet UIButton *btnLeft,*btnRight,*btnClose,*btnDeleteAll;  //최근검색어,인기검색어,닫기,모두삭제 버튼들
    
    IBOutlet UILabel *lblNoSearchWord;          //검색결과가 없습니다 라벨
    
    IBOutlet UITextField *tfSearch;             //검색어 필드
    IBOutlet UIView *viewGreenLine;             //최근검색어,인기검색어 하단 녹색 라인
    IBOutlet UIView *viewSearchWordDelete;      //검색어 모두삭제가 노출될 뷰 영역
    
    IBOutlet UIView *viewRecommend;             //추천검색어 말풍선 영역
    
    NSMutableArray *arrSearch,*arrAuto;      //검색어 , 자동완성
    
    NSUInteger intBeforeTag;            
    NSMutableString *strABTest;
    
    //NSInteger statusBarStatus;
    CGFloat iphoneX_TopMargin; //아이폰X용 뷰 크기 조절
    
    CGFloat rrc_H; // 추천연관검색어 뷰 노출값
}
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSURLSessionDataTask* currentOperation;
@property (nonatomic, assign) MainSearchCellType searchType;
@property (nonatomic, strong) IBOutlet UIView *viewTableViewArea;         //테이블뷰가 노출되는 영역

@property (nonatomic, strong) IBOutlet UITableView *tbvSearch;      //검색어 리스트 테이블뷰 최근,인기 같이씀
@property (weak, nonatomic) IBOutlet UILabel *noAutoMaker;          //해당 검색어의 자동완성어가 없습니다.
@property (weak, nonatomic) IBOutlet UIButton *btnImageSearch;          //이미지검색 버튼
@property (weak, nonatomic) IBOutlet UIView *noAutoView;

@property (weak, nonatomic) IBOutlet UIView *recommendedRelatedSearchList;
@property (weak, nonatomic) IBOutlet UICollectionView *rrSList;

//검색어 선택시 BOLD 처리해줘야함 @property (nonatomic, assign) iScrollType type;
- (void)initWithDelegate:(id)sender Nframe:(CGRect)tframe;


-(IBAction)onBtnTextFieldClear:(id)sender;          //검색중인 텍스트 필드 삭제
-(IBAction)onBtnClose:(id)sender;                   //닫기
-(IBAction)onBtnSearchWordDelete:(id)sender;        //검색어 리스트중 해당 검색어 삭제

- (void)closeWithAnimated:(BOOL)animated;           //검색창 닫기
- (void)openWithAnimated:(BOOL)animated;            //검색창 열기
- (void)openWithAnimated:(BOOL)animated showRelated:(BOOL)show; //2020 검색창 열기 연관검색어 포함

-(void)goWebViewWithSearchWord:(NSString *)strWord direct:(BOOL)isDirect;       //해당 검색어로 왭뷰에 결과표시
-(void)goWebViewWithSearchWordOnlyRecommended:(NSString *)strWord isHome:(BOOL)ishome;                      //추천연관검색어 전용 결과표시
-(void)goWebViewWithCateUrl:(NSString *)strURL;                                 //카테고리값으로 왭뷰에 결과표시
-(void)delRecentWord:(NSString *)strWord;                                       //최근검색어 삭제
- (IBAction)onBtnOpenTooltip:(UIButton *)sender;
- (IBAction)onBtnCloseTooltip:(UIButton *)sender;

@end
