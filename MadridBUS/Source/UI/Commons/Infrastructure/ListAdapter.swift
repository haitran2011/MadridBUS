protocol ListAdapter {
    func numberOfSections() -> Int
	func numberOfItems(in section: Int) -> Int
}

protocol SectionsListAdapter: ListAdapter {
	var numberOfSections: Int { get }
}

extension SectionsListAdapter {
    var numberOfSections: Int {
		return 1
	}
}
