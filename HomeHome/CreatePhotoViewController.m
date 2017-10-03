//
//  CreatePhotoViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-23.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "CreatePhotoViewController.h"
#import "CBHelp.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface CreatePhotoViewController ()

@property UIImagePickerController *ipc;
@property UIImage *pickedLargeImage;
@property NSData *myImageData;

@end

@implementation CreatePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   CGFloat tempW = self.laterOutlet.frame.size.width;
 //   self.laterOutlet.layer.cornerRadius = tempW / 2;
    
  //  CGFloat imgW = self.userImg.frame.size.width;
  //  self.userImg.layer.cornerRadius = imgW / 2;
  //  self.userImg.layer.borderWidth = 1;
  //  self.userImg.layer.borderColor = [[UIColor grayColor] CGColor];
  //  self.userImg.clipsToBounds = YES;
    
    self.myImageData = [[NSUserDefaults standardUserDefaults] objectForKey:myPhoto];
    if (self.myImageData) {
        self.userImg.image = [UIImage imageWithData:self.myImageData];
    } else {
        self.userImg.image = [UIImage imageNamed:@"User"];
    }
    
    UITapGestureRecognizer *choosePhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseIt:)];
    [self.userImg addGestureRecognizer:choosePhoto];
    self.userImg.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseIt:(UITapGestureRecognizer *)tapGestureRecognizer {

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
        popPresenter.sourceView = self.userImg;
        popPresenter.sourceRect = self.userImg.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - imagepickercontroller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.pickedLargeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.userImg.image = [CBHelp compressAndResizeImage:self.pickedLargeImage];
    self.myImageData = UIImageJPEGRepresentation(self.userImg.image, 1.0);
    
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

- (IBAction)saveAction:(id)sender {
    if (self.myImageData) {
        [self connectingServer];
    } else {
        NSString *alertMsg = @"Choose your photo to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    }
}

- (IBAction)laterAction:(id)sender {
    NSString *role = [[NSUserDefaults standardUserDefaults] objectForKey:myRole];
    if ([role isEqualToString:@"customer"]) {
        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Custom" bundle:nil] instantiateViewControllerWithIdentifier:@"MainSlidingBaseCustom"];
        [self presentViewController:mainController animated:YES completion:nil];
    } else {
        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoCreateMerchant"];
        [self presentViewController:mainController animated:YES completion:nil];
    }
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Saving photo...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"setphoto"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSString *photoStr = [self.myImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:photoStr, @"photo", uToken, @"token", nil];
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
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSString *role = [[NSUserDefaults standardUserDefaults] objectForKey:myRole];
                    if ([role isEqualToString:@"customer"]) {
                        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Custom" bundle:nil] instantiateViewControllerWithIdentifier:@"MainSlidingBaseCustom"];
                        [self presentViewController:mainController animated:YES completion:nil];
                    } else {
                        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoCreateMerchant"];
                        [self presentViewController:mainController animated:YES completion:nil];
                    }
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

@end
