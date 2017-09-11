//
//  YGHTMLAttribute.h
//  YGHTML
//
//  Created by Ян on 21/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGHTML.h"

@interface YGHTMLAttribute : NSObject <YGHTMLStringing>

- (instancetype) initWithName:(NSString *)name value:(NSString *)value;
- (instancetype) initWithName:(NSString *)name;
- (NSString *) string;
+ (NSArray<YGHTMLAttribute *>*)parseOpenTagForAttributes:(NSString *)string;

/// Name of attribute
@property NSString *name;

/// Value of attribute
@property NSString *value;

@end
