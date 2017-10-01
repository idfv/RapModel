//
//  RapModel.m
//
//  Created by RapKit on 14/10/24.
//  Copyright (c) 2014年 RapKit. All rights reserved.
//

#import "RapModel.h"

#import <objc/runtime.h>

#ifdef __OPTIMIZE__
#define NSLog(...)
#endif

@implementation NSString (CharValue)

- (BOOL)charValue
{
    NSLog(@"<%@ charValue>", self.class);
    return [self boolValue];
}

@end

@interface RapModel ()

@property (nonatomic, strong) NSMutableDictionary *propertyCheckMDic;

@end

@implementation RapModel

#pragma mark - Init
- (instancetype)init
{
    if (self = [super init]) {
        [self getPropertiesForPropertyCheckDic];
    }
    
    return self;
}

#pragma mark - GetCheckDic
/*
 @property (nonatomic, copy) NSString *testStr;
 
 property_getName(property)                 -> testStr
 property_getAttributes(property)           -> T@"NSString",C,N,V_testStr
 property_copyAttributeValue(property, "V") -> _testStr
 property_copyAttributeValue(property, "T") -> @"NSString"
 */

- (void)getPropertiesForPropertyCheckDic
{
    self.propertyCheckMDic = [NSMutableDictionary dictionary];
    
    unsigned int outCnt;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCnt);
    
    for (unsigned int i = 0; i < outCnt; i++) {
        objc_property_t property = properties[i];
        
        const char  *propertyName   = property_getName(property);
        NSString    *propertyNSName = [NSString stringWithUTF8String:propertyName];
        char        *propertyAttr   = property_copyAttributeValue(property, "T");
        NSString    *propertyNSAttr = [NSString stringWithUTF8String:propertyAttr];
        
        Class propertyClass = nil;
        
        if ((strlen(propertyName) > 0) && (strlen(propertyAttr) > 0)) {
            switch (propertyAttr[0]) {
                case '@': {
                    if (propertyNSAttr.length > 3) {
                        propertyClass = NSClassFromString([propertyNSAttr substringWithRange:NSMakeRange(2, propertyNSAttr.length - 3)]);
                    }
                }
                    break;
                case 'c':
                case 'i':
                case 's':
                case 'l':
                case 'q':
                case 'C':
                case 'I':
                case 'S':
                case 'L':
                case 'Q':
                case 'f':
                case 'd':
                case 'B': {
                    propertyClass = [NSNumber class];
                }
                    break;
                case '{': {
                    propertyClass = [NSValue class];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        if ((propertyClass != nil) && (propertyNSName.length > 0)) {
            [self.propertyCheckMDic setValue:propertyClass forKey:propertyNSName];
        }else{
            NSLog(@"<%@> Unsupported key: [%@] class: [%@].", self.class, propertyNSName, propertyClass);
        }
        
        free(propertyAttr);
    }
    
    if (outCnt != (unsigned int)_propertyCheckMDic.count) {
        NSLog(@"<%@> Property check dic count: [%d] != self class properties count: [%d].", self.class, (unsigned int)_propertyCheckMDic.count, outCnt);
    }
    
    free(properties);
}

#pragma mark - SetValueAndCheckClass
- (void)setValue:(id)value forKey:(NSString *)key checkWithClass:(Class)desiredClass
{
    if ((key == nil) || (desiredClass == nil)) {
        NSLog(@"<%@> Set value for nil key: [%@] or nil class: [%@].", self.class, key, desiredClass);
        return;
    }
    
    if ([value isKindOfClass:desiredClass] ||
        ([value isKindOfClass:[NSString class]] && (desiredClass == [NSNumber class]))) {
        // Equal
        // NSString to NSNumber
        [super setValue:value forKey:key];
    }else if ((desiredClass == [NSString class]) && [value respondsToSelector:@selector(stringValue)]) {
        // NSNumber to NSString
        [super setValue:[value stringValue] forKey:key];
    }else{
        // (value == [NSNull null]) || (value == nil)
        // Unsupported
        if (desiredClass == [NSNumber class]) {
            [super setValue:@0 forKey:key];
        }else{
            [super setValue:nil forKey:key];
        }
        
        if ((value != [NSNull null]) && (value != nil)) {
            NSLog(@"<%@> Set wrong value: [%@][%@] for key: [%@], desired class: [%@].", self.class, value, [value class], key, desiredClass);
        }
    }
}

#pragma mark - Original
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"<%@> Set value for undefined key: [%@].", self.class, key);
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (![_propertyCheckMDic isKindOfClass:[NSDictionary class]] || (_propertyCheckMDic.count <= 0)) {
        [super setValue:value forKey:key];
    }else{
        [self setValue:value forKey:key checkWithClass:_propertyCheckMDic[key]];
    }
}

#pragma mark -

@end
