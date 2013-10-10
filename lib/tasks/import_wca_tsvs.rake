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
    quote_char: "|"
  }

  CLASSES.each do |klass|
    imported = 0

    csv = CSV.open(tsv_filename_for(klass), options)
    csv.each_slice(5000) do |rows|
      rows.delete_if do |row|
        if row.key?(:subid) && row[:subid].to_i != 1
          puts "Skipping #{klass.name} #{row.inspect}"
          true
        end
      end

      attributes = rows.map do |row|
        row.to_hash.except(:id, :subid).tap do |h|
          h.update(_id: row[:id]) if row.key?(:id)
        end
      end
      klass.collection.insert(attributes)

      imported += rows.size
      puts "Imported #{imported} #{klass.name.pluralize}"
    end
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
