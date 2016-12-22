//
//  AddPictureViewController.m
//  PlannerApplication
//
//  Created by Abe Gustafson on 12/12/16.
//  Copyright © 2016 Abe Gustafson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddPictureViewController.h"

@interface AddPictureViewController (){
    UIImagePickerController *picker;
    UIImagePickerController *picker2;
    UIImage *image;
    IBOutlet UIImageView *imageView;
    NSString * typesString; //holds the Name of theTableTypes "location"
    NSMutableDictionary * theTable; //the data structure for holding every Class
}
@property (strong, nonatomic) IBOutlet UITextField *titleField; // TItle of the task
@property (strong, nonatomic) IBOutlet UITextField *descField; // Description of the field
@end

@implementation AddPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     NSLog(@"IN PICTURE: %@",curCourse);
    self.view.backgroundColor = [UIColor whiteColor];
    typesString = curCourse;
    typesString = [typesString stringByAppendingString:@"Types"];

    /*self.titleField= [[UITextField alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/8, 100.0, 30.0)];
    self.titleField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.titleField];*/
    // Title Text Box
    self.titleField= [[UITextField alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height/8, self.view.frame.size.width/5*4-10, 30.0)];
    [[self.titleField layer] setBorderColor:[UIColor colorWithRed:0.80784313725 green:0.80784313725 blue:0.80784313725 alpha:1.0].CGColor];
    [self.view addSubview:self.titleField];
    
    
    imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/5 + 1, self.view.frame.size.width, self.view.frame.size.height/5*4)];
    [[imageView layer] setBorderColor:[UIColor colorWithRed:0.80784313725 green:0.80784313725 blue:0.80784313725 alpha:1.0].CGColor];
    [self.view addSubview:imageView];
    
    //upload button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(uploadExisting) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
    [button setTitle:@"Choose" forState:UIControlStateNormal];
    button.frame = CGRectMake(self.view.frame.size.width/5*4, self.view.frame.size.height/8, self.view.frame.size.width/5-10, 30.0);
    [self.view addSubview:button];
    
    theTable = [[[NSUserDefaults standardUserDefaults] dictionaryForKey: curCourse]mutableCopy];
    if(!theTable) theTable = [[NSMutableDictionary alloc] init];
    if(self.nameOfString){
        NSLog(@"EXISTS>>");
        self.titleField.text = self.nameOfString;//[theTable objectForKey:curCourse][0];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent: self.picName];
        image = [UIImage imageWithContentsOfFile:path];
        NSLog(@"getting path: %@",path);
        
        [imageView setImage:image];
        //self.descField.text = self.innerDesc;//[theTable objectForKey:curCourse][2];
    }
    else{
        NSLog(@"DOES NOT EXIST>>");
        //self.titleField.text = @"Title";
        self.titleField.placeholder = @"Enter Title...           Pick Picture ->";
        //self.descField.text = @"Description..";
        
        
    }
    
    // Camera
    /*UIBarButtonItem *taskButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                   //style:UIBarButtonSystemItemCamera
                                   target:self
                                   action:@selector(ChooseExisting:)];*/
    //self.navigationItem.rightBarButtonItem = taskButton;
    
    
    
    //set picture
   // UIImage *img = [UIImage imageNamed:@"photo"];
    //[imageView setImage:img];
    
    
//    @try {
//        picker = [[UIImagePickerController alloc]init];
//        picker.delegate=self;
//        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        [self presentViewController:picker animated:YES completion:NULL];
//    }
//    @catch ( NSException *e ) {
//        //[treeController setValue:nil forKeyPath:@"selection.predicate"];
//        NSLog(@"bug..");
//    }
}







/*- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      [NSString stringWithFormat: @"MyImage.png"] ];
    image = [UIImage imageWithContentsOfFile:path];
    return image;
}*/
- (void)uploadExisting {
    NSLog(@"button was pressed");
    picker = [[UIImagePickerController alloc]init];
    picker.delegate=self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

/*- (IBAction)btnSave:(id)sender {
    
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat: @"MyImage.png"]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
        NSLog(@"saved");
    }
}

- (IBAction)btnLoad:(id)sender {
    [self loadImage];
}*/



-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    
    //generate random string name for the file, append .png ?
    NSString * filetype = @".png";
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 8];
    for (int i=0; i<8; i++) { [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];}
    NSString *fileName = [NSString stringWithFormat:@"%@%@", randomString,filetype];
     NSLog(@"selected image name: %@",fileName);
    
    //add the "image name" to the array (name,type,imageName), then add that array to theTable under curCourse string
    NSNumber *type = [NSNumber numberWithUnsignedInt:2];
    NSMutableArray * newArr = [[NSMutableArray alloc] init];
    [newArr addObject:self.titleField.text];
    [newArr addObject:type];
    [newArr addObject:fileName];
    NSNumber *zero = [NSNumber numberWithUnsignedInt:0];
    [newArr addObject:zero];
    [theTable removeObjectForKey:self.titleField.text];
    if(self.oldName)
        [theTable removeObjectForKey:self.oldName];
    [theTable setValue:newArr forKey: self.titleField.text];   //I think this is right?
    NSLog(@"the key is: %@  , and the type is: %@",newArr[0],newArr[2]);
    [[NSUserDefaults standardUserDefaults] setObject: theTable forKey: curCourse];
    
    //store image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:YES]; // was no
    NSLog(@"realPath: %@",savedImagePath);
    
    //return to view
    [self dismissViewControllerAnimated:YES completion:NULL];
}
















//grab the array of "stuff" at the current level. Create this object and save it, or overwrite it if it already exists (edit)
/*-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"GOING BACK...Title/name: %@",self.titleField.text);
        
    }
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    [super viewWillDisappear:animated];
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPic:(id)sender{
    NSLog(@"addpic");
    
}



/*-(IBAction)ChooseExisting{
 //picker2 = [[UIImagePickerController alloc]init];
 //picker2.delegate=self;
 //[picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
 //[self presentViewController:picker2 animated:YES completion:NULL];
 picker = [[UIImagePickerController alloc]init];
 picker.delegate=self;
 [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
 [self presentViewController:picker animated:YES completion:NULL];
 // [picker release];
 
 }*/

@end
