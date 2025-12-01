//
//  Dimensions.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Represents the terminal screen dimensions.
public struct Dimensions {
    /// The total columns in the dimensions.
    public let totalColumns: CellUnit
    /// The total rows in the dimensions.
    public let totalRows: CellUnit

    /// The area of the dimensions.
    public var area: CellUnit {
        totalColumns.saturatedMultiply(to: totalRows)
    }

    /// Creates new dimensions from its components.
    ///
    /// - Parameter totalColumns: the total columns in the dimensions.
    /// - Parameter totalRows: the total rows in the dimensions.
    public init(totalColumns: CellUnit, totalRows: CellUnit) {
        self.totalColumns = totalColumns
        self.totalRows = totalRows
    }
}
