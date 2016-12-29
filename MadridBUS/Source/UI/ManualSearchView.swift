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
    var backgroundImage = UIImageView()
    
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
        
        backgroundImage.image = #imageLiteral(resourceName: "Radar")
        backgroundImage.tintColor = .white
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.alpha = 0.2
        
        explanationLabel.font = Fonts.standard
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .white
        explanationLabel.numberOfLines = 0
        explanationLabel.adjustsFontSizeToFitWidth = true
        explanationLabel.text = LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_LB_REDEFINERADIUS")

        radiusSegmentedControl.insertSegment(withTitle: "50 m.", at: 0, animated: false)
        radiusSegmentedControl.insertSegment(withTitle: "100 m.", at: 1, animated: false)
        radiusSegmentedControl.insertSegment(withTitle: "200 m.", at: 2, animated: false)
        radiusSegmentedControl.tintColor = .white
        
        relatedActionLabel.font = Fonts.standard
        relatedActionLabel.textAlignment = .left
        relatedActionLabel.textColor = .white
        relatedActionLabel.numberOfLines = 0
        relatedActionLabel.adjustsFontSizeToFitWidth = true
        relatedActionLabel.text = LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_LB_MANUALSEARCH")
        
        relatedActionButton.backgroundColor = Colors.green
        relatedActionButton.setTitle(LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_BT_MANUALSEARCH"), for: .normal)
        relatedActionButton.setTitleColor(.white, for: .normal)
        relatedActionButton.titleLabel?.font = Fonts.button
        
        [backgroundImage, explanationLabel, radiusSegmentedControl, relatedActionLabel, relatedActionButton].forEach({ addSubview($0) })
        
        backgroundImage.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(3)
        }
        
        radiusSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        explanationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(radiusSegmentedControl.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().offset(16)
        }

        relatedActionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(relatedActionButton.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        relatedActionButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalToSuperview()
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
