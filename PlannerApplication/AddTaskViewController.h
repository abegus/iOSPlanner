//
//  AddTaskViewController.h
//  PlannerApplication
//
//  Created by Abe Gustafson on 12/12/16.
//  Copyright © 2016 Abe Gustafson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailView.h"

@interface AddTaskViewController : UIViewController
extern NSString* curCourse; //just to hold the path of the directory.
@property(nonatomic) NSString* nameOfString;
@property(nonatomic) NSString* oldName;
@property(nonatomic) NSString* innerDesc;

//extern NSMutableDictionary * lastTable;
//extern NSString * taskTitle; //global to store the taskTitle
@end

