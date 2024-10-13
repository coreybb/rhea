import SwiftSyntax
import UIKit


class SyntaxHighlighter: SyntaxVisitor {
    var attributedString: NSMutableAttributedString
    
    init(text: String) {
        self.attributedString = NSMutableAttributedString(string: text)
        super.init(viewMode: .sourceAccurate)
    }
    
    override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
        let startLocation = token.position.utf8Offset
        let length = token.trimmedLength
        
        let range = NSRange(location: startLocation, length: length.utf8Length)
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        switch token.tokenKind {
        case .keyword:
            attributes[.foregroundColor] = UIColor.systemPurple
        case .stringQuote, .stringSegment:
            attributes[.foregroundColor] = UIColor.systemGreen
        case .integerLiteral, .floatLiteral:
            attributes[.foregroundColor] = UIColor.systemOrange
        case .identifier:
            attributes[.foregroundColor] = UIColor.white
        case .comma, .leftParen, .rightParen, .leftBrace, .rightBrace, .leftSquare, .rightSquare:
            attributes[.foregroundColor] = UIColor.systemYellow
        default:
            attributes[.foregroundColor] = UIColor.lightGray
        }
        
        if range.location + range.length <= attributedString.length {
            attributedString.addAttributes(attributes, range: range)
        }
        
        return .visitChildren
    }
}

