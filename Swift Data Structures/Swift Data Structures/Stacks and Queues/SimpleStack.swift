//
//  SimpleStack.swift
//  Swift Data Structures
//
//  Created by Michael Lee on 6/14/18.
//  Copyright © 2018 Michael Lee. All rights reserved.
//

import Foundation

// Generic Stack class for any type implemented
// with a swift array backing store
//
// The Top of the stack is the last item in the array
// Push & Pop from the end of the array/

// All operations are Order(1)
public class SimpleStack<Element> {
    
    private var backingStore: [Element]
    
    public var count: Int { return backingStore.count }
    
    public init(with array: [Element]) { backingStore = array }

    public convenience init() { self.init(with: [Element]() ) }
    
    public func push(item: Element) { backingStore.append(item) }
    
    public func pop() -> Element? {
        guard backingStore.count > 0 else { return nil }
        let item = backingStore.last
        backingStore.removeLast()
        return item
    }
    
    public func asArray() -> [Element] { return backingStore }
    
    public func topItem() -> Element? {
        guard backingStore.count > 0 else { return nil }
        return backingStore.last
    }

}
