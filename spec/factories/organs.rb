# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organ do
    official true
    factory :tasa_arvotyoryhma do
      name  'Tasa-arvotyöryhmä'
      description {{fi:'Työryhmä varmistaa tasa-arvon toteutumisen', en:'Organ assures fulfilling of equality'}}
      _id   "4f6b1edf91bc2b3301010101"
      association :organization, :factory => :kemian_laitos
    end
    factory :kirjakerho do
      name  'Kirjakerho'
      _id   "4f6b1edf91bc2b3302010101"
      association :organization, :factory => :kirjasto
    end
  end
end
