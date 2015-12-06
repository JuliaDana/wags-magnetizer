require_relative 'magnet.rb'
require "pp"

class MagnetTranslator
  MAGNET_SEPARATOR = "\n.:|:.\n"
  PANEL_STRING = " <br><!-- panel --><br> "

  def translate_to_wags_magnets magnets
    magnetsAsStrings = []
    magnets.each do |m|
      m.coalesce
      # pp m
      magnetsAsStrings << ""
      m.contents.each do |c|
        magnetsAsStrings.last.concat case c
        when MagnetDropZone
          PANEL_STRING
        when MagnetText
          CGI.escapeHTML(c.text).strip
        else
            raise "Unsupported magnet type #{m.class}"
         end
       end
    end

    magnetsAsStrings.join(MAGNET_SEPARATOR)
  end
  
  def translate_statements_to_wags_magnets magnets
    pp magnets
    magnetsAsStrings = []

    magnets.each do |m|
      magnetsAsStrings << ""
      
      m.contents.each do |c|
        magnetsAsStrings.last.concat case c
        when MagnetDropZone
          PANEL_STRING
        when MagnetText
          CGI.escapeHTML(c.text)
        else
            raise "Unsupported magnet type #{m.class}"
        end
      end
    end

    magnetsAsStrings.join(MAGNET_SEPARATOR)

  end

  def statementMagnetsToString statementMagnetArray
    return statementMagnetArray.map {|m|  
        escaped = CGI.escapeHTML(m)
        escapedPanel = Regexp.new(Regexp.quote(CGI.escapeHTML(PANEL_STRING)))
        escaped.gsub(escapedPanel, PANEL_STRING)
      }.join(MAGNET_SEPARATOR)
  end

  def outputMagnetsToString magnetArray
    return magnetArray.map {|ma| ma.map {|m|  m == PANEL_STRING ? m : CGI.escapeHTML(m)}; ma.join(" ")}.join(MAGNET_SEPARATOR)
  end
end
