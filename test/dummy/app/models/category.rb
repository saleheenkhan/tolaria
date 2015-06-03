class Category < ActiveRecord::Base

  has_and_belongs_to_many :blog_posts, join_table:"blog_post_categories"

  validates_presence_of :label
  validates_presence_of :slug

  manage_with_tolaria using:{
    icon: :leaf,
    category: "Syndication",
    permit_params: [
      :label,
      :slug,
    ],
  }

end
