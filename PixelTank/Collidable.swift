//
//  Collidable.swift
//
//

import Foundation;
import SpriteKit;

protocol Collidable
{
    func handleCollisionWithObject(otherBody:SKPhysicsBody);
}