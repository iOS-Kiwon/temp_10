//
//  Mocha_Alert.m
//  Mocha_Alert
//
//  Created by Hoecheon Kim on 12. 5. 31..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//


#import "Mocha_Alert.h"
#import "Mocha_Define.h"
#import "GSButton.h"


#import <QuartzCore/CALayer.h>
#import <QuartzCore/QuartzCore.h>

#define Mocha_UIViewAnimationDuration 0.5









@implementation Mocha_Alert

@synthesize alertview, iv_background, adelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isrotateview = NO;
    }
    return self;
}

- (UIView *)initWithView:(NSString *)title message:(UIView *)messageView delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle{
    self = [super init];
    
    _title = title;
    _messageView = messageView;
    adelegate = delegate;
    _buttonTitle = buttonTitle;
    isrotateview = NO;
    
    
    
    
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    
    iv_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)];
    // NSString* path = [NSString stringWithFormat:@"%@/Mocha.framework/Resources/blind01.png", [[NSBundle mainBundle] bundlePath]];
    //아래참조
    //UIImage* closeImage = [UIImage imageNamed:@"FBDialog.bundle/images/close.png"];
    iv_background.image = [UIImage imageNamed:@"MochaResources.bundle/blind01.png"];
    
    
    [self addSubview:iv_background];
    
    CGSize size = [_title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(270, 30000) lineBreakMode:NSLineBreakByWordWrapping];
    
    alertview = [[UIView alloc] initWithFrame:CGRectMake((APPFULLWIDTH/2)-148, (APPFULLHEIGHT - (70+_messageView.frame.size.height+size.height))/2, 296, 75+_messageView.frame.size.height+size.height)];
    [self addSubview:alertview];
    UIImageView *iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 75+_messageView.frame.size.height+size.height)];
    iv_alertview.image = [[UIImage imageNamed:@"MochaResources.bundle/popup01.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0f];
    [alertview addSubview:iv_alertview];
    
    
    if(![_title isEqualToString:@""]){
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, 17, 270, size.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _title;
        lb_title.textColor = [Mocha_Util getColor:@"454545"];
        lb_title.font = [UIFont systemFontOfSize:14.0f];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
    }
    
    if(_messageView == nil){
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    else{
        _messageView.frame = CGRectMake(13, 20 + size.height, 270, _messageView.frame.size.height);
        [alertview addSubview:_messageView];
    }
    
    for(int i = 0; i < [_buttonTitle count];i++){
        if([_buttonTitle count] < 2){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(101.5, 30+_messageView.frame.size.height + size.height, 93, 28)];
            [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            button.titleLabel.textColor = [Mocha_Util getColor:@"454545"];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
        }
        else if ([_buttonTitle count] == 2){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60 + (i*107), 30+_messageView.frame.size.height + size.height, 93, 28)];
            if([[_buttonTitle objectAtIndex:i] isEqualToString:@"취소"]){
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            button.titleLabel.textColor = [Mocha_Util getColor:@"454545"];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
        }
        else if ([_buttonTitle count] == 3){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5 + (i*97), 35+_messageView.frame.size.height + size.height, 93, 28)];
            if([[_buttonTitle objectAtIndex:i] isEqualToString:@"취소"]){
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            button.titleLabel.textColor = [Mocha_Util getColor:@"454545"];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
        }
        
    }
    
    
    
    
    
    
    
	// 팝업 애니메이션
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	
	animation.duration = Mocha_UIViewAnimationDuration/2;
	animation.values = [NSArray arrayWithObjects:
						[NSNumber numberWithFloat:0.1],
						[NSNumber numberWithFloat:1.2],
						[NSNumber numberWithFloat:0.9],
						[NSNumber numberWithFloat:1.0],
						nil];
	animation.keyTimes = [NSArray arrayWithObjects:
						  [NSNumber numberWithFloat:0.0],
						  [NSNumber numberWithFloat:0.5],
						  [NSNumber numberWithFloat:0.75],
						  [NSNumber numberWithFloat:1.0],
						  nil];
	
	[alertview.layer addAnimation:animation forKey:@"scaleAnimation"];
	
    //
    [alertview.layer setCornerRadius:5.0f];
    [alertview.layer setShadowRadius:5.0f];
    [alertview setClipsToBounds:YES];
    
    
    return self;
}





void RetinaAwareUIGraphicsBeginImageContext(CGSize size) {
    static CGFloat scale = -1.0;
    if (scale<0.0) {
        UIScreen *screen = [UIScreen mainScreen];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            if( [screen respondsToSelector:@selector(scale)] ){
                scale = [screen scale] ;
            }else {
                scale = 1.0;
            }
        }
        else {
            scale = 0.0; // mean use old api
        }
    }
    if (scale>0.0) {
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    }
    else {
        UIGraphicsBeginImageContext(size);
    }
}
void drawPxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, float linewidth)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetShouldAntialias(context, (linewidth>0.5f)?YES:NO);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, linewidth);
    CGContextMoveToPoint(context, startPoint.x  , startPoint.y  );
    CGContextAddLineToPoint(context, endPoint.x  , endPoint.y  );
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}




