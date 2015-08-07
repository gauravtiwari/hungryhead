class DropCspReportsTable < ActiveRecord::Migration
  def change
    drop_table :csp_reports
  end
end
