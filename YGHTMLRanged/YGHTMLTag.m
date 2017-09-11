//
//  YGHTMLTag.m
//  YGHTML
//
//  Created by Ян on 21/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLTag.h"
#import "YGHTMLAttributeRanged.h"

@interface YGHTMLTag()
- (instancetype)initWithName:(NSString *)name attributes:(NSArray<YGHTMLAttribute *>*)attributes isOpen:(BOOL)isOpen isOpenOnly:(BOOL)isOpenOnly;
- (NSArray <YGHTMLAttributeRanged *> *)rangeAttributes:(NSArray <YGHTMLAttribute *> *)attributes;
@end

@implementation YGHTMLTag

-(instancetype)initWithName:(NSString *)name attributes:(NSArray<YGHTMLAttribute *>*)attributes isOpen:(BOOL)isOpen isOpenOnly:(BOOL)isOpenOnly{
    self = [super init];
    if(self){
        _name = [name copy];
        if(attributes != nil){
            _attributes = [[NSArray alloc] init];
            _attributes = [self rangeAttributes:attributes];
        }
        _isOpen = isOpen;
        _isOpenOnly = isOpenOnly;
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name attributes:(NSArray<YGHTMLAttribute *>*)attributes isOpenOnly:(BOOL)isOpenOnly{
    return [self initWithName:name attributes:attributes isOpen:YES isOpenOnly:isOpenOnly];
}

-(instancetype)initWithName:(NSString *)name attributes:(NSArray<YGHTMLAttribute *>*)attributes{
    return [self initWithName:name attributes:attributes isOpen:YES isOpenOnly:NO];
}

-(instancetype)initWithName:(NSString *)name isOpen:(BOOL)isOpen isOpenOnly:(BOOL)isOpenOnly{
    return [self initWithName:name attributes:nil isOpen:isOpen isOpenOnly:isOpenOnly];
}

- (instancetype)initWithName:(NSString *)name isOpen:(BOOL)isOpen{
    BOOL isOpenOnly = NO;
    if(!isOpen)
        isOpenOnly = NO;
    return [self initWithName:name attributes:nil isOpen:isOpen isOpenOnly:isOpenOnly];
}


-(instancetype)initWithName:(NSString *)name{
    return [self initWithName:name attributes:nil isOpen:YES isOpenOnly:NO];
}

- (instancetype)initWithTag:(YGHTMLTag *)tag{
    return [self initWithName:tag.name attributes:tag.attributes isOpen:tag.isOpen isOpenOnly:tag.isOpenOnly];
}

- (YGHTMLTag *)selfTag{
    return self;
}

- (NSArray <YGHTMLAttributeRanged *> *)rangeAttributes:(NSArray <YGHTMLAttribute *> *)attributes {
    
    NSMutableString *resultString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"<%@", _name]];
    NSMutableArray <YGHTMLAttributeRanged *> *resultAttributes = [[NSMutableArray alloc] init];
    
    NSRange range = {NSNotFound, 0};
    YGHTMLAttributeRanged *rangedAttr = nil;
    for(id attr in attributes){
        [resultString appendFormat:@" %@", [attr string]];
        range = [resultString rangeOfString:[attr string]];
        rangedAttr = [[YGHTMLAttributeRanged alloc] initWithAttribute:attr range:range];
        [resultAttributes addObject:rangedAttr];
        
        //NSLog(@"[rangedAttr description]: %@", [rangedAttr description]);
    }
    
    return [resultAttributes copy];
}

- (NSString *) string{
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    if(_isOpen){
        [result appendString:[NSString stringWithFormat:@"<%@", _name]];
        if(_attributes){
            for(id attr in _attributes)
                [result appendFormat:@" %@", [attr string]];
        }
        
        //[result appendString:@" "];
        
        if(_isOpenOnly)
            [result appendString:@" /"];
        [result appendString:@">"];
    }
    else{
        [result appendFormat:@"</%@>", _name];
    }

    return [result copy];
}

@end
