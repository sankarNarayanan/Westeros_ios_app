//
//  BattleModel.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 07/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import Foundation
import CoreData

class Battle : NSManagedObject {
    @NSManaged var battleName : String?
    @NSManaged var attackerCommander : String?
    @NSManaged var attackerOutcome : String?
    @NSManaged var attackers : String?
    @NSManaged var defenders : String?
    @NSManaged var attackerSize : String?
    @NSManaged var attckerKing : String?
    @NSManaged var battleNumber : NSNumber?
    @NSManaged var battleType : String?
    @NSManaged var defenderCommander : String?
    @NSManaged var defenderKing : String?
    @NSManaged var defenderSize : String?
    @NSManaged var location : String?
    @NSManaged var majorCapture : NSNumber?
    @NSManaged var majorDeath : NSNumber?
    @NSManaged var note : String?
    @NSManaged var region : String?
    @NSManaged var summer : String?
    @NSManaged var year : NSNumber?
    
    func initWithResponse(battleDetails : Dictionary<String,AnyObject>){
        self.battleName = (battleDetails[jsonResponseConstants.name] as? String) ?? ""
        self.attackerCommander = (battleDetails[jsonResponseConstants.attackerCommander] as? String) ?? ""
        self.attackerOutcome = (battleDetails[jsonResponseConstants.attackerOutcome] as? String) ?? ""
        //Append attackers
        self.attackers = ((battleDetails[jsonResponseConstants.attacker1] as? String)) ?? ""
        if let attacker2 = battleDetails[jsonResponseConstants.attacker2] as? String{
            self.attackers = self.attackers! + "," + attacker2
        }
        if let attacker3 = battleDetails[jsonResponseConstants.attacker3] as? String{
            self.attackers = self.attackers! + "," + attacker3
        }
        if let attacker4 = battleDetails[jsonResponseConstants.attacker4] as? String{
            self.attackers = self.attackers! + "," + attacker4
        }
        //Append defenders
        self.defenders = ((battleDetails[jsonResponseConstants.defender1] as? String)) ?? ""
        if let defender2 = battleDetails[jsonResponseConstants.defender2] as? String{
            self.attackers = self.attackers! + "," + defender2
        }
        if let defender3 = battleDetails[jsonResponseConstants.defender3] as? String{
            self.attackers = self.attackers! + "," + defender3
        }
        if let defender4 = battleDetails[jsonResponseConstants.defender4] as? String{
            self.attackers = self.attackers! + "," + defender4
        }
        self.attackerSize = (battleDetails[jsonResponseConstants.attackerSize] as? String) ?? ""
        self.attckerKing = (battleDetails[jsonResponseConstants.attackerKing] as? String) ?? ""
        self.battleNumber = (battleDetails[jsonResponseConstants.battleNumber] as? NSNumber) ?? 1
        self.battleType = (battleDetails[jsonResponseConstants.battleType] as? String) ?? ""
        self.defenderCommander = (battleDetails[jsonResponseConstants.defenderCommander] as? String) ?? ""
        self.defenderKing = (battleDetails[jsonResponseConstants.defenderKing] as? String) ?? ""
        self.defenderSize = (battleDetails[jsonResponseConstants.defenderSize] as? String) ?? ""
        self.location = (battleDetails[jsonResponseConstants.location] as? String) ?? ""
        self.majorCapture = (battleDetails[jsonResponseConstants.majorCapture] as? NSNumber) ?? 1
        self.majorDeath = (battleDetails[jsonResponseConstants.majorDeath] as? NSNumber) ?? 1
        self.note = (battleDetails[jsonResponseConstants.note] as? String) ?? ""
        self.region = (battleDetails[jsonResponseConstants.region] as? String) ?? ""
        self.summer = (battleDetails[jsonResponseConstants.summer] as? String) ?? ""
        self.year = (battleDetails[jsonResponseConstants.year] as? NSNumber) ?? 1
    }
    
}
