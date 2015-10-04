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
#import "CustomCell.h"

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



    //Add gesture recognizer to table view to allow long press.

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];




}
-(IBAction)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress{

    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];

    UIGestureRecognizerState state = longPress.state;
    static UIView *snapShot = nil;
    static NSIndexPath *sourceIndexPath = nil;

    switch (state) {
        case UIGestureRecognizerStateBegan:{
            if (indexPath) {

                sourceIndexPath = indexPath;
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

                snapShot = [self customSnapShotFromView:cell];

                __block CGPoint center = cell.center;
                snapShot.center = cell.center;
                snapShot.alpha = 0;
                [self.tableView addSubview:snapShot];

                [UIView animateWithDuration:0.25 animations:^{

                    center.y = location.y;
                    snapShot.center = center;
                    snapShot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapShot.alpha = 0.98;


                    cell.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.alpha = 0;
                    cell.imageView.alpha = 0;

                }];

            }
        }

            break;


        case UIGestureRecognizerStateChanged:{

            CGPoint center = snapShot.center;
            center.y = location.y;
            snapShot.center = center;

            //rearange the data model and rows.

            IconSet *destSet = [self.iconsSetsArray objectAtIndex:indexPath.section];

            if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.row < destSet.icons.count) {



                //get the source and the destination
                IconSet *sourceSet = self.iconsSetsArray[sourceIndexPath.section];
                IconSet *destSet = self.iconsSetsArray[indexPath.section];

                // get the icon to move
                Icon *iconTomove = sourceSet.icons[sourceIndexPath.row];

                if(sourceSet == destSet){
                    [destSet.icons exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                }else{

                    [destSet.icons insertObject:iconTomove atIndex:indexPath.row];
                    [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];
                    
                }

                //tell the tableView about the move.

                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                //update the indexPath

                sourceIndexPath = indexPath;


            }


        }
            break;



        default:{


            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{

                snapShot.center = cell.center;
                snapShot.transform = CGAffineTransformMakeScale(1.0, 1.0);

                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.alpha = 1;
                cell.detailTextLabel.alpha = 1;
                cell.imageView.alpha = 1;


            } completion:^(BOOL finished) {
                [snapShot removeFromSuperview];
            }];
            sourceIndexPath = nil;
        }
            break;
    }
}
-(UIView *)customSnapShotFromView:(UIView *)inputView{

    UIView *snapShot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapShot.layer.masksToBounds = NO;
    snapShot.layer.cornerRadius = 0.0;
    snapShot.layer.shadowOffset = CGSizeMake(-5.0, 0);
    snapShot.layer.shadowRadius = 5.0;
    snapShot.layer.shadowOpacity = 0.4;

    return snapShot;

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

//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //remove highlight
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    IconSet *set = self.iconsSetsArray[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];

    }


}


//MOVING ROWS//

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{

    IconSet *set = self.iconsSetsArray[indexPath.section];

    if([self isEditing] && indexPath.row >= set.icons.count){

        return NO;
    }else{
        return YES;
    }


}

//MOVE ROW FROM AND TO -- Based on indexPath
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{


    //get the source and the destination
    IconSet *sourceSet =self.iconsSetsArray[sourceIndexPath.section];
    IconSet *destSet = self.iconsSetsArray[destinationIndexPath.section];

    // get the icon to move
    Icon *iconTomove = sourceSet.icons[sourceIndexPath.row];

    if(sourceSet == destSet){
        [destSet.icons exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
    }else{

        [destSet.icons insertObject:iconTomove atIndex:destinationIndexPath.row];
        [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];

    }


}


//Are you ok with me moving the item to this destination idexpath or not? if so return the indexpath
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{

    IconSet *set = self.iconsSetsArray[proposedDestinationIndexPath.section];

    if([self isEditing] && proposedDestinationIndexPath.row >= set.icons.count){


        return [NSIndexPath indexPathForRow:set.icons.count-1 inSection:proposedDestinationIndexPath.section];

    }else{
        return proposedDestinationIndexPath;
    }




}
//Create and configure each cell.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //Create the Cell

    UITableViewCell *cell = nil;

    //configure the cell.


    IconSet *set = self.iconsSetsArray[indexPath.section];
    //check if we are in editing mode and we have an extra row.
    if(indexPath.row >= set.icons.count && [self isEditing]){

       cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

        cell.textLabel.text = @"Add Icon";
        cell.detailTextLabel.text = nil;
        cell.imageView.image = nil;

    }else{

    cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];

        CustomCell *iconCell = (CustomCell *)cell;


    Icon *icon = set.icons[indexPath.row];

    iconCell.titleLabel.text = icon.title;
    iconCell.subtitleLabel.text = icon.subtitle;
    iconCell.iconImageView.image = icon.image;

        if (icon.rating == RatingTypeAwesome) {
            iconCell.favoriteImage.image = [UIImage imageNamed:@"star_uns.png"];
        }

    }

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    IconSet *set = self.iconsSetsArray[indexPath.section];

    if (indexPath.row >= set.icons.count && [self isEditing]) {

        return 40;
    }else{
        return 100;
    }

}


@end
