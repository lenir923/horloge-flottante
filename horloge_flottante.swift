// Horloge flottante : grande fenêtre toujours au premier plan.
//   horloge         -> l'heure (HH:MM:SS), blanc sur noir, en haut à droite
//   horloge chrono  -> chrono qui part de 00:00:00 au lancement, blanc sur rouge, 3x plus grand, juste en dessous
// Se déplace à la souris, clic droit pour quitter.
// Compiler : swiftc -O horloge_flottante.swift -o horloge
import AppKit

final class ClockPanel: NSPanel {
    override var canBecomeKey: Bool { true }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    let isChrono = CommandLine.arguments.dropFirst().first == "chrono"
    let start = Date()
    var panel: ClockPanel!
    var label: NSTextField!
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Le chrono est trois fois plus grand que l'horloge.
        let scale: CGFloat = isChrono ? 3 : 1
        let size = NSSize(width: 230 * scale, height: 70 * scale)
        let margin: CGFloat = 20
        let screen = NSScreen.main?.visibleFrame ?? .zero
        // Le chrono se place sous l'horloge pour ne pas la recouvrir.
        let top = screen.maxY - margin - (isChrono ? 70 + margin : 0)
        let origin = NSPoint(x: screen.maxX - size.width - margin, y: top - size.height)

        panel = ClockPanel(contentRect: NSRect(origin: origin, size: size),
                           styleMask: [.borderless, .nonactivatingPanel],
                           backing: .buffered, defer: false)
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        panel.isMovableByWindowBackground = true
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true

        // Fond plein aux coins arrondis (le flou du système laissait des coins blancs sur fond clair).
        let bg = NSView(frame: NSRect(origin: .zero, size: size))
        bg.wantsLayer = true
        bg.layer?.backgroundColor = (isChrono ? NSColor.systemRed : NSColor.black).cgColor
        bg.layer?.cornerRadius = 16 * scale
        bg.layer?.cornerCurve = .continuous
        bg.layer?.masksToBounds = true

        label = NSTextField(labelWithString: "")
        label.font = .monospacedDigitSystemFont(ofSize: 44 * scale, weight: .semibold)
        label.textColor = .white
        label.alignment = .center
        label.frame = NSRect(x: 0, y: (size.height - 54 * scale) / 2, width: size.width, height: 54 * scale)
        bg.addSubview(label)

        let menu = NSMenu()
        menu.addItem(withTitle: isChrono ? "Quitter le chrono" : "Quitter l'horloge",
                     action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        bg.menu = menu

        panel.contentView = bg
        panel.orderFrontRegardless()
        // L'ombre est calculée sur la forme arrondie une fois le contenu dessiné.
        panel.display()
        panel.invalidateShadow()

        tick()
        // 10 vérifications par seconde : la seconde affichée change au plus 0,1 s en retard.
        let timer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in self?.tick() }
        RunLoop.main.add(timer, forMode: .common)
    }

    func tick() {
        let text: String
        if isChrono {
            let s = Int(Date().timeIntervalSince(start))
            text = String(format: "%02d:%02d:%02d", s / 3600, s / 60 % 60, s % 60)
        } else {
            text = formatter.string(from: Date())
        }
        if label.stringValue != text { label.stringValue = text }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
