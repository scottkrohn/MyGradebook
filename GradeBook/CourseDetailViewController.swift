//
//  CourseDetailViewController.swift
//  GradeBook
//
//  Created by Scott 3/31/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {
    
    var semesterController: SemesterController = SemesterController();
    var selectedSemester: Semester?
    var enrolledCourses: [Course]?
    
    @IBOutlet weak var courseTable: UITableView!

    @IBOutlet weak var gpaLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enrolledCourses = ((selectedSemester?.mutableSetValueForKey("enrolledCourses"))?.allObjects as! [Course])
        gpaLabel.text = String(format: "%.2f", semesterController.calcSemesterGPA(enrolledCourses!));
    }
    
    override func viewDidAppear(animated: Bool) {
        enrolledCourses = ((selectedSemester?.mutableSetValueForKey("enrolledCourses"))?.allObjects as! [Course])
        gpaLabel.text = String(format: "%.2f", semesterController.calcSemesterGPA(enrolledCourses!));
        courseTable.reloadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Delegate function: indicate number of rows for table view.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (enrolledCourses?.count)!;
    }
    
    // Delegate function: populate the table view.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("protoCell", forIndexPath: indexPath)
        cell.textLabel!.text = enrolledCourses?[indexPath.item].courseName;
        let courseGrade = semesterController.calcCourseWeightedGrade(enrolledCourses![indexPath.item]);
        cell.detailTextLabel!.text = "Grade: " + String(format: "%.2f", courseGrade) + "%";
        return cell;
    }
    
    // Facilitate deleting data from the table view.
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            semesterController.deleteCourse(selectedSemester!, course: (enrolledCourses?[indexPath.item])!);
            enrolledCourses?.removeAtIndex(indexPath.item);
            courseTable.reloadData();
        }
    }
    
    // Send data to next view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addCourseSegue" {
            if let addCourseController = segue.destinationViewController as? AddCourseViewController {
                addCourseController.selectedSemeter = selectedSemester;
            }
        }
        else if segue.identifier == "viewCourseSegue" {
            print("View course segue");
            if let viewCourseController = segue.destinationViewController as? CourseViewController {
                viewCourseController.currentCourse = enrolledCourses![(courseTable.indexPathForSelectedRow?.item)!]
                print(enrolledCourses![(courseTable.indexPathForSelectedRow?.item)!].courseName);
            }
        }
    }
}
