//
//  StoryboardBased.swift
//  Fantasy-Companion
//
//  Created by Vikram on 31/08/2019.
//  Copyright © 2019 Vikram. All rights reserved.
//

import UIKit


/*
 - StoryboardBased.swift
 */

/// Make you UIViewController subclasses conform to this protocol when:
/// * they *are* Storyboard-based and
/// * this ViewController is the initialViewController of your Storyboard
///
/// to be able to instantiate them from the Storyboard in a type-safe manner
public protocol StoryboardBased: class{
    /// The UIStoryboard to use when we want to instantiate this ViewController
    static var sceneStoryboard: UIStoryboard { get }
}

//MARK: Default Implementation
public extension StoryboardBased{
    /// by default, use the storyboard with the same name as the class
    static var sceneStoryboard: UIStoryboard{
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
    }
}

//MARK: Support for instantiation from Storyboard
public extension StoryboardBased where Self: UIViewController{
    /**
     Create an instance of the ViewController from its associated Storyboard's initialViewController
     - returns: instance of the conforming ViewController
     */
    
    static func instantiate() -> Self{
        let viewController = sceneStoryboard.instantiateInitialViewController()
        guard let typedViewController = viewController as? Self else {
            fatalError("The InitialViewController of '\(sceneStoryboard)' is not of class '\(self)'")
        }
        return typedViewController
    }
}
