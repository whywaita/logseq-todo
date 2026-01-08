cask "logseq-todo" do
  version "0.1.12"
  sha256 "80c1d5662d90e5d9c7c912567e325712bc683fffe2e81c1668386f54e8ef35be"

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