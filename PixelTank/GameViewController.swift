//
//  GameViewController.swift
//  PixelTank
//
//  Created by Wendy Jones on 2/26/15.
//  Copyright (c) 2015 kittycode. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    var scene : GameScene? = nil;

    override func viewDidLoad() {
        super.viewDidLoad();
    }

    /****************************************************************
    * viewWillLayoutSubviews
    ****************************************************************/
    override func viewWillLayoutSubviews()
    {
        scene = GameScene(size:view.bounds.size);
        // Configure the view.
        let skView : SKView = self.view as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true;
        skView.showsDrawCount = true;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene!.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }
    
    /****************************************************************
    * shouldAutorotate
    ****************************************************************/
    override func shouldAutorotate() -> Bool {
        return true
    }

    /****************************************************************
    * supportedInterfaceOrientations
    ****************************************************************/
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    /****************************************************************
    * didReceiveMemoryWarning
    ****************************************************************/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    /****************************************************************
    * prefersStatusBarHidden
    ****************************************************************/
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
