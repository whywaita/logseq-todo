cask "logseq-todo" do
  version "0.1.7"
  sha256 "41bfe9e85d1cec0ce7c800a7cbc5af3258683c77592222d2e0ca3a7780c6cb72"

  url "https://github.com/whywaita/logseq-todo/releases/download/v#{version}/LogseqTodo-#{version}.zip"
  name "Logseq TODO"
  desc "Menu bar app for Logseq TODO tasks"
  homepage "https://github.com/whywaita/logseq-todo"

  depends_on macos: ">= :sequoia"
  depends_on arch: :arm64

  app "LogseqTodo.app"

  uninstall quit: "com.whywaita.logseq-todo"

  zap trash: [
    "~/Library/Preferences/com.whywaita.logseq-todo.plist",
    "~/Library/Application Support/LogseqTodo",
  ]
end