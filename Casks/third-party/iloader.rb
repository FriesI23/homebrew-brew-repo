cask "iloader" do
  version "2.4.1"
  sha256 "51b1de6b498d4dc5657bffc0ba218e55693e19715edc4b671217dd7a0c54445b"

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
