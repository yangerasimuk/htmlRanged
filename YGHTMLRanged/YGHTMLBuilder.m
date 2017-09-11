//
//  YGHTMLBuilder.m
//  YGHTML
//
//  Created by Ян on 27/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGHTMLBuilder.h"
#import "YGHTMLElementRanged.h"
#import "YGHTMLElements.h"
#import "YGHTMLAttributeRanged.h"

@interface YGHTMLBuilder (){
    NSMutableString *_html;
    YGHTMLElements *_elements;
}

- (void)buildElements;
- (NSArray<YGHTMLElementRanged *> *)getElementsByName:(NSString *)name;
- (NSArray<YGHTMLElementRanged *> *)getElementsByName:(NSString *)name attributes:(NSArray<YGHTMLAttribute*> *)attributes;
- (NSString *)stringIndentFromPreviousOfElement:(YGHTMLElementRanged *)element;

@end

@implementation YGHTMLBuilder


- (instancetype)initWithHTMLString:(NSString *)html{
    self = [super init];
    if(self){
        _html = [html mutableCopy];
        [self buildElements];
    }
    return self;
}

/**
 Build inner elements array of YGHTMLBuilder. Send this message after any changes in inner html.
 
 */
- (void)buildElements{
#ifdef FUNC_DEBUG
#undef FUNC_DEBUG
#endif
    
    YGHTMLTags *tags = [[YGHTMLTags alloc] init];
    
    NSMutableString *tagName = [[NSMutableString alloc] init];
    NSMutableString *tagAttributes = [[NSMutableString alloc] init];
    BOOL isTagNameSequence = NO, isOpenTagSequence = NO, isCloseTagSequence = NO, isComment = NO, isAttributesSequence = NO;
    unichar curChar = 0, prevChar = 0, nextChar = 0;
    NSUInteger startIndex = 0, endIndex = 0;
    
    for(NSUInteger i = 0; i < [_html length]; i++){
        
        curChar = [_html characterAtIndex:i];
        nextChar = i < ([_html length] - 1) ? [_html characterAtIndex:(i+1)] : 0;
        
        if(curChar == '<' && nextChar == '!' && !isOpenTagSequence && !isCloseTagSequence){
            isComment = YES;
        }
        else if(isComment && curChar == '>'){
            isComment = NO;
        }
        else if(curChar == '<' && nextChar == '/'){
            startIndex = i;
            isCloseTagSequence = YES;
        }
        else if(isCloseTagSequence && curChar == '/'){
            tagName = [@"" mutableCopy];
        }
        else if(isCloseTagSequence && curChar != '>' && curChar != '/'){
            [tagName appendFormat:@"%C", curChar];
        }
        else if(isCloseTagSequence && curChar == '>'){
            isCloseTagSequence = NO;
            endIndex = i;
            YGHTMLTag *tag = [[YGHTMLTag alloc] initWithName:tagName isOpen:NO];
            YGHTMLTagRanged *closeTag = [[YGHTMLTagRanged alloc] initWithTag:tag range:NSMakeRange(startIndex, (endIndex - startIndex)+1)];
#ifdef FUNC_DEBUG
            printf("\nCreated close tag with name: %s -> {%ld,%ld}", [closeTag.name UTF8String], closeTag.range.location, closeTag.range.length);
#endif
            
            [tags addTag:closeTag];
        }
        else if(curChar == '<' && nextChar != '/'){
            startIndex = i;
            isOpenTagSequence = YES;
            isTagNameSequence = YES;
            tagName = [@"" mutableCopy];
        }
        else if(isOpenTagSequence && isTagNameSequence && curChar == ' '){
            isTagNameSequence = NO;
            isAttributesSequence = YES;
            tagAttributes = [@"" mutableCopy];
        }
        else if(isOpenTagSequence && curChar == '>'){
            isOpenTagSequence = NO;
            isAttributesSequence = NO;
            endIndex = i;
#ifdef FUNC_DEBUG
            printf("\nTag attributes: %s", [tagAttributes UTF8String]);
#endif
            
            if([tagName compare:@"p"] == NSOrderedSame){
                ;
            }
            
            YGHTMLTag *tag = [[YGHTMLTag alloc] initWithName:tagName attributes:[YGHTMLAttribute parseOpenTagForAttributes:tagAttributes]];
            YGHTMLTagRanged *openTag = [[YGHTMLTagRanged alloc] initWithTag:tag range:NSMakeRange(startIndex, (endIndex - startIndex)+1)];
#ifdef FUNC_DEBUG
            printf("\nCreated open tag with name: %s -> {%ld,%ld}", [openTag.name UTF8String], openTag.range.location, openTag.range.length);
#endif
            
            [tags addTag:openTag];
            
            tagAttributes = [@"" mutableCopy];

            
        }
        else if(isOpenTagSequence && isTagNameSequence){
            [tagName appendFormat:@"%C", curChar];
        }
        else if(isOpenTagSequence && isAttributesSequence){
            [tagAttributes appendFormat:@"%C", curChar];
        }
        
        
        prevChar = curChar;
    }
    
#ifdef FUNC_DEBUG
    [tags printTags];
#endif
    
    YGHTMLElements *elements = [[YGHTMLElements alloc] init];
    [elements makeElementsFromTags:tags inHTML:_html];
    [elements sortElements];
    
#ifdef FUNC_DEBUG
    printf("\nElements ranged:");
    for(YGHTMLElementRanged *element in [elements array]){
        printf("\n%s: %s", [[element nameAndRange] UTF8String], [element.content UTF8String]);
    }
#endif
    
    _elements = elements;
}


