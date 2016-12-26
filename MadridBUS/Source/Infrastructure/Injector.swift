import Foundation

protocol Injector {
    func instanceOf<T>(_ type: T.Type) -> T
}

protocol InjectorProvider {
    static var injector: Injector { get }
    func configure()
}
