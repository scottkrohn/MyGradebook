//
//  Course.swift
//  GradeBook
//
//  Created by Scott & Jen on 4/21/16.
//  Copyright © 2016 CSE394. All rights reserved.
//

import Foundation
import CoreData


class Course: NSManagedObject {

    @NSManaged var categories: NSData?
    @NSManaged var courseName: String?
    @NSManaged var weightedGrade: NSNumber?
    @NSManaged var semester: NSSet?
    @NSManaged var workItems: NSSet?
}
