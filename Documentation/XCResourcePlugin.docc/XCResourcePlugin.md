# ``Documentation``

Easily generate Swift code for localized strings, fonts, and other resource files, streamlining resource management in your projects.

@Metadata {
    @TitleHeading("Command Plugin")
    @DisplayName("XCResource")
}

## Overview

XCResource is a tool designed to help you efficiently and safely manage resources such as localized strings, fonts, and other files in Xcode projects.  
By automating code generation, it minimizes typos and prevents runtime errors.

With just a few steps, you can transform code like this:

```swift
VStack {
    LottieView(animation: .named("warning.json"))
    
    Text("\(filename)\" will be deleted.\nThis action cannot be undone.")
        .font(.custom("OpenSans-Regular", size: 16))
}
```

Into something cleaner and safer:

```swift
VStack {
    LottieView(.warning)
    
    Text(.alertDeleteFile(named: filename))
        .font(.custom(.openSansRegular, size: 16))
}
```

## Topics

### Getting Started

- <doc:Integrating-XCResource-into-a-Swift-Package>
- <doc:Generating-LocalizedStringResource>
- <doc:Generating-FontResource>

### Advanced

- <doc:Configuration-File-Format>
