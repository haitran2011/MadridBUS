import Foundation

enum Errors: Error {
    case RepositoryError(error: Error)
    case EmptyDataError(error: Error)
}
