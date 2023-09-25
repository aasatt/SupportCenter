//Copyright (c) 2016 Kenneth Tsang <kenneth.tsang@me.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation
import UIKit

@objc protocol MessageTextViewDelegate: UITextViewDelegate {
    @objc optional func textViewDidChangeHeight(_ textView: MessageTextView, height: CGFloat)
    @objc optional func textWasEntered()
    @objc optional func textWasCleared()
}

protocol MessageTextViewMentionDelegate: AnyObject {
    func shouldHighlightForMention(text: String) -> Bool
    func didHighlightMentions(_ patterns: [String])
    func attributesForNormalText() -> [NSAttributedString.Key: Any]
    func attributesForMentionText() -> [NSAttributedString.Key: Any]
}

@IBDesignable @objc
class MessageTextView: UITextView {
    
    weak var mentionDelegate: MessageTextViewMentionDelegate?
    
    var conversationInputId: String? {
        didSet {
            // NOTE: look into using a restoration identifier
            guard let id = conversationInputId else { return }
            let value = UserDefaults.standard.string(forKey: "input-\(id)") ?? ""
            text = value
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
        }
    }
            
    override var text: String! {
        didSet { setNeedsDisplay() }
    }
    
    private var heightConstraint: NSLayoutConstraint?
    
    // Maximum length of text. 0 means no limit.
    @IBInspectable var maxLength: Int = 0
    
    // Trim white space and newline characters when end editing. Default is true
    @IBInspectable var trimWhiteSpaceWhenEndEditing: Bool = true
    
    // Customization
    @IBInspectable var minHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    @IBInspectable var maxHeight: CGFloat = 0 {
        didSet { forceLayoutSubviews() }
    }
    @IBInspectable var placeholder: String? {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var placeholderColor: UIColor = UIColor(white: 0.8, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var attributedPlaceholder: NSAttributedString? {
        didSet { setNeedsDisplay() }
    }
    
    // Initialize
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        contentMode = .redraw
        associateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: UITextView.textDidEndEditingNotification, object: self)
        textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        textContainer.lineFragmentPadding = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
    
    private func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height,from: https://github.com/legranddamien/MBAutoGrowingTextView
        for constraint in constraints {
            if (constraint.firstAttribute == .height) {
                if (constraint.relation == .equal) {
                    heightConstraint = constraint;
                }
            }
        }
    }
    
    // Calculate and adjust textview's height
    private var oldText: String = ""
    private var oldSize: CGSize = .zero
    
