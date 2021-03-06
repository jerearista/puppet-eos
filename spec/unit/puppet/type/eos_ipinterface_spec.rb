#
# Copyright (c) 2014, Arista Networks, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#  Redistributions of source code must retain the above copyright notice,
#  this list of conditions and the following disclaimer.
#
#  Redistributions in binary form must reproduce the above copyright
#  notice, this list of conditions and the following disclaimer in the
#  documentation and/or other materials provided with the distribution.
#
#  Neither the name of Arista Networks nor the names of its
#  contributors may be used to endorse or promote products derived from
#  this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ARISTA NETWORKS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# encoding: utf-8

require 'spec_helper'

describe Puppet::Type.type(:eos_ipinterface) do
  let(:catalog) { Puppet::Resource::Catalog.new }
  let(:type) { described_class.new(name: 'Ethernet12', catalog: catalog) }

  it_behaves_like 'an ensurable type', name: 'Ethernet12'

  describe 'name' do
    let(:attribute) { :name }
    subject { described_class.attrclass(attribute) }

    include_examples 'parameter'
    include_examples '#doc Documentation'
  end

  describe 'address' do
    let(:attribute) { :address }
    subject { described_class.attrclass(attribute) }

    include_examples 'property'
    include_examples '#doc Documentation'
    include_examples 'accepts values without munging',
                     %w(0.0.0.0 255.255.255.255)
    include_examples 'rejects values', [[1], { two: :three }]
  end

  describe 'helper_addresses' do
    let(:attribute) { :helper_addresses }
    subject { described_class.attrclass(attribute) }

    include_examples 'property'
    include_examples '#doc Documentation'
    include_examples 'accepts values without munging', [['1.1.1.1', '2.2.2.2']]
  end

  describe 'mtu' do
    let(:attribute) { :mtu }
    subject { described_class.attrclass(attribute) }

    include_examples 'property'
    include_examples '#doc Documentation'

    [100, '100'].each do |val|
      it "validates #{val.inspect} as isomorphic to '100'" do
        type[attribute] = val
        expect(type[attribute]).to eq(val.to_i)
      end
    end
  end
end
