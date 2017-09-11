//
//  YGHTMLTagRanged.m
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLTagRanged.h"

@implementation YGHTMLTagRanged

- (instancetype) initWithTag:(YGHTMLTag *)tag range:(NSRange)range{
    self = [super initWithTag:tag];
    if (self){
        _range = range;
    }
    return self;
}


- (NSString *)nameAndRange{
    return [NSString stringWithFormat:@"%@{%lu,%lu}", self.name, self.range.location, self.range.length];
}

- (NSString *)nameAndRangeAndIsOpen{
    return [NSString stringWithFormat:@"%@{%lu,%lu,%hhd}", self.name, self.range.location, self.range.length, self.isOpen];
}

/*
- (instancetype) initWithName:(NSString *)name range:(NSRange)range isOpen:(BOOL)isOpen{
    YGHTMLTag *tag = [[YGHTMLTag alloc] initWithName:name isOpen:isOpen];
    self = [super initWithName:tag.name];
    if (self){
        _range = range;
    }
    return self;

    
    return [self initWithTag:tag range:range];
}

- (instancetype) initWithName:(NSString *)name range:(NSRange)range{
    YGHTMLTag *tag = [[YGHTMLTag alloc] initWithName:name isOpen:YES];
    return [self initWithTag:tag range:range];
}
 */

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ {%ld, %ld}", self.name, _range.location, _range.length];
}

@end
