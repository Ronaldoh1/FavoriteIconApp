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
@property NSArray *iconsArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *iconSets = [IconSet iconSets];
    IconSet *set = (IconSet *)iconSets[0];
    self.iconsArray = set.icons;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Data Source Delegate: Here implement number of sections, number of rows and cellForRowAtIndexPath which displays the data for each.

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.iconsArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //Create the Cell

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    Icon *icon = self.iconsArray[indexPath.row];

    cell.textLabel.text = icon.title;
    cell.detailTextLabel.text = icon.subtitle;
    cell.imageView.image = icon.image;

    return cell;
}



@end
