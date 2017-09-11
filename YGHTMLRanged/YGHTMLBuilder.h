//
//  YGHTMLBuilder.h
//  YGHTML
//
//  Created by Ян on 27/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGHTMLElementRanged.h"

@interface YGHTMLBuilder : NSObject

- (instancetype)initWithHTMLString:(NSString *)html;
- (void)setElement:(YGHTMLElementRanged *)element;

- (BOOL)isExistElementWithName:(NSString *)name;
//- (void)setElementByName:(YGHTMLElementRanged *)element;
- (void)setElementByName:(YGHTMLElement *)element;

- (BOOL)isExistElementWithType:(YGHTMLElement *)element;
//- (void)setElementByType:(YGHTMLElementRanged *)element;
- (void)setElementByType:(YGHTMLElement *)element;


-(void)setElementsByNameAndAttributeValue:(YGHTMLElement *)element toElements:(NSArray<YGHTMLElement *> *)elements;

- (NSString *)html;

/// new
-(void)replaceElementWithType:(YGHTMLElement *)element byElements:(NSArray<YGHTMLElement *> *)elements;
-(void)replaceElementWithType:(YGHTMLElement *)element byElement:(YGHTMLElement *)element;
-(void)addElements:(NSArray<YGHTMLElement *> *)elements afterElement:(YGHTMLElement *)element;
-(void)addElements:(NSArray<YGHTMLElement *> *)elements beforeElement:(YGHTMLElement *)element;


@end