/**
 Check exist of element with entered name.
 
 - tagName: searched name
 
 - return: YES if element founded and NO if not
 */
- (BOOL)isExistElementWithName:(NSString *)tagName{
    
    for(YGHTMLElementRanged *el in [_elements array]){
        if([el.name compare:tagName] == NSOrderedSame)
            return YES;
    }
    
    return NO;
}

/**
 Check exist of element with entered element by type. Search only by name, type (one tag or open + close) and attributes key/value equivalence.
 
 - elemente: searched html element
 
 - return: YES if element founded and NO if not
 
 */
- (BOOL)isExistElementWithType:(YGHTMLElement *)element{
    
    NSArray <YGHTMLElementRanged *> *elements = [NSArray arrayWithArray:[self getElementsByName:element.name]];
    
    if([elements count] > 0){
        for(YGHTMLElementRanged *el in elements){
            if([el isEqualByType:element]){
                return YES;
            }
        }
    }
    else{
        return NO;
    }
    
    return NO;
}


- (NSArray<YGHTMLElementRanged *> *)getElementsByName:(NSString *)name{
    
    NSMutableArray<YGHTMLElementRanged *> *foundElements = [[NSMutableArray alloc] init];
    
    for(YGHTMLElementRanged *el in [_elements array]){
        if([el.name compare:name] == NSOrderedSame){
            [foundElements addObject:el];
        }
    }
    
    return [foundElements copy];
}


/**
 
 Attention! Element will be found if it's tags name and searched attribute is equel.
 
 */
- (NSArray<YGHTMLElementRanged *> *)getElementsByName:(NSString *)name attributes:(NSArray<YGHTMLAttribute*> *)attributes{
    
#ifndef FUNC_DEBUG
#define FUNC_DEBUG
#endif
    
    NSMutableArray<YGHTMLElementRanged *> *foundElements = [[NSMutableArray alloc] init];
    
    for(YGHTMLElementRanged *el in [_elements array]){
        if([el.name compare:name] == NSOrderedSame){
            
            for(YGHTMLAttribute *attrEl in el.openTag.attributes){
                
                for(YGHTMLAttribute *attr in attributes){
                    if([attr.name compare:attrEl.name] == NSOrderedSame){
                        if([attr.value compare:attrEl.value] == NSOrderedSame){
                            
                            [foundElements addObject:el];
                            break;
#ifdef FUNC_DEBUG
                            printf("\nel found: %s", [[el string] UTF8String]);
#endif
                        }
                    }
                }
            }
        }
    }
    
    return [foundElements copy];
}


//- (void)setElementByName:(YGHTMLElementRanged *)element{
- (void)setElementByName:(YGHTMLElement *)element{
    NSArray <YGHTMLElementRanged *> *foundElements = [NSArray arrayWithArray:[self getElementsByName:element.name]];
    if([foundElements count] > 0){
        [_html replaceCharactersInRange:foundElements[0].range withString:[element string]];
    }
    
    [self buildElements];
}

//- (void)setElementByType:(YGHTMLElementRanged *)element{
- (void)setElementByType:(YGHTMLElement *)element{
#ifndef FUNC_DEBUG
#define FUNC_DEBUG
#endif 
    
    NSArray <YGHTMLElementRanged *> *foundElements = [NSArray arrayWithArray:[self getElementsByName:element.name]];
    
    NSRange searchedRange = {NSNotFound, 0};
    
    if([foundElements count] > 0){
        for(YGHTMLElementRanged *el in foundElements){
            if([el isEqualByType:element]){
                searchedRange = el.range;
                break;
            }
        }
    }
    else
        return;
    
    if(searchedRange.location != NSNotFound){
        [_html replaceCharactersInRange:searchedRange withString:[element string]];
        
        [self buildElements];
    }
    else{
#ifdef FUNC_DEBUG
        printf("\nReplaced element did not found.");
#endif
        return;
    }
}


