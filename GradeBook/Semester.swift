//
//  Semester.swift
//  GradeBook
//
//  Created by Scott & Jen on 4/12/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import Foundation
import CoreData

@objc(Semester)
class Semester: NSManagedObject {
   typealias Gpa = NSDecimalNumber
    
    @NSManaged var semesterGpa : Gpa?
    @NSManaged var term: String?
}
