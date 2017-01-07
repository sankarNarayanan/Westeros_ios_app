//
//  DetailViewController.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 08/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedKing : King? = nil
    var cellIdentifier = "detailsCell"
    
    @IBOutlet weak var kingImageIcon: UIImageView!
    @IBOutlet weak var kingsName: UILabel!
    @IBOutlet weak var kingsRating: UILabel!
    @IBOutlet weak var additionalDetailsTable: UITableView!
    
    //PRAGMA MARK: View controller delegates
    
    override func viewDidLoad() {
        self.kingImageIcon.layer.cornerRadius = self.kingImageIcon.frame.size.height / 6;
        self.kingImageIcon.clipsToBounds = true;
        self.kingsName.text = self.selectedKing?.kingName ?? ""
        self.kingsRating.text = "Highest Rating : " + String(Int(self.selectedKing?.rating ?? 0))
        self.additionalDetailsTable.tableFooterView = UIView()
    }
    
    //PRAGMA MARK: Table View delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = self.additionalDetailsTable.dequeueReusableCellWithIdentifier(self.cellIdentifier) as! UITableViewCell
        
        let cell = UITableViewCell(style:.Subtitle, reuseIdentifier: self.cellIdentifier)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Battles Won"
            let battlesWon = Int(self.selectedKing?.attackVictory ?? 0) + Int(self.selectedKing?.defenseVictory ?? 0)
            cell.detailTextLabel?.text = String(battlesWon)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        case 1:
            cell.textLabel?.text = "Battles Lost"
            let battlesWon = Int(self.selectedKing?.attackDefeat ?? 0) + Int(self.selectedKing?.defenseDefeat ?? 0)
            cell.detailTextLabel?.text = String(battlesWon)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        case 2:
            cell.textLabel?.text = "Strength"
            
            if (Double(self.selectedKing?.attackVictory ?? 0) > Double(self.selectedKing?.defenseVictory ?? 0)){
                cell.detailTextLabel?.text = "Attack"
            }else{
                cell.detailTextLabel?.text = "Defence"
            }
        case 3:
            let scoringEngine = ScoringEngine()
            cell.textLabel?.text = "Strength in Battle Type"
            let strength = scoringEngine.findStrengthInBattleType(self.selectedKing!)
            cell.detailTextLabel?.text = strength
        default:
            break
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
}


