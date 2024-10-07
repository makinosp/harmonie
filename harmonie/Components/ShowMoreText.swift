import SwiftUI

struct ShowMoreText: View {
    @State private var isExpanded = false
    private let text: String
    private let lineLimit: Int

    init(_ text: String, lineLimit: Int = 3) {
        self.text = text
        self.lineLimit = lineLimit
    }

    var body: some View {
        VStack(spacing: 3) {
            Text(text)
                .lineLimit(isExpanded ? nil : lineLimit)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                withAnimation { isExpanded.toggle() }
            } label: {
                Text(isExpanded ? "Show less" : "Show more")
                    .fontWeight(.regular)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
