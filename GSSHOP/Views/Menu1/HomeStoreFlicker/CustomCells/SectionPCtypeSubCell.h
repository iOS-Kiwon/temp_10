//
//  SectionPCtypeSubCell.h
//  GSSHOP
//
//  Created by gsshop iOS on 2018. 4. 19..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SectionPCtypeSubCellIdentifier = @"SectionPCtypeSubCell";

@interface SectionPCtypeSubCell : UITableViewCell
@property (nonatomic,weak) id delegate;

@property (nonatomic,strong) IBOutlet UIView *viewProgram;
@property (nonatomic,strong) IBOutlet UIImageView *imgProgram;                  //프로그램 이미지
@property (nonatomic,strong) IBOutlet UIImageView *imgLive;                     //프로그램 라이브 딱지 이미지

@property (nonatomic,strong) IBOutlet UILabel *lblProgramTime;                  //프로그램 방송시간
@property (nonatomic,strong) IBOutlet UILabel *lblProgramTitle;                 //프로그램 타이틀
@property (nonatomic,strong) IBOutlet UIButton *btnProgram;                     //프로그램 버튼
@property (nonatomic,strong) NSIndexPath *myPath;                               //상위 셀로 전달할 현재 셀의 IndexPath
@property (nonatomic,strong) NSString *imageURL;


-(void)setCellInfoNDrawData:(NSDictionary*)rowInfodic andIndexPath:(NSIndexPath *)path;     //셀 더이터 셋팅
-(IBAction)onBtnProgram;

@end
