cask "penpot-desktop" do
  version "1.0.1"

  on_arm do
    sha256 "f0a944709846e45d11dac8b71d19618d7c6d3782e8228c3af3f0241314cee112"

    url "https://github.com/author-more/penpot-desktop/releases/download/v#{version}/penpot-desktop-arm64.dmg"
  end
  on_intel do
    sha256 "f5603709b32b0953e608dbbdae43d8d1550801524bae10bbbb361a4a9e2add98"

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
