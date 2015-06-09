class BlogPost < ActiveRecord::Base

  has_and_belongs_to_many :categories, join_table:"blog_post_categories"

  validates_presence_of :title
  validates_presence_of :summary
  validates_presence_of :published_at
  validates_presence_of :body

  manage_with_tolaria using: {
    icon: :file_o,
    priority: 1,
    default_order: "id DESC",
    category: "Syndication",
    paginated: true,
    permit_params: [
      :title,
      :summary,
      :body,
      :published_at,
      :color,
      :portrait,
      :attachment,
      category_ids: []
    ],
  }

  after_initialize :initalize_published_at!
  def initalize_published_at!
    self.published_at ||= Time.current
  rescue ActiveModel::MissingAttributeError
    # Swallow this exception
  end

end
