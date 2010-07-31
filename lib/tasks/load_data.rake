namespace :afg do
  task :load => :environment do
    require 'fastercsv'
    csvin = FasterCSV::open(File.join(RAILS_ROOT, 'afg.csv'))
    csvin.each do |row|
      WarDiary.create!(
        :reportkey => row[0],
        :reportdate => row[1],
        :reporttype => row[2],
        :category => row[3],
        :trackingnumber => row[4],
        :title => row[5],
        :summary => row[6],
        :region => row[7],
        :attackon => row[8],
        :complexattack => row[9],
        :reportingunit => row[10],
        :unitname => row[11],
        :typeofunit => row[12],
        :friendlywia => row[13],
        :friendlykia => row[14],
        :hostnationwia => row[15],
        :hostnationkia => row[16],
        :civilianwia => row[17],
        :civiliankia => row[18],
        :enemywia => row[19],
        :enemykia => row[20],
        :enemydetained => row[21],
        :mgrs => row[22],
        :latitude => row[23],
        :longitude => row[24],
        :originatorgroup => row[25],
        :updatedbygroup => row[26],
        :ccir => row[27],
        :sigact => row[28],
        :affiliation => row[29],
        :dcolor => row[30],
        :classification => row[31]
      )
      print '.'
    end
  end
end
