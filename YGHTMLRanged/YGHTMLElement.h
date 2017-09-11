//
//  YGHTMLElement.h
//  YGHTML
//
//  Created by Ян on 27/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGHTMLTag.h"
#import "YGHTML.h"

@interface YGHTMLElement : NSObject <YGHTMLStringing>

/** 
 Default init message.
 
 - openTag:
 
 - closeTag:
 
 - content: string between open and close tags with contents of element
 
 - return: new instance of YGHTMLElement
 */
-(instancetype)initWithOpenTag:(YGHTMLTag *)openTag closeTag:(YGHTMLTag *)closeTag content:(NSString *)content;

/**
 Init message for elements with only one (open) tag.
 */
-(instancetype)initWithOpenTag:(YGHTMLTag *)openTag;

- (BOOL)isEqualByType:(YGHTMLElement *)element;

- (NSString *)string;

/// Name of element
@property NSString *name;

/// Value from open tag to close tag, or nil for single tag
@property NSString *content;

/// Open tag with no range
@property YGHTMLTag *openTag;

/// Close tag with no range, may be nil
@property YGHTMLTag *closeTag;

@end