    private func forceLayoutSubviews() {
        oldSize = .zero
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private var shouldScrollAfterHeightChanged = false
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if text == oldText && bounds.size == oldSize { return }
        oldText = text
        oldSize = bounds.size
        
        let size = sizeThatFits(CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        var height = size.height
        
        // Constrain minimum height
        height = minHeight > 0 ? max(height, minHeight) : height
        
        // Constrain maximum height
        height = maxHeight > 0 ? min(height, maxHeight) : height
        
        // Add height constraint if it is not found
        if (heightConstraint == nil) {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            heightConstraint?.priority = UILayoutPriority(950)
            addConstraint(heightConstraint!)
        }
        
        // Update height constraint if needed
        if height != heightConstraint!.constant {
            shouldScrollAfterHeightChanged = true
            heightConstraint!.constant = height
            if let delegate = delegate as? MessageTextViewDelegate {
                delegate.textViewDidChangeHeight?(self, height: height)
            }
        } else if shouldScrollAfterHeightChanged {
            shouldScrollAfterHeightChanged = false
            scrollToCorrectPosition()
        }
    }
    
    private func scrollToCorrectPosition() {
        if self.isFirstResponder {
            self.scrollRangeToVisible(NSMakeRange(-1, 0)) // Scroll to bottom
        } else {
            self.scrollRangeToVisible(NSMakeRange(0, 0)) // Scroll to top
        }
    }
    
    // Show placeholder if needed
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if text.isEmpty {
            let xValue = textContainerInset.left + textContainer.lineFragmentPadding
            let yValue = textContainerInset.top
            let width = rect.size.width - xValue - textContainerInset.right
            let height = rect.size.height - yValue - textContainerInset.bottom
            let placeholderRect = CGRect(x: xValue, y: yValue, width: width, height: height)
            
            if let attributedPlaceholder = attributedPlaceholder {
                // Prefer to use attributedPlaceholder
                attributedPlaceholder.draw(in: placeholderRect)
            } else if let placeholder = placeholder {
                // Otherwise user placeholder and inherit `text` attributes
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = textAlignment
                var attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
                if let font = font {
                    attributes[.font] = font
                }
                
                placeholder.draw(in: placeholderRect, withAttributes: attributes)
            }
        }
    }
    
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        if let sender = notification.object as? MessageTextView, sender == self {
            if trimWhiteSpaceWhenEndEditing {
                text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                setNeedsDisplay()
            }
            scrollToCorrectPosition()
        }
    }
    
    // Limit the length of text
    @objc func textDidChange(notification: Notification) {
        if let sender = notification.object as? MessageTextView, sender == self {
            saveCurrentInput()
            if maxLength > 0 && text.count > maxLength {
                let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                text = String(text[..<endIndex])
                undoManager?.removeAllActions()
            }
            if sender.text.isEmpty {
                (delegate as? MessageTextViewDelegate)?.textWasCleared?()
            } else {
                (delegate as? MessageTextViewDelegate)?.textWasEntered?()
            }
            setNeedsDisplay()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    func saveCurrentInput() {
        guard let id = conversationInputId else {
            return
        }
        let key = "input-\(id)"
        UserDefaults.standard.setValue(text, forKey: key)
    }
    
    private func beginObserveTyping() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionEditingChanged), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(actionEditingEnded), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    private func endObserveTyping() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    // MARK: -- Observe Typing
    
    private var typingTimer: Timer?
    private var typingObservers: [InputFieldTypingObserver] = [] {
        didSet {
            if oldValue.isEmpty, !typingObservers.isEmpty {
                beginObserveTyping()
            }
            if !oldValue.isEmpty, typingObservers.isEmpty {
                endObserveTyping()
            }
        }
    }
    private var lastTypingStatus: Bool = false
    
    @objc func actionEditingChanged() {
        sendTypingEvent(!self.text.isEmpty)
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(timeInterval: 5.0,
                                           target: self,
                                           selector: #selector(self.typingTimerFired),
                                           userInfo: nil,
                                           repeats: false)
        hightlightMentionText()
    }
    
    private func hightlightMentionText() {
        guard let delegate = mentionDelegate else {
            return
        }
        // Test regex https://www.regextester.com/index.php?fam=113243
        let pattern = "\\B\\@[\\S ]+\\b"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }
        let range = NSMakeRange(0, text.count)
        let matches = regex.matches(in: text, options: [], range: range)
        let a = NSMutableAttributedString(string: text, attributes: delegate.attributesForNormalText())
        var highlights: [String] = []
        matches.reversed().forEach {
            let range = $0.range
            guard let start = position(from: beginningOfDocument, offset: range.location),
                let end = position(from: start, offset: range.length),
                let tRange = textRange(from: start, to: end),
                let mentionText = text(in: tRange),
                delegate.shouldHighlightForMention(text: mentionText) else {
                    return
            }
            a.addAttributes(delegate.attributesForMentionText(), range: $0.range)
            highlights.append(mentionText)
        }
        attributedText = a
        delegate.didHighlightMentions(highlights)
    }
    
    @objc func typingTimerFired() {
        sendTypingEvent(false)
        typingTimer?.invalidate()
    }
        
    @objc func actionEditingEnded() {
        sendTypingEvent(false)
    }
    
    private func sendTypingEvent(_ isTyping: Bool) {
        guard isTyping != lastTypingStatus else {
            return
        }
        lastTypingStatus = isTyping
        typingObservers.forEach {
            $0.recieveInputFieldTypingStatusUpdate(isTyping)
        }
    }
    
    func addTypingObserver(_ observer: InputFieldTypingObserver) {
        removeTypingObserver(observer)
        typingObservers.append(observer)
    }
    
    func removeTypingObserver(_ observer: InputFieldTypingObserver) {
        typingObservers.removeAll(where: {$0 == observer})
    }

}

typealias InputFieldTypingObserver = NSObject & InputFieldTypingDelegate

protocol InputFieldTypingDelegate: AnyObject {
    func recieveInputFieldTypingStatusUpdate(_ isTyping: Bool)
}
