//
//  JobDeleteTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-08-03.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "JobDeleteTableViewCell.h"

@implementation JobDeleteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteJob:(id)sender {
    [self.delegate deleteTheJob:self];
}

@end
