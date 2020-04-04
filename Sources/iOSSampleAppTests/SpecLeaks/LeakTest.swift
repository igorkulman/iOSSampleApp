//
//  LeakTest.swift
//  Nimble
//
//  Created by Leandro Perez on 01/04/2018.
//

import Quick
import Nimble

//public typealias LeakTestConstructor = () -> AnyObject

public struct LeakTest {
    let constructor: LeakTestConstructor

    public init(constructor:@escaping LeakTestConstructor) {
        self.constructor = constructor
    }

    internal func isLeaking() -> Bool {
        weak var leaked: AnyObject? = nil

        autoreleasepool {

            var evaluated: AnyObject? = self.constructor()

            //To call viewDidLoad on the vc
            view(evaluated)

            leaked = evaluated
            evaluated = nil
        }

        return leaked != nil
    }

    internal func isLeaking<P>( when action: (P) -> Any) -> PredicateStatus where P: AnyObject {
        weak var leaked: AnyObject? = nil

        var failed = false
        var actionResult: Any? = nil

        autoreleasepool {

            var evaluated: P? = self.constructor() as? P

            if evaluated == nil {
                failed = true
            } else {
                actionResult = action(evaluated!)

                //To call viewDidLoad on the vc
                view(evaluated)

                leaked = evaluated
                evaluated = nil
            }
        }

        if failed || actionResult == nil {
            return PredicateStatus.fail
        }

        return PredicateStatus.init(bool: leaked != nil)
    }
}
