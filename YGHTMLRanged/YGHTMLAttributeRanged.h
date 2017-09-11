//
//  YGHTMLAttributeRanged.h
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLAttribute.h"

@interface YGHTMLAttributeRanged : YGHTMLAttribute

- (instancetype) initWithAttribute:(YGHTMLAttribute *)attribute range:(NSRange)range;

/// Range of attribute inside of tag bounds
@property NSRange range;

@end
