//
//  Apptimize+Variables+Macros.h
//  Apptimize
//
//  Created by George Wright on 2017-05-09.
//  Copyright © 2017 Apptimize, Inc. All rights reserved.
//

#ifndef Apptimize_Variables_Macros_h
#define Apptimize_Variables_Macros_h

#define ApptimizeString(_name, _value)  _Pragma("GCC warning \"'ApptimizeString' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSString*, String, ,string,_value)
#define ApptimizeInt(_name, _value)     _Pragma("GCC warning \"'ApptimizeInt' macro is deprecated\"") _ApptimizeVariableDefinition(_name, Integer) _ApptimizeVariableInitializer(_name, Integer, , integer, [default_ intValue], default_ = _Generic(_value, \
int:           @(_value), \
unsigned int:  @(_value), \
long:          @(_value), \
unsigned long: @(_value)))
#define ApptimizeDouble(_name, _value)  _Pragma("GCC warning \"'ApptimizeDouble' macro is deprecated\"") _ApptimizeVariableDefinition(_name, Double) _ApptimizeVariableInitializer(_name, Double, ,double, [default_ doubleValue], default_ = _Generic(_value, \
float:  @(_value), \
double: @(_value)))
#define ApptimizeBoolean(_name, _value) _Pragma("GCC warning \"'ApptimizeBoolean' macro is deprecated\"") _ApptimizeVariableDefinition(_name, Bool) _ApptimizeVariableInitializer(_name, Bool, , bool, [default_ boolValue], default_ = _Generic(_value, BOOL: @(_value)))

#define ApptimizeArrayOfStrings(_name, ...)       _Pragma("GCC warning \"'ApptimizeArrayOfStrings' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      Array, s,stringArray, __VA_ARGS__)
#define ApptimizeDictionaryOfStrings(_name, ...)  _Pragma("GCC warning \"'ApptimizeDictionaryOfStrings' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, Dictionary, s,stringDictionary, __VA_ARGS__)
#define ApptimizeArrayOfInts(_name, ...)          _Pragma("GCC warning \"'ApptimizeArrayOfInts' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      Array, i,integerArray, __VA_ARGS__)
#define ApptimizeDictionaryOfInts(_name, ...)     _Pragma("GCC warning \"'ApptimizeDictionaryOfInts' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, Dictionary, i,integerDictionary, __VA_ARGS__)
#define ApptimizeArrayOfDoubles(_name, ...)       _Pragma("GCC warning \"'ApptimizeArrayOfDoubles' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      Array, d,doubleArray, __VA_ARGS__)
#define ApptimizeDictionaryOfDoubles(_name, ...)  _Pragma("GCC warning \"'ApptimizeDictionaryOfDoubles' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, Dictionary, d,doubleDictionary, __VA_ARGS__)
#define ApptimizeArrayOfBooleans(_name, ...)      _Pragma("GCC warning \"'ApptimizeArrayOfBooleans' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSArray*,      Array, b,boolArray, __VA_ARGS__)
#define ApptimizeDictionaryOfBooleans(_name, ...) _Pragma("GCC warning \"'ApptimizeDictionaryOfBooleans' macro is deprecated\"") _ApptimizeEnsuredObjectTypeVariable(_name, NSDictionary*, Dictionary, b,boolDictionary, __VA_ARGS__)

// The following are for internal use only
#define _ApptimizeEnsuredObjectTypeVariable(_name, _ensuredType, _type, _subtype, _method, ...) _ApptimizeVariableDefinition(_name, _type) _ApptimizeVariableInitializer(_name, _type, _subtype, _method, default_, default_ = _Generic((__VA_ARGS__), _ensuredType: (__VA_ARGS__), void*: nil))

#define _ApptimizeVariableDefinition(_name, _type) __attribute__((unused)) ApptimizeVariable ## _type * _name = nil;
#define _ApptimizeVariableInitializer(_name, _type, _subtype, _method, _def, ...) \
static void __attribute__((constructor,deprecated)) _atz_var_init ## _name () { \
__attribute__((used,unused)) static __strong id default_ = NULL; \
__VA_ARGS__;\
_name = [ApptimizeVariable _method ## WithName:@#_name andDefault ## _type: _def];\
}


#endif /* Apptimize_Variables_Macros_h */
