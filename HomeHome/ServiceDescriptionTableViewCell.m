//
//  ServiceDescriptionTableViewCell.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-05.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ServiceDescriptionTableViewCell.h"

@implementation ServiceDescriptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toLike)];
    [self.ratingStar addGestureRecognizer:likeTap];
    self.ratingStar.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)toLike {
    //   self.heart.image = [UIImage imageNamed:@"Heart"];
    [self.delegate likeTheService:self];
}

@end
