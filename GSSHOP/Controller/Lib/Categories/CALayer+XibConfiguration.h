//
//  CALayer+XibConfiguration.h
//  GSSHOP
//
//  Created by gsshop on 2015. 3. 13..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer(XibConfiguration)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end