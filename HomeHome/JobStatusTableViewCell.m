//
//  JobStatusTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-01.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "JobStatusTableViewCell.h"

@implementation JobStatusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self layoutIfNeeded];
    
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
    [self.delegate changeJobStatus:self];
}

@end
