#import <Foundation/Foundation.h>

#import "AmailSBJsonParser.h"
#import "AmailSBJsonWriter.h"
@interface AmailSBJSON : AmailSBJsonBase <AmailSBJsonParser, AmailSBJsonWriter> {
@private    
    AmailSBJsonParser *jsonParser;
    AmailSBJsonWriter *jsonWriter;
}
- (id)fragmentWithString:(NSString*)jsonrep error:(NSError**)error;
- (id)objectWithString:(NSString*)jsonrep error:(NSError**)error;
- (id)objectWithString:(id)value allowScalar:(BOOL)x error:(NSError**)error;
- (NSString*)stringWithObject:(id)value error:(NSError**)error;
- (NSString*)stringWithFragment:(id)value error:(NSError**)error;
- (NSString*)stringWithObject:(id)value allowScalar:(BOOL)x error:(NSError**)error;
@end
