cask "table-habit" do
  version "1.27.18+207"
  sha256 "be58fb679ad9e9d51e66ffb75c9c56c47cc545d0219c5658a12f5c501d6b474d"

  url "https://github.com/FriesI23/mhabit/releases/download/v#{version}/mhabit.dmg"
  name "Table Habit"
  desc "Simple habit tracker"
  homepage "https://github.com/FriesI23/mhabit"

  livecheck do
    url :url
    strategy :github_latest do |json|
      json["tag_name"].delete_prefix("v")
    end
  end

  auto_updates false
  conflicts_with cask: "table-habit@beta"
  depends_on :macos

  app "mhabit.app"

  preflight_steps do
    run "xattr", args: ["-d", "com.apple.quarantine", "{{staged_path}}/mhabit.app"]
  end

  zap trash: [
    "~/Library/Application Support/io.github.friesi23.mhabit",
    "~/Library/Caches/io.github.friesi23.mhabit",
    "~/Library/Preferences/io.github.friesi23.mhabit.plist",
  ]
end
