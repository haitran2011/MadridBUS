extension String {
    func truncated(toLength length: Int) -> String {
        if self.characters.count > length {
            return self.substring(to: index(startIndex, offsetBy: length))
        }
        
        return self
    }
}
