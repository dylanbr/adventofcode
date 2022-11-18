require "benchmark"

@basedir = Dir.pwd

days = Dir["./day*"].map { |dir|
  dir.match(/\d+/).to_s.to_i
}.sort

def capture_stdout
  old = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = old
end
class String
  CM_BOLD=1
  CM_ITALIC=3
  CM_UNDERLINE=4
  CM_BLINK=5
  CM_REVERSE=7

  CF_BLACK=30
  CF_RED=31
  CF_GREEN=32
  CF_BROWN=33
  CF_BLUE=34
  CF_MAGENTA=35
  CF_CYAN=36
  CF_WHITE=37

  CB_BLACK=40
  CB_RED=41
  CB_GREEN=42
  CB_BROWN=43
  CB_BLUE=44
  CB_MAGENTA=45
  CB_CYAN=46
  CB_WHITE=47

  def colorise(color_codes)
    "\e[#{color_codes.join(";")}m#{self}\e[0m"
  end
end

days.each do |day|
  Dir.chdir @basedir + "/day#{day}"
  print "[Day #{day}]\n".colorise([String::CM_BOLD, String::CF_WHITE])
  times = [1,2].map do |part|
    print "Output ##{part}\n".colorise([String::CM_BOLD, String::CF_BLUE])
    time = 0
    output = "  " + capture_stdout do
      time = Benchmark.realtime do
        load "./run#{part}.rb"
      rescue SystemExit
      end
    end.split(/\n/).join("\n  ") + "\n"
    print output.colorise([String::CF_GREEN])
    time * 1000
  end
  print "Benchmarks\n".colorise([String::CM_BOLD, String::CF_RED]) +
    "  #1: #{times[0]}ms\n  #2: #{times[1]}ms\n\n".colorise([String::CM_BOLD, String::CF_BROWN])
end
