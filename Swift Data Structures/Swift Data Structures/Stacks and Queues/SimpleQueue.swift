//
//  SimpleQueue.swift
//  Swift Data Structures
//
//  Created by Michael Lee on 7/25/18.
//  Copyright © 2018 Michael Lee. All rights reserved.
//

import UIKit

// Generic Queue class for any type. Implemented
// with a swift array backing store
//
// Push to the Head of the Queue. Pop from the Tail
//
// Head is the last item in the backing store.
// Tail is the first item in the backing store.

// All operations are Order(1) - on backingStore

public class SimpleQueue<Element> {
    
    private var backingStore: [Element]
    
    public var count: Int { return backingStore.count }
    
    public var headElement: Element? {
        guard backingStore.count > 0 else { return nil }
        return backingStore.last
    }
    
    public var tailElement: Element? {
        guard backingStore.count > 0 else { return nil }
        return backingStore.first
    }

    public init(with array: [Element]) { backingStore = array }
    
    public convenience init() { self.init(with: [Element]() ) }
    
    public func push(_ item: Element) { backingStore.append(item) }
    
    public func pop() -> Element? {
        guard backingStore.count > 0 else { return nil }
        let item = backingStore.first
        backingStore.removeFirst()
        return item
    }
    
    public func asArray() -> [Element] { return backingStore }

}
