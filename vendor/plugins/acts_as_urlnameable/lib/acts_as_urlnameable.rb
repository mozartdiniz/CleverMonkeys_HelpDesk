module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Urlnameable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_urlnameable(attr_name, options = {})
          
          write_inheritable_attribute(:acts_as_urlnameable_options,
          { :type               => ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s,
            :attr               => attr_name,
            :mode               => (options[:mode] || :single),
            :overwrite          => (options[:overwrite] || false),
            :validate           => (options[:validate] || :class),
            :owner_association  => (options[:owner_association] || nil),
            :message    => (options[:message] || 'already exists') } )

          class_inheritable_reader :acts_as_urlnameable_options

          write_inheritable_attribute(:urlname_table, Urlname.table_name)
          class_inheritable_reader :urlname_table

          has_many    :urlnames, :as => :nameable, :order => 'id DESC', :dependent => :destroy
          after_save  :update_or_add_urlname
          validate    :validate_urlname unless acts_as_urlnameable_options[:validate] == false

          include ActiveRecord::Acts::Urlnameable::InstanceMethods
          extend ActiveRecord::Acts::Urlnameable::SingletonMethods
        end
        
      end

      module SingletonMethods
        def find_all_by_urlname(name)
          find_urlnames(name, :all)
        end
        
        def find_by_urlname(name)
          find_urlnames(name, :first)
        end
        
        def urlnames
          connection.select_values("SELECT name FROM #{urlname_table}
                                    WHERE #{urlname_table}.nameable_type = '#{acts_as_urlnameable_options[:type]}'")
        end
        
        private
        def find_urlnames(name, all_or_first)
          find( all_or_first,
                :select => "#{table_name}.*",
                :joins => "JOIN #{urlname_table} ON #{table_name}.#{primary_key} = #{urlname_table}.nameable_id",
                :conditions =>
                ["#{urlname_table}.nameable_type = '#{acts_as_urlnameable_options[:type]}'
                  AND #{urlname_table}.name = ?", name],
                :readonly => false)
        end
      end
      
      module InstanceMethods
        def urlname
          urlnames.first ? urlnames.first.name : nil
        end
        
        def past_urlnames
          (urlnames.size <= 1) ? [] : (urlnames - [urlnames.first]).collect { |u| u.name }
        end
        
        def all_urlnames
          urlnames.collect { |u| u.name }
        end
        
        def urlnameify(text)
          t = text.to_s.downcase.strip.gsub(/[^-_\s[:alnum:]]/, '').squeeze(' ').tr(' ', '_')
          (t.blank?) ? '_' : t
        end
        
        private
        def attr_to_urlname
          urlnameify(send(acts_as_urlnameable_options[:attr]))
        end
        
        def update_or_add_urlname
          recent_name = (urlnames.first || urlnames.build)
          urlname_string = attr_to_urlname

          case acts_as_urlnameable_options[:mode]
          when :single
            if acts_as_urlnameable_options[:overwrite]
              recent_name.name = urlname_string
            else
              recent_name.name = urlname_string if recent_name.new_record?
            end
          when :multiple
            if recent_name.new_record? && !past_urlnames.include?(urlname_string)
              recent_name.name = urlname_string
            elsif !recent_name.new_record? && !past_urlnames.include?(urlname_string)
              unless recent_name.name == urlname_string
                recent_name = urlnames.build(:name => urlname_string) 
                # Because it ends up at the end of the association when it should be at the start
                urlnames.unshift(urlnames.pop)
              end
            end
          end

          recent_name.save
        end
        
        def validate_urlname
          case acts_as_urlnameable_options[:validate]
          when :class, :sti_class
            validate_urlname_against_class
          else
            validate_urlname_against_owner
          end
        end
                
        def validate_urlname_against_class
          urlname_string = attr_to_urlname

          if past_urlnames.include? urlname_string
            return true
          else
            finder_class = 
              (acts_as_urlnameable_options[:validate] == :sti_class) ? self.class : acts_as_urlnameable_options[:type].constantize
            
            existing_urlname = finder_class.find_by_urlname(urlname_string)
            
            if existing_urlname == self || existing_urlname.nil?
              return true
            else
              errors.add(:urlname, acts_as_urlnameable_options[:message])
            end                             
          end
        end
        
        def validate_urlname_against_owner
          owner_reflection = self.class.reflect_on_association(acts_as_urlnameable_options[:validate])
          unless owner_reflection && owner_reflection.macro == :belongs_to
            raise ArgumentError, "You can only validate against the class as a whole, or a belongs_to association."
          end

          unless child_reflection = owner_reflection.klass.reflect_on_association(acts_as_urlnameable_options[:owner_association] || self.class.to_s.tableize.to_sym)
            raise ArgumentError, "Couldn't figure out owner association via reflection"
          end

          if obj = send(owner_reflection.name).send(child_reflection.name).find_by_urlname(attr_to_urlname)
            errors.add(:urlname, acts_as_urlnameable_options[:message]) unless obj == self || obj.nil?
          else
            return true
          end
        end
        
      end
      
    end
  end
end
