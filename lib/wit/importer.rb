require "wit/importer/version"

require 'pathname'
require 'json'
require 'net/http'

module Wit
  class Importer

    API_VERSION = '20170307'
    API_URL = 'https://api.wit.ai/'


    def self.import(key, path)
      self.new(key, path).perform!
    end

    def initialize(key, path)
      @key = key
      @path = Pathname.new(path)
      @entities = {}
      @expressions = []
    end

    def perform!
      puts "Loading entities\n"
      load_entities(@path.join('entities'))
      puts "Uploading entities\n"
      submit_entities

      puts "Loading expressions\n"
      load_expressions(@path)
      puts "Uploading expressions\n"
      submit_expressions
      puts "Done"
    end

    private

    def load_entities(dir_path)
      Dir[dir_path.join('**')].each do |file|
        load_entity file
      end
    end

    def load_entity(file_path)
      data = JSON.parse(File.read(file_path))
      is_keyword = data['data']['lookups'].include?('keywords')
      post_data = data['data'].select { |k, _| ['name', 'doc'].include?(k) }
      values = data['data']['values'] || []
      name = data['data']['name']
      builtin = data['data']['builtin']

      @entities[name] =  {
          name: name,
          builtin: builtin,
          values: values,
          post_data: post_data,
          is_keyword: is_keyword
      }
    end

    def submit_entities
      @entities.each do |k, data|
        if !data[:builtin]

          # Create entity
          create_entity(data[:post_data])

          if data[:is_keyword]
            data[:values].each do |value|
              add_value(data[:name], value)
            end
          end

        end
      end
    end

    def load_expressions(path)
      data = JSON.parse(File.read(path.join('expressions.json')))['data']

      data.each do |expression|
        (expression['entities'] || []).each do |entity|

          if @entities[entity['entity']][:builtin]
            entity['entity'] = 'wit$' + entity['entity']
          end

        end
      end

      @expressions = data
    end

    def submit_expressions
      uri = URI.parse(build_uri('samples'))
      https, req = create_post(uri)
      req.body = @expressions.to_json

      res = https.request(req)
      if res.code == '200'
        true
      else
        raise res.body
      end
    end

    def create_entity(data)
      uri = URI.parse(build_uri('entities'))
      https, req = create_post(uri)
      req.body = data.to_json

      res = https.request(req)
      if (res.code == '409' && res.body =~ /Entity with the same id already present/) ||
          res.code == '200'
        true
      else
        raise res.body
      end
    end

    def add_value(name, value)
      uri = URI.parse(build_uri("entities/#{name}/values"))
      https, req = create_post(uri)
      req.body = value.to_json

      res = https.request(req)
      if (res.code == '409' && res.body =~ /A value already exists with this name/) ||
          res.code == '200'
        true
      else
        raise res.body
      end
    end

    def create_post(uri)
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true

      req = Net::HTTP::Post.new(uri.path, {
          'Content-Type' =>'application/json',
          'Authorization' => "Bearer #{@key}"
      })

      [https, req]
    end

    def build_uri(endpoint)
      API_URL + endpoint + '?v=' + API_VERSION
    end


  end
end
