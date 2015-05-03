require 'bundler/setup'
require 'open-uri'
require 'base64'
require 'public_suffix'

gfwlist_url = 'https://autoproxy-gfwlist.googlecode.com/svn/trunk/gfwlist.txt'
extra_domains = [
  "blogspot.com",
  "fastly.net",
  "githubusercontent.com",
  "google-analytics.com",
  "google.co.hk",
  "google.co.jp",
  "google.com",
  "google.com.hk",
  "googlesyndication.com",
  "s3.amazonaws.com",
]

def get_hostname(rule)
  begin
    host = URI.parse(rule).host
    if PublicSuffix.valid?(host)
      return PublicSuffix.parse(host).domain
    elsif PublicSuffix.valid?('.' + host)
      tld = PublicSuffix.parse('.' + host).tld
      if tld.include?('.') and tld == host
        return tld
      end
    else
      puts 'Hostname not valid: ' + host
    end
    return nil
  rescue
    puts 'can not parse rule as url: ' + rule
    return nil
  end
end

enc = open(gfwlist_url).read
plain = Base64.decode64(enc)

domains = []
plain.each_line do |line|
  if line.include? '.*'
    next
  elsif line.include? '*'
    line = line.gsub('*', '/')
  end
  if line.start_with? '||'
    line = line.sub('||', '')
  elsif line.start_with? '|'
    line = line.sub('|', '')
  elsif line.start_with? '.'
    line = line.sub('.', '')
  end
  if line.start_with? '!' or line.start_with? '[' or line.start_with? '@'
    next
  end
  line.chomp!
  if line.length > 0
    if not line.start_with? 'http'
      line = 'http://' + line
    end
    hostname = get_hostname(line)
    if hostname
      domains.push(hostname)
    end
  end
end

output_file = File.new('gfwlist.conf', 'w+')
domains.concat extra_domains
domains.sort!.uniq!.each { |domain| output_file.puts('ipset=/' + domain + '/outwall') }
output_file.close
