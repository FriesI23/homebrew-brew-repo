cask "table-habit" do
  version "1.23.8+148"
  sha256 "fcddc8788e585931c75b3f232f708549642168cafaf0e68a15f82306874936eb"

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
  depends_on macos: ">= :catalina"

  app "mhabit.app"

  preflight do
    system_command "xattr",
                   args: ["-d", "com.apple.quarantine", "#{staged_path}/mhabit.app"]
  end

  zap trash: [
    "~/Library/Application Support/io.github.friesi23.mhabit",
    "~/Library/Caches/io.github.friesi23.mhabit",
    "~/Library/Preferences/io.github.friesi23.mhabit.plist",
  ]
end
