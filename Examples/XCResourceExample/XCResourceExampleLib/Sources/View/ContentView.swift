import SwiftUI
import Resources

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
            
            Text(.dogEatingApples(dogName: dogName, appleCount: 1))
                .font(.custom(.openSansRegular, size: 16))
                .bold(isBold)
                .italic(isItalic)
                .underline(isUnderline)
                .strikethrough(isStrikethrough)
            
            Spacer(minLength: 20).frame(maxHeight: 50)
            
            textStyleControl
            
            Text(.editMenuTextStyle)
            
            Spacer().frame(maxHeight: 10)
        }
    }
    
    private var dogName: AttributedString {
        var result = AttributedString("Charlie")
        result.foregroundColor = .green
        result.font = .title2
        return result
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
                title: .textBold,
                imageKey: .Style.textFormattingBold),
            TextStyleData(
                isOn: $isItalic,
                title: .textItalic,
                imageKey: .Style.textFormattingItalic),
            TextStyleData(
                isOn: $isUnderline,
                title: .textUnderline,
                imageKey: .Style.textFormattingUnderline),
            TextStyleData(
                isOn: $isStrikethrough,
                title: .textStrikethrough,
                imageKey: .Style.textFormattingStrikethrough),
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
