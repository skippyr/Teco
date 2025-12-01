//
//  String+Styles.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

extension String {
    func rawPad(using padding: TextPadding) -> String {
        let totalPaddingLength = max(0, Int(padding.length) - count)
        switch padding.alignment {
        case .left:
            return self + String(repeating: padding.character, count: totalPaddingLength)
        case .right:
            return String(repeating: padding.character, count: totalPaddingLength) + self
        case .center:
            let leftPaddingLength = totalPaddingLength / 2
            let rightPaddingLength = totalPaddingLength - leftPaddingLength
            return String(repeating: padding.character, count: leftPaddingLength) + self + String(repeating: padding.character, count: rightPaddingLength)
        }
    }
}
