//
//  MeTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-14.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MeTableViewCell.h"

@implementation MeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
    self.photo.layer.cornerRadius = 13.0;
    self.photo.clipsToBounds = YES;
    
    self.containerView.layer.cornerRadius = 8.0;
    self.containerView.clipsToBounds = YES;
    
 //   self.message.numberOfLines = 0;
 //   self.message.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
