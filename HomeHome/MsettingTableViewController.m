//
//  MsettingTableViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-27.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "MsettingTableViewController.h"
#import "SWRevealViewController.h"
#import "AppConstants.h"
#import "MexpertiseSetTableViewCell.h"
#import "MbioSetTableViewCell.h"
#import "CBHelp.h"
#import "NamePostPhoneViewController.h"
#import "NSString+EmptyCheck.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "CountryListTableViewController.h"

@interface MsettingTableViewController ()

@property (strong, nonatomic) NSArray *userInfoList;
@property (strong, nonatomic) NSArray *infoTitleList;
@property (strong, nonatomic) NSArray *sectionNameList1;

@property UIImagePickerController *ipc;
@property UIImage *pickedLargeImage;

@property (strong, nonatomic) NSData *myPhotoData;
@property (strong, nonatomic) NSString *nameStr;
@property (strong, nonatomic) NSString *postStr;
@property (strong, nonatomic) NSString *phoneStr;
@property (strong, nonatomic) NSString *expertiseStr;
@property (strong, nonatomic) NSString *bioStr;
@property (strong, nonatomic) NSString *countryStr;

@end

@implementation MsettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.sideBarItem setTarget:self.revealViewController];
        [self.sideBarItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.infoTitleList = @[@"Name", @"Postal Code", @"Phone"];
    self.sectionNameList1 = @[@"", @"", @"Expertises", @"Bio Details"];
    
    NSString *uName = [[NSUserDefaults standardUserDefaults] objectForKey:myNickName];
    NSString *uPostCode = [[NSUserDefaults standardUserDefaults] objectForKey:myPostalCode];
    NSString *uPhone = [[NSUserDefaults standardUserDefaults] objectForKey:myPhone];
    self.nameStr = uName;
    self.postStr = uPostCode;
    self.phoneStr = uPhone;
    if (uName == nil || [uName isStringEmpty]) {
        uName = @"Set Name";
    }
    if (uPostCode == nil || [uPostCode isStringEmpty]) {
        uPostCode = @"Set Postal Code";
    }
    if (uPhone == nil || [uPhone isStringEmpty]) {
        uPhone = @"Set Phone Number";
    }
    self.userInfoList = @[uName, uPostCode, uPhone];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newNameShow:) name:@"notificationSetName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPostShow:) name:@"notificationSetPost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPhoneShow:) name:@"notificationSetPhone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newExpertiseShow:) name:@"notificationSetExpertise" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newBioShow:) name:@"notificationSetBio" object:nil];
    
    self.expertiseStr = [[NSUserDefaults standardUserDefaults] objectForKey:myExpertise];
    self.bioStr = [[NSUserDefaults standardUserDefaults] objectForKey:myBio];
    self.myPhotoData = [[NSUserDefaults standardUserDefaults] objectForKey:myPhoto];
    self.countryStr = [[NSUserDefaults standardUserDefaults] objectForKey:myCountry];
}

- (void)newNameShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.nameStr = [[note userInfo] objectForKey:key];
    NSIndexPath *tempIdx = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tempIdx];
    if ([self.nameStr isStringEmpty] || self.nameStr == nil) {
        cell.detailTextLabel.text = @"Set Name";
    } else {
        cell.detailTextLabel.text = self.nameStr;
    }
}

- (void)newPostShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.postStr = [[note userInfo] objectForKey:key];
    NSIndexPath *tempIdx = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tempIdx];
 //   cell.detailTextLabel.text = self.postStr;
    if ([self.postStr isStringEmpty] || self.postStr == nil) {
        cell.detailTextLabel.text = @"Set Postal Code";
    } else {
        cell.detailTextLabel.text = self.postStr;
    }
}

- (void)newPhoneShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.phoneStr = [[note userInfo] objectForKey:key];
    NSIndexPath *tempIdx = [NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tempIdx];
  //  cell.detailTextLabel.text = self.phoneStr;
    if ([self.phoneStr isStringEmpty] || self.phoneStr == nil) {
        cell.detailTextLabel.text = @"Set Phone Number";
    } else {
        cell.detailTextLabel.text = self.phoneStr;
    }
}

- (void)newExpertiseShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.expertiseStr = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

- (void)newBioShow:(NSNotification *) note {
    NSString *key = @"keyStr";
    self.bioStr = [[note userInfo] objectForKey:key];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.countryStr = [[NSUserDefaults standardUserDefaults] objectForKey:myCountry];
    NSIndexPath *tempIdx = [NSIndexPath indexPathForRow:3 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tempIdx];
    
    if (self.countryStr == nil || [self.countryStr isStringEmpty]) {
        cell.detailTextLabel.text = @"Choose your country";
    } else {
 //       NSLog(@"TT12345TT- 99 --%@", self.countryStr);
        cell.detailTextLabel.text = self.countryStr;
    }
}

