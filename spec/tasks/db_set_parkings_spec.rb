require 'rails_helper'
require 'rake'

RSpec.describe 'db_set_parkings:set_parkings' do
  it 'パーキングの読み込みが全件分行われるか' do
    Rake.application.rake_require 'tasks/db_set_parkings'
    Rake::Task.define_task(:environment)
    task = Rake::Task['db_set_parkings:set_parkings']

    expect { task.invoke }.to change { Parking.count }.by(586)
  end
end