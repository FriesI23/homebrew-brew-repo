cask "penpot-desktop" do
  version "0.23.2"

  on_arm do
    sha256 "f0dc9ca47660b0b03270413dde10cb1fc3329700e1a52f045db7017bc396fa4c"

    url "https://github.com/author-more/penpot-desktop/releases/download/v#{version}/penpot-desktop-arm64.dmg",
        verified: "github.com/author-more/penpot-desktop/"
  end
  on_intel do
    sha256 "03e70854a2902488963ca6a457c871819911402ced57bc48e35cf4ec2f4ea162"

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
