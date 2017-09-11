//
//  YGHTMLAttribute.m
//  YGHTML
//
//  Created by Ян on 21/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLAttribute.h"

@implementation YGHTMLAttribute

/**
 Basic init for creating tag attribute. No value mean empty string. 
 
 - name: name of attribute
 
 - value: value of attribute, no value is empty string
 
 - return: self
 */
- (instancetype) initWithName:(NSString *)name value:(NSString *)value{
    self = [super init];
    if(self){
        _name = name;
        if(value != nil)
            _value = value;
        else
            _value = @"";
    }
    return self;
}

/**
 Init for attribute without value - only name. Value is @"".
 
 - name: name of attribute
 
 */
- (instancetype) initWithName:(NSString *)name{
    return [self initWithName:name value:@""];
}


/**
 String of all attribute. For example: @"id=\"note-info\""
 
 - return: string of attribute
 */
- (NSString *) string{
    return [NSString stringWithFormat:@"%@=\"%@\"", self.name, self.value];
}

/**
 Parse of open tag string to array of attributes.
 
 - string: string of open tag
 
 - return: array of YGHTMLAttribute objects
 */
+ (NSArray<YGHTMLAttribute *>*)parseOpenTagForAttributes:(NSString *)string{
    
    NSMutableArray<YGHTMLAttribute *> *attributes = [[NSMutableArray alloc] init];
    unichar curCh = 0;
    NSMutableString *name = [[NSMutableString alloc] init];
    NSMutableString *value = [[NSMutableString alloc] init];
    
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    string = [string stringByTrimmingCharactersInSet:set];

    BOOL isTagSequence = NO, isNameSequence = NO, isValueSequence = NO, isEqualSequence = NO;
    
    for(NSUInteger i = 0; i < [string length]; i++){
        
        curCh = [string characterAtIndex:i];
        
        if(i == 0 && curCh != '<'){
            isNameSequence = YES;
            isTagSequence = NO;
            [name appendFormat:@"%C", curCh];
        }
        else if(curCh == '<'){
            isTagSequence = YES;
        }
        else if(isTagSequence && curCh == ' '){
            isTagSequence = NO;
            isNameSequence = YES;
        }
        else if(curCh == '='){
            isNameSequence = NO;
            isValueSequence = NO;
            isEqualSequence = YES;
        }
        else if(curCh == '"'){
            if(isEqualSequence){
                isValueSequence = YES;
                isEqualSequence = NO;
            }
            else if(isValueSequence){
                isValueSequence = NO;
                
                // value is! create new attribute and add to array
                YGHTMLAttribute *attribute = [[YGHTMLAttribute alloc] initWithName:name value:value];
                [attributes addObject:attribute];
                name = [@"" mutableCopy];
                value = [@"" mutableCopy];
            }
        }
        else if(!isValueSequence && curCh == ' '){
            isNameSequence = YES;
        }
        else if(isValueSequence){
            [value appendFormat:@"%C", curCh];
        }
        else if(isNameSequence){
            [name appendFormat:@"%C", curCh];
        }
        
    }
    return [attributes copy];
}

@end