- (UIView *)initWithTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle{
    
    self = [super init];
    //if (self){
    _title = title;
    _maintitle = mtitle;
    adelegate = delegate;
    _buttonTitle = buttonTitle;
    // iv_background = iv_background;
    // alertview = alertview;
    isrotateview = NO;
    //}
    int kMainTitleHeight =0;
    if(mtitle !=nil) {
        kMainTitleHeight = 40;
    }
    
    //font
    const int kVwidth = 270;
    const int kFontwidth = 240;
    
    CGSize maintsize = CGSizeMake(0, 0);
    if(mtitle !=nil) {
        maintsize = [_maintitle sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)  lineBreakMode:NSLineBreakByWordWrapping];
    }
    CGSize titlesize = [_title sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)   lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    int kMsgTopMarginHeight = 30;
    int kMsgBottomMarginHeight = 30;
    const int kButtonHeight = 40;
    
    if(mtitle ==nil && titlesize.height < 55){
        kMsgTopMarginHeight =45;
        kMsgBottomMarginHeight =45;
    }
    
    int kmsgViewFullheight = 0;
    if(mtitle != nil){
        kmsgViewFullheight = kMainTitleHeight+kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }else {
        kmsgViewFullheight = kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    iv_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)];
    // NSString* path = [NSString stringWithFormat:@"%@/Mocha.framework/Resources/blind01.png", [[NSBundle mainBundle] bundlePath]];
    //iv_background.image = [UIImage imageNamed:@"MochaResources.bundle/blind01.png"];
    
    
    
    
    
    [iv_background.layer setMasksToBounds:NO];
    iv_background.layer.shadowColor = [UIColor blackColor].CGColor;
    iv_background.layer.shadowOpacity = 0.6;
    iv_background.layer.shadowOffset = CGSizeMake(0, 0);
    iv_background.layer.shadowRadius = 0.0;
    iv_background.layer.shadowPath = [UIBezierPath bezierPathWithRect:iv_background.bounds].CGPath;
    [self addSubview:iv_background];
    
    
    
    
    if(mtitle != nil) {
        alertview = [[UIView alloc] initWithFrame:CGRectMake( (APPFULLWIDTH - kVwidth)/2 , (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }else {
        alertview = [[UIView alloc] initWithFrame:CGRectMake((APPFULLWIDTH - kVwidth)/2, (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }
    
    [self addSubview:alertview];
    
    
    
    
    
    
    
    
    UIImageView *iv_alertview = nil;
    
    if(mtitle != nil) {
        iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth,  kmsgViewFullheight)];
        // iv_alertview.image = [[UIImage imageNamed:@"MochaResources.bundle/popup02.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0f];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    } else {
        iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth, kmsgViewFullheight)];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    }
    
    RetinaAwareUIGraphicsBeginImageContext(iv_alertview.frame.size);
    //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
    
    //1CADBB
    if(mtitle !=nil) {
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, kFontwidth, maintsize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _maintitle;
        lb_title.textColor = [Mocha_Util getColor:@"000000"];
        lb_title.font = [UIFont boldSystemFontOfSize:17];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
        
        
        CGPoint startPoint = CGPointMake( 0, kMainTitleHeight);
        CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, kMainTitleHeight);
        drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"1CADBB"].CGColor, 1.0f);
        
        
    }
    
    if(![_title isEqualToString:@""]){
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, (mtitle != nil)?kMainTitleHeight+kMsgTopMarginHeight:kMsgTopMarginHeight, kFontwidth, titlesize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _title;
        lb_title.textColor = [Mocha_Util getColor:@"111111"];
        lb_title.font = [UIFont systemFontOfSize:15.0f];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
    }
    
    
    
    for(int i = 0; i < [_buttonTitle count];i++){
        if([_buttonTitle count] < 2){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake(0, kmsgViewFullheight-kButtonHeight, kVwidth, kButtonHeight)];
            
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            
            button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            //   UIColor * lightGrayColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
            
            //  UIGraphicsBeginImageContext(iv_alertview.frame.size);
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
        }
        else if ([_buttonTitle count] == 2){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake((i*(kVwidth/2)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/2)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            
            if(i == 0 ){
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            }else{
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            }
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/2, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
        }
        else if ([_buttonTitle count] == 3){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake((i*(kVwidth/3)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/3)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            if(i == 2 ){
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            }else{
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                
            }
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            
            
            //            UIGraphicsBeginImageContext(iv_alertview.frame.size);
            
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/3, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/3, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
            CGPoint startPoint3 = CGPointMake( (iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height);
            CGPoint endPoint3 = CGPointMake((iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint3, endPoint3, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
        }
        
    }
    
    
    
    
    
    
    iv_alertview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 팝업 애니메이션
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = Mocha_UIViewAnimationDuration/2;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.1],
                        [NSNumber numberWithFloat:1.2],
                        [NSNumber numberWithFloat:0.9],
                        [NSNumber numberWithFloat:1.0],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:0.75],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    [alertview.layer addAnimation:animation forKey:@"scaleAnimation"];
    
    // nami0342 - corner round
    [alertview.layer setCornerRadius: 5.0f];
    [alertview.layer setShadowRadius: 5.0f];
    [alertview setClipsToBounds:YES];
    
    return self;
}



//////////////////////////////////////////
// nami0342
- (UIView *)initWithTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle changeFont:(UIFont*) changeFont changeColor:(UIColor*) changeColor changeMessage:(NSString *) strChageMessage
{
    self = [super init];
    //if (self){
    _title = title;
    _maintitle = mtitle;
    adelegate = delegate;
    _buttonTitle = buttonTitle;
    isrotateview = NO;
    //}
    int kMainTitleHeight =0;
    if(mtitle !=nil) {
        kMainTitleHeight = 40;
    }
    
    //font
    const int kVwidth = 270;
    const int kFontwidth = 240;
    
    CGSize maintsize = CGSizeMake(0, 0);
    if(mtitle !=nil) {
        maintsize = [_maintitle sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)  lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    
    CGSize titlesize;
    
    if(changeFont != nil)
    {
        titlesize = [_title sizeWithFont:changeFont constrainedToSize:CGSizeMake(kFontwidth, 30000)   lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"Change size null : title size : %@", [UIFont systemFontOfSize:15.0f]);
    }
    else
    {
        
        titlesize = [_title sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)   lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"Change size  : title size : %@", titlesize);
    }
    
    int kMsgTopMarginHeight = 30;
    int kMsgBottomMarginHeight = 30;
    const int kButtonHeight = 40;
    
    if(mtitle ==nil && titlesize.height < 55){
        kMsgTopMarginHeight =45;
        kMsgBottomMarginHeight =45;
    }
    
    int kmsgViewFullheight = 0;
    if(mtitle != nil){
        kmsgViewFullheight = kMainTitleHeight+kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }else {
        kmsgViewFullheight = kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    iv_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)];
    
    
    [iv_background.layer setMasksToBounds:NO];
    iv_background.layer.shadowColor = [UIColor blackColor].CGColor;
    iv_background.layer.shadowOpacity = 0.6;
    iv_background.layer.shadowOffset = CGSizeMake(0, 0);
    iv_background.layer.shadowRadius = 0.0;
    iv_background.layer.shadowPath = [UIBezierPath bezierPathWithRect:iv_background.bounds].CGPath;
    [self addSubview:iv_background];
    
    
    
    
    if(mtitle != nil) {
        alertview = [[UIView alloc] initWithFrame:CGRectMake( (APPFULLWIDTH - kVwidth)/2 , (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }else {
        alertview = [[UIView alloc] initWithFrame:CGRectMake((APPFULLWIDTH - kVwidth)/2, (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }
    
    [self addSubview:alertview];
    
    
    
    
    
    UIImageView *iv_alertview = nil;
    
    if(mtitle != nil) {
        iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth,  kmsgViewFullheight)];
        // iv_alertview.image = [[UIImage imageNamed:@"MochaResources.bundle/popup02.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0f];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    } else {
        iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth, kmsgViewFullheight)];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    }
    
    
    
    [iv_alertview.layer setCornerRadius: 5.0f];
    [iv_alertview.layer setShadowRadius: 5.0f];
    
    RetinaAwareUIGraphicsBeginImageContext(iv_alertview.frame.size);
    //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
    
    //1CADBB
    if(mtitle !=nil) {
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, kFontwidth, maintsize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _maintitle;
        lb_title.textColor = [Mocha_Util getColor:@"000000"];
        lb_title.font = [UIFont boldSystemFontOfSize:17];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
        
        
        CGPoint startPoint = CGPointMake( 0, kMainTitleHeight);
        CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, kMainTitleHeight);
        drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"1CADBB"].CGColor, 1.0f);
        
        
    }
    
    if(![_title isEqualToString:@""])
    {
        
        if(strChageMessage != nil && [strChageMessage length] > 0)
        {
            
            TTTAttributedLabel *ttLabel = [[TTTAttributedLabel alloc]  initWithFrame:CGRectMake(0, 0, kVwidth, kmsgViewFullheight-kButtonHeight)];
            [ttLabel setNumberOfLines:0];
            
            [ttLabel setText:_title afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
                
                NSLog(@"**** mutable Attributed String : %@", mutableAttributedString);
                
                NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:strChageMessage options:0 error:nil];
                
                NSArray *arrMatchs = [regexp matchesInString:[mutableAttributedString string] options:0 range:stringRange];
                
                UIFont *highlightFont = [UIFont systemFontOfSize:15.0];
                
                if(changeFont != nil){
                    highlightFont = changeFont;
                }
                
                UIColor *targetColor = [Mocha_Util getColor:@"111111"];
                if(changeColor !=nil){
                    targetColor = changeColor;
                }
                    
                
                CTFontRef hihiFont = CTFontCreateWithName((__bridge CFStringRef)highlightFont.fontName, highlightFont.pointSize,  NULL);
                
                for (NSTextCheckingResult *match in arrMatchs) {
                    
                    NSRange nameRange = match.range;
                    
                    NSLog(@"nameRangenameRange = %@",NSStringFromRange(nameRange));
                    
                    
                    [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:nameRange];
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)hihiFont range:nameRange];
                    
                    [mutableAttributedString addAttribute:(id)kCTForegroundColorAttributeName
                                                    value:(id)targetColor.CGColor
                                                    range:nameRange];
                    
                    
                    [mutableAttributedString replaceCharactersInRange:nameRange withString:[[mutableAttributedString string] substringWithRange:nameRange]];
                }
                
                CFRelease(hihiFont);
                
                
                
                return mutableAttributedString;
                
            }];
            
            ttLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
            ttLabel.backgroundColor = [UIColor clearColor];
            ttLabel.textAlignment = NSTextAlignmentCenter;
            ttLabel.textColor = [Mocha_Util getColor:@"111111"];
            ttLabel.numberOfLines = 0;
            ttLabel.lineBreakMode = NSLineBreakByWordWrapping;
            ttLabel.layer.cornerRadius = 5.0f;
            [alertview addSubview:ttLabel];

        }
        else
        {
        
            UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, (mtitle != nil)?kMainTitleHeight+kMsgTopMarginHeight:kMsgTopMarginHeight, kFontwidth, titlesize.height)];
            lb_title.backgroundColor = [UIColor clearColor];
            lb_title.text = _title;
            lb_title.textColor = [Mocha_Util getColor:@"111111"];
            lb_title.font = [UIFont systemFontOfSize:15.0f];
            lb_title.textAlignment = UITextAlignmentCenter;
            lb_title.numberOfLines = 0;
            lb_title.layer.cornerRadius = 5.0f;
            [alertview addSubview:lb_title];
        }
    }
    
    
    
    for(int i = 0; i < [_buttonTitle count];i++){
        if([_buttonTitle count] < 2){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake(0, kmsgViewFullheight-kButtonHeight, kVwidth, kButtonHeight)];
            
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            
            button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [alertview addSubview:button];
            
            //   UIColor * lightGrayColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
            
            //  UIGraphicsBeginImageContext(iv_alertview.frame.size);
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
        }
        else if ([_buttonTitle count] == 2){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake((i*(kVwidth/2)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/2)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            
            if(i == 0 ){
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            }else{
                button.titleLabel.textColor = [Mocha_Util getColor:@"666666"];
                
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateHighlighted];
            }
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            
            //       UIGraphicsBeginImageContext(iv_alertview.frame.size);
            
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/2, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
            
            
        }
        else if ([_buttonTitle count] == 3){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake((i*(kVwidth/3)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/3)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            if(i == 2 ){
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            }else{
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                
            }
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/3, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/3, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
            CGPoint startPoint3 = CGPointMake( (iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height);
            CGPoint endPoint3 = CGPointMake((iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint3, endPoint3, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
        }
        
    }
    
    
    
    iv_alertview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // 팝업 애니메이션
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = Mocha_UIViewAnimationDuration/2;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.1],
                        [NSNumber numberWithFloat:1.2],
                        [NSNumber numberWithFloat:0.9],
                        [NSNumber numberWithFloat:1.0],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:0.75],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    [alertview.layer addAnimation:animation forKey:@"scaleAnimation"];
    
    
    // nami0342 - corner round
    [alertview.layer setCornerRadius: 5.0f];
    [alertview.layer setShadowRadius: 5.0f];
    [alertview setClipsToBounds:YES];
    
    
    
    return self;
}



