require File.dirname(__FILE__) + '/test_helper'

class ActsAsUrlnameableTest < Test::Unit::TestCase
  fixtures :articles, :pages, :people, :sections, :urlnames

  def test_urlname_reader_methods
    assert_equal 'first_test_article_edit', articles(:first).urlname

    assert_nil articles(:sixth).urlname
    
    assert_equal 'seventh_test_article', articles(:seventh).urlname
    
    assert_equal 'joe_smith', people(:first).urlname
    
    assert_equal 'jane_bloggs', people(:second).urlname
    
    assert_equal 2, articles(:first).past_urlnames.size
    
    assert articles(:first).past_urlnames.find { |u| u == 'first_test_article' }
    
    assert_nil articles(:third).past_urlnames.find { |u| u == 'third_test_article' }

    assert 0, people(:first).past_urlnames.size
    
    assert 1, people(:second).past_urlnames.size    
    
    assert 2, people(:second).all_urlnames.size    
  end
  
  def test_urlname_association   
    assert_equal 3, articles(:first).urlnames.size 
    
    assert_equal 2, articles(:third).urlnames.size 
    
    assert_equal 1, people(:first).urlnames.size
    
    assert_equal 3, people(:second).urlnames.size
  end
  
  def test_urlnames_class_method
    assert_equal Urlname.find_all_by_nameable_type('Article').size, Article.urlnames.size
    
    assert_equal Urlname.find_all_by_nameable_type('Person').size, Person.urlnames.size
  end
  
  def test_class_finder_methods
    assert_equal articles(:first), Article.find_by_urlname('first_test_article_edit')
    
    assert_equal articles(:third), Article.find_by_urlname('old_third_test_title')
    
    assert_nil Article.find_by_urlname('blah blah non existent')
    
    assert_equal 2, Page.find_all_by_urlname('test_for_multiple_finder').size

  end
  
  def test_finder_methods_with_association
    person_one, person_two = people(:first), people(:second)
    
    assert_nil person_one.articles.find_by_urlname('blah blah non existent')
    
    assert_equal articles(:first), person_one.articles.find_by_urlname('first_test_article_edit')
    
    assert_equal articles(:first), person_one.articles.find_by_urlname('first_test_article')
    
    assert_equal articles(:fourth), person_two.articles.find_by_urlname('fourth_test_article')
    
    assert_nil person_one.articles.find_by_urlname('fourth_test_article')
    
    assert_nil person_two.articles.find_by_urlname('first_test_article_edit')
  end

  def test_urlname_single_saving_without_overwrite
    page = Page.new(:title => 'Testing New Urlnames - Test', 
                    :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
    page.save
    
    assert_equal page, Page.find_by_urlname('testing_new_urlnames_-_test')
    
    page.title = 'This is another test of the urlname saving'
    
    page.save

    assert_equal page, Page.find_by_urlname('testing_new_urlnames_-_test')
    
    assert_nil Page.find_by_urlname('this_is_another_test_of_the_urlname_saving')
  end

  def test_urlname_single_saving_with_overwrite
    section = Section.new(:name => 'Testing Section')
    
    section.save
    
    assert_equal section, Section.find_by_urlname('testing_section')
    
    section.name = 'Renamed this section'
    
    section.save
    
    assert_nil Section.find_by_urlname('testing_section')
    
    assert_equal section, Section.find_by_urlname('renamed_this_section')
  end

  def test_urlname_multiple_saving
    article = Article.new(:title => 'Testing New Urlnames - Test Article', 
                          :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
    article.save

    assert_equal article, Article.find_by_urlname('testing_new_urlnames_-_test_article')
    
    assert_equal article.urlname, 'testing_new_urlnames_-_test_article'
    
    article.title = 'This is another test of the urlname saving - article'
    
    article.save
    
    assert_equal article.urlname, 'this_is_another_test_of_the_urlname_saving_-_article'

    assert_equal article, Article.find_by_urlname('this_is_another_test_of_the_urlname_saving_-_article')
        
    assert_equal article, Article.find_by_urlname('testing_new_urlnames_-_test_article')
  end
  
  def test_validations_against_class
    article = Article.new(:title => 'Ninth Test Article', 
                          :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
                          
    assert !article.save
    
    assert_equal 'already exists', article.errors[:urlname]
    
    article = articles(:ninth)
    
    assert article.save
  end

  def test_validations_against_owner
    page = sections(:ruby).pages.build(:title => 'a test page about rails specifically')
    
    assert !page.save
    
    assert_equal 'already exists', page.errors[:urlname]

    Page.send(:acts_as_urlnameable, :title, :validate => :section)

    page = sections(:ruby).pages.build(:title => 'a test page about rails specifically')

    assert page.save
    
    page = sections(:rails).pages.build(:title => 'a test page about rails specifically')
    
    assert !page.save
  end

  def test_with_single_table_inheritance
    press_release = PressRelease.new( :title => 'testing single table inheritance',
                                      :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
                                      
    assert press_release.save
    
    assert_equal press_release, Article.find_by_urlname('testing_single_table_inheritance')
    
    assert_nil PressRelease.find_by_urlname('first_test_article_edit')
    
    assert_not_nil Article.find_by_urlname('first_test_article_edit')

    press_release = PressRelease.new( :title => 'first test article edit',
                                      :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
                                      
    assert !press_release.save
    
    PressRelease.send(:acts_as_urlnameable, :title, :mode => :multiple, :validate => :sti_class)
    
    assert press_release.save

    assert_equal 1, PressRelease.find_all_by_urlname('first_test_article_edit').size
    assert_equal 2, Article.find_all_by_urlname('first_test_article_edit').size
  end

  def test_bad_reflection
    bad_page = BadPage.new( :title => 'Testing bad association validation', 
                            :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
    
    assert_raise(ArgumentError) { bad_page.save }
    
    badder_page = BadderPage.new( :title => "Testing bad association validation - can't reflect the has_many or has_one association", 
                                  :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
                                  
    assert_raise(ArgumentError) { badder_page.save }
  end

  def test_custom_owner_association
    article = people(:first).custom_articles.build( :title => 'Testing custom association validation', 
                                                    :body => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin adipiscing mi ac neque.')
                                                    
    assert article.save
    
    assert_not_nil SpecialArticle.find_by_urlname('testing_custom_association_validation')
    
    article = people(:first).custom_articles.build( :title => 'Testing custom association validation', 
                                                    :body => 'This urlname should already exist now')
    
    assert !article.save

    assert_equal 'already exists', article.errors[:urlname]
  end

  def test_finder_scoping
    assert_equal 2, Page.find_all_by_urlname('test_for_multiple_finder').size
    
    Page.with_scope(:find => { :conditions => ['section_id = ?', 2] }) do
      assert_equal 1, Page.find_all_by_urlname('test_for_multiple_finder').size
    end 
  end

  def test_custom_validator
    person = PersonWithCustomValidation.new(:full_name => 'Hobo Joe')
    
    assert !person.save
    
    assert_equal "is invalid. You've got it all wrong! I'm not a name, I AM a number!", person.errors[:urlname]
  end
  
  def test_custom_urlnameify
    writer = Writer.new(:full_name => 'candy', :password => 'password')
    
    assert writer.save
    
    assert_not_nil Writer.find_by_urlname('writer_candy')
  end
  
end
