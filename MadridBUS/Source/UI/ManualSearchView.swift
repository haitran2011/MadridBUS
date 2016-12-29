import UIKit
import SnapKit

protocol ManualSearchView {
    func show(over view: UIView)
    func hide()
}

class ManualSearchViewBase: UIView, ManualSearchView {
    var explanationLabel = UILabel()
    var radiusSegmentedControl = UISegmentedControl()
    var relatedActionLabel = UILabel()
    var relatedActionButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Colors.blue
        clipsToBounds = true
        
        explanationLabel.font = Fonts.standard
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .white
        explanationLabel.numberOfLines = 0
        explanationLabel.adjustsFontSizeToFitWidth = true
        explanationLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        
        radiusSegmentedControl.insertSegment(withTitle: "50 m.", at: 0, animated: false)
        radiusSegmentedControl.insertSegment(withTitle: "100 m.", at: 1, animated: false)
        radiusSegmentedControl.insertSegment(withTitle: "200 m.", at: 2, animated: false)
        radiusSegmentedControl.tintColor = .white
        
        relatedActionLabel.font = Fonts.standard
        relatedActionLabel.textAlignment = .left
        relatedActionLabel.textColor = .white
        relatedActionLabel.numberOfLines = 0
        relatedActionLabel.adjustsFontSizeToFitWidth = true
        relatedActionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        
        relatedActionButton.backgroundColor = Colors.green
        relatedActionButton.setTitle("ACTION", for: .normal)
        relatedActionButton.setTitleColor(.white, for: .normal)
        relatedActionButton.titleLabel?.font = Fonts.button
        
        [explanationLabel, radiusSegmentedControl, relatedActionLabel, relatedActionButton].forEach({ addSubview($0) })
        
        radiusSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        explanationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(radiusSegmentedControl.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        relatedActionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(relatedActionButton.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        relatedActionButton.snp.makeConstraints { (make) in
            make.height.lessThanOrEqualTo(50)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func show(over view: UIView) {
        view.addSubview(self)
        frame = view.frame
        bounds = view.bounds
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        layoutIfNeeded()
    }
    
    func hide() {
        removeFromSuperview()
    }
}
