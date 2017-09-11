//
//  YGHTMLElements.h
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGHTMLElementRanged.h"
#import "YGHTMLTags.h"

@interface YGHTMLElements : NSObject

- (instancetype)init;
- (void)addElement:(YGHTMLElementRanged *)element;
- (void)makeElementsFromTags:(YGHTMLTags *)tags inHTML:(NSString *)html;
- (void)sortElements;
- (NSArray *)array;

@end
