alias zshconfig='vi ~/.zshrc'
alias sourcezsh='source ~/.zshrc'
alias setzsh='chsh -s "$(which zsh)"'
alias setbash='chsh -s "$(which bash)"'
alias c='clear'

# Source private aliases (never committed) from ~/.aliases/*.zsh
for alias_file ("$HOME"/.aliases/*.zsh(N.)); do
  source "$alias_file"
done
