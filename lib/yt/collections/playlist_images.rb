require 'yt/collections/resources'

module Yt
  module Collections
    class PlaylistImages < Resources

      def insert(attributes = {}, options = {})
        super attributes.merge(playlist_id: @parent.id), options
      rescue Yt::Error => error
        ignorable_errors = error.reasons & ['playlistNotFound', 'forbidden']
        raise error unless options[:ignore_errors] && ignorable_errors.any?
      end

      # @return [Hash] the parameters to submit to YouTube to list playlist items.
      # @see https://developers.google.com/youtube/v3/docs/playlistItems/list
      def list_params
        super.tap{|params| params[:params] = playlist_images_params}
      end

      def playlist_images_params
        resources_params.merge playlist_id: @parent.id
      end

      def insert_parts
        {snippet: {keys: [:playlist_id, :resource_id]}}
      end

      # For inserting a playlist image.
      # @see https://developers.google.com/youtube/v3/docs/playlistImages/insert
      def insert_params
        params = super
        params[:params] ||= {}
        params
      end
    end
  end
end
