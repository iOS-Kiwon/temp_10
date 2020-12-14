//
//  Apptimize+Variables.h
//  Apptimize 3.3.0
//
//  Copyright (c) 2014 Apptimize, Inc. All rights reserved.
//

#ifndef Apptimize_Apptimize_Variables_h
#define Apptimize_Apptimize_Variables_h

#import <Foundation/NSObject.h>
#import <Foundation/NSString.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSArray.h>

#import "Apptimize+Variables+Macros.h"

// Please see the documentation at http://apptimize.com/docs/advanced-functionality/dynamic-variables

@class ApptimizeVariableString;
@class ApptimizeVariableBool;
@class ApptimizeVariableInteger;
@class ApptimizeVariableDouble;
@class ApptimizeVariableArray<__covariant ContainedType>;
@class ApptimizeVariableDictionary<__covariant ContainedType>;

/**
 * This interface is used to create and retrieve dynamic variables.
 *
 * The factory methods are used to create and register dynamic variables with the SDK. As they need to be declared prior
 * to setting up an experiment, they should be called as early as possible during app execution, such as in
 * `didFinishLaunchingWithOptions`.
 *
 * All the factory methods return a reference to the created dynamic variable.
 *
 * As dynamic variables are expected to be declared ahead of time during app startup, getters are provided to retrieve those
 * dynamic variables at time of use.
 */
@interface ApptimizeVariable : NSObject
/**
 * @name Factory methods
 */