-(NSString *)stringIndentFromPreviousOfElement:(YGHTMLElementRanged *)element{
#ifdef FUNC_DEBUG
#undef FUNC_DEBUG
#endif
    
#ifdef FUNC_DEBUG
    printf("\n-[YGHTMLRanged stringIndentFromPreviousOfElement:]...");
#endif
    
    NSString *stringOfGap = nil;
    
    @try{
        NSUInteger index = [[_elements array] indexOfObject:element];
        if(index <= 0)
            return nil;
        YGHTMLElementRanged *previousEl = [[_elements array] objectAtIndex:(index-1)];
        NSRange rangeOfGap = NSMakeRange(NSNotFound, 0);
        
        // choice if previous element include next element or not
        if(previousEl.range.location + previousEl.range.length > element.range.location + element.range.length){
            
            //YGHTMLTagRanged *openTagOfPreviousEl = previousEl.openTag;
            YGHTMLTagRanged *openTagOfPreviousEl = previousEl.openTagRanged;
            rangeOfGap = NSMakeRange(openTagOfPreviousEl.range.location + openTagOfPreviousEl.range.length, element.range.location - (openTagOfPreviousEl.range.location + openTagOfPreviousEl.range.length));
            
        }
        else{
            rangeOfGap = NSMakeRange(previousEl.range.location + previousEl.range.length, element.range.location - (previousEl.range.location + previousEl.range.length));
        }
        

#ifdef FUNC_DEBUG
        printf("\npreviousEl range: {%ld,%ld}", previousEl.range.location, previousEl.range.length);
        printf("\nelement range: {%ld,%ld}", element.range.location, element.range.length);
        printf("\nrangeOfGap = {%ld,%ld}", rangeOfGap.location, rangeOfGap.length);
#endif
        
        stringOfGap = [_html substringWithRange:rangeOfGap];
        
        
        
#ifdef FUNC_DEBUG
        printf("\nstring of gap: %s", [stringOfGap UTF8String]);
#endif
    }
    @catch(NSException *ex){
        
    }
    @finally{
        return stringOfGap;
    }
    
}


-(void)addElements:(NSArray<YGHTMLElement *> *)elements beforeElement:(YGHTMLElement *)element{
    NSArray <YGHTMLElementRanged *> *foundedElements = [self getElementsByName:element.name attributes:element.openTag.attributes];
    
    NSRange foundedRange = {NSNotFound, 0};
    
    if([foundedElements count] > 0){
        
        NSString *indentString = [self stringIndentFromPreviousOfElement:foundedElements[0]];
        NSMutableString *newIndentString = [[NSMutableString alloc] init];
        
        for(NSUInteger i = 0; i < [indentString length]; i++){
            unichar ch = [indentString characterAtIndex:i];
            if(ch != '\n')
                [newIndentString appendFormat:@"%C", ch];
        }
        
        foundedRange = foundedElements[0].range;
        
        if(foundedRange.location != NSNotFound){
            
            NSMutableString *stringOfElements = [[NSMutableString alloc] init];
            
            for(NSUInteger i = 0; i < [elements count]; i++){
                YGHTMLElement *el = elements[i];
                
                [stringOfElements appendFormat:@"\n%@%@", newIndentString, [el string]];
            }
            NSUInteger indexOfInsert = foundedRange.location - 1 - [newIndentString length];
            [_html insertString:stringOfElements atIndex:indexOfInsert];
            
            [self buildElements];
        }
        else
            return;
    }
    else
        return;
}

