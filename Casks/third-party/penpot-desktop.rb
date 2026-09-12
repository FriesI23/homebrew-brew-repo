cask "penpot-desktop" do
  version "0.25.0"

  on_arm do
    sha256 "ca39c51b5e2e4681486601561bdcef3f3b5e71d0b3ce7d284ff16ea930687aa5"

    url "https://github.com/author-more/penpot-desktop/releases/download/v#{version}/penpot-desktop-arm64.dmg"
  end
  on_intel do
    sha256 "00a6065760cf62ea601ca07c396339f32fbe4ff15b06115773deed53ce6cf1c6"

    url "https://github.com/author-more/penpot-desktop/releases/download/v#{version}/penpot-desktop-x64.dmg"
  end

  name "Penpot Desktop"
  desc "Unofficial desktop application for Penpot, an open-source design tool"
  homepage "https://github.com/author-more/penpot-desktop"

  livecheck do
    url :url
    strategy :github_latest do |json|
      json["tag_name"]&.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: :monterey

  app "Penpot Desktop.app"

  zap trash: [
    "~/Library/Application Support/com.authormore.penpotdesktop",
    "~/Library/Caches/com.authormore.penpotdesktop",
    "~/Library/Logs/com.authormore.penpotdesktop",
    "~/Library/Preferences/com.authormore.penpotdesktop.plist",
    "~/Library/Saved Application State/com.authormore.penpotdesktop.savedState",
  ]
end
