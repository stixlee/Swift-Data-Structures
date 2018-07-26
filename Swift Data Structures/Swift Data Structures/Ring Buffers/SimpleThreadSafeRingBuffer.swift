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
    
    
    var isEmpty: Bool { return writeHead == readHead }
    

    private var backingStore: [Element?]
    private var size: Int { return backingStore.count }
    private var wrappedWriteHead: Int = 0
    private var wrappedReadHead: Int = 0
    private var readWriteQueue = DispatchQueue(label: "com.stixlee.ringbuffer-read-write-queue",
                                               attributes: [])
    private let readWriteLock = DispatchSemaphore(value: 1)

    private var writeHead: Int {
        get { return wrappedWriteHead }
        set {
            if newValue > size {
                wrappedWriteHead = 0
            } else {
                wrappedWriteHead = newValue
            }
        }
    }
    
    private var readHead: Int {
        get { return wrappedReadHead }
        set {
            if newValue > size {
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
    
    public func write(element: Element) {
        readWriteQueue.async { self.atomicWrite(element: element ) }
    }
    
    public func read(completion: @escaping (Element?) -> Void ) {
        readWriteQueue.async {
            self.atomicRead(completion: completion)
        }
    }
}

// MARK - private methods
extension SimpleThreadSafeRingBuffer {
    
    private func atomicWrite(element: Element) {
        readWriteLock.wait()
        defer { readWriteLock.signal() }
        backingStore[writeHead] = element
        writeHead += 1
    }
    
    private func atomicRead(completion: (Element?) -> Void  ) {
        readWriteLock.wait()
        defer { readWriteLock.signal() }
        if self.isEmpty {
            completion(nil)
            return
        }
        let element: Element? = backingStore[readHead]
        readHead += 1
        completion(element)
    }
}
