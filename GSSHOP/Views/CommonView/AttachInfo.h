//
//  AttachInfo.h
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 12. 22..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLParser.h"


@interface AttachInfo : NSObject {
    
}

@property (nonatomic,strong)URLParser *urlreqparser;
@property (nonatomic,strong)NSString *contentstr;
@property (nonatomic,strong)NSMutableArray *arruploadimg;
@property (nonatomic,strong)NSString *errorCode;
@property (nonatomic,strong)NSString *errorMsg;

@end
