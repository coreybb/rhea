import UIKit
import LazyBones
import SwiftSyntax
import SwiftParser

final class TextEditorView: LazyView {
    
    
    let textView = CodeTextView()
    
    
    init() {
        super.init(color: UIColor(white: 0.15, alpha: 1))
        let lateralPadding: CGFloat = 16
        let topPadding: CGFloat = 8
        let bottomPadding: CGFloat = 0
        addSubview(textView)
        textView.fillSuperview(padding: UIEdgeInsets(top: topPadding, left: lateralPadding, bottom: bottomPadding, right: lateralPadding))
    }
}
