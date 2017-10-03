//
//  MJobStatusTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MJobStatusTableViewCell.h"

@implementation MJobStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
    self.changeContainer.layer.cornerRadius = 10;
    self.changeContainer.layer.borderWidth = 1;
    self.changeContainer.layer.borderColor = [[UIColor grayColor] CGColor];
    self.changeContainer.clipsToBounds = YES;

    UITapGestureRecognizer *changeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toChange)];
    [self.changeContainer addGestureRecognizer:changeTap];
    self.changeContainer.userInteractionEnabled = NO;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)toChange {
    //   self.heart.image = [UIImage imageNamed:@"Heart"];
    [self.delegate changeTheStatus:self];
}

@end
