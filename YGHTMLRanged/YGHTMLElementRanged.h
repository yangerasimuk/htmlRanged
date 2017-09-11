//
//  YGHTMLElementRanged.h
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YGHTMLTagRanged.h"
#import "YGHTMLElement.h"

@interface YGHTMLElementRanged : YGHTMLElement

-(instancetype)initWithOpenTag:(YGHTMLTagRanged *)openTag closeTag:(YGHTMLTagRanged *)closeTag content:(NSString *)content;

-(instancetype)initWithOpenTag:(YGHTMLTagRanged *)openTag closeTag:(YGHTMLTagRanged *)closeTag inHTML:(NSString *)html;

/**
 Init func for html element consists with only one open tag.
 
 @param tag Base open tag of element
 */
-(instancetype)initWithOpenTagOnly:(YGHTMLTagRanged *)tag inHTML:(NSString *)html;

-(NSString *)nameAndRange;

@property YGHTMLTagRanged *openTagRanged;
@property YGHTMLTagRanged *closeTagRanged;

/// Range (location, length) of whole element in html string
@property NSRange range;


@end
