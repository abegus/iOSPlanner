//
//  ViewController.m
//  PlannerApplication
//
//  Created by Abe Gustafson on 12/10/16.
//  Copyright © 2016 Abe Gustafson. All rights reserved.
//

#import "ViewController.h"
#import "CourseDetailView.h"

@interface ViewController (){
    NSMutableDictionary * theTable; //the data structure for holding every Class
}
@property (weak, nonatomic) IBOutlet UITableView *tableView; // Global TABLE VIEW
//CourseDetailView * detailView;

@end

@implementation ViewController{
    NSMutableArray *courses;
    CourseDetailView * detailView;
}

- (IBAction)addCourse:(id)sender {
    // Alert View to show add course
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: @"Add Root Directory"
                                message: @"Enter Name"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   UITextField *alertTextField = alert.textFields.firstObject;
                                                   [courses addObject:alertTextField.text];
                                                   [theTable setValue:alertTextField.text forKey: alertTextField.text];
                                                   [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: @"MyAppsTable"];
                                                   [_tableView reloadData];
                                               }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler: nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Text here";
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    //add the course to the dictionary in User Defaults
    [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: @"MyAppsTable"];
}
- (IBAction)addPicture:(id)sender{}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Root Directories";
    //load the mutable dictionary for this view?, name of the Dictionary being  "MyAppsTable".  or create if empty
    theTable = [[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"MyAppsTable"]mutableCopy];
    if(!theTable) theTable = [[NSMutableDictionary alloc] init];
    
    // load all of the dictionary information
    for( id key in theTable){
        //NSLog(@"key= %@",[theTable objectForKey:key]);
    }
    
    // Create Array
    courses = [(NSArray*)[theTable allValues] mutableCopy];
    //courses = [NSMutableArray arrayWithObjects:@"MTH 208", nil];
}


//transition into the CourseDetailView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curCourse = courses[indexPath.row];
    CourseDetailView* viewController = [[CourseDetailView alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    //    [viewController release];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Count of Array of Courses
    return [courses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell Stuff
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [courses objectAtIndex:indexPath.row];
    return cell;
}



// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSString *key = [courses objectAtIndex:indexPath.row];
        //for(id key in [[NSUserDefaults standardUserDefaults] ])
        NSLog(@"? %@",key);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [courses removeObjectAtIndex:indexPath.row];
        if ([theTable objectForKey:key]) {
            [theTable removeObjectForKey:key];
            //theTable = nil;
            [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: @"MyAppsTable"];
            //[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        [tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
