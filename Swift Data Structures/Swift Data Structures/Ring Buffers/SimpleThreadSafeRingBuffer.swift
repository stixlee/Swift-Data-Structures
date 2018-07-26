//
//  RingBuffer.swift
//  Swift Data Structures
//
//  Created by Michael Lee on 7/25/18.
//  Copyright © 2018 Michael Lee. All rights reserved.
//

import UIKit

let minimumRingBufferSize = 10

public class SimpleThreadSafeRingBuffer<Element> {
    
    public var isEmpty: Bool { return writeHead == readHead && backingStore[readHead] == nil }
    public var isFull: Bool { return backingStore[writeHead] != nil }
    
    private var backingStore: [Element?]
    private var size: Int { return backingStore.count }
    private var wrappedWriteHead: Int = 0
    private var wrappedReadHead: Int = 0
    private var readWriteQueue = DispatchQueue(label: "com.stixlee.ringbuffer-read-write-queue")
    private let readWriteLock = DispatchSemaphore(value: 1)
    
    private var writeHead: Int {
        get { return wrappedWriteHead }
        set {
            if newValue > size-1 {
                wrappedWriteHead = 0
            } else {
                wrappedWriteHead = newValue
            }
        }
    }
    
    private var readHead: Int {
        get { return wrappedReadHead }
        set {
            if newValue > size-1 {
                wrappedReadHead = 0
            } else {
                wrappedReadHead = newValue
            }
        }
    }
    
    
    public init?(size: Int) {
        guard size >= minimumRingBufferSize else { return nil }
        self.backingStore = [Element?](repeating: nil, count: size)
    }
    
    public init?(from array: [Element?]) {
        guard array.count >= minimumRingBufferSize else { return nil }
        self.backingStore = array
    }
    
    public func write(element: Element, completion: @escaping (Bool) -> Void ) {
        readWriteQueue.async {
            self.atomicWrite(element: element, completion: completion)
        }
    }
    
    public func read(completion: @escaping (Element?, Bool) -> Void ) {
        readWriteQueue.async {
            self.atomicRead(completion: completion)
        }
    }
}

// MARK - private methods
extension SimpleThreadSafeRingBuffer {
    
    private func atomicWrite(element: Element, completion: (Bool) -> Void ) {
        readWriteLock.wait()
        defer { readWriteLock.signal() }
        if backingStore[writeHead] == nil {
            backingStore[writeHead] = element
            writeHead += 1
            completion(true)
            
        } else {
            completion(false)
        }
    }
    
    private func atomicRead(completion: (Element?, Bool) -> Void  ) {
        readWriteLock.wait()
        defer { readWriteLock.signal() }
        let element: Element? = backingStore[readHead]
        if element == nil {
            completion(nil, false)
            return
        }
        backingStore[readHead] = nil
        readHead += 1
        completion(element,true)
    }
}
