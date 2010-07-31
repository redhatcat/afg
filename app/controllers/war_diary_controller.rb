class WarDiaryController < ApplicationController
  active_scaffold :war_diary do |config|
    config.list.per_page = 35
    config.list.page_links_window = 10
    list_columns = [
      :reportkey,
      :reportdate,
      :classification,
      :reporttype,
      :category,
      :unitname
    ]

    config.list.columns = list_columns
    config.actions.add :list_filter
    list_columns.each do |column|
      config.list_filter.add(:field, column)
    end
  end
end