// nami0342 - 특정 텍스트들의 폰드와 컬러를 조정
- (UIView *)initWithTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle changeItems:(NSArray *) arChanges
{
    self = [super init];
    //if (self){
    _title = title;
    _maintitle = mtitle;
    adelegate = delegate;
    _buttonTitle = buttonTitle;
    // iv_background = iv_background;
    // alertview = alertview;
    isrotateview = NO;
    //}
    int kMainTitleHeight =0;
    if(mtitle !=nil) {
        kMainTitleHeight = 40;
    }
    
    //font
    const int kVwidth = 270;
    const int kFontwidth = 240;
    
    CGSize maintsize = CGSizeMake(0, 0);
    if(mtitle !=nil) {
        maintsize = [_maintitle sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)  lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    
    CGSize titlesize;
    titlesize = [_title sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)   lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"Change size null : title size : %@", [UIFont systemFontOfSize:15.0f]);

    
    
    
    int kMsgTopMarginHeight = 30;
    int kMsgBottomMarginHeight = 30;
    const int kButtonHeight = 40;
    
    if(mtitle ==nil && titlesize.height < 55){
        kMsgTopMarginHeight =45;
        kMsgBottomMarginHeight =45;
    }
    
    int kmsgViewFullheight = 0;
    if(mtitle != nil){
        kmsgViewFullheight = kMainTitleHeight+kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }else {
        kmsgViewFullheight = kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    iv_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)];
    // NSString* path = [NSString stringWithFormat:@"%@/Mocha.framework/Resources/blind01.png", [[NSBundle mainBundle] bundlePath]];
    //iv_background.image = [UIImage imageNamed:@"MochaResources.bundle/blind01.png"];
    
    
    
    
    
    [iv_background.layer setMasksToBounds:NO];
    iv_background.layer.shadowColor = [UIColor blackColor].CGColor;
    iv_background.layer.shadowOpacity = 0.6;
    iv_background.layer.shadowOffset = CGSizeMake(0, 0);
    iv_background.layer.shadowRadius = 0.0;
    iv_background.layer.shadowPath = [UIBezierPath bezierPathWithRect:iv_background.bounds].CGPath;
    [self addSubview:iv_background];
    
    
    
    
    if(mtitle != nil) {
        alertview = [[UIView alloc] initWithFrame:CGRectMake( (APPFULLWIDTH - kVwidth)/2 , (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }else {
        alertview = [[UIView alloc] initWithFrame:CGRectMake((APPFULLWIDTH - kVwidth)/2, (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }
    
    [self addSubview:alertview];
    
    
    
    
    
    UIImageView *iv_alertview = nil;
    
    if(mtitle != nil) {
        iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth,  kmsgViewFullheight)];
        // iv_alertview.image = [[UIImage imageNamed:@"MochaResources.bundle/popup02.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0f];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    } else {
        iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth, kmsgViewFullheight)];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    }
    
    
    
    [iv_alertview.layer setCornerRadius: 5.0f];
    [iv_alertview.layer setShadowRadius: 5.0f];
    
    RetinaAwareUIGraphicsBeginImageContext(iv_alertview.frame.size);
    //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
    
    //1CADBB
    if(mtitle !=nil) {
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, kFontwidth, maintsize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _maintitle;
        lb_title.textColor = [Mocha_Util getColor:@"000000"];
        lb_title.font = [UIFont boldSystemFontOfSize:17];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
        
        
        CGPoint startPoint = CGPointMake( 0, kMainTitleHeight);
        CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, kMainTitleHeight);
        drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"1CADBB"].CGColor, 1.0f);
        
        
    }
    
    if(![_title isEqualToString:@""])
    {
        
        if(arChanges != nil && [arChanges count] > 0)
        {
            
            TTTAttributedLabel *ttLabel = [[TTTAttributedLabel alloc]  initWithFrame:CGRectMake(0, 0, kVwidth, kmsgViewFullheight-kButtonHeight)];
            [ttLabel setNumberOfLines:0];
            
            [ttLabel setText:_title afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange stringRange = NSMakeRange(0, [mutableAttributedString length]);
                
                NSLog(@"**** mutable Attributed String : %@", mutableAttributedString);
                
                for(NSDictionary *items in arChanges)
                {
                    if([items objectForKey:@"text"] == nil || [[items objectForKey:@"text"] length] == 0)
                    {
                        return mutableAttributedString;
                    }
                    
                    NSRegularExpression *regexp = [[NSRegularExpression alloc] initWithPattern:[items objectForKey:@"text"] options:0 error:nil];
                    
                    NSArray *arrMatchs = [regexp matchesInString:[mutableAttributedString string] options:0 range:stringRange];
                    
                    UIFont *highlightFont = [UIFont systemFontOfSize:15.0];
                    
                    if([items objectForKey:@"font"] != nil && [[items objectForKey:@"font"] isKindOfClass:[UIFont class]] == YES){
                        highlightFont = [items objectForKey:@"font"];
                    }
                    
                    UIColor *targetColor = [Mocha_Util getColor:@"111111"];
                    if([items objectForKey:@"color"] != nil && [[items objectForKey:@"color"] isKindOfClass:[UIColor class]] == YES){
                        targetColor = [items objectForKey:@"color"];
                    }
                    
                    
                    CTFontRef hihiFont = CTFontCreateWithName((__bridge CFStringRef)highlightFont.fontName, highlightFont.pointSize,  NULL);
                    
                    for (NSTextCheckingResult *match in arrMatchs) {
                        
                        NSRange nameRange = match.range;
                        
                        NSLog(@"nameRangenameRange = %@",NSStringFromRange(nameRange));
                        
                        
                        [mutableAttributedString removeAttribute:(NSString *)kCTFontAttributeName range:nameRange];
                        [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)hihiFont range:nameRange];
                        
                        [mutableAttributedString addAttribute:(id)kCTForegroundColorAttributeName
                                                        value:(id)targetColor.CGColor
                                                        range:nameRange];
                        
                        
                        [mutableAttributedString replaceCharactersInRange:nameRange withString:[[mutableAttributedString string] substringWithRange:nameRange]];
                    }
                    
                    CFRelease(hihiFont);
                }
                
                return mutableAttributedString;
                
            }];
            
            
            
            
            ttLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
            ttLabel.backgroundColor = [UIColor clearColor];
            ttLabel.textAlignment = NSTextAlignmentCenter;
            ttLabel.textColor = [Mocha_Util getColor:@"111111"];
            ttLabel.font = [UIFont systemFontOfSize:15.0f];
            ttLabel.numberOfLines = 0;
            ttLabel.lineBreakMode = NSLineBreakByWordWrapping;
            ttLabel.layer.cornerRadius = 5.0f;
            [alertview addSubview:ttLabel];
            
        }
        else
        {
            
            UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, (mtitle != nil)?kMainTitleHeight+kMsgTopMarginHeight:kMsgTopMarginHeight, kFontwidth, titlesize.height)];
            lb_title.backgroundColor = [UIColor clearColor];
            lb_title.text = _title;
            lb_title.textColor = [Mocha_Util getColor:@"111111"];
            lb_title.font = [UIFont systemFontOfSize:15.0f];
            lb_title.textAlignment = UITextAlignmentCenter;
            lb_title.numberOfLines = 0;
            lb_title.layer.cornerRadius = 5.0f;
            [alertview addSubview:lb_title];
        }
    }
    
    
    
    for(int i = 0; i < [_buttonTitle count];i++){
        if([_buttonTitle count] < 2){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake(0, kmsgViewFullheight-kButtonHeight, kVwidth, kButtonHeight)];
            
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            
            button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [alertview addSubview:button];
            
            //   UIColor * lightGrayColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
            
            //  UIGraphicsBeginImageContext(iv_alertview.frame.size);
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
        }
        else if ([_buttonTitle count] == 2){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake((i*(kVwidth/2)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/2)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            
            if(i == 0 ){
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            }else{
                button.titleLabel.textColor = [Mocha_Util getColor:@"666666"];
                
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"666666"] forState:UIControlStateHighlighted];
            }
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            
            //       UIGraphicsBeginImageContext(iv_alertview.frame.size);
            
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/2, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
            
            
        }
        else if ([_buttonTitle count] == 3){
            GSButton *button = [[GSButton alloc] initWithFrame:CGRectMake((i*(kVwidth/3)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/3)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            if(i == 2 ){
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            }else{
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                
            }
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/3, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/3, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
            CGPoint startPoint3 = CGPointMake( (iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height);
            CGPoint endPoint3 = CGPointMake((iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint3, endPoint3, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
        }
        
    }
    
    
    
    iv_alertview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // 팝업 애니메이션
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = Mocha_UIViewAnimationDuration/2;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.1],
                        [NSNumber numberWithFloat:1.2],
                        [NSNumber numberWithFloat:0.9],
                        [NSNumber numberWithFloat:1.0],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.5],
                          [NSNumber numberWithFloat:0.75],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    [alertview.layer addAnimation:animation forKey:@"scaleAnimation"];
    
    
    // nami0342 - corner round
    [alertview.layer setCornerRadius: 5.0f];
    [alertview.layer setShadowRadius: 5.0f];
    [alertview setClipsToBounds:YES];
    
    
    
    return self;
}



//오로지 닫기 기능만추가 닫기 return tag= 1000 예약
- (UIView *)initWithCloseBtn:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate buttonTitle:(NSArray *)buttonTitle{
    
    self = [super init];
    //if (self){
    _title = title;
    _maintitle = mtitle;
    adelegate = delegate;
    _buttonTitle = buttonTitle;
    // iv_background = iv_background;
    // alertview = alertview;
    isrotateview = NO;
    //}
    int kMainTitleHeight =0;
    if(mtitle !=nil) {
       kMainTitleHeight = 40;
    }
    
    //font
    const int kVwidth = 270;
    const int kFontwidth = 240;
    
    CGSize maintsize = CGSizeMake(0, 0);
    if(mtitle !=nil) {
        maintsize = [_maintitle sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)  lineBreakMode:NSLineBreakByWordWrapping];
    }
    CGSize titlesize = [_title sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(kFontwidth, 30000)   lineBreakMode:NSLineBreakByWordWrapping];

    
    
    int kMsgTopMarginHeight = 30;
    int kMsgBottomMarginHeight = 30;
    const int kButtonHeight = 40;
    
    if(mtitle ==nil && titlesize.height < 55){
        kMsgTopMarginHeight =45;
        kMsgBottomMarginHeight =45;
    }
    
    int kmsgViewFullheight = 0;
    if(mtitle != nil){
        kmsgViewFullheight = kMainTitleHeight+kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }else {
        kmsgViewFullheight = kMsgTopMarginHeight+titlesize.height+kMsgBottomMarginHeight+kButtonHeight;
    }
    
     self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
    iv_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT)];
    // NSString* path = [NSString stringWithFormat:@"%@/Mocha.framework/Resources/blind01.png", [[NSBundle mainBundle] bundlePath]];
    //iv_background.image = [UIImage imageNamed:@"MochaResources.bundle/blind01.png"];

    
    
    
    
    [iv_background.layer setMasksToBounds:NO];
    iv_background.layer.shadowColor = [UIColor blackColor].CGColor;
    iv_background.layer.shadowOpacity = 0.6;
    iv_background.layer.shadowOffset = CGSizeMake(0, 0);
    iv_background.layer.shadowRadius = 0.0;
    iv_background.layer.shadowPath = [UIBezierPath bezierPathWithRect:iv_background.bounds].CGPath;
        [self addSubview:iv_background];
    
    
    
    
    if(mtitle != nil) {
        alertview = [[UIView alloc] initWithFrame:CGRectMake( (APPFULLWIDTH - kVwidth)/2 , (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }else {
        alertview = [[UIView alloc] initWithFrame:CGRectMake((APPFULLWIDTH - kVwidth)/2, (APPFULLHEIGHT - kmsgViewFullheight)/2, kVwidth,   kmsgViewFullheight)];
    }
    
    [self addSubview:alertview];
    
    
    
    
    
    
    
    
    UIImageView *iv_alertview = nil;
    
    if(mtitle != nil) {
        iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth,  kmsgViewFullheight)];
        // iv_alertview.image = [[UIImage imageNamed:@"MochaResources.bundle/popup02.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0f];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    } else {
         iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVwidth, kmsgViewFullheight)];
        iv_alertview.backgroundColor = [UIColor whiteColor];
        iv_alertview.contentMode = UIViewContentModeScaleToFill;
        [alertview addSubview:iv_alertview];
    }
    
    RetinaAwareUIGraphicsBeginImageContext(iv_alertview.frame.size);
    //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
    
    //1CADBB
    if(mtitle !=nil) {
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, kFontwidth, maintsize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _maintitle;
        lb_title.textColor = [Mocha_Util getColor:@"000000"];
        lb_title.font = [UIFont boldSystemFontOfSize:17];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
        
        
        CGPoint startPoint = CGPointMake( 0, kMainTitleHeight);
        CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, kMainTitleHeight);
        drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"1CADBB"].CGColor, 1.0f);
        
        
    }
    
    if(![_title isEqualToString:@""]){
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, (mtitle != nil)?kMainTitleHeight+kMsgTopMarginHeight:kMsgTopMarginHeight, kFontwidth, titlesize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _title;
        lb_title.textColor = [Mocha_Util getColor:@"111111"];
        lb_title.font = [UIFont systemFontOfSize:15.0f];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
    }
    
    
    
    for(int i = 0; i < [_buttonTitle count];i++){
        if([_buttonTitle count] < 2){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, kmsgViewFullheight-kButtonHeight, kVwidth, kButtonHeight)];
            
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            
            button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
            [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            
            [button setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"F1F1F1"]] forState:UIControlStateHighlighted];
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
         //   UIColor * lightGrayColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
            
          //  UIGraphicsBeginImageContext(iv_alertview.frame.size);
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
         
            
        }
        else if ([_buttonTitle count] == 2){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i*(kVwidth/2)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/2)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            
            if(i == 0 ){
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
            }else{
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            }
            [button setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"F1F1F1"]] forState:UIControlStateHighlighted];
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            
          //       UIGraphicsBeginImageContext(iv_alertview.frame.size);
            
          //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
          
            
         
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/2, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
           
            
            
        }
        else if ([_buttonTitle count] == 3){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i*(kVwidth/3)+1), kmsgViewFullheight-kButtonHeight, (kVwidth/3)-1, kButtonHeight)];
            
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateReserved];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateSelected];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateDisabled];
            
            
            if(i == 2 ){
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
            }else{
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateSelected];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateNormal];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateReserved];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateHighlighted];
                [button setTitleColor:[Mocha_Util getColor:@"888888"] forState:UIControlStateDisabled];
                button.titleLabel.textColor = [Mocha_Util getColor:@"888888"];

            }
            [button setBackgroundImage:[self imageWithColor:[Mocha_Util getColor:@"F1F1F1"]] forState:UIControlStateHighlighted];
            
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
            
            
            //            UIGraphicsBeginImageContext(iv_alertview.frame.size);
            
            //  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 229.0f/255.0f, 229.0f/255.0f, 229.0f/255.0f, 1.0);
            
            
            
            CGPoint startPoint = CGPointMake( 0, iv_alertview.frame.size.height-40);
            CGPoint endPoint = CGPointMake(iv_alertview.frame.size.width, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint, endPoint, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            CGPoint startPoint2 = CGPointMake( iv_alertview.frame.size.width/3, iv_alertview.frame.size.height);
            CGPoint endPoint2 = CGPointMake(iv_alertview.frame.size.width/3, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint2, endPoint2, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
            CGPoint startPoint3 = CGPointMake( (iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height);
            CGPoint endPoint3 = CGPointMake((iv_alertview.frame.size.width/3)*2, iv_alertview.frame.size.height-40);
            drawPxStroke(UIGraphicsGetCurrentContext(), startPoint3, endPoint3, [Mocha_Util getColor:@"CFCFCF"].CGColor, 0.5f);
            
            
            
            
        }
 
        
        
        //닫기 버튼  전용 tag = 1000 return
        UIButton *closebutton = [[UIButton alloc] initWithFrame:CGRectMake(kVwidth-40, 0, 40, 40)];
        
        closebutton.backgroundColor = [UIColor clearColor];
        [closebutton setImage:[UIImage imageNamed:@"MochaResources.bundle/malert_bt_close.png"] forState:UIControlStateHighlighted];
        [closebutton setImage:[UIImage imageNamed:@"MochaResources.bundle/malert_bt_close.png"] forState:UIControlStateSelected];
        [closebutton setImage:[UIImage imageNamed:@"MochaResources.bundle/malert_bt_close.png"] forState:UIControlStateNormal];
        closebutton.imageEdgeInsets  = UIEdgeInsetsMake(13, 13, 13, 13);
        [closebutton setTag:1000];
        [closebutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertview addSubview:closebutton];
    
    }
    
    iv_alertview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    [self runAnimation:alertview.layer durationTime:0.0f];
    
    
    //
    [alertview.layer setCornerRadius:5.0f];
    [alertview.layer setShadowRadius:5.0f];
    [alertview setClipsToBounds:YES];
    
    return self;
}

