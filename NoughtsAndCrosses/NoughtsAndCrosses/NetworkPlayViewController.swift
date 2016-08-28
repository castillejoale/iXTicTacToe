//
//  NetworkPlayViewController.swift
//  NoughtsAndCrosses
//
//  Created by Julian Hulme on 2016/06/02.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class NetworkPlayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var refreshControl: UIRefreshControl!
    var gameList : [OXGame]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewDidAppear(animated: Bool) {
        self.title = "Network Play"
        self.navigationController?.navigationBarHidden = false
        
        OXGameController.sharedInstance.gameList(self,viewControllerCompletionFunction: {(gameList, message) in self.gameListReceived(gameList, message:message)})
    }
    
    func gameListReceived(games:[OXGame]?,message:String?)  {

        print ("games received \(games)")
        if let newGames = games {
            self.gameList = newGames
        }
        self.tableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startNetworkGameButtonTapped(sender: UIButton) {
        //To start a network game, we need to tell the server that we want to, so that the list of available games will know we want to add one to the list
        print("startNetworkGameButtonTapped")
        OXGameController.sharedInstance.createNewGame(UserController.sharedInstance.getLoggedInUser()!, presentingViewController:self,viewControllerCompletionFunction: {(game, message) in self.newStartGameCompleted(game, message:message)})
        
    }

    func newStartGameCompleted(game:OXGame?,message:String?)   {
       
        if let newGame = game   {
            
            let networkBoardView = BoardViewController(nibName: "BoardViewController", bundle: nil)
            networkBoardView.networkGame = true
            networkBoardView.currentGame = newGame
            self.navigationController?.pushViewController(networkBoardView, animated: true)
        }
        
    }
    
    
    //MARK: TableView delegate methods
    
    func refreshTable(sender:AnyObject) {
        // Code to refresh table view
        OXGameController.sharedInstance.gameList(self,viewControllerCompletionFunction: {(gameList, message) in self.gameListReceived(gameList, message:message)})
        self.tableView.reloadData()
        refreshControl.endRefreshing()

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let gameRowSelected = self.gameList![indexPath.row]
        
        OXGameController.sharedInstance.acceptGame(gameRowSelected.gameId!,presentingViewController:self,viewControllerCompletionFunction:{(game, message) in self.acceptGameComplete(game,message:message)})
        
        print("did select row \(indexPath.row)")
        
        
    }
    
    func acceptGameComplete(game:OXGame?, message:String?)    {
        print ("accept game call complete")
        
        if let gameAcceptedSuccess = game   {
            //so the game is accepted by you. Now show the boardview for the new game to start. 
            
            let networkBoardView = BoardViewController(nibName: "BoardViewController", bundle: nil)
            networkBoardView.networkGame = true
            networkBoardView.currentGame = gameAcceptedSuccess
            self.navigationController?.pushViewController(networkBoardView, animated: true)
        }
        
        //note that if you select a game that was already accepted, the gameAcceptedSuccess call will fail
    }
    
    //MARK: TableView datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = self.gameList?.count   {
            return count
        }   else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = "id: \(gameList![indexPath.row].gameId!) - VS \(gameList![indexPath.row].hostUser!.email)"
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Available Online Games"
    }
}
