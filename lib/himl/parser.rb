# frozen_string_literal: true

require 'nokogiri'

module Himl
  class Parser
    class Document < Nokogiri::XML::SAX::Document
      Tag = Struct.new(:name, :indentation) do
        def end_tag
          "#{' ' * indentation}</#{name}>\n"
        end
      end

      ROOT_NODE = 'THE_HIML_ROOT_NODE'
      ERB_TAG = 'HIML_ERB_TAG'
      ERB_TAG_REGEXP = /<%(?:=|==|-|#|%)?(.*?)(?:[-=])?%>/

      attr_accessor :context

      def initialize(template)
        @original_template, @tags, @end_tags = template, [], []
        template = template.gsub(ERB_TAG_REGEXP, "<#{ERB_TAG}>\\1</#{ERB_TAG}>")
        @lines = "<#{ROOT_NODE}>\n#{template}</#{ROOT_NODE}>\n".lines
      end

      def template
        @lines.join
      end

      def erb_template
        lines = @original_template.lines

        @end_tags.reverse_each do |index, tag|
          lines.insert index - 1, tag
        end

        lines.join
      end

      def start_element(name, *)
        close_tags unless name == ROOT_NODE

        @tags << Tag.new(name, current_indentation)
      end

      def end_element(name)
        return if @tags.last.name == ROOT_NODE

        @tags.pop if name == @tags.last.name
      end

      def close_tags
        while (@tags.last.name != ROOT_NODE) && (current_indentation <= @tags.last.indentation)
          @end_tags << [current_line, @tags.last.end_tag]
          @tags.pop
        end
      end

      def verify!
        raise SyntaxError if @tags.last.name != ROOT_NODE
      end

      private

      def current_indentation
        line = @lines[current_line]
        line.slice(0, context.column).rindex('<')
      end

      def current_line
        (context.column == 1) && (context.line > 1) ? context.line - 2 : context.line - 1
      end
    end

    def call(template)
      parse_template template
    end

    def to_html
      @document.erb_template
    end

    private

    def parse_template(template)
      @document = Document.new template
      @parser = Nokogiri::XML::SAX::Parser.new(@document)
      @parser.parse @document.template do |ctx|
        @document.context = ctx
      end

      @document.close_tags

      @document.verify!
    end
  end
end
