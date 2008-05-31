class Style < ActiveRecord::Base
  def validate_on_create
    if Style.find_by_element_and_theme_and_user(element,theme,user)
      errors.add("This element is already defined for this theme for #{user}")
    end
  end
end
