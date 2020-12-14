//
//  ViewMotherRequest.h
//  GSSHOP
//
//  Created by gsshop iOS on 2019. 1. 15..
//  Copyright © 2019년 GS홈쇼핑. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewMotherRequest : UIView

@property (nonatomic,strong) NSDictionary *dicMR;

-(void)showPopupWithDic:(NSDictionary *)dic;
@end
