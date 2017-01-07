//
//  ViewController.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 07/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import UIKit

class KingsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var kingsTableView: UITableView!
    
    var kingsArray : [King] = [King]()
    let scoringEngine = ScoringEngine()
    
    var tableViewRestorationId = "KingsTableCell"
    var titleString = "Westeros at War"
    
    //PRAGMA MARK: - View controller Delagates
    
    override func viewDidLoad() {
        self.setUpUserInterface()
        self.performNetworkOperation()
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
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.kingsTableView.dequeueReusableCellWithIdentifier(self.tableViewRestorationId, forIndexPath: indexPath) as! KingTableViewCell
        cell.kingIcon.image = UIImage(named: "crown.png")
        let kingObject = self.kingsArray[indexPath.row]
        cell.kingName.text = kingObject.kingName
        cell.rating.text = String(Int(kingObject.rating!))
        if (Double(kingObject.attackVictory ?? 0) > Double(kingObject.defenseVictory ?? 0)){
            cell.battleStrength.text = "Attack"
        }else{
            cell.battleStrength.text = "Defence"
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsController = storyBoard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailsController.selectedKing = self.kingsArray[indexPath.row]
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    //PRAGMA MARK: Search bar delegates
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar == self.searchBar && searchBar.text?.characters.count > 0){
            let predicate = NSPredicate(format: "kingName CONTAINS[c] '\(self.searchBar.text ?? "")' ")
            self.kingsArray =  self.scoringEngine.getKingsDetials(predicate)
        }else{
            self.kingsArray =  self.scoringEngine.getKingsDetials(nil)
            self.view.endEditing(true)
        }
        self.kingsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    //PRAGMA MARK: Controller Utilities
    
    func setUpUserInterface(){
        self.kingsTableView.delegate = self
        self.kingsTableView.dataSource = self
        self.searchBar.delegate = self
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithHexValue(colorConstants.themeBlue)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = titleString
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: #selector(KingsTableViewController.filterButtonPressed))
        navigationItem.rightBarButtonItem = button
        self.searchBar.barTintColor = UIColor.colorWithHexValue(colorConstants.themeBlue)
    }
    
    
    func filterButtonPressed() {
        //Show a model containing battle types
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func performNetworkOperation(){
        let nController = NetworkController()
        nController.makeWebServiceCall(AppConstants.baseUrl, method: AppConstants.httpGetMethod, callback: {(response: NSData?, error: NSError?) -> Void in
            if (response != nil){
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.scoringEngine.loadBattleModels(response!)
                    self.scoringEngine.fetchBattleDetails()
                    self.kingsArray =  self.scoringEngine.getKingsDetials(nil)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.kingsTableView.reloadData()
                    })
                    
                })
            }
        })
    }


}

