cask "table-habit@beta" do
  version "1.26.3+176"
  sha256 "ab78d6fc19733d5f2f6ea2578d5b12bc5f83dbc924943e42fc1fd3a439e43183"

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
  depends_on macos: :catalina

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
