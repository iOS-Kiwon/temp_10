//
//  MochaValidator.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 6. 26..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

 

typedef enum {
    MochaPasswordStrengthVeryWeak     = 0,
    MochaPasswordStrengthWeak         = 1,
    MochaPasswordStrengthMedium       = 2,
    MochaPasswordStrengthStrong       = 3,
    MochaPasswordStrengthVeryStrong   = 4,
} MochaPasswordStrength;

/**
 * @brief MochaValidator
 * 기본적으로 UITextField  입력값 검증용도로  검증결과에따른 화  비밀번호 입력값의 암호화정책의 강도(MochaPasswordStrength)에 따른 비밀번호 유효성체크 기능포함.
 */
@interface MochaValidator : NSObject

@property (nonatomic, assign) MochaPasswordStrength requiredStrength;



/**
 *  TextField에 입력된 string을 받아 알파벳 여부 BOOL값 반환
 *
 *   @param string 검증 대상 str  (NSString)
 *   @return BOOL
 *
 */
- (BOOL)Alphabeticcheck:(NSString *)string;

/**
 *  TextField에 입력된 string을 받아 숫자로만 구성되어있는지 여부 BOOL값 반환
 *
 *   @param string 검증 대상 str  (NSString)
 *   @return BOOL
 *
 */
- (BOOL)Numbercheck:(NSString *)string;

/**
 *  TextField에 입력된 string을 받아 알파벳과 숫자로만 구성되어있는지 여부 BOOL값 반환
 *
 *   @param string 검증 대상 str  (NSString)
 *   @return BOOL
 *
 */
- (BOOL)AlphaNumericcheck:(NSString *)string;

/**
 *  TextField에 입력된 string을 받아 이메일 형식이 유효한지 여부 BOOL값 반환
 *
 *   @param string 검증 대상 str  (NSString)
 *   @return BOOL
 *
 */
- (BOOL)Emailcheck:(NSString *)string;

/**
 *  TextField에 입력된 string을 받아 URL 형식이 유효한지 여부 BOOL값 반환
 *
 *   @param string 검증 대상 str  (NSString)
 *   @return BOOL
 *
 */
- (BOOL)Urlcheck:(NSString *)string;

/**
 *  TextField에 입력된 string을 받아 retain 정의된 MochaPasswordStrength 암호화 정책에 따른 유효성 여부 BOOL값 반환
 *
 *   @param string 검증 대상 str  (NSString)
 *   @return BOOL
 *
 */
- (BOOL)passwordStrengthcheck:(NSString *)string;
@end
