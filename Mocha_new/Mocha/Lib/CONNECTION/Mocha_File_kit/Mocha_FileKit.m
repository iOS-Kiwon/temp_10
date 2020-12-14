//
//  Mocha_FileKit.m
//  Mocha
//
//  Created by Hoecheon Kim on 12. 7. 9..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//
 
#import "Mocha_FileKit.h"
#import "zlib.h"
#import "zconf.h"

@implementation Mocha_FileKit
@synthesize FileManager;
@synthesize delegate = _delegate;
-(id) init
{
	if( (self=[super init]) )
	{
		FileManager = [NSFileManager defaultManager];
        _zipFile = NULL ;
	}
	return self;
}

-(void) dealloc
{
    [self CloseZipFile2];
}
 


-(BOOL) createDirectoryAtPath:(NSString*) targetPath {
    
    NSFileManager *fileManager;
    fileManager = [NSFileManager defaultManager];

    if ([fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:NO  attributes:nil  error:nil]== NO ) {
        ErLog(@"Fail to create directory");
        return 0;
    }else {
        return 1;
    }
    
}

-(BOOL) fileExistsAtPath:(NSString*) targetPath {
    if ([FileManager fileExistsAtPath:targetPath] == NO) {
        ErLog(@"test.txt file not exist");
        return 0;
    }else {
        return 1;
    }
}
 

-(BOOL) moveFile:(NSString*)fromPath targetpath:(NSString*) targetPath{
    
    if([FileManager moveItemAtPath: @"test" toPath: @"test2" error:nil] == NO) {
        ErLog(@"Fail to move file or directory");
        return 0;
    }else {
        return 1;
    }
}
//fromPath & targetPath file명 단위 
-(BOOL) copyFile:(NSString*)fromPath targetpath:(NSString*) targetPath{
    
    if([FileManager copyItemAtPath:fromPath toPath:targetPath error:nil] == NO) {
        ErLog(@"Fail to copy file or directory");
        return 0;
    }else {
        return 1;
    }
}

//파일삭제
-(BOOL) deleteFile:(NSString *)targetPath{
    
    if([FileManager removeItemAtPath: @"re_test.txt" error:nil] == NO) {
        ErLog(@"Fail to delete file or directory");
        return 0;
    }else {
        return 1;
    }
}
//targetPath경로의 파일목록 리턴 
/*  파일을 생성일자 순으로 소팅하기... & 날짜, 파일사이즈 출력형태 조정 by vic.
 */


-(NSArray *) dirFileNameList:(NSString *)targetPath;
{
      
    NSError* error = nil;
    NSArray* filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:targetPath error:&error];
    if(error != nil) {
        NSLog(@"경로 오픈 Error : %@", error);
    }
    
    NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[filesArray count]];
    for(NSString* file in filesArray) {
        NSString* filePath = [targetPath stringByAppendingPathComponent:file];
        NSDictionary* properties = [[NSFileManager defaultManager]
                                    attributesOfItemAtPath:filePath
                                    error:&error];
        NSDate* modDate = [properties objectForKey:NSFileModificationDate];
        
        // tableView에 출력할 내용 변경
        // 제목 아래 상세내용: 원래 cellForRowAtIndexPath에서 처리되었으나 performance를 위해 한꺼번에 처리...
        // 파일size 가져오기
        NSInteger fileSize = [[properties objectForKey:NSFileSize] intValue];
        
        NSString* formattedFileSize = [NSString stringWithFormat:@"%ld",(long)fileSize];
        
        
        // 최종수정일자 가져오기
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd HH:mm"];
        
        NSDate *fileDate = [properties objectForKey:NSFileModificationDate];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:fileDate];
        // 여기까지
        
        //NSString* fileSize = [properties objectForKey:NSFileSize];
        NSString* fileType = [properties objectForKey:NSFileType];
        
        if(error == nil)
        {
            [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           file, @"path",
                                           modDate, @"lastModDate",
                                           formattedDateString, @"formattedModDate", 
                                           formattedFileSize, @"formatedFileSize",
                                           fileType, @"fileType",
                                           nil]];                 
        }
    }
    
    NSArray* sortedFiles =  [filesAndProperties sortedArrayUsingComparator:
                             ^(id path1, id path2)
                             {                               
                                 // 비교 
                                 NSComparisonResult comp = [[path1 objectForKey:@"lastModDate"] compare:
                                                            [path2 objectForKey:@"lastModDate"]];
                                 // 순서 재조정
                                 if (comp == NSOrderedDescending) {
                                     comp = NSOrderedAscending;
                                 }
                                 else if(comp == NSOrderedAscending){
                                     comp = NSOrderedDescending;
                                 }
                                 return comp;                                
                             }];
    
    return sortedFiles;
}



