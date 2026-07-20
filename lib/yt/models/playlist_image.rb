require 'yt/models/resource'

module Yt
  module Models
    # Provides methods to interact with YouTube playlist images.
    # @see https://developers.google.com/youtube/v3/docs/playlistImages
    class PlaylistImage < Resource

    ### SNIPPET ###

      # @!attribute [r] type
      #   @return [String] the image type.
      delegate :type, to: :snippet

      # @!attribute [r] width
      #   @return [Integer] the image width.
      delegate :width, to: :snippet

      # @!attribute [r] height
      #   @return [Integer] the image height.
      delegate :height, to: :snippet

      # @!attribute [r] playlist_id
      #   @return [String] the ID of the playlist that the image belongs to.
      delegate :playlist_id, to: :snippet

      # @return [String] the ID of the playlist referred by the item.
      def playlist_id
        snippet.resource_id['playlistId']
      end

    ### ACTIONS (UPLOAD, UPDATE, DELETE) ###

      # Deletes the playlist item.
      # @return [Boolean] whether the playlist item does not exist anymore.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to delete the item.
      def delete(options = {})
        do_delete {@id = nil}
        !exists?
      end

      # Updates the attributes of a playlist item.
      # @return [Boolean] whether the item was successfully updated.
      # @raise [Yt::Errors::Unauthorized] if {Resource#auth auth} is not an
      #   authenticated Yt::Account with permissions to update the item.
      # @param [Hash] attributes the attributes to update.
      # @option attributes [Integer] the order in which the item should appear
      #   in a playlist. The value is zero-based, so the first position of 0.
      def update(attributes = {})
        super
      end

    ### ASSOCIATIONS ###

      # @return [Yt::Models::Playlist] the playlist referred by the image.
      def playlist
        playlist ||= Playlist.new id: playlist_id, auth: @auth if playlist_id
      end

    ### PRIVATE API ###

      # @private
      def exists?
        !@id.nil?
      end

      # @private
      # Override Resource's new to set playlist if the response includes it
      def initialize(options = {})
        super options
        @playlist = options[:playlist] if options[:playlist]
      end

    private

      def resource_id
        {kind: 'youtube#playlist', playlistId: playlist_id}
      end

      def delete_params
        super.tap do |params|
          params[:params] ||= {}
          params[:params].merge! @auth.playlist_images_params
        end
      end

      # @see https://developers.google.com/youtube/v3/docs/playlistImages/update
      def update_parts
        keys = [:playlist_id, :resource_id]
        snippet = {keys: keys, required: true}
        {snippet: snippet}
      end
    end
  end
end
