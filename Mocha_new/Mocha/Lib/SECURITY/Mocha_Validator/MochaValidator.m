//
//  MochaValidator.m
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 26..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "MochaValidator.h"
@interface MochaValidator (Private)

- (NSUInteger)_numberOfNumericCharactersInString:(NSString *)string;

- (NSUInteger)_numberOfLowercaseCharactersInString:(NSString *)string;

- (NSUInteger)_numberOfUppercaseCharactersInString:(NSString *)string;

- (NSUInteger)_numberOfSpecialCharactersInString:(NSString *)string;

- (NSUInteger)_numberOfMatchesWithPattern:(NSString *)pattern inString:(NSString *)string;

- (NSUInteger)_strengthOfPasswordString:(NSString *)string;
@end


@implementation MochaValidator

@synthesize requiredStrength = _requiredStrength;

#pragma mark - Initilisation

- (id)init
{
    self = [super init];
    
    if(self != nil)
    {
        _requiredStrength = MochaPasswordStrengthMedium; // default required strength
    }
    
    return self;
}

- (BOOL)Alphabeticcheck:(NSString *)string
{
    if (nil == string)
        return NO;
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return numberOfMatches == string.length;
}
- (BOOL)Numbercheck:(NSString *)string
{
    if (nil == string)
        return NO;
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return numberOfMatches == string.length;
}


- (BOOL)AlphaNumericcheck:(NSString *)string
{
    if (nil == string)
        return NO;
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9]" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return numberOfMatches == string.length;
}



- (BOOL)Emailcheck:(NSString *)string
{
    if (nil == string)
        string = [NSString string];
    
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z]{2,})+$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    return numberOfMatches == 1;
}




- (BOOL)Urlcheck:(NSString *)string
{
    if (nil == string)
    {
        return NO;
    }
    
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSTextCheckingResult *firstMatch = [detector firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    return [firstMatch.URL isKindOfClass:[NSURL class]]
    && ![firstMatch.URL.scheme isEqualToString:@"mailto"]
    && ![firstMatch.URL.scheme isEqualToString:@"ftp"];
}




#pragma mark - Condition check

- (BOOL)passwordStrengthcheck:(NSString *)string
{
    BOOL passed = NO;
    
    // If strength is more than or equal to the required strength to pass, the condition can pass
    if([self _strengthOfPasswordString:string] >= _requiredStrength)
    {
        passed = YES;
    }
    
    return passed;
}








#pragma mark - Strength Check

- (NSUInteger)_strengthOfPasswordString:(NSString *)string
{
    
    NSUInteger strength = 0;
    
    // Run regex on string to check for matches of lowercase, uppercase, numeric and special chars
    NSUInteger numberMatchesCount = [self _numberOfNumericCharactersInString:string];
    NSUInteger lowercaseMatchesCount = [self _numberOfLowercaseCharactersInString:string];
    NSUInteger uppercaseMatchesCount = [self _numberOfUppercaseCharactersInString:string];
    NSUInteger specialCharacterMatchesCount = [self _numberOfSpecialCharactersInString:string];
    
    // For each match of each type, move the strength value up one (higher = stronger)
    if (numberMatchesCount > 0)	
    { 
        strength ++; 
    }
    
    if (lowercaseMatchesCount > 0)	
    { 
        strength ++; 
    }
    
    if (uppercaseMatchesCount > 0)	
    { 
        strength ++; 
    }
    
    if (specialCharacterMatchesCount > 0) 
    { 
        strength ++; 
    }
    
    // Move the strength up if the length is more than 8 characters and down if it is less
    if (string.length > 8) 
    { 
        strength ++; 
    }
    else if (strength > 0)
    {
        strength --;
    }
    
    return strength;
    
}
 

- (NSUInteger)_numberOfNumericCharactersInString:(NSString *)string
{
    return [self _numberOfMatchesWithPattern:@"\\d" inString:string];
}

- (NSUInteger)_numberOfLowercaseCharactersInString:(NSString *)string
{
    return [self _numberOfMatchesWithPattern:@"[a-z]" inString:string];
}

- (NSUInteger)_numberOfUppercaseCharactersInString:(NSString *)string
{
    return [self _numberOfMatchesWithPattern:@"[A-Z]" inString:string];
}

- (NSUInteger)_numberOfSpecialCharactersInString:(NSString *)string
{
    return [self _numberOfMatchesWithPattern:@"[^a-zA-Z\\d]" inString:string];
}

- (NSUInteger)_numberOfMatchesWithPattern:(NSString *)pattern inString:(NSString *)string
{
    NSError *error      = NULL;
    NSUInteger matches  = 0;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if(!error)
    {
        matches =  [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    }
    
    return matches;
}


@end
