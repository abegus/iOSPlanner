//
//  CourseDetailView.m
//  PlannerApplication
//
//  Created by Abe Gustafson on 12/10/16.
//  Copyright © 2016 Abe Gustafson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseDetailView.h"
#import "ViewController.h"
#import "AddTaskViewController.h"
#import "AddPictureViewController.h"

@interface CourseDetailView (){
    NSMutableDictionary * theTable; //the data structure for holding every Class
    //NSMutableDictionary * theTableTypes; //holds the types for each thing in the dictionary
    
    
    NSString * typesString; //holds the Name of theTableTypes "location"
}


@end

@implementation CourseDetailView{
    NSMutableArray* tasks;
    NSMutableArray * rowType; //0 for folder, 1 for Notes, 2 for Picture
    NSMutableArray * checkType; //0 for none, 1 for uncheck 2 for check
    UITableView *tableView;
    UISwipeGestureRecognizer * recognizer;
    //NSMutableArray *courses;
    
}
/*- (void)doMyLayoutStuff:(id)sender {
    // stuff
    NSLog(@"RETURNING TO OLD VIEW");
}*/
//called when returned to from addtaskviewcontroller
- (void)viewWillAppear: (BOOL)animated{
    //NSLog(@"COURSE DETAIL VIEW APPEARING");
     NSLog(@"IN COURSE DETAIL: %@",curCourse);
    [tableView reloadData];
    
    //[self viewDidLoad];
    theTable = [[[NSUserDefaults standardUserDefaults] dictionaryForKey: curCourse]mutableCopy];//name is the curCourse
    if(!theTable) theTable = [[NSMutableDictionary alloc] init];
    
    
    // Create Array
    tasks = [[NSMutableArray alloc] init];
    rowType = [[NSMutableArray alloc] init];
    checkType = [[NSMutableArray alloc] init];
    for(id key in theTable){
        //if([theTable objectForKey:key][1]){
        NSNumber *typeInt = [theTable objectForKey:key][1];
        int x = [[theTable objectForKey:key][1] intValue];
        [rowType addObject: [theTable objectForKey:key][1]];
        
        [checkType addObject: [theTable objectForKey:key][3]];
        //}
        NSString * test = [theTable objectForKey:key][0];
        NSLog(@"         the key is: %@  , and the type is: %@",test,typeInt);
        [tasks addObject:test];
        
    }
    [tableView reloadData];

}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([curCourse rangeOfString:@"/"].location != NSNotFound){
            NSRange lastSlash = [curCourse rangeOfString:@"/" options:NSBackwardsSearch];
        //lastSlash.length = curCourse.length;
            curCourse = [curCourse substringToIndex:lastSlash.location];
        //curCourse = [curCourse stringByReplacingCharactersInRange:lastSlash withString: @""];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Array
    self.navigationItem.title = curCourse; // like "MTH 208"
    typesString = curCourse;
    typesString = [typesString stringByAppendingString:@"Types"];
    
    float height = [[UIScreen mainScreen] bounds].size.height;
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //load in the tasks from theTable, or create object if there is none
    theTable = [[[NSUserDefaults standardUserDefaults] dictionaryForKey: curCourse]mutableCopy];//name is the curCourse
    if(!theTable) theTable = [[NSMutableDictionary alloc] init];
    NSLog(@"IN COURSE DETAIL: %@",curCourse);
    
    // Create Array
    tasks = [[NSMutableArray alloc] init];
    rowType = [[NSMutableArray alloc] init];
    checkType = [[NSMutableArray alloc] init];
    for(id key in theTable){
        //if([theTable objectForKey:key][1]){
            NSNumber *typeInt = [theTable objectForKey:key][1];
            int x = [[theTable objectForKey:key][1] intValue];
            [rowType addObject: [theTable objectForKey:key][1]];
        [checkType addObject: [theTable objectForKey:key][3]];
        //}
        NSString * test = [theTable objectForKey:key][0];
        NSLog(@"SENDING...the key is: %@  , and the type is: %@",test,typeInt);
        [tasks addObject:test];
    }
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    // Add Button
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                   //initWithTitle:@"Add Item"
                                   //style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(addThing:)];
    self.navigationItem.rightBarButtonItem = flipButton;
    // Add Thing
    UIBarButtonItem *taskButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                   //initWithTitle:@"Add Task"
                                   //style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(addTask:)];
    //add a picture
    UIBarButtonItem *picButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                   //initWithTitle:@"Add picture"
                                   //style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(addPicture:)];
    
    NSArray *buttonArray = [[NSArray alloc] initWithObjects:flipButton,taskButton,picButton,nil];
    self.navigationItem.rightBarButtonItems = buttonArray;
    
    
    //Add a right swipe gesture recognizer
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(didSwipe:)];
    //recognizer.delegate = self;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [tableView addGestureRecognizer:recognizer];
    //[recognizer release];
}

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Did Swipe");
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:tableView];
        NSIndexPath *swipedIndexPath = [tableView indexPathForRowAtPoint:swipeLocation];
        
        NSLog(@"Index: %ld",swipedIndexPath.row);
        //[imageArray removedObjectAtIndexPath:swipedIndexPath.row];
        //[//tableView reloadData];
        
        //@try{
        
        //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:swipeLocation];
        NSNumber *n = [NSNumber numberWithInt:([checkType[indexPath.row] integerValue] + 1) % 3];
        checkType[indexPath.row] = n;
        NSLog(@"Changed %ld  row to %@",(long)indexPath.row,n);
        
        
        //save the new "state" to the table
        NSNumber *typeFile = [theTable objectForKey:tasks[indexPath.row]][1];
        NSString * miscFiled = [theTable objectForKey:tasks[indexPath.row]][2];
        NSMutableArray * adding = [[NSMutableArray alloc] init];
        [adding addObject:tasks[indexPath.row]]; // name
        [adding addObject:typeFile];//type
        [adding addObject:miscFiled];//nothing.
        [adding addObject:n]; //for the checkType
        [theTable setValue:adding forKey: tasks[indexPath.row]];
        [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: curCourse];
        
        
        
        [tableView reloadData];

    }
}