- (void)updatePhoto:(MphotoSetTableViewCell *)cellView {
    
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
        popPresenter.sourceView = cellView.photo;
        popPresenter.sourceRect = cellView.photo.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - imagepickercontroller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.pickedLargeImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSIndexPath *tempIdx = [NSIndexPath indexPathForRow:0 inSection:0];
    MphotoSetTableViewCell *cell = (MphotoSetTableViewCell *)[self.tableView cellForRowAtIndexPath:tempIdx];
    cell.photo.image = [CBHelp compressAndResizeImage:self.pickedLargeImage];
    self.myPhotoData = UIImageJPEGRepresentation(cell.photo.image, 1.0);
    
 //   self.photoImg = cell.photo.image;
/*
    NSData *imgData = UIImageJPEGRepresentation(cell.photo.image, 1.0);
    [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:myPhoto];
    [[NSUserDefaults standardUserDefaults] synchronize];
*/
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//   return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//   return the number of rows
    if (section == 1) {
        return 4;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1.0)];
        [tempView setBackgroundColor:[UIColor whiteColor]];
        
        return tempView;
    } else {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, tableView.frame.size.width - 15, 20)];
        [tLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [tLabel setText:[self.sectionNameList1 objectAtIndex:section]];
        [tLabel setTextColor:[UIColor whiteColor]];
        //  [tLabel setBackgroundColor:[UIColor grayColor]];
        [tempView addSubview:tLabel];
        UIColor *aa = [UIColor colorWithRed:(185.0/255.0) green:(185.0/255.0) blue:(185.0/255.0) alpha:1.0];
        [tempView setBackgroundColor:aa];
        
        return tempView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0.0f;
    } else {
        return 30.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MphotoSetTableViewCell *cell = (MphotoSetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"photoUpdate" forIndexPath:indexPath];
        if (self.myPhotoData) {
            cell.photo.image = [UIImage imageWithData:self.myPhotoData];
        } else {
            cell.photo.image = [UIImage imageNamed:@"User"];
        }
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 2) {
        MexpertiseSetTableViewCell *cell = (MexpertiseSetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"expertiseUpdate" forIndexPath:indexPath];
     //   NSString *temp = [[NSUserDefaults standardUserDefaults] objectForKey:myExpertise];
        if (self.expertiseStr == nil || [self.expertiseStr isStringEmpty]) {
            cell.expertise.text = @"Update your expertises.";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.expertise.textColor = aa;
        } else {
            cell.expertise.text = self.expertiseStr;
            cell.expertise.textColor = [UIColor blackColor];
        }
        return cell;
    } else if (indexPath.section == 3) {
        MbioSetTableViewCell *cell = (MbioSetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"bioUpdate" forIndexPath:indexPath];
    //    NSString *temp3 = [[NSUserDefaults standardUserDefaults] objectForKey:myBio];
        if (self.bioStr == nil || [self.bioStr isStringEmpty]) {
            cell.bioDetail.text = @"Update your bio details.";
            UIColor *aa = [UIColor colorWithRed:(142.0/255.0) green:(142.0/255.0) blue:(147.0/255.0) alpha:1.0];
            cell.bioDetail.textColor = aa;
            cell.bioDetail.textAlignment = NSTextAlignmentRight;
        } else {
            cell.bioDetail.text = self.bioStr;
            cell.bioDetail.textAlignment = NSTextAlignmentLeft;
            cell.bioDetail.textColor = [UIColor blackColor];
        }
        return cell;
    } else {
        if (indexPath.row == 3) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryUpdate" forIndexPath:indexPath];
        //    cell.textLabel.text = [self.infoTitleList objectAtIndex:indexPath.row];
            if (self.countryStr == nil || [self.countryStr isStringEmpty]) {
                cell.detailTextLabel.text = @"Choose your country";
            } else {
                cell.detailTextLabel.text = self.countryStr;
            }
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nameUpdate" forIndexPath:indexPath];
            cell.textLabel.text = [self.infoTitleList objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [self.userInfoList objectAtIndex:indexPath.row];
            return cell;
        }
    }
    // Configure the cell...
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 3) {
        [self chooseCountry];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)chooseCountry {
    //  NSLog(@"12345TT- 99 --");
    CountryListTableViewController *controller = (CountryListTableViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CountryListSB"];
    /*
     NSString *tagStr = [NSString stringWithFormat:@"%ld", (long)tapGestureRecognizer.view.tag];
     //    NSLog(@"uuuuuuuuTTT---%@", tagStr);
     controller.viewTag = tagStr;
     */
    controller.chosedCountry = self.countryStr;
    if ([self respondsToSelector:@selector(showViewController:sender:)]) {
        [self showViewController:controller sender:self];
    } else {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"namePostPhone"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        int temp = (int)indexPath.row;
        
        //   UINavigationController *nv = [segue destinationViewController];
        NamePostPhoneViewController *mm = (NamePostPhoneViewController *)[segue destinationViewController];
        
        mm.situationCode = temp;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (IBAction)saveAct:(id)sender {
    if ([self.postStr isStringEmpty] || self.postStr == nil) {
        NSString *alertMsg = @"Enter your postal code to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else if ([self.countryStr isStringEmpty] || self.countryStr == nil) {
        NSString *alertMsg = @"Choose your country to save.";
        NSString *okTitle = @"OK";
        [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
    } else {
        if ([self.countryStr isEqualToString:@"Canada"]) {
            NSString *tempPost = self.postStr;
            NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [tempPost stringByTrimmingCharactersInSet:whiteSpace];
            if (trimmed.length > 3 && trimmed.length < 7) {
                NSString *s1 = [trimmed substringToIndex:3];
                NSString *s2 = [trimmed substringFromIndex:3];
                self.postStr = [NSString stringWithFormat:@"%@ %@", s1, s2];
                //          NSLog(@"999fffiii--here--999 %@", self.postalCodeTxt.text);
            } else {
                self.postStr = trimmed;
            }
            
            NSIndexPath *tempIdx = [NSIndexPath indexPathForRow:1 inSection:1];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:tempIdx];
            //   cell.detailTextLabel.text = self.postStr;
            cell.detailTextLabel.text = self.postStr;
            
            NSString *postRegex = @"^[a-zA-Z][0-9][a-zA-Z][- ]*[0-9][a-zA-Z][0-9]$";
            NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postRegex];
            BOOL testResult = [postTest evaluateWithObject:self.postStr];
            if (!testResult) {
                NSString *alertMsg = @"Not right postal code format.";
                NSString *okTitle = @"OK";
                [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
            } else {
                //  NSLog(@"965--here--569, OK Canada");
                [self connectingServer];
            }
        } else if ([self.countryStr isEqualToString:@"United States"]) {
            NSString *tempPost = self.postStr;
            NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [tempPost stringByTrimmingCharactersInSet:whiteSpace];
            self.postStr = trimmed;
            
            NSString *postRegex = @"^[0-9]{5}(-[0-9]{4})?$";
            NSPredicate *postTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", postRegex];
            BOOL testResult = [postTest evaluateWithObject:self.postStr];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"merchant/profileupdate"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    NSString *photoS;
    if (self.myPhotoData) {
        photoS = [self.myPhotoData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        photoS = @"";
    }
    NSString *nameS = self.nameStr;
    if (nameS == nil || [nameS isStringEmpty]) {
        nameS = @"";
    }
    NSString *postCodeS = self.postStr;
    NSString *phoneS = self.phoneStr;
    if (phoneS == nil || [phoneS isStringEmpty]) {
        phoneS = @"";
    }
    NSArray *tempArr;
    if (self.expertiseStr == nil || [self.expertiseStr isStringEmpty]) {
        tempArr = [[NSArray alloc] init];
    } else {
        tempArr = [self.expertiseStr componentsSeparatedByString:@",\n"];
    }
    NSString *bioS = self.bioStr;
    if (bioS == nil || [bioS isStringEmpty]) {
        bioS = @"";
    }
    NSString *countryS = self.countryStr;
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:nameS, @"name", uToken, @"token", postCodeS, @"postcode", countryS, @"country", photoS, @"photo", phoneS, @"phone", tempArr, @"expertise", bioS, @"biodetail", nil];
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
                    
                    [[NSUserDefaults standardUserDefaults] setObject:self.myPhotoData forKey:myPhoto];
                    [[NSUserDefaults standardUserDefaults] setObject:self.nameStr forKey:myNickName];
                    [[NSUserDefaults standardUserDefaults] setObject:self.postStr forKey:myPostalCode];
                    [[NSUserDefaults standardUserDefaults] setObject:self.phoneStr forKey:myPhone];
                    [[NSUserDefaults standardUserDefaults] setObject:self.expertiseStr forKey:myExpertise];
                    [[NSUserDefaults standardUserDefaults] setObject:self.bioStr forKey:myBio];
                    [[NSUserDefaults standardUserDefaults] setObject:self.countryStr forKey:myCountry];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    //  [self performSegueWithIdentifier:@"NameToNextSegue" sender:self];
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
