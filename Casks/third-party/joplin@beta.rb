cask "joplin@beta" do
  arch arm: "-arm64"

  version "3.7.14"
  sha256 arm:   "2a41773769758cd5db5453d1e1fb0d119a6f29d36940435cbb06df9481431efd",
         intel: "c1fb723378df866002108577e5b92c3881f842b6945fef7c0dda23d79b8b9d2e"

  url "https://github.com/laurent22/joplin/releases/download/v#{version}/Joplin-#{version}#{arch}.DMG",
      verified: "github.com/laurent22/joplin/"
  name "Joplin Beta"
  desc "Pre-release of the note taking and to-do application"
  homepage "https://joplinapp.org/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"] || !release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        asset_names = release["assets"]&.filter_map { |asset| asset["name"] } || []
        expected_assets = ["Joplin-#{match[1]}-arm64.DMG", "Joplin-#{match[1]}.dmg"]
        has_all_assets = expected_assets.all? do |expected|
          asset_names.any? { |name| name.casecmp?(expected) }
        end
        next unless has_all_assets

        match[1]
      end
    end
  end

  conflicts_with cask: "joplin"
  depends_on macos: :monterey

  app "Joplin.app"

  zap trash: [
    "~/Library/Application Support/Joplin",
    "~/Library/Preferences/net.cozic.joplin-desktop.helper.plist",
    "~/Library/Preferences/net.cozic.joplin-desktop.plist",
    "~/Library/Saved Application State/net.cozic.joplin-desktop.savedState",
  ]

  caveats <<~EOS
    Joplin 3.7 upgrades the local profile and raises the minimum sync version.
    Back up your profile and update every syncing device to Joplin 3.7 or newer
    before using this pre-release. Downgrading to Joplin 3.6 may not be possible.
  EOS
end
