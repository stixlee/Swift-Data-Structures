//
//  Node.swift
//  Swift Data Structures
//
//  Created by Michael Lee on 7/24/18.
//  Copyright © 2018 Michael Lee. All rights reserved.
//

import Foundation

// A generic Node class for linked lists (standard & double)
// Used by LinkedLists.  Internal to library
class Node<T: Comparable> {
    
    var element: T
    var next: Node?
    var previous: Node?
    
    init(with element: T) { self.element = element }
    
}
