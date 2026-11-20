cask "iloader" do
  version "2.4.2"
  sha256 "e67b92eeaf16493991c1721aec3e2aaedde6670a4fa4a546c111718340bf0680"

  url "https://github.com/nab138/iloader/releases/download/v#{version}/iloader-darwin-universal.dmg"
  name "iloader"
  desc "iOS sideloading companion"
  homepage "https://iloader.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "iloader.app"

  zap trash: [
    "~/Library/Application Support/me.nabdev.iloader",
    "~/Library/Caches/me.nabdev.iloader",
    "~/Library/WebKit/me.nabdev.iloader",
  ]
end
