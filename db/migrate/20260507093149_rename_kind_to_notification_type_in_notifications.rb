class RenameKindToNotificationTypeInNotifications < ActiveRecord::Migration[8.0]
  def change
    rename_column :notifications, :kind, :notification_type
  end
end
