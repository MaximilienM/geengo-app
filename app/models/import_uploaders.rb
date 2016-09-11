module ImportUploaders

  def import_uploaders

    Rails.logger.info "ImportUploaders : called for class : #{self.to_s}"

    c = Fog::AWS::Storage.new CarrierWave::Uploader::Base.fog_credentials
    d = c.directories.new :key => CarrierWave::Uploader::Base.fog_directory

    files_to_import = d.files.find_all {|f| f.key =~ %r(^imports/#{self.table_name}/.+?/.+)}

    Rails.logger.info "ImportUploaders : found #{files_to_import.size} files to import"

    files_grouped_by_record = files_to_import.group_by {|f| f.key =~%r(imports/#{self.table_name}/(.+?)/); $1}

    records = where(:name => files_grouped_by_record.keys)

    Rails.logger.info "ImportUploaders : found #{records.size} records corresponding to the directory names"

    # HACK : need abstraction here
    identifer = self == Employee ? :email : :name

    files_grouped_by_record = Hash[
      files_grouped_by_record.map do |record_identifier, files|
        record = records.detect {|i| i.send(identifer) == record_identifier}
        record ? [record, files] : nil
      end.compact
    ]

    files_grouped_by_record.each do |record, files|

      files.each do |file|
        begin
          uploader_name = File.basename(file.key).gsub(/\..+?$/, "")
          url = file.url Time.now + 10.minutes
          record.send "remote_#{uploader_name}_url=", url
          file.destroy
        rescue OpenURI::HTTPError
          Rails.logger.warn "Importer : could not process remote file #{url}. Retrying"
          retry
        end
      end

      record_dir = d.files.get "imports/#{self.table_name}/#{record.send(identifer)}/"
      Rails.logger.info "ImportUploaders : about to destroy directory : #{record_dir.key}"
      record_dir.destroy

      record.save

    end
  end


end