//
//  YGHTMLTag.h
//  YGHTML
//
//  Created by Ян on 21/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGHTML.h"

@class YGHTMLAttribute;
@class YGHTMLAttributeRanged;

@interface YGHTMLTag : NSObject <YGHTMLStringing>

- (instancetype)initWithName:(NSString *)name attributes:(NSArray<YGHTMLAttribute *>*)attributes isOpenOnly:(BOOL)isOpenOnly;
- (instancetype)initWithName:(NSString *)name attributes:(NSArray<YGHTMLAttribute *>*)attributes;
- (instancetype)initWithName:(NSString *)name isOpen:(BOOL)isOpen isOpenOnly:(BOOL)isOpenOnly;
- (instancetype)initWithName:(NSString *)name isOpen:(BOOL)isOpen;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithTag:(YGHTMLTag *)tag;

- (YGHTMLTag *)selfTag;


- (NSString *) string;

@property (readonly) NSString *name;
@property (readonly) NSArray <YGHTMLAttributeRanged *> *attributes;
@property BOOL isOpen;

/// Tag of element consist only with open tag, like <meta name="" content="" />
@property BOOL isOpenOnly;

@end
