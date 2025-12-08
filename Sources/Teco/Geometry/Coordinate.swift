//
//  File: Coordinate.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros (skippyr.developer@icloud.com)
//  Connect: https://dragonscave.xyz | GitHub: https://github.com/skippyr
//
//  Refer to the LICENSE file included with this source code for full terms.
//  See the NOTICE file, if included, for third-party attributions.
//

/// Represents a coordinate within the terminal screen cell-grid.
///
/// The origin point, where column and row are both zero, is at the top left corner of the screen. From there, those components increase going right and down, respectively.
struct Coordinate {
    /// The column component of the coordinate.
    public var column: CellUnit
    /// The row component of the coordinate.
    public var row: CellUnit

    /// Creates a new coordinate from its components.
    ///
    /// - Parameter column: the column component of the coordinate.
    /// - Parameter row: the row component of the coordinate.
    public init(column: CellUnit, row: CellUnit) {
        self.column = column
        self.row = row
    }
}
