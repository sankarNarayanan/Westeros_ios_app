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
    @NSManaged var attackVictory : NSNumber?
    @NSManaged var defenseVictory : NSNumber?
    @NSManaged var attackDefeat : NSNumber?
    @NSManaged var defenseDefeat : NSNumber?
    
    func initWithResponse(rating : NSNumber, name : String, attackVictory : NSNumber, defenseVictory : NSNumber){
        self.rating = rating
        self.kingName = name
        self.attackVictory = attackVictory
        self.defenseVictory = defenseVictory
    }
    
}