- (void) runAnimation : (CALayer *)layer durationTime : (CGFloat) duration
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    
    animation.duration = duration;
    if(duration <= 0.1f)
    {
        if(self.fdurationTime <= 0.1f)
        {
            animation.duration = 1.0f;
        }
        else
        {
            animation.duration = self.fdurationTime;
        }
    }
    
    
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.2],
                        [NSNumber numberWithFloat:0.4],
                        [NSNumber numberWithFloat:0.6],
                        [NSNumber numberWithFloat:0.8],
                        [NSNumber numberWithFloat:1.0],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.2],
                          [NSNumber numberWithFloat:0.4],
                          [NSNumber numberWithFloat:0.6],
                          [NSNumber numberWithFloat:0.8],
                          [NSNumber numberWithFloat:1.0],
                          nil];
    
    [layer addAnimation:animation forKey:@"opacityAnimation"];
}




- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}





- (UIView *)initWithRotateTitle:(NSString *)title maintitle:(NSString *)mtitle delegate:(id)delegate onwindow:(BOOL)onwindow buttonTitle:(NSArray *)buttonTitle{
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameOrOrientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    
    self = [super init];
    //if (self){
    _title = title;
    _maintitle = mtitle;
    adelegate = delegate;
    _buttonTitle = buttonTitle;
    isrotateview = YES;
    //}
    const int kMainTitleTopHeight = 30;
    const int kTopMarginHeight = 43;
    const int kBottomMarginHeight = 38;
    const int kButtonHeight = 30;
    const int kMsgBtnMargin = 25;
    
    if(onwindow){
        self.isonwindow = YES;
    }else {
        self.isonwindow = NO;
    }
    
    
    
    
    
    
    self.frame = CGRectMake(0, 0, APPFULLHEIGHT, APPFULLWIDTH);
    iv_background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPFULLHEIGHT, APPFULLWIDTH)];
    // NSString* path = [NSString stringWithFormat:@"%@/Mocha.framework/Resources/blind01.png", [[NSBundle mainBundle] bundlePath]];
    
    iv_background.image = [UIImage imageNamed:@"MochaResources.bundle/blind01.png"];
    [self addSubview:iv_background];
    
    
    
    CGSize maintsize = [_maintitle sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(270, 30000)   lineBreakMode:NSLineBreakByWordWrapping];
    CGSize titlesize = [_title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(270, 30000)  lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    if(mtitle != nil) {
        alertview = [[UIView alloc] initWithFrame:CGRectMake((APPFULLHEIGHT/2)-148, (APPFULLWIDTH - (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+kMainTitleTopHeight+titlesize.height+kMsgBtnMargin))/2, 296,   (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+kMainTitleTopHeight+titlesize.height+kMsgBtnMargin))];
    }else {
        alertview = [[UIView alloc] initWithFrame:CGRectMake((APPFULLHEIGHT/2)-148, (APPFULLWIDTH - (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+titlesize.height+kMsgBtnMargin))/2, 296,   (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+titlesize.height+kMsgBtnMargin))];
    }
    
    [self addSubview:alertview];
    
    
    
    
    if(mtitle != nil) {
        UIImageView *iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296,  (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+kMainTitleTopHeight+titlesize.height+kMsgBtnMargin))];
        iv_alertview.image = [[UIImage imageNamed:@"MochaResources.bundle/popup02.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0f];
        [alertview addSubview:iv_alertview];
    } else {
        UIImageView *iv_alertview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+titlesize.height+kMsgBtnMargin))];
        iv_alertview.image = [[UIImage imageNamed:@"MochaResources.bundle/popup01.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0f];
        [alertview addSubview:iv_alertview];
    }
    
    
    if(![_maintitle isEqualToString:@""]){
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, kTopMarginHeight, 270, maintsize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _maintitle;
        lb_title.textColor = [Mocha_Util getColor:@"000000"];
        lb_title.font = [UIFont boldSystemFontOfSize:17];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
    }
    
    if(![_title isEqualToString:@""]){
        UILabel *lb_title = [[UILabel alloc] initWithFrame:CGRectMake(13, (mtitle != nil)?kTopMarginHeight+kMainTitleTopHeight:kTopMarginHeight, 270, titlesize.height)];
        lb_title.backgroundColor = [UIColor clearColor];
        lb_title.text = _title;
        lb_title.textColor = [Mocha_Util getColor:@"454545"];
        lb_title.font = [UIFont systemFontOfSize:14.0f];
        lb_title.textAlignment = UITextAlignmentCenter;
        lb_title.numberOfLines = 0;
        [alertview addSubview:lb_title];
    }
    
    
    _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    int maintth = 0;
    if(mtitle != nil){
        maintth = kMainTitleTopHeight+kTopMarginHeight+kMsgBtnMargin;
    }else {
        maintth = kTopMarginHeight+kMsgBtnMargin;
    }
    
    for(int i = 0; i < [_buttonTitle count];i++){
        if([_buttonTitle count] < 2){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(86.5, _messageView.frame.size.height + titlesize.height+maintth, 123, kButtonHeight)];
            [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn_ac.png"] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            button.titleLabel.textColor = [Mocha_Util getColor:@"454545"];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
            
        }
        else if ([_buttonTitle count] == 2){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(48 + (i*107), _messageView.frame.size.height + titlesize.height+maintth, 93, kButtonHeight)];
            if([[_buttonTitle objectAtIndex:i] isEqualToString:@"취소"]){
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }
            
            [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn_ac.png"] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            button.titleLabel.textColor = [Mocha_Util getColor:@"454545"];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
        }
        else if ([_buttonTitle count] == 3){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5 + (i*97), _messageView.frame.size.height + titlesize.height+maintth, 93, kButtonHeight)];
            if([[_buttonTitle objectAtIndex:i] isEqualToString:@"취소"]){
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn.png"] forState:UIControlStateNormal];
            }
            
            [button setBackgroundImage:[UIImage imageNamed:@"MochaResources.bundle/pop_btn_ac.png"] forState:UIControlStateHighlighted];
            [button setTitle:[_buttonTitle objectAtIndex:i] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            button.titleLabel.textColor = [Mocha_Util getColor:@"454545"];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertview addSubview:button];
        }
        
    }
    
    
    
    
    
    /*
     //opacity 알파값 애니메이션
     CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
     
     animation.duration = Mocha_UIViewAnimationDuration/2;
     animation.values = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:0.2],
     [NSNumber numberWithFloat:0.4],
     [NSNumber numberWithFloat:0.6],
     [NSNumber numberWithFloat:0.8],
     [NSNumber numberWithFloat:1.0],
     nil];
     animation.keyTimes = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:0.1],
     [NSNumber numberWithFloat:0.2],
     [NSNumber numberWithFloat:0.3],
     [NSNumber numberWithFloat:0.4],
     [NSNumber numberWithFloat:0.5],
     nil];
     
     [alertview.layer addAnimation:animation forKey:@"opacityAnimation"];
     
     */
    
    NSLog(@"리턴뷰");
    
    
	// 팝업 애니메이션 old
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	
	animation.duration = Mocha_UIViewAnimationDuration/2;
	animation.values = [NSArray arrayWithObjects:
						[NSNumber numberWithFloat:0.1],
						[NSNumber numberWithFloat:1.2],
						[NSNumber numberWithFloat:0.9],
						[NSNumber numberWithFloat:1.0],
						nil];
	animation.keyTimes = [NSArray arrayWithObjects:
						  [NSNumber numberWithFloat:0.0],
						  [NSNumber numberWithFloat:0.5],
						  [NSNumber numberWithFloat:0.75],
						  [NSNumber numberWithFloat:1.0],
						  nil];
	
	[alertview.layer addAnimation:animation forKey:@"scaleAnimation"];
	
    
    //
    [alertview.layer setCornerRadius:5.0f];
    [alertview.layer setShadowRadius:5.0f];
    [alertview setClipsToBounds:YES];
    
    
    return self;
    
    
    /*
     // 팝업 애니메이션_부드러운
     CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
     
     animation.duration = Mocha_UIViewAnimationDuration/1;
     animation.values = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:0.1],
     [NSNumber numberWithFloat:1.2],
     [NSNumber numberWithFloat:0.9],
     [NSNumber numberWithFloat:1.0],
     nil];
     animation.keyTimes = [NSArray arrayWithObjects:
     [NSNumber numberWithFloat:0.0],
     [NSNumber numberWithFloat:0.5],
     [NSNumber numberWithFloat:0.75],
     [NSNumber numberWithFloat:1.0],
     nil];
     
     [alertview.layer addAnimation:animation forKey:@"scaleAnimation"];
     
     
     
     return self;
     */
}












