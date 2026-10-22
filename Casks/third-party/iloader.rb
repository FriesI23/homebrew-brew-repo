cask "iloader" do
  version "2.4.0"
  sha256 "171fc0aee7e42e6e5db3174ed2a8940d53ef2f1dd475090579e1740d3b139d29"

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
