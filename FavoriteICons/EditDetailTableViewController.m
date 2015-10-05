//
//  EditDetailTableViewController.m
//  FavoriteICons
//
//  Created by Ronald Hernandez on 10/4/15.
//  Copyright © 2015 Hardcoder. All rights reserved.
//

#import "EditDetailTableViewController.h"
#import "Icon.h"

@interface EditDetailTableViewController ()<UITextFieldDelegate>
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
