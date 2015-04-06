ActiveAdmin.register Keyword do
  permit_params :name

  collection_action :upload_csv do
  end

  collection_action :save_csv, method: :post do
    Keyword.import(params[:csv_file].tempfile)
    redirect_to admin_keywords_path, notice: 'CSV Uploaded successfully.'
  end

  action_item only: :index do
    link_to('Upload CSV', upload_csv_admin_keywords_path)
  end

  member_action :results do
  end

  index do
    id_column
    column :name
    actions defaults: true do |keyword|
      links = ''
      links += link_to 'Search Results', results_admin_keyword_path(keyword)
      links.html_safe
    end
  end

  filter :name

  form do |f|
    f.inputs "Keyword Details" do
      f.input :name
    end
    f.actions
  end
end
