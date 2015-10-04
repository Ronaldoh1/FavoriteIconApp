//
//  ViewController.m
//  FavoriteICons
//
//  Created by Ronald Hernandez on 10/2/15.
//  Copyright © 2015 Hardcoder. All rights reserved.
//

#import "ViewController.h"
#import "Icon.h"
#import "IconSet.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property NSArray *iconsSetsArray;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.iconsSetsArray = [IconSet iconSets];

    //add the edit button to the nav bar - this will allow the tableview to go into editing mode.

    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.tableView.allowsSelectionDuringEditing = YES;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Data Source Delegate: Here implement number of sections, number of rows and cellForRowAtIndexPath which displays the data for each.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.iconsSetsArray.count;
}

//The array now contains sets and for each set, we can get the name associated with the set.
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    IconSet *set = self.iconsSetsArray[section];

    return set.name;
}

//we need to return the appropriate number of rows for each section.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    int adjustment = [self isEditing] ? 1 :0;



    IconSet *set = self.iconsSetsArray[section];


    return set.icons.count + adjustment;

}

//**DELETE ROW**//
//must override commitEditing Style.
//Check the editing style - for delete.

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{



    if (editingStyle == UITableViewCellEditingStyleDelete) {

        IconSet *set = self.iconsSetsArray[indexPath.section];

        [set.icons removeObjectAtIndex:indexPath.row];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    //here we need to check if the editing style is inset if so we need to add an extra row.
    }else if(editingStyle == UITableViewCellEditingStyleInsert){

        IconSet *set = self.iconsSetsArray[indexPath.section];
        Icon *newIcon = [[Icon alloc]initWithTitle:@"New Icon" subtitle:@"" imageName:nil];
        [set.icons addObject:newIcon];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];


    }
}
//Tell the tableView everything that you want to change.
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{

    [super setEditing:editing animated:animated];


    //add the placeholder rows.
    if (editing) {

        [self.tableView beginUpdates];
        for (int i = 0; i < self.iconsSetsArray.count; i++){


            IconSet *set = self.iconsSetsArray[i];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];


        //here we want to remove the place holder rows.
    }else {


        [self.tableView beginUpdates];
        for (int i = 0; i < self.iconsSetsArray.count; i++){


            IconSet *set = self.iconsSetsArray[i];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];

    }
}
//we want for the add row to have the green icon to add a row.

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

    IconSet *set = self.iconsSetsArray[indexPath.section];

    if (indexPath.row >= set.icons.count) {

        return UITableViewCellEditingStyleInsert;
    }else{

        return UITableViewCellEditingStyleDelete;
    }
}

//Willselect Row at IndexPath will allow the users to select the add row but not any other rows during editing mode.

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    IconSet *set = self.iconsSetsArray[indexPath.section];

    if([self isEditing] && indexPath.row < set.icons.count){

        return nil;
    }else{
        return indexPath;
    }

}

//Should performSegueWithIdentifier - here we want to prevent the user from segue during editing mode.

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{

    if ([identifier isEqualToString:@"GoToDetail"] && [self isEditing]) {

        return NO;

    }else{
        
        return YES;
    }
}

//Create and configure each cell.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //Create the Cell

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    //configure the cell.


    IconSet *set = self.iconsSetsArray[indexPath.section];
    //check if we are in editing mode and we have an extra row.
    if(indexPath.row >= set.icons.count && [self isEditing]){

        cell.textLabel.text = @"Add Icon";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;

    }else{


    Icon *icon = set.icons[indexPath.row];

    cell.textLabel.text = icon.title;
    cell.detailTextLabel.text = icon.subtitle;
    cell.imageView.image = icon.image;
    }
    return cell;
}



@end
