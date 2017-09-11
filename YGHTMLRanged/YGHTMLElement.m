//
//  YGHTMLElement.m
//  YGHTML
//
//  Created by Ян on 27/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLElement.h"
#import "YGHTMLAttributeRanged.h"

@implementation YGHTMLElement

- (instancetype)initWithOpenTag:(YGHTMLTag *)openTag closeTag:(YGHTMLTag *)closeTag content:(NSString *)content{
    self = [super init];
    if(self){
        _openTag = openTag;
        _closeTag = closeTag;
        _content = content;
        _name = openTag.name;
    }
    return self;
}

- (instancetype)initWithOpenTag:(YGHTMLTag *)openTag{
    return [self initWithOpenTag:openTag closeTag:nil content:nil];
}

- (NSString *) string{
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    [result appendFormat:@"%@", [_openTag string]];
    
    if(_closeTag){
        if(_content)
            [result appendFormat:@"%@", _content];
        [result appendFormat:@"%@", [_closeTag string]];
    }
    
    return [result copy];
}

- (BOOL)isEqualByType:(YGHTMLElement *)element{
    
    BOOL result = NO;
    
    for(YGHTMLAttributeRanged *attrSelf in self.openTag.attributes){
        for(YGHTMLAttributeRanged *attrEl in element.openTag.attributes){
            
            if([attrSelf.name compare:attrEl.name] == NSOrderedSame){
                if([attrSelf.value compare:attrEl.value] == NSOrderedSame){
                    result = YES;
                }
            }
            
            
        }
        if(!result)
            return NO;
    }
    
    return result;
}


@end
