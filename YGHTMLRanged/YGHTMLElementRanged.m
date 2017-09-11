//
//  YGHTMLElementRanged.m
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLElementRanged.h"

@implementation YGHTMLElementRanged

-(instancetype)initWithOpenTag:(YGHTMLTagRanged *)openTag closeTag:(YGHTMLTagRanged *)closeTag content:(NSString *)content{
    self = [super initWithOpenTag:[openTag selfTag] closeTag:[closeTag selfTag] content:content];
    if(self){
        _openTagRanged = openTag;
        _closeTagRanged = closeTag;
        
        if(!closeTag){
            _range = openTag.range;
        }
        else{
            _range = NSMakeRange(openTag.range.location, (closeTag.range.location + closeTag.range.length - openTag.range.location));
        }
    }
    return self;
}

-(instancetype)initWithOpenTag:(YGHTMLTagRanged *)openTag closeTag:(YGHTMLTagRanged *)closeTag inHTML:(NSString *)html{
    return [self initWithOpenTag:openTag closeTag:closeTag content:[html substringWithRange:NSMakeRange(openTag.range.location, (closeTag.range.location + closeTag.range.length - openTag.range.location))]];
}

-(instancetype)initWithOpenTagOnly:(YGHTMLTagRanged *)tag inHTML:(NSString *)html{
    return [self initWithOpenTag:tag closeTag:nil content:[html substringWithRange:NSMakeRange(tag.range.location,tag.range.length)]];
}

-(NSString *)nameAndRange{
    return [NSString stringWithFormat:@"%@ in {%lu,%lu}", self.name, self.range.location, self.range.length];
}



@end
