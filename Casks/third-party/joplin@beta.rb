cask "joplin@beta" do
  arch arm: "-arm64"

  version "3.7.13"
  sha256 arm:   "cd9e154dcf8a11d56b3f5888dc63d92c26660b27fdd072270c3ec2e3bf76c4ea",
         intel: "b887e3199fcfc625953a2d04f406bab2351ac1e145ae276a1b214df7eedccd66"

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
