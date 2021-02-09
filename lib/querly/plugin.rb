require 'shellwords'

module Danger
  # Run Ruby files through Querly.
  # Results are passed out as a table in markdown.
  #
  # @example Lint changed files
  #
  #          querly.lint
  #
  class DangerQuerly < Plugin
    # Runs Ruby files through Querly. Generates a `markdown` list of warnings.
    def lint(config = nil)
      files_to_lint = _fetch_files_to_lint
      querly_result = _querly(files_to_lint)

      return if querly_result.nil?

      _add_warning_for_each_line(querly_result)
    end

    private

    def _querly(files_to_lint)
      base_command = 'querly -q -f json --only-files'

      querly_output = `#{'bundle exec ' if File.exist?('Gemfile')}#{base_command} #{files_to_lint}`

      return [] if querly_output.empty?

      JSON.parse(querly_output)['warnings']
    end

    def _add_warning_for_each_line(querly_result)
      querly_result.each do |warning|
        arguments = [
          "[query] #{warning['message']}",
          {
            file: warning['file'],
            line: warning['line']
          }
        ]
        warn(*arguments)
      end
    end

    def _fetch_files_to_lint
      to_lint = git.modified_files + git.added_files
      Shellwords.join(to_lint).gsub(" ", ",")
    end
  end
end
