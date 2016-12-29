import UIKit
import SnapKit

class NodesNearTable: UITableView {
    let nodeCell = "NodeCell"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Colors.blue
        clipsToBounds = true
    }

    func show(over view: UIView, delegating delegate: UITableViewDelegate, sourcing datasource: UITableViewDataSource) {
        view.addSubview(self)
        frame = view.frame
        bounds = view.bounds
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.delegate = delegate
        self.dataSource = datasource
        register(UINib(nibName: "WelcomeNodeCell", bundle: nil), forCellReuseIdentifier: nodeCell)
        
        layoutIfNeeded()
    }
    
    func hide() {
        removeFromSuperview()
    }
}
