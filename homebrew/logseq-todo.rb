cask "logseq-todo" do
  version "0.1.10"
  sha256 "39980b9d2baa4f3424ef4212aa23f72ddf064faebbffc2d032b8634df43712b0"

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