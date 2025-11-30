cask "table-habit@beta" do
  version "1.22.1+124"
  sha256 "9e2bf98ffd18dccfd3050a994335e0cd4fc43c6f85b4ff697acd57ad3afad6a7"

  url "https://github.com/FriesI23/mhabit/releases/download/pre-v#{version}/mhabit.dmg"
  name "Table Habit"
  desc "Simple habit tracker"
  homepage "https://github.com/FriesI23/mhabit"

  livecheck do
    url :url
    strategy :github_releases do |json, _regex|
      versions = json.map do |release|
        tag = release["tag_name"]
        tag.sub(/^pre-v/, "")
      end
      versions.map { |v| Version.new(v) }.max.to_s
    end
  end

  auto_updates false
  conflicts_with cask: "table-habit"
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
