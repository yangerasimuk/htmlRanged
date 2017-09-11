//
//  YGHTMLTags.m
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLTags.h"

@interface YGHTMLTags(){
    NSMutableDictionary *_tags;
}

@end

@implementation YGHTMLTags
-(instancetype)init{
    self = [super init];
    if(self){
        _tags = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addTag:(YGHTMLTagRanged *)tag{
    
    NSString *tagName = [NSString stringWithFormat:@"%@", tag.name];
    NSMutableArray *array = nil;
    
    if(_tags[tagName]){
        array = _tags[tagName];
    }
    else{
        array = [[NSMutableArray alloc] init];
        [_tags setObject:array forKey:tagName];
        
    }
    
    [array addObject:tag];
    
}

- (NSDictionary *)dictionary{
    return [_tags copy];
}

- (NSArray <YGHTMLTagRanged *>*) arrayForTagName:(NSString *)name{
    return _tags[name];
}

- (void)printTags{
    NSArray *tags = nil;
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSArray *allTagNames = [NSArray arrayWithArray:[_tags allKeys]];
    
    [resultString appendString:@"\n{"];
    
    for(NSString *tagName in allTagNames){
        [resultString appendFormat:@"\n\t%@: [ ", tagName];
        
        tags = _tags[tagName];
        for(YGHTMLTagRanged *tag in tags){
            NSString *isOpen = nil;
            if(tag.isOpen)
                isOpen = @"isOpen";
            else
                isOpen = @"isClose";
            [resultString appendFormat:@"%@.%@={%lu,%lu} ", tag.name, isOpen, tag.range.location, tag.range.length];
        }
        
        [resultString appendFormat:@"]"];
    }
    
    [resultString appendString:@"\n}"];
    
    printf("%s", [resultString UTF8String]);
}

@end
