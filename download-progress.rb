require 'net/http'
require 'uri'
 
def download(url)
  t = Thread.new do
    thread = Thread.current
    body = thread[:body] = []
    url = URI.parse url
    Net::HTTP.new(url.host, url.port).request_get(url.path) do |response|
      length = thread[:length] = response['Content-Length'].to_i
       
      response.read_body do |fragment|
        body << fragment
        thread[:done] = (thread[:done] || 0) + fragment.length
        thread[:progress] = thread[:done].quo(length) * 100
      end
    end
    yield body.join('') if block_given?
  end
  at_exit { t.join }
  t
end
 
if $0 == __FILE__
  downloader = download 'http://freebigpictures.com/wp-content/uploads/2009/09/winter-forest.jpg' do |content|
    File.write('picture.jpg', content)
  end
  puts "%.2f%%" % downloader[:progress].to_f until downloader.join 1
end

