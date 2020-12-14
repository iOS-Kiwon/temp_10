//
//  GSButton.m
//  Mocha
//
//  Created by nami0342 on 2017. 7. 31..
//
//

#import "GSButton.h"
#import <Mocha_Util.h>

@implementation GSButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [Mocha_Util getColor:@"F1F1F1"];
    }
    else {
        self.backgroundColor = [Mocha_Util getColor:@"FFFFFF"];
    }
}



@end
