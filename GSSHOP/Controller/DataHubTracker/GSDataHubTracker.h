//
//  GSDataHubTracker.h
//  GSSHOP
//
//  Created by gsshop on 2015. 6. 15..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSDataHubTracker : NSObject

@property (strong, nonatomic) NSString* DHmediaType;


+ (GSDataHubTracker *)sharedInstance;
- (id)init;
//20150930
- (void)NeoCallGTMWithReqURL:(NSString*)arg1 str2:(NSString*)arg2 str3:(NSString*)arg3;
-(NSString*)itspcid;
-(NSString*)itscatvid;
-(NSString*)itsmediatype;
-(NSString*)itscustclass;
@end
