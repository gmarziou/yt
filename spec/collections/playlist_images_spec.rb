require 'spec_helper'
require 'yt/models/playlist'
require 'yt/models/playlist_image'
require 'yt/collections/playlist_images'

describe Yt::Collections::PlaylistImages do
  subject(:collection) { Yt::Collections::PlaylistImages.new parent: playlist }
  let(:playlist) { Yt::Playlist.new id: 'LLxO1tY8h1AhOz0T4ENwmpow' }
  let(:attrs) { {id: '9bZkp7q19f0', kind: :video} }
  let(:msg) { {response_body: {error: {errors: [{reason: reason}]}}}.to_json }
  before { expect(collection).to behave }

  describe '#insert' do
    let(:playlist_image) { Yt::PlaylistImage.new }

    context 'given an existing playlist' do
      let(:behave) { receive(:do_insert).and_return playlist_image }

      it { expect(collection.insert attrs).to eq playlist_image }
    end

    context 'given an unknown playlist' do
      let(:reason) { 'playlistNotFound' }
      let(:behave) { receive(:do_insert).and_raise Yt::Error, msg }

      it { expect{collection.insert attrs}.to fail.with 'playlistNotFound' }
      it { expect{collection.insert attrs, ignore_errors: true}.not_to fail }
    end

    context 'given a forbidden playlist' do
      let(:reason) { 'forbidden' }
      let(:behave) { receive(:do_insert).and_raise Yt::Error, msg }

      it { expect{collection.insert attrs}.to fail.with 'forbidden' }
      it { expect{collection.insert attrs, ignore_errors: true}.not_to fail }
    end
  end

end