/**
 * Create a string dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getStringForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultString The default NSString for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableString if no variable has been created before with this name. If an ApptimizeVariableString
 *         already exists with this name it returns the existing string variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableString* _Nullable)stringWithName:(NSString* _Nonnull)name andDefaultString:(NSString* _Nonnull)defaultString
    NS_SWIFT_NAME(makeString(name:defaultString:));

/**
 * Create a bool dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getBoolForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultBool The default BOOL for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableBool if no variable has been created before with this name. If an ApptimizeVariableBool
 *         already exists with this name it returns the existing bool variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableBool* _Nullable)boolWithName:(NSString* _Nonnull)name andDefaultBool:(BOOL)defaultBool
    NS_SWIFT_NAME(makeBool(name:defaultBool:));

/**
 * Create a bool dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getBoolForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultNumber The default NSNumber (containing a BOOL) for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableBool if no variable has been created before with this name. If an ApptimizeVariableBool
 *         already exists with this name it returns the existing bool variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableBool* _Nullable)boolWithName:(NSString* _Nonnull)name andDefaultNumber:(NSNumber* _Nonnull)defaultNumber
    NS_SWIFT_NAME(makeBool(name:defaultNumber:));

/**
 * Create an integer dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getIntegerForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultInteger The default NSInteger for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableInteger if no variable has been created before with this name. If an ApptimizeVariableInteger
 *         already exists with this name it returns the existing integer variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableInteger* _Nullable)integerWithName:(NSString* _Nonnull)name andDefaultInteger:(NSInteger)defaultInteger
    NS_SWIFT_NAME(makeInteger(name:defaultInteger:));

/**
 * Create an integer dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getIntegerForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultUnsignedInteger The default NSUInteger for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableInteger if no variable has been created before with this name. If an ApptimizeVariableInteger
 *         already exists with this name it returns the existing integer variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableInteger* _Nullable)integerWithName:(NSString* _Nonnull)name andDefaultUnsignedInteger:(NSUInteger)defaultUnsignedInteger
    NS_SWIFT_NAME(makeInteger(name:defaultUnsignedInteger:));

/**
 * Create an integer dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getIntegerForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultNumber The default NSNumber (containing an NSInteger or NSUInteger) for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableInteger if no variable has been created before with this name. If an ApptimizeVariableInteger
 *         already exists with this name it returns the existing integer variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableInteger* _Nullable)integerWithName:(NSString* _Nonnull)name andDefaultNumber:(NSNumber* _Nonnull)defaultNumber
    NS_SWIFT_NAME(makeInteger(name:defaultNumber:));

/**
 * Create a double dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getDoubleForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultDouble The default double for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableDouble if no variable has been created before with this name. If an ApptimizeVariableDouble
 *         already exists with this name it returns the existing double variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableDouble* _Nullable)doubleWithName:(NSString* _Nonnull)name andDefaultDouble:(double)defaultDouble
    NS_SWIFT_NAME(makeDouble(name:defaultDouble:));

/**
 * Create a double dynamic variable with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getDoubleForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultNumber The default NSNumber (containing a double) for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableDouble if no variable has been created before with this name. If an ApptimizeVariableDouble
 *         already exists with this name it returns the existing double variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableDouble* _Nullable)doubleWithName:(NSString* _Nonnull)name andDefaultNumber:(NSNumber* _Nonnull)defaultNumber
    NS_SWIFT_NAME(makeDouble(name:defaultNumber:));

/**
 * Create a dynamic variable of an array containing strings with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getStringArrayForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultStringArray The default NSArray (containing NSStrings) for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableArray if no variable has been created before with this name. If an ApptimizeVariableArray
 *         containing strings already exists with this name it returns the existing string array variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableArray<NSString*>* _Nullable)stringArrayWithName:(NSString* _Nonnull)name andDefaultArray:(NSArray<NSString*>* _Nonnull)defaultStringArray
    NS_SWIFT_NAME(makeStringArray(name:defaultStringArray:));

/**
 * Create a dynamic variable of an array containing bools with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getBoolArrayForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultBoolArray The default NSArray (containing NSNumbers of BOOLs) for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableArray if no variable has been created before with this name. If an ApptimizeVariableArray
 *         containing bools already exists with this name it returns the existing bool array variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableArray<NSNumber*>* _Nullable)boolArrayWithName:(NSString* _Nonnull)name andDefaultArray:(NSArray<NSNumber*>* _Nonnull)defaultBoolArray
    NS_SWIFT_NAME(makeBoolArray(name:defaultBoolArray:));

/**
 * Create a dynamic variable of an array containing integers with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getIntegerArrayForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultIntegerArray The default NSArray (containing NSNumbers of integers) for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableArray if no variable has been created before with this name. If an ApptimizeVariableArray
 *         containing integers already exists with this name it returns the existing integer array variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableArray<NSNumber*>* _Nullable)integerArrayWithName:(NSString* _Nonnull)name andDefaultArray:(NSArray<NSNumber*>* _Nonnull)defaultIntegerArray
    NS_SWIFT_NAME(makeIntegerArray(name:defaultIntegerArray:));

/**
 * Create a dynamic variable of an array containing doubles with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getDoubleArrayForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultDoubleArray The default NSArray (containing NSNumbers of doubles) for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableArray if no variable has been created before with this name. If an ApptimizeVariableArray
 *         containing doubles already exists with this name it returns the existing double array variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableArray<NSNumber*>* _Nullable)doubleArrayWithName:(NSString* _Nonnull)name andDefaultArray:(NSArray<NSNumber*>* _Nonnull)defaultDoubleArray
    NS_SWIFT_NAME(makeDoubleArray(name:defaultDoubleArray:));

/**
 * Create a dynamic variable of an dictionary with key/value pairs of string/string with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getStringDictionaryForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultStringDictionary The default NSDictionary of NSStrings keyed with NSStrings for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableDictionary if no variable has been created before with this name. If an ApptimizeVariableDictionary
 *         containing strings already exists with this name it returns the existing string dictionary variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableDictionary<NSString*>* _Nullable)stringDictionaryWithName:(NSString* _Nonnull)name andDefaultDictionary:(NSDictionary<NSString*,NSString*>* _Nonnull)defaultStringDictionary
    NS_SWIFT_NAME(makeStringDictionary(name:defaultStringDictionary:));

/**
 * Create a dynamic variable of an dictionary with key/value pairs of string/bool with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getBoolDictionaryForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultBoolDictionary The default NSDictionary of NSNumbers (containing BOOLs) keyed with NSStrings for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableDictionary if no variable has been created before with this name. If an ApptimizeVariableDictionary
 *         containing bools already exists with this name it returns the existing bool dictionary variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableDictionary<NSNumber*>* _Nullable)boolDictionaryWithName:(NSString* _Nonnull)name andDefaultDictionary:(NSDictionary<NSString*,NSNumber*>* _Nonnull)defaultBoolDictionary
    NS_SWIFT_NAME(makeBoolDictionary(name:defaultBoolDictionary:));

/**
 * Create a dynamic variable of an dictionary with key/value pairs of string/integer with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getIntegerDictionaryForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultIntegerDictionary The default NSDictionary of NSNumbers (containing integers) keyed with NSStrings for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableDictionary if no variable has been created before with this name. If an ApptimizeVariableDictionary
 *         containing integers already exists with this name it returns the existing integer dictionary variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableDictionary<NSNumber*>* _Nullable)integerDictionaryWithName:(NSString* _Nonnull)name andDefaultDictionary:(NSDictionary<NSString*,NSNumber*>* _Nonnull)defaultIntegerDictionary
    NS_SWIFT_NAME(makeIntegerDictionary(name:defaultIntegerDictionary:));

/**
 * Create a dynamic variable of an dictionary with key/value pairs of string/double with a specified name and default value.
 *
 * @see `+[ApptimizeVariable getDoubleDictionaryForName:]`
 *
 * @param name The name of the dynamic variable to create.
 * @param defaultDoubleDictionary The default NSDictionary of NSNumbers (containing doubles) keyed with NSStrings for this dynamic variable.
 *
 * @return Returns a new ApptimizeVariableDictionary if no variable has been created before with this name. If an ApptimizeVariableDictionary
 *         containing doubles already exists with this name it returns the existing double dictionary variable but does not update the default value.  
 *         Returns nil if a variable of another type already exists with this name.
 */
