//
//  CircularImageView.m
//  HomeHome
//
//  Created by boqian cheng on 2016-11-23.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "CircularImageView.h"

@implementation CircularImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    CGFloat imgW = self.frame.size.width;
    self.layer.cornerRadius = imgW / 2;
    self.layer.borderWidth = 1;
    //  [self.view layoutIfNeeded];
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.clipsToBounds = YES;
}

@end
