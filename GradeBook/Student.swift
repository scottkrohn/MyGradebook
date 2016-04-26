//  CSE 394 Class Project
//  Group: The Binary Canaries
//  --------------------------
//  File: Student.swift
//  Author: John Rabatin
//  Contains a Student's information as well one-to-many relationship with Semester.

import CoreData
import Foundation

class Student: NSManagedObject {
    typealias Gpa = NSDecimalNumber

    @NSManaged var cumulativeGpa: Gpa?
    @NSManaged var major: String?
    @NSManaged var name: String?
}


