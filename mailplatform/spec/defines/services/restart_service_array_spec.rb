# frozen_string_literal: true

require 'spec_helper'

describe 'mailplatform::services::restart_service_array' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'service_array' => ['httpd','dovecot'],
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
