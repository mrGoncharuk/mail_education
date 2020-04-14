# frozen_string_literal: true

require 'spec_helper'

describe 'mailplatform::install_package_array' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'package_array' => ['httpd','postfix'],
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
