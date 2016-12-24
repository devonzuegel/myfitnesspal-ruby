describe API::Builders::LastSyncInfo, :db do
  let(:user_id) { 2 }
  let(:date)    { DateTime.now }

  before do
    db[:users].insert(
      id:       user_id,
      username: 'dummy-username',
      password: 'dummy-password'
    )
  end

  let(:valid_ptrs) do
    {
      deleted_item:   '2561719350',
      diary_note:     '2016-10-30 21:02:18 UTC',
      exercise:       '1018692',
      exercise_entry: '2293971121',
      food:           '318556366',
      food_entry:     '5776792680',
      measurement:    '2016-10-30 21:01:43 UTC',
      user_property:  '2016-07-03 22:20:44 UTC',
      user_status:    '',
      water_entry:    '2014-12-25 01:20:59 UTC',
    }
  end

  let(:valid_input) do
    {
      id:      -1,
      user_id: user_id,
      ptrs:    valid_ptrs,
      date:    date,
    }
  end

  it 'has the expected VALIDATION_CLASS' do
    expect(described_class::VALIDATION_CLASS).to eql(API::Schema::LastSyncInfo::Creation)
  end

  it 'has the expected MAPPER_CLASS' do
    expect(described_class::MAPPER_CLASS).to eql(API::Mappers::LastSyncInfo)
  end

  it 'inherits from Base' do
    expect(described_class).to be < API::Builders::Base
  end

  it 'returns errors when given empty input' do
    expect(described_class.call({}, repository)).to eql(
      errors: {
        user_id:  ['is missing'],
        date:     ['is missing'],
        ptrs:     ['is missing'],
      }
    )
  end

  it 'returns the successfully created last_sync_info' do
    expect(described_class.call(valid_input, repository)).to eql(
      date:            date,
      id:              -1,
      serialized_ptrs: valid_ptrs.to_s,
      user_id:         user_id,
    )
  end

  it 'calls mapper#create' do
    expect_any_instance_of(described_class::MAPPER_CLASS).to receive(:create).once
    described_class.call(valid_input, repository)
  end

  it 'should require the expected serialized pointers' do
    expect(described_class.call(valid_input.merge(ptrs: {}), repository)).to eql(
       errors: {
        ptrs: {
          deleted_item:   ['is missing'],
          diary_note:     ['is missing'],
          exercise:       ['is missing'],
          exercise_entry: ['is missing'],
          food:           ['is missing'],
          food_entry:     ['is missing'],
          measurement:    ['is missing'],
          user_property:  ['is missing'],
          user_status:    ['is missing'],
          water_entry:    ['is missing'],
        },
      },
    )
  end
end
