import Foundation

class LineSchemeNodeModel: Equatable {
    var name: String
    var position: Int
    var direction: LineSchemeDirection

    init(name: String, position: Int, direction: LineSchemeDirection) {
        self.name = name
        self.position = position
        self.direction = direction
    }
}

func ==<T: LineSchemeNodeModel>(left: T, right: T) -> Bool {
    return left.name == right.name && left.position == right.position && left.direction == right.direction
}
