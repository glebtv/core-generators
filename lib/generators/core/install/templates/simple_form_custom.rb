module SimpleForm
  module Inputs
    
    class Base
      def label_html_options
        label_options = html_options_for(:label, [input_type, required_class, :label ])
        label_options[:for] = options[:input_html][:id] if options.key?(:input_html)
        label_options
      end
      def hint_html_options
        html_options_for(:hint, [:description, :hint])
      end
    end
    
    class StringInput < Base
      def input_html_classes
        classes = input_type == :string ? super : super.unshift("string")
        classes << :text_field
      end
    end
    
    class NumericInput < Base
      def input_html_classes
        super.unshift("text_field")
      end
    end
    
    class BooleanInput < Base
    end

    class DatePickerInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end
    end

    class DateTimePickerInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options) + "<span class='date_time_picker_button'>&nbsp;</span>".html_safe
      end
    end

    class SubdomainInput < Base
      def input
        "http://" + @builder.text_field(attribute_name, input_html_options) + ".#{domain}"
      end
      def domain
        input_options[:domain] || "hhh.com"
      end
    end
  end
end

module SimpleForm
  @@wrapper_class = :group
  @@components = [ :label, :error, :input, :hint ]
  @@wrapper_error_class = :error
end