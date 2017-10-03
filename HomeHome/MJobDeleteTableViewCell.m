//
//  MJobDeleteTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MJobDeleteTableViewCell.h"

@implementation MJobDeleteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteAct:(id)sender {
    [self.delegate deleteTheJob:self];
}

@end
