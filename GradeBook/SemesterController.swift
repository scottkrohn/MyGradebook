//
//  SemesterController.swift
//  GradeBook
//
//  Created by Scott on 3/29/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SemesterController: NSObject, NSFetchedResultsControllerDelegate{
    
    // Data members
    var semesterDataController: NSFetchedResultsController = NSFetchedResultsController();
    var semesterContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Constructor
    override init(){
        super.init();
        semesterDataController = getFetchResultsController();
        semesterDataController.delegate = self;
        do{
            try semesterDataController.performFetch();
        }
        catch _{
        }
    }
    
    // Add a relationship between a Course and Semester core data object.
    func addCourseToSemester(semester: Semester, courseName: String, categories: Dictionary<String, Int>) {
        let ent = NSEntityDescription.entityForName("Course", inManagedObjectContext: semesterContext);
        let newCourse = Course(entity: ent!, insertIntoManagedObjectContext: semesterContext);
        newCourse.categories = NSKeyedArchiver.archivedDataWithRootObject(categories);
        newCourse.courseName = courseName;
        
        let courses = semester.mutableSetValueForKey("enrolledCourses");
        courses.addObject(newCourse);
        do {
            try semesterContext.save();
            print("Course added");
        }
        catch _ {
        }
    }
    
    func addWorkItemToCourse(currentCourse: Course, pointsPoss: Double, pointsEarned: Double, name: String, category: String) {
        let ent = NSEntityDescription.entityForName("WorkItem", inManagedObjectContext: semesterContext);
        let newWorkItem = WorkItem(entity: ent!, insertIntoManagedObjectContext: semesterContext);
        newWorkItem.category = category;
        newWorkItem.pointsPossible = pointsPoss;
        newWorkItem.pointsEarned = pointsEarned;
        newWorkItem.itemName = name;
        let workItems = currentCourse.mutableSetValueForKey("workItems");
        workItems.addObject(newWorkItem);
        do {
            try semesterContext.save();
            print("WorkItem added");
        }
        catch _ {
        }
    }
    
    // Calculate a simple grade for a category.
    func calcCategoryGrade(currentCourse: Course, categoryName: String) -> Double {
        var pointsPossible: Double = 0;
        var pointsEarned: Double = 0;
        
        var categoryMatchingItems: [WorkItem] = Array<WorkItem>();
        var workItems = ((currentCourse.mutableSetValueForKey("workItems")).allObjects as! [WorkItem]);
        for(var i = 0; i < workItems.count; i++) {
            if(workItems[i].category == categoryName) {
                categoryMatchingItems.append(workItems[i]);
            } 
        }
        
        for(var i = 0; i < categoryMatchingItems.count; i++) {
            pointsPossible += Double(categoryMatchingItems[i].pointsPossible!);
            pointsEarned += Double(categoryMatchingItems[i].pointsEarned!);
        }
        if(pointsPossible == 0) {
            return 0;
        }
        return pointsEarned/pointsPossible;
    }
    
    // Calculate the current weighted grade for a course. If a weight
    // category has no entries, it's assumed to be 100%
    func calcCourseWeightedGrade(currentCourse: Course) -> Double {
        var currentGrades: Dictionary<String, Double> = Dictionary<String, Double>();
        var weightCategories = Array<String>();
        var weightValues = Array<Int>();
        let categories: NSDictionary = (NSKeyedUnarchiver.unarchiveObjectWithData((currentCourse.categories)!)) as! NSDictionary;
        for(key, value) in categories {
            weightCategories.append(key as! String);
            weightValues.append(value as! Int);
        }
        
        for(var i = 0; i < weightCategories.count; i++) {
            currentGrades[weightCategories[i]] = calcCategoryGrade(currentCourse, categoryName: weightCategories[i]);
        }
        
        var weightedGrade: Double = 0;
        for(var i = 0; i < weightCategories.count; i++) {
            if(currentGrades[weightCategories[i]] == 0) {
                weightedGrade += Double(weightValues[i]);
            }
            else {
                weightedGrade += currentGrades[weightCategories[i]]! * Double(weightValues[i]);
            }
        }
        return weightedGrade;
    }
    
    // Calculate cumulative GPA
    func calcCumulativeGPA() -> Double {
        let allSemesters: NSArray = semesterDataController.fetchedObjects!;
        var semesterCount: Int = allSemesters.count;
        if(allSemesters.count == 0) {
            return 0;
        }
        var gpaTotal: Double = 0;
        for(var i = 0; i < allSemesters.count; i++) {
            let enrolledCourses: [Course] = allSemesters[i].mutableSetValueForKey("enrolledCourses").allObjects as! [Course];
            
            // Ignore semesters with no courses, otherwise it will skew the GPA.
            if(enrolledCourses.count == 0) {
                semesterCount--;
                continue;
            }
            else {
                gpaTotal += calcSemesterGPA(enrolledCourses)
            }
        }
        return gpaTotal/Double(semesterCount);
    }
    
    
    // Calculate the current GPA for a semester of courses.
    func calcSemesterGPA(enrolledCourses: [Course]) -> Double {
        var gradeTotal: Double = 0;
        let creditsBeingTaken = 3 * enrolledCourses.count;
        if(creditsBeingTaken == 0) {
            return 0;
        }
        
        // Get the letter grade for a specific course in a semester.
        for(var i = 0; i < enrolledCourses.count; i++) {
            // Get Distionary of weight categories and store in arrays for processing.
            let categories: NSDictionary = (NSKeyedUnarchiver.unarchiveObjectWithData((enrolledCourses[i].categories)!)) as! NSDictionary;
            var weightCategories = Array<String>();
            var weightValues = Array<Int>();
        
            for(key, value) in categories {
                weightCategories.append(key as! String);
                weightValues.append(value as! Int);
            }
            // Store the total quality grade amount.
            gradeTotal += getLetterValue(calcCourseWeightedGrade(enrolledCourses[i])) * 3;
        }
        return gradeTotal / Double(creditsBeingTaken);
    }
    
    // Return a GPA value for a letter grade.
    private func getLetterValue(grade: Double) -> Double {
        if(grade >= 97) {
            return 4.33;
        }
        else if(grade >= 93) {
            return 4;
        }
        else if(grade >= 89.5) {
            return 3.67;
        }
        else if(grade >= 87) {
            return 3.33;
        }
        else if(grade >= 83) {
            return 3;
        }
        else if(grade >= 79.5) {
            return 2.67;
        }
        else if(grade >= 77) {
            return 2.33;
        }
        else if(grade >= 73) {
            return 2;
        }
        else if(grade > 69.5) {
            return 1.33;
        }
        else if(grade >= 67) {
            return 1;
        }
        else if(grade >= 63) {
            return 0.67;
        }
        else {
            return 0;
        }
    }
    
    // Make the fetch search for "Semester" objects and sort by the term data member.
    private func listFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Semester");
        let sortDescripter = NSSortDescriptor(key: "term", ascending: true);
        fetchRequest.sortDescriptors = [sortDescripter];
        return fetchRequest;
    }
    
    // Get a NSFetchedResultsController
    private func getFetchResultsController() -> NSFetchedResultsController {
        // Create NSFetchedResultsController and bind to the managedObjectContext we specify.
        semesterDataController = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: semesterContext, sectionNameKeyPath: nil, cacheName: nil);
        return semesterDataController;
    }
    
    // Called when the semesterDataController emits an event that data has changed.
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        do{
            print("NSFetchedResultsController update event");
            try semesterDataController.performFetch();
        } catch _ {
        }
    }
    
    
    // Delete a course from a semester object
    func deleteCourse(semester: Semester, course: Course) -> Void {
        semesterContext.deleteObject(course);
        do {
            try semesterContext.save();
        }
        catch _ {
        }
    }
    
    // Delete a Semester object from core data.
    func deleteSemester(indexPath: NSIndexPath) {
        let semester = semesterDataController.objectAtIndexPath(indexPath) as! Semester;
        semesterContext.deleteObject(semester);
        do {
            try semesterContext.save();
            print("Semester deleted.");
        }
        catch _ {
        }
    }
    
    func deleteWorkItem(item: WorkItem) {
        semesterContext.deleteObject(item);
        do {
            try semesterContext.save();
            print("WorkItem deleted.");
        }
        catch _ {
        }
    }
    
    // Save the current state of the core data.
    func save() {
        do {
            try semesterContext.save();
        }
        catch _ {
        }
    }
    
    // Return the number of semester objects.
    func getSemesterCount() -> Int {
        return (semesterDataController.fetchedObjects?.count)!;
    }
    
    // Get the term data member for a given Semester object.
    func getTerm(indexPath: NSIndexPath) -> String {
        let semester = semesterDataController.objectAtIndexPath(indexPath) as! Semester;
        return semester.term!;
    }
    
    // Return a semester object.
    func getSemester(indexPath: NSIndexPath) -> Semester {
        return semesterDataController.objectAtIndexPath(indexPath) as! Semester;
    }
    
    // Add a new Semester object to core data.
    func addTerm(termName: String) -> Void {
        // Create an entity object.
        let ent = NSEntityDescription.entityForName("Semester", inManagedObjectContext: semesterContext);
        // Create new Semester object.
        let newSemester = Semester(entity: ent!, insertIntoManagedObjectContext: semesterContext);
        newSemester.term = termName;
        
        // Attempt to save the place to Core Data.
        do {
            try semesterContext.save()
            print("Data saved.")
        } catch _ {
            print("data not saved")
        }
    }
}