//
//  AppDelegate.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 07/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let nController = NetworkController()
        nController.makeWebServiceCall(AppConstants.baseUrl, method: AppConstants.httpGetMethod, callback: {(response: NSData?, error: NSError?) -> Void in
            if (response != nil){
                self.loadBattleModels(response!)
            }
        })
        
        return true
    }
    
    
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
                    self.fetchBattleDetails()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
        catch let error as NSError {
            print(error.description)
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
                self.calculateRatingForKing(battle)
            }
            
        } catch {
            fatalError("Failed to fetch battles: \(error)")
        }
    }
    
    
    func calculateRatingForKing(battleDetails : Battle){
        let moc = DataController.sharedInstance.managedObjectContext
        do {
            let kingFetchRequest = NSFetchRequest(entityName: coreDataBaseConstants.kingTableName)
            kingFetchRequest.predicate = NSPredicate(format: coreDataBaseConstants.kingName + " == %@", (battleDetails.attckerKing ?? ""))
            let battleFetchRequest = NSFetchRequest(entityName: coreDataBaseConstants.battleTableName)
            battleFetchRequest.predicate = NSPredicate(format: "attckerKing == %@ OR defenderKing == %@", (battleDetails.attckerKing ?? ""), (battleDetails.attckerKing ?? ""))
            let fetchedKings = try moc.executeFetchRequest(kingFetchRequest) as! [King]
            if (fetchedKings.count == 0){
                let fetchedBattles = try moc.executeFetchRequest(battleFetchRequest) as! [Battle]
                
            }
        } catch {
            fatalError("Failed to fetch battles with king name as search spec: \(error)")
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

