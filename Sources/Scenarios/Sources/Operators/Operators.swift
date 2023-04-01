//
//  Operators.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 01.01.2023.
//  Copyright © 2023 Igor Kulman. All rights reserved.
//

import Foundation

precedencegroup FunctionApplicationPrecedence {
  associativity: left
  higherThan: BitwiseShiftPrecedence
}

infix operator &>: FunctionApplicationPrecedence

// swiftlint:disable static_operator
@discardableResult
public func &> <Input>(value: Input, function: (inout Input) throws -> Void) rethrows -> Input {
  var m_value = value
  try function(&m_value)
  return m_value
}
