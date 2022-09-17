import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    func addRightBorder(borderColor: UIColor, borderWidth: CGFloat) {
       let border = CALayer()
       border.backgroundColor = borderColor.cgColor
       border.frame = CGRect(x: self.frame.size.width - borderWidth,y: 0, width:borderWidth, height:self.frame.size.height)
       self.layer.addSublayer(border)
    }
    
    ///
    public func constraints(pinningEdgesTo view: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor) ]
        return constraints
    }
    
    ///
    public func constraints(pinningEdgesTo layoutGuide: UILayoutGuide) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            self.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            self.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor) ]
        return constraints
    }
    
    ///
    public func constraints(centeringIn view: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor) ]
        return constraints
    }
    
    func usesAutolayout(_ usesAutolayout: Bool) {
        translatesAutoresizingMaskIntoConstraints = !usesAutolayout
    }
}
