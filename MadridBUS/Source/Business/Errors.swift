import Foundation

enum Errors: Error {
    case RepositoryError(error: Error)
    case ValidationError(error: String)
}
