//
//  NSTFCListTBViewController.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#define kDefaultNalBangContentsCount 3              //날방이 상단에 위치할경우 표시할 날방 셀의 수 , 더보기 버튼 출현
#define kDefaultShortBangContentsCount 2            //숏방이 상단에 위치할경우 표시할 숏방 셀의 수 , 더보기 버튼 출현
#define kDefaultShortBangContentsPerRow 3           //숏방의경우 한셀에 들어갈 컨텐츠의 수
#define kTableViewMoreCountShortBang 3                      //더보기시 추가될 셀의 갯수 , CELL 의 갯수임 숏방용
#define kTableViewMoreCountNalBang 10                      //더보기시 추가될 셀의 갯수 , CELL 의 갯수임 날방용


#import "SectionTBViewController.h"

@interface NSTFCListTBViewController :  SectionTBViewController {
    NSMutableArray *arrHashFilter;          //날방 해쉬테그 영역 빠른 검색을위해 저장
    NSDateFormatter* dateformat;            //날방 시간체크를위한 포맷터
    BOOL isOnAir;
    
    NSMutableArray *arrNSTFC;
    
    NSTimer *timer;
    BOOL isTimer;
    
    //NSInteger idxHF;                                // HF 셀 인덱스 indexPath.row
    NSIndexPath *indexPathHFCell;
    
    
//    NSInteger idxHFCate;                            // HF 셀 선택된 카테고리 인덱스
//    CGRect rectHFCell;                              // HF 셀 CGRect값 , 해쉬테그를 클릭할경우 테이블 뷰의 스크롤 포지션이동을 위해 저장
//    NSMutableDictionary *dicHFResult;               // HF 셀 아래 선택된 헤쉬테그와 , 검색된 갯수 저장
    
    
    
    NSMutableArray *arrAllShortBang;
    NSIndexPath *indexPathSCFCell;
    NSInteger idxSCFCate;

    //CGRect rectSCFCell;                              // SCF 셀 CGRect값 , 해쉬테그를 클릭할경우 테이블 뷰의 스크롤 포지션이동을 위해 저장
    
    
    NSIndexPath *indexPathNalbangHeader;
    NSIndexPath *indexPathShortbangTop;
    
    
    
    
}

@property (strong, nonatomic) NTCBroadCastHeaderView *nalHeaderView;
@property (nonatomic,weak) id sectionView;
@property (nonatomic, strong) UIView *tvhview;                              //헤더뷰 영역

-(void)touchEventTBCellJustLinkStr:(NSString *)linkstr;
-(void)touchEventSBTCell:(NSDictionary*)dic andCnum:(NSNumber *)prdIndex andCImage:(UIImage*)prdImage indexPathCell:(NSIndexPath *)indexPathCell withCallType:(NSString*)cstr;

-(void)scrollToShortBangSectionTop;

-(void)tableViewSectionloadMoreButton:(NSInteger)section;

//해쉬테그 선택 , 관리자 테그와, 일반테그 같이 사용 소스내 분기
-(void)onBtnHFTag:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
-(void)onBtnSCFTag:(NSDictionary *)dic andCnum:(NSNumber*)cnum withCallType:(NSString*)cstr;
-(void)removeSectionTimer;
@end
