require "test_helper"

class InterfaceTest < ActionDispatch::IntegrationTest

  def setup
    BlogPost.destroy_all
  end

  def teardown
    BlogPost.destroy_all
  end

  test "menu is rendering" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts")
    assert page.has_content?("Blog Posts")
    assert page.has_content?("Categories")
    assert page.has_content?("Administrators")
  end

  test "get the blog index and see empty slate" do
    sign_in_dummy_administrator!
    visit("/admin/blog_posts")
    assert page.has_content?("New Blog Post")
    assert page.has_content?("Blog Posts")
    assert page.has_content?("live here")
  end

  test "create a blog post, see it on the index, inspect it" do

    sign_in_dummy_administrator!
    visit("/admin/blog_posts")
    first(".button.-primary").click
    fill_in("blog_post[title]", with:"Neko Atsume")
    fill_in("blog_post[summary]", with:"Neko Atsume")
    fill_in("blog_post[body]", with:"Neko Atsume")
    first(".button.-primary").click

    assert page.current_path.include?(admin_blog_posts_path)
    assert page.has_content?("Neko Atsume")
    assert page.has_content?("created the"), "should see flash message"

    find_link("Neko Atsume").click

    assert page.current_path.include?(admin_blog_post_path(BlogPost.first.id))
    assert page.has_content?("Neko Atsume")

  end

  test "blog post fails validation and sees flash message" do

    sign_in_dummy_administrator!
    visit("/admin/blog_posts")
    first(".button.-primary").click
    fill_in "blog_post[title]", with:"Neko Atsume"
    first(".button.-primary").click

    assert page.has_content?("correct the following"), "should see flash message"

  end

end

