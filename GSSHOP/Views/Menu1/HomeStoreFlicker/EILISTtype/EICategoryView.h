//
//  EICategoryView.h
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 26..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//  이벤트 탭에 헤더 부분에 사용되는 카테고리 뷰 서버에서 내려오느값 받아서 그림 ex[이벤트홈|핫이슈|혜택|TV존]

#import <UIKit/UIKit.h>

@interface EICategoryView : UIView {
    IBOutlet UIView *viewBG;
}

@property (nonatomic, weak) id target;
@property (nonatomic, strong) MochaNetworkOperation* imageLoadingOperation;



-(void)setCateIndex:(NSInteger)indexCategory;
-(void) setCellInfoNDrawData:(NSArray*)arrCate seletedIndex:(NSInteger)index;

@end
