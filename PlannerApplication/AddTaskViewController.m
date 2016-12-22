//
//  AddTaskViewController.m
//  PlannerApplication
//
//  Created by Abe Gustafson on 12/12/16.
//  Copyright © 2016 Abe Gustafson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddTaskViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AddTaskViewController (){
    NSString * typesString; //holds the Name of theTableTypes "location"
    NSMutableDictionary * theTable; //the data structure for holding every Class
   // NSString
}
@property (strong, nonatomic) IBOutlet UITextField *titleField; // TItle of the task
@property (strong, nonatomic) IBOutlet UITextView *descField; // Description of the field
@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[theTable objectForKey:key]
    
    
     NSLog(@"IN TEXT: %@",curCourse);
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    //set the connection string for the type
    typesString = curCourse;
    typesString = [typesString stringByAppendingString:@"Types"];
    
    // Title Text Box
    //UITextField* text
    self.titleField= [[UITextField alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height/8, self.view.frame.size.width-10, 30.0)];
    //self.titleField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.titleField];
    // View
    //UITextField* text2
    self.descField = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/5, self.view.frame.size.width, self.view.frame.size.height/5*4)];
    //self.descField .borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.descField];
    self.descField.backgroundColor = [UIColor colorWithRed:0.97647058823 green:0.97647058823 blue:0.97647058823 alpha:1];
    UIColor * k = [UIColor colorWithRed:0.80784313725 green:0.80784313725 blue:0.80784313725 alpha:1];
    [[self.descField layer] setBorderColor:[UIColor colorWithRed:0.80784313725 green:0.80784313725 blue:0.80784313725 alpha:1.0].CGColor];
    [[self.descField layer] setBorderWidth:1];
    
    theTable = [[[NSUserDefaults standardUserDefaults] dictionaryForKey: curCourse]mutableCopy];
    //ADD TEXT IF IT EXISTS IN THE LAST LEVEL
    //NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    //if([[[defaults dictionaryRepresentation] allKeys] containsObject:curCourse]){
    if(self.nameOfString){
        NSLog(@"EXISTS>>");
        self.titleField.text = self.nameOfString;//[theTable objectForKey:curCourse][0];
        self.descField.text = self.innerDesc;//[theTable objectForKey:curCourse][2];
    }
    else{
        self.titleField.placeholder = @"Enter Document Name";
        //self.descField.placeholder = @"Write Notes Here!";
    }
}

//grab the array of "stuff" at the current level. Create this object and save it, or overwrite it if it already exists (edit)
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"GOING BACK...Title/name: %@",self.titleField.text);
    
        //save the new item onto the table
        NSNumber *type = [NSNumber numberWithUnsignedInt:1];
        NSMutableArray * newArr = [[NSMutableArray alloc] init];
        [newArr addObject:self.titleField.text];
        [newArr addObject:type];
        [newArr addObject:self.descField.text];
        NSNumber *zero = [NSNumber numberWithUnsignedInt:0];
        [newArr addObject:zero];//checkbox
        [theTable removeObjectForKey:self.titleField.text];
        if(self.oldName)
            [theTable removeObjectForKey:self.oldName];
        [theTable setValue:newArr forKey: self.titleField.text];   //I think this is right?
       // NSLog(@"the key is: %@  , and the type is: %@",newArr[0],newArr[2]);
        [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: curCourse];
        //[theTable setValue:alertTextField.text forKey: alertTextField.text];
        
        
    }
    [super viewWillDisappear:animated];
}

-(void) perform:(id)sender {
    //NSLog(@"GOING BACK??");
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPic:(id)sender{
    NSLog(@"addpic");
    
}

@end
