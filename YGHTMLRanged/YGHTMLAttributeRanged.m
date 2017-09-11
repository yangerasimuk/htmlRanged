
//
//  YGHTMLAttributeRanged.m
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLAttributeRanged.h"

@implementation YGHTMLAttributeRanged

/**
 Basic init for ranged attribute. Range is inside of tag bounds.
 
 - attribtue: parent attribute
 
 - range: range of attribute in tag bounds
 
 - return: self
 */
- (instancetype) initWithAttribute:(YGHTMLAttribute *)attribute range:(NSRange)range{
    self = [super initWithName:attribute.name value:attribute.value];
    if(self){
        _range = range;
    }
    return self;
}

/**
 Override description message of debug.
 
 - return: string of ranged attribute. For example: @"id=\"note-info\" {5, 14}"
 */
- (NSString *)description{
    return [NSString stringWithFormat:@"%@=%@ {%ld, %ld}", self.name, self.value, _range.location, _range.length];
}

@end
