//
//  LinkedList.swift
//  Swift Data Structures
//
//  Created by Michael Lee on 7/24/18.
//  Copyright © 2018 Michael Lee. All rights reserved.
//

import Foundation

// Iterator class for a LinkedList.  Iterate over every Node in
// The Linkedist starting at the head of the list.

public class LinkedListIterator<T: Comparable>: IteratorProtocol {
    
    public typealias Element = T
    var linkedList: LinkedList<Element>
    var current: Node<Element>?

    init(_ linkedList: LinkedList<Element> ) {
        self.linkedList = linkedList
        self.current = linkedList.head
    }
    
    public func next() -> Element? {
        let item = current?.element
        current = current?.next
        return item
    }
}

// Generic LinkedList class for any Comparable type
//
// Linked List is ordered but non non-indexed.
// For indexed operations, convert the LinkedList
// to an array (by calling the asArray() function).
//
// Public class
public class LinkedList<T: Comparable> {
    
    fileprivate var head: Node<T>?
    
    private var tail: Node<T>?
    
    public var isEmpty: Bool { return head == nil }
    
    // Order(N)
    public var count: Int {
        guard let first = head else { return 0 }
        var count = 1
        var node = first
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
    
    public var first: T? { return head?.element }
    public var last: T? { return tail?.element }
    
    public init(with element: T) {
        self.head = Node<T>(with: element)
        self.tail = self.head
    }
    
    public convenience init?(from array: [T]) {
        guard array.count > 0 else { return nil }
        self.init(with: array[0])
        
        var index = 1
        while index < array.count {
            append(element: array[index])
            index += 1
        }
    }
    
}

// MARK - Order(1) Operations
extension LinkedList {

    public func append(element: T) {
        guard let last = tail else {
            head = Node<T>(with: element)
            tail = head
            return
        }
        last.next = Node<T>(with: element)
        tail = last.next
    }
    
    public func prepend(element: T) {
        guard head != nil else {
            head = Node<T>(with: element)
            tail = head
            return
        }
        let newNode = Node<T>(with: element)
        newNode.next = head
        head = newNode
    }

}

// MARK - Order(N) Pperations
extension LinkedList {

    public func insert(newElement: T, after element: T) -> Bool {
        guard var current = head else { return false }
        while true {
            if current.element == element { //Match
                let next = current.next
                let newNode = Node<T>(with: newElement)
                newNode.next = next
                if tail != nil && current === tail { tail = newNode }
                current.next = newNode
                return true
            }
            guard let next = current.next else { break }
            current = next
        }
        return false
    }
    
    public func insert(newElement: T, before element: T) -> Bool {
        guard let first = head else { return false }
        if first.element == element {
            prepend(element: newElement)
            return true
        }
        var current = first
        while let next = current.next {
            if next.element == element {
                let newNode = Node<T>(with: newElement)
                newNode.next = next
                current.next = newNode
                return true
            }
            current = next
        }
        return false
    }
    
    public func remove(element: T) -> T? {
        guard let first = head else { return nil }
        if first.element == element {
            if tail != nil && head === tail { tail = first.next}
            head = first.next
            return first.element
        }
        var current: Node<T>? = first
        while let next = current?.next {
            if next.element == element {
                if next === tail { tail = next.next }
                current?.next = next.next
                return next.element
            }
            current = next
        }
        return nil
    }
    
    //Order(N*2)
    public func asArray() -> [T] {
        var array = [T]()
        for item in self {
            array.append(item)
        }
        return array
    }

}

// MARK - Sequence Conformity
extension LinkedList: Sequence {
    public func makeIterator() -> LinkedListIterator<T> {
        return LinkedListIterator<T>(self)
    }

}
