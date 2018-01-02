require 'minitest/autorun'

class XmlBuilder
  def initialize
    @render_xml_tag = false
    @namespaces = {}
    @content = ''
    @prefix = ''
  end

  def render_xml_tag!
    @render_xml_tag = true
    self
  end

  def register_namespace(namespaces)
    @namespaces = namespaces
    self
  end

  def namespace(prefix)
    @prefix = prefix
    self
  end

  def method_missing(tagname, attrs={})
    if @prefix != ''
      tagname = "#{@prefix}:#{tagname}"
    end
    @prefix = ''

    @content << open_tag(tagname, attrs)
    yield self if block_given?
    @content << close_tag(tagname)
    self
  end

  def to_s
    if @render_xml_tag 
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>#{@content}"
    else
      @content
    end
  end

  private

  def open_tag(tagname, attrs)
    props = []
    @namespaces.each do |name, value|
      props.push("xmlns:#{name}=\"#{value}\"")
    end
    @namespaces = {}
    attrs.each do |name, value|
      props.push("#{name}=\"#{value}\"")
    end
    if props.length != 0
      "<#{tagname} #{props.join(' ')}>"
    else
      "<#{tagname}>"
    end
  end

  def close_tag(tagname)
    "</#{tagname}>"
  end

end

describe XmlBuilder do
  it 'can register namespace' do
    x = XmlBuilder.new
    x.register_namespace(:h => 'http://www.w3.org/TR/html4').root
    x.to_s.must_equal  '<root xmlns:h="http://www.w3.org/TR/html4"></root>'
  end

  it 'can have attributes' do
    XmlBuilder.new.root(:foo => "123").to_s.must_equal '<root foo="123"></root>'
  end

  it 'can have nested nodes' do
    XmlBuilder.new.register_namespace(:x => "html5").root(:foo => "123") do |builder| 
      builder.bar(:foo => "567") do |builder|
        builder.foo(:bar => "333")
      end
    end.to_s.must_equal '<root xmlns:x="html5" foo="123"><bar foo="567"><foo bar="333"></foo></bar></root>'
  end

  it 'can have namespaces' do
    XmlBuilder.new.register_namespace(:x => "html5").root(:foo => "123") do |builder| 
      builder.namespace(:f).bar(:foo => "567") do |builder|
        builder.namespace(:x).foo(:bar => "333")
      end
    end.to_s.must_equal '<root xmlns:x="html5" foo="123"><f:bar foo="567"><x:foo bar="333"></x:foo></f:bar></root>'
  end

  it 'can render xml tag' do
    XmlBuilder.new.render_xml_tag!.register_namespace(:x => "html5").root(:foo => "123") do |builder| 
      builder.namespace(:f).bar(:foo => "567") do |builder|
        builder.namespace(:x).foo(:bar => "333")
      end
    end.to_s.must_equal '<?xml version="1.0" encoding="utf-8"?><root xmlns:x="html5" foo="123"><f:bar foo="567"><x:foo bar="333"></x:foo></f:bar></root>'
  end
end
