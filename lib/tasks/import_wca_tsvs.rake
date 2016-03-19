require 'csv'

task import_wca_tsvs: :environment do
  CLASSES = [
    Continent,
    Country,
    Competition,
    Event,
    Format,
    Person,
    Round,
    Result,
    SingleRank,
    AverageRank
  ].freeze

  CLASSES.each(&:delete_all)

  options = {
    headers: true,
    header_converters: ->(s) { s.underscore.to_sym },
    col_sep: "\t",
    quote_char: "§"
  }

  CLASSES.each do |klass|
    imported = 0

    CSV.foreach(tsv_filename_for(klass), options) do |row|
      if row.key?(:subid) && row[:subid].to_i != 1
        puts "Skipping #{klass.name} #{row.inspect}"
        next
      end

      klass.create!(row.to_hash.except(:id, :subid)) do |x|
        x._id = row[:id] if row.key?(:id)
      end

      imported += 1
      puts "Imported #{imported} #{klass.name.pluralize}" if imported % 5000 == 0
    end

    puts "Imported #{imported} #{klass.name.pluralize}"
  end
end

def tsv_filename_for(klass)
  wca_collection_name_for = Hash.new { |_, k| k.name.pluralize }
  wca_collection_name_for.update(
    Person => "Persons",
    SingleRank => "RanksSingle",
    AverageRank => "RanksAverage"
  )
  Rails.root.join("vendor", "wca_export", "WCA_export_#{wca_collection_name_for[klass]}.tsv")
end
