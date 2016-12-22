//
//  CourseDetailView.h
//  PlannerApplication
//
//  Created by Abe Gustafson on 12/10/16.
//  Copyright © 2016 Abe Gustafson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailView : UIViewController <UITableViewDelegate, UITableViewDataSource>

extern NSString* curCourse;
//extern NSMutableDictionary * theTable;
@end


/* hold two arrays for the data being stored, one for the actually link names?
 * the other for the type. 0 for folder, 1 for Notes, 2 for Picture. */