-(void)addElements:(NSArray<YGHTMLElement *> *)elements afterElement:(YGHTMLElement *)element{
    NSArray <YGHTMLElementRanged *> *foundedElements = [self getElementsByName:element.name attributes:element.openTag.attributes];
    
    NSRange foundedRange = {NSNotFound, 0};
    
    if([foundedElements count] > 0){
        
        NSString *indentString = [self stringIndentFromPreviousOfElement:foundedElements[0]];
        NSMutableString *newIndentString = [[NSMutableString alloc] init];
        
        for(NSUInteger i = 0; i < [indentString length]; i++){
            unichar ch = [indentString characterAtIndex:i];
            if(ch != '\n')
                [newIndentString appendFormat:@"%C", ch];
        }
        
        foundedRange = foundedElements[0].range;
        
        if(foundedRange.location != NSNotFound){
            
            NSMutableString *stringOfElements = [[NSMutableString alloc] init];
            
            for(NSUInteger i = 0; i < [elements count]; i++){
                YGHTMLElement *el = elements[i];
                
                [stringOfElements appendFormat:@"\n%@%@", newIndentString, [el string]];
            }
            
            [_html insertString:stringOfElements atIndex:(foundedRange.location + foundedRange.length)];
            
            [self buildElements];
            
        }
        else
            return;
    }
    else
        return;
}

-(void)replaceElementWithType:(YGHTMLElement *)element byElement:(YGHTMLElement *)element{
    NSArray *elements = [NSArray arrayWithObjects:element, nil];
    [self replaceElementWithType:element byElements:elements];
}

-(void)replaceElementWithType:(YGHTMLElement *)element byElements:(NSArray<YGHTMLElement *> *)elements{
    NSArray <YGHTMLElementRanged *> *foundedElements = [self getElementsByName:element.name attributes:element.openTag.attributes];
    
    NSRange foundedRange = {NSNotFound, 0};
    
    if([foundedElements count] > 0){
        
        NSString *indentString = [self stringIndentFromPreviousOfElement:foundedElements[0]];
        NSMutableString *newIndentString = [[NSMutableString alloc] init];
        
        for(NSUInteger i = 0; i < [indentString length]; i++){
            unichar ch = [indentString characterAtIndex:i];
            if(ch != '\n')
                [newIndentString appendFormat:@"%C", ch];
        }
        
        foundedRange = foundedElements[0].range;
        
        if(foundedRange.location != NSNotFound){
            
            NSMutableString *stringOfElements = [[NSMutableString alloc] init];
            
            for(NSUInteger i = 0; i < [elements count]; i++){
                YGHTMLElement *el = elements[i];
                
                if(i == 0)
                    [stringOfElements appendString:[el string]];
                else
                    [stringOfElements appendFormat:@"\n%@%@", newIndentString, [el string]];
            }
            
            [_html replaceCharactersInRange:foundedRange withString:stringOfElements];
            
            [self buildElements];
            
        }
        else
            return;
    }
    else
        return;
}

/**
 
 Attention! Proccess only first of found element.
 
 Attention! Function is rename to -[replaceElementWithType:toElements:]
 */
-(void)setElementsByNameAndAttributeValue:(YGHTMLElement *)element toElements:(NSArray<YGHTMLElement *> *)elements{
    
    NSArray <YGHTMLElementRanged *> *foundedElements = [self getElementsByName:element.name attributes:element.openTag.attributes];
    
    NSRange foundedRange = {NSNotFound, 0};

    if([foundedElements count] > 0){
        
        NSString *indentString = [self stringIndentFromPreviousOfElement:foundedElements[0]];
        NSMutableString *newIndentString = [[NSMutableString alloc] init];
        
        for(NSUInteger i = 0; i < [indentString length]; i++){
            unichar ch = [indentString characterAtIndex:i];
            if(ch != '\n')
                [newIndentString appendFormat:@"%C", ch];
        }
        
        foundedRange = foundedElements[0].range;
        
        if(foundedRange.location != NSNotFound){
            
            NSMutableString *stringOfElements = [[NSMutableString alloc] init];
            
            for(NSUInteger i = 0; i < [elements count]; i++){
                YGHTMLElement *el = elements[i];
                
                if(i == 0)
                    [stringOfElements appendString:[el string]];
                else
                    [stringOfElements appendFormat:@"\n%@%@", newIndentString, [el string]];
            }
                 
            [_html replaceCharactersInRange:foundedRange withString:stringOfElements];
            
            [self buildElements];
            
        }
        else
            return;
    }
    else
        return;
}

- (BOOL)replaceElement:(YGHTMLElement *)oldElement byElement:(YGHTMLElement *)newElement{
    
    NSArray <YGHTMLElementRanged *> *array = [NSArray arrayWithArray:[self getElementsByName:oldElement.name]];
    
    for(YGHTMLElementRanged *el in array){
        if([el isEqual:oldElement]){
            
            [_html replaceCharactersInRange:el.range withString:[newElement string]];
            return YES;
        }
    }
    
    [self buildElements];
    
    return NO;
}

- (NSString *)html{
    return [_html copy];
}

@end
