//
//  CircularButton.m
//  HomeHome
//
//  Created by boqian cheng on 2016-11-24.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CircularButton.h"

@implementation CircularButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    CGFloat tempW = self.frame.size.width;
    self.layer.cornerRadius = tempW / 2;
    //  [self.view layoutIfNeeded];
    self.clipsToBounds = YES;
}

@end
