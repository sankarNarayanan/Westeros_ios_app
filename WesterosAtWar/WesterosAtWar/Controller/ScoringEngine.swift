//
//  ScoringEngine.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 07/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import Foundation
import CoreData

class ScoringEngine {
    func loadBattleModels(response : NSData){
        let objectContext = DataController.sharedInstance.managedObjectContext
        do {
            let rawData = try NSJSONSerialization.JSONObjectWithData(response, options: .AllowFragments)
            if let responseArray = rawData as? [Dictionary<String,AnyObject>] {
                for item in responseArray{
                    self.populateBattleEntity(item)
                }
                do {
                    try objectContext.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func populateBattleEntity(battleDetails : Dictionary <String, AnyObject>){
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let battleObject = NSEntityDescription.insertNewObjectForEntityForName(coreDataBaseConstants.battleTableName, inManagedObjectContext: managedObjectContext) as! Battle
        battleObject.initWithResponse(battleDetails)
    }
    
    
    func fetchBattleDetails(){
        let objectContext = DataController.sharedInstance.managedObjectContext
        let battlesFetch = NSFetchRequest(entityName: coreDataBaseConstants.battleTableName)
        do {
            let fetchedBattles = try objectContext.executeFetchRequest(battlesFetch) as! [Battle]
            for battle in fetchedBattles{
                if (battle.attckerKing?.characters.count > 0 && battle.defenderKing?.characters.count > 0 && (battle.attckerKing != battle.defenderKing)){
                    self.calculateRatingForKing(battle)
                }
            }
            
        } catch {
            fatalError("Failed to fetch battles: \(error)")
        }
    }
    
    
    func calculateRatingForKing(battleDetails : Battle){
        let moc = DataController.sharedInstance.managedObjectContext
        do {
            let kingFetchRequest = NSFetchRequest(entityName: coreDataBaseConstants.kingTableName)
            kingFetchRequest.predicate = NSPredicate(format: coreDataBaseConstants.kingName + " == %@ OR " + coreDataBaseConstants.kingName + " == %@", (battleDetails.attckerKing ?? ""), (battleDetails.defenderKing ?? ""))
            let fetchedKings = try moc.executeFetchRequest(kingFetchRequest) as! [King]
            var attackerScore : Double = 400
            var defenderScore : Double = 400
            if (fetchedKings.count > 0){
                for king in fetchedKings{
                    if (king.kingName == battleDetails.attckerKing){
                        attackerScore = Double(king.rating ?? 400)
                    }else if (king.kingName == battleDetails.defenderKing){
                        defenderScore = Double(king.rating ?? 400)
                    }
                }
            }
            self.calculatefinalScore(attackerScore, defenderKingScore: defenderScore, battleDetails: battleDetails)
        } catch {
            fatalError("Failed to fetch battles with king name as search spec: \(error)")
        }
    }
    
    
    func calculatefinalScore(attackerKingScore : Double, defenderKingScore : Double, battleDetails : Battle){
        
        let baseValue : Double = 10
        let kFactor : Double = 32
        //first step is to compute the transformed rating for each King
        let transformedAttackerScore = pow(Double(baseValue),Double(attackerKingScore/400))
        let transformedDefenderScore = pow(Double(baseValue),Double(defenderKingScore/400))
        //second step we calculate the expected score for each King
        let expectedAttackerScore = transformedAttackerScore / (transformedAttackerScore + transformedDefenderScore)
        let expectedDefenderSCore = transformedDefenderScore / (transformedAttackerScore + transformedDefenderScore)
        //set the actual score in the third step
        var attackerScore : Double = 0, defenderScore : Double = 0
        if (battleDetails.attackerOutcome == "win"){
            attackerScore = 1
            defenderScore = 0
        }else if (battleDetails.attackerOutcome == "loss"){
            attackerScore = 0
            defenderScore = 1
            
        }else if (battleDetails.attackerOutcome == "draw"){
            attackerScore = 0.5
            defenderScore = 0.5
        }
        
        //final updated scores
        let updatedAttackerScore : Double = attackerKingScore + kFactor * (attackerScore - expectedAttackerScore)
        let updatedDefenderScore : Double = defenderKingScore + kFactor * (defenderScore - expectedDefenderSCore)
        
        //To update tables
        let modelDetails = KingModelDetails(attackerScore: attackerScore, defenderScore: defenderScore, updatedAttackerScore: updatedAttackerScore, updatedDefenderScore: updatedDefenderScore, battleDetails: battleDetails)
        self.pushScoreToTable(modelDetails)
    }
    
    
    struct KingModelDetails {
        var attackerScore : Double!,
        defenderScore : Double!,
        updatedAttackerScore : Double!,
        updatedDefenderScore : Double!
        let battleDetails : Battle!
    }
    
    func pushScoreToTable(kingModel : KingModelDetails){
        let updatedAttackerScore = kingModel.updatedAttackerScore ,
        updatedDefenderScore = kingModel.updatedDefenderScore ,
        battleDetails = kingModel.battleDetails,
        attackVictory = kingModel.attackerScore,
        defenseVictory = kingModel.defenderScore
        do {
            let managedObjectContext = DataController.sharedInstance.managedObjectContext
            let kingFetchRequest = NSFetchRequest(entityName: coreDataBaseConstants.kingTableName)
            kingFetchRequest.predicate = NSPredicate(format: coreDataBaseConstants.kingName + " == %@ OR " + coreDataBaseConstants.kingName + " == %@", (battleDetails.attckerKing ?? ""), (battleDetails.defenderKing ?? ""))
            let fetchedKings = try managedObjectContext.executeFetchRequest(kingFetchRequest) as! [King]
            var attackerPresent = false, defenderPresent = false
            for king in fetchedKings{
                if (battleDetails.attckerKing == king.kingName){
                    king.rating = updatedAttackerScore
                    //add attack failure to king
                    if (attackVictory == 0){
                        king.attackDefeat = Double(king.attackDefeat ?? 0) + 1
                    }
                    //add attack victory to the king
                    var attackVic = Double(king.attackVictory ?? 0)
                    attackVic = attackVic + Double(attackVictory)
                    king.attackVictory = attackVic
                    attackerPresent = true
                }else if (battleDetails.defenderKing == king.kingName){
                    //Add defense failure to king
                    if (defenseVictory == 0){
                        king.defenseDefeat = Double(king.defenseDefeat ?? 0) + 1
                    }
                    king.rating = updatedDefenderScore
                    //add defense victory to king
                    var defenseVic = Double(king.defenseVictory ?? 0)
                    defenseVic = defenseVic + Double(defenseVictory)
                    king.defenseVictory = defenseVic
                    defenderPresent = true
                }
            }
            if (!attackerPresent){
                if (battleDetails.attckerKing != nil && battleDetails.attckerKing?.characters.count > 0){
                    let attackerKingObject = NSEntityDescription.insertNewObjectForEntityForName(coreDataBaseConstants.kingTableName, inManagedObjectContext: managedObjectContext) as! King
                    attackerKingObject.initWithResponse(updatedAttackerScore, name: battleDetails.attckerKing!, attackVictory: attackVictory, defenseVictory: 0)
                    //add attack failure to king
                    if (attackVictory == 0){
                        attackerKingObject.attackDefeat = Double(attackerKingObject.attackDefeat ?? 0) + 1
                    }
                }
            }
            if (!defenderPresent){
                if (battleDetails.defenderKing != nil && battleDetails.defenderKing?.characters.count > 0){
                    let defenderKingObject = NSEntityDescription.insertNewObjectForEntityForName(coreDataBaseConstants.kingTableName, inManagedObjectContext: managedObjectContext) as! King
                    defenderKingObject.initWithResponse(updatedDefenderScore, name: battleDetails.defenderKing!, attackVictory: 0, defenseVictory: defenseVictory)
                    //Add defense failure to king
                    if (defenseVictory == 0){
                        defenderKingObject.defenseDefeat = Double(defenderKingObject.defenseDefeat ?? 0) + 1
                    }
                }
            }
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func getKingsDetials(predicate : NSPredicate?) -> [King]{
        let objectContext = DataController.sharedInstance.managedObjectContext
        let kingsFetch = NSFetchRequest(entityName: coreDataBaseConstants.kingTableName)
        if (predicate != nil){
            kingsFetch.predicate = predicate
        }
        do {
            let fetchedKings = try objectContext.executeFetchRequest(kingsFetch) as! [King]
            return fetchedKings
            
        } catch {
            fatalError("Failed to fetch battles: \(error)")
        }
    }
    
    func findStrengthInBattleType(kingModel: King) -> String{
        do {
            var finalDict : Dictionary<String, Int> = Dictionary<String, Int>()
            let objectContext = DataController.sharedInstance.managedObjectContext
            let battlesFetch = NSFetchRequest(entityName: coreDataBaseConstants.battleTableName)
            battlesFetch.predicate = NSPredicate(format: coreDataBaseConstants.winnerKey + " == %@ ", (kingModel.kingName ?? ""))
            let fetchedBattles = try objectContext.executeFetchRequest(battlesFetch) as! [Battle]
            for battle in fetchedBattles{
                if finalDict[battle.battleType ?? ""] != nil{
                    finalDict[battle.battleType ?? ""] = finalDict[battle.battleType ?? ""]! + 1
                }else{
                    finalDict[battle.battleType ?? ""] = 1
                }
            }
            let componentArray = [Int] (finalDict.values)
            let maxCount = componentArray.maxElement()
            var finalString = ""
            for (key,value) in finalDict{
                if (value == maxCount){
                    finalString = key
                    break
                }
            }
            return finalString
            
        } catch {
            fatalError("Failed to fetch battles: \(error)")
        }
    }
    
    
    
}
