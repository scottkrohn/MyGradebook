//
//  CourseViewController.swift
//  GradeBook
//
//  Created by Scott on 4/21/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
    
    var semesterController: SemesterController = SemesterController();
    var currentCourse: Course?;
    var weightCategories: [String] = Array<String>();
    var weightValues: [Int] = Array<Int>();
    
    @IBOutlet weak var courseTable: UITableView!
    
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        let categories: NSDictionary = (NSKeyedUnarchiver.unarchiveObjectWithData((currentCourse?.categories)!)) as! NSDictionary;
        
        for(key, value) in categories {
            weightCategories.append(key as! String);
            weightValues.append(value as! Int);
        }
        navBar.title = currentCourse?.courseName;
        calcWeightedGrade();
    }
    
    // Recalculate the current weighted grade when the view appears.
    override func viewDidAppear(animated: Bool) {
        calcWeightedGrade();
    }
    
    override func didReceiveMemoryWarning() {
    }
    
    // Delegate function: indicate number of rows for table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weightCategories.count;
    }
    
    // Display the current weighted grade for the course.
    func calcWeightedGrade() {
        let weightedGrade = semesterController.calcCourseWeightedGrade(currentCourse!);
        gradeLabel.text = String(format: "Current weighted grade: %.2f", weightedGrade) + "%";
    }
    
    // Delegate function: populate the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath)
        cell.textLabel!.text = weightCategories[indexPath.item];
        cell.detailTextLabel!.text = "Weight: " + String(weightValues[indexPath.item]) + "%";
        return cell
    }
    
    // Send course and weight category name to next view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewCategorySegue" {
            if let categoryViewController = segue.destinationViewController as? CategoryDetailViewController {
                categoryViewController.currentCourse = currentCourse;
                categoryViewController.categoryName = weightCategories[courseTable.indexPathForSelectedRow!.item];
            }
        }
    }
    
    // Open a web view to let the user login to my.asu.edu
    @IBAction func openSafari(sender: AnyObject) {
        let url = NSURL(string: "https://my.asu.edu")
        UIApplication.sharedApplication().openURL(url!)
    }
}
