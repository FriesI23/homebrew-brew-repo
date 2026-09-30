cask "penpot-desktop" do
  version "1.0.0"

  on_arm do
    sha256 "8c7d3f4e4465ef925c9737a29b100298edad39ea546d0f75e385e5955a8ab536"

    url "https://github.com/author-more/penpot-desktop/releases/download/v#{version}/penpot-desktop-arm64.dmg"
  end
  on_intel do
    sha256 "1c70d94b849a0d4787349139a989a40d9ad4ea04de50a13893dc561c000ad795"

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
