import UIKit
import SnapKit

protocol ManualSearchViewDelegate: class {
    func didSelect(radius: Int)
}

protocol ManualSearchView {
    var delegate: ManualSearchViewDelegate? { get set }
    
    func show(over view: UIView, delegating delegate: ManualSearchViewDelegate)
    func hide()
}

class ManualSearchViewBase: UIView, ManualSearchView {
    weak var delegate: ManualSearchViewDelegate?
    
    var explanationLabel = UILabel()
    var radiusSegmentedControl = UISegmentedControl()
    var relatedActionLabel = UILabel()
    var relatedActionButton = UIButton(type: .custom)
    var backgroundImage = UIImageView()
    
    fileprivate let backgroundRotation = CABasicAnimation(keyPath: "transform.rotation")
    
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
        layer.masksToBounds = true

        backgroundRotation.fromValue = 0.0
        backgroundRotation.toValue = CGFloat(M_PI * 2.0)
        backgroundRotation.duration = 2.0
        backgroundRotation.repeatCount = HUGE
        
        backgroundImage.image = #imageLiteral(resourceName: "Radar")
        backgroundImage.tintColor = .white
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.alpha = 0.1
        
        explanationLabel.font = Fonts.standardRegular
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .white
        explanationLabel.numberOfLines = 0
        explanationLabel.adjustsFontSizeToFitWidth = true
        explanationLabel.text = LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_LB_REDEFINERADIUS")

        radiusSegmentedControl.insertSegment(withTitle: "50 m.", at: 0, animated: false)
        radiusSegmentedControl.insertSegment(withTitle: "100 m.", at: 1, animated: false)
        radiusSegmentedControl.insertSegment(withTitle: "200 m.", at: 2, animated: false)
        radiusSegmentedControl.tintColor = .white
        radiusSegmentedControl.selectedSegmentIndex = 0
        radiusSegmentedControl.addTarget(self, action: #selector(radiusSegmentedControlValueDidChange), for: .valueChanged)
        
        relatedActionLabel.font = Fonts.standardRegular
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
            make.width.height.equalToSuperview().dividedBy(4)
        }
        
        radiusSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        explanationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(radiusSegmentedControl.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
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
    
    func show(over view: UIView, delegating delegate: ManualSearchViewDelegate) {
        view.addSubview(self)
        frame = view.frame
        bounds = view.bounds
        self.delegate = delegate
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        layoutIfNeeded()

        backgroundImage.layer.add(backgroundRotation, forKey: nil)
    }
    
    func hide() {
        if superview != nil {
            removeFromSuperview()
        }
    }
    
    func radiusSegmentedControlValueDidChange() {
        switch radiusSegmentedControl.selectedSegmentIndex {
        case 0: delegate?.didSelect(radius: 50)
        case 1: delegate?.didSelect(radius: 100)
        case 2: delegate?.didSelect(radius: 150)
        default: break
        }
    }
}
