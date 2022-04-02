# Contributing

- Pull requests are welcome on GitHub at https://github.com/dry-rb/dry-rb.org.

- Make changes to the Markdown files in `/source` and run
  `bundle exec rake build` to generate the latest copy of the site. Commit any
  changed files in `source` and push the branch to GitHub.

- Dont hard-wrap lines in Markdown paragraphs:

        If you hard-wrap a paragraph like this so it spans
        multiple lines, it might look better in your text
        editor, but it'll mess up the formatting when
        Middleman builds the site.

        This paragraph will be fine though because it's kept on one line even though it's longer than 80 characters or whatever your arbitrary limit might be.

- We build the site on `main` exclusively: branches and PRs should not change
  anything in the `docs` directory.