+ (ApptimizeVariableDictionary<NSNumber*>* _Nullable)doubleDictionaryWithName:(NSString* _Nonnull)name andDefaultDictionary:(NSDictionary<NSString*,NSNumber*>* _Nonnull)defaultDoubleDictionary
    NS_SWIFT_NAME(makeDoubleDictionary(name:defaultDoubleDictionary:));

/**
 * @name Getters
 */

/**
 * Retrieve a string dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable stringWithName:andDefaultString:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableString if one has already been created with the specified name.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableString* _Nullable)getStringForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getString(name:));

/**
 * Retrieve a bool dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable boolWithName:andDefaultBool:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableBool if one has already been created with the specified name.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableBool* _Nullable)getBoolForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getBool(name:));

/**
 * Retrieve an integer dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable integerWithName:andDefaultInteger:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableInteger if one has already been created with the specified name.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableInteger* _Nullable)getIntegerForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getInteger(name:));

/**
 * Retrieve a double dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable doubleWithName:andDefaultDouble:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableDouble if one has already been created with the specified name.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableDouble* _Nullable)getDoubleForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getDouble(name:));

/**
 * Retrieve a string array dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable stringArrayWithName:andDefaultStringArray:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableArray if one has already been created with the specified name which contains strings.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableArray<NSString*>* _Nullable)getStringArrayForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getStringArray(name:));

/**
 * Retrieve a bool array dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable boolArrayWithName:andDefaultBoolArray:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableArray if one has already been created with the specified name which contains bools.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableArray<NSNumber*>* _Nullable)getBoolArrayForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getBoolArray(name:));

/**
 * Retrieve a integer array dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable integerArrayWithName:andDefaultIntegerArray:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableArray if one has already been created with the specified name which contains integers.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableArray<NSNumber*>* _Nullable)getIntegerArrayForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getIntegerArray(name:));

/**
 * Retrieve a double array dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable doubleArrayWithName:andDefaultDoubleArray:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableArray if one has already been created with the specified name which contains doubles.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableArray<NSNumber*>* _Nullable)getDoubleArrayForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getDoubleArray(name:));

/**
 * Retrieve a string dictionary dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable stringDictionaryWithName:andDefaultStringDictionary:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableDictionary if one has already been created with the specified name which contains strings.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableDictionary<NSString*>* _Nullable)getStringDictionaryForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getStringDictionary(name:));

/**
 * Retrieve a bool dictionary dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable boolDictionaryWithName:andDefaultBoolDictionary:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableDictionary if one has already been created with the specified name which contains bools.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableDictionary<NSNumber*>* _Nullable)getBoolDictionaryForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getBoolDictionary(name:));

/**
 * Retrieve an integer dictionary dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable integerDictionaryWithName:andDefaultIntegerDictionary:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableDictionary if one has already been created with the specified name which contains integers.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableDictionary<NSNumber*>* _Nullable)getIntegerDictionaryForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getIntegerDictionary(name:));

/**
 * Retrieve a double dictionary dynamic variable that has already been declared.
 *
 * @see `+[ApptimizeVariable doubleDictionaryWithName:andDefaultDoubleDictionary:]`
 *
 * @param name The name of the dynamic variable to retrieve.
 *
 * @return Returns an ApptimizeVariableDictionary if one has already been created with the specified name which contains doubles.  
 *         Returns nil if no such variable exists with this name.
 */
