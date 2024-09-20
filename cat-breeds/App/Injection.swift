//
//  Injection.swift
//  cat-breeds
//
//  Created by Developer on 20/09/24.
//

/*
 Must register value using InjectionContainer.register method
 Setting it's value using this Inject wrapper won't affect the container value
 */
@propertyWrapper struct Inject<Value> {
    private let value: Value

    var wrappedValue: Value {
        get { self.value }
        set {
            // Shouldn't be used to set a injected value
        }
    }

    init() {
        self.value = InjectionContainer.resolve(type: Value.self)
    }
}

internal struct InjectionContainer {
    private static var injectedValues: [String: Any] = [:]

    static func register<P>(type: P.Type, value: P) {
        let key = String(String(describing: type.self))
        injectedValues[key] = value
    }

    fileprivate static func resolve<P>(type: P.Type) -> P {
        let key = String(String(describing: type.self))
        guard let value = injectedValues[key] as? P else {
            fatalError("Must inject value using `InjectionContainer.register` method")
        }
        return value
    }
}
