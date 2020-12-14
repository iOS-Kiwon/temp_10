//
//  SectionHomeFnSView.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 18..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//  (오늘오픈)FCLIST 필터컨텐츠 리스트 전용
//  SectionView 단에서 테이블뷰 위로 플로팅 시키기 위한 뷰

#import <UIKit/UIKit.h>

@interface SectionHomeFnSView  : UIView {
    
    
    
    
}

@property (nonatomic, weak) id target;                                          //클릭시 이벤트를 보낼 타겟
@property (strong, nonatomic) IBOutlet UILabel *label_catetitle;                //카테고리 타이틀 라벨 ex)전체,의류/잡화,뷰티/보석

@property (strong, nonatomic) IBOutlet UIImageView *img_cate_arrow;             //카테고리 타이틀 라벨 옆 상하 화살표 이미지,하이라이트시 반전


@property (strong, nonatomic) IBOutlet UIButton *btn_catename;                  //카테고리 변경 버튼


- (id)initWithTarget:(id)sender;                                                //초기화
-(IBAction)clickBtn:(id)sender;                                                 //버튼 클릭
-(void)catevClose;                                                                  //닫기 버튼 , 닫기 기능
-(void)categorychoiceWithName:(NSString*)catename withCount:(NSString*)catecount;   //카테고리 선택 기능
@end
