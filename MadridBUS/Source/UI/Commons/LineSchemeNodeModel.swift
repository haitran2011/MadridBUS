import Foundation

class LineSchemeNodeModel: Equatable {
    var id: Int
    var name: String
    var position: Int
    var direction: LineSchemeDirection
    var latitude: Double?
    var longitude: Double?
    var selected: Bool

    init(id: Int, name: String, position: Int, direction: LineSchemeDirection, latitude: Double?, longitude: Double?, selected: Bool = false) {
        self.id = id
        self.name = name
        self.position = position
        self.direction = direction
        self.latitude = latitude
        self.longitude = longitude
        self.selected = selected
    }
}

func ==<T: LineSchemeNodeModel>(left: T, right: T) -> Bool {
    return left.id == right.id
}
