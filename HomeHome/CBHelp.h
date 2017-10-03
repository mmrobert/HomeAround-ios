//
//  CBHelp.h
//  NiuXue
//
//  Created by boqian cheng on 2016-05-11.
//  Copyright © 2016 MiApple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CBHelp : NSObject

+ (UIColor *)randomColor;

+ (UIImage *)compressAndResizeImage:(UIImage *)imageIn;

+ (BOOL)isNumeric:(NSString *)checkText;

@end
