module Api
  module V1
    class KeywordsController < Api::V1::BaseController
      def import
        Keyword.import(params[:csv_file].tempfile)
        render json: { message: 'CSV Uploaded successfully.' }, status: :ok
      end
    end
  end
end
