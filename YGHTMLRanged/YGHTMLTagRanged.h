//
//  YGHTMLTagRanged.h
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLTag.h"

@interface YGHTMLTagRanged : YGHTMLTag

- (instancetype) initWithTag:(YGHTMLTag *)tag range:(NSRange)range;
- (NSString *)nameAndRange;
- (NSString *)nameAndRangeAndIsOpen;

/// Range (location, length) of element in whole html string
@property NSRange range;

@end
