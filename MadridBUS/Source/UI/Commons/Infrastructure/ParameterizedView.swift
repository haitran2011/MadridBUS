import Foundation

protocol ParameterizedView: View {
    var params: [String: Any] { get set }
}
