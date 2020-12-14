//
//  SectionFPCHeaderView.h
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 4..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  FPC 셀이 존재할경우 테이블뷰 최상단에 플로팅 형식으로 붙히는 뷰 ,"지금BEST" 매장 런칭시 최초 도입

#import <UIKit/UIKit.h>
#import "SectionFPCtypeSubview.h"

@interface SectionFPCHeaderView : UIView

@property (nonatomic, weak) id target;
@property (strong, nonatomic) IBOutlet UIImageView *imgCrown;           //왕관 이미지

@property (strong, nonatomic) IBOutlet UILabel *label_catetitle;        //카테고리 라벨

@property (strong, nonatomic) IBOutlet UIImageView *img_cate_arrow;     //오른쪽 끝 화살표


@property (strong, nonatomic) IBOutlet UIButton *btn_catename;          //카테고리 버튼

@property (nonatomic,strong) IBOutlet UIView *viewAlpha;                //플로팅중 약간의 투명처리를 위한 뷰

-(IBAction)clickBtn:(id)sender;
-(void)catevClose;
-(void)categorychoiceWithName:(NSString*)catename showCrown:(BOOL)isShow;
-(void)FPC_SCategorychoiceWithName:(NSString*)catename showCrown:(BOOL)isShow;
@end
