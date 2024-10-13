import UIKit
import SwiftParser


class CodeTextView: UITextView {
    
    private var isUpdating = false
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        autocapitalizationType = .none
        spellCheckingType = .no
        autocorrectionType = .no
        textColor = .white
        font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func highlightSyntax() {
        guard let text = self.text,
                !text.isEmpty,
                !isUpdating else { return }
        
        isUpdating = true
        
        let selectedRange = self.selectedRange
        
        let sourceFile = Parser.parse(source: text)
        let highlighter = SyntaxHighlighter(text: text)
        highlighter.walk(sourceFile)
        
        let newAttributedString = highlighter.attributedString
        
        // Ensure we're not trying to access out of bounds
        let maxLength = min(textStorage.length, newAttributedString.length)
        let fullRange = NSRange(location: 0, length: maxLength)
        
        textStorage.beginEditing()
        textStorage.setAttributes([:], range: fullRange) // Clear existing attributes
        newAttributedString.enumerateAttributes(in: fullRange, options: []) { (attributes, range, _) in
            textStorage.addAttributes(attributes, range: range)
        }
        textStorage.endEditing()
        
        // Ensure the selected range is within bounds
        let maxLocation = max(0, min(selectedRange.location, textStorage.length))
        let _maxLength = max(0, min(selectedRange.length, textStorage.length - maxLocation))
        self.selectedRange = NSRange(location: maxLocation, length: _maxLength)
        
        isUpdating = false
    }
}

extension CodeTextView: NSTextStorageDelegate {
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            highlightSyntax()
        }
    }
}



extension CodeTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        highlightSyntax()
    }
}
