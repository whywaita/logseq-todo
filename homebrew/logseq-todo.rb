cask "logseq-todo" do
  version "0.1.11"
  sha256 "ee94591d14a955b52400782530039d0843202e97bccd7d2cff05db61390003d4"

  url "https://github.com/whywaita/logseq-todo/releases/download/v#{version}/LogseqTodo-#{version}.zip"
  name "Logseq TODO"
  desc "Menu bar app for Logseq TODO tasks"
  homepage "https://github.com/whywaita/logseq-todo"

  depends_on macos: ">= :sequoia"
  depends_on arch: :arm64

  app "LogseqTodo.app"

  uninstall quit: "it.whywrite.logseq-todo"

  zap trash: [
    "~/Library/Preferences/it.whywrite.logseq-todo.plist",
    "~/Library/Application Support/LogseqTodo",
  ]
end