//
//  YGHTMLTags.h
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGHTMLTagRanged.h"

@interface YGHTMLTags : NSObject

- (instancetype)init;
- (void)addTag:(YGHTMLTagRanged *)tag;
- (NSDictionary *)dictionary;
- (NSArray <YGHTMLTagRanged *>*)arrayForTagName:(NSString *)name;

- (void)printTags;

@end
