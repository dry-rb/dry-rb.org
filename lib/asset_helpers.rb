module AssetHelpers
  # Output a JavaScript file (from sprockets) inline
  def inline_javascript(name)
    content_tag :script do
      sprockets["#{name}.js"].to_s
    end.to_s
  end
end
