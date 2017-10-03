//
//  CBHelp.m
//  NiuXue
//
//  Created by boqian cheng on 2016-05-11.
//  Copyright © 2016 MiApple Inc. All rights reserved.
//

#import "CBHelp.h"

@implementation CBHelp

+ (UIColor *)randomColor {
    CGFloat hue = (arc4random() % 256 / 256.0);  // 0.0 to 1.0
    CGFloat saturation = (arc4random() % 128 / 256.0) + 0.4; // 0.5 to 1.0 away from white
    CGFloat brightness = (arc4random() % 128 / 256.0) + 0.7; // 0.5 to 1.0 away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIImage *)compressAndResizeImage:(UIImage *)imageIn {
    float actualHeight = imageIn.size.height;
    float actualWidth = imageIn.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;
    
    if (actualHeight > maxHeight || actualWidth > maxWidth) {
        if (imgRatio < maxRatio) {
            // adjust width according to maxHeight
            float reducedRatio = maxHeight/actualHeight;
            //     imgRatio = maxHeight/actualHeight;
            actualWidth = reducedRatio * actualWidth;
            actualHeight = maxHeight;
        } else if (imgRatio > maxRatio) {
            // adjust width according to maxWidth
            float reducedRatio2 = maxWidth/actualWidth;
            //  imgRatio = maxWidth/actualWidth;
            actualHeight = reducedRatio2 * actualHeight;
            actualWidth = maxWidth;
        } else {
            actualWidth = maxWidth;
            actualHeight = maxHeight;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [imageIn drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imgData = UIImageJPEGRepresentation(img, compressionQuality);
    //  NSLog(@"8888---%li", [imgData length]);
    UIGraphicsEndImageContext();
    // save to userDefaults
    //   [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:myPhoto];
    
    return [UIImage imageWithData:imgData];
}

+ (BOOL)isNumeric:(NSString *)checkText {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [formatter numberFromString:checkText];
    if (number != nil) {
        return YES;
    } else {
        return NO;
    }
}

@end
