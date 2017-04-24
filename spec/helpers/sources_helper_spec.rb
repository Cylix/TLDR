require 'rails_helper'

include SourcesHelper

RSpec.feature "SourcesHelper", type: :feature do

  describe 'allowed_source_types_for_select' do

    it 'should return valid text' do
      expect(allowed_source_types_for_select).to eq Source.descendants.collect { |s| [printable_source_type(s.to_s), s.to_s] }
    end

    it 'should not be empty' do
      expect(allowed_source_types_for_select.presence).to be_truthy
    end

  end

  describe 'colorized_synchronization_state' do

    it 'should return the right class' do
      { never: 'muted', in_progress: 'warning', success: 'success', fail: 'danger' }. each do |k, v|
        expect(SourcesHelper::colorized_synchronization_state k).to eq "text-#{v}"
      end
    end

  end

  describe 'iconable_source_type' do

    it 'should return the right fa class' do
      { 'Source::RSS' => {icon:'rss',color:'warning'}, 'Source::Youtube' => {icon:'youtube',color:'danger'}, 'Source::Facebook' => {icon:'facebook',color:'info'}, 'Source::Twitter' => {icon:'twitter',color:'info'} }.each do |k, v|
        expect(SourcesHelper::iconable_source_type k).to match /fa-#{v[:icon]} text-#{v[:color]}/
      end
    end

  end

  describe 'iconable_synchronization_state' do

    it 'should return the right class' do
      { never: 'question-circle', in_progress: 'clock-o', success: 'check', fail: 'exclamation-triangle' }. each do |k, v|
        expect(SourcesHelper::iconable_synchronization_state k).to eq "fa-#{v}"
      end
    end

  end

  describe 'printable_source_type' do

    it 'should return a valid string' do
      ['Source::RSS', 'Source::Youtube', 'Source::Facebook', 'Source::Twitter'].each do |type|
        expect(SourcesHelper::printable_source_type(type).presence).to be_truthy
      end
    end

    it 'should not miss a translation' do
      ['Source::RSS', 'Source::Youtube', 'Source::Facebook', 'Source::Twitter'].each do |type|
        expect(SourcesHelper::printable_source_type(type).presence).not_to match /Missing translation/
      end
    end

  end

  describe 'printable_synchronization_state' do

    it 'should return a valid string' do
      ['never', 'in_progress', 'success', 'fail'].each do |state|
        expect(SourcesHelper::printable_synchronization_state(state).presence).to be_truthy
      end
    end

    it 'should not miss a translation' do
      ['never', 'in_progress', 'success', 'fail'].each do |state|
        expect(SourcesHelper::printable_synchronization_state(state).presence).not_to match /Missing translation/
      end
    end

    describe 'uncolorized_iconable_source_type' do

      it 'should return the right fa class' do
        { 'Source::RSS' => 'rss', 'Source::Youtube' => 'youtube', 'Source::Facebook' => 'facebook', 'Source::Twitter' => 'twitter' }.each do |k, v|
          expect(SourcesHelper::uncolorized_iconable_source_type k).to eq "fa-#{v}"
        end
      end

    end

  end

end
