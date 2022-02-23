module ApplicationHelper

  def full_title(page_title = '') # Method def, optional argument
  base_title = "The Little Esty Shop" # variable assignment
  if page_title.empty? # Boolean test
    base_title# implicit return
  else
    page_title + " | " + base_title # string concatenation
  end
end

end
