require "yaml"
require "rails"

module CSVImporter
  @config = {
    file_loader: { loader: :file_system, path: "#{Rails.root}public/" },
    history_loader: { loader: :file, path: "tmp/csv_import_history" }
  }

  @valid_config_keys = %I[
    file_loader
    history_loader
  ]

  # Configure through hash
  def self.configure(options = {})
    options.each do |k,v|
      @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
    end

    @config
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end
end