# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add vendor paths
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets')

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w( ckeditor/*)


# Precompile libs
lib_files = Dir[Rails.root.join('vendor', 'assets', 'libs', '**', '[^_]*.*')]
lib_files.map! { |file| file.sub(%r(#{Rails.root.join('vendor', 'assets/')}), '') }
lib_files.map! { |file| file.sub(%r(\.(scss)), '.css') }
Rails.application.config.assets.precompile += lib_files



Rails.application.config.assets.precompile += Dir[Rails.root.join('app', 'assets', 'javascripts', '*.js')].map {
    |file| file.sub(%r(#{Rails.root.join('app', 'assets', 'javascripts/')}), '')
}
Rails.application.config.assets.precompile += Dir[Rails.root.join('app', 'assets', 'stylesheets', '*.css')].map {
    |file| file.sub(%r(#{Rails.root.join('app', 'assets', 'stylesheets/')}), '')
}

# Precompile core javascripts
Rails.application.config.assets.precompile += ['javascripts/*.js']

# Precompile fonts
Rails.application.config.assets.precompile += ['fonts/*']

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