-(NSArray *) dirSimpleFileNameList:(NSString *)targetPath;
{
    
    
    //NSFileManager *fm = [NSFileManager defaultManager]; 
   // NSArray *tmpFileList = [NSArray array];
    
    //tmpFileList = [FileManager subpathsAtPath:targetPath];
    
    return  [FileManager subpathsAtPath:targetPath];
    /*
    for (int inx = 0; inx < [tmpFileList count]; inx++) {
        NSString *fileName = [tmpFileList objectAtIndex:inx];
        NSRange findRange1 = [fileName rangeOfString:@"dddd"];
        NSRange findRange2 = [fileName rangeOfString:@".zip"];
        if (NSEqualRanges(findRange1, NSMakeRange(0, 9))
            && NSEqualRanges(findRange2, NSMakeRange([fileName length]-4, 4)))
        {
            NSString *backupFilePath = [NSString stringWithFormat:@"%@/%@", docPath, fileName];
            [fm removeItemAtPath:backupFilePath error:nil];
        }
    }
    
    */



}

















//ZIP 관련

-(BOOL) CreateZipFile2:(NSString*) zipFile
{
	_zipFile = zipOpen( (const char*)[zipFile UTF8String], 0 );
	if( !_zipFile ) 
		return NO;
	return YES;
}

-(BOOL) CreateZipFile2:(NSString*) zipFile Password:(NSString*) password
{
	_password = password;
	return [self CreateZipFile2:zipFile];
}

