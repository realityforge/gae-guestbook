class SimpleLayout < Layout::Default
  def initialize
    super()
    self[:target, :generated] = "generated"
  end
end

def define_with_central_layout(name, options = { }, &block)
  options = options.dup
  options[:layout] = SimpleLayout.new
  options[:base_dir] = "#{name}"

  define(name, options) do
    project.instance_eval &block
    project.clean { rm_rf _(:target, :generated) }
    project
  end
end

desc "GAE Guestbook: Sample GAE application"
define 'gae-guestbook' do
  project.version = '1.0-SNAPSHOT'
  project.group = 'org.realityforge.gae.guestbook'

  compile.options.source = '1.6'
  compile.options.target = '1.6'
  compile.options.lint = 'all'

  iml.add_web_facet

  compile.with :javax_servlet

  package(:war)

  # Remove the IDEA generated artifacts
  project.clean { rm_rf project._(:artifacts) }

  doc.using :javadoc, { :tree => false, :since => false, :deprecated => false, :index => false, :help => false }

  ipr.add_exploded_war_artifact(project, :name => 'gae-guestbook')
  iml.add_jruby_facet
end
