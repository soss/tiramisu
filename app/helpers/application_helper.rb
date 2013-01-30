module ApplicationHelper

  # renders markdown, escaping premature HTML code before-hand
  def markdown(text)
    text = text.gsub(/</,'&lt;')
               .gsub(/>/,'&gt;')
    Redcarpet.new(text).to_html.html_safe
  end

  # gravatar
  def gravatar_url(user, height = 64)
    default_url = "#{root_url}assets/default_user.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{height}&d=#{CGI.escape(default_url)}"
  end

end