//
//  EditDetailTableViewController.m
//  FavoriteICons
//
//  Created by Ronald Hernandez on 10/4/15.
//  Copyright © 2015 Hardcoder. All rights reserved.
//

#import "EditDetailTableViewController.h"
#import "DetailViewController.h"
#import "Icon.h"
#import "RatingTableViewController.h"

@interface EditDetailTableViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *ratingTextField;

@end

@implementation EditDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    self.imageView.image = self.iconToDisplay.image;
    self.titleTextField.text = self.iconToDisplay.title;
    self.subTitleTextField.text = self.iconToDisplay.subtitle;
    self.ratingTextField.text = [Icon ratingToString:self.iconToDisplay.rating];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.iconToDisplay.image = self.imageView.image;
    self.iconToDisplay.title = self.titleTextField.text;
    self.iconToDisplay.subtitle = self.subTitleTextField.text;
   // self.iconToDisplay.rating = self.ratingTextField.text;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ((indexPath.row == 0 && indexPath.section == 0) || (indexPath.row == 2 && indexPath.section == 1)) {
        return indexPath;
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;

    [self presentViewController:picker animated:YES completion:nil];




}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage *image = info[UIImagePickerControllerOriginalImage];

    self.iconToDisplay.image = image;
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"gotBigImage"]) {
        DetailViewController *destVC = (DetailViewController *)segue.destinationViewController;
        destVC.iconToDisplay = self.iconToDisplay;


    }

    if ([segue.identifier isEqualToString:@"toRating"]) {
        RatingTableViewController *destVC = (RatingTableViewController *)segue.destinationViewController;
        destVC.iconToRate = self.iconToDisplay;

        
    }


}


@end
