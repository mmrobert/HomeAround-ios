//
//  MphotoSetTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-28.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MphotoSetTableViewCell.h"

@implementation MphotoSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self layoutIfNeeded];
    
    CGFloat imgW = self.photo.frame.size.width;
    self.photo.layer.cornerRadius = imgW / 2;
    self.photo.layer.borderWidth = 1;
    self.photo.layer.borderColor = [[UIColor grayColor] CGColor];
    self.photo.clipsToBounds = YES;

    UITapGestureRecognizer *updateTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toUpdate)];
    [self.photo addGestureRecognizer:updateTap];
    self.photo.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)toUpdate {
    //   self.heart.image = [UIImage imageNamed:@"Heart"];
    [self.delegate updatePhoto:self];
}

@end
