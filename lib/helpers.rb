def ask(prompt, options={})
  if options[:secret]
    begin
      $stdin.extend Termios
      oldsetting = $stdin.tcgetattr
      newsetting = oldsetting.dup
      newsetting.lflag &= ~Termios::ECHO
      $stdin.tcsetattr(Termios::TCSANOW, newsetting)
      print prompt
      answer = $stdin.gets.chomp
    ensure
      $stdin.tcsetattr(Termios::TCSANOW, oldsetting)
    end
    puts
    answer
  else
    print prompt
    $stdin.gets.chomp
  end
end

def require_or_prompt(dep)
  begin
    require dep
  rescue LoadError
    abort "You are missing the `#{dep}` gem. Please install it to continue."
  end
end