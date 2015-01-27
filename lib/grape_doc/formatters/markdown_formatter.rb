module GrapeDoc
  class MarkdownFormatter 
    def generate_resource_doc(resource)
      title = "### #{resource.resource_name}\n"
      
      documents = resource.documents.map do |document|
        path = "#### #{document.http_method} #{document.path}\n\n"
        description = "#{document.description}\n\n"

        response =
            if document.description.split("::")[1]
              eval(document.description.split("::")[1]).map do |parameter|

                param = " - #{parameter[0]}"
                param += " (#{parameter[1][:type]})" if parameter[1][:type]
                param += " : #{parameter[1][:desc]}" if parameter[1][:desc]

              end.join if document.description.split("::")[1]
            else
              []
            end
        
        parameters = document.params.map do |parameter| 
          next if parameter.field.nil? or parameter.field.empty?
          param = " - #{parameter.field}"
          param += " (#{parameter.field_type})" if parameter.field_type
          param += " (*required*)" if parameter.required
          param += " : #{parameter.description} " if parameter.description
          param += " Example: #{parameter.sample_value}" if parameter.sample_value
          param += "\n\n"
        end.join if document.params
        
        route = "#{path} #{description}"
        route += "**Parameters:** \n\n\n#{parameters}" if parameters
        route += "\n\n"
        route += "**Response:** \n\n\n#{response}" if response
        route += "\n\n"

      end.join
      return "" if documents.nil? or documents.empty?
      "#{title}\n\n\n#{documents}\n"
    end
  end
end
