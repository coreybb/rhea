import UIKit
import LazyBones
import SwiftSyntax
import SwiftParser

final class TextEditorView: LazyView {
    
    
    let textView = CodeTextView()
    
    
    init() {
        super.init(color: UIColor(white: 0.15, alpha: 1))
        let padding: CGFloat = 16
        addSubview(textView)
        textView.fillSuperview(padding: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
}
