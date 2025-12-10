# ``Terminal``
## Topics
### Terminfo lookup
- ``Terminal/termInfoID``

### Styling behavior
- ``Terminal/shouldApplyStyles``
- ``Terminal/shouldApplyColors``

### Streams manipulation
- ``Terminal/isInputRedirected``
- ``Terminal/isOutputRedirected``
- ``Terminal/isErrorRedirected``
- ``Terminal/print(_:terminator:via:)-(.StyledText,_,_)``
- ``Terminal/print(_:terminator:via:)-(.StyledTextFragment,_,_)``
- ``Terminal/print(_:terminator:via:)-(String,_,_)``
- ``Terminal/print(_:terminator:via:)-(Any,_,_)``
- ``Terminal/print(via:)``
- ``Terminal/flushOutputBuffer()``

### Cursor manipulation
- ``Terminal/withCursor(visible:action:)``
- ``Terminal/withCursor(_:blink:action:)``

### Primary screen manipulation
- ``Terminal/screenDimensions``

### Alternate screen manipulation
- ``Terminal/withAlternateScreen(action:)``

### Region cleaning
- ``Terminal/clear(_:)``

### Notifications
- ``Terminal/ringBell()``

### Errors
- ``Terminal/Error``

### Deprecated properties
- ``Terminal/dimensions``

### Deprecated types
- ``Terminal/WritableStream``
- ``Terminal/Style``
- ``Terminal/StyledFragment``
- ``Terminal/StyledString``
- ``Terminal/Layer``
- ``Terminal/Color``
- ``Terminal/ANSIColor``
- ``Terminal/SRGBColor``
- ``Terminal/Weight``
- ``Terminal/Effect``
- ``Terminal/Alignment``
- ``Terminal/Padding``
- ``Terminal/Size``
- ``Terminal/Dimensions``
