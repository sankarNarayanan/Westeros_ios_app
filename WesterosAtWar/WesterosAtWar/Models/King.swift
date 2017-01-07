//
//  King.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 07/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import Foundation
import CoreData

class King : NSManagedObject {
    @NSManaged var kingName : String?
    @NSManaged var rating : NSNumber?
    @NSManaged var strength : String?
}
