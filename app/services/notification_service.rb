class NotificationService
  def self.notify(user, noti_type:, content:)
    notification = Notification.create!(
      user: user,
      noti_type: noti_type,
      content: content,
      read: false
    )
    # Gửi realtime qua ActionCable
    NotificationsChannel.broadcast_to(user, notification.as_json)
  end
end
