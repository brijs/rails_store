class Product < ActiveRecord::Base
	attr_accessible :name, :price
	validates_presence_of :name, :price

# custom search 
def self.search(search, page = 1)
	paginate(per_page: 15,
			 page: page,
			 conditions: ['name LIKE ?', "%#{search}%"])
end

end
