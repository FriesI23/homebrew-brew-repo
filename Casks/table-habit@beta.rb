cask "table-habit@beta" do
  version "1.22.0+123"
  sha256 "7f9f05224a42e7f4e57f9f2c09b531ddbc13249d83394047d40a1f85a53786f5"

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
    if system_command("pgrep", args: ["-x", "mhabit"], print_stderr: false).exit_status == 0
      system_command "osascript",
                     args: ['-e', 'tell application "mhabit" to quit']
      File.write("/tmp/mhabit_beta_was_running", "1")
    end
    File.write("/tmp/mhabit_beta_installed_version", version)
  end

  postflight do
    if File.exist?("/tmp/mhabit_beta_installed_version")
      installed_version = File.read("/tmp/mhabit_beta_installed_version").strip
      if installed_version != "#{version}"
        odie "Beta version mismatch! Expected #{version}, but got #{installed_version}."
      end
      File.delete("/tmp/mhabit_beta_installed_version")
    end
    if File.exist?("/tmp/mhabit_beta_was_running")
      system_command "open", args: ["-a", "mhabit"]
      File.delete("/tmp/mhabit_beta_was_running")
    end
  end

  zap trash: [
    "~/Library/Application Support/io.github.friesi23.mhabit",
    "~/Library/Caches/io.github.friesi23.mhabit",
    "~/Library/Preferences/io.github.friesi23.mhabit.plist",
  ]
end