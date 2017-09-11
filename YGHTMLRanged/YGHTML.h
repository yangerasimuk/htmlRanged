//
//  YGHTML.h
//  YGHTML
//
//  Created by Ян on 21/03/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Object must return string with own contents.
 */
@protocol YGHTMLStringing
- (NSString *) string;
@end

@interface YGHTML : NSObject

@end
