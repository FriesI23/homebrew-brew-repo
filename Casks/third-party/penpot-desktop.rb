cask "penpot-desktop" do
  version "0.24.0"

  on_arm do
    sha256 "e8d4fb4af6ed33e2a0c280d8882b23af21b9c28d9c0cdba5206aa16e036b5496"

    url "https://github.com/author-more/penpot-desktop/releases/download/v#{version}/penpot-desktop-arm64.dmg",
        verified: "github.com/author-more/penpot-desktop/"
  end
  on_intel do
    sha256 "a5ecbebee355580eda6f176b26a8056487918f7fdfc4ec3ad26f1d4e205ee1d1"

    url "https://github.com/author-more/penpot-desktop/releases/download/v#{version}/penpot-desktop-x64.dmg",
        verified: "github.com/author-more/penpot-desktop/"
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
