//
//  AutoLayoutPropertyWrapper.swift
//  Rick and Morty UIKit
//
//  Created by Pavel Neprin on 12/12/22.
//

import UIKit

@propertyWrapper
public struct AutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