-(BOOL) addFileToZip:(NSString*) file newname:(NSString*) newname;
{
	if( !_zipFile )
		return NO;
	//	tm_zip filetime;
	time_t current;
	time( &current );
	
	zip_fileinfo zipInfo = {0};
	//	zipInfo.dosDate = (unsigned long) current;
    
	//Warning 수정.
	NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
	//NSDictionary* attr = [[NSFileManager defaultManager] fileAttributesAtPath:file traverseLink:YES];
	if( attr )
	{
		NSDate* fileDate = (NSDate*)[attr objectForKey:NSFileModificationDate];
		if( fileDate )
		{
			// some application does use dosDate, but tmz_date instead
			//	zipInfo.dosDate = [fileDate timeIntervalSinceDate:[self Date1980] ];
			NSCalendar* currCalendar = [NSCalendar currentCalendar];
			uint flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | 
			NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
			NSDateComponents* dc = [currCalendar components:flags fromDate:fileDate];
			zipInfo.tmz_date.tm_sec = (unsigned int)[dc second];
			zipInfo.tmz_date.tm_min = (unsigned int)[dc minute];
			zipInfo.tmz_date.tm_hour = (unsigned int)[dc hour];
			zipInfo.tmz_date.tm_mday = (unsigned int)[dc day];
			zipInfo.tmz_date.tm_mon = (unsigned int)[dc month] - 1;
			zipInfo.tmz_date.tm_year = (unsigned int)[dc year];
		}
	}
	
	int ret ;
	NSData* data = nil;
	if( [_password length] == 0 )
	{
		ret = zipOpenNewFileInZip( _zipFile,
								  (const char*) [newname UTF8String],
								  &zipInfo,
								  NULL,0,
								  NULL,0,
								  NULL,//comment
								  Z_DEFLATED,
								  Z_DEFAULT_COMPRESSION );
	}
	else
	{
		data = [ NSData dataWithContentsOfFile:file];
		uLong crcValue = crc32( 0L,NULL, 0L );
		crcValue = crc32( crcValue, (const Bytef*)[data bytes], (unsigned int)[data length] );
		ret = zipOpenNewFileInZip3( _zipFile,
								   (const char*) [newname UTF8String],
								   &zipInfo,
								   NULL,0,
								   NULL,0,
								   NULL,//comment
								   Z_DEFLATED,
								   Z_DEFAULT_COMPRESSION,
								   0,
								   15,
								   8,
								   Z_DEFAULT_STRATEGY,
								   [_password cStringUsingEncoding:NSASCIIStringEncoding],
								   crcValue );
	}
	if( ret!=Z_OK )
	{
		return NO;
	}
	if( data==nil )
	{
		data = [ NSData dataWithContentsOfFile:file];
	}
	unsigned int dataLen = (unsigned int)[data length];
	ret = zipWriteInFileInZip( _zipFile, (const void*)[data bytes], dataLen);
	if( ret!=Z_OK )
	{
		return NO;
	}
	ret = zipCloseFileInZip( _zipFile );
	if( ret!=Z_OK )
		return NO;
	return YES;
}

-(BOOL) CloseZipFile2
{
	_password = nil;
	if( _zipFile==NULL )
		return NO;
	BOOL ret =  zipClose( _zipFile,NULL )==Z_OK?YES:NO;
	_zipFile = NULL;
	return ret;
}

-(BOOL) UnzipOpenFile:(NSString*) zipFile
{
	_unzFile = unzOpen( (const char*)[zipFile UTF8String] );
	if( _unzFile )
	{
		unz_global_info  globalInfo = {0};
		if( unzGetGlobalInfo(_unzFile, &globalInfo )==UNZ_OK )
		{	
			//NSString *log = [NSString stringWithFormat:@"%ld entries in the zip file",globalInfo.number_entry];
            //NSLog(@"%@",log);
		}
	}
	BOOL bRet = (_unzFile!=NULL);
	return bRet;
}

-(BOOL) UnzipOpenFile:(NSString*) zipFile Password:(NSString*) password
{
	_password = password;
	return [self UnzipOpenFile:zipFile];
}

