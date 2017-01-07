//
//  ViewController.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 07/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import UIKit

class KingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var kingsTableView: UITableView!
    
    var kingsArray : [King] = [King]()
    
    var tableViewRestorationId = "KingsTableCell"
    
    override func viewDidLoad() {
        self.kingsTableView.delegate = self
        self.kingsTableView.dataSource = self
        let nController = NetworkController()
        nController.makeWebServiceCall(AppConstants.baseUrl, method: AppConstants.httpGetMethod, callback: {(response: NSData?, error: NSError?) -> Void in
            if (response != nil){
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let scoringEngine = ScoringEngine()
                    scoringEngine.loadBattleModels(response!)
                    scoringEngine.fetchBattleDetails()
                    self.kingsArray =  scoringEngine.getKingsDetials()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.kingsTableView.reloadData()
                    })
                    
                })
            }
        })
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PRAGMA MARK: - TableView Delagates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.kingsArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.kingsTableView.dequeueReusableCellWithIdentifier(self.tableViewRestorationId, forIndexPath: indexPath) as! KingTableViewCell
        

        cell.kingIcon.image = UIImage(named: "crown.png")
        let kingObject = self.kingsArray[indexPath.row]
        cell.kingName.text = kingObject.kingName
        cell.rating.text = String(kingObject.rating)
        if (Double(kingObject.attackVictory ?? 0) > Double(kingObject.defenseVictory ?? 0)){
            cell.battleStrength.text = "Attack"
        }else{
            cell.battleStrength.text = "Defense"
        }
        return cell
    }


}

