require "csv"

class ImportCsvJob < ApplicationJob
  queue_as :imports

  def perform(file_path, user_id, type)
    user ||= User.find(user_id)
    model = type.constantize
    valid_columns = model.column_names.map(&:to_sym)

    CSV.foreach(file_path, headers: true) do |row|
      begin
        attrs = row.to_h.transform_keys do |k|
          k.to_s.strip.downcase.gsub(/\A\uFEFF/, "").to_sym
        end

        filtered_attrs = attrs.slice(*valid_columns)
        model.create!(filtered_attrs)
      rescue => e
        Rails.logger.error("Import lỗi: #{e.message}")
      end
    end
    # Dọn file tạm sau khi xong
    File.delete(file_path) if File.exist?(file_path)

    # ✅ Đợi một chút để đảm bảo job hoàn tất
    sleep(0.5)
    
    # Gửi notification thành công
    NotificationService.notify(
      user,
      noti_type: "success",
      content: "Nhập CSV #{File.basename(file_path)} thành công"
    )
  end
end