-(BOOL) UnzipFileTo:(NSString*) path overWrite:(BOOL) overwrite
{
	BOOL success = YES;
	int ret = unzGoToFirstFile( _unzFile );
	unsigned char		buffer[4096] = {0};
	NSFileManager* fman = [NSFileManager defaultManager];
	if( ret!=UNZ_OK )
	{
		[self OutputErrorMessage:@"Failed"];
	}
	
	do{
		if( [_password length]==0 )
			ret = unzOpenCurrentFile( _unzFile );
		else
			ret = unzOpenCurrentFilePassword( _unzFile, [_password cStringUsingEncoding:NSASCIIStringEncoding] );
		if( ret!=UNZ_OK )
		{
			[self OutputErrorMessage:@"Error occurs"];
			success = NO;
			break;
		}
		// reading data and write to file
		int read ;
		unz_file_info	fileInfo ={0};
		ret = unzGetCurrentFileInfo(_unzFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if( ret!=UNZ_OK )
		{
			[self OutputErrorMessage:@"Error occurs while getting file info"];
			success = NO;
			unzCloseCurrentFile( _unzFile );
			break;
		}
		char* filename = (char*) malloc( fileInfo.size_filename +1 );
		unzGetCurrentFileInfo(_unzFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		filename[fileInfo.size_filename] = '\0';
		
		// check if it contains directory
		NSString * strPath = [NSString  stringWithCString:filename encoding:NSUTF8StringEncoding];
		//NSString * strPath = [NSString  stringWithCString:filename];
		BOOL isDirectory = NO;
		if( filename[fileInfo.size_filename-1]=='/' || filename[fileInfo.size_filename-1]=='\\')
			isDirectory = YES;
		free( filename );
		if( [strPath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location!=NSNotFound )
		{// contains a path
			strPath = [strPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		}
		NSString* fullPath = [path stringByAppendingPathComponent:strPath];
		
		if( isDirectory )
			[fman createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
		else
			[fman createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
		if( [fman fileExistsAtPath:fullPath] && !isDirectory && !overwrite )
		{
			if( ![self OverWrite:fullPath] )
			{
				unzCloseCurrentFile( _unzFile );
				ret = unzGoToNextFile( _unzFile );
				continue;
			}
		}
		FILE* fp = fopen( (const char*)[fullPath UTF8String], "wb");
		while( fp )
		{
			read=unzReadCurrentFile(_unzFile, buffer, 4096);
			if( read > 0 )
			{
				fwrite(buffer, read, 1, fp );
			}
			else if( read<0 )
			{
				[self OutputErrorMessage:@"Failed to reading zip file"];
				break;
			}
			else 
				break;				
		}
		if( fp )
		{
			fclose( fp );
			// set the orignal datetime property
			NSDate* orgDate = nil;
			
			//{{ thanks to brad.eaton for the solution
			NSDateComponents *dc = [[NSDateComponents alloc] init];
			
			dc.second = fileInfo.tmu_date.tm_sec;
			dc.minute = fileInfo.tmu_date.tm_min;
			dc.hour = fileInfo.tmu_date.tm_hour;
			dc.day = fileInfo.tmu_date.tm_mday;
			dc.month = fileInfo.tmu_date.tm_mon+1;
			dc.year = fileInfo.tmu_date.tm_year;
			
			NSCalendar *gregorian = [[NSCalendar alloc] 
									 initWithCalendarIdentifier:NSGregorianCalendar];
			
			orgDate = [gregorian dateFromComponents:dc] ;
			//}}
			
			
			NSDictionary* attr = [NSDictionary dictionaryWithObject:orgDate forKey:NSFileModificationDate]; //[[NSFileManager defaultManager] fileAttributesAtPath:fullPath traverseLink:YES];
			if( attr )
			{
				//		[attr  setValue:orgDate forKey:NSFileCreationDate];
				if( ![[NSFileManager defaultManager] setAttributes:attr ofItemAtPath:fullPath error:nil] )
				{
					// cann't set attributes 
					NSLog(@"Failed to set attributes");
				}
				
			}
			
			
			
		}
		unzCloseCurrentFile( _unzFile );
		ret = unzGoToNextFile( _unzFile );
	}while( ret==UNZ_OK && UNZ_OK!=UNZ_END_OF_LIST_OF_FILE );
	return success;
}

-(BOOL) UnzipCloseFile
{
	_password = nil;
	if( _unzFile )
		return unzClose( _unzFile )==UNZ_OK;
	return YES;
}

#pragma mark wrapper for delegate
-(void) OutputErrorMessage:(NSString*) msg
{
    if( _delegate && [_delegate respondsToSelector:@selector(ErrorMessage:)] )
		[_delegate ErrorMessage:msg];
}

-(BOOL) OverWrite:(NSString*) file
{
    if( _delegate && [_delegate respondsToSelector:@selector(OverWriteOperation:)] )
		return [_delegate OverWriteOperation:file];
	return YES;
}

#pragma mark get NSDate object for 1980-01-01
-(NSDate*) Date1980
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:1];
	[comps setMonth:1];
	[comps setYear:1980];
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	
	return date;
}

@end
