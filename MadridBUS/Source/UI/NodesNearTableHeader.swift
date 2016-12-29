import UIKit
import SnapKit

class NodesNearTableHeader: UITableViewHeaderFooterView {
    var titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = Colors.blue
        
        titleLabel.font = Fonts.standardBold
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        
        [titleLabel].forEach({ addSubview($0) })
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}
