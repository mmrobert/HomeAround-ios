//
//  ServiceListTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-04.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ServiceListTableViewCell.h"

@implementation ServiceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    // Initialization code
    self.deleteC.layer.borderWidth = 1;
    self.deleteC.layer.borderColor = [[UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0] CGColor];
    self.deleteC.clipsToBounds = YES;

    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toDeleteService)];
    [self.deleteC addGestureRecognizer:deleteTap];
    self.deleteC.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

- (void)toDeleteService {
    [self.delegate deleteService:self];
}

@end
