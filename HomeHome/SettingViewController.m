//
//  SettingViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-16.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "SettingViewController.h"
#import "SWRevealViewController.h"
#import "AppConstants.h"
#import "CBHelp.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "NSString+EmptyCheck.h"
#import "CountryListTableViewController.h"

@interface SettingViewController ()

@property CGFloat originalTopDistance;

@property UIImagePickerController *ipc;
@property UIImage *pickedLargeImage;

@property NSData *myImageData;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarItem setTarget:self.revealViewController];
        [self.sideBarItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
  //  CGFloat imgW = self.photo.frame.size.width;
  //  self.photo.layer.cornerRadius = imgW / 2;
  //  self.photo.layer.borderWidth = 1;
  //  self.photo.layer.borderColor = [[UIColor grayColor] CGColor];
  //  self.photo.clipsToBounds = YES;
    
    self.myImageData = [[NSUserDefaults standardUserDefaults] objectForKey:myPhoto];
    if (self.myImageData) {
        self.photo.image = [UIImage imageWithData:self.myImageData];
    } else {
        self.photo.image = [UIImage imageNamed:@"User"];
    }
    self.nameTxt.text = [[NSUserDefaults standardUserDefaults] objectForKey:myNickName];
    self.postalCodeTxt.text = [[NSUserDefaults standardUserDefaults] objectForKey:myPostalCode];
    
    UITapGestureRecognizer *choosePhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseIt:)];
    [self.photo addGestureRecognizer:choosePhoto];
    self.photo.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.nameTxt.delegate = self;
    self.postalCodeTxt.delegate = self;
    
    self.originalTopDistance = self.topDistance.constant;

    UITapGestureRecognizer *chooseCy = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCountry:)];
    [self.countryView addGestureRecognizer:chooseCy];
    self.countryView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *tempCountry = [[NSUserDefaults standardUserDefaults] objectForKey:myCountry];
    if (tempCountry == nil || [tempCountry isStringEmpty]) {
        UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
        self.countryL.textColor = aa;
        self.countryL.text = @"Choose your country";
    } else {
        self.countryL.textColor = [UIColor blackColor];
        self.countryL.text = tempCountry;
    }
}

- (void)chooseCountry:(UITapGestureRecognizer *)tapGestureRecognizer {
    //  NSLog(@"12345TT- 99 --");
    CountryListTableViewController *controller = (CountryListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CountryListSB"];
    /*
     NSString *tagStr = [NSString stringWithFormat:@"%ld", (long)tapGestureRecognizer.view.tag];
     //    NSLog(@"uuuuuuuuTTT---%@", tagStr);
     controller.viewTag = tagStr;
     */
    controller.chosedCountry = [[NSUserDefaults standardUserDefaults] objectForKey:myCountry];
    if ([self respondsToSelector:@selector(showViewController:sender:)]) {
        [self showViewController:controller sender:self];
    } else {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.nameTxt) || (textField == self.postalCodeTxt)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

 - (void)textFieldDidBeginEditing:(UITextField *)textField {
// [UIView setAnimationsEnabled:YES];
     textField.textAlignment = NSTextAlignmentLeft;
 }

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // workaround for jumping text bug
    textField.textAlignment = NSTextAlignmentRight;
    [textField resignFirstResponder];
    [textField layoutIfNeeded];
}

- (void) keyboardWillShow:(NSNotification *)note {
    //  NSLog(@"key show");
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // needs to translate the bounds to account for rotation
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // animation settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // [self.tableView layoutIfNeeded];
   // CGFloat tempH = self.view.frame.size.height - self.outContainer.frame.size.height;
  //  CGFloat tempKH = keyboardBounds.size.height + 60;
    if (!(self.topDistance.constant < 6)) {
        self.topDistance.constant -= 128;
    }
    //   self.view.frame.origin.y -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    // set table view scroll to bottom
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification *)note {
    //  NSLog(@"key hide");
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // [self.tableView layoutIfNeeded];
    self.topDistance.constant = self.originalTopDistance;
    //   self.enterViewBottom.constant -= keyboardBounds.size.height + 5;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)chooseIt: (UITapGestureRecognizer *) tapGestureRecognizer {
    
    typedef void (^HandlerForPickPhoto)(UIAlertAction *action);
    
    //   NSString *alertTitle = @"";
    //   NSString *alertMessage= @"";
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    HandlerForPickPhoto handlerAlbums = ^void (UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            self.ipc = [[UIImagePickerController alloc] init];
            self.ipc.allowsEditing = YES;
            self.ipc.mediaTypes = @[(NSString *) kUTTypeImage];
            self.ipc.delegate = self;
            self.ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:self.ipc animated:YES completion:nil];
            } else {
                //  self.popover = [[UIPopoverController alloc] initWithContentViewController:self.ipc];
                self.ipc.modalPresentationStyle = UIModalPresentationPopover;
                
                [self presentViewController:self.ipc animated:YES completion:nil];
                
                UIPopoverPresentationController *popController = [self.ipc popoverPresentationController];
                popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
                popController.sourceView = self.view;
                popController.sourceRect = CGRectMake(10, 10, 10, 10);
                popController.delegate = self;
                //   [self.popover presentPopoverFromRect:self.userImage.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
        }
    };
    HandlerForPickPhoto handlerCamera = ^void (UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.ipc = [[UIImagePickerController alloc] init];
            self.ipc.allowsEditing = YES;
            self.ipc.mediaTypes = @[(NSString *) kUTTypeImage];
            self.ipc.delegate = self;
            self.ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:self.ipc animated:YES completion:nil];
            } else {
                //  self.popover = [[UIPopoverController alloc] initWithContentViewController:self.ipc];
                self.ipc.modalPresentationStyle = UIModalPresentationPopover;
                
                [self presentViewController:self.ipc animated:YES completion:nil];
                
                UIPopoverPresentationController *popController = [self.ipc popoverPresentationController];
                popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
                popController.sourceView = self.view;
                popController.sourceRect = CGRectMake(10, 10, 10, 10);
                popController.delegate = self;
                //   [self.popover presentPopoverFromRect:self.userImage.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
        }
    };
    
    NSString *firstActionTitle = @"Choose from Albums";
    UIAlertAction *gallery = [UIAlertAction actionWithTitle:firstActionTitle
                                                      style:UIAlertActionStyleDefault
                                                    handler:handlerAlbums];
    NSString *secondActionTitle = @"Take Photo";
    UIAlertAction *camera = [UIAlertAction actionWithTitle:secondActionTitle style:UIAlertActionStyleDefault handler:handlerCamera];
    NSString *thirdActionTitle = @"Cancel";
    UIAlertAction *cancell = [UIAlertAction actionWithTitle:thirdActionTitle
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    [alert addAction:gallery];
    [alert addAction:camera];
    [alert addAction:cancell];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPresenter.sourceView = self.photo;
        popPresenter.sourceRect = self.photo.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - imagepickercontroller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.pickedLargeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.photo.image = [CBHelp compressAndResizeImage:self.pickedLargeImage];
    self.myImageData = UIImageJPEGRepresentation(self.photo.image, 1.0);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController.navigationItem setTitle:@"Photos"];
}

