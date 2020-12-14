//
//  NTCListTBViewController.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 6. 3..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  날방 테이블뷰 컨트롤러

#import "SectionTBViewController.h"
#define NALBANNERHEIGHT 58.0f

@class NTCBroadCastHeaderView;

@interface NTCListTBViewController : SectionTBViewController{
    NSMutableArray *arrHashFilter;          //날방 해쉬테그 영역 빠른 검색을위해 저장
    
    NSDateFormatter* dateformat;            //날방 시간체크를위한 포맷터
    BOOL isOnAir;                           //생방인지 VOD 인지 여부
    NSTimer *timer;
    BOOL isTimer;
}
@property (nonatomic,weak) id sectionView;
@property (strong, nonatomic) NTCBroadCastHeaderView *nalHeaderView;        //헤더뷰에 붙는 생방송 영역
@property (nonatomic, strong) UIView *tvhview;                              //헤더뷰 영역

//해쉬테그 선택 , 관리자 테그와, 일반테그 같이 사용 소스내 분기
-(void)onBtnHFTag:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
-(void)removeSectionTimer;
@end
