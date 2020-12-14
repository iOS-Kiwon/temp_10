//
//  SCH_BAN_THUMBTypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 5..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_BAN_THUMBTypeCell.h"

@implementation SCH_BAN_THUMBTypeCell

@synthesize onAirImg,onAirTime,backgroundImg,timeText,titleText,selectLine,onAirLine;


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    dateformat = [[NSDateFormatter alloc]init];
    [dateformat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"]];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    
    //선택라인
    [self.selectLine.layer setMasksToBounds:NO];
    self.selectLine.layer.shadowOffset = CGSizeMake(0, 0);
    self.selectLine.layer.shadowRadius = 3.0;
    self.selectLine.layer.borderColor = [Mocha_Util getColor:@"09BCCD"].CGColor;
    self.selectLine.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.selectLine.layer.borderWidth = 3.0;
    
    //생방송라인
    [self.onAirLine.layer setMasksToBounds:NO];
    self.onAirLine.layer.shadowOffset = CGSizeMake(0, 0);
    self.onAirLine.layer.shadowRadius = 1.0;
    self.onAirLine.layer.borderColor = [Mocha_Util getColor:@"ED1F60"].CGColor;
    self.onAirLine.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.onAirLine.layer.borderWidth = 1.0;

}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.onAirImg.hidden = YES;
    self.onAirTime.hidden = YES;
    self.onAirTime.text = @"";
    self.onAirLine.hidden = YES;
    
    self.timeText.hidden = YES;
    self.timeText.text = @"";
    self.selectLine.hidden = YES;
    
    self.backgroundImg.image = nil;
    self.titleText.text = @"";
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr{

    if(NCO(rowinfoArr))
    {
        self.titleText.text = NCS([celldic objectForKey:@"productName"]);
        
        celldic = rowinfoArr;
        NSString *imageURL = NCS([celldic objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageURL isEqualToString:strInputURL]){
                if (isInCache)
                {
                    self.backgroundImg.image = fetchedImage;
                }
                else
                {
                    self.backgroundImg.alpha = 0;
                    self.backgroundImg.image = fetchedImage;
                    
                    [UIView animateWithDuration:0.2f
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         
                                         self.backgroundImg.alpha = 1;
                                         
                                     }
                                     completion:^(BOOL finished) {
                                         
                                     }];
                }
            }
        }];
        
        
        // 시간 계산 부분.. 간결화 필요.
        onAirDateTime = NCS([celldic objectForKey:@"broadCloseTime"]);
        NSString *st = NCS([celldic objectForKey:@"broadStartTime"]);
        
        NSDate *startTime = [dateformat dateFromString:onAirDateTime];
        long long startStamp = [startTime timeIntervalSince1970];
        long long leftTimeSec = startStamp - (long long)[[NSDate getSeoulDateTime] timeIntervalSince1970];
        
        
        NSDate *startTime2 = [dateformat dateFromString:st];
        long long startStamp2 = [startTime2 timeIntervalSince1970];
        long long leftTimeSec2 = startStamp2 - (long long)[[NSDate getSeoulDateTime] timeIntervalSince1970];
        
        if ((leftTimeSec > 0) && (leftTimeSec2 < 0)) //현재 방송중인지 판단
        {
            [self setOnAir:YES];
        }
        else
        {
            [self setOnAir:NO];
        }
        
    }
    else
    {
        
    }
}




- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    // 선택되면 사각 테두리를 만든다.
    self.selectLine.hidden = !highlighted;
    
    //값 전달은..
}


// 생방송 상품 설정
- (void)setOnAir:(BOOL) isOnair{
    
    
    self.onAirLine.hidden = !isOnair;
    
    if(isOnair)
    {
        self.onAirImg.hidden = NO;
        self.onAirTime.hidden = NO;
        self.onAirTime.text = @"TV HIT";
        self.timeText.hidden = YES;
        self.timeText.text = @"";
        
        [self startOnAirTimer];
    }
    else
    {
        self.onAirImg.hidden = YES;
        self.onAirTime.hidden = YES;
        self.timeText.hidden = NO;
        self.onAirTime.text = @"";
        self.timeText.text = NCS([celldic objectForKey:@"broadStartText"]);
    }
}



#pragma 타이머 메서드

-(void) startOnAirTimer
{
    
    if(NCS(onAirDateTime).length <= 0)
    {
        return;
    }
   
    
    [self TimeDealTimerProcess];
    
    if ([self.onAirLeftTimer isValid]) {
        [self.onAirLeftTimer invalidate];
        self.onAirLeftTimer = nil;
    }
    self.onAirLeftTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(TimeDealTimerProcess)
                                                        userInfo:nil
                                                         repeats:YES];
}



-(void) stopOnAirTimer
{
    if ([self.onAirLeftTimer isValid])
    {
        [self.onAirLeftTimer invalidate];
        self.onAirLeftTimer = nil;
    }
    else{
        
    }
    
    self.onAirTime.text = @"방송종료";
}



-(void) TimeDealTimerProcess
{
    NSDate *startTime = [dateformat dateFromString:onAirDateTime];
    
    long long startStamp = [startTime timeIntervalSince1970];
    long long leftTimeSec = startStamp - (long long)[[NSDate getSeoulDateTime] timeIntervalSince1970];
    
    if ((leftTimeSec > 0) ) {
        
        NSString * dbstr =   [NSString stringWithFormat:@"%lld", (long long)startStamp ];
        self.onAirTime.text = [self getDateLeftToStart:dbstr];
    }
    else // 끝나면..
    {
        [self stopOnAirTimer];
    }
}


- (NSString *) getDateLeftToStart:(NSString *)date{
    //카운트 표시 불가능일때는 TV HIT 표기
    NSString *callTemp = @"TV HIT";
    @try
    {
        double left = [date doubleValue] - [[NSDate getSeoulDateTime] timeIntervalSince1970];
        
        int tminite = left/60;
        int hour = left/3600;
        int minite = (left-(hour*3600))/60;
        int second = (left-(hour*3600)-(minite*60));
        

        
        //종료일이 100시간이 넘을 경우 99시간으로 표시. 2자리 시간이 남을 경우 정상적으로 2자리만 표시
        if(hour >= 100)
        {
            callTemp = [NSString stringWithFormat:@"99:59:59"];
        }
        else if(tminite >= 60)
        {
            callTemp = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minite, second];
        }
        else if(left <= 0)
        {
            callTemp  = [NSString stringWithFormat:@"00:00:00"];
        }
        else
        {
            callTemp  = [NSString stringWithFormat:@"00:%02d:%02d", minite, second];
        }
        
        
        if([callTemp isEqualToString:@"00:00:00"])
        {
            [self.onAirLeftTimer invalidate];
            self.onAirLeftTimer = nil;
            
             callTemp = @"방송종료";
        }
    }
    @catch(NSException *exception)
    {
        callTemp = @"TV HIT";
    }
    
    return callTemp;
}



@end
