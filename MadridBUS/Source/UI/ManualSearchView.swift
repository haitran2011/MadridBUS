import UIKit
import SnapKit

protocol ManualSearchViewDelegate: class {
    func didSelect(radius: Int)
}

protocol ManualSearchView {
    var delegate: ManualSearchViewDelegate? { get set }
    
    func show(over view: UIView, mode: ManualSearchViewMode, delegating delegate: ManualSearchViewDelegate)
    func hide()
}

enum ManualSearchViewMode {
    case unableToLocate
    case noLocationPermission
}

class ManualSearchViewBase: UIView, ManualSearchView {
    weak var delegate: ManualSearchViewDelegate?
    
    var explanationLabel = UILabel()
    var radiusSegmentedControl = UISegmentedControl()
    var relatedActionLabel = UILabel()
    var scanButton = UIButton(type: .custom)
    var typeButton = UIButton(type: .custom)
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
        
        explanationLabel.textAlignment = .left
        explanationLabel.textColor = .white
        explanationLabel.numberOfLines = 0
        explanationLabel.adjustsFontSizeToFitWidth = true

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
        
        scanButton.backgroundColor = Colors.midnight
        scanButton.setTitle(LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_BT_SCANCODE"), for: .normal)
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.titleLabel?.font = Fonts.button
        
        typeButton.backgroundColor = Colors.green
        typeButton.setTitle(LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_BT_TYPECODE"), for: .normal)
        typeButton.setTitleColor(.white, for: .normal)
        typeButton.titleLabel?.font = Fonts.button
        
        [backgroundImage, explanationLabel, radiusSegmentedControl, relatedActionLabel, scanButton, typeButton].forEach({ addSubview($0) })
        
        backgroundImage.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(4)
        }
        
        radiusSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(29)
        }
        
        explanationLabel.snp.makeConstraints { (make) in
            make.top.equalTo(radiusSegmentedControl.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        relatedActionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(scanButton.snp.top).offset(-8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        scanButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.leading.bottom.equalToSuperview()
        }
        
        typeButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalToSuperview().dividedBy(2)
            make.leading.equalTo(scanButton.snp.trailing)
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    func show(over view: UIView, mode: ManualSearchViewMode, delegating delegate: ManualSearchViewDelegate) {
        switch mode {
        case .unableToLocate:
            explanationLabel.font = Fonts.standardRegular
            explanationLabel.text = LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_LB_REDEFINERADIUS")
            
            backgroundImage.image = #imageLiteral(resourceName: "Radar")
            backgroundImage.tintColor = .white
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.alpha = 0.1
            backgroundImage.layer.add(backgroundRotation, forKey: "BackgroundRotation")
            
            backgroundImage.snp.remakeConstraints { (make) in
                make.centerX.centerY.equalToSuperview()
                make.width.height.equalToSuperview().dividedBy(4)
            }
            
            radiusSegmentedControl.isHidden = false
            radiusSegmentedControl.snp.updateConstraints({ (make) in
                make.height.equalTo(29)
            })
            
            explanationLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(radiusSegmentedControl.snp.bottom).offset(8)
            })
        
        case .noLocationPermission:
            explanationLabel.font = Fonts.standardBold
            explanationLabel.text = LocalizedLiteral.localize(using: "MANUALSEARCHVIEW_LB_LOCATIONPERMISSION")
            
            backgroundImage.image = #imageLiteral(resourceName: "NoLocation")
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.alpha = 1
            backgroundImage.layer.removeAllAnimations()
            
            backgroundImage.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalToSuperview().dividedBy(4)
                make.leading.trailing.equalToSuperview()
            }
            
            radiusSegmentedControl.isHidden = true
            radiusSegmentedControl.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            
            explanationLabel.snp.updateConstraints({ (make) in
                make.top.equalTo(radiusSegmentedControl.snp.bottom)
            })
        }
        
        view.addSubview(self)
        frame = view.frame
        bounds = view.bounds
        self.delegate = delegate
        snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        layoutIfNeeded()
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
