//
//  NSString+EmptyCheck.m
//  NiuXue
//
//  Created by boqian cheng on 2016-04-28.
//  Copyright © 2016 MiApple Inc. All rights reserved.
//

#import "NSString+EmptyCheck.h"

@implementation NSString (EmptyCheck)

- (BOOL)isStringEmpty {
    if ([self length] == 0) {
        return YES;
    }
    if (![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return YES;
    }
    
    return NO;
}

@end
