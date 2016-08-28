//
//  BoardViewController.swift
//  NoughtsAndCrosses
//
//  Created by Alejandro Castillejo on 5/27/16.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet var boardView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var networkPlayButton: UIButton!
    @IBOutlet var topLeftButton: UIButton!
    
    var networkGame:Bool = false
    var currentGame = OXGame()
    var lastRotation: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // allow for user interaction
        view.userInteractionEnabled = true
        
        //Rotation
        
        // create an instance of UIRotationGestureRecognizer
        let rotation: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action:#selector(BoardViewController.handleRotation(_:)))
        // add tap as a gestureRecognizer to tapView
        self.boardView.addGestureRecognizer(rotation)
        
        //In your viewDidLoad, you have probably set some if/ else code about NetworkMode. Thats good, but you want to put it in
        //a goto function that you can reuse for refreshing your boardViewController. So
        //create the func updateUI() and call it in viewDidLoad. After refreshing your game, you can call the same function
        self.updateUI()
        
        if (self.networkGame == true)   {
            //keep a look out if the competitor played a move
            OXGameController.sharedInstance.getGame(self.currentGame.gameId!, presentingViewController: nil,viewControllerCompletionFunction: {(game, message) in self.gameUpdateReceived(game,message:message)})
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func updateUI() {
        
        for view in boardView.subviews  {
            if let button = view as? UIButton   {
                
                button.setTitle(self.currentGame.board[button.tag].rawValue, forState: UIControlState.Normal)
                
            }
        }
        
        if (networkGame )   {
            self.logoutButton.setTitle("Cancel Game", forState: UIControlState.Normal)
            networkPlayButton.hidden = true
            
            self.updatePlayButton()
            
        }
        
    }
    
    func updatePlayButton() {
        
        let lastPlayer = self.currentGame.whoJustPlayed()//is to play next, if game is not won
        if (self.currentGame.backendState == OXGameState.abandoned)   {
            let message = "\(lastPlayer) won the game, opponent backed out"
            print(message)
            bottomButton.setTitle("You won the game", forState: UIControlState.Normal)
            self.logoutButton.setTitle("Close Game", forState: UIControlState.Normal)
        } else if (self.currentGame.state() == OXGameState.complete_someone_won) {
            let message = "\(lastPlayer) won the game"
            print(message)
            bottomButton.setTitle("\(lastPlayer) won the game", forState: UIControlState.Normal)
            self.logoutButton.setTitle("Close Game", forState: UIControlState.Normal)
            self.restartGame()
            
        } else if (self.currentGame.state() == OXGameState.complete_no_one_won) {
            let message = "Game tied!"
            bottomButton.setTitle(message, forState: UIControlState.Normal)
            print(message)
            self.logoutButton.setTitle("Close Game", forState: UIControlState.Normal)
            self.restartGame()
            
        } else if(self.currentGame.state() == OXGameState.inProgress) {
            //if there is no opponent, state that thats the case
            if (self.currentGame.guestUser?.email != "")   {
                //there is 2 players so start play
                if (self.currentGame.localUsersTurn())  {
                    //you are the host user, therefore you play first
                    self.bottomButton.setTitle("Your turn to play...", forState: UIControlState.Normal)
                    self.boardView.userInteractionEnabled = true
                }   else    {
                    self.bottomButton.setTitle("Awaiting Opponent Move...", forState: UIControlState.Normal)
                    self.boardView.userInteractionEnabled = false
                }
            }   else    {
                //there isnt a second player yet, ask user to wait
                self.bottomButton.setTitle("Awaiting Opponent To Join...", forState: UIControlState.Normal)
                self.boardView.userInteractionEnabled = false
            }
            
        }

    }

    @IBAction func boardWasTapped(sender: AnyObject) {
        
        print("boardWasTapped at index: " + String(sender.tag))
        
        if(String(currentGame.typeAtIndex(sender.tag)) != "EMPTY"){
            return
        }
        
        var lastMove: CellType?
        
        if(networkGame){
            
            lastMove = currentGame.playMove(sender.tag)
            
            OXGameController.sharedInstance.playMove(currentGame.serialiseBoard(), gameId: currentGame.gameId!, presentingViewController: self, viewControllerCompletionFunction: {(game, message) in self.playMoveComplete(game, message:message)})
            
            if(!gameEnded(lastMove!))   {

                
            } else {
                //Game ended
                return
            }
            
        } else {
            lastMove = currentGame.playMove(sender.tag)
            if let moveToPrint = lastMove   {
                print("Setting button to: \(moveToPrint)")
                sender.setTitle("\(moveToPrint)", forState: UIControlState.Normal)
            }
        }
        
        gameEnded(lastMove!)
        
    }
    
    func playMoveComplete(game:OXGame?, message:String?)    {
        
        if let gameBack = game   {
            //success
            
            
            self.currentGame = gameBack
            //update the board visual state
            self.updateUI()
            
            
        }   else    {
            //failure
        }
        
        OXGameController.sharedInstance.getGame(self.currentGame.gameId!, presentingViewController: self,viewControllerCompletionFunction: {(game, message) in self.gameUpdateReceived(game,message:message)})
    }
    
    func gameEnded(cellType: CellType) -> Bool {
        let state = currentGame.state()
        
        if (state == OXGameState.complete_someone_won) {
            let message = "\(cellType) won the game"
            print(message)
            bottomButton.setTitle("\(cellType) won the game", forState: UIControlState.Normal)
            self.restartGame()
            return true
        } else if (state == OXGameState.complete_no_one_won) {
            let message = "Game tied!"
            bottomButton.setTitle(message, forState: UIControlState.Normal)
            print(message)
            self.restartGame()
            return true
        } else if(state == OXGameState.inProgress) {
            print ("Game in progress")
        }
        
        return false
    }
    
    func handleRotation(sender: UIRotationGestureRecognizer? = nil) {
        
        //Update transformation        
        self.boardView.transform = CGAffineTransformMakeRotation(sender!.rotation + CGFloat(self.lastRotation));
        
        //Rotation ends
        if (sender!.state == UIGestureRecognizerState.Ended)   {
            
            print("game rotation")
            
            UIView.animateWithDuration(NSTimeInterval(1), animations: {
                
                var rotation = CGFloat(self.lastRotation)
                
                if( abs(sender!.rotation) > CGFloat(M_PI)/6.0){
                    
                    rotation += CGFloat(M_PI)
                    self.lastRotation = self.lastRotation + Float(M_PI)
                    
                    
                }
                
                self.boardView.transform = CGAffineTransformMakeRotation(rotation)
                
            })
            
        }
        
    }

    @IBAction func networkPlayTapped(sender: AnyObject) {
        
        let networkPlayScreen = NetworkPlayViewController(nibName: "NetworkPlayViewController", bundle:nil)
        self.navigationController?.pushViewController(networkPlayScreen, animated: true)
    }
    
    @IBAction func newGameWasTapped(sender: AnyObject) {
        
        print("newGameWasTapped")
        self.restartGame()
        
    }
    
    func restartGame()  {
        
        if(!networkGame){
            //reset model
            currentGame.reset()
            //reset UI
            for view in boardView.subviews  {
                if let button = view as? UIButton   {
                    button.setTitle("", forState: UIControlState.Normal)
                }
            }
            
        }
        
    }
    
    @IBAction func logoutWasPressed(sender: AnyObject) {
        
        if (self.networkGame)   {
            
            if (self.logoutButton.titleLabel?.text == "Cancel Game")    {
                //Cancel game
                OXGameController.sharedInstance.cancelGame(self.currentGame.gameId!, presentingViewController:self, viewControllerCompletionFunction: {(success, message) in self.gameCancelCompletion(success, message:message)})
            }    else   {
                //close game
                
                self.navigationController?.popViewControllerAnimated(true)
            }
        }   else    {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.navigateToLoggedOutNavigationController()
            UserController.sharedInstance.setLoggedInUser(nil)
        }
        
        
    }
    
    func gameCancelCompletion(success:Bool, message:String?) {
        
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    
    func gameUpdateReceived(game:OXGame?, message:String?)    {

        if let gameReceived = game  {
            self.currentGame = gameReceived
        }
        
        self.updateUI()
        print (self.currentGame.localUsersTurn())
        
        OXGameController.sharedInstance.getGame(self.currentGame.gameId!, presentingViewController: nil,viewControllerCompletionFunction: {(game, message) in self.gameUpdateReceived(game,message:message)})
    
        
        
    }

    
    //Hey GUYS/
    //Next Steps:
    //implement the cancel game function, if the user tapped cancel. once the web service (the ox game controller function) returns, 
    //do a self.navigationController.popViewController to go back.
}
