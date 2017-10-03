//
//  CreatePhotoViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-23.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UIButton *laterOutlet;
- (IBAction)saveAction:(id)sender;
- (IBAction)laterAction:(id)sender;

@end