+ (ApptimizeVariableDictionary<NSNumber*>* _Nullable)getDoubleDictionaryForName:(NSString* _Nonnull)name
    NS_SWIFT_NAME(getDoubleDictionary(name:));

@end

/**
 * ApptimizeVariableString is a dynamic variable which contains an NSString.
 */
@interface ApptimizeVariableString : ApptimizeVariable

/**
  * Retrieves the string value of this ApptimizeVariableString.
  *
  * @return Returns the default string provided at construction if no variant has been received
  *         from the servers, or the variant string if enrolled in a particular variant.  
  *         Returns the default value if there is an issue with the incoming variant data.
  */
@property (nonatomic, readonly) NSString* _Nullable stringValue;
@end

/**
 * ApptimizeVariableBool is a dynamic variable which contains a bool.
 */
@interface ApptimizeVariableBool : ApptimizeVariable
/**
 * Retrieves the bool value of this ApptimizeVariableBool.
 *
 * @return Returns the default bool provided at construction if no variant has been received
 *         from the servers, or the variant bool if enrolled in a particular variant.  
 *         Returns the default value if there is an issue with the incoming variant data.
 */
@property (nonatomic, readonly) BOOL boolValue;
@end

/**
 * ApptimizeVariableInteger is a dynamic variable which contains a signed or unsigned integer.
 */
@interface ApptimizeVariableInteger : ApptimizeVariable
/**
 * Retrieves the signed integer value of this ApptimizeVariableInteger.
 *
 * @return Returns the default integer provided at construction if no variant has been received
 *         from the servers, or the variant integer if enrolled in a particular variant.  
 *         Returns the default value if there is an issue with the incoming variant data.
 */
@property (nonatomic, readonly) NSInteger integerValue;

/**
 * Retrieves the unsigned integer value of this ApptimizeVariableInteger.
 *
 * @return Returns the default integer provided at construction if no variant has been received
 *         from the servers, or the variant integer if enrolled in a particular variant.  
 *         Returns the default value if there is an issue with the incoming variant data.
 */
@property (nonatomic, readonly) NSUInteger unsignedIntegerValue;
@end

/**
 * ApptimizeVariableDouble is a dynamic variable which contains a double floating point number.
 */
@interface ApptimizeVariableDouble : ApptimizeVariable
/**
 * Retrieves the double value of this ApptimizeVariableDouble.
 *
 * @return Returns the default double provided at construction if no variant has been received
 *         from the servers, or the variant double if enrolled in a particular variant.  
 *         Returns the default value if there is an issue with the incoming variant data.
 */
@property (nonatomic, readonly) double doubleValue;
@end

/**
 * ApptimizeVariableArray is a dynamic variable which contains an array of a specified type
 * (string, bool, integer, double).
 */
@interface ApptimizeVariableArray<__covariant ContainedType> : ApptimizeVariable
/**
 * Retrieves the array of this ApptimizeVariableArray.
 *
 * @return Returns the default array provided at construction if no variant has been received
 *         from the servers, or the variant array if enrolled in a particular variant.  
 *         Returns the default value if there is an issue with the incoming variant data.
 */
@property (nonatomic, readonly) NSArray<ContainedType>* _Nullable arrayValue;
@end

/**
 * ApptimizeVariableDictionary is a dynamic variable which contains a dictionary of values of a
 * specified type (string, bool, integer, double) keyed by strings.
 */
@interface ApptimizeVariableDictionary<__covariant ContainedType> : ApptimizeVariable
/**
 * Retrieves the dictionary of this ApptimizeVariableDictionary.
 *
 * @return Returns the default dictionary provided at construction if no variant has been received
 *         from the servers, or the variant array if enrolled in a particular variant.  
 *         If a variant is returned, none of the key/value pairs from the default will be returned,
 *         even if that key isn't specified in the variant dictionary.  
 *         Returns the default value if there is an issue with the incoming variant data.
 */
@property (nonatomic, readonly) NSDictionary<NSString*,ContainedType>* _Nullable dictionaryValue;
@end

#endif
