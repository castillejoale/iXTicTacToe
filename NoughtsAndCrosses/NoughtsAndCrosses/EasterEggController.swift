//
//  EasterEggController.swift
//  NoughtsAndCrosses
//
//  Created by Julian Hulme on 2016/05/29.
//  Copyright © 2016 Julian Hulme. All rights reserved.
//

import Foundation
import UIKit

class EasterEggController: NSObject, UIGestureRecognizerDelegate {
    
    //MARK: Class Singleton
    class var sharedInstance: EasterEggController {
        struct Static {
            static var instance:EasterEggController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = EasterEggController()
        }
        return Static.instance!
    }
    
    var lastRotation: Float!
    
    enum Gesture{
        
        case ClockwiseRotation
        case CounterClockwiseRotation
        case RightSwipe
        case LongPress
        case TwoFingerDownSwipe
        //    case Pinch
        
    }
    
    var gestures = [Gesture]()
    let gesturesCombo = [Gesture.ClockwiseRotation, Gesture.CounterClockwiseRotation, Gesture.LongPress, Gesture.RightSwipe, Gesture.TwoFingerDownSwipe]
    
    func initiate(view:UIView) {
        
        //Gestures
        
        // allow for user interaction
        view.userInteractionEnabled = true
        
        //Rotation
        let rotation: UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action:#selector(EasterEggController.handleRotation(_:)))
        rotation.delegate = self
        view.addGestureRecognizer(rotation)
        self.lastRotation = 0.0
        
        //Right swipe
        let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(EasterEggController.handleRightSwipe(_:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipe)
        
        //TwoFinderDownSwipe
        let twoFinderDownSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(EasterEggController.handleTwoFingerDownSwipe(_:)))
        twoFinderDownSwipe.direction = UISwipeGestureRecognizerDirection.Down
        twoFinderDownSwipe.numberOfTouchesRequired = 2;
        view.addGestureRecognizer(twoFinderDownSwipe)

        //LongPress
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(EasterEggController.handleLongPress(_:)))
        view.addGestureRecognizer(longPress)

        //Pinch
        //        let pinch: UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(EasterEggController.handlePinch(_:)))
        //        self.view.addGestureRecognizer(pinch)

    }
    
    
    func handleRotation(sender: UIRotationGestureRecognizer? = nil) {
        
        //Rotation ends
        if (sender!.state == UIGestureRecognizerState.Ended)   {
            
            UIView.animateWithDuration(NSTimeInterval(1), animations: {
                
                var rotation = CGFloat(self.lastRotation)
                
                if( abs(sender!.rotation) > CGFloat(M_PI)/6.0){
                    
                    rotation += CGFloat(M_PI)
                    self.lastRotation = self.lastRotation! + Float(M_PI)
                    
                    if(sender!.rotation > 0) {
                        print("ClockwiseRotation")
                        self.gestures.append(Gesture.ClockwiseRotation)
                    } else {
                        print("CounterClockwiseRotation")
                        self.gestures.append(Gesture.CounterClockwiseRotation)
                    }
                    
                    self.combinationDetection()
                    
                }
                
            })
            
        }
        
    }
    
        
    func handleRightSwipe(sender: UISwipeGestureRecognizer? = nil) {
        if (sender!.state == UIGestureRecognizerState.Ended)   {
            print("Right Swiping")
            self.gestures.append(Gesture.RightSwipe)
            self.combinationDetection()
        }
    }
    
    func handleTwoFingerDownSwipe(sender: UISwipeGestureRecognizer? = nil) {
        if (sender!.state == UIGestureRecognizerState.Ended)   {
            print("Two Finger Down Swiping")
            self.gestures.append(Gesture.TwoFingerDownSwipe)
            self.combinationDetection()
        }
    }
    
    func handleLongPress(sender: UISwipeGestureRecognizer? = nil) {
        if (sender!.state == UIGestureRecognizerState.Ended)   {
            print("LongPress")
            self.gestures.append(Gesture.LongPress)
            self.combinationDetection()
        }
    }
    
    //    func handlePinch(sender: UIPinchGestureRecognizer? = nil) {
    //        if (sender!.state == UIGestureRecognizerState.Ended)   {
    //            print("Pinch")
    //            self.gestures.append(Gesture.Pinch)
    //            self.combinationDetection()
    //        }
    //    }
    
    func displayEasterEggView() {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navigateToEasterEggScreen(true)
    }
    
    func combinationDetection() {
        
        if(self.gestures == self.gesturesCombo){
            self.gestures = [Gesture]()
            self.displayEasterEggView()
        } else {
            if (self.gestures.count > self.gesturesCombo.count){
                self.gestures = [Gesture]()
            } else {
                for i in 0...self.gestures.count - 1 {
                    if (self.gesturesCombo[i] != self.gestures[i]){
                        self.gestures = [Gesture]()
                    }
                }
            }
        }
        
    }

    //Allow to recognize multiple gestures of the same type
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}