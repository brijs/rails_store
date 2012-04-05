class Product < ActiveRecord::Base
	attr_accessible :name, :price
	validates_presence_of :name, :price

# custom search 
def self.search(search)
	if search
		find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
	else
		find(:all)
	end
end

end
