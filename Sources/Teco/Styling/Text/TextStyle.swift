//
//  TextStyle.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Contains the style properties a text might have.
public struct TextStyle {
    /// An optional set containing active effects.
    public var effects: Set<TextEffect>?
    /// An optional custom padding.
    public var padding: TextPadding?
    /// An optional custom weight.
    public var weight: TextWeight?
    /// An optional custom foreground color.
    public var foreground: Color?
    /// An optional custom background color.
    public var background: Color?

    /// Creates a new style from a list of properties.
    ///
    /// - Parameter foreground: an optional custom foreground color.
    /// - Parameter background: an optional custom background color.
    /// - Parameter weight: an optional custom weight.
    /// - Parameter effects: an optional set containing active effects.
    /// - Parameter padding: an optional custom padding.
    public init(foreground: Color? = nil, background: Color? = nil, weight: TextWeight? = nil, effects: Set<TextEffect>? = nil, padding: TextPadding? = nil) {
        self.foreground = foreground
        self.background = background
        self.weight = weight
        self.effects = effects
        self.padding = padding
    }

    /// A boolean that states whether none of the style properties are set.
    public var isBlank: Bool {
        (effects == nil || effects!.isEmpty) && padding == nil && weight == nil && foreground == nil && background == nil
    }
}
