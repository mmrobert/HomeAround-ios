//
//  OtherTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-14.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "OtherTableViewCell.h"

@implementation OtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
    self.containerView.layer.cornerRadius = 8.0;
    self.containerView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
