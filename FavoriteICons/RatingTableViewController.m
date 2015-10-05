//
//  RatingTableViewController.m
//  FavoriteICons
//
//  Created by Ronald Hernandez on 10/4/15.
//  Copyright © 2015 Hardcoder. All rights reserved.
//

#import "RatingTableViewController.h"
#import "Icon.h"

@interface RatingTableViewController ()

@end

@implementation RatingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self refresh];
    
}

//loop through each of the cells.

-(void)refresh{

    for (int i = 0; i < NumRatingType; i++){
        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = (int) self.iconToRate.rating == i ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.iconToRate.rating = indexPath.row;
    [self refresh];


}




@end
