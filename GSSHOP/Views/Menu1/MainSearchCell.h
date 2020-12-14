//
//  MainSearchCell.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 12..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  앱 메인 검색창에 들어가는 셀

#import <UIKit/UIKit.h>
#import <MOCHA/TTTAttributedLabel.h>

typedef enum  {
    MainSearchModeRecent, //최근검색어
    MainSearchModePopular, //인기검색어
    MainSearchModeAuto, //자동완성
    recommendedRelatedSearch, //추천연관검색어
} MainSearchCellType;

//검색타입에 따라 보여줄 뷰를 결정

@interface MainSearchCell : UITableViewCell {
    IBOutlet UIView *viewRecent;                //최근검색어
    IBOutlet UIView *viewPopular;               //인기검색어
    IBOutlet UIView *viewAuto;                  //자동완성
    IBOutlet UIView *viewCate;                  //카테고리
    
    
    IBOutlet UILabel *lblPopularLeft;           //인기검색어 왼쪽
    IBOutlet UILabel *lblPopularNumberLeft;     //인기검색어 왼쪽 순위 숫자
    IBOutlet UILabel *lblPopularRight;          //인기검색어 오른쪽
    IBOutlet UILabel *lblPopularNumberRight;    //인기검색어 오른쪽 순위 숫자
    
    IBOutlet UILabel *lblAutoHighlightLeft;  //해당검색어 하이라이트용
    IBOutlet UILabel *lblAutoWordLeft;          //검색결과 자동완성 왼쪽 정렬
    IBOutlet UILabel *lblAutoHighlightRight;    //검색결과 자동완성 오른쪽 하이라이트
    IBOutlet UILabel *lblAutoWordRight;         //검색결과 자동완성 오른쪽

    IBOutlet UILabel *lblCateBig;               //대 카테고리
    IBOutlet UILabel *lblCateArrow;             //카테고리 화살표
    IBOutlet UILabel *lblCateSmall;             //소 카테고리
    
    IBOutlet UILabel *lblCateSearchWord;        //카테고리 검색어
    IBOutlet UIImageView *imgArrow;        //우측 화살표
    
    IBOutlet UIButton *btnPopularLeft;          //인기검색어 왼쪽 버튼
    IBOutlet UIButton *btnPopularRight;         //인기검색어 오른쪽 버튼
    IBOutlet UIButton *btnAuto;                 //검색결과 자동완성 버튼
    
    
    IBOutlet UIButton *LbtnRecentWord;           //최근검색어 버튼
    IBOutlet UIButton *LbtnRecentWordDelete;     //최근검색어 삭제 버튼
    IBOutlet UILabel *LlblRecentWord;            //최근검색어    
    IBOutlet UIButton *btnCategory;             //카테고리
    
    NSArray *arrRow;
    
    
    
}
@property (nonatomic, weak) id target;
@property (nonatomic, assign) MainSearchCellType cellType;
@property (nonatomic, strong) IBOutlet UIView *viewBottomLine;
-(void) setCellInfoNDrawData:(NSArray*)rowinfoArr type:(MainSearchCellType)tableType indexPath:(NSIndexPath*)path searchWord:(NSString *)strWord;

-(IBAction)onBtnSelectWord:(id)sender;
-(IBAction)onBtnWordDelete:(id)sender;
@end
