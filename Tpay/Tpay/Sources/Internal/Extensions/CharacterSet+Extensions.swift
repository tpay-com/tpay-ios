//
//  Copyright © 2023 Tpay. All rights reserved.
//

extension CharacterSet {
    
    static let specialcharacters = CharacterSet(charactersIn: "~!@#$%^&*()_+[]{}")
    static let emojis: CharacterSet = { 
            var emojiSet = CharacterSet()
            emojiSet.insert(charactersIn: "\u{1F600}"..."\u{1F64F}") // Emoticons
            emojiSet.insert(charactersIn: "\u{1F300}"..."\u{1F5FF}") // Miscellaneous Symbols and Pictographs
            emojiSet.insert(charactersIn: "\u{1F680}"..."\u{1F6FF}") // Transport and Map Symbols
            emojiSet.insert(charactersIn: "\u{1F700}"..."\u{1F77F}") // Alchemical Symbols
            emojiSet.insert(charactersIn: "\u{1F780}"..."\u{1F7FF}") // Geometric Shapes Extended
            emojiSet.insert(charactersIn: "\u{1F800}"..."\u{1F8FF}") // Supplemental Arrows-C
            emojiSet.insert(charactersIn: "\u{1F900}"..."\u{1F9FF}") // Supplemental Symbols and Pictographs
            emojiSet.insert(charactersIn: "\u{1FA00}"..."\u{1FA6F}") // Chess Symbols
            emojiSet.insert(charactersIn: "\u{1FA70}"..."\u{1FAFF}") // Symbols and Pictographs Extended-A
            emojiSet.insert(charactersIn: "\u{2600}"..."\u{26FF}")   // Miscellaneous Symbols
            emojiSet.insert(charactersIn: "\u{2700}"..."\u{27BF}")   // Dingbats
            emojiSet.insert(charactersIn: "\u{1F000}"..."\u{1F02F}") // Mahjong Tiles
            emojiSet.insert(charactersIn: "\u{1F0A0}"..."\u{1F0FF}") // Playing Cards
            emojiSet.insert(charactersIn: "\u{FE0F}")                // Variation Selector-16
            return emojiSet
        }()
}
