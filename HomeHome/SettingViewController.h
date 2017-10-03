//
//  SettingViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-16.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *outContainer;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTxt;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;

- (IBAction)saveAct:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *countryView;
@property (weak, nonatomic) IBOutlet UILabel *countryL;

@end
