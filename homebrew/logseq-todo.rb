cask "logseq-todo" do
  version "0.1.9"
  sha256 "2e7a285a38216ebe7c1fd834308fbb613d20c257324ddb63748a195be858fbd9"

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