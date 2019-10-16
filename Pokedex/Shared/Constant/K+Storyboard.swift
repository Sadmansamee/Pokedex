//
//  Storyboard.swift
//  Pokedex
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

import UIKit

enum KStoryboard: String {
    case Home
}

protocol StoryboardLodable: AnyObject {
    static var storyboardName: String { get }
}

protocol HomeStoryboardLodable: StoryboardLodable {
}

protocol AuthStoryboardLodable: StoryboardLodable {
}

extension HomeStoryboardLodable where Self: UIViewController {
    static var storyboardName: String {
        KStoryboard.Home.rawValue
    }
}
