actions :create, :remove

attribute :name, :kind_of => String, :name_attribute => true
attribute :servername, :kind_of => String
attribute :serveraliases, :kind_of => Array, :default => []
attribute :user, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
