import SwiftUI
import Resource

public struct ContentView: View {
    @State private var isBold: Bool = false
    @State private var isItalic: Bool = false
    @State private var isUnderline: Bool = false
    @State private var isStrikethrough: Bool = false
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass: UserInterfaceSizeClass?
    #endif
    
    public init() {}
    
    public var body: some View {
        VStack {
            Image(key: .dogWithApple)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .layoutPriority(1)
            
            Text(.dog_eating_apples(dogName: "Charlie", appleCount: 1))
                .font(.custom(.openSans_regular, size: 16))
                .ifTrue(isBold, then: { $0.bold() })
                .ifTrue(isItalic, then: { $0.italic() })
                .underline(isUnderline)
                .strikethrough(isStrikethrough)
            
            Spacer(minLength: 20).frame(maxHeight: 50)
            
            textStyleControl
            
            Text(.editMenu_textStyle)
            
            Spacer().frame(maxHeight: 10)
        }
    }
    
    @ViewBuilder
    private var textStyleControl: some View {
        HStack {
            ForEach(textStyles, id: \.title.key) { style in
                Toggle(isOn: style.isOn) {
                    Label(title: style.title, imageKey: style.imageKey)
                }
            }
        }
        .toggleStyle(.button)
        #if os(iOS)
        .ifTrue(horizontalSizeClass == .compact, then: { $0.labelStyle(.iconOnly) })
        #endif
        .padding(4)
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(.secondary, lineWidth: 1))
    }
    
    private var textStyles: [TextStyleData] {
        return [
            TextStyleData(
                isOn: $isBold,
                title: .text_bold,
                imageKey: .textFormattingBold),
            TextStyleData(
                isOn: $isItalic,
                title: .text_italic,
                imageKey: .textFormattingItalic),
            TextStyleData(
                isOn: $isUnderline,
                title: .text_underline,
                imageKey: .textFormattingUnderline),
            TextStyleData(
                isOn: $isStrikethrough,
                title: .text_strikethrough,
                imageKey: .textFormattingStrikethrough),
        ]
    }
}

private struct TextStyleData {
    var isOn: Binding<Bool>
    var title: LocalizedStringResource
    var imageKey: ImageKey
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.locale, Locale(identifier: "ko"))
    }
}
