require "test_helper"

class MenuTest < ActiveSupport::TestCase

  test "categories from the demo application returned correctly" do
    assert_equal ["Prose", "Media", "Settings"], Tolaria.categories
  end

  test "menu categories supersede class categories" do
    old_setting = Tolaria.config.menu_categories
    Tolaria.config.menu_categories = ["Bull", "Krem"]
    assert_equal ["Bull", "Krem", "Settings", "Prose", "Media"], Tolaria.categories
    Tolaria.config.menu_categories = old_setting
  end

  test "class categories get added to the menu" do

    class ::Card < ActiveRecord::Base
      manage_with_tolaria using:{
        category: "Payments",
      }
    end

    assert_equal ["Prose", "Media", "Settings", "Payments"], Tolaria.categories

    # Unseat the Card class so that it doesn't leak out of this test
    Tolaria.discard_managed_class(Card)
    Object.send(:remove_const, :Card)

  end

end
