class CsvController < ApplicationController
  def create
    file = params[:file]
    type = params[:type]

    tmp_path = Rails.root.join("tmp", "uploads", "#{Time.now.to_i}_#{file.original_filename}")
    FileUtils.mkdir_p(File.dirname(tmp_path))
    File.open(tmp_path, "wb") { |f|
      f.write(file.read)
    }

    ImportCsvJob.perform_later(tmp_path.to_s, current_user.id, type)
    render status: :no_content
  end
end