#pragma Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAct:(id)sender {
    [self.view endEditing:YES];
    
    if (self.postalCodeTxt.text == nil || [self.postalCodeTxt.text isStringEmpty]) {
        NSString *alertMsg = @"Enter your postal code to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else if (self.countryL.text == nil || [self.countryL.text isStringEmpty]) {
        NSString *alertMsg = @"Choose your country to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        if ([self.countryL.text isEqualToString:@"Canada"]) {
            NSString *tempPost = self.postalCodeTxt.text;
            NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [tempPost stringByTrimmingCharactersInSet:whiteSpace];
            if (trimmed.length > 3 && trimmed.length < 7) {
                NSString *s1 = [trimmed substringToIndex:3];
                NSString *s2 = [trimmed substringFromIndex:3];
                self.postalCodeTxt.text = [NSString stringWithFormat:@"%@ %@", s1, s2];
                //          NSLog(@"999fffiii--here--999 %@", self.postalCodeTxt.text);
            } else {
                self.postalCodeTxt.text = trimmed;
            }
            
            NSString *postRegex = @"^[a-zA-Z][0-9][a-zA-Z][- ]*[0-9][a-zA-Z][0-9]$";
            NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postRegex];
            BOOL testResult = [postTest evaluateWithObject:self.postalCodeTxt.text];
            if (!testResult) {
                NSString *alertMsg = @"Not right postal code format.";
                NSString *okTitle = @"OK";
                [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
            } else {
                //  NSLog(@"965--here--569, OK Canada");
                [self connectingServer];
            }
        } else if ([self.countryL.text isEqualToString:@"United States"]) {
            NSString *tempPost = self.postalCodeTxt.text;
            NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [tempPost stringByTrimmingCharactersInSet:whiteSpace];
            self.postalCodeTxt.text = trimmed;
            
            NSString *postRegex = @"^[0-9]{5}(-[0-9]{4})?$";
            NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postRegex];
            BOOL testResult = [postTest evaluateWithObject:self.postalCodeTxt.text];
            if (!testResult) {
                NSString *alertMsg = @"Not right postal code format.";
                NSString *okTitle = @"OK";
                [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
            } else {
                //   NSLog(@"965--here--569, OK states");
                [self connectingServer];
            }
        }
        //  NSLog(@"999--test here--999");
    }
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Saving profile...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"customer/profileupdate"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
  //  NSData *imgData = UIImageJPEGRepresentation(self.photo.image, 1.0);
    NSString *photoStr;
    if (self.myImageData) {
        photoStr = [self.myImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        photoStr = @"";
    }
    NSString *nameStr = self.nameTxt.text;
    if (nameStr == nil || [nameStr isStringEmpty]) {
        nameStr = @"";
    }
    NSString *postCodeStr = [self.postalCodeTxt.text uppercaseString];
    NSString *countryStr = self.countryL.text;
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:nameStr, @"name", uToken, @"token", countryStr, @"country", postCodeStr, @"postcode", photoStr, @"photo", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    //   NSString *token = [returnedDict objectForKey:@"sessionId"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.myImageData forKey:myPhoto];
                    [[NSUserDefaults standardUserDefaults] setObject:nameStr forKey:myNickName];
                    [[NSUserDefaults standardUserDefaults] setObject:postCodeStr forKey:myPostalCode];
                    [[NSUserDefaults standardUserDefaults] setObject:countryStr forKey:myCountry];
                    [[NSUserDefaults standardUserDefaults] synchronize];
       //     [self performSegueWithIdentifier:@"NameToNextSegue" sender:self];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *alertMsg = msg;
                    NSString *okTitle = @"OK";
                    [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
                }
                
            }
        }
    }];
}

#pragma alert presentation

- (void)presentaAlert:(NSString *)aTitle withMsg:(NSString *)aMsg withConfirmTitle:(NSString *)aConfirmTitle {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:aTitle
                                message:aMsg
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:aConfirmTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [super dealloc];
}

@end
