//
//  Mocha_FileKit.h
//  Mocha
//
//  Created by Hoecheon Kim on 12. 7. 9..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#include "zip.h"
#include "unzip.h"

@protocol Mocha_FileKitDelegate <NSObject>
@optional
-(void) ErrorMessage:(NSString*) msg;
-(BOOL) OverWriteOperation:(NSString*) file;

@end



/**
 * @brief 파일,디렉토리 관리 메니저
 * 파일,디렉토리 생성,존재여부,이동,복사,삭제, 목록 리턴, zip파일 생성,해제 관리 기능망라.
 */

@interface Mocha_FileKit : NSObject {
 
NSFileManager *FileManager;
    
@private
	zipFile		_zipFile;
	unzFile		_unzFile;
	
	NSString*   _password;
	id			_delegate;
}

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSFileManager *FileManager;


/**
 *  targetPath를 받아 폴더 생성 후 성공여부 BOOL값 반환
 *
 *   @param targetPath 생성할 대상 경로 str  (NSString)
 *   @return BOOL
 *
 */

-(BOOL) createDirectoryAtPath:(NSString*) targetPath;

/**
 *  targetPath를 받아 해당경로에 존재여부 BOOL값 반환
 *
 *   @param targetPath 존재여부를 확인할 대상 경로 str  (NSString)
 *   @return BOOL
 *
 */

-(BOOL) fileExistsAtPath:(NSString*) targetPath;
/**
 *  원시경로로부터 대상경로로 파일 이동 후 성공여부 BOOL값 반환
 *
 *   @param fromPath 원시 경로 str  (NSString)
 *   @param targetPath 이동할 대상 경로 str  (NSString)
 *   @return BOOL
 *
 */
-(BOOL) moveFile:(NSString*)fromPath targetpath:(NSString*) targetPath;

/** 
 *  원시경로로부터 대상경로로 파일 복사 후 성공여부 BOOL값 반환
 *
 *   @param fromPath 원시 경로 str  (NSString)
 *   @param targetPath 복사할 대상 경로 str  (NSString)
 *   @return BOOL
 *
 */
-(BOOL) copyFile:(NSString*)fromPath targetpath:(NSString*) targetPath;
/**
 *  대상로의 파일 삭제 후 성공여부 BOOL값 반환
 *
 *   @param targetPath 삭제할 대상 경로 str  (NSString)
 *   @return BOOL
 *
 */
-(BOOL) deleteFile:(NSString *)targetPath;
/**
 *  대상경로의 파일네임 리스트 NSArray 반환
 *
 *   @param targetPath 파일네임리스트 array를 확인할 대상 경로 str  (NSString)
 *   @return NSArray
 *
 */
-(NSArray *) dirFileNameList:(NSString *)targetPath;
/**
 *  대상경로의 파일네임 리스트 NSArray 반환, 파일명만 심플하게 반환용도.
 *
 *   @param targetPath 파일네임리스트 array를 확인할 대상 경로 str  (NSString)
 *   @return NSArray
 *
 */
-(NSArray *) dirSimpleFileNameList:(NSString *)targetPath;




/**
 *  대상경로의 파일을 Overwrite-덮어쓰기 후 성공여부 BOOL값반환. optional protocol 메서드구현필요.
 *
 *   @param file  대상 파일 경로 str  (NSString)
 *   @return BOOL
 *
 */

-(BOOL) OverWrite:(NSString*) file;

/**
 *  에러메세지 delegate 객체에 전달. optional protocol 메서드구현필요.
 *
 *   @param msg  에러메세지 문자열   (NSString)
 *   @return (void)
 *
 */

-(void) OutputErrorMessage:(NSString*) msg;



/**
 *  zip파일 생성 후 성공값 반환  
 *
 *   @param zipFile zip파일을 생성할 대상 파일 경로 str  (NSString)
 *   @return BOOL
 *
 */
-(BOOL) CreateZipFile2:(NSString*) zipFile;


/**
 *  zip파일 생성 후 성공값 반환 - 암호화 zip파일생성
 *
 *   @param zipFile zip파일을 생성할 대상 파일 경로 str  (NSString)
 *   @param password zip파일을 생성,해제시 사용할 비밀번호 str  (NSString)
 *   @return BOOL
 *
 */

-(BOOL) CreateZipFile2:(NSString*) zipFile Password:(NSString*) password;

/**
 *  생성한 zip 파일에 압축하여 묶을 파일을 추가
 *
 *   @param file 생성한 또는 기존재하는 zip파일의 파일 경로 str  (NSString)
 *   @param newname zip파일에 추가할 대상 파일 경로 str  (NSString)
 *   @return BOOL
 *
 */
-(BOOL) addFileToZip:(NSString*) file newname:(NSString*) newname;

/**
 *  생성또는 해지,추가시 사용한 zip 파일 객체 닫은 후 성공값 반환.
 * 
 *   @return BOOL
 *
 */
-(BOOL) CloseZipFile2;


/**
 *  zip파일 압축 해제 후 성공값 반환
 *
 *   @param zipFile zip파일을 압축 해제할 대상 파일 경로 str  (NSString)
 *   @return BOOL
 *
 */
-(BOOL) UnzipOpenFile:(NSString*) zipFile;

/**
 *  zip파일 압축 해제 후 성공값 반환 - 암호화 zip파일해제
 *
 *   @param zipFile zip파일 해제할 대상 파일 경로 str  (NSString)
 *   @param password zip파일을 해제시 사용할 비밀번호 str  (NSString)
 *   @return BOOL
 *
 */
-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password;

/**
 *  zip파일 압축 해제 후 성공값 반환 
 *
 *   @param path zip파일 해제할 대상 파일 경로 str  (NSString)
 *   @param overwrite zip파일을 해제시 overwrite 여부  (BOOL)
 *   @return BOOL
 *
 */
-(BOOL) UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite;

/**
 *  생성또는 해지시 사용한 zip 파일 객체 닫은 후 성공값 반환.
 *
 *   @return BOOL
 *
 */
-(BOOL) UnzipCloseFile;


@end

 
  

