function fzf_g
  git ls-files --modified --deleted --other --exclude-standard --deduplicate | \
    fzf --style minimal --multi --no-sort --reverse \
      --bind 'focus:change-preview:bat --color=always --style=numbers {} 2> /dev/null || git diff -- {}'
end


