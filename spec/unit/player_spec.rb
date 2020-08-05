require 'securerandom'
require_relative '../../lib/player'
require_relative '../../lib/unit'

describe Player do
  subject(:player) { described_class.new('Chinese Empire', [unit_1, unit_3, unit_2]) }

  let(:unit_1) { instance_double(Unit, id: 'asdf1234', strength_points: 10) }
  let(:unit_2) { instance_double(Unit, id: 'qwer1234', strength_points: 20) }
  let(:unit_3) { instance_double(Unit, id: 'zxcv1234', strength_points: 30) }

  describe '#initialize' do
    before do
      allow(SecureRandom).to receive(:uuid).and_return('abc123')
    end

    it 'assigns a random ui, sets civilization and gold, and sorts units' do
      expect(subject.id).to eq('abc123')
      expect(subject.civilization).to eq('Chinese Empire')
      expect(subject.gold).to eq(0)
      expect(subject.units).to eq([unit_1, unit_2, unit_3])
      expect(subject.units_by_id).to eq(
        unit_1.id => unit_1,
        unit_2.id => unit_2,
        unit_3.id => unit_3
      )
    end
  end

  describe '#strength_points' do
    it 'is equal to the sum of the units\'s strengh points' do
      expect(subject.strength_points).to eq(60)
    end
  end

  describe '#delete_unit' do
    it 'deletes the unit from all storage structures' do
      player.delete_unit(unit_2)
      expect(player.units).to eq([unit_1, unit_3])
      expect(player.units_by_id).to eq(unit_1.id => unit_1, unit_3.id => unit_3)
    end
  end

  describe '#update_unit' do
    it 'replaces the unit that has the same id' do
      new_unit = instance_double(Unit, id: 'qwer1234')
      player.update_unit(new_unit)
      expect(player.units).to eq([unit_1, new_unit, unit_3])
      expect(player.units_by_id).to eq(unit_1.id => unit_1, new_unit.id => new_unit, unit_3.id => unit_3)
    end
  end
end
