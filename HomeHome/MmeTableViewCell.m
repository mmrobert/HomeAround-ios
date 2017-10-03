//
//  MmeTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-23.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MmeTableViewCell.h"

@implementation MmeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
    self.photo.layer.cornerRadius = 13.0;
    self.photo.clipsToBounds = YES;
    
    self.msgContainer.layer.cornerRadius = 8.0;
    self.msgContainer.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
