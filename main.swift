import Foundation

struct Terminal {
    static let supportsColor = ProcessInfo.processInfo.environment["NO_COLOR"] == nil
        && ProcessInfo.processInfo.environment["TERM"] != "dumb"

    static func paint(_ text: String, _ code: String) -> String {
        supportsColor ? "\u{001B}[\(code)m\(text)\u{001B}[0m" : text
    }
}

let title = "Hello, Swift!"
let subtitle = "A tiny program with a little sparkle."
let timestamp = Date().formatted(date: .abbreviated, time: .standard)

let lines = [
    "  \(Terminal.paint(title, "1;36"))",
    "  \(subtitle)",
    "  Running at \(timestamp)"
]

let visibleWidths = lines.map { line in
    line.replacingOccurrences(
        of: #"\u{001B}\[[0-9;]*m"#,
        with: "",
        options: .regularExpression
    ).count
}

let width = (visibleWidths.max() ?? 0) + 2
let top = "╭" + String(repeating: "─", count: width) + "╮"
let bottom = "╰" + String(repeating: "─", count: width) + "╯"

print(Terminal.paint(top, "35"))

for (index, line) in lines.enumerated() {
    let padding = String(repeating: " ", count: width - visibleWidths[index])
    print(Terminal.paint("│", "35") + line + padding + Terminal.paint("│", "35"))
}

print(Terminal.paint(bottom, "35"))
