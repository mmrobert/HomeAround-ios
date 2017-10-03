//
//  SvcFindNoReviewTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-25.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "SvcFindNoReviewTableViewCell.h"

@implementation SvcFindNoReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toLike)];
    [self.heart addGestureRecognizer:likeTap];
    self.heart.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)toLike {
    //   self.heart.image = [UIImage imageNamed:@"Heart"];
    [self.delegate likeServiceNoReview:self];
}

@end