- (IBAction)addTask:(id)sender{
    //construct array to add to the dictionary
    //NSMutableArray * insertArray = [[NSMutableArray alloc] init];
    NSNumber *zero = [NSNumber numberWithUnsignedInt:0];
    // This is for entering things into the alert
    //NSLog(@"ADD TASKS AND OTHER THINGS ETC");
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle: @"Create Folder"
                                message: @"Enter Name"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action){
                                                   UITextField *alertTextField = alert.textFields.firstObject;
                                                   [tasks addObject:alertTextField.text];
                                                   [rowType addObject:zero];
                                                   [checkType addObject:zero];
                                                   NSMutableArray * adding = [[NSMutableArray alloc] init];
                                                   [adding addObject:alertTextField.text]; // name
                                                   [adding addObject:zero];//type
                                                   [adding addObject:zero];//nothing.
                                                   [adding addObject:zero]; //for the checkType
                                                   [theTable setValue:adding forKey: alertTextField.text];
                                                   //set value to 0, meaning it is a FOLDER
                                                   //[theTableTypes setValue:0 forKey: alertTextField.text];
                                                   //[[NSUserDefaults standardUserDefaults] setObject: theTableTypes forKey: typesString];
                                                   [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: curCourse];
                                                   [tableView reloadData];
                                               }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                   handler: nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Text here";
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)addThing:(id)sender{
    // This is for entering things into the alert
    AddTaskViewController* viewController = [[AddTaskViewController alloc] init];
    
    
    [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: curCourse];
    [tableView reloadData];
    
    curCourse = curCourse;
    viewController.nameOfString = nil;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (IBAction)addPicture:(id)sender{
    // This is for entering things into the alert
    AddPictureViewController  * viewController = [[AddPictureViewController alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: curCourse];
    [tableView reloadData];
    
    curCourse = curCourse;
    viewController.nameOfString = nil;
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

// set the new path before you load it in the next view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //NSLog(@"row #: %ld",(long)indexPath.row);
    NSLog(@"row type: %d",[rowType[indexPath.row] intValue]);
    //check type!!
    if([rowType[indexPath.row] intValue] == 0){
    
        //append the old path onto the current one with a "/" inbetween
        NSString * temp = curCourse;
        curCourse = temp;
        curCourse = [curCourse stringByAppendingString:@"/"];
        curCourse = [curCourse stringByAppendingString:tasks[indexPath.row]];
        CourseDetailView* viewController = [[CourseDetailView alloc] init];
    
        //[self.navigationController pushViewController:viewController animated:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        //    [viewController release];
    }
    else if([rowType[indexPath.row] intValue] == 1){//task description
        //append the old path onto the current one with a "/" inbetween
        //NSString * temp = curCourse;
        //curCourse = temp;
        //curCourse = [curCourse stringByAppendingString:@"/"];
        //curCourse = [curCourse stringByAppendingString:tasks[indexPath.row]];
        NSMutableArray * contents =[[NSMutableArray alloc] init];
        contents = [theTable objectForKey:tasks[indexPath.row]];
        AddTaskViewController* viewController = [[AddTaskViewController alloc] init];
        //NSLog(@"the contents... %@, %@",contents[0],contents[2]);
        viewController.nameOfString = contents[0];
        viewController.oldName = contents[0];
        viewController.innerDesc =contents[2];
        
        //set global name
        viewController.nameOfString = tasks[indexPath.row];
        
        //[self.navigationController pushViewController:nextVC animated:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        //[self presentViewController:alert animated:YES completion:nil];
        //[self presentViewController:viewController animated:YES completion:nil];
    }
    else{//Picture;
        NSMutableArray * contents =[[NSMutableArray alloc] init];
        contents = [theTable objectForKey:tasks[indexPath.row]];
        AddPictureViewController* viewController = [[AddPictureViewController alloc] init];
        NSLog(@"the contents... %@, %@",contents[0],contents[2]);
        viewController.nameOfString = contents[0];
        viewController.oldName = contents[0];
        viewController.picName =contents[2];
        
        //set global name
        viewController.nameOfString = tasks[indexPath.row];
        
        //[self.navigationController pushViewController:nextVC animated:YES];
        [self.navigationController pushViewController:viewController animated:YES];
        //[self presentViewController:alert animated:YES completion:nil];
        //[self presentViewController:viewController animated:YES completion:nil];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Count of Array of Courses
    return [tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell Stuff
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
   // cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
    if([rowType[indexPath.row] intValue] == 0){ //folder
        UIImageView *cellBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        cellBackView.backgroundColor=[UIColor clearColor];
        cellBackView.image = [UIImage imageNamed:@"folder.png"];
        cell.backgroundView = cellBackView;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else if([rowType[indexPath.row] intValue] == 1){ //text
        //cell.backgroundColor = [UIColor greenColor];
        UIImageView *cellBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        cellBackView.backgroundColor=[UIColor clearColor];
        cellBackView.image = [UIImage imageNamed:@"notes.png"];
        cell.backgroundView = cellBackView;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else{
        //cell.backgroundColor = [UIColor blueColor];
        UIImageView *cellBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        cellBackView.backgroundColor=[UIColor clearColor];
        cellBackView.image = [UIImage imageNamed:@"camera.png"];
        cell.backgroundView = cellBackView;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    
    if([checkType[indexPath.row] intValue] == 0){ //nothing
        cell.imageView.image = nil;
    }
    else if([checkType[indexPath.row] intValue] == 1){ //Empty
        cell.imageView.image = [UIImage imageNamed:@"uncheck.png"];
    }
    else{//checked
        cell.imageView.image = [UIImage imageNamed:@"check.jpg"];
    }
    
    cell.textLabel.text = [tasks objectAtIndex:indexPath.row];
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
        NSString *key = [tasks objectAtIndex:indexPath.row];
        NSLog(@"? %@",key);
        [tasks removeObjectAtIndex:indexPath.row];
        if ([theTable objectForKey:key]) {
            [theTable removeObjectForKey:key];
            NSLog(@"did remove");
            [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: curCourse];
        }
        
        [tableView reloadData];
    }
}
- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    
   
}


@end