-(void)forcelayoutSubviews {
    
    //    UIDeviceOrientation   orientation = [UIDevice currentDevice].orientation;
    
    UIInterfaceOrientation desiredorientation = [self desiredOrientation];
    
    // NSString   *LorP = UIDeviceOrientationIsLandscape(desiredorientation) ? @"Landscape" : @"Portrait";
    //NSLog(@"orientation is %@",LorP);
    //창 위치 수정 추가
    
    
    const int kMainTitleTopHeight = 30;
    const int kTopMarginHeight = 43;
    const int kBottomMarginHeight = 38;
    const int kButtonHeight = 30;
    const int kMsgBtnMargin = 25;
    
    
    
    
    if (UIDeviceOrientationIsLandscape((UIDeviceOrientation)desiredorientation)) {
        //가로모드
        NSLog(@"가로감");
        iv_background.frame = CGRectMake(0, 0, APPFULLHEIGHT, APPFULLWIDTH);
        
        alertview.frame = CGRectMake((APPFULLHEIGHT/2)-148, (APPFULLWIDTH - (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+kMainTitleTopHeight+20+kMsgBtnMargin))/2, 296,   (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+kMainTitleTopHeight+20+kMsgBtnMargin));
        
    }else {
        //세로모드
        NSLog(@"세로감");
        
        iv_background.frame = CGRectMake(0, 0, APPFULLWIDTH, APPFULLHEIGHT);
        
        alertview.frame = CGRectMake((APPFULLWIDTH/2)-148, (APPFULLHEIGHT - (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+kMainTitleTopHeight+20+kMsgBtnMargin))/2, 296,   (kTopMarginHeight+kBottomMarginHeight+kButtonHeight+kMainTitleTopHeight+20+kMsgBtnMargin));
    }
    
    
    
    //윈도붙였을시엔
    if(self.isonwindow) {
        [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
    }
    
    
    
    
    
}





- (void) buttonClick:(UIButton*)sender{
    if(self.superview != nil ) {
        NSLog(@"클릭");
        if ([adelegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
            [adelegate customAlertView:self clickedButtonAtIndex:sender.tag];
        }
        [self removeFromSuperview];
        
    }
    // [self release]; self = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


-(void)dealloc {
    
    if(isrotateview){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSLog(@"회전뷰옵저버 제거");
    }
    
    NSLog(@"디얼알럿");
    
    _maintitle = nil;
    _title = nil;
    _messageView = nil;
    _buttonTitle = nil;
    
}




//#pragma mark Alert block
//- (void) block_alertWithTitle:(NSString*)title message:(NSString *)message btnOK:(NSString *)strOk btnClose:(NSString *) btnClose btnOther : (NSString *)strOther block_BtnEvent:(AlertButonIndex)btnEvent
//{
//    self.alertBtnIndex                  =   [btnEvent copy];
//    
//    UIAlertView *pAlert;
//    
//    if([strOk length] == 0)
//    {   // 닫기
//        pAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:btnClose otherButtonTitles:nil];
//    }
//    else
//    {   // 확인, 취소
//        pAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:btnClose otherButtonTitles:strOk, strOther, nil];
//    }
//    
//    [pAlert show];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    self.alertBtnIndex((BTNINDEX)buttonIndex);
//}


























- (void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    _supportedInterfaceOrientations = supportedInterfaceOrientations;
    
    if(self.window != nil)
    {
        [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
    }
}

- (void)statusBarFrameOrOrientationChanged:(NSNotification *)notification
{
    /*
     This notification is most likely triggered inside an animation block,
     therefore no animation is needed to perform this nice transition.
     */
    NSLog(@"돔돔돔");
    if(self.isonwindow){
        [self rotateAccordingToStatusBarOrientationAndSupportedOrientations];
    }
}

- (void)rotateAccordingToStatusBarOrientationAndSupportedOrientations
{
    UIInterfaceOrientation orientation = [self desiredOrientation];
    CGFloat angle = UIInterfaceOrientationAngleOfOrientation(orientation);
    CGFloat statusBarHeight = [[self class] getStatusBarHeight];
    // CGFloat statusBarHeight = 20.0f;
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    NSLog(@"로테잇 %ld",(unsigned long)orientation  );
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGRect frame = [[self class] rectInWindowBounds:self.window.bounds statusBarOrientation:statusBarOrientation statusBarHeight:statusBarHeight];
    
    [self setIfNotEqualTransform:transform frame:frame];
}

- (void)setIfNotEqualTransform:(CGAffineTransform)transform frame:(CGRect)frame
{
    if(!CGAffineTransformEqualToTransform(self.transform, transform))
    {
        self.transform = transform;
    }
    if(!CGRectEqualToRect(self.frame, frame))
    {
        self.frame = frame;
    }
}



+ (CGFloat)getStatusBarHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsLandscape(orientation))
    {
        return [UIApplication sharedApplication].statusBarFrame.size.width;
    }
    else
    {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (CGRect)rectInWindowBounds:(CGRect)windowBounds statusBarOrientation:(UIInterfaceOrientation)statusBarOrientation statusBarHeight:(CGFloat)statusBarHeight
{
    CGRect frame = windowBounds;
    frame.origin.x += statusBarOrientation == UIInterfaceOrientationLandscapeLeft ? statusBarHeight : 0;
    frame.origin.y += statusBarOrientation == UIInterfaceOrientationPortrait ? statusBarHeight : 0;
    frame.size.width -= UIInterfaceOrientationIsLandscape(statusBarOrientation) ? statusBarHeight : 0;
    frame.size.height -= UIInterfaceOrientationIsPortrait(statusBarOrientation) ? statusBarHeight : 0;
    return frame;
}





- (UIInterfaceOrientation)desiredOrientation
{
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    UIInterfaceOrientationMask statusBarOrientationAsMask = UIInterfaceOrientationMaskFromOrientation(statusBarOrientation);
    if(self.supportedInterfaceOrientations & statusBarOrientationAsMask)
    {
        return statusBarOrientation;
    }
    else
    {
        if(self.supportedInterfaceOrientations & UIInterfaceOrientationMaskPortrait)
        {
            return UIInterfaceOrientationPortrait;
        }
        else if(self.supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeLeft)
        {
            return UIInterfaceOrientationLandscapeLeft;
        }
        else if(self.supportedInterfaceOrientations & UIInterfaceOrientationMaskLandscapeRight)
        {
            return UIInterfaceOrientationLandscapeRight;
        }
        else
        {
            return UIInterfaceOrientationPortraitUpsideDown;
        }
    }
}

/*
 
 #pragma mark - Presentation
 
 - (void)addSubViewAndKeepSamePosition:(UIView *)view
 {
 if(view.superview == nil)
 {
 [NSException raise:NSInternalInconsistencyException format:@"When calling %s we are expecting the view to be moved is already in a view hierarchy.", __PRETTY_FUNCTION__];
 }
 
 view.frame = [view convertRect:view.bounds toView:self];
 [self addSubview:view];
 }
 
 - (void)addSubviewAndFillBounds:(UIView *)view
 {
 view.frame = [self bounds];
 [self addSubview:view];
 }
 
 - (void)addSubviewAndFillBounds:(UIView *)view withSlideUpAnimationOnDone:(void(^)(void))onDone
 {
 CGRect endFrame = [self bounds];
 CGRect startFrame = endFrame;
 startFrame.origin.y += startFrame.size.height;
 
 view.frame = startFrame;
 [self addSubview:view];
 
 [UIView animateWithDuration:0.4 animations:^{
 view.frame = endFrame;
 self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
 self.opaque = YES;
 } completion:^(BOOL finished) {
 if(onDone)
 {
 onDone();
 }
 }];
 }
 
 - (void)fadeOutAndRemoveFromSuperview:(void(^)(void))onDone
 {
 [UIView animateWithDuration:0.4 animations:^{
 self.alpha = 0.0;
 } completion:^(BOOL finished) {
 [self removeFromSuperview];
 if(onDone)
 {
 onDone();
 }
 }];
 }
 
 - (void)slideDownSubviewsAndRemoveFromSuperview:(void(^)(void))onDone
 {
 self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
 self.opaque = YES;
 
 [UIView animateWithDuration:0.4 animations:^{
 
 for(UIView *subview in [self subviews])
 {
 CGRect frame = subview.frame;
 frame.origin.y += self.bounds.size.height;
 subview.frame = frame;
 }
 
 self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
 self.opaque = NO;
 
 } completion:^(BOOL finished) {
 [self removeFromSuperview];
 if(onDone)
 {
 onDone();
 }
 }];
 }
 
 - (void)bringToFront
 {
 [self.superview bringSubviewToFront:self];
 }
 
 - (BOOL)isInFront
 {
 NSArray *subviewsOnSuperview = [self.superview subviews];
 NSUInteger index = [subviewsOnSuperview indexOfObject:self];
 return index == subviewsOnSuperview.count - 1;
 }
 
 */







@end








@implementation MochaWindowViewHelper

BOOL UIInterfaceOrientationsIsForSameAxis(UIInterfaceOrientation o1, UIInterfaceOrientation o2)
{
    if(UIInterfaceOrientationIsLandscape(o1) && UIInterfaceOrientationIsLandscape(o2))
    {
        return YES;
    }
    else if(UIInterfaceOrientationIsPortrait(o1) && UIInterfaceOrientationIsPortrait(o2))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

CGFloat UIInterfaceOrientationAngleBetween(UIInterfaceOrientation o1, UIInterfaceOrientation o2)
{
    CGFloat angle1 = UIInterfaceOrientationAngleOfOrientation(o1);
    CGFloat angle2 = UIInterfaceOrientationAngleOfOrientation(o2);
    
    return angle1 - angle2;
}

CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation)
{
    CGFloat angle;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = -M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = M_PI_2;
            break;
        default:
            angle = 0.0;
            break;
    }
    
    return angle;
}

UIInterfaceOrientationMask UIInterfaceOrientationMaskFromOrientation(UIInterfaceOrientation orientation)
{
    return 1 << orientation;
}















@end
