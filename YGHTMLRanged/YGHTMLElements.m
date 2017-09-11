//
//  YGHTMLElements.m
//  YGHTML
//
//  Created by Ян on 25/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLElements.h"
#import "YGHTMLElementRanged.h"

NSUInteger YGSearchOfTagPairs(NSArray<YGHTMLTagRanged *> *array, NSUInteger index, NSMutableArray<YGHTMLElementRanged *> *elements, NSString *html);
/*
@interface YGHTMLElements()
+ (NSUInteger) recurEnumerateArray:array atIndex:(NSUInteger)index toArray:(NSMutableArray <YGHTMLElementRanged *>*)elements inHTML:(NSString *)html;

@end
*/
@implementation YGHTMLElements{
    
    NSMutableArray *_elements;
}


- (instancetype)init{
    self = [super init];
    if(self){
        _elements = [[NSMutableArray alloc] init];
    }
    return self;
}


- (NSArray *)array{
    return [_elements copy];
}


- (void)makeElementsFromTags:(YGHTMLTags *)tags inHTML:(NSString *)html{
    
    NSArray *allTagNames = [NSArray arrayWithArray:[[tags dictionary] allKeys]];
    
    for(NSString *tagName in allTagNames){
        
        NSArray *array = [tags arrayForTagName:tagName];
        
        YGSearchOfTagPairs(array, 0, _elements, html);
    }
}

/**
 Recursive func to search pairs of open and close tags
 
 @param array Array of tags (all, open and close)
 @param index Current index in for loop
 @param elements Array for found html elements
 @param html HTML string to create content for html-element
 */
NSUInteger YGSearchOfTagPairs(NSArray<YGHTMLTagRanged *> *array, NSUInteger index, NSMutableArray<YGHTMLElementRanged *> *elements, NSString *html){
    
    NSUInteger prevIndex = 0;
    YGHTMLElementRanged *element = nil;
    
    do{
        
        if(array[index].isOpen == NO){
            return index;
        }
        if(array[index].isOpen == YES){
            prevIndex = index;
            if(index < ([array count]-1)){
                index = YGSearchOfTagPairs(array, index+1, elements, html);
            }
            
            if(array[prevIndex].isOpen == YES && array[index].isOpen == NO){
                element = [[YGHTMLElementRanged alloc] initWithOpenTag:array[prevIndex] closeTag:array[index] inHTML:html];
                [elements addObject:element];
                //printf("\nAdd new element...");
            }
            else{
                element = [[YGHTMLElementRanged alloc] initWithOpenTagOnly:array[prevIndex] inHTML:html];
                [elements addObject:element];
            }

        }
        
        index++;
    }while(index < [array count]);
    
    return index == [array count] ? index - 1 : index;
}


- (void)addElement:(YGHTMLElementRanged *)element{
    [_elements addObject:element];
}


/**
 Sort html elements in location ascending direction.
 
 Example: [html, head, body, h1...].
 */
- (void)sortElements{
    [_elements sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2){
        if([obj1 range].location < [obj2 range].location)
            return NSOrderedAscending;
        else if([obj1 range].location > [obj2 range].location)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
}

@end
