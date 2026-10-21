cask "iloader" do
  version "2.3.10"
  sha256 "302ea6cb1434d4b0a9468024c629e680e739ed858b9cdb16f164efc8d63b37d3"

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